-- 1. CREATE CLEAN SCHEMA
CREATE SCHEMA IF NOT EXISTS clean;

-- 2. BACKUP RECORDS WITH CRITICAL NULLS
CREATE TABLE clean.sales_information_backup AS
SELECT *
FROM staging.sales_information
WHERE order_id IS NULL
   OR customer_id IS NULL
   OR product_id IS NULL
   OR quantity IS NULL
   OR unit_price IS NULL
   OR order_date IS NULL
   OR delivery_status IS NULL
   OR payment_method IS NULL;

-- 3. CREATE CLEAN TABLE
CREATE TABLE clean.sales_information AS
WITH raw_sales_information AS (
    SELECT *
    FROM staging.sales_information
),
standardized AS (
    SELECT
        LOWER(TRIM(order_id)) AS order_id,
        LOWER(TRIM(customer_id)) AS customer_id,
        LOWER(TRIM(product_id)) AS product_id,
        LOWER(TRIM(quantity)) AS quantity,
        CAST(unit_price AS NUMERIC(10,2)) AS unit_price,
        order_date::DATE AS order_date,
        CASE
            WHEN UPPER(TRIM(delivery_status)) IN ('DELIVERED','DELRD') THEN 'delivered'
            WHEN UPPER(TRIM(delivery_status)) IN ('CANCELLED') THEN 'cancelled'
            WHEN UPPER(TRIM(delivery_status)) IN ('DELAYED','DELAYD') THEN 'delayed'
            ELSE 'unknown'
        END AS delivery_status,
        CASE
            WHEN UPPER(TRIM(payment_method)) IN ('BANK TRANSFER','BANK TRANSFR') THEN 'bank transfer'
            WHEN UPPER(TRIM(payment_method)) IN ('PAYPAL') THEN 'paypal'
            WHEN UPPER(TRIM(payment_method)) IN ('CREDIT CARD') THEN 'credit card'
            ELSE 'unknown'
        END AS payment_method,
        CASE
            WHEN UPPER(TRIM(region)) IN ('NORTH','NRTH') THEN 'north'
            WHEN UPPER(TRIM(region)) IN ('CENTRAL') THEN 'central'
            WHEN UPPER(TRIM(region)) IN ('EAST') THEN 'east'
            WHEN UPPER(TRIM(region)) IN ('SOUTH') THEN 'south'
            WHEN UPPER(TRIM(region)) IN ('WEST') THEN 'west'
            ELSE 'unknown'
        END AS region,
        COALESCE(CAST(discount_applied AS NUMERIC), 0) AS discount_applied
    FROM raw_sales_information
),
valid_records AS (
    SELECT
        order_id,
        customer_id,
        product_id,
        CASE
            WHEN quantity = 'three' THEN 3
            WHEN quantity = 'five' THEN 5
            ELSE quantity::NUMERIC
        END AS quantity,
        unit_price,
        order_date,
        delivery_status,
        payment_method,
        region,
        discount_applied
    FROM standardized
    WHERE order_id IS NOT NULL
      AND customer_id IS NOT NULL
      AND product_id IS NOT NULL
      AND order_date IS NOT NULL
)
SELECT *
FROM valid_records;


