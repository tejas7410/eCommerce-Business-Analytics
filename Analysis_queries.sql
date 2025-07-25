-- Revenue Contribution by Top 5 Categories
SELECT p.product_category_name,
       ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
       ROUND(100 * SUM(oi.price + oi.freight_value) / 
              (SELECT SUM(price + freight_value) FROM order_items), 2) AS revenue_percentage
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Customers with More Than 5 Orders
SELECT c.customer_unique_id,
       COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 5
ORDER BY total_orders DESC;

-- Top 10 Cities by Order Volume
SELECT c.customer_city,
       COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_city
ORDER BY total_orders DESC
LIMIT 10;

-- Most Frequently Canceled Products
SELECT p.product_category_name,
       COUNT(o.order_id) AS canceled_orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'canceled'
GROUP BY p.product_category_name
ORDER BY canceled_orders DESC
LIMIT 5;

--Average Revenue per Customer (ARPC)
SELECT ROUND(SUM(oi.price + oi.freight_value) / COUNT(DISTINCT c.customer_unique_id), 2) AS avg_revenue_per_customer
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

-- Delivery Performance by State
SELECT c.customer_state,
       ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 2) AS avg_delivery_days
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC;


--Sellers with the Most Returns or Cancellations
SELECT s.seller_id,
       COUNT(o.order_id) AS canceled_orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN sellers s ON oi.seller_id = s.seller_id
WHERE o.order_status = 'canceled'
GROUP BY s.seller_id
ORDER BY canceled_orders DESC
LIMIT 5;

--Month-over-Month Revenue Growth (%)
SELECT month,
       ROUND((monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month)) * 100 / 
              LAG(monthly_revenue) OVER (ORDER BY month), 2) AS growth_percentage
FROM (
    SELECT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
           SUM(oi.price + oi.freight_value) AS monthly_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
) t;


--Peak Order Hours
SELECT HOUR(order_purchase_timestamp) AS order_hour,
       COUNT(order_id) AS total_orders
FROM orders
GROUP BY HOUR(order_purchase_timestamp)
ORDER BY total_orders DESC;


-- Average Review Score by Product Category

SELECT p.product_category_name,
       ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM order_reviews r
JOIN orders o ON r.order_id = o.order_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY avg_review_score DESC;
