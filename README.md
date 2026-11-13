# Marketing AI Engineering Petri Dish

An autonomous, code-driven marketing engineering ecosystem powered by **Hermes Agent**, **Supabase**, **DeepSeek**, and generative media toolchains.

Based on the marketing engineering architecture popularized by Greg Isenberg & Cody Schneider.

---

## Architecture Breakdown

### 1. Cloud VPS (The Conductor & Analytics Brain)
- **Hermes Agent**: Runs natively as root on the VPS, managing skills, background audits, and MCP tools.
- **Supabase / PostgreSQL**: Stores ad metadata, daily ad performance, and downstream conversion telemetry.
- **Decoupled Telemetry**:
  - High-frequency analytical reads execute entirely against the local Supabase/Postgres database.
  - Meta Ads API interactions are strictly unidirectional writes (campaign staging, pausing underperforming ad sets).
- **Background Cron**: Every 6 hours, Hermes audits CPA and pauses losing ad sets automatically.

### 2. Local Laptop (Video Production Studio)
- **Sub-$5 Lip-Sync Pipeline**: Generates 480p avatar videos using Fal.ai / ElevenLabs, upscales to 1080p via FFmpeg, and applies natural mobile camera grain.
- **Kinetic Motion Graphics**: Uses Remotion / Tesseract to overlay dynamic word-by-word animated captions and CTAs.
- **Vision QA Gate**: Multi-modal vision eval audits generated videos frame-by-frame before ad account upload.

---

## Repository Structure

```text
├── db/
│   ├── schema.sql                   # Supabase tables and RLS security policies
│   └── views/
│       └── creative_attribution.sql # Full-funnel LTV & CPA view
├── skills/                          # Hermes custom skill definitions
│   ├── static-ads/                  # Static ad generation from brand scraping
│   ├── ugc-avatars/                 # Sub-$5 UGC video generation workflow
│   └── cpa-auditor/                 # Scheduled autonomous budget optimization
├── video-engine/                    # Laptop-side video processing
│   └── scripts/
│       ├── upscale_and_enhance.sh   # FFmpeg Lanczos 480p -> 1080p + mobile sensor grain
│       └── pipeline.py              # Video workflow runner
├── swipe-warehouse/                 # Direct-response swipe files & hook formulas
├── workflows/                       # n8n & Airbyte ingestion pipelines
└── .env.example
```

---

## Quick Start

### 1. Database Setup
Execute `db/schema.sql` and `db/views/creative_attribution.sql` in your Supabase SQL Editor.

### 2. Link Skills to Hermes on VPS
```bash
ln -sf /root/marketing-ai-engineering/skills/* /root/.hermes/skills/
```

### 3. Run First Pipeline Command via Hermes
```bash
hermes chat -q "Run static-ads for https://yourbrand.com, extract brand palette, draft 5 pain points, and generate creatives."
```
