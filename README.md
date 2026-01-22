# Sales Lead Funnel Analysis

## Overview
This project analyzes a synthetic sales leads dataset to measure funnel conversion rates from lead creation through conversion. The objective is to identify funnel drop-off points and surface actionable insights that can improve lead qualification, follow-up strategy, and overall sales performance.

The project demonstrates an end-to-end analytics workflow, including data cleaning, validation, SQL-based aggregation, Excel quality assurance checks, and Tableau dashboarding.

---

## Business Question
How effectively are sales leads progressing through each stage of the funnel, and where are the largest drop-offs occurring?

Key questions addressed:
- What percentage of leads convert at each funnel stage?
- Which stages experience the highest loss of potential customers?
- Where should sales teams focus to improve funnel efficiency?
- How can funnel performance be clearly communicated to stakeholders?

---

## Dataset
- **Source:** Synthetic CSV dataset from Datablist
- **Format:** CSV
- **Records:** 10,000 sales leads with defined lifecycle stages
- **Example Fields:**
  - Lead ID
  - Deal Stage
  - Lead Source / Channel
  - Contact Information
  - Notes

Raw and cleaned datasets are stored separately to preserve data lineage, reproducibility, and auditability.

---

## Project Workflow
1. Ingested raw sales lead data (CSV)
2. Performed initial data quality checks and validation in **Excel**
3. Saved a cleaned, verified CSV for analysis
4. Applied funnel logic and created analytical fields in **SQL**
5. Calculated funnel counts and conversion metrics in SQL
6. Built an interactive **Tableau dashboard** to visualize lead flow and drop-offs

---
```text
## Project Structure
sales_lead_funnel_analysis/
│
├── data/
│ ├── raw_data/
│ │ └── leads_raw.csv
│ ├── cleaned_data/
│ │ └── leads_cleaned.csv
│
├── excel/
│ └── lead_validation_checks.xlsx
│
├── sql/
│ ├── 01_create_tables.sql
│ ├── 02_data_cleaning.sql
│ ├── 03_funnel_metrics.sql
│ └── 04_conversion_rates.sql
│
├── tableau/
│ └── sales_lead_funnel_dashboard.twbx
│
├── screenshots/
│ └── funnel_dashboard.png
│
└── README.md
```

---

## Tools & Technologies
- **Excel** – Initial data inspection, duplicate checks, and QA validation
- **SQL (SQLite)** – Funnel stage standardization, KPI creation, and aggregation
- **Tableau** – Interactive dashboard for funnel visualization
- **CSV** – Synthetic sales leads dataset

---

## Data Cleaning & Validation

## Excel (Initial QA)

Before applying SQL logic, the raw dataset was reviewed in Excel to ensure data quality:
- Verified total row count (~10,000 records)
- Checked for duplicate records (none found)
- Confirmed no missing or invalid Deal Stage values
- Visually inspected Deal Stage consistency
No critical data quality issues were identified, so no rows were removed.
This ensured that downstream funnel metrics reflected the full lead population without introducing bias.
A cleaned dataset was saved for downstream SQL processing.


### SQL (Analytical Cleaning)

SQL was used to:
- Standardize Deal Stage values into ordered funnel stages
- Add a binary conversion flag (is_converted)
- Rename columns for consistency and usability
- Preserve all validated records for analysis
This separation ensures that Excel handles data quality, while SQL encodes business logic.

---

## Funnel Metrics (SQL)
Using SQL, leads were aggregated by funnel stage to calculate:
- Total leads per stage
- Stage-to-stage conversion rates
- Overall lead-to-conversion rate

These KPIs make it easy to identify bottlenecks and prioritize improvements in the sales process.

---

## Tableau Dashboard
The Tableau dashboard visualizes:
- Lead counts by funnel stage
- Conversion rates between stages
- Funnel drop-off points at a glance

The dashboard is designed for non-technical stakeholders and supports fast, data-driven decision making.

📸 **Dashboard Preview:**  
See `/screenshots/funnel_dashboard.png`

---

## Key Insights
- The largest drop-off occurs between early qualification and active engagement.
- Once leads pass initial screening, later-stage conversion rates improve significantly.
- Improved funnel visibility enables targeted improvements in lead qualification and follow-up strategy.

---

## Next Steps / Enhancements
- Segment funnel metrics by lead source or channel
- Track funnel performance over time
- Add revenue attribution for converted leads
- Automate data refresh and dashboard updates

---

## Why This Project Matters
This project demonstrates practical, job-relevant data analyst skills:
- Translating business questions into measurable KPIs
- Cleaning and validating real-world-style datasets
- Writing clear, maintainable SQL for analysis
- Communicating insights visually with Tableau

It mirrors the type of funnel analysis commonly used by sales, marketing, and operations teams in real organizations.
