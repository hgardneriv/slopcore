---
name: claudia-slopcore
description: >-
  Make a Claudia slopcore clip whose mouth matches a song. The required path
  is a Suno song locked as a wav, stills approved, then Higgsfield Seedance
  2.5 one phrase at a time, remuxed so the song plays and the lips can be
  judged. Use when the user asks for Claudia slopcore, a Claudia music video,
  Suno-to-video lip sync, or this skill.
---

# Claudia slopcore

Harry rejected a paid lip-sync pass on cost. The cut that is in progress does not try to make her talk. She smiles and flirts. Verses stay at the computer. Choruses and drops are dance. Important words are graphics in the edit. The song is still the soundtrack.

Follow this order. Do not skip ahead to paid motion.

Claudia is an open character by anabology. Canon, song practice, and motion practice:

- https://claudia.gallery/claudia.md
- https://claudia.gallery/wiki/song/
- https://claudia.gallery/wiki/seedance/
- https://claudia.gallery/use/

When you post the work, use this credit line: "Claudia is an open character by anabology (claudia.gallery)". Release it under the user's name. Do not put feat. Claudia in the artist field. Say the work is AI.

## Canon

She is a 28-year-old woman with a grown angular face, pale skin, light freckles, a glossy black blunt jaw-length bob, heavy bangs, one clay-orange streak, a small clay-orange eight-pointed star clip, and a thin headset mic. She is an adult. Never use the word young. One streak. Plates are photographic, with no text in the image. Mouth closed on stills.

Paste this into every still and motion prompt:

```text
a 28-year-old Caucasian American woman with a grown-up angular face, defined cheekbones and a strong jawline, pale skin and light freckles, a glossy black blunt jaw-length bob with heavy straight bangs and one clay-orange streak through the bangs, a small flat clay-orange eight-pointed star hair clip, a thin headset microphone at her cheek
```

## Wardrobe

Wardrobe is an input, not a fixed costume. Ask the user what she wears, and keep that look once they approve it.

One approved look, which the user can replace: a fitted black top, a short skirt, tall combat boots, and thigh-high stockings that stop short of the hem.

## 1. Lock the song

When the user wants a new song, write it on Suno, then lock the wav they download. That locked file is the soundtrack the mouth has to match. Do not upload a locked vocal or riff back into a music model when the user needs those samples kept.

For a Suno custom song, fill title, style, and lyrics. Match the voice to Claudia: a woman, spoken verses that can rise into the chorus, not a male lead and not "feat. Claudia" in the artist field. Credit on release: "Claudia is an open character by anabology (claudia.gallery)". Say the work is AI.

Slice a phrase with ffmpeg. Times are seconds on the locked wav:

```bash
ffmpeg -y -i SONG.wav \
  -af atrim=start=START:end=END,asetpts=PTS-STARTPTS \
  -ar 48000 -ac 2 -c:a pcm_s16le slice.wav
```

One phrase per slice. Keep the slice between 4 and 8 seconds, and do not cut in the middle of a word.

## 2. Stills, then a yes

Make the stills before any paid motion. Use Grok Imagine when `XAI_API_KEY` is set, or whatever image tool you have. 16:9, photographic, mouth closed, no letters, no logos, no captions. Keep the single clay-orange streak and the star clip.

Show the stills and wait. The user approves the look before you spend on motion. Silence is not a yes.

Do not print `XAI_API_KEY`. Do not write it into a file.

## 3. Motion

Motion is Seedance 2.5 on Higgsfield, reference-to-video, 480p, 16:9, one phrase per clip, 4–8 seconds.

Read the secret from the environment name `higgsfield_api_key` and pass it to the Higgsfield client as `HF_KEY`. Never print `higgsfield_api_key` or `HF_KEY`. Never put either value on a command line, in a file, or in a log.

```python
import os
import higgsfield_client
from higgsfield_client.http.client import SyncClient

os.environ["HF_KEY"] = os.environ["higgsfield_api_key"]
image_url = higgsfield_client.upload_file(plate_path)
audio_url = higgsfield_client.upload_file(wav_slice_path)
controller = SyncClient(timeout=90.0).submit(
    "bytedance/seedance-2.5/reference-to-video",
    {
        "prompt": prompt,
        "duration": duration_seconds,
        "resolution": "480p",
        "aspect_ratio": "16:9",
        "image_urls": [image_url],
        "audio_urls": [audio_url],
        "generate_audio": False,
    },
)
```

`duration_seconds` is a whole number from 4 to 8 that covers the slice. The image is the approved plate. The audio URL is the wav slice, so the mouth has something to follow. The delivered soundtrack is still the remux in the next step, not the generator file.

Quote the phrase as what the audio contains. Do not wrap the words in braces. Braces make Seedance re-sing them. Say that the soundtrack is the given audio, copied, with nothing added. Say no subtitles, captions, titles, logos, or other on-screen text.

Tell the user the price before you submit. From a Higgsfield account estimate, 16:9, no video input: about $0.21 a second at 480p, $0.46 at 720p, and $1.14 at 1080p. An extend bills the input and the new seconds together. Stay at 480p until the user likes the take. These figures are a ballpark. Read the account estimate again before you change resolution or extend.

