-- ============================================================
-- 05_source_breakdown.sql
-- Purpose:
--   Analyze funnel outcomes by lead source to identify
--   which channels drive conversions, losses, and open pipeline.
-- ============================================================

DROP TABLE IF EXISTS source_outcome_breakdown;

CREATE TABLE source_outcome_breakdown AS
SELECT
    source,
    COUNT(*) AS total_leads,

    -- outcome counts
    SUM(CASE WHEN funnel_stage = 'Converted' THEN 1 ELSE 0 END) AS won_leads,
    SUM(CASE WHEN funnel_stage = 'Lost' THEN 1 ELSE 0 END) AS lost_leads,
    SUM(CASE 
        WHEN funnel_stage NOT IN ('Converted', 'Lost') THEN 1 
        ELSE 0 
    END) AS open_leads,

    -- outcome rates
    ROUND(
        1.0 * SUM(CASE WHEN funnel_stage = 'Converted' THEN 1 ELSE 0 END) 
        / COUNT(*),
        4
    ) AS won_rate,

    ROUND(
        1.0 * SUM(CASE WHEN funnel_stage = 'Lost' THEN 1 ELSE 0 END) 
        / COUNT(*),
        4
    ) AS lost_rate

FROM leads_cleaned
GROUP BY source
ORDER BY total_leads DESC;
