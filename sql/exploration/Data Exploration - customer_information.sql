-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: customer_id
-- Rule: customer_id must not be NULL
-- Expected result: 0 records with NULL values (3)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(customer_id) AS records_not_null,
	COUNT(*) - COUNT(customer_id) as Null_record,
	ROUND(
		(COUNT(*) - COUNT(customer_id)) * 100.0 / COUNT(*), 2
	)AS Null_percentage
FROM staging.customer_information

-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: email
-- Rule: email must not be NULL
-- Expected result: 0 records with NULL values (6)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(email) AS records_not_null,
	COUNT(*) - COUNT(email) as Null_record,
	ROUND(
		(COUNT(*) - COUNT(email)) * 100.0 / COUNT(*), 2
	)AS Null_percentage
FROM staging.customer_information


-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: signup_date
-- Rule: signup_date must not be NULL
-- Expected result: 0 records with NULL values (4)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(signup_date) AS records_not_null,
	COUNT(*) - COUNT(signup_date) as Null_record,
	ROUND(
		(COUNT(*) - COUNT(signup_date)) * 100.0 / COUNT(*), 2
	)AS Null_percentage
FROM staging.customer_information


-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: gender
-- Rule: gender must not be NULL
-- Expected result: 0 records with NULL values (4)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(gender) AS records_not_null,
	COUNT(*) - COUNT(gender) as Null_record,
	ROUND(
		(COUNT(*) - COUNT(gender)) * 100.0 / COUNT(*), 2
	)AS Null_percentage
FROM staging.customer_information


-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: region
-- Rule: region must not be NULL
-- Expected result: 0 records with NULL values (3)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(region) AS records_not_null,
	COUNT(*) - COUNT(region) AS null_records,
	ROUND(
		(COUNT(*) - COUNT(region)) * 100.00 / COUNT(*), 2
	)AS null_percentage
FROM staging.customer_information


-- =====================================================
-- Data Quality Validation: Completeness
-- Field evaluated: loyalty_tier
-- Rule: loyalty_tier must not be NULL
-- Expected result: 0 records with NULL values (2)
-- =====================================================
SELECT
	COUNT(*) AS total_records,
	COUNT(loyalty_tier) AS records_not_null,
	COUNT(*) - COUNT(loyalty_tier) AS null_records,
	ROUND(
		(COUNT(*) - COUNT(loyalty_tier)) * 100.00 / COUNT(*), 2
	)AS null_percentage
FROM staging.customer_information


-- =====================================================
-- Data Quality Validation: Uniqueness
-- Field evaluated: customer_id
-- Rule: customer_id must be unique
-- Expected result: 0 duplicate records (3 records null but no repeted)
-- =====================================================
SELECT
	customer_id,
	COUNT(*) AS repetition
FROM staging.customer_information
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- =====================================================
-- Data Quality Validation: Uniqueness
-- Field evaluated: email
-- Rule: email must be unique
-- Expected result: 0 duplicate records (6 records null but no repeted)
-- =====================================================
SELECT
	email,
	COUNT(*) AS repetition
FROM staging.customer_information
GROUP BY email
HAVING COUNT(*) > 1;


-- =====================================================
-- Data Quality Validation: Domain Consistency
-- Field evaluated: gender
-- Rule: gender values must belong to a predefined domain
-- Accepted values: 'male', 'female', 'unknown', 'other'
-- Expected result: 0 records with values outside the accepted domain
-- =====================================================
SELECT
	gender,
	COUNT(*)
FROM staging.customer_information
GROUP BY gender
ORDER BY COUNT(*) DESC


-- =====================================================
-- Data Quality Validation: Domain Consistency
-- Field evaluated: region
-- Rule: gender values must belong to a predefined domain
-- Accepted values: 'east', 'north', 'west', 'south', 'central', 'unknown'
-- Expected result: 0 records with values outside the accepted domain
-- =====================================================
SELECT
	region,
	COUNT(*)
FROM staging.customer_information
GROUP BY region
ORDER BY COUNT(*) DESC


-- =====================================================
-- Data Quality Validation: Domain Consistency
-- Field evaluated: loyalty_tier
-- Rule: gender values must belong to a predefined domain
-- Accepted values: 'gold', 'silver', 'bronze'
-- Expected result: 0 records with values outside the accepted domain
-- =====================================================
SELECT
	loyalty_tier,
	COUNT(*)
FROM staging.customer_information
GROUP BY loyalty_tier
ORDER BY COUNT(*) DESC


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
SELECT signup_date
FROM staging.customer_information
WHERE signup_date ~ '^\d{2}-\d{2}-\d{2}$'
  AND (
    SUBSTRING(signup_date, 1, 2)::int > 31 OR
    SUBSTRING(signup_date, 4, 2)::int > 12
  );

-- =====================================================
-- Data Quality Validation: Email Domain Consistency
-- Field evaluated: email
-- Rule: email domain must follow valid domain structure
-- Validation method:
--   - domain extracted using SPLIT_PART(email, '@', 2)
--   - domain must contain a valid TLD
--   - no placeholder or test domains detected
-- Result:
--   - All domains observed are syntactically valid
--   - No invalid or placeholder domains found
-- Conclusion:
--   - Email domain quality PASSED
-- =====================================================

SELECT 
	SPLIT_PART(email,'@',2) AS email_domain,
	COUNT(*) AS total_records
FROM staging.customer_information
WHERE email IS NOT NULL
GROUP BY email_domain
ORDER BY total_records DESC;


--Check space in blanck(everything good)
SELECT *
FROM staging.customer_information
WHERE customer_id <> TRIM(customer_id);

SELECT *
FROM staging.customer_information
WHERE email <> TRIM(email);

SELECT *
FROM staging.customer_information
WHERE signup_date <> TRIM(signup_date);

SELECT *
FROM staging.customer_information
WHERE gender <> TRIM(gender);

SELECT *
FROM staging.customer_information
WHERE region <> TRIM(region);

SELECT *
FROM staging.customer_information
WHERE loyalty_tier <> TRIM(loyalty_tier); --quitar espacios 