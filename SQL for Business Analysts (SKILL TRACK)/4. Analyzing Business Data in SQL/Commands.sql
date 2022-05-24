                                                                --Chapter 1: Revenue, cost, and profit
                          --Revenue per customer
/*                          
You've been hired at Delivr as a data analyst! A customer just called Delivr's Customer Support team; she wants to double-check whether her receipts add up. 
Going by her receipts, she calculated that her total bill on Delivr is $271, and she wants to make sure of that. Her user ID is 15.
Help the Customer Support team by calculating her total bill! Sum up everything she's spent on Delivr orders; in other words, calculate the total revenue that Delivr 
has generated from her.
*/
--Write the expression for revenue.
--Keep only the records of user ID 15.

-- Calculate revenue
SELECT sum(order_quantity*meal_price) AS revenue
  FROM meals
  JOIN orders 
  ON meals.meal_id = orders.meal_id
-- Keep only the records of customer ID 15
WHERE user_id=15;


                         --Revenue per week
/*
Delivr's first full month of operations was June 2018. At launch, the Marketing team ran an ad campaign on popular food channels on TV, with the number of ads 
increasing each week through the end of the month. The Head of Marketing asks you to help her assess that campaign's success.

Get the revenue per week for each week in June and check whether there's any consistent growth in revenue.

Note: Don't be surprised if you get a date in May in the result. DATE_TRUNC('week', '2018-06-02') returns '2018-05-28', since '2018-06-02' is a Saturday and 
the preceding Monday is on '2018-05-28'.
*/

--Write the expression for revenue.
--Keep only the records of June 2018.

SELECT DATE_TRUNC('week', order_date) :: DATE AS delivr_week,
       -- Calculate revenue
       SUM(meal_price*order_quantity) AS revenue
  FROM meals
  JOIN orders ON meals.meal_id = orders.meal_id
-- Keep only the records in June 2018
WHERE order_date BETWEEN '2018-06-01' AND '2018-06-30'
GROUP BY delivr_week
ORDER BY delivr_week ASC;


                            --Total cost
--What is Delivr's total cost since it began operating?
--Ans: 92133

      
                            --Top meals by cost
/*
Alice from Finance wants to know what Delivr's top 5 meals are by overall cost; in other words, Alice wants to know the 5 meals that Delivr has spent 
the most on for stocking.
You're provided with an aggregate query; you'll need to fill in the blanks to get the output Alice needs.
Note: Recall that in the meals table, meal_price is what the user pays Delivr for the meal, while meal_cost is what Delivr pays its eateries to stock this meal.
*/

--Calculate cost per meal ID.
--Set the LIMIT to 5.

SELECT
  -- Calculate cost per meal ID
  meals.meal_id,
  sum(meal_cost*stocked_quantity) AS cost
FROM meals
JOIN stock ON meals.meal_id = stock.meal_id
GROUP BY meals.meal_id
ORDER BY cost DESC
-- Only the top 5 meal IDs by purchase cost
LIMIT 5;


                            --Using CTEs
/*
Alice wants to know how much Delivr spent per month on average during its early months (before September 2018). 
You'll need to write two queries to solve this problem:
A query to calculate cost per month, wrapped in a CTE,
A query that averages monthly cost before September 2018 by referencing the CTE.
*/

--1 Calculate cost per month.

SELECT
  -- Calculate cost
  DATE_TRUNC('month', stocking_date)::DATE AS delivr_month,
  sum(meal_cost*stocked_quantity) AS cost
FROM meals
JOIN stock ON meals.meal_id = stock.meal_id
GROUP BY delivr_month
ORDER BY delivr_month ASC;

--2 Wrap the query you just wrote in a CTE named monthly_cost.

WITH monthly_cost AS (
  SELECT
    DATE_TRUNC('month', stocking_date)::DATE AS delivr_month,
    SUM(meal_cost * stocked_quantity) AS cost
  FROM meals
  JOIN stock ON meals.meal_id = stock.meal_id
  GROUP BY delivr_month)

SELECT *
FROM monthly_cost;

--3 Now that you've set up the monthly_cost CTE, find the average cost incurred before September 2018.

