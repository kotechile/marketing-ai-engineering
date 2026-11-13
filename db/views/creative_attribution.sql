-- View: Unified Creative Attribution & LTV Metrics
-- Joins ad creatives, spend, and downstream conversion revenue for full-funnel analysis.
CREATE OR REPLACE VIEW public.view_creative_attribution AS
SELECT 
    c.creative_id,
    c.headline,
    c.ad_format,
    c.pain_point_angle,
    COALESCE(SUM(p.spend), 0) AS total_spend,
    COALESCE(SUM(p.clicks), 0) AS total_clicks,
    COALESCE(COUNT(DISTINCT cv.id), 0) AS total_conversions,
    COALESCE(SUM(cv.revenue), 0) AS total_revenue,
    CASE 
        WHEN COALESCE(COUNT(DISTINCT cv.id), 0) > 0 
        THEN ROUND(COALESCE(SUM(p.spend), 0) / COUNT(DISTINCT cv.id), 2)
        ELSE NULL 
    END AS blended_cpa,
    CASE 
        WHEN COALESCE(SUM(p.spend), 0) > 0 
        THEN ROUND(COALESCE(SUM(cv.revenue), 0) / SUM(p.spend), 2)
        ELSE NULL 
    END AS blended_roas
FROM public.ad_creatives_metadata c
LEFT JOIN public.ad_performance p ON c.creative_id = p.creative_id
LEFT JOIN public.conversions cv ON c.creative_id = cv.creative_id
GROUP BY c.creative_id, c.headline, c.ad_format, c.pain_point_angle;
