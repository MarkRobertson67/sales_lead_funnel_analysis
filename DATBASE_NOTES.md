# Sales Lead Funnel – Database Notes

This file documents **how the SQLite database was created**,  
**what tables exist**, and **what each table is used for**.

---

## 1. How the database was created

This project uses **SQLite**.

There was **no `CREATE DATABASE` statement**.

The database file was created automatically when SQLite opened it:

```bash
sqlite3 sales_leads.db
```
If the file does not exist, SQLite creates it immediately.

## 2. Raw data import
Table: leads_raw

Purpose: 
Stores the raw, unmodified lead data. Imported directly from CSV


How it was created:

Imported via SQLite CSV import

Column names were preserved exactly as in the CSV

Schema:
```bash
CREATE TABLE IF NOT EXISTS "leads_raw"(
  "Index" TEXT,
  "Account Id" TEXT,
  "Lead Owner" TEXT,
  "First Name" TEXT,
  "Last Name" TEXT,
  "Company" TEXT,
  "Phone 1" TEXT,
  "Phone 2" TEXT,
  "Email 1" TEXT,
  "Email 2" TEXT,
  "Website" TEXT,
  "Source" TEXT,
  "Deal Stage" TEXT,
  "Notes" TEXT
);
```

Notes:

Quoted column names + spaces indicate raw import

This table is not used directly for analytics



## 3. Cleaned / analytics-ready data
Table: leads_cleaned

Purpose:

Cleaned, standardized version of leads_raw

Base table for all funnel analysis

How it was created:

Created manually with CREATE TABLE

Populated via INSERT INTO ... SELECT ... FROM leads_raw

Added derived fields using CASE logic

Schema:
```bash
CREATE TABLE leads_cleaned(
  lead_index TEXT,
  account_id TEXT,
  lead_owner TEXT,
  first_name TEXT,
  last_name TEXT,
  company TEXT,
  phone_1 TEXT,
  phone_2 TEXT,
  email_1 TEXT,
  email_2 TEXT,
  website TEXT,
  source TEXT,
  deal_stage TEXT,
  notes TEXT,
  funnel_stage,
  funnel_order,
  is_converted
);
```

Derived columns:

funnel_stage – Top / Mid / Bottom funnel classification

funnel_order – Numeric stage order for sorting

is_converted – 1 if Closed Won, else 0



## 4. Funnel summary tables (derived outputs)

These tables store aggregated results for reporting and Tableau.

They are derived from leads_cleaned.

Table: funnel_stage_metrics

Purpose:

Distribution of leads by funnel stage

Schema:
```bash
CREATE TABLE funnel_stage_metrics(
  funnel_order,
  funnel_stage,
  leads_in_stage,
  pct_of_total
);
```

Table: funnel_conversion_rates

Purpose:

Conversion performance by funnel stage

Schema:
```bash
CREATE TABLE funnel_conversion_rates(
  funnel_order,
  funnel_stage,
  leads_in_stage,
  converted_leads,
  conversion_rate_to_close
);
```

Table: funnel_outcome_summary

Purpose:

Overall funnel outcomes (single-row summary)

Schema:
```bash
CREATE TABLE funnel_outcome_summary(
  total_leads,
  won_leads,
  lost_leads,
  open_leads,
  won_rate,
  lost_rate,
  open_rate
);
```

Table: source_outcome_breakdown

Purpose:

Funnel outcomes broken down by lead source

Used for channel and digital vs non-digital insights

Schema:
```bash
CREATE TABLE source_outcome_breakdown(
  source TEXT,
  total_leads,
  won_leads,
  lost_leads,
  open_leads,
  won_rate,
  lost_rate
);
```


## 5. Relationships & ERD notes

No primary keys or foreign keys were explicitly defined

SQLite therefore does not show relationships in ERD diagrams

Conceptual flow is:

leads_raw
   ↓
leads_cleaned
   ↓
(funnel_stage_metrics, funnel_conversion_rates,
 funnel_outcome_summary, source_outcome_breakdown)


ERD tools only draw relationships when foreign keys are declared.



## 6. CSV export for Tableau

Aggregated tables were exported using SQLite shell commands:
```bash
.mode csv
.headers on
.output tableau/<filename>.csv
SELECT * FROM <table_name>;
.output stdout
```

These CSVs were then loaded into Tableau.



📎 Appendix A — Terminal Commands Used
## Appendix A — Terminal Commands Used

This section documents the **actual terminal / SQLite shell commands**
used to build, inspect, and export data for this project.

If something looks familiar, that’s because these commands were run
multiple times during development.

---

### A1. Opening the database

SQLite databases are single files.  
Opening the file creates the database if it does not exist.

```bash
sqlite3 sales_leads.db
```

⚠️ Opening the wrong filename (e.g. funnel.db) will silently create
a new empty database.

### A2. Inspecting database contents

Run inside the SQLite shell (sqlite> prompt):
```bash
.tables        -- list tables and views
.schema        -- show CREATE TABLE / VIEW statements
.schema --indent
.databases     -- show file path of the active database
```

These commands were used to debug schema and ERD issues.

### A3. Importing raw CSV data

Raw lead data was imported into leads_raw.

Terminal method:

.mode csv
.import leads.csv leads_raw


Notes:

Column names were taken directly from the CSV

Spaces and capitalization were preserved


Exiting SQLite
.exit