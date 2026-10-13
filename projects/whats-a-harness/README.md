# What's a Harness

A 2:37 performance video for a song about an agent harness. Claudia sits at a computer for the open, gets up and walks, dances on the choruses and the drop, and sits again only when the words turn to shipping a demo. She smiles. She does not talk. Short lines from the song are drawn on the picture.

Approved cut:

<a href="https://hgardneriv-slopcore.vercel.app/projects/whats-a-harness/whats-a-harness-remastered.mp4" target="_blank" rel="noopener"><img src="thumbs/whats-a-harness-remastered.jpg" alt="What's a Harness, remastered" width="640"></a>

<a href="https://hgardneriv-slopcore.vercel.app/projects/whats-a-harness/whats-a-harness-remastered.mp4" target="_blank" rel="noopener">whats-a-harness-remastered.mp4</a>

Higgsfield original: <a href="https://hgardneriv-slopcore.vercel.app/projects/whats-a-harness/whats-a-harness.mp4" target="_blank" rel="noopener"><img src="thumbs/whats-a-harness.jpg" alt="What's a Harness" width="320"></a> [whats-a-harness.mp4](whats-a-harness.mp4)

Grok Imagine remake, same locked song. Pass 1 sits and types on the verses and dances the choruses and drops. Mouth closed. The soundtrack is the locked wav, not generated audio.

<a href="https://hgardneriv-slopcore.vercel.app/projects/whats-a-harness/grok-imagine-whats-a-harness.mp4" target="_blank" rel="noopener"><img src="thumbs/grok-imagine-whats-a-harness.jpg" alt="Grok Imagine pass 1" width="320"></a> <a href="https://hgardneriv-slopcore.vercel.app/projects/whats-a-harness/grok-imagine-whats-a-harness.mp4" target="_blank" rel="noopener">grok-imagine-whats-a-harness.mp4</a>

<a href="https://hgardneriv-slopcore.vercel.app/projects/whats-a-harness/grok-imagine-whats-a-harness-1.mp4" target="_blank" rel="noopener"><img src="thumbs/grok-imagine-whats-a-harness-1.jpg" alt="Grok Imagine pass 1, alternate filename" width="320"></a> <a href="https://hgardneriv-slopcore.vercel.app/projects/whats-a-harness/grok-imagine-whats-a-harness-1.mp4" target="_blank" rel="noopener">Pass 1</a> is the same cut with `-1` in the name.

<a href="https://hgardneriv-slopcore.vercel.app/projects/whats-a-harness/grok-imagine-whats-a-harness-2.mp4" target="_blank" rel="noopener"><img src="thumbs/grok-imagine-whats-a-harness-2.jpg" alt="Grok Imagine pass 2" width="320"></a> <a href="https://hgardneriv-slopcore.vercel.app/projects/whats-a-harness/grok-imagine-whats-a-harness-2.mp4" target="_blank" rel="noopener">Pass 2</a> keeps the seated verses and replaces the dance with clothed club choreography.

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

`grok-imagine-video-1.5` is $0.08 a second at 480p plus $0.01 per image input. That is the rate card, not a bill.
