This is the setup file of mysql database for the Ecommerce Analysis project.

CREATE DATABASE ecommerce;
USE ecommerce;
-- Create the database
CREATE DATABASE ecommerce;
USE ecommerce;

-- 1. Customers
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(50)
);

-- 2. Orders
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 3. Order Items
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

-- 4. Order Payments
CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);

-- 5. Order Reviews
CREATE TABLE order_reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATE,
    review_answer_timestamp DATETIME
);

-- 6. Products
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);
ALTER TABLE products
MODIFY idx INT FIRST;
Describe products


-- 7. Sellers
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(50)
);

-- 8. Geolocation
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL(10,6),
    geolocation_lng DECIMAL(10,6),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(50)
);

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, customer_id, order_status,
 @order_purchase_timestamp,
 @order_approved_at,
 @order_delivered_carrier_date,
 @order_delivered_customer_date,
 @order_estimated_delivery_date)
SET
 order_purchase_timestamp = NULLIF(@order_purchase_timestamp, ''),
 order_approved_at = NULLIF(@order_approved_at, ''),
 order_delivered_carrier_date = NULLIF(@order_delivered_carrier_date, ''),
 order_delivered_customer_date = NULLIF(@order_delivered_customer_date, ''),
 order_estimated_delivery_date = NULLIF(@order_estimated_delivery_date, '');
 
 
 

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, order_item_id, product_id, seller_id,
 shipping_limit_date, price, freight_value);
 
 
 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_payments_dataset.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, payment_sequential, payment_type, payment_installments, payment_value);




LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(idx, product_id, product_category_name,
 @product_name_length, @product_description_length, @product_photos_qty,
 @product_weight_g, @product_length_cm, @product_height_cm, @product_width_cm)
SET
 product_name_length = CASE WHEN TRIM(@product_name_length) REGEXP '^[0-9]+$' THEN @product_name_length ELSE NULL END,
 product_description_length = CASE WHEN TRIM(@product_description_length) REGEXP '^[0-9]+$' THEN @product_description_length ELSE NULL END,
 product_photos_qty = CASE WHEN TRIM(@product_photos_qty) REGEXP '^[0-9]+$' THEN @product_photos_qty ELSE NULL END,
 product_weight_g = CASE WHEN TRIM(@product_weight_g) REGEXP '^[0-9]+$' THEN @product_weight_g ELSE NULL END,
 product_length_cm = CASE WHEN TRIM(@product_length_cm) REGEXP '^[0-9]+$' THEN @product_length_cm ELSE NULL END,
 product_height_cm = CASE WHEN TRIM(@product_height_cm) REGEXP '^[0-9]+$' THEN @product_height_cm ELSE NULL END,
 product_width_cm = CASE WHEN TRIM(@product_width_cm) REGEXP '^[0-9]+$' THEN @product_width_cm ELSE NULL END;



INSERT INTO order_reviews
(review_id, order_id, review_score, review_comment_title,
 review_comment_message, review_creation_date, review_answer_timestamp)
SELECT
 review_id,
 order_id,
 review_score,
 review_comment_title,
 review_comment_message,
 STR_TO_DATE(review_creation_date, '%Y-%m-%d %H:%i:%s'),
 STR_TO_DATE(review_answer_timestamp, '%Y-%m-%d %H:%i:%s')
FROM order_reviews_staging;

 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(seller_id, seller_zip_code_prefix, seller_city, seller_state);


SELECT 
    'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 
    'geolocation', COUNT(*) FROM geolocation
UNION ALL
SELECT 
    'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 
    'order_payments', COUNT(*) FROM order_payments
UNION ALL
SELECT 
    'order_reviews', COUNT(*) FROM order_reviews
UNION ALL
SELECT 
    'orders', COUNT(*) FROM orders
UNION ALL
SELECT 
    'products', COUNT(*) FROM products
UNION ALL
SELECT 
    'sellers', COUNT(*) FROM sellers;
    
    
    
    
    
SELECT 
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT c.customer_unique_id) AS total_customers,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered';
    
