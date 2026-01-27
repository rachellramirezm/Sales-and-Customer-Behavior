-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: product_id
-- Rule: product_id must not be NULL
-- Expected result: 0 records with NULL values (0)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(product_id) AS records_not_null,
	COUNT(*) - COUNT(product_id) AS null_records,
	ROUND(
		(COUNT(*) - COUNT(product_id))* 100.00/ COUNT(*), 2
	)AS null_percentage
FROM staging.product_information

-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: product_name
-- Rule: product_name must not be NULL
-- Expected result: 0 records with NULL values (0)
-- =====================================================

SELECT
	COUNT(*) AS total_records,
	COUNT(product_name) AS records_not_null,
	COUNT(*) - COUNT(product_name) AS null_records,
	ROUND(
		(COUNT(*) - COUNT(product_name))* 100.00/ COUNT(*), 2
	)AS null_percentage
FROM staging.product_information


-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: category_name
-- Rule: category_name must not be NULL
-- Expected result: 0 records with NULL values (0)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(category_name) AS records_not_null,
	COUNT(*) - COUNT(category_name) AS null_records,
	ROUND(
		(COUNT(*) - COUNT(category_name))* 100.00/ COUNT(*), 2
	)AS null_percentage
FROM staging.product_information


-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: launch_date
-- Rule: launch_date must not be NULL
-- Expected result: 0 records with NULL values (0)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(launch_date) AS records_not_null,
	COUNT(*) - COUNT(launch_date) AS null_records,
	ROUND(
		(COUNT(*) - COUNT(launch_date))* 100.00/ COUNT(*), 2
	)AS null_percentage
FROM staging.product_information


-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: base_price
-- Rule: base_price must not be NULL
-- Expected result: 0 records with NULL values (0)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(base_price) AS records_not_null,
	COUNT(*) - COUNT(base_price) AS null_records,
	ROUND(
		(COUNT(*) - COUNT(base_price))* 100.00/ COUNT(*), 2
	)AS null_percentage
FROM staging.product_information


-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: supplier_code
-- Rule: supplier_code must not be NULL
-- Expected result: 0 records with NULL values (0)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(supplier_code) AS records_not_null,
	COUNT(*) - COUNT(supplier_code) AS null_records,
	ROUND(
		(COUNT(*) - COUNT(supplier_code))* 100.00/ COUNT(*), 2
	)AS null_percentage
FROM staging.product_information


-- =====================================================
-- Data Quality Validation: Uniqueness
-- Field evaluated: product_id
-- Rule: product_id must be unique
-- Expected result: 0 duplicate records (0)
-- =====================================================
SELECT
	product_id,
	COUNT(*)
FROM staging.product_information
GROUP BY product_id
HAVING COUNT(*) > 1;


-- =====================================================
-- Data Quality Validation: Uniqueness
-- Field evaluated: product_name
-- Rule: product_name must be unique
-- Expected result: 0 duplicate records (0)
-- =====================================================
SELECT
	product_name,
	COUNT(*)
FROM staging.product_information
GROUP BY product_name
HAVING COUNT(*) > 1;


-- =====================================================
-- Data Quality Validation: Validity
-- Field evaluated: base_price
-- Rule: base_price must be greater than 0
-- Expected result: 0 invalid records
-- =====================================================
SELECT
	CAST(base_price AS NUMERIC),
	COUNT(*) AS records
FROM staging.product_information
WHERE CAST(base_price AS NUMERIC) <= 0
GROUP BY base_price
	

-- =====================================================
-- Data Quality Validation: Date Consistency and Validity
-- Field evaluated: signup_date
-- Rule: 
-- signup_date values must represent valid calendar dates,
-- follow a consistent format, and comply with business
-- logic (no future dates).
-- Expected result:
-- 0 records with invalid, inconsistent, or future dates
-- =====================================================
SELECT launch_date
FROM staging.product_information
WHERE launch_date ~ '^\d{2}-\d{2}-\d{2}$'
  AND (
    SUBSTRING(launch_date, 1, 2)::int > 31 OR
    SUBSTRING(launch_date, 4, 2)::int > 12
  );


SELECT
	DISTINCT category_name,
	COUNT(*) AS records
FROM staging.product_information
GROUP BY category_name
ORDER BY COUNT(*) DESC

--Check space in blanck(everything good)
SELECT *
FROM staging.product_information
WHERE product_id <> TRIM(product_id);

SELECT *
FROM staging.product_information
WHERE product_name <> TRIM(product_name);

SELECT *
FROM staging.product_information
WHERE category_name <> TRIM(category_name);

SELECT *
FROM staging.product_information
WHERE launch_date <> TRIM(launch_date);

SELECT *
FROM staging.product_information
WHERE base_price <> TRIM(base_price);

SELECT *
FROM staging.product_information
WHERE supplier_code <> TRIM(supplier_code);


