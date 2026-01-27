CREATE TABLE analytics.revenue_share_top_x_percent_customers AS
WITH base_sales AS (
    SELECT
        s.customer_id,
        s.product_id,
        s.quantity * s.unit_price AS revenue
    FROM clean.sales_information s
    WHERE s.delivery_status = 'delivered'
),
customer_revenue AS (
    SELECT
        customer_id,
        SUM(revenue) AS total_revenue
    FROM base_sales
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT
        customer_id,
        total_revenue,
        NTILE(100) OVER (ORDER BY total_revenue DESC) AS percentile_rank
    FROM customer_revenue
),
top_customers AS (
    SELECT customer_id, total_revenue
    FROM ranked_customers
    WHERE percentile_rank <= 10  -- top 10% of customers
),
top_customers_revenue AS (
    SELECT SUM(b.revenue) AS top_revenue
    FROM base_sales b
    JOIN top_customers t
      ON b.customer_id = t.customer_id
),
total_revenue AS (
    SELECT SUM(revenue) AS total_revenue FROM base_sales
)
SELECT 
    t.top_revenue,
    tt.total_revenue,
    t.top_revenue / tt.total_revenue AS share_of_total
FROM top_customers_revenue t
CROSS JOIN total_revenue tt;
