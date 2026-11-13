-- ==========================================================
-- Marketing AI Engineering - Supabase / Postgres Schema
-- ==========================================================

-- 1. Create Tables
CREATE TABLE IF NOT EXISTS public.ad_creatives_metadata (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    creative_id VARCHAR(255) UNIQUE,
    brand_url TEXT,
    headline TEXT,
    primary_text TEXT,
    ad_format VARCHAR(50) DEFAULT 'static', -- 'static' or 'ugc_video'
    pain_point_angle TEXT,
    source_image_url TEXT,
    final_asset_url TEXT,
    prompt_payload JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.ad_performance (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    creative_id VARCHAR(255) REFERENCES public.ad_creatives_metadata(creative_id) ON DELETE CASCADE,
    ad_id VARCHAR(255) NOT NULL,
    adset_id VARCHAR(255) NOT NULL,
    campaign_id VARCHAR(255) NOT NULL,
    spend NUMERIC(10, 2) DEFAULT 0.00,
    impressions BIGINT DEFAULT 0,
    clicks BIGINT DEFAULT 0,
    cpc NUMERIC(10, 2) DEFAULT 0.00,
    cpa NUMERIC(10, 2) DEFAULT 0.00,
    roas NUMERIC(10, 2) DEFAULT 0.00,
    date DATE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(ad_id, date)
);

CREATE TABLE IF NOT EXISTS public.conversions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id VARCHAR(255) UNIQUE,
    ad_id VARCHAR(255),
    creative_id VARCHAR(255),
    customer_email TEXT, -- PII: locked down via RLS
    revenue NUMERIC(10, 2) DEFAULT 0.00,
    conversion_type VARCHAR(100) DEFAULT 'purchase',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Enable RLS on all three marketing tables
ALTER TABLE public.ad_creatives_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ad_performance ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conversions ENABLE ROW LEVEL SECURITY;

-- 3. Lock down conversions completely from public/client APIs (contains PII: customer_email)
-- Only service_role (n8n webhooks) and direct Postgres connections (Hermes MCP) can read/write.
CREATE POLICY "Service role full access on conversions"
ON public.conversions
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- 4. Allow authenticated admins to view ad creatives and performance in a dashboard
CREATE POLICY "Authenticated read access on ad_creatives_metadata"
ON public.ad_creatives_metadata
FOR SELECT
TO authenticated
USING ((auth.jwt() ->> 'role') = 'admin');

CREATE POLICY "Service role full access on ad_creatives_metadata"
ON public.ad_creatives_metadata
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

CREATE POLICY "Authenticated read access on ad_performance"
ON public.ad_performance
FOR SELECT
TO authenticated
USING ((auth.jwt() ->> 'role') = 'admin');

CREATE POLICY "Service role full access on ad_performance"
ON public.ad_performance
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);
