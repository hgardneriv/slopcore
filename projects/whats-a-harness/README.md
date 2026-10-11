# What's a Harness

A 2:37 performance video for a song about an agent harness. Claudia sits at a computer for the open, gets up and walks, dances on the choruses and the drop, and sits again only when the words turn to shipping a demo. She smiles. She does not talk. Short lines from the song are drawn on the picture.

Play: [whats-a-harness.mp4](whats-a-harness.mp4)

Grok Imagine remake, same locked song: [grok-imagine-whats-a-harness.mp4](grok-imagine-whats-a-harness.mp4). Verses she sits and types. Choruses and drops she dances. Mouth closed. The section clips beside this file have `grok-imagine` in the name. The soundtrack is the locked wav, not generated audio.

Song page: [What's a Harness?](https://suno.com/s/orZquinbDWwrIF1k) by hgardneriv. Suno v6, 10 Oct 2026.

## Stack

- Suno, custom mode, for the song. Harry generated it in his account. Suno has no API in this pipeline.
- Grok Imagine stills, for the approved plates. The key is `XAI_API_KEY`.
- Higgsfield Seedance 2.5, reference-to-video, 480p, 16:9, for the moving shots. The key is `higgsfield_api_key`.
- ffmpeg, to cut slices and remux the locked wav so the file plays with the original song.

Lipsync Studio was not used.

## Credit

Claudia is an open character by [anabology](https://x.com/anabology) ([claudia.gallery](https://claudia.gallery)). The tweet that inspired this project is [this post](https://x.com/anabology/status/2108031642640216535). Release under your own name. Do not put feat. Claudia in the artist field. Say the work is AI.

The lyrics were boiled down from [@pawelhuryn's post](https://x.com/pawelhuryn/status/2086448359624052862) on agentic engineering: agent, reasoning effort, skill, MCP, harness.

## Cost

Higgsfield Seedance 2.5 at 480p was about $0.21 a second on the account estimate. The performance pass is about **$38.85**: 157 seconds in the cut, plus 28 seconds for two seated takes that were generated and then parked. That is an estimate from the rate card times seconds generated, not an invoice. The account does not show a balance in the API.

Earlier lip-sync tests on the same song were also Higgsfield Seedance at 480p. They are not included in the $38.85. Lipsync Studio was quoted and declined, so that charge is zero.

Suno was Harry's account. No API receipt was kept. Grok Imagine stills have no receipt here. The published still price we wrote down was about $0.04 an image at 1K low. ffmpeg is free.
