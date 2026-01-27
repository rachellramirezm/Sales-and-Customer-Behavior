CREATE TABLE analytics.revenue_product_mix_by_region AS
WITH base_sales AS (
	SELECT
        s.order_id,
        s.region,
        s.product_id,
        s.quantity,
        s.unit_price,
        s.quantity * s.unit_price AS revenue
    FROM clean.sales_information s
    WHERE s.delivery_status = 'delivered'
),

sales_by_region AS (
	SELECT
		region,
		SUM(revenue) AS total_revenue_region
	FROM base_sales
	GROUP BY region
),

sales_by_product_region AS (
	SELECT
		region,
		product_id,
		SUM(revenue) AS product_revenue
	FROM base_sales
	GROUP BY region, product_id
)

SELECT
    rp.region,
    rp.product_id,
    rp.product_revenue,
    r.total_revenue_region,
    rp.product_revenue * 1.0 / r.total_revenue_region 
        AS product_revenue_share
FROM sales_by_product_region rp
JOIN sales_by_region r
    ON rp.region = r.region
ORDER BY rp.region, product_revenue_share DESC;
