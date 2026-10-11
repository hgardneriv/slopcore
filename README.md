# slopcore

A workspace for AI-generated music videos in the SLOPCORE style, inspired by [@anabology](https://x.com/anabology) and the character Claudia.

The spark was [this post](https://x.com/anabology/status/2108031642640216535): Claudia's soul, downloadable, with the pieces for making A-tier slopcore gathered in one place — an MCP server, an agent skill, a wiki, and character sheets. The invitation at the end was to go make your own.

This repo is that attempt. It started the morning of October 10, 2026, with nothing but a love for the style. The long-term goal is a record of the whole trip from 0 to N: how the idea took shape across iterations, what the tools actually did, and what a finished SLOPCORE music video looks like when the music is original too.

Finished pieces live in `projects/`, one folder each. The next piece gets its own folder and a README. Shared workflow lives in `skills/`.

## Play

- [What's a Harness](projects/whats-a-harness/whats-a-harness.mp4) — 2:37. Claudia, a Suno song, Higgsfield motion, words on screen. [Notes](projects/whats-a-harness/README.md).
- [Swordplay](projects/swordplay/swordplay-hero-3.mp4) — Grok Imagine sword fight on the guitar riff. Day 1 also kept [swordplay.mp4](projects/swordplay/swordplay.mp4) and [swordplay-full.mp4](projects/swordplay/swordplay-full.mp4). [Notes](projects/swordplay/README.md).

## Goal

Learn how to generate SLOPCORE-style music videos in the vein of anabology's Claudia work, scored with original AI music, and write down the path as it happens.

## Tools

- **Cursor** — the workspace, and the place the iterations happen
- **Grok Imagine** — image and video generation
- **[Suno](https://suno.com/)** — original AI music
- **[Higgsfield](https://open.higgsfield.ai/)** — Seedance video via API

## Skills

[skills/claudia-slopcore/SKILL.md](skills/claudia-slopcore/SKILL.md) is the workflow for the next Claudia piece: lock the wav, approve stills, generate Seedance one section at a time, and remux with [skills/claudia-slopcore/scripts/mux-song.sh](skills/claudia-slopcore/scripts/mux-song.sh). The script needs ffmpeg.

Do not paste API keys into the repo or into chat.

- `XAI_API_KEY` for Grok Imagine
- `higgsfield_api_key` for Seedance on Higgsfield

## Credit

Claudia is an open character by [anabology](https://x.com/anabology) ([claudia.gallery](https://claudia.gallery)). The tweet that inspired this project is [this post](https://x.com/anabology/status/2108031642640216535). Release under your own name. Do not put feat. Claudia in the artist field. Say the work is AI.
