CREATE TABLE modeling.fact_sales AS
SELECT
    ROW_NUMBER() OVER () AS sales_key,
    dd.date_key,
    dp.product_key,
    dc.customer_key,
    dr.region_key,
    dpm.payment_key,
    s.order_id,
    s.quantity,
    s.unit_price,
    (s.quantity * s.unit_price) AS total_amount,
    s.discount_applied,
    s.delivery_status
FROM clean.sales_information s
LEFT JOIN modeling.dim_date dd
       ON s.order_date = dd.full_date
LEFT JOIN modeling.dim_product dp
       ON s.product_id = dp.product_id
LEFT JOIN modeling.dim_customer dc
       ON s.customer_id = dc.customer_id
LEFT JOIN modeling.dim_region dr
       ON s.region = dr.sales_region
LEFT JOIN modeling.dim_payment_method dpm
       ON s.payment_method = dpm.payment_method;
