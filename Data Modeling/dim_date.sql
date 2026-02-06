CREATE TABLE modeling.dim_date AS
SELECT DISTINCT
	TO_CHAR(d::date, 'YYYYMMDD'):: INT AS date_key,
	d::date AS full_date,
	EXTRACT(DAY FROM d) AS day,
	EXTRACT(MONTH FROM d) AS month,
	EXTRACT(YEAR FROM d) AS year,
	EXTRACT(QUARTER FROM d) AS quarter
FROM (
	SELECT
		order_date AS d 
	FROM clean.sales_information
	UNION
	SELECT
		signup_date 
	FROM clean.customer_information
	UNION
	SELECT 
		launch_date
	FROM clean.product_information
) t;
	