-- Declare a CTE named monthly_cost
WITH monthly_cost AS (
  SELECT
    DATE_TRUNC('month', stocking_date)::DATE AS delivr_month,
    SUM(meal_cost * stocked_quantity) AS cost
  FROM meals
  JOIN stock ON meals.meal_id = stock.meal_id
  GROUP BY delivr_month)

SELECT
  -- Calculate the average monthly cost before September
  AVG(cost)
FROM monthly_cost
WHERE delivr_month<'2018-09-01';
      		

                                    --Profit per eatery

/*
Delivr is renegotiating its contracts with its eateries. The higher the profit that an eatery generates, the higher the rate that Delivr is willing to pay 
this eatery for the bulk purchase of meals.
The Business Development team asks you to find out how much profit each eatery is generating to strengthen their negotiating positions.
Note: You don't need to GROUP BY eatery in the final query. You've already grouped by eatery in the revenue and cost CTEs; all that's required is joining them to 
each other to get each eatery's revenue and cost in one row. Since revenue and cost take up one row each per eatery, there are no additional groupings to be made.
*/
--Calculate revenue per eatery in the revenue CTE.
--Calculate cost per eatery in the cost CTE.
--Join the two CTEs and calculate profit per eatery.
WITH revenue AS (
  -- Calculate revenue per eatery
  SELECT meals.eatery,
         SUM(meal_price*order_quantity) AS revenue
    FROM meals
    JOIN orders ON meals.meal_id = orders.meal_id
   GROUP BY eatery),

  cost AS (
  -- Calculate cost per eatery
  SELECT meals.eatery,
         SUM(meal_cost * stocked_quantity) AS cost
    FROM meals
    JOIN stock ON meals.meal_id = stock.meal_id
   GROUP BY eatery)

   -- Calculate profit per eatery
   SELECT revenue.eatery,
          revenue-cost as profit
     FROM revenue
     JOIN cost ON revenue.eatery = cost.eatery
    ORDER BY profit DESC;
    
    
                                      --Profit per month
/*
After prioritizing and making deals with eateries by their overall profits, Alice wants to track Delivr profits per month to see how well it's doing. 
You're here to help.
You're provided with two CTEs. The first stores revenue and the second stores cost. To access revenue and cost in one query, the two CTEs are joined in the last query.
From there, you can apply the formula for profit Profit = Revenue - Cost to calculate profit per month.
Remember that revenue is the sum of each meal's price times its order quantity, and that cost is the sum of each meal's cost times its stocked quantity.
*/

--Calculate revenue per month in the revenue CTE.
--Calculate cost per month in the cost CTE.
--Join the two CTEs and calculate profit per month.

-- Set up the revenue CTE
WITH revenue AS ( 
	SELECT
		DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
		SUM(meal_price*order_quantity) AS revenue
	FROM meals
	JOIN orders ON meals.meal_id = orders.meal_id
	GROUP BY delivr_month),
-- Set up the cost CTE
  cost AS (
 	SELECT
		DATE_TRUNC('month', stocking_date) :: DATE AS delivr_month,
		SUM(meal_cost * stocked_quantity) AS cost
	FROM meals
    JOIN stock ON meals.meal_id = stock.meal_id
	GROUP BY delivr_month)
-- Calculate profit by joining the CTEs
SELECT
	revenue.delivr_month,
	revenue-cost as profit
FROM revenue
JOIN cost ON revenue.delivr_month = cost.delivr_month
ORDER BY revenue.delivr_month ASC;  
  
  
                                                ----------    ----Chapter 2: User-centric KPIs


                                  --Registrations by month
/*
Usually, registration dates are stored in a table containing users' metadata. However, Delivr only considers a user registered if that user has ordered at least once. 
A Delivr user's registration date is the date of that user's first order.
Bob, the Investment Relations Manager at Delivr, is preparing a pitch deck for a meeting with potential investors. He wants to add a line chart of registrations 
by month to highlight Delivr's success in gaining new users.
Send Bob a table of registrations by month.
*/
--1
--Return a table of user IDs and their registration dates.
--Order by user_id in ascending order.

