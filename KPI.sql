-- Total Number of Orders
SELECT COUNT(order_id) AS total_orders
FROM orders
WHERE order_status = 'delivered';

-- Total Revenue
SELECT ROUND(SUM(price + freight_value), 2) AS total_revenue
FROM order_items;

--Total Number of Customers
SELECT COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;


--Total Number of Sellers
SELECT COUNT(DISTINCT seller_id) AS total_sellers
FROM sellers;


--Average Order Value (AOV)
SELECT ROUND(SUM(price + freight_value) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM order_items;


--Monthly Revenue Trend
SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
       ROUND(SUM(price + freight_value), 2) AS monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY month;


--Top 10 States by Revenue
SELECT c.customer_state,
       ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 10;


--Top 10 Product Categories by Revenue
SELECT p.product_category_name,
       ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;


--Top 10 Sellers by Revenue
SELECT s.seller_id,
       ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY total_revenue DESC
LIMIT 10;

--Average Delivery Time (Days)
SELECT ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 2) AS avg_delivery_days
FROM orders
WHERE order_status = 'delivered';

--Late Delivery Percentage
SELECT ROUND(
    SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) 
    * 100.0 / COUNT(*), 2
) AS late_delivery_percentage
FROM orders
WHERE order_status = 'delivered';

--Payment Method Usage
SELECT payment_type, COUNT(*) AS total_payments,
       ROUND(SUM(payment_value), 2) AS total_value
FROM order_payments
GROUP BY payment_type
ORDER BY total_value DESC;


--Review Score Distribution
SELECT review_score, COUNT(*) AS review_count
FROM order_reviews
GROUP BY review_score
ORDER BY review_score DESC;


--Orders with 1-Star Reviews
SELECT r.order_id, r.review_score, o.order_status
FROM order_reviews r
JOIN orders o ON r.order_id = o.order_id
WHERE r.review_score = 1;

--Repeat vs New Customers
SELECT 
    CASE WHEN order_count > 1 THEN 'Repeat' ELSE 'New' END AS customer_type,
    COUNT(*) AS customer_count
FROM (
    SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) t
GROUP BY customer_type;

--Revenue by Payment Installments
SELECT payment_installments,
       ROUND(SUM(payment_value), 2) AS total_revenue
FROM order_payments
GROUP BY payment_installments
ORDER BY total_revenue DESC;

-- Top 5 Products with Highest Freight Charges
SELECT p.product_category_name, oi.product_id,
       ROUND(SUM(oi.freight_value), 2) AS total_freight
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY oi.product_id, p.product_category_name
ORDER BY total_freight DESC
LIMIT 5;

--Top 5 Customers by Spending
SELECT c.customer_unique_id,
       ROUND(SUM(oi.price + oi.freight_value), 2) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 5;

--Monthly New Customer Count
SELECT DATE_FORMAT(MIN(o.order_purchase_timestamp), '%Y-%m') AS first_order_month,
       COUNT(DISTINCT c.customer_unique_id) AS new_customers
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY first_order_month
ORDER BY first_order_month;

--Correlation of Review Scores with Delivery Time
SELECT r.review_score,
       ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 2) AS avg_delivery_days
FROM order_reviews r
JOIN orders o ON r.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY r.review_score
ORDER BY r.review_score;
