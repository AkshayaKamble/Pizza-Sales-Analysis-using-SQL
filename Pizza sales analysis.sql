-- 1) Total revenue
SELECT 
    ROUND(SUM(pizzas.price * order_details.quantity),
            2) AS Total_Revenue
FROM
    pizzas
        INNER JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id;


-- 2) Average order value

SELECT 
    ROUND(SUM(order_details.quantity * pizzas.Price) / COUNT(DISTINCT order_details.order_id),
            2) AS average_order
FROM
    order_details
        INNER JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;
    
    
   
-- 3) total pizzas sold

SELECT 
    SUM(order_details.quantity)
FROM
    order_details;
    
    
    
-- 4) Total orders

SELECT 
    COUNT(DISTINCT order_details.order_id) AS Total_Orders
FROM
    order_details;
    
    
    
-- 5) Average pizzas per order

SELECT 
    ROUND(SUM(order_details.quantity) / COUNT(DISTINCT order_details.order_id)) AS Average_Pizzas_per_order
FROM
    order_details;



-- 6) Daily trends or total orders (total nos of orders on a daily basis) 
 SELECT
    orders.order_date, 
    COUNT(DISTINCT orders.order_id) AS total_orders
FROM 
    orders
GROUP BY 
    orders.order_date
ORDER BY 
    orders.order_date;
    


-- 7) hourly trend of total orders

SELECT 
    HOUR(orders.order_time) AS hour,
    COUNT(DISTINCT order_details.order_id) AS order_count
FROM
    orders
        INNER JOIN
    order_details ON orders.order_id = order_details.order_id
GROUP BY HOUR(orders.order_time)
ORDER BY hour;



-- 8) Percentage of sales by pizza category
SELECT 
    pizza_types.category, 
    SUM(pizzas.price * order_details.quantity) AS category_sales,
round((SUM(pizzas.price * order_details.quantity) / 
    (SELECT SUM(pizzas.price * order_details.quantity) 
     FROM pizzas 
     INNER JOIN order_details ON pizzas.pizza_id = order_details.pizza_id)) * 100, 2) AS category_sales_percentage
FROM 
    order_details 
INNER JOIN 
    pizzas ON order_details.pizza_id = pizzas.pizza_id
INNER JOIN 
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id 
GROUP BY 
    pizza_types.category;    
    
    
    
-- 9) Percentage of pizza sales by size

SELECT 
    pizzas.size, 
    ROUND(SUM(order_details.quantity * pizzas.price), 2) AS pizza_size_sales,
    ROUND(
        (SUM(order_details.quantity * pizzas.price) / 
        (SELECT SUM(order_details.quantity * pizzas.price) 
         FROM pizzas 
         INNER JOIN order_details ON pizzas.pizza_id = order_details.pizza_id)
        ) * 100, 
    2) AS pizza_size_sales_percentage
FROM 
    pizzas
INNER JOIN 
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY 
    pizzas.size
ORDER BY 
    pizza_size_sales DESC;
    
    
-- 10) Total pizza sold by pizza category
SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS pizza_sold
FROM
    pizza_types
        INNER JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        INNER JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY pizza_sold DESC;


-- 11) Top 5 best sellers by total pizzas sold
SELECT 
    pizza_types.name,
    SUM(order_details.quantity) AS total_pizzas_sold
FROM
    pizza_types
        INNER JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        INNER JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY total_pizzas_sold DESC
LIMIT 5;



-- 12) Bottom 5 worst seller pizzas by total pizzas sold
SELECT 
    pizza_types.name,
    SUM(order_details.quantity) AS total_pizzas_sold
FROM
    pizza_types
        INNER JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        INNER JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY total_pizzas_sold ASC
LIMIT 5;