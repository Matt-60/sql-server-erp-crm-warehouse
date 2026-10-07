# SQL Server ERP + CRM Data Warehouse

An end-to-end data warehousing and analytics solution — from raw ERP/CRM extracts to a documented, analytics-ready star schema in SQL Server. Built while following the Data With Baraa SQL Data Warehouse course; used to practise T-SQL ETL and medallion design.

`SQL Server` · `T-SQL` · `Medallion Architecture` · `Star Schema` · `ETL` · `Data Quality`

---

## 🎯 Business Goal

The business runs on two disconnected systems — an ERP and a CRM — making it hard to get one consistent view of customers, products, and sales. This project consolidates both sources into a single SQL Server data warehouse, so analysts can answer questions about customer behavior, product performance, and sales trends from one clean, documented model instead of reconciling two systems by hand.

## 🏗️ Data Architecture

```
ERP (CSV) + CRM (CSV) ─► Bronze ─► Silver ─► Gold (Star Schema) ─► SQL Reports / BI
```

| Layer | Purpose |
|---|---|
| **Bronze** | Raw data as-is from ERP + CRM CSV exports, loaded into SQL Server, no transformations |
| **Silver** | Cleansing, standardization, deduplication, and normalization — resolving conflicts between the two source systems before integration |
| **Gold** | Business-ready star schema — dimension and fact views for reporting and analytics |

<details>
<summary><b>🖼️ Architecture diagram (click to expand)</b></summary>

<img width="1221" height="611" alt="data architecture diagram" src="https://github.com/user-attachments/assets/039fc9f9-5325-4436-8f42-79b889b6ba2a" />

</details>

<details>
<summary><b>🔀 Dataflow — Bronze → Silver → Gold (click to expand)</b></summary>

<img width="862" height="405" alt="dataflow diagram" src="https://github.com/user-attachments/assets/992dcdfc-ec3b-4ea6-a811-8b5a2e43849f" />

</details>

<details>
<summary><b>🔗 Data integration — ERD & column mapping (click to expand)</b></summary>

<img width="1204" height="592" alt="data integration diagram" src="https://github.com/user-attachments/assets/8b61b141-1b7b-4f45-911d-25e0bf321bc2" />

Entity-relationship diagram showing how ERP and CRM tables relate to each other and how their columns map into the unified Silver/Gold model.

</details>

## 🚀 Scope

**Data Engineering:**
- Two source systems (ERP + CRM), CSV-based, latest snapshot only (no historization required)
- Data quality cleansing and conflict resolution before integration
- Combined into a single, documented, analytics-friendly model
- Documented **data catalog** and **naming conventions**, enforced consistently across Bronze/Silver/Gold

**Analytics (SQL-based):**
- Customer behavior
- Product performance
- Sales trends

<details>
<summary><b>📊 Example analytics output (click to expand)</b></summary>

<img width="1531" height="640" alt="analytics query example" src="https://github.com/user-attachments/assets/caa17bb1-27f5-41ac-9a24-cf3d73371972" />

</details>

## 🧠 Key Design Decisions

- **Medallion architecture** — keeps raw data untouched in Bronze for traceability/reprocessing, isolates cleansing logic in Silver, and exposes only business-ready models in Gold
- **Documented naming conventions & data catalog** — every table/column follows a defined standard from day one, so the model stays consistent as more sources or analysts are added
- **Latest-snapshot approach** — since source systems don't require historical tracking here, the model favors simplicity over unnecessary SCD complexity

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
