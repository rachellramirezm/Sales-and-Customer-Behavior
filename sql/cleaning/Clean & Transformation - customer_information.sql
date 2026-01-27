-- 1. CREAT CLEAN SCHEMA IF NOT EXISTS
CREATE SCHEMA IF NOT EXISTS clean;

-- 2. CREATE BACKUP TABLE FOR RAW DATA
CREATE TABLE clean.customer_information_backup AS
SELECT *
FROM staging.customer_information
WHERE customer_id IS NULL OR email IS NULL OR signup_date IS NULL OR region IS NULL;

-- 3. CREATE CLEAN TABLE
CREATE TABLE clean.customer_information AS
WITH raw_customer_information AS (
	SELECT *
	FROM staging.customer_information
),
standardized AS (
	SELECT
		NULLIF(LOWER(TRIM(customer_id)), '') AS customer_id,
        NULLIF(LOWER(TRIM(email)), '') AS email,
		signup_date::DATE AS signup_date,
		CASE
			WHEN gender IS NULL THEN 'unknown'
			WHEN UPPER(gender) IN ('FEMLE', 'FEMALE','FEMALE') THEN 'female'
			WHEN UPPER(gender) IN ('MALE') THEN 'male'
			ELSE 'other'
		END AS gender,
		CASE
			WHEN region IS NULL THEN 'unknown'
			WHEN UPPER(region) IN ('EAST') THEN 'east'
			WHEN UPPER(region) IN ('NORTH') THEN 'north'
			WHEN UPPER(region) IN ('WEST') THEN 'west'
			WHEN UPPER(region) IN ('SOUTH') THEN 'south'
			WHEN UPPER(region) IN ('CENTRAL') THEN 'central'	
		END AS region,
		CASE
			WHEN loyalty_tier IS NULL THEN NULL
			WHEN UPPER(TRIM(loyalty_tier)) IN ('GOLD', 'GLD') THEN 'gold'
			WHEN UPPER(TRIM(loyalty_tier)) IN ('SILVER', 'SLLVER') THEN 'silver'
			WHEN UPPER(TRIM(loyalty_tier)) IN ('BRONZE', 'BRNZE') THEN 'bronze'
		END AS loyalty_tier
	FROM raw_customer_information
),
valid_records AS(
	SELECT *
	FROM standardized
	WHERE customer_id IS NOT NULL 
	AND email IS NOT NULL
	AND signup_date IS NOT NULL 
)

SELECT *
FROM valid_records




