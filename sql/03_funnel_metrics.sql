-- ============================================================
-- 03_funnel_metrics.sql
-- Purpose:
--   Aggregate leads by funnel stage to produce stage counts
--   and % of total leads (Tableau-ready).
-- ============================================================

DROP TABLE IF EXISTS funnel_stage_metrics;

CREATE TABLE funnel_stage_metrics AS
WITH stage_counts AS (
    SELECT
        funnel_order,
        funnel_stage,
        COUNT(*) AS leads_in_stage
    FROM leads_cleaned
    GROUP BY funnel_order, funnel_stage
),
totals AS (
    SELECT SUM(leads_in_stage) AS total_leads
    FROM stage_counts
)
SELECT
    sc.funnel_order,
    sc.funnel_stage,
    sc.leads_in_stage,
    ROUND(1.0 * sc.leads_in_stage / t.total_leads, 4) AS pct_of_total
FROM stage_counts sc
CROSS JOIN totals t
ORDER BY sc.funnel_order;
