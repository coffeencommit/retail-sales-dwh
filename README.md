# 🛒 Retail Sales Data Warehouse — Star Schema Design

A data warehousing project demonstrating dimensional modelling using a retail sales domain. Built with PostgreSQL.

## 📐 Schema Design

Star schema with one fact table and four dimension tables:

```
         dim_customer
              |
dim_product — fact_sales — dim_date
              |
           dim_store
```

## 📁 Project Structure

```
retail-sales-dwh/
├── schema.sql        # DDL: CREATE TABLE statements
├── queries.sql       # Analytical SQL queries
├── data/             # Sample CSV files
│   ├── customers.csv
│   ├── products.csv
│   ├── stores.csv
│   ├── dates.csv
│   └── sales.csv
└── README.md
```

## 🚀 How to Run

1. Create a PostgreSQL database:
```sql
CREATE DATABASE retail_dwh;
```

2. Load the schema:
```bash
psql -d retail_dwh -f schema.sql
```

3. Import sample data (CSV → tables) and run queries:
```bash
psql -d retail_dwh -f queries.sql
```

## 🔍 Key Queries Included

- Total revenue by product category per month
- Top 10 customers by lifetime value
- Store performance comparison (YoY)
- Sales trend by day of week

## 🛠️ Tools Used

- PostgreSQL
- SQL (CTEs, Window Functions, Aggregations)

## 💡 Concepts Demonstrated

- Star schema / dimensional modelling
- Surrogate keys
- Slowly Changing Dimensions (Type 1)
- Analytical query design with CTEs and window functions
