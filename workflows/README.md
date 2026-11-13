# Telemetry Ingestion Workflows

This directory holds workflow definitions (n8n JSON exports or Airbyte connector configurations) responsible for streaming attribution data into your Supabase / Postgres database.

## Ingestion Pipelines
1. **Meta Ads -> Supabase**: Syncs daily spend, impressions, clicks, CPC, and ad IDs hourly.
2. **PostHog / GA4 -> Supabase**: Streams conversion and signup events.
3. **Stripe -> Supabase**: Ingests subscription, invoice, and payment events for full Customer Lifetime Value (LTV) attribution.
