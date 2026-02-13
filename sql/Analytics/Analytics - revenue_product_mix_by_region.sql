CREATE TABLE analytics.revenue_product_mix_by_region AS
WITH base_sales AS (
	SELECT
        s.order_id,
        s.region,
        p.category_name,
        s.quantity,
        s.unit_price,
        s.quantity * s.unit_price * (1 - s.discount_applied) AS revenue
    FROM clean.sales_information s
	JOIN clean.product_information p
		ON s.product_id = p.product_id
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
		category_name,
		SUM(revenue) AS product_revenue
	FROM base_sales
	GROUP BY region, category_name
)

SELECT
    rp.region,
	rp.category_name,
    rp.product_revenue,
    r.total_revenue_region,
    rp.product_revenue * 1.0 / r.total_revenue_region 
        AS product_revenue_share
FROM sales_by_product_region rp
JOIN sales_by_region r
    ON rp.region = r.region
ORDER BY rp.region, product_revenue_share DESC;