SELECT
  -- Get the earliest (minimum) order date by user ID
  user_id,
  min(order_date) AS reg_date
FROM orders
GROUP BY user_id
-- Order by user ID
ORDER BY user_id ASC;

--2
--Wrap the query you just wrote in a CTE named reg_dates.
--Using reg_dates, return a table of registrations by month.

-- Wrap the query you wrote in a CTE named reg_dates
WITH reg_dates AS (
  SELECT
    user_id,
    MIN(order_date) AS reg_date
  FROM orders
  GROUP BY user_id)
SELECT
  -- Count the unique user IDs by registration month
  DATE_TRUNC('month', reg_date) :: DATE AS delivr_month,
  COUNT (DISTINCT user_id) AS regs
FROM reg_dates
GROUP BY delivr_month
ORDER BY delivr_month ASC; 



                                      --  Monthly active users (MAU)
/*
Bob predicts that the investors won't be satisfied with only registrations by month. They will want to know how many users actually used Delivr as well. 
He's decided to include another line chart of Delivr's monthly active users (MAU); he's asked you to send him a table of monthly active users.
*/
--Select the month by truncating the order dates.
--Calculate MAU by counting the users for every month.
--Order by month in ascending order.

SELECT
  -- Truncate the order date to the nearest month
  DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
  -- Count the unique user IDs
  COUNT(DISTINCT user_id) AS mau
FROM orders
GROUP BY delivr_month
-- Order by month
ORDER BY delivr_month ASC;


                                      --Registrations running total
/*
You have a suggestion for Bob's pitch deck: Instead of showing registrations by month in the line chart, he can show the registrations running total by month.
The numbers are bigger that way, and investors always love bigger numbers! He agrees, and you begin to work on a query that returns a table of the registrations 
running total by month.
*/

--1   Select the month and the registrations in each month.
-- Order by month in ascending order.

WITH reg_dates AS (
  SELECT
    user_id,
    MIN(order_date) AS reg_date
  FROM orders
  GROUP BY user_id)

SELECT
  -- Select the month and the registrations
  DATE_TRUNC('month', reg_date) :: DATE AS delivr_month,
  COUNT (DISTINCT user_id) AS regs
FROM reg_dates
GROUP BY delivr_month
-- Order by month in ascending order
ORDER BY delivr_month ASC; 

-- 2   Return a table of the registrations running total by month.
--     Order by month in ascending order.

WITH reg_dates AS (
  SELECT
    user_id,
    MIN(order_date) AS reg_date
  FROM orders
  GROUP BY user_id),

  regs AS (
  SELECT
    DATE_TRUNC('month', reg_date) :: DATE AS delivr_month,
    COUNT(DISTINCT user_id) AS regs
  FROM reg_dates
  GROUP BY delivr_month)

SELECT
  -- Calculate the registrations running total by month
  delivr_month,
  regs,
  SUM(regs) OVER (ORDER BY delivr_month ASC) AS regs_rt
FROM regs
-- Order by month in ascending order
ORDER BY delivr_month ASC; 

					
					--MAU monitor (I)
/*
Carol from the Product team noticed that you're working with a lot of user-centric KPIs for Bob's pitch deck. While you're at it, she says, you can help build an 
idea of hers involving a user-centric KPI. She wants to build a monitor that compares the MAUs of the previous and current month, raising a red flag to the Product 
team if the current month's active users are less than those of the previous month.
To start, write a query that returns a table of MAUs and the previous month's MAU for every month.
*/
--Select the month and the MAU.
--Fetch the previous month's MAU.
--Order by month in ascending order.

WITH mau AS (
  SELECT
    DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
    COUNT(DISTINCT user_id) AS mau
  FROM orders
  GROUP BY delivr_month)

SELECT
  -- Select the month and the MAU
  delivr_month,
  mau,
  COALESCE(
    LAG(mau) OVER (ORDER BY delivr_month ASC),
  0) AS last_mau
FROM mau
-- Order by month in ascending order
ORDER BY delivr_month ASC;



				--MAU monitor (II)
