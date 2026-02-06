CREATE TABLE modeling.dim_region AS
SELECT DISTINCT
    ROW_NUMBER() OVER (ORDER BY region) AS region_key,
    region AS sales_region
FROM(
	SELECT DISTINCT region
	FROM clean.sales_information
	WHERE region IS NOT NULL
) 


