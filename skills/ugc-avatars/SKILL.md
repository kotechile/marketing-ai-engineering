---
name: ugc-avatars
description: Produces sub-$5 lip-synced AI UGC avatar video ads with voice cloning, script alignment, and motion graphics handoff.
---

# UGC Avatars Skill

## Objectives
Generate hyper-realistic AI User-Generated Content (UGC) ad creative at sub-$5 per video instead of traditional $50+ rendering costs.

## Workflow

### 1. Direct-Response Scriptwriting (30-45s)
- **Hook (0-3s)**: Stop the scroll with a polarizing question or pattern interrupt.
- **Agitation (3-15s)**: Validate the specific pain point with relatable emotion.
- **Solution (15-30s)**: Introduce the product naturally without sounding like an infomercial.
- **Call-to-Action (30-45s)**: Clear, single directive.

### 2. Audio Ad Read (Voice Clone)
- Send clean script to ElevenLabs / Fal.ai voice clone.
- Output raw `.mp3`.

### 3. Low-Resolution Avatar Lip-Sync
- Pair a remixed real human creator source image + the `.mp3` audio + script.
- Send to Fal LiveAvatar / Seed Dance at **480p resolution** (keeps unit generation cost around ~$4.00 - $4.75).

### 4. Word-by-Word Transcript & Alignment
- Extract word-level timestamps using Whisper.
- Detect any mispronounced terms and patch timestamps.

### 5. Laptop Pipeline Handoff
- Hand off raw 480p video + transcript JSON to the laptop `video-engine` for:
  - FFmpeg Lanczos 1080p upscaling & smartphone camera texture.
  - Remotion / Tesseract kinetic text overlays & motion graphics.
  - Creative Director Vision QA gate.