/*
Now that you've built the basis for Carol's MAU monitor, write a query that returns a table of months and the deltas of each month's current and previous MAUs.
If the delta is negative, less users were active in the current month than in the previous month, which triggers the monitor to raise a red flag so
the Product team can investigate.
*/
--Fetch the previous month's MAU in the mau_with_lag CTE..
--Select the month and the delta between its MAU and the previous month's MAU.
--Order by month in ascending order.

WITH mau AS (
  SELECT
    DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
    COUNT(DISTINCT user_id) AS mau
  FROM orders
  GROUP BY delivr_month),

  mau_with_lag AS (
  SELECT
    delivr_month,
    mau,
    -- Fetch the previous month's MAU
    COALESCE(
      LAG(mau) OVER (ORDER BY delivr_month ASC),
    0) AS last_mau
  FROM mau)

SELECT
  -- Calculate each month's delta of MAUs
  delivr_month,
  mau,
  last_mau,
  mau-last_mau AS mau_delta
FROM mau_with_lag
-- Order by month in ascending order
ORDER BY delivr_month ASC;



					--MAU monitor (III)
/*
Carol is very pleased with your last query, but she's requested one change: She prefers to have the month-on-month (MoM) MAU growth rate over a raw delta of MAUs. 
That way, the MAU monitor can have more complex triggers, like raising a yellow flag if the growth rate is -2% and a red flag if the growth rate is -5%.
Write a query that returns a table of months and each month's MoM MAU growth rate to finalize the MAU monitor.
*/

--Select the month and its MoM MAU growth rate.
--Order by month in ascending order.

WITH mau AS (
  SELECT
    DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
    COUNT(DISTINCT user_id) AS mau
  FROM orders
  GROUP BY delivr_month),

  mau_with_lag AS (
  SELECT
    delivr_month,
    mau,
    GREATEST(
      LAG(mau) OVER (ORDER BY delivr_month ASC),
    1) AS last_mau
  FROM mau)

SELECT
  -- Calculate the MoM MAU growth rates
  delivr_month,
  mau,
  last_mau,
  ROUND(
    (mau-last_mau)/last_mau :: NUMERIC,
  2) AS growth
FROM mau_with_lag
-- Order by month in ascending order
ORDER BY delivr_month ASC;


				--Order growth rate
/*
Bob needs one more chart to wrap up his pitch deck. He's covered Delivr's gain of new users, its growing MAUs, and its high retention rates. 
Something is missing, though. Throughout the pitch deck, there's not a single mention of the best indicator of user activity: the users' orders! 
The more orders users make, the more active they are on Delivr, and the more money Delivr generates.
Send Bob a table of MoM order growth rates.
(Recap: MoM means month-on-month.)
*/
--Count the unique orders per month.
--Fetch each month's previous and current orders.
--Return a table of MoM order growth rates.

WITH orders AS (
  SELECT
    DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
    --  Count the unique order IDs
    COUNT(DISTINCT order_id) AS orders
  FROM orders
  GROUP BY delivr_month),

  orders_with_lag AS (
  SELECT
    delivr_month,
    -- Fetch each month's current and previous orders
    orders,
    COALESCE(
      LAG(orders) OVER (ORDER By delivr_month ASC),
    1) AS last_orders
  FROM orders)

SELECT
  delivr_month,
  orders,
  last_orders,
  -- Calculate the MoM order growth rate
  ROUND(
    (orders-last_orders)/last_orders :: NUMERIC,
  2) AS growth
FROM orders_with_lag
ORDER BY delivr_month ASC;


				--New, retained, and resurrected users 
				

--In August 2018, Delivr had 300 overall active users. Of these users, 124 were retained from last month, and 67 were resurrected users who weren't active in previous 
--months but returned to the platform in August. How many users were new?
--Ans: 109

				--Retention rate
				--(complex)
/*
Bob's requested your help again now that you're done with Carol's MAU monitor. His meeting with potential investors is fast approaching, and he wants to wrap up his 
pitch deck. You've already helped him with the registrations running total by month and MAU line charts; the investors, Bob says, would be convinced that Delivr is 
growing both in new users and in MAUs.
However, Bob wants to show that Delivr not only attracts new users but also retains existing users. Send him a table of MoM retention rates so that he can highlight 
Delivr's high user loyalty.
*/

