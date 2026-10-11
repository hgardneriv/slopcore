#!/usr/bin/env bash
# mux-song.sh SILENT_VIDEO WAV_SLICE OUTPUT_MP4
#
# Playable remux of a generator clip with the locked song.
# A stream-copy mux stayed silent in a player's preview, so this always
# re-encodes: H.264 yuv420p, AAC stereo 44.1 kHz, movflags +faststart,
# edit lists off. A 48 kHz track with an AAC priming edit list played
# as picture only.
#
# Arguments:
#   SILENT_VIDEO  generator file. Video is taken from this file. Its audio is not.
#   WAV_SLICE     phrase cut from the locked song.
#   OUTPUT_MP4    deliverable written only after the loudness check passes.
#
# Silence check (ffmpeg volumedetect on the output audio):
#   Read mean_volume. Fail if it is missing, -inf, or at or below -50 dB.
#   -50 dB is near silence. Digital silence measures about -91 dB.
#   A song slice loud enough to hear sits above -50 dB.
#   On failure the output is removed and the script exits 1.
#
# Exit 0 on a hearable file, 1 on silence or encode failure, 2 on bad usage.

set -euo pipefail

THRESHOLD_DB="-50"

if [[ $# -ne 3 ]]; then
  echo "usage: mux-song.sh SILENT_VIDEO WAV_SLICE OUTPUT_MP4" >&2
  exit 2
fi

silent=$1
wav=$2
out=$3

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "mux-song: ffmpeg is required" >&2
  exit 1
fi

if [[ ! -f "$silent" ]]; then
  echo "mux-song: missing silent video: $silent" >&2
  exit 2
fi
if [[ ! -f "$wav" ]]; then
  echo "mux-song: missing wav slice: $wav" >&2
  exit 2
fi

out_dir=$(dirname -- "$out")
mkdir -p -- "$out_dir"

tmp=$(mktemp --suffix=.mp4)
cleanup() {
  rm -f -- "$tmp"
}
trap cleanup EXIT

ffmpeg -y -hide_banner -loglevel error \
  -i "$silent" \
  -i "$wav" \
  -map 0:v:0 \
  -map 1:a:0 \
  -c:v libx264 \
  -pix_fmt yuv420p \
  -r 24 \
  -video_track_timescale 24000 \
  -preset medium \
  -crf 18 \
  -c:a aac \
  -b:a 192k \
  -ac 2 \
  -ar 44100 \
  -movflags +faststart \
  -use_editlist 0 \
  -shortest \
  "$tmp"

# volumedetect prints mean_volume to stderr, for example: mean_volume: -23.4 dB
detect=$(ffmpeg -hide_banner -i "$tmp" -map 0:a:0 -af volumedetect -f null - 2>&1 || true)
mean=$(printf '%s\n' "$detect" | sed -n 's/.*mean_volume:[[:space:]]*\([-+0-9.inf][-+0-9.inf]*\)[[:space:]]*dB.*/\1/p' | head -n 1)

fail_silent() {
  echo "mux-song: $1" >&2
  echo "mux-song: silence check failed (mean_volume at or below ${THRESHOLD_DB} dB is near silence). No deliverable written." >&2
  exit 1
}

if [[ -z "${mean}" || "${mean}" == "-inf" || "${mean}" == "inf" || "${mean}" == "+inf" ]]; then
  fail_silent "no usable mean_volume (got '${mean:-missing}')."
fi

# Exit 0 from awk when mean_volume is at or below the near-silence line.
if awk -v mean="$mean" -v limit="$THRESHOLD_DB" 'BEGIN { exit (mean+0 <= limit+0) ? 0 : 1 }'; then
  fail_silent "output mean_volume is ${mean} dB."
fi

mv -f -- "$tmp" "$out"
trap - EXIT
echo "mux-song: wrote ${out} (mean_volume ${mean} dB)"
