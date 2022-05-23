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


                                      --
