--Select the month column from user_monthly_activity, and calculate the MoM user retention rates.
--Join user_monthly_activity to itself on the user ID and the month, pushed forward one month.

WITH user_monthly_activity AS (
  SELECT DISTINCT
    DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
    user_id
  FROM orders)

SELECT
  -- Calculate the MoM retention rates
  previous.delivr_month,
  ROUND(
    COUNT(DISTINCT current.user_id) :: NUMERIC /
    GREATEST(COUNT(DISTINCT previous.user_id),1),
  2) AS retention_rate
FROM user_monthly_activity AS previous
LEFT JOIN user_monthly_activity AS current
-- Fill in the user and month join conditions
ON previous.user_id=current.user_id
AND previous.delivr_month = (current.delivr_month - INTERVAL '1 month')
GROUP BY previous.delivr_month
ORDER BY previous.delivr_month ASC;



							--Chapter 3: ARPU, histograms, and percentiles

					--Average revenue per user
/*
Dave from Finance wants to study Delivr's performance in revenue and orders per each of its user base. In other words, he wants to understand its unit economics.
Help Dave kick off his study by calculating the overall average revenue per user (ARPU) using the first way discussed in Lesson 3.1.
*/
--1 Return a table of user IDs and the revenue each user generated.

SELECT
  -- Select the user ID and calculate revenue
  user_id,
  SUM(meal_price*order_quantity) AS revenue
FROM meals AS m
JOIN orders AS o ON m.meal_id = o.meal_id
GROUP BY user_id;

--2 Wrap the previous query in a CTE named kpi.
--Return the average revenue per user (ARPU).

-- Create a CTE named kpi
WITH kpi AS (
  SELECT
    -- Select the user ID and calculate revenue
    user_id,
    SUM(m.meal_price * o.order_quantity) AS revenue
  FROM meals AS m
  JOIN orders AS o ON m.meal_id = o.meal_id
  GROUP BY user_id)
-- Calculate ARPU
SELECT ROUND(avg(revenue) :: NUMERIC, 2) AS arpu
FROM kpi;


						--ARPU per week
/*
Next, Dave wants to see whether ARPU has increased over time. Even if Delivr's revenue is increasing, it's not scaling well if its ARPU is decreasing—it's 
generating less revenue from each of its customers.
Send Dave a table of ARPU by week using the second way discussed in Lesson 3.1.
*/
--Store revenue and the number of unique active users by week in the kpi CTE.
--Calculate ARPU by dividing the revenue by the number of users.
--Order the results by week in ascending order.

WITH kpi AS (
  SELECT
    -- Select the week, revenue, and count of users
    DATE_TRUNC('week',order_date) :: DATE AS delivr_week,
    SUM(meal_price*order_quantity) AS revenue,
    COUNT(DISTINCT user_id) AS users
  FROM meals AS m
  JOIN orders AS o ON m.meal_id = o.meal_id
  GROUP BY delivr_week)

SELECT
  delivr_week,
  -- Calculate ARPU
  ROUND(
    revenue :: NUMERIC / GREATEST(users,1),
  2) AS arpu
FROM kpi
-- Order by week in ascending order
ORDER BY delivr_week ASC;


					--Average orders per user

/*
Dave wants to add the average orders per user value to his unit economics study, since more orders usually correspond to more revenue.
Calculate the average orders per user for Dave.
Note: The count of distinct orders is different than the sum of ordered meals. One order can have many meals within it. Average orders per user depends on the c
ount of orders, not the sum of ordered meals.
*/ 
--Store the count of distinct orders and distinct users in the kpi CTE.
--Calculate the average orders per user.

WITH kpi AS (
  SELECT
    -- Select the count of orders and users
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT user_id) AS users
  FROM orders)

SELECT
  -- Calculate the average orders per user
  ROUND(
    orders :: NUMERIC / GREATEST(users,1),
  2) AS arpu
FROM kpi;


					--Histogram of revenue
