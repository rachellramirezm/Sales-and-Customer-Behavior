CREATE TABLE modeling.dim_customer AS
SELECT
    ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key,
    customer_id,
    email,
    gender,
    region AS customer_region,
    loyalty_tier,
    signup_date
FROM clean.customer_information;
