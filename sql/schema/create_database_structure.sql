
/*
First, create the database with this script "CREATE DATABASE sales_and_customer_behavior", then connect to the previously created database and run this script.
*/
CREATE SCHEMA IF NOT EXISTS staging; --Create schema to work in layers

--Table: staging.product_information
CREATE TABLE staging.product_information (
    product_id TEXT,
    product_name TEXT,
    category_name TEXT,
    launch_date TEXT,
    base_price TEXT,
    supplier_code TEXT
);

CREATE TABLE staging.customer_information (
    customer_id TEXT,
    email TEXT,
    signup_date TEXT,
    gender TEXT,
    region TEXT,
    loyalty_tier TEXT
);

CREATE TABLE staging.sales_information (
    order_id TEXT,
    customer_id TEXT,
    product_id TEXT,
    quantity TEXT,
    unit_price TEXT,
    order_date TEXT,
    delivery_status TEXT,
    payment_method TEXT,
    region TEXT,
    discount_applied TEXT
);
