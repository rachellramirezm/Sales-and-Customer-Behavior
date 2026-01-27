-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: order_id
-- Rule: order_id must not be NULL
-- Expected result: 0 records with NULL values (1)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(order_id) AS not_null_records,
	COUNT(*) - COUNT(order_id) AS null_records,
	ROUND(
		(COUNT(*) - COUNT(order_id)) * 100.00 / COUNT(*), 2
	)AS null_porcentage
FROM staging.sales_information 

-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: customer_id
-- Rule: customer_id must not be NULL
-- Expected result: 0 records with NULL values (2)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(customer_id) AS not_null_records,
	COUNT(*) - COUNT(customer_id) AS null_records,
	ROUND(
		(COUNT(*) - COUNT(customer_id)) * 100.00 / COUNT(*), 2
	)AS null_porcentage
FROM staging.sales_information 

-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: product_id
-- Rule: product_id must not be NULL
-- Expected result: 0 records with NULL values (5)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(product_id) AS not_null_records,
	COUNT(*) - COUNT(product_id) AS null_records,
	ROUND(
		(COUNT(*) - COUNT(product_id)) * 100.00 / COUNT(*), 2
	)AS null_porcentage
FROM staging.sales_information 

-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: quantity
-- Rule: quantity must not be NULL
-- Expected result: 0 records with NULL values (3)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(quantity) AS not_null_records,
	COUNT(*) - COUNT(quantity) AS null_records,
	ROUND(
		(COUNT(*) - COUNT(quantity)) * 100.00 / COUNT(*), 2
	)AS null_porcentage
FROM staging.sales_information 

-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: unit_price
-- Rule: unit_price must not be NULL
-- Expected result: 0 records with NULL values (1)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(unit_price) AS not_null_records,
	COUNT(*) - COUNT(unit_price) AS null_records,
	ROUND(
		(COUNT(*) - COUNT(unit_price)) * 100.00 / COUNT(*), 2
	)AS null_porcentage
FROM staging.sales_information

-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: order_date
-- Rule: order_date must not be NULL
-- Expected result: 0 records with NULL values (3)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(order_date) AS not_null_records,
	COUNT(*) - COUNT(order_date) AS null_records,
	ROUND(
		(COUNT(*) - COUNT(order_date)) * 100.00 / COUNT(*), 2
	)AS null_porcentage
FROM staging.sales_information --3

-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: delivery_status
-- Rule: delivery_status must not be NULL
-- Expected result: 0 records with NULL values (3)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(delivery_status) AS not_null_records,
	COUNT(*) - COUNT(delivery_status) AS null_records,
	ROUND(
		(COUNT(*) - COUNT(delivery_status)) * 100.00 / COUNT(*), 2
	)AS null_porcentage
FROM staging.sales_information 


-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: payment_method
-- Rule: payment_method must not be NULL
-- Expected result: 0 records with NULL values (3)
-- =====================================================

SELECT
	COUNT(*) AS total_records,
	COUNT(payment_method) AS not_null_records,
	COUNT(*) - COUNT(payment_method) AS null_records,
	ROUND(
		(COUNT(*) - COUNT(payment_method)) * 100.00 / COUNT(*), 2
	)AS null_porcentage
FROM staging.sales_information 


-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: region
-- Rule: region must not be NULL
-- Expected result: 0 records with NULL values (0)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(region) AS not_null_records,
	COUNT(*) - COUNT(region) AS null_records,
	ROUND(
		(COUNT(*) - COUNT(region)) * 100.00 / COUNT(*), 2
	)AS null_porcentage
FROM staging.sales_information --0


-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: discount_applied
-- Rule: discount_applied must be NULL
-- Expected result: 0 records with NULL values (517)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(discount_applied) AS not_null_records,
	COUNT(*) - COUNT(discount_applied) AS null_records,
	ROUND(
		(COUNT(*) - COUNT(discount_applied)) * 100.00 / COUNT(*), 2
	)AS null_porcentage
FROM staging.sales_information 

-- =====================================================
-- Data Quality Validation: Uniqueness
-- Field evaluated: order_id
-- Rule: order_id must be unique
-- Expected result: 0 duplicate records
-- Result: 2 records returned
-- Duplicate values identified: "O916245", "O515400"
-- =====================================================
SELECT
	order_id,
	COUNT(*) AS repetition
