CREATE TABLE modeling.dim_product AS
SELECT
    ROW_NUMBER() OVER (ORDER BY product_id) AS product_key,
    product_id,
    product_name,
    category_name,
    launch_date,
    base_price,
    supplier_code
FROM clean.product_information;