/*
After determining that Delivr is doing well at scaling its business model, Dave wants to explore the distribution of revenues. He wants to see whether the 
distribution is U-shaped or normal to see how best to categorize users by the revenue they generate.
Send Dave a frequency table of revenues by user.
*/
--Store each user ID and the revenue Delivr generates from it in the user_revenues CTE.
--Return a frequency table of revenues rounded to the nearest hundred and the users generating those revenues.


WITH user_revenues AS (
  SELECT
    -- Select the user ID and revenue
    user_id,
    SUM(meal_price*order_quantity) AS revenue
  FROM meals AS m
  JOIN orders AS o ON m.meal_id = o.meal_id
  GROUP BY user_id)

SELECT
  -- Return the frequency table of revenues by user
  ROUND(revenue :: NUMERIC, -2) AS revenue_100,
  COUNT(DISTINCT user_id) AS users
FROM user_revenues
GROUP BY revenue_100
ORDER BY revenue_100 ASC;

						--Histogram of orders
/*
Dave also wants to plot the histogram of orders to see if it matches the shape of the histogram of revenues.
Send Dave a frequency table of orders by user.
*/
--1 Set up the frequency tables query by getting each user's count of orders.

SELECT
  -- Select the user ID and the count of orders
  user_id,
  COUNT(DISTINCT order_id) AS orders
FROM orders
GROUP BY user_id
ORDER BY user_id ASC
LIMIT 5;

--2 Return a frequency table of orders and the count of users with those orders.

WITH user_orders AS (
  SELECT
    user_id,
    COUNT(DISTINCT order_id) AS orders
  FROM orders
  GROUP BY user_id)

SELECT
  -- Return the frequency table of orders by user
  orders,
  COUNT(DISTINCT user_id) AS users
FROM user_orders
GROUP BY orders
ORDER BY orders ASC;


					--Bucketing users by revenue
/*
Based on his analysis, Dave identified that $150 is a good cut-off for low-revenue users, and $300 is a good cut-off for mid-revenue users. He wants to find the 
number of users in each category to tweak Delivr's business model.
Split the users into low, mid, and high-revenue buckets, and return the count of users in each group.
*/
--Store each user ID and the revenue it generates in the user_revenues CTE.
--Return a table of the revenue groups and the count of users in each group.

WITH user_revenues AS (
  SELECT
    -- Select the user IDs and the revenues they generate
    user_id,
    SUM(meal_price*order_quantity) AS revenue
  FROM meals AS m
  JOIN orders AS o ON m.meal_id = o.meal_id
  GROUP BY user_id)

SELECT
  -- Fill in the bucketing conditions
  CASE
    WHEN revenue<150 THEN 'Low-revenue users'
    WHEN revenue<300 THEN 'Mid-revenue users'
    ELSE 'High-revenue users'
  END AS revenue_group,
  COUNT(DISTINCT user_id) AS users
FROM user_revenues
GROUP BY revenue_group;


					--Bucketing users by orders
/*
Dave is repeating his bucketing analysis on orders to have a more complete profile of each group. He determined that 8 orders is a good cut-off for the 
low-orders group, and 15 is a good cut-off for the medium orders group.
Send Dave a table of each order group and how many users are in it.
*/
--Store each user ID and its count of orders in a CTE named user_orders.
--Set the cut-off point for the low-orders bucket to 8 orders, and set the cut-off point for the mid-orders bucket to 15 orders.
--Count the distinct users in each bucket.

-- Store each user's count of orders in a CTE named user_orders
WITH user_orders AS(
  SELECT
    user_id,
    COUNT(DISTINCT order_id) AS orders
  FROM orders
  GROUP BY user_id)

SELECT
  -- Write the conditions for the three buckets
  CASE
    WHEN orders<8 THEN 'Low-orders users'
    WHEN orders<15 THEN 'Mid-orders users'
    ELSE 'High-orders users'
  END AS order_group,
  -- Count the distinct users in each bucket
  COUNT(DISTINCT user_id) AS users
FROM user_orders
GROUP BY order_group;


					--Revenue quartiles