## 4. One clip at a time

Submit one clip. Wait until it is done. Play the remux. If that clip is wrong, redo only that clip. Do not regenerate the set.

## 5. Remux the song

Every finished clip includes the song, loud enough to hear. A silent picture is not finished.

The raw generator file is not the deliverable. A stream-copy mux, and a 48 kHz AAC track with a priming edit list, stayed silent in a player's preview. Deliver a re-encoded file: H.264 yuv420p, 24 fps, video timescale 24000, AAC stereo 44.1 kHz, `movflags +faststart`, edit lists off.

`scripts/mux-song.sh` does that. Arguments are the silent generator video, the wav slice, and the output mp4:

```bash
skills/claudia-slopcore/scripts/mux-song.sh silent.mp4 slice.wav clip.mp4
```

The script maps video only from the generator file and audio only from the wav. It re-encodes, then measures the output with ffmpeg `volumedetect`. The check fails when `mean_volume` is missing, is `-inf`, or is at or below **-50 dB**. That line is near silence. Digital silence lands near -91 dB. A slice loud enough to hear sits above -50 dB. If the check fails, the script writes nothing and exits 1. Do not hand the user a file that failed this check.

## 6. Words on screen

On-screen words are an edit overlay. Draw them in the edit. Do not ask Seedance to render lyrics, titles, or captions.

## Lip sync

This is the step the skill has to perfect. Judge every take with the song audible. The user is checking whether the mouth hits the words they already hear.

Two jobs. Seedance 2.5 makes the body from the approved still and the wav slice. It does not lock phonemes. When the body is acceptable and the mouth is late, do not generate that line again from a still. Lock the mouth in a second pass on that finished clip.

The mouth pass is Sync Lipsync 3 in Higgsfield Lipsync Studio: upload the accepted clip, upload the same wav slice, pick Sync Lipsync 3. Kling Lipsync is the fallback if that pass smears the body. Those models are documented in Lipsync Studio. They are not in the public video API catalog, so do not invent an endpoint and do not route the mouth back through Seedance. Claudia stays the approved stills. She does not need a Soul ID.

Word-level alignment of the locked wav to the known lyrics is how a slice is cut between words, and how you see which half drifted. A loudness meter does not name the words.

What the performance pass has shown:

- Start the slice just before a sigh or breath, and name it in the prompt: a soft breath out, lips part, shoulders drop, on the sigh. That put the sigh in sync.
- Quote the phrase as speech the audio already contains. Prompt the body. Keep the mouth visible and uncovered.
- If the lag grows through the line, do not slide the whole soundtrack. Keep the closer take. On What's a Harness, a new clip from a still of only the late half was a big step backwards.
- Redo a bad slice only when the new take can beat the closer one. Do not regenerate the set to chase one late phrase.
- After the mouth pass, remux the original wav. The mouth pass may change pixels. It may not replace the vocal.

## Assemble a cut

Harry builds a cut a few ranges at a time and iterates. He names sources in creation order. He refers to them as video 1, video 2, video 3. A new pass gets the next number.

For What's a Harness right now:

- Video 1 is the Higgsfield original `projects/whats-a-harness/whats-a-harness.mp4`.
- Video 2 is the first Grok Imagine pass `projects/whats-a-harness/grok-imagine-whats-a-harness-1.mp4`.
- Video 3 is the harder dance pass `projects/whats-a-harness/grok-imagine-whats-a-harness-2.mp4`.

Each instruction is a video number plus a time range. Assemble those ranges in the order he gives them. Keep earlier assembly files. Number the new one `whats-a-harness-assembly-N.mp4`. Write it in `projects/whats-a-harness/` and in the store under `media/harness-assembly/` (`/cursor/stores/bc-936398b9-ab19-4a31-8396-7c5e68d56474/media/harness-assembly/`).

Do not use audio from the source clips. The picture ranges will not line up with the song. Lay the locked master `/cursor/stores/bc-936398b9-ab19-4a31-8396-7c5e68d56474/media/whats-a-harness.wav` from 0:00 continuously under the whole assembly.

A short crossfade, about 0.4s, when the body position jumps between clips. A hard cut when the join already lands on a beat.

Every preview clip freezes the last frame and plays the next 10 seconds of the locked master song, including a locked clip like New Clip 1. That hold is how he picks the next piece. Do not deliver a preview that stops the audio when the picture stops.

Record the picture-out time, the frame where the moving video ends. That time is the stitch point.

When clips are joined into a sequence, cut at each picture-out. Do not include the frozen hold, and do not leave a stretch of audio with a dead picture, in the stitched video. The hold exists only on the preview clip.

When the duration changes, write the delivered clip to a new filename, so a player does not reuse a shorter cut.

Put every range on one common frame size before the join. Encode H.264 yuv420p, 24 fps, AAC stereo 44100 Hz, `movflags +faststart`, `use_editlist 0`.

Later moves he already named. Do these only when he asks:

- Cut one dance sequence for the drops and choruses and loop it on both drops.
- He may add a few more clips on the ending.
- He may want the dance loop faster.
- He may want zoom variation during the loop.

Mouth stays closed. No new generation during an assembly pass.
