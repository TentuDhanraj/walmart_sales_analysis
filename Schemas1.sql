-- create raw table
CREATE TABLE walmart_sales_raw (
    invoice_id      TEXT,
    branch          TEXT,
    city            TEXT,
    category        TEXT,
    unit_price      TEXT,
    quantity        TEXT,
    date            TEXT,
    time            TEXT,
    payment_method  TEXT,
    rating          TEXT,
    profit_margin   TEXT
);

-- create a clean table
CREATE TABLE walmart_sales (
    invoice_id      INT PRIMARY KEY,
    branch          VARCHAR(10),
    city            VARCHAR(50),
    category        VARCHAR(50),
    unit_price      NUMERIC(10, 2),
    quantity        INT,
    date            DATE,
    time            TIME,
    payment_method  VARCHAR(20),
    rating          NUMERIC(3, 1),
    profit_margin   NUMERIC(4, 2)
);
-- insert data to cleaN data from raw data 
TRUNCATE TABLE walmart_sales;
INSERT INTO walmart_sales
SELECT
    invoice_id::INT,
    branch,
    city,
    category,
    REPLACE(unit_price, '$', '')::NUMERIC,
    quantity::INT,
    TO_DATE(date, 'DD/MM/YYYY'),
    time::TIME,
    payment_method,
    rating::NUMERIC,
    profit_margin::NUMERIC
FROM walmart_sales_raw
ON CONFLICT (invoice_id) DO NOTHING; -- ignoreing the duplicates in invoice id

SELECT COUNT(*) FROM walmart_sales;

-- Delete null values
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE invoice_id IS NULL)     AS null_invoice_id,
    COUNT(*) FILTER (WHERE branch IS NULL)         AS null_branch,
    COUNT(*) FILTER (WHERE city IS NULL)           AS null_city,
    COUNT(*) FILTER (WHERE category IS NULL)       AS null_category,
    COUNT(*) FILTER (WHERE unit_price IS NULL)     AS null_unit_price,
    COUNT(*) FILTER (WHERE quantity IS NULL)       AS null_quantity,
    COUNT(*) FILTER (WHERE date IS NULL)           AS null_date,
    COUNT(*) FILTER (WHERE time IS NULL)           AS null_time,
    COUNT(*) FILTER (WHERE payment_method IS NULL) AS null_payment_method,
    COUNT(*) FILTER (WHERE rating IS NULL)         AS null_rating,
    COUNT(*) FILTER (WHERE profit_margin IS NULL)  AS null_profit_margin
FROM walmart_sales;

DELETE FROM walmart_sales
WHERE invoice_id IS NULL
   OR branch IS NULL
   OR city IS NULL
   OR category IS NULL
   OR unit_price IS NULL
   OR quantity IS NULL
   OR date IS NULL
   OR time IS NULL
   OR payment_method IS NULL
   OR rating IS NULL
   OR profit_margin IS NULL;