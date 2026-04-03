-- ============================================================
--  Retail Sales Data Warehouse — Star Schema
-- ============================================================

-- Dimension: Customer
CREATE TABLE dim_customer (
    customer_key   SERIAL PRIMARY KEY,
    customer_id    VARCHAR(20)  NOT NULL UNIQUE,
    first_name     VARCHAR(50),
    last_name      VARCHAR(50),
    email          VARCHAR(100),
    city           VARCHAR(50),
    state          VARCHAR(50),
    country        VARCHAR(50),
    segment        VARCHAR(30),   -- e.g. Retail, Wholesale
    created_at     DATE
);

-- Dimension: Product
CREATE TABLE dim_product (
    product_key    SERIAL PRIMARY KEY,
    product_id     VARCHAR(20)  NOT NULL UNIQUE,
    product_name   VARCHAR(100),
    category       VARCHAR(50),
    sub_category   VARCHAR(50),
    brand          VARCHAR(50),
    unit_cost      NUMERIC(10,2)
);

-- Dimension: Store
CREATE TABLE dim_store (
    store_key      SERIAL PRIMARY KEY,
    store_id       VARCHAR(20)  NOT NULL UNIQUE,
    store_name     VARCHAR(100),
    city           VARCHAR(50),
    state          VARCHAR(50),
    region         VARCHAR(30)
);

-- Dimension: Date
CREATE TABLE dim_date (
    date_key       INT PRIMARY KEY,   -- format: YYYYMMDD
    full_date      DATE NOT NULL,
    day_of_week    VARCHAR(10),
    day_num        INT,
    week_num       INT,
    month_num      INT,
    month_name     VARCHAR(15),
    quarter        INT,
    year           INT,
    is_weekend     BOOLEAN
);

-- Fact: Sales
CREATE TABLE fact_sales (
    sales_id       SERIAL PRIMARY KEY,
    order_id       VARCHAR(30)  NOT NULL,
    date_key       INT          REFERENCES dim_date(date_key),
    customer_key   INT          REFERENCES dim_customer(customer_key),
    product_key    INT          REFERENCES dim_product(product_key),
    store_key      INT          REFERENCES dim_store(store_key),
    quantity       INT          NOT NULL,
    unit_price     NUMERIC(10,2) NOT NULL,
    discount       NUMERIC(5,2)  DEFAULT 0,
    total_amount   NUMERIC(12,2) GENERATED ALWAYS AS
                   (quantity * unit_price * (1 - discount / 100)) STORED
);

-- Indexes for query performance
CREATE INDEX idx_fact_date     ON fact_sales(date_key);
CREATE INDEX idx_fact_customer ON fact_sales(customer_key);
CREATE INDEX idx_fact_product  ON fact_sales(product_key);
CREATE INDEX idx_fact_store    ON fact_sales(store_key);
