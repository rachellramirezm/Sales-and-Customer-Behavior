CREATE TABLE modeling.dim_payment_method AS
SELECT DISTINCT
    ROW_NUMBER() OVER (ORDER BY payment_method) AS payment_key,
    payment_method
FROM clean.sales_information;
