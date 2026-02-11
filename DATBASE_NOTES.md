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
### Table: leads_raw

**Purpose**

- Stores the raw, unmodified lead data
- Serves as the immutable source of truth for all downstream transformations
- Imported directly from CSV without preprocessing

**Data origin**

- Source: Public sample leads dataset from Datablist  
```bash
  https://www.datablist.com/learn/csv/download-sample-csv-files#leads-dataset
  ```
- Dataset is synthetic and used for demonstration and analysis purposes

**How it was created**

- Imported using the SQLite CLI CSV import
- No transformations applied prior to import
- Column names, spacing, and capitalization preserved exactly as provided

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

### Table: funnel_stage_metrics

**Purpose**

This table stores the distribution of leads across standardized funnel stages.

It answers the question:

> “Where are leads currently concentrated in the funnel?”

Each row represents a funnel stage, along with:
- The total number of leads in that stage
- The percentage of total leads represented by that stage

This table is used for:
- Funnel visualization in Tableau
- Identifying stage bottlenecks
- Highlighting where leads accumulate or stall

**Grain:** One row per funnel stage  
**Derived From:** `leads_cleaned`

**Schema**
```bash
CREATE TABLE funnel_stage_metrics(
  funnel_order,
  funnel_stage,
  leads_in_stage,
  pct_of_total
);

```

### Table: funnel_conversion_rates

**Purpose**

This table measures conversion performance at each funnel stage.

It answers the question:

> “How effectively do leads at each stage ultimately convert to Closed Won?”

Each row represents a funnel stage and includes:
- The number of leads in that stage
- The number of those leads that ultimately converted
- The conversion rate to close

This allows performance comparison across stages and helps identify:
- Strong progression points
- Weak or leaky stages
- Where conversion efficiency drops

Unlike `funnel_stage_metrics`, which shows distribution, this table evaluates **stage-level effectiveness**.

**Grain:** One row per funnel stage  
**Derived From:** `leads_cleaned`

**Schema**
```bash
CREATE TABLE funnel_conversion_rates(
  funnel_order,
  funnel_stage,
  leads_in_stage,
  converted_leads,
  conversion_rate_to_close
);

```

### Table: funnel_outcome_summary

**Purpose**

This table provides a single-row summary of overall funnel outcomes.

It answers the question:

> “Across all leads, how did the funnel resolve?”

The table includes:
- Total leads
- Number of leads won
- Number of leads lost
- Number of leads still open
- Corresponding outcome rates

This table serves as the executive KPI snapshot of the entire funnel and is used for:
- Dashboard KPI cards
- High-level performance reporting
- Measuring overall funnel health

Unlike stage-level tables, this table aggregates outcomes across the entire dataset and represents the highest level of summary.

**Grain:** Entire dataset (single row)  
**Derived From:** `leads_cleaned`

**Schema**
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

### Table: source_outcome_breakdown

**Purpose**

This table provides funnel outcomes segmented by lead source.

It answers the question:

> “Which channels drive scale versus conversion efficiency?”

Each row represents a lead source and includes:
- Total leads generated by that source
- Number of leads won, lost, and still open
- Outcome rates (won and lost rates)

This table enables:
- Channel performance comparison
- Ranking by conversion rate
- Ranking by open pipeline volume
- Digital vs non-digital analysis

By applying the same outcome logic used in `funnel_outcome_summary` at a more granular level, this table supports deeper channel-level insights while maintaining consistent metric definitions.

**Grain:** One row per lead source  
**Derived From:** `leads_cleaned`

**Schema**
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

---

### A1. Opening the database

SQLite databases are single files.  
Opening the file creates the database if it does not exist.

```bash
sqlite3 sales_leads.db
```

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