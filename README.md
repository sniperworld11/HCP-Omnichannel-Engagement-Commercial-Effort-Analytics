# HCP Omnichannel Engagement & Commercial Effort Analytics
Commercial HCP promotional effort analytics using SQL and Excel to benchmark coverage (cumulative reach), intensity (frequency), and consistency (weekly unique reach) across Salesforce, Digital, and Omnichannel touchpoints.

## Project Overview
This commercial salesforce effectiveness and analytics project evaluates Healthcare Professional (HCP) engagement across **Salesforce (Field + SOS)**, **Digital**, and **Omnichannel** touchpoints. Using call and reach activity data (`Call_Reach_Data`), the framework decouples field promotional effort into three core dimensions: **Coverage (Cumulative Reach)**, **Intensity (Contact Frequency)**, and **Consistency (Weekly Reach)** across aligned Tier A and Tier B target HCPs.

---

## Core Business Questions & Framework

1. **Cumulative Reach (Coverage Breadth):** How much aligned-tier coverage accumulates within each half-year window across channels?
2. **Contact Frequency (Promotional Intensity):** How intensively is each reached HCP engaged, and how does contact intensity shift between H1 and H2?
3. **Weekly Reach (Cadence Consistency):** How consistently do field and digital teams reach unique HCPs week-over-week across national, regional, and district territories?

---

## Analytics Methodology & Data Pipeline (SQL)

- **Tier Alignment & Harmonization:** Filtered and harmonized aligned target populations where Omnichannel and Field tiers matched (`Tier A/A` and `Tier B/B`).
- **Channel Standardization:**
  - `Salesforce`: Field + SOS interactions
  - `Digital`: Approved digital promotional touchpoints
  - `Omnichannel`: Blended engagement (Field + SOS + Digital)
- **Cumulative Metrics (CTEs & Window Functions):** Constructed half-year tracking models restarting cumulative calculations every half-year to determine distinct HCP reach vs. cumulative calls.
- **Weekly Cadence & Territory Rollups:** Calculated daily vs. weekly distinct HCP reach using modular arithmetic week-start alignments across **National**, **Regional** (East, West), and **8 District levels** (Great Lakes, Gulf Coast, Mid-Atlantic, Northeast, Pacific, Rocky Mountain, Southeast, Southwest).

---

## Key Findings & Commercial Insights

- **Weekly Reach Consistency:** Salesforce (Field + SOS) demonstrated high weekly reach consistency (**97%–99%**) across all tiers and geographies, while Digital (**85%–92%**) showed wider regional variation and higher repeated daily touchpoints.
- **H1 vs. H2 Call Frequency:** Overall contact intensity declined in H2 across channels; Tier A digital contact frequency experienced the sharpest drop (**21% decline from 5.91 to 4.65 calls/HCP**), while Salesforce engagement remained the most stable (**6% decline from 3.24 to 3.05 calls/HCP**).
- **Geographic Nuances:** The **Rocky Mountain** district led Tier A digital reach (**92%**), while the **Southeast** district peaked for Tier B salesforce reach (**99%**).

---

## Repository Structure

```text
├── sql/
│   └── Onco_SQL_8.sql            # T-SQL scripts for cumulative reach, channel frequency & weekly reach matrices
├── data/
│   └── Oncology_case_study_8.xlsx # Aggregated frequency tables, reach metrics, and geographic cuts
├── presentations/
│   └── Onco case study 8.pptx    # Executive presentation on HCP engagement breadth, intensity & consistency
└── README.md
