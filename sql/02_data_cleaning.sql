-- ============================================================
-- 02_data_cleaning.sql
-- Purpose:
--   Create a cleaned leads table with standardized funnel logic
--   and conversion indicators for downstream analysis.
--
-- Upstream data quality checks were performed in Excel
-- prior to SQL-based funnel modeling.
--
-- What this step DOES:
--   - Preserves all validated records (no row removal)
--   - Standardizes deal stages into ordered funnel stages
--   - Adds a conversion flag for KPI calculation
--   - Renames columns for SQL-friendly usage
--
-- What this step DOES NOT do:
--   - No deduplication (each row treated as a unique lead record)
--   - No outlier removal (non-numeric dataset)
--   - No imputation or enrichment
--
-- Rationale:
--   Funnel logic is applied at the SQL layer to ensure
--   transparency, reproducibility, and auditability.
-- ============================================================


DROP TABLE IF EXISTS leads_cleaned;

CREATE TABLE leads_cleaned AS
SELECT
    -- keep original columns (renamed to SQL-friendly)
    "Index"            AS lead_index,
    "Account Id"       AS account_id,
    "Lead Owner"       AS lead_owner,
    "First Name"       AS first_name,
    "Last Name"        AS last_name,
    "Company"          AS company,
    "Phone 1"          AS phone_1,
    "Phone 2"          AS phone_2,
    "Email 1"          AS email_1,
    "Email 2"          AS email_2,
    "Website"          AS website,
    "Source"           AS source,
    "Deal Stage"       AS deal_stage,
    "Notes"            AS notes,

    -- funnel stage definition (business logic)
    CASE
        WHEN "Deal Stage" = 'New Lead' THEN 'Lead Created'
        WHEN "Deal Stage" = 'Contacted' THEN 'Contacted'
        WHEN "Deal Stage" = 'Qualified' THEN 'Qualified'
        WHEN "Deal Stage" IN ('Proposal Sent', 'Negotiation', 'Re-engagement') THEN 'Active Deal'
        WHEN "Deal Stage" = 'On Hold' THEN 'Paused'
        WHEN "Deal Stage" = 'Closed Won' THEN 'Converted'
        WHEN "Deal Stage" IN ('Closed Lost', 'Disqualified') THEN 'Lost'
        ELSE 'Unknown'
    END AS funnel_stage,

    -- funnel order (so Tableau can sort correctly)
    CASE
        WHEN "Deal Stage" = 'New Lead' THEN 1
        WHEN "Deal Stage" = 'Contacted' THEN 2
        WHEN "Deal Stage" = 'Qualified' THEN 3
        WHEN "Deal Stage" IN ('Proposal Sent', 'Negotiation', 'Re-engagement') THEN 4
        WHEN "Deal Stage" = 'On Hold' THEN 5
        WHEN "Deal Stage" = 'Closed Won' THEN 6
        WHEN "Deal Stage" IN ('Closed Lost', 'Disqualified') THEN 7
        ELSE NULL
    END AS funnel_order,

    -- conversion flag
    CASE
        WHEN "Deal Stage" = 'Closed Won' THEN 1
        ELSE 0
    END AS is_converted

FROM leads_raw;
