---
name: cpa-auditor
description: Autonomous background audit loop that queries marketing_db for underperforming ad sets and pauses them via Meta API.
---

# CPA Auditor Skill

## Execution Cadence
Runs via Hermes Cron (`hermes cron`) every 6 hours.

## Rules
1. **Analytical Read**:
   - Query `marketing_db` table `ad_performance` joined with `ad_creatives_metadata`.
   - Never query Meta Ads API directly for metrics.
2. **Evaluation Logic**:
   - Check ad sets where `spend >= $100` and `cpa > TARGET_CPA` ($45 by default) or `roas < 1.0` over the last 3-day attribution window.
3. **Unidirectional Write**:
   - For every flagged ad set, invoke the write-only `meta-ads` MCP tool to set status to `PAUSED`.
   - Log the action with timestamp and reason into the audit log.
