-- ============================================================
-- 04_conversion_rates.sql
-- Purpose:
--   Compute overall funnel outcomes (Won/Lost/Open) and rates.
--   Note: dataset is snapshot-by-stage (no time-based progression).
-- ============================================================

DROP TABLE IF EXISTS funnel_outcome_summary;

CREATE TABLE funnel_outcome_summary AS
WITH base AS (
    SELECT
        COUNT(*) AS total_leads,
        SUM(CASE WHEN funnel_stage = 'Converted' THEN 1 ELSE 0 END) AS won_leads,
        SUM(CASE WHEN funnel_stage = 'Lost' THEN 1 ELSE 0 END) AS lost_leads,
        SUM(CASE WHEN funnel_stage IN ('Lead Created','Contacted','Qualified','Active Deal','Paused') THEN 1 ELSE 0 END) AS open_leads
    FROM leads_cleaned
)
SELECT
    total_leads,
    won_leads,
    lost_leads,
    open_leads,
    ROUND(1.0 * won_leads / total_leads, 4)  AS won_rate,
    ROUND(1.0 * lost_leads / total_leads, 4) AS lost_rate,
    ROUND(1.0 * open_leads / total_leads, 4) AS open_rate
FROM base;
