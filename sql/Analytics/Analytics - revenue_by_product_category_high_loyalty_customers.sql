CREATE TABLE analytics.revenue_by_product_category_high_loyalty_customers AS
WITH base_sales AS (
    SELECT
        s.customer_id,
        s.quantity,
        s.unit_price,
        p.category_name,
        c.loyalty_tier,
        s.quantity * s.unit_price * (1 - discount_applied) AS revenue
    FROM clean.sales_information s
    JOIN clean.customer_information c
        ON s.customer_id = c.customer_id
    JOIN clean.product_information p
        ON p.product_id = s.product_id
    WHERE s.delivery_status = 'delivered'    
),
sales_by_category AS (
    SELECT
        category_name,
        SUM(revenue) AS category_revenue
    FROM base_sales
    WHERE loyalty_tier = 'gold'
    GROUP BY category_name
)

SELECT
    category_name,
    category_revenue
FROM sales_by_category
ORDER BY category_revenue DESC;
