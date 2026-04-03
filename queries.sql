-- ============================================================
--  Retail Sales DWH — Analytical Queries
-- ============================================================

-- 1. Monthly Revenue by Product Category
SELECT
    d.year,
    d.month_name,
    p.category,
    SUM(f.total_amount)               AS revenue,
    SUM(f.quantity)                   AS units_sold
FROM fact_sales f
JOIN dim_date    d ON f.date_key    = d.date_key
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY d.year, d.month_num, d.month_name, p.category
ORDER BY d.year, d.month_num, revenue DESC;


-- 2. Top 10 Customers by Lifetime Value
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name  AS customer_name,
    c.segment,
    COUNT(DISTINCT f.order_id)           AS total_orders,
    SUM(f.total_amount)                  AS lifetime_value
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.customer_id, customer_name, c.segment
ORDER BY lifetime_value DESC
LIMIT 10;


-- 3. Year-over-Year Store Performance
WITH yearly AS (
    SELECT
        s.store_name,
        s.region,
        d.year,
        SUM(f.total_amount) AS revenue
    FROM fact_sales f
    JOIN dim_store s ON f.store_key = s.store_key
    JOIN dim_date  d ON f.date_key  = d.date_key
    GROUP BY s.store_name, s.region, d.year
)
SELECT
    store_name,
    region,
    year,
    revenue,
    LAG(revenue) OVER (PARTITION BY store_name ORDER BY year) AS prev_year_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (PARTITION BY store_name ORDER BY year))
        / NULLIF(LAG(revenue) OVER (PARTITION BY store_name ORDER BY year), 0) * 100, 2
    ) AS yoy_growth_pct
FROM yearly
ORDER BY store_name, year;


-- 4. Sales by Day of Week (to find peak days)
SELECT
    d.day_of_week,
    d.day_num,
    COUNT(f.sales_id)     AS transactions,
    SUM(f.total_amount)   AS total_revenue,
    AVG(f.total_amount)   AS avg_order_value
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.day_of_week, d.day_num
ORDER BY d.day_num;


-- 5. Running Total Revenue (Month-to-Date)
SELECT
    d.full_date,
    SUM(f.total_amount)                                                AS daily_revenue,
    SUM(SUM(f.total_amount)) OVER (
        PARTITION BY d.year, d.month_num
        ORDER BY d.full_date
    )                                                                  AS mtd_revenue
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.full_date, d.year, d.month_num
ORDER BY d.full_date;
