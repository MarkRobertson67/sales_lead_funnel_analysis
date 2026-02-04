# Sales Lead Funnel Analysis — Project Workflow

This document records the **exact workflow used to build this project**
from an empty folder to final Tableau-ready outputs.

If I need to recreate this project later, this file is the starting point.

---

## 1. Project initialization

### 1.1 Create repository
- Created a new Git repository:
  `sales_lead_funnel_analysis`
- Initialized locally and linked to GitHub

```bash
git init
```

### 1.2 Create project folder structure

sales_lead_funnel_analysis/
├─ data/
│  ├─ raw_data/
│  └─ cleaned_data/
├─ sql/
├─ tableau/
├─ screenshots/
├─ sales_leads.db
├─ README.md
├─ DATABASE_NOTES.md
├─ WORKFLOW.md
└─ .gitignore

Folders were created manually or via terminal:

mkdir data raw_data cleaned_data sql tableau screenshots

### 1.3 Create README and .gitignore

    Added README.md to describe the project

    Added .gitignore to exclude:

        local DB artifacts

        temporary files

        editor/system files


## 2. Raw data preparation
### 2.1 Source data

The raw CSV was sourced from a publicly available Datablist sample
leads dataset and stored in `/data/raw_data` without modification.


    Original dataset provided as CSV / Excel

    File used:
    leads_raw_10000.csv

Stored in:

data/raw_data/leads_raw_10000.csv

### 2.2 Initial inspection

    Opened CSV in Excel for:

        column inspection

        basic validation

    No transformations performed in Excel

    All cleaning handled in SQL


## 3. SQLite database creation

Note: The SQLite database file is intentionally not committed.
It can be regenerated from the raw CSV and SQL scripts.

### 3.1 Create SQLite database file

From terminal:

sqlite3 sales_leads.db

Notes:

    SQLite automatically creates the database file

    No CREATE DATABASE statement is required

### 3.2 Import raw CSV into SQLite

Inside SQLite shell:

.mode csv
.import data/raw_data/leads_raw_10000.csv leads_raw

Result:

    Table leads_raw created

    Columns preserved exactly as in CSV

    Quoted column names and spaces indicate raw import


## 4. Schema inspection & ERD
### 4.1 Inspect schema

Used SQLite meta-commands:

.tables
.schema


### 4.2 Create ERD (conceptual)

ERD was created to visualize:

raw vs cleaned tables

derived funnel outputs

No foreign keys were defined, so ERD is conceptual

ERD used for understanding flow, not enforcement

Conceptual flow:

leads_raw
   ↓
leads_cleaned
   ↓
funnel metrics tables


## 5. SQL development (core logic)

All SQL logic was written as separate, ordered scripts
and stored in the sql/ directory.

### 5.1 01_create_tables.sql

Purpose:

Define cleaned and output tables

Created:

leads_cleaned

funnel_stage_metrics

funnel_conversion_rates

funnel_outcome_summary

source_outcome_breakdown

Executed in terminal:

.read sql/01_create_tables.sql

### 5.2 02_data_cleaning.sql

Purpose:

Transform raw data into analytics-ready format

Actions:

Renamed columns

Standardized values

Derived:

funnel_stage

funnel_order

is_converted

Executed:

.read sql/02_data_cleaning.sql

### 5.3 03_funnel_metrics.sql

Purpose:

Create funnel stage distribution metrics

Outputs:

funnel_stage_metrics

leads per stage

percent of total leads

Executed:

.read sql/03_funnel_metrics.sql

### 5.4 04_conversion_rates.sql

Purpose:

Create overall funnel outcome metrics

Outputs:

funnel_outcome_summary

won / lost / open

conversion rates

Executed:

.read sql/04_conversion_rates.sql

### 5.5 05_source_breakdown.sql

Purpose:

Analyze funnel outcomes by lead source

Outputs:

source_outcome_breakdown

channel-level performance

win/loss rates

Executed:

.read sql/05_source_breakdown.sql


## 6. CSV export for Tableau

All Tableau data sources were exported directly
from SQLite using the terminal.

General pattern:

.mode csv
.headers on
.output tableau/<filename>.csv
SELECT * FROM <table_name>;
.output stdout


Exported files:

funnel_stage_metrics.csv

funnel_outcome_summary.csv

source_outcome_breakdown.csv


## 7. Tableau visualization

Imported CSV files into Tableau

Built dashboards for:

funnel overview

stage distribution

source performance

Saved screenshots to screenshots/


## 8. Version control

All work committed incrementally:

git status
git add .
git commit -m "Add funnel metrics and Tableau exports"
git push


## 9. Key takeaways

Entire project is terminal-driven and reproducible

SQLite used for lightweight analytics and prototyping

SQL scripts are modular and ordered

CSVs act as clean interfaces to Tableau

Documentation ensures future reproducibility


## 10. Rebuild checklist (quick)

Clone repo

Import CSV

Run SQL scripts in order

Export CSVs

Open Tableau

## 11. Tableau connection workflow (Repo → Tableau)

This section documents **how data files from the repository
were connected to Tableau Desktop**.

---

### 11.1 Data handoff from SQLite to Tableau

All Tableau visualizations are powered by **CSV files exported
from SQLite** and stored in the repository under:

```text
sales_lead_funnel_analysis/
└─ tableau/
   ├─ funnel_outcome_summary.csv
   ├─ funnel_stage_metrics.csv
   └─ source_outcome_breakdown.csv
   ```

These CSVs represent final, analytics-ready data marts.
Tableau does not connect directly to the SQLite database.

### 11.2 Connecting CSV files in Tableau Desktop

In Tableau Desktop, the following steps were used:

    Open Tableau Desktop

    Click Data → New Data Source

    Select Files → Text File

    Choose My Computer

    Navigate to the project repository:

    sales_lead_funnel_analysis/tableau/

    Select the desired CSV file

    Click Open

Each CSV file was connected as a separate Tableau data source.

### 11.3 Tableau data sources used
Tableau Worksheet / Dashboard	CSV Data Source
Funnel overview KPIs	funnel_outcome_summary.csv
Funnel stage distribution	funnel_stage_metrics.csv
Source performance & ranking	source_outcome_breakdown.csv

This separation allows each visualization to use a purpose-built,
pre-aggregated dataset.

### 11.4 Why CSV files were used (design choice)

CSV was intentionally chosen as the interface between SQLite and Tableau because:

    SQLite was used for data transformation and aggregation

    Tableau was used strictly for visualization

    CSV files:

        are easy to inspect and validate

        can be versioned in Git

        provide a stable, reproducible snapshot of metrics

        avoid live database dependencies

This mirrors a common analytics workflow:

Database → Aggregation → Export → BI Tool

### 11.5 Reproducibility guarantee

If this project is cloned on another machine:

    Run the SQL scripts in order

    Re-export the CSV files into /tableau

    Reconnect those CSV files in Tableau Desktop

All dashboards will reproduce the same results.

### 11.6 Notes on file discovery

CSV files were located using Tableau’s file browser by navigating
the repository folder structure.

Clear directory organization (/tableau) ensured the correct files
were easy to identify and import.
---