/*
Dave is wrapping up his study, and wants to calculate a few more figures. He wants to find out the first, second, and third revenue quartiles. 
He also wants to find the average to see in which direction the data is skewed.

Calculate the first, second, and third revenue quartiles, as well as the average.

Note: You can calculate the 30th percentile for a column named column_a by using 

PERCENTILE_CONT(0.30) WITHIN GROUP (ORDER BY column_a ASC)

*/
--Store each user ID and the revenue Delivr generates from it in the user_revenues CTE.
--Calculate the first, second, and third revenue quartile.
--Calculate the average revenue.

WITH user_revenues AS (
  -- Select the user IDs and their revenues
  SELECT
    user_id,
    SUM(meal_price*order_quantity) AS revenue
  FROM meals AS m
  JOIN orders AS o ON m.meal_id = o.meal_id
  GROUP BY user_id)

SELECT
  -- Calculate the first, second, and third quartile
  ROUND(
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY revenue ASC) :: NUMERIC,
  2) AS revenue_p25,
  ROUND(
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY revenue ASC) :: NUMERIC,
  2) AS revenue_p50,
  ROUND(
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY revenue ASC) :: NUMERIC,
  2) AS revenue_p75,
  -- Calculate the average
  ROUND(AVG(revenue) :: NUMERIC, 2) AS avg_revenue
FROM user_revenues;


					--Interquartile range
/*
The final value that Dave wants is the count of users in the revenue interquartile range (IQR). Users outside the revenue IQR are outliers, and Dave wants 
to know the number of "typical" users.

Return the count of users in the revenue IQR.
*/
--1 Return a table of user IDs and generated revenues for each user.

SELECT
  -- Select user_id and calculate revenue by user
  user_id,
  SUM(meal_price*order_quantity) AS revenue
FROM meals AS m
JOIN orders AS o ON m.meal_id = o.meal_id
GROUP BY user_id;

--2 Wrap the previous query in a CTE named user_revenues.
--Calculate the first and third revenue quartiles.


-- Create a CTE named user_revenues
WITH user_revenues AS (
  SELECT
    -- Select user_id and calculate revenue by user 
    user_id,
    SUM(m.meal_price * o.order_quantity) AS revenue
  FROM meals AS m
  JOIN orders AS o ON m.meal_id = o.meal_id
  GROUP BY user_id)

SELECT
  -- Calculate the first and third revenue quartiles
  ROUND(
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY revenue ASC) :: NUMERIC,
  2) AS revenue_p25,
  ROUND(
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY revenue ASC) :: NUMERIC,
  2) AS revenue_p75
FROM user_revenues;


--3 Count the number of distinct users.
--Filter out all users outside the IQR.


WITH user_revenues AS (
  SELECT
    -- Select user_id and calculate revenue by user 
    user_id,
    SUM(m.meal_price * o.order_quantity) AS revenue
  FROM meals AS m
  JOIN orders AS o ON m.meal_id = o.meal_id
  GROUP BY user_id),

  quartiles AS (
  SELECT
    -- Calculate the first and third revenue quartiles
    ROUND(
      PERCENTILE_CONT(0.25) WITHIN GROUP
      (ORDER BY revenue ASC) :: NUMERIC,
    2) AS revenue_p25,
    ROUND(
      PERCENTILE_CONT(0.75) WITHIN GROUP
      (ORDER BY revenue ASC) :: NUMERIC,
    2) AS revenue_p75
  FROM user_revenues)

SELECT
  -- Count the number of users in the IQR
  COUNT(DISTINCT user_id) AS users
FROM user_revenues
CROSS JOIN quartiles
-- Only keep users with revenues in the IQR range
WHERE revenue :: NUMERIC >= revenue_p25
  AND revenue :: NUMERIC <= revenue_p75;
/*  
output:
users
652
  */
  								--Chapter 4: Generating an executive report

					--Formatting dates
/*
Eve from the Business Intelligence (BI) team lets you know that she's gonna need your help to write queries for reports. The reports are read by C-level execs, 
so they need to be as readable and quick to scan as possible. Eve tells you that the C-level execs' preferred date format is something like Friday 01, 
June 2018 for 2018-06-01.

You have a list of useful patterns.

Pattern		Description
--------------------------------------------------------
DD		Day number (01 - 31)
FMDay		Full day name (Monday, Tuesday, etc.)
FMMonth		Full month name (January, February, etc.)
YYYY		Full 4-digit year (2018, 2019, etc.)

Figure out the format string that formats 2018-06-01 as "Friday 01, June 2018" when using TO_CHAR.
*/

