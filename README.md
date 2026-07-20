# Telco Customer Churn Dashboard

An end-to-end data analytics project identifying churn drivers, at-risk customer segments, and revenue impact for a telecom provider — built using Excel, SQL Server, and Power BI.

## 🎯 Project Overview

Customer churn is one of the most expensive problems a subscription business can face. This project uses the IBM Telco Customer Churn dataset to answer: **who is leaving, why, and how much revenue is at stake?**

## 🛠️ Tools & Skills

- **Excel** — data auditing, cleaning, and normalization
- **SQL Server (SSMS)** — relational database design, DDL, PK/FK constraints, data import & validation
- **Power BI** — data modeling, DAX, interactive report design

## 📁 Workflow

1. **Data Audit & Normalization (Excel)**
   Split the raw 21-column flat file into three normalized tables — `demographics`, `services`, and `subscriptions` — keyed on `customerID`. Cleaned blank values in `TotalCharges` prior to database import.

2. **Relational Database Design (SQL Server)**
   Wrote DDL to create three tables with explicit data types and constraints. Established `customerID` as Primary Key across all tables, with Foreign Keys linking `services` and `subscriptions` back to `demographics`.

3. **Data Import & Validation**
   Imported each CSV via SSMS, resolving real data issues along the way — a UTF-8/ANSI code page conflict, a hidden byte-order-mark on the `customerID` header, and truncation errors on `PaymentMethod`. Verified row counts (7,043 per table) post-import.

4. **Data Modeling & DAX (Power BI)**
   Connected Power BI to the SQL Server database. Built measures including `Churn Rate`, `Retention Rate`, `Revenue at Risk`, `% Revenue at Risk`, and `High Risk Customers`, using `CALCULATE`, `DIVIDE`, and `ALLSELECTED`. Created tenure bins for cohort analysis.

5. **Dashboard Design**
   Two-page interactive report — an executive Overview and a Services/Demographics/Revenue deep-dive — with synced slicers (Contract, Gender, Internet Service) across both pages.

## 📊 Key Findings

| Driver | Insight |
|---|---|
| **Contract Type** | Month-to-month customers churn at 42.7% — over 15x two-year contracts |
| **Tenure** | Churn peaks at 54.3% in months 0–6, falling below 2% by year 5 |
| **Payment Method** | Electronic check churns at 45.3% — nearly 3x every other method |
| **Internet Service** | Fiber optic churns more than 2x DSL (41.9% vs 19.0%) |
| **Service Adoption** | No Online Security/Tech Support customers churn 2–3x more |
| **Revenue Impact** | $139K/month (30.5% of total revenue) sits with at-risk customers |

## 🔗 Links

- **Live Dashboard:** [Power BI Report link]
- **Portfolio Write-up:** [datawithkunle.com/telco-customer-churn-dashboard](https://datawithkunle.com/telco-customer-churn-dashboard/)
- **Dataset:** [IBM Telco Customer Churn, via Kaggle](https://www.kaggle.com/datasets/blastchar/telco-customer-churn)

## 📸 Preview
<img width="1920" height="1080" alt="telco-churn-dashboard-overview" src="https://github.com/user-attachments/assets/44c15f68-1edf-4461-9919-f92b3dcc1a46" />
<img width="1920" height="1080" alt="telco-churn-dashboard-services-revenue" src="https://github.com/user-attachments/assets/539a9404-479c-4dff-8692-f0b592ffc493" />



## 📂 Repository Structure

```
├── data/
│   ├── demographics.csv
│   ├── services.csv
│   └── subscriptions.csv
├── sql/
│   └── create_tables.sql
├── powerbi/
│   └── Telco_Customer_Churn_Dashboard.pbix
└── README.md
```
