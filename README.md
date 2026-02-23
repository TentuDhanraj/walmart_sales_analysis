# 🛒 Walmart Sales Analysis

An end-to-end data analysis project using **PostgreSQL** and **Excel** to explore Walmart sales data across multiple branches, cities, and product categories.

---

## 📁 Project Structure

```
walmart-sales-analysis/
│
├── walmart_analysis.sql     # All SQL queries (setup + analysis)
├── README.md                # Project documentation
└── screenshots/             # Excel charts and pivot table visuals
```

---

## 🗄️ Dataset

- **Source:** Walmart sales transaction data
- **Records:** ~10,000 rows
- **Period:** January – March 2019
- **Columns:** invoice_id, branch, city, category, unit_price, quantity, date, time, payment_method, rating, profit_margin

---

## 🔧 Tools Used

| Tool | Purpose |
|------|---------|
| PostgreSQL | Data storage, cleaning, and analysis |
| Excel | Pivot tables, charts, and formulas |

---

## 🧹 Data Cleaning Steps

1. Loaded raw CSV into a staging table (`walmart_sales_raw`)
2. Removed `$` symbol from `unit_price` and cast to NUMERIC
3. Converted date strings to proper DATE format (`DD/MM/YYYY`)
4. Removed duplicate `invoice_id` entries using `ON CONFLICT DO NOTHING`
5. Added computed columns: `total_revenue`, `profit`, `month_name`, `day_of_week`, `hour_of_day`

---

## 📊 SQL Analysis — Key Findings

| # | Question | Key Finding |
|---|----------|-------------|
| 1 | Total revenue per category | Food & Beverages generated the highest revenue |
| 2 | Branch performance | WALM058 had the most transactions (239); WALM004 had the highest avg rating (7.0) |
| 3 | Cities with high profit margin | Mansfield had the highest avg profit margin (0.57) |
| 4 | Busiest hours | 15:00 (3 PM) was the peak hour with 1,191 transactions |
| 5 | Payment method by city | Varies by city — identified using RANK() window function |
| 6 | Monthly revenue | All 3 months exceeded $500 threshold |
| 7 | Branch-city mapping | No branch appeared in more than one city |
| 8 | Running revenue total | Calculated per branch using window functions |
| 9 | Above-average unit price | Identified transactions above category average price |
| 10 | Top-rated transactions | Found highest rated sale per category (ties handled with RANK) |

---

## 📈 Excel Analysis

- **Pivot Table:** Total revenue broken down by category and payment method
- **AVERAGEIF:** Average rating per product category
- **SUMIF:** Monthly sales summary
- **COUNTIFS:** Count of Ewallet transactions with rating > 7
- **XLOOKUP:** Mapped categories to department names
- **Bar Chart:** Total revenue comparison across branches
- **Conditional Formatting:** Highlighted rows with lowest profit margin (0.18)

---

## 💡 SQL Concepts Used

- Aggregations (`SUM`, `AVG`, `COUNT`)
- `GROUP BY` with `HAVING`
- CTEs (`WITH` clause)
- Window functions (`RANK()`, `SUM() OVER`)
- Subqueries
- `EXTRACT` for date/time parts
- `TO_DATE`, `TO_CHAR` for formatting
- `ON CONFLICT DO NOTHING` for deduplication

---

## 🚀 How to Run

1. Clone the repository
2. Create a PostgreSQL database
3. Update the file path in the `\copy` command inside `walmart_analysis.sql`
4. Run the script in psql or pgAdmin:
```bash
psql -d your_database_name -f walmart_analysis.sql
```

---

## 👤 Author

**[Your Name]**  
Aspiring Data Analyst  
[LinkedIn Profile] | [GitHub Profile]
