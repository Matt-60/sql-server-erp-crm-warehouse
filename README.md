# SQL Server ERP + CRM Data Warehouse

An end-to-end data warehousing and analytics solution — from raw ERP/CRM extracts to a documented, analytics-ready star schema in SQL Server. Built as a portfolio project demonstrating industry-standard data engineering practices.

`SQL Server` · `T-SQL` · `Medallion Architecture` · `Star Schema` · `ETL`

---

## 🎯 Business Goal

The business runs on two disconnected systems — an ERP and a CRM — making it hard to get one consistent view of customers, products, and sales. This project consolidates both sources into a single SQL Server data warehouse, so analysts can answer questions about customer behavior, product performance, and sales trends from one clean, documented model instead of reconciling two systems by hand.

## 🏗️ Data Architecture
data architecture:
<img width="1221" height="611" alt="image" src="https://github.com/user-attachments/assets/039fc9f9-5325-4436-8f42-79b889b6ba2a" />
dataflow:
<img width="862" height="405" alt="image" src="https://github.com/user-attachments/assets/992dcdfc-ec3b-4ea6-a811-8b5a2e43849f" />
data integration:
<img width="1204" height="592" alt="image" src="https://github.com/user-attachments/assets/8b61b141-1b7b-4f45-911d-25e0bf321bc2" />



```
ERP (CSV) + CRM (CSV) ─► Bronze ─► Silver ─► Gold (Star Schema) ─► SQL Reports / BI
```

| Layer | Purpose |
|---|---|
| **Bronze** | Raw data as-is from ERP + CRM CSV exports, loaded into SQL Server |
| **Silver** | Cleansing, standardization, and normalization to prepare data for analysis |
| **Gold** | Business-ready star schema for reporting and analytics |

## 🚀 Scope

**Data Engineering:**
- Two source systems (ERP + CRM), CSV-based, latest snapshot only (no historization required)
- Data quality cleansing and resolution before integration
- Combined into a single, documented, analytics-friendly model

**Analytics (SQL-based):**
- Customer behavior
- Product performance
- Sales trends

  <img width="1531" height="640" alt="image" src="https://github.com/user-attachments/assets/caa17bb1-27f5-41ac-9a24-cf3d73371972" />


<details>
<summary><b>📂 Repository structure (click to expand)</b></summary>

```
data-warehouse-project/
├── data_analysis/     # SQL scripts: EDA, time-based trends, performance metrics, customer segments
├── datasets/           # Raw ERP and CRM source data
├── docs/
│   ├── data_catalog.md         # Field descriptions and metadata
│   └── naming-conventions.md   # Naming standards for tables/columns/files
├── scripts/
│   ├── bronze/         # Extract & load raw data
│   ├── silver/         # Cleaning & transformation
│   └── gold/            # Analytical star schema models
├── tests/               # Data quality test scripts
└── README.md
```

</details>
