-- Relative proportions of bike categories sold in each state

WITH prods AS (
	SELECT *
	FROM products
	JOIN brands USING(brand_id)
	JOIN categories USING(category_id)
	),
	ords AS (
	SELECT *
	FROM orders
	JOIN customers USING(customer_id)
	JOIN order_items USING(order_id)
	),
	cnts_all AS (
	SELECT state, COUNT(*) AS cnt_all
	FROM prods
	JOIN ords USING(product_id)
	GROUP BY state
	),
	cnts_state AS (
	SELECT state, category_name, COUNT(*) AS cnt_st
	FROM prods
	JOIN ords USING(product_id)
	GROUP BY state, category_name			
	)	
SELECT
	state AS State,
	category_name AS Category,
	ROUND(cnt_st/cnt_all::NUMERIC*100)||'%' AS Proportion
FROM cnts_state 
LEFT JOIN cnts_all USING(state)
ORDER BY State, ROUND(cnt_st/cnt_all::NUMERIC*100) DESC



-- Proportions and counts of delayed shipments for each bike store,
-- along with average delay time in hours

WITH delays AS (
	SELECT
		order_id,
		CASE WHEN required_date < shipped_date THEN 1 ELSE 0 END AS del_bool,
		CASE WHEN required_date < shipped_date THEN shipped_date::DATE - required_date::DATE 
			ELSE 0 END AS del_days
	FROM orders
	JOIN stores USING(store_id)
	WHERE order_status = 4
	)
SELECT 
	store_name AS Store,
	ROUND(SUM(del_bool)/COUNT(*)::NUMERIC*100,1)||'%' AS Proportion_Of_Delayed_Shipments,
	SUM(del_bool) AS Number_Of_Delayed_Shipments,
	ROUND(AVG(del_days)*24) AS Average_Delay_In_Hours
FROM orders
JOIN delays USING(order_id)
JOIN stores USING(store_id)
GROUP BY store_name;



-- Which product categories are sold by which brands,
-- and what are the average prices for products from these categories within specific brands

SELECT
	brand,
	SUM(CASE WHEN category = 'Children Bicycles' THEN Average_Price ELSE NULL END) AS Children_Bicycles,
	SUM(CASE WHEN category = 'Comfort Bicycles' THEN Average_Price ELSE NULL END) AS Comfort_Bicycles,
	SUM(CASE WHEN category = 'Cyclocross Bicycles' THEN Average_Price ELSE NULL END) AS Cyclocross_Bicycles,
	SUM(CASE WHEN category = 'Electric Bikes' THEN Average_Price ELSE NULL END) AS Electric_Bikes,
	SUM(CASE WHEN category = 'Mountain Bikes' THEN Average_Price ELSE NULL END) AS Mountain_Bikes,
	SUM(CASE WHEN category = 'Road Bikes' THEN Average_Price ELSE NULL END) AS Road_Bikes
FROM (SELECT brand_name AS Brand, category_name AS Category, ROUND(avg(list_price)) AS Average_Price
	FROM products
	JOIN brands USING(brand_id)
	JOIN categories USING(category_id)
	GROUP BY brand_name, category_name) AS temp_tbl
GROUP BY Brand;



-- Mean shipping time (in hours) between each store and customers cities,
-- displayed in form of 3 store-city combinations with shortest time of delivery
-- and 3 store-city combinations with longest time of delivery

WITH ship_times AS(
	SELECT
		store_name AS store,
		c.city AS cust_location,
		ROUND(AVG(shipped_date::DATE - order_date::DATE)*24) AS shipping_time
	FROM orders AS o
	JOIN customers AS c USING(customer_id)
	JOIN stores AS s USING(store_id)
	WHERE order_status = 4
	GROUP BY store_name, c.city
	ORDER BY Store, shipping_time 
	),
	rnk_short AS(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY store ORDER BY shipping_time) AS rnk
	FROM ship_times	
	),
	rnk_long AS(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY store ORDER BY shipping_time DESC) AS rnk
	FROM ship_times	
	)
SELECT store, Delivery_Time, Customer_Location, Shipping_Time_In_Hours
FROM (SELECT
	'Top 3 Shortest' AS Delivery_Time,
	store,
	cust_location AS Customer_Location,
	shipping_time AS Shipping_Time_In_Hours
FROM rnk_short
WHERE rnk <= 3
UNION ALL
SELECT
	'Top 3 Longest' AS Delivery_Time,
	store,
	cust_location AS Customer_Location,
	shipping_time AS Shipping_Time_In_Hours
FROM rnk_long
WHERE rnk <= 3) AS tbl
ORDER BY store, delivery_time;



