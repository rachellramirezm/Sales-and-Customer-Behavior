-- 1. CREAT CLEAN SCHEMA
CREATE SCHEMA IF NOT EXISTS clean;

-- 2. CREATE CLEAN TABLE
CREATE TABLE clean.product_information AS
WITH raw_product_information AS (
	SELECT *
	FROM staging.product_information
),
standardized AS (
	SELECT
		LOWER(product_id) AS product_id,
		LOWER(product_name) AS product_name,
		LOWER(category_name) AS category_name,
		launch_date::DATE AS launch_date,
		CAST(base_price AS NUMERIC(10,2)) AS base_price,
		LOWER(supplier_code) AS supplier_code
	FROM raw_product_information
)
SELECT *
FROM standardized;