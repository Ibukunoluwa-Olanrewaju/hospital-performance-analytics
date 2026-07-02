# Hospital Operations Performance Analysis: Identifying Drivers of Length of Stay, Readmissions, and Financial Performance
> *Analyzed hospital-wide operational and financial data to identify the drivers of prolonged length of stay, readmissions, bed occupancy pressure, and revenue performance, delivering actionable insights to improve patient flow and operational efficiency.*

---

## ⚙️ Project Type

**End-to-End Healthcare Analytics Project**

**Techniques Used**
- [x] Data Cleaning / Wrangling
- [x] Exploratory Data Analysis (EDA)
- [x] SQL Analysis / Querying
- [x] Dashboard / Data Visualization

---

## Table of Contents
1. [Project Overview](#1-project-overview)
2. [Objectives](#2-objectives)
3. [Project Scope & Tools](#3-project-scope--tools)
4. [Repository Structure](#4-repository-structure)
5. [Data Workflow](#5-data-workflow)
6. [Data Model & Schema](#6-data-model--schema)
7. [ERD - Entity Relationship Diagram](#7-erd--entity-relationship-diagram) *(SQL projects)*
8. [Analysis & Metrics](#8-analysis--metrics)
9. [Key Insights](#9-key-insights)
10. [Recommendations](#10-recommendations)
11. [Assumptions & Limitations](#11-assumptions--limitations)
12. [Future Enhancements](#12-future-enhancements)
13. [Deliverables](#13-deliverables)
14. [Author](#14-author)

---

## 1. Project Overview

**Context:** 

A large tertiary hospital had experienced increasing operational and financial pressure over an 24-month period. Leadership observed prolonged inpatient stays, rising bed occupancy, delayed patient turnover, higher readmission rates, and growing financial strain despite sustained patient activity.

**Problem Statement:** 

Hospital leadership needed a data-driven investigation to identify the factors contributing to prolonged length of stay, readmissions, and capacity constraints. The objective was to determine which departments were under the greatest operational pressure, assess the impact on financial performance, and provide actionable recommendations to improve patient flow, operational efficiency, and patient outcomes.

**Approach:**

Cleaned and standardized five hospital datasets using Excel Power Query before integrating them in PostgreSQL through relational joins on Encounter, Patient, and Payer IDs.

Using SQL, I analyzed key operational and financial metrics including Average Length of Stay (ALOS), bed-day burden, readmission rate, inpatient volume, and revenue. The results were then connected to Tableau to build an interactive dashboard with KPIs and visualizations that supported trend analysis, departmental comparisons, segmentation, and root cause analysis.

**Outcome:** 

Developed an executive Tableau dashboard, analytical report, and presentation that uncovered the primary drivers of prolonged hospital stays, readmissions, and capacity constraints.

The analysis showed that operational inefficiencies, rather than increasing patient volume, were placing the greatest strain on hospital resources and provided actionable recommendations to improve patient flow, optimize bed utilization, and support better financial and operational decision-making.

---

## 2. Objectives

- **Primary Objective:** Determine the key operational factors driving inpatient capacity constraints and evaluate their impact on hospital performance to support data-driven decision-making.

- **Secondary Objective 1:** Analyze seasonal inpatient admission patterns to determine whether capacity pressure is driven by increasing patient volume or operational inefficiencies.

- **Secondary Objective 2:** Identify the departments, diagnoses, and readmission patterns contributing most to prolonged length of stay, bed-day utilization, and repeat hospitalizations.

- **Secondary Objective 3:** Evaluate the relationship between operational performance and financial outcomes, then develop an interactive Tableau dashboard to communicate key insights and support executive decision-making.

## 3. Project Scope & Tools

### Scope

| Dimension | Details |
|-----------|---------|
| **In Scope** | Analysis of five relational hospital datasets covering inpatient encounters, patient demographics, procedures, payer information, and financial performance. The project evaluated operational, clinical, and financial KPIs across hospital departments using SQL and Tableau. |
| **Out of Scope** | Operational cost accounting, clinical severity (acuity) scores, and post-discharge follow-up data were excluded because these variables were not available in the source datasets, limiting detailed cost analysis and identification of clinical causes of prolonged stays and readmissions. |
| **Time Period** | January 2023 to December 2024 (24 months).|
| **Granularity** | One row per inpatient encounter, enriched with patient, procedure, payer, and financial information through relational joins. |

### Tools & Technologies

| Category | Tool(s) Used |
|----------|-------------|
| Data Storage |PostgreSQL |
| Data Processing | Microsoft Excel (Power Query), SQL (PostgreSQL) |
| Analysis |SQL (PostgreSQL) |
| Visualization | Tableau |
| Version Control | Git & GitHub |
| Documentation |Markdown (GitHub README) |
| Other | DBeaver |

---

## 4. Repository Structure

Hospital-Operations-Performance-Analysis/

│

├── README.md

│

├── data/

│   ├── raw/

│   └── processed/

│

├── queries/

│   └── hospital_operations_analysis.sql

│

├── dashboards/

│   └── Hospital_Operations_Dashboard.twb

│

├── reports/

│   └── Executive_Report.pdf

│

├── visuals/

│   ├── hospital_erd.png

│   ├── dashboard_01_overview.png

│   ├── dashboard_02_operational.png

│   ├── dashboard_03_departmental.png

│   ├── dashboard_04_clinical.png

│   └── dashboard_05_financial.png               

## 5. Data Workflow

### 🔄 Data Workflow

```text

Five Relational Hospital Datasets

(Fact Encounter, Fact Patient, Fact Procedure, Fact Financial Summary, Fact Payer)

       ↓
Microsoft Excel (Power Query)

Data quality checks, character encoding cleanup, and data standardization

       ↓
PostgreSQL

Relational joins using Encounter ID, Patient ID, and Payer ID

       ↓
SQL Analysis

Calculated operational and financial KPIs, performed trend, ranking, 

segmentation, and root cause analysis, and created reusable SQL views

       ↓
Tableau

Connected SQL views, created calculated fields, built KPI cards, 

and developed interactive dashboards

       ↓
Deliverables

Executive dashboard, analytical report, and business recommendations
```

1. **Source:** Five relational hospital datasets in CSV format generated using Synthea, representing inpatient encounters, patient demographics, procedures, payer information, and financial data for the period January 2023 to December 2024.
   
3. **Ingestion:** Imported the CSV files into Microsoft Excel (Power Query) for initial preprocessing before loading the cleaned datasets into PostgreSQL for relational analysis.
   
4. **Cleaning:** Resolved character encoding issues, removed leading and trailing spaces, and standardized the datasets to improve data quality and ensure consistency before analysis.
   
5. **Transformation:** Integrated the five datasets in PostgreSQL using Encounter ID, Patient ID, and Payer ID. Created reusable SQL views and derived fields to support KPI calculations, while preparing the underlying data required for metrics such as Average Length of Stay (ALOS) and Readmission Rate. Final calculated fields were implemented in Tableau for dashboard reporting.
   
6. **Analysis:** Used SQL to calculate operational and financial KPIs and perform trend analysis, departmental comparisons, ranking, segmentation, and root cause analysis. Connected the SQL views to Tableau to develop interactive dashboards and KPI visualizations.

7. **Output:** Produced an interactive Tableau dashboard, an executive analytical report, and business recommendations to support operational, clinical, and financial decision-making.

---

## 6. Data Model & Schema

### Dataset / Table: `[name]`

| Field Name | Data Type | Description | Example Value |

| Encounter ID | String | Unique identifier for each hospital encounter. | ENC-102345 |

| Patient ID | String | Identifies the patient associated with the encounter. | PAT-004521 |

| Payer ID | String | Identifies the payer responsible for the encounter. | PAY-012 |

| Start Date | Date | Admission date of the encounter. | 2023-01-15 |

| Stop Date | Date | Discharge date of the encounter. | 2023-01-20 |

| Encounter Class | String | Type of hospital encounter. | Inpatient |

| Diagnosis Code | String | Standardized clinical code assigned to the primary diagnosis. | 72892002 |

| Diagnosis | String | Primary diagnosis associated with the encounter. | Normal pregnancy |

> **Row count (approx.):** 936,000+ rows

> **Date range:** January 2023 – December 2024

> **Key join / relationship:** patient_id → Fact Patient.patient_id, payer_id → Fact Payer.payer_id, encounter_id → Fact Procedure.encounter_id, encounter_id → Fact Financial Summary.encounter_id

> **Note:** The project uses five relational tables. The schema above presents a representative sample from the central **Fact Encounter** table. The complete table relationships are illustrated in the **Entity Relationship Diagram (ERD)** in the next section.

## 7. ERD - Entity Relationship Diagram

The Entity Relationship Diagram (ERD) illustrates the relational structure of the hospital database used in this project. The **Fact Encounter** table serves as the central fact table and is linked to the **Fact Patient**, **Fact Procedure**, **Fact Financial Summary**, and **Fact Payer** tables through shared keys.

![Entity Relationship Diagram](visuals/hospital_erd.png)

*Figure 1. Entity Relationship Diagram showing the relational schema and key relationships across the five hospital datasets.*
---

## 8. Analysis & Metrics

<!--
  Explain what you measured and how - before you share what you found.

  WHAT GOOD LOOKS LIKE:
  Metric: "Customer Return Rate"
  Definition: "Number of transactions flagged as returns divided by total
               transactions, calculated at product-category and regional grain."
  Why It Matters: "Return rate - not sales volume - was hypothesised to
                  explain regional revenue gaps. This metric tests that hypothesis."

  WHAT TO AVOID:
  ❌ Defining a metric only in code: SUM(returns) / COUNT(transaction_id)
     That's an implementation. Write the plain-language definition here.
     Both belong in your project - the definition in the README,
     the implementation in the code.
-->

### Analytical Approach

[Describe how you approached the analysis. Were you exploring patterns? Testing a hypothesis? Building and validating a pipeline? Be honest about your method - exploratory work is valid, just call it that.]

### Key Metrics Defined

| Metric | Plain-Language Definition | Why It Matters |
|--------|--------------------------|----------------|
| `[Metric 1]` | [What it measures, in one sentence] | [What decision or question it answers] |
| `[Metric 2]` | [What it measures, in one sentence] | [What decision or question it answers] |
| `[Metric 3]` | [What it measures, in one sentence] | [What decision or question it answers] |

### Methods Used

- [e.g., Descriptive statistics - distribution, central tendency, outlier detection]
- [e.g., Trend analysis across [time period]]
- [e.g., Segmentation / group comparison by [dimension]]
- [e.g., Correlation analysis between [variable A] and [variable B]]
- [e.g., SQL window functions for [specific aggregation]]
- [e.g., Custom aggregation or transformation logic in [tool]]

---

## 9. Key Insights

<!--
  Findings + implications. Not just what happened - what it means.

  WHAT GOOD LOOKS LIKE:
  ✅ "Return rates, not sales volume, explain Region A's underperformance.
      Region A's return rate on home goods was 34% - more than double the
      company average. Revenue was not lost at the point of sale; it was
      lost post-sale through refunds. This points to a fulfilment or
      product quality issue specific to that region, not a demand problem."

  WHAT TO AVOID:
  ❌ "Region A had lower revenue than other regions in Q4."
     (That's an observation. It describes what happened.
      An insight says what it means and where to look next.)

  Aim for 3–6 insights. Quality over quantity.
-->

**Insight 1: [Short descriptive headline]**
[What you found + what it suggests. One short paragraph.]

**Insight 2: [Short descriptive headline]**
[What you found + what it suggests.]

**Insight 3: [Short descriptive headline]**
[What you found + what it suggests.]

**Insight 4 (if applicable): [Short descriptive headline]**
[What you found + what it suggests.]

---

## 10. Recommendations

<!--
  Action-oriented. Addressed to a real audience.
  Tied explicitly to the insight that supports each one.

  WHAT GOOD LOOKS LIKE:
  Priority: High
  Recommendation: "Conduct a fulfilment audit for home goods deliveries
                   in Region A - specifically investigating whether returns
                   correlate with a particular warehouse, carrier, or SKU batch."
  Based On: Insight 1 - return rate anomaly in Region A
  Owner: Operations / Supply Chain team

  WHAT TO AVOID:
  ❌ "Improve the return rate."
     (Not actionable. Doesn't say who, how, or where to start.)
  ❌ "Further analysis is needed."
     (This is a placeholder, not a recommendation.)
-->

| Priority | Recommendation | Based On | Suggested Owner |
|----------|---------------|----------|-----------------|
| High | [Specific, actionable step] | [Insight it comes from] | [Who should act] |
| Medium | [Specific, actionable step] | [Insight it comes from] | [Who should act] |
| Low | [Exploratory or longer-term suggestion] | [Insight it comes from] | [Who should act] |

---

## 11. Assumptions & Limitations

<!--
  WHAT GOOD LOOKS LIKE:
  Assumption: "Transaction records were assumed to be complete for all five regions.
               No validation was performed against source system record counts."
  Limitation: "The analysis cannot distinguish between returns initiated by
               the customer vs. returns initiated by the business (e.g., recalls).
               If business-initiated returns are concentrated in Region A, the
               return rate finding may reflect a policy decision, not a quality issue."

  WHAT TO AVOID:
  ❌ Leaving this section blank or writing "None known."
     Every project has limitations. Documenting them is a sign of
     analytical maturity - not a confession of failure.
-->

### Assumptions
- [What did you treat as true without being able to verify?]
- [What simplifications did you make for scope or feasibility?]
- [What domain rules or definitions did you accept as given?]

### Limitations
- [What gaps exist in the data?]
- [What analysis was out of scope but could affect interpretation?]
- [What would a more rigorous version of this project include?]
- [Are there known biases in the data source or collection method?]

> *The goal here is pre-emptive Q&A. What would a thoughtful skeptic push back on? Document the answer here, before they ask.*

---

## 12. Future Enhancements

<!--
  WHAT GOOD LOOKS LIKE:
  ✅ "Automate the monthly data pull from the POS export folder using
      a scheduled Python script, replacing the current manual process."
  ✅ "Expand the return rate analysis to include carrier-level data,
      which was unavailable in this dataset but exists in the logistics system."

  WHAT TO AVOID:
  ❌ "Add a machine learning model."
     (Vague, and disconnected from the actual findings of this project.)
  ❌ Listing aspirational features that don't follow logically from the work.
-->

- [ ] [Enhancement 1 - specific and traceable to a real gap in this project]
- [ ] [Enhancement 2]
- [ ] [Enhancement 3]
- [ ] [Enhancement 4]

---

## 13. Deliverables

| Deliverable | Description | Location |
|-------------|-------------|----------|
| [Name] | [What it contains] | [`/path/to/file`] |
| [Name] | [What it contains] | [`/path/to/file`] |
| [Name] | [What it contains] | [`/path/to/file`] |

---

## 14. Author

**[Your Name]**
[Your role or title - current or target]

- 🔗 [LinkedIn URL]
- 💼 [Portfolio or GitHub profile URL]
- 📧 [Email - optional]

---

*Last updated: [Month YYYY]*
*If this template helped you, consider starring the repository.*