--Select the order date.
--Format the order date so that 2018-06-01 is formatted as Friday 01, June 2018.

SELECT DISTINCT
  -- Select the order date
  order_date,
  -- Format the order date
  TO_CHAR(order_date, 'FMDay DD, FMMonth YYYY') AS format_order_date
FROM orders
ORDER BY order_date ASC
LIMIT 3;



							--Rank users by their count of orders
/*
Eve tells you that she wants to report which user IDs have the most orders each month. She doesn't want to display long numbers, which will only distract 
C-level execs, so she wants to display only their ranks. The top 1 rank goes to the user with the most orders, the second-top 2 rank goes to the user with the 
second-most orders, and so on.

Send Eve a list of the top 3 user IDs by orders in August 2018 with their ranks.
*/
--1 Keep only the orders in August 2018.

SELECT
  user_id,
  COUNT(DISTINCT order_id) AS count_orders
FROM orders
-- Only keep orders in August 2018
WHERE order_date between '2018-08-01' AND '2018-08-31'
GROUP BY user_id;


--2 Wrap the previous query in a CTE named user_count_orders.
--Select the user ID and rank all user IDs by the count of orders in descending order.
--Only keep the top 3 users by their count of orders.

-- Set up the user_count_orders CTE
WITH user_count_orders AS (
  SELECT
    user_id,
    COUNT(DISTINCT order_id) AS count_orders
  FROM orders
  -- Only keep orders in August 2018
  WHERE DATE_TRUNC('month', order_date) = '2018-08-01'
  GROUP BY user_id)

SELECT
  -- Select user ID, and rank user ID by count_orders
  user_id,
  RANK() OVER (ORDER BY count_orders desc) AS count_orders_rank
FROM user_count_orders
ORDER BY count_orders_rank ASC
-- Limit the user IDs selected to 3
LIMIT 3;




						--Pivoting user revenues by month
/*
Next, Eve tells you that the C-level execs prefer wide tables over long ones because they're easier to scan. She prepared a sample report of user revenues by month, 
detailing the first 5 user IDs' revenues from June to August 2018. The execs told her to pivot the table by month. She's passed that task off to you.

Pivot the user revenues by month query so that the user ID is a row and each month from June to August 2018 is a column.
*/
--Enable CROSSTAB() from tablefunc.
--Declare the new pivot table's columns, user ID and the first three months of operation.





						--Costs
/*
The C-level execs next tell Eve that they want a report on the total costs by eatery in the last two months.

First, write a query to get the total costs by eatery in November and December 2018, then pivot by month.

Note: Recall from Chapter 1 that total cost is the sum of each meal's cost times its stocking quantity.
*/
--1 Select the eatery and calculate total cost per eatery.
--Keep only the records after October 2018.




--2



						--Report readability
/*
This executive report detailing the quarterly rank of each eatery by how many orders each eatery received was generated by Frank, a more junior member of the BI team.
Frank sent it to Eve, who rejected it and told him that it was unreadable.

Frank approaches you and asks you what he can do to make this report more readable.

eatery               delivr_quarter  orders_rank
-----------------  --------------  -----------            
Bean Me Up Scotty  Q2 2018           3          
Bean Me Up Scotty  Q3 2018           2          
Bean Me Up Scotty  Q4 2018           2           
Burgatorio         Q2 2018           2           
...                ...             ...            

Ans: 



						--Executive report
/*
Eve wants to produce a final executive report about the rankings of eateries by the number of unique users who order from them by quarter. 
She said she'll handle the pivoting, so you only need to prepare the source table for her to pivot.

Send Eve a table of unique ordering users by eatery and by quarter.
*/
--1 Fill in the format string that formats 2018-06-01 as Q2 2018.
Count the ordering users by eatery and by quarter.


--2



--3










