/*
----------------------------------------------------------------------------------------------------
TABLE: analytics.total_revenue_by_customer_segment
----------------------------------------------------------------------------------------------------
DESCRIPTION:
This table calculates total revenue by customer segment, defined by gender and loyalty tier. 
It helps identify which customer groups contribute the most to revenue, supporting targeted 
marketing, loyalty programs, and strategic business decisions.

LOGIC & STEPS:

1. CTE: daily_sales
   - Aggregates revenue per customer from delivered orders: quantity * unit_price.

2. CTE: customer_segments
   - Extracts customer demographic and loyalty information (gender, loyalty_tier).

3. CTE: sales_with_segments
   - Joins customer revenue with segment information to associate each sale with the corresponding segment.

4. FINAL SELECT
   - Aggregates total revenue by gender and loyalty tier.
   - Orders results by descending revenue to highlight the most valuable customer segments.

INSIGHTS:
- Reveals which combinations of gender and loyalty tier generate the highest revenue.
- Supports segmentation-driven marketing, retention strategies, and resource allocation.
----------------------------------------------------------------------------------------------------
*/

CREATE TABLE analytics.Total_revenue_by_customer_segment AS
WITH daily_sales AS (
	SELECT
		c.customer_id,
		SUM(s.quantity * s.unit_price * (1 - discount_applied)) AS revenue
	FROM clean.sales_information s
	JOIN clean.customer_information c
		ON s.customer_id = c.customer_id
	WHERE s.delivery_status = 'delivered'
	GROUP BY c.customer_id
),
customer_segments AS (
	SELECT 
		customer_id,
		gender,
		loyalty_tier
	FROM clean.customer_information
),
sales_with_segments AS (
	SELECT
		c.gender,
		c.loyalty_tier,
		d.revenue
	FROM daily_sales AS d
	JOIN customer_segments as c
		ON d.customer_id = c.customer_id
)

SELECT
	gender,
	loyalty_tier,
	SUM(revenue) AS total_revenue
FROM sales_with_segments
GROUP BY gender, loyalty_tier
ORDER BY gender, total_revenue DESC
