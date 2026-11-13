---
name: static-ads
description: Scrapes brand URL, extracts brand design tokens, mines pain points, formulates 5 Ogilvy-style direct response angles, and generates static ads.
---

# Static Ads Skill

## Objectives
Automate the end-to-end production of high-converting static image ads for Meta Ads.

## Workflow

### 1. Brand Extraction
- Use Puppeteer/Scraper to fetch the target brand URL.
- Extract primary brand colors (HEX codes), secondary accents, typography, and core positioning.

### 2. Pain-Point Research
- Scrape Reddit, reviews, or social conversations related to the product category.
- Identify the top 5 desired outcomes and visceral user frustrations.

### 3. Headline & Copy Ideation
Formulate 5 direct-response angles using proven copywriting archetypes:
1. **The Call-Out**: *"Stop guessing which idea to build."*
2. **Authority / Science**: *"Built on science, backed by doctors."*
3. **Problem Inversion**: *"Your chat GPT ideas are generic."*
4. **The Comparison**: *"Pay retail, not resale."*
5. **The Proof / Metric**: *"1,948 ideas worth building."*

### 4. Image Generation
- Invoke image generation endpoint (Fal.ai FLUX / OpenAI Image 2.5).
- Structure prompts to preserve clean negative space for typography and adhere to extracted brand colors.

### 5. Staging & Database Logging
- Write generation metadata (creative_id, prompt, angle, brand_url) into `ad_creatives_metadata`.
- Stage assets for ad campaign upload.
