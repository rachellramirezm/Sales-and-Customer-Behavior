/*
----------------------------------------------------------------------------------------------------
TABLE: analytics.customer_revenue_metrics_by_loyalty_tier
----------------------------------------------------------------------------------------------------
DESCRIPTION:
This table calculates revenue metrics by customer loyalty tier. It summarizes total revenue, 
total orders, and average order value (AOV) for each tier, providing insights into spending 
patterns of different loyalty groups and informing retention and marketing strategies.

LOGIC & STEPS:

1. CTE: base_orders
   - Joins sales and customer information.
   - Filters only delivered orders to ensure valid revenue.
   - Retains customer loyalty tier for segmentation.

2. CTE: daily_sales
   - Calculates revenue per order: quantity * unit_price.

3. CTE: revenue_by_loyalty_tier
   - Aggregates total revenue and total orders by loyalty tier.

4. FINAL SELECT
   - Outputs loyalty_tier, total_revenue, total_orders, and average order value (total_revenue / total_orders).

INSIGHTS:
- Highlights the revenue contribution of each loyalty tier.
- Shows which customer segments generate higher AOV.
- Supports loyalty program evaluation, pricing strategies, and marketing focus.
----------------------------------------------------------------------------------------------------
*/

CREATE TABLE analytics.customer_revenue_metrics_by_loyalty_tier AS
WITH base_orders AS (
	SELECT
		s.order_id,
		s.customer_id,
		s.quantity,
		s.unit_price,
		c.loyalty_tier,
		s.delivery_status
	FROM clean.sales_information s
	JOIN clean.customer_information c
		ON s.customer_id = c.customer_id
	WHERE delivery_status = 'delivered'
),
daily_sales AS (
	SELECT
        order_id,
        loyalty_tier,
        quantity * unit_price AS revenue
    FROM base_orders
),
revenue_by_loyalty_tier AS(
	SELECT
		loyalty_tier,
		SUM(revenue) AS total_revenue,
		COUNT(DISTINCT order_id) AS total_orders
	FROM daily_sales
	GROUP BY loyalty_tier
)

SELECT
	loyalty_tier,
	total_revenue,
	total_orders,
	total_revenue / total_orders AS avg_order_value
FROM revenue_by_loyalty_tier