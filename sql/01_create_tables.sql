
-- ============================================================
-- 01_create_tables.sql
-- Purpose: Raw data ingestion & verification
-- Database: SQLite
-- ============================================================

-- Raw data source:
-- data/raw_data/leads_raw_10000.csv
-- 10,000 synthetic sales lead records

-- ------------------------------------------------------------
-- SQLite CLI ingestion steps (run manually in terminal)
-- ------------------------------------------------------------
-- sqlite3 sales_leads.db
-- .mode csv
-- .headers on
-- .import data/raw_data/leads_raw_10000.csv leads_raw
-- .quit

-- ------------------------------------------------------------
-- Result:
-- Table created: leads_raw
-- Columns inferred automatically from CSV header
-- No transformations applied at this stage
-- ------------------------------------------------------------

-- ------------------------------------------------------------
-- Verification check
-- ------------------------------------------------------------
SELECT COUNT(*) AS raw_row_count
FROM leads_raw;
