/*
----------------------------------------------------------------------------------------------------
TABLE: analytics.revenue_contribution_by_frequency_segment
----------------------------------------------------------------------------------------------------
DESCRIPTION:
This table calculates the revenue contribution by customer purchase frequency segment. It 
categorizes customers into single-purchase and multiple-purchase segments and quantifies 
their respective contribution to total revenue. This helps identify the importance of 
recurring customers for business revenue sustainability.

LOGIC & STEPS:

1. CTE: base_sales
   - Filters only delivered orders to ensure valid revenue.
   - Calculates revenue per transaction: quantity * unit_price adjusted by discount.

2. CTE: customer_metrics
   - Aggregates order count and total revenue per customer.

3. CTE: customer_segment
   - Segments customers based on purchase frequency:
       - 'single_purchase' for customers with 1 order.
       - 'multiple_purchases' for customers with more than 1 order.

4. CTE: segment_revenue
   - Aggregates total revenue per purchase frequency segment.

5. FINAL SELECT
   - Outputs purchase_segment, segment_revenue, and revenue_proportion (share of total revenue per segment).

INSIGHTS:
- Quantifies how much revenue comes from recurring versus one-time customers.
- Highlights the critical role of multiple-purchase customers for revenue growth and retention strategy.
----------------------------------------------------------------------------------------------------
*/

CREATE TABLE analytics.revenue_contribution_by_frequency_segment AS
WITH base_sales AS (
	SELECT
		customer_id,
		order_id,
		quantity * unit_price * (1 - discount_applied) AS revenue
	FROM clean.sales_information
	WHERE delivery_status = 'delivered'
),
customer_metrics AS (
	SELECT
		customer_id,
		COUNT(DISTINCT order_id) AS order_count,
		SUM(revenue) AS customer_revenue
	FROM base_sales
	GROUP BY customer_id
),
customer_segment AS (
	SELECT
		customer_id,
		customer_revenue,
		CASE
			WHEN order_count = 1 THEN 'single_purchase'
			ELSE 'multiple_purchases'
		END AS purchase_segment
	FROM customer_metrics
),
segment_revenue AS (
	SELECT
		purchase_segment,
		SUM(customer_revenue) AS segment_revenue
	FROM customer_segment
	GROUP BY purchase_segment
)


SELECT
	purchase_segment,
	segment_revenue,
	segment_revenue / SUM(segment_revenue) OVER() AS revenue_proportion
FROM segment_revenue