FROM staging.sales_information
GROUP BY order_id
HAVING COUNT(*) > 1;


-- =====================================================
-- Data Quality Check: Quantity Numeric Validation
-- Description: Detect non-numeric values in quantity field
-- Expected: 0 records returned
-- Result: 2 records returned
-- Invalid values identified: 'five', 'three'
-- =====================================================
SELECT
  order_id,
  quantity,
  COUNT(*) AS occurrences
FROM staging.sales_information
WHERE quantity !~ '^-?[0-9]+$'
GROUP BY quantity,order_id
ORDER BY occurrences DESC;

-- =====================================================
-- Data Quality Validation: Validity
-- Field evaluated: base_price
-- Rule: base_price must be greater than 0
-- Expected result: 0 invalid records
-- =====================================================
SELECT
	CAST(unit_price AS NUMERIC),
	COUNT(*) AS records
FROM staging.sales_information
WHERE CAST(unit_price AS NUMERIC) <= 0
GROUP BY unit_price --0


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
SELECT order_date
FROM staging.sales_information
WHERE order_date ~ '^\d{2}-\d{2}-\d{2}$'
  AND (
    SUBSTRING(order_date, 1, 2)::int > 31 OR
    SUBSTRING(order_date, 4, 2)::int > 12
  ); 

-- =====================================================
-- Data Quality Validation: Domain Consistency
-- Field evaluated: delivery_status
-- Rule: gender values must belong to a predefined domain
-- Accepted values: 'delivered', 'cancelled', 'delayed'
-- Expected result: 0 records with values outside the accepted domain
-- =====================================================
SELECT
	DISTINCT delivery_status,
	COUNT(*) AS records
FROM staging.sales_information
GROUP BY delivery_status
ORDER BY COUNT(*) DESC

-- =====================================================
-- Data Quality Validation: Domain Consistency
-- Field evaluated: payment_method
-- Rule: gender values must belong to a predefined domain
-- Accepted values: 'bank transfer', 'paypal', 'credit card'
-- Expected result: 0 records with values outside the accepted domain
-- =====================================================
SELECT
	DISTINCT payment_method,
	COUNT(*) AS records
FROM staging.sales_information
GROUP BY payment_method
ORDER BY COUNT(*) DESC

-- =====================================================
-- Data Quality Validation: Domain Consistency
-- Field evaluated: region
-- Rule: gender values must belong to a predefined domain
-- Accepted values: 'north', 'central', 'east', 'south', 'west'
-- Expected result: 0 records with values outside the accepted domain
-- =====================================================
SELECT
	DISTINCT region,
	COUNT(*) AS records
FROM staging.sales_information
GROUP BY region
ORDER BY COUNT(*) DESC


-- =====================================================
-- Data Quality Validation: Validity
-- Field evaluated: discount_applied
-- Rule: discount_applied must be greater than 0
-- Expected result: 0 invalid records
-- =====================================================
SELECT
	CAST(discount_applied AS NUMERIC),
	COUNT(*) AS records
FROM staging.sales_information
WHERE CAST(discount_applied AS NUMERIC) < 0
GROUP BY discount_applied 

-- =====================================================
-- Data Quality Validation: Consistency (Referential Integrity)
-- Field evaluated: sales_information.orden_id
-- Reference table: customer_information.customer_id
-- Rule: Each sale must be associated with a valid product
-- Expected result: 0 orphan records
-- =====================================================
SELECT
	s.order_id,
	s.customer_id
FROM staging.sales_information s
LEFT JOIN staging.customer_information c
	ON s.customer_id = c.customer_id
WHERE s.customer_id IS NULL

-- =====================================================
-- Data Quality Validation: Consistency (Referential Integrity)
-- Field evaluated: sales_information.order_id
-- Reference table: product_information.product_id
-- Rule: Each sale must be associated with a valid product
-- Expected result: 0 orphan records
-- =====================================================
SELECT
	s.order_id,
	s.product_id
FROM staging.sales_information s
LEFT JOIN staging.product_information p
	ON s.product_id = p.product_id
WHERE p.product_id IS NULL

SELECT *
FROM staging.sales_information
WHERE delivery_status <> TRIM(delivery_status)


	