-- Top 5 customers who:
-- • saved the most money due to discounts (Query #1)
-- • spent the most money overall (Query #2)

CREATE VIEW base_tbl AS
SELECT customer_id, first_name, last_name, order_id, product_id, quantity, list_price, discount
FROM orders
JOIN customers USING(customer_id)
JOIN order_items USING(order_id);

SELECT
	customer_id AS ID,
	first_name||' '||last_name AS Customer_Name,
	ROUND(SUM(quantity*list_price*discount)) AS money_saved_due_to_discounts
FROM base_tbl
GROUP BY customer_id, first_name||' '||last_name
ORDER BY money_saved_due_to_discounts DESC
LIMIT 5;

SELECT
	customer_id AS ID,
	first_name||' '||last_name AS Customer_Name,
	ROUND(SUM(quantity*list_price)) AS total_money_spent
FROM base_tbl
GROUP BY customer_id, first_name||' '||last_name
ORDER BY total_money_spent DESC
LIMIT 5;



-- The three cities that bring in the most revenue for each store

WITH revenues AS(
	SELECT
		store_name AS Store,
		city,
		ROUND(SUM(quantity*price - quantity*price*discount)) AS Total_Revenue
	FROM (SELECT customers.city AS city, order_id, store_name, quantity, list_price AS price, discount
		FROM orders
		JOIN customers USING(customer_id)
		JOIN stores USING(store_id)
		JOIN order_items USING(order_id)) AS tbl
	GROUP BY store_name, city),
	ranks AS(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY store ORDER BY total_revenue DESC) AS rnk
	FROM revenues
	)
SELECT store, city, total_revenue
FROM ranks
WHERE rnk <= 3;



-- How the number of orders changes during the year

WITH order_cnt_16 AS(SELECT COUNT(*) FROM orders WHERE EXTRACT(YEAR FROM order_date::DATE) = 2016),
	order_cnt_17 AS(SELECT COUNT(*) FROM orders WHERE EXTRACT(YEAR FROM order_date::DATE) = 2017),
	order_cnt_18 AS(SELECT COUNT(*) FROM orders WHERE EXTRACT(YEAR FROM order_date::DATE) = 2018),
	yr_2016 AS (
	SELECT
		TO_CHAR(DATE_TRUNC('MONTH', order_date::DATE), 'MONTH') AS Month,
		ROUND(COUNT(*)/(SELECT * FROM order_cnt_16)::NUMERIC*100)||'%' AS Order_Prop,
		COUNT(*) AS Order_Count
	FROM orders
	WHERE EXTRACT(YEAR FROM order_date::DATE) = 2016
	GROUP BY DATE_TRUNC('MONTH', order_date::DATE)
	),
	yr_2017 AS (
	SELECT
		TO_CHAR(DATE_TRUNC('MONTH', order_date::DATE), 'MONTH') AS Month,
		ROUND(COUNT(*)/(SELECT * FROM order_cnt_17)::NUMERIC*100)||'%' AS Order_Prop,
		COUNT(*) AS Order_Count
	FROM orders
	WHERE EXTRACT(YEAR FROM order_date::DATE) = 2017
	GROUP BY DATE_TRUNC('MONTH', order_date::DATE)
	),
	yr_2018 AS (
	SELECT
		TO_CHAR(DATE_TRUNC('MONTH', order_date::DATE), 'MONTH') AS Month,
		ROUND(COUNT(*)/(SELECT * FROM order_cnt_18)::NUMERIC*100)||'%' AS Order_Prop,
		COUNT(*) AS Order_Count
	FROM orders
	WHERE EXTRACT(YEAR FROM order_date::DATE) = 2018
	GROUP BY DATE_TRUNC('MONTH', order_date::DATE)
	)
SELECT
	MONTH,
	yr_2016.Order_Prop AS Proportion_2016,
	yr_2016.Order_Count AS Count_2016,
	yr_2017.Order_Prop AS Proportion_2017,
	yr_2017.Order_Count AS Count_2017,
	yr_2018.Order_Prop AS Proportion_2018,
	yr_2018.Order_Count AS Count_2018
FROM yr_2016
JOIN yr_2017 USING(Month)
JOIN yr_2018 USING(Month);


