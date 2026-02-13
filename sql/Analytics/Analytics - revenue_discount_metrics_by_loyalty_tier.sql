CREATE TABLE analytics.revenue_discount_metrics_by_loyalty_tier AS
WITH base_sales AS (
    SELECT 
        s.order_id,
        s.customer_id,
        c.loyalty_tier,
        s.quantity,
        s.unit_price,
        s.discount_applied,
        s.quantity * s.unit_price AS revenue,
        CASE 
            WHEN s.discount_applied > 0 THEN 1 
            ELSE 0 
        END AS is_discounted
    FROM clean.sales_information s
    JOIN clean.customer_information c
        ON s.customer_id = c.customer_id
    WHERE s.delivery_status = 'delivered'
), 
aggregated_metrics AS (
    SELECT
        loyalty_tier,
        SUM(revenue) AS total_revenue,
        SUM(
            CASE 
                WHEN is_discounted = 1 THEN revenue 
                ELSE 0 
            END
        ) AS discounted_revenue
    FROM base_sales
    GROUP BY loyalty_tier
)
SELECT
    loyalty_tier,
    discounted_revenue,
    total_revenue,
    discounted_revenue * 1.0 / total_revenue 
        AS discounted_revenue_ratio,
    SUM(discounted_revenue) OVER () * 1.0 
        / SUM(total_revenue) OVER () 
        AS overall_discounted_revenue_ratio
FROM aggregated_metrics
ORDER BY loyalty_tier;
