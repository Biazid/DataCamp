 --                               Chapter 1: Use Real-World SQL


        --Review the essentials

--In this exercise you must prepare the data you need (title & description) to run a promotion for the store's Italian & French language films from 2005.

--1 Return the title and description from the film table. Make sure to alias this table AS f.

SELECT title, description
FROM film AS f

--2 Use an INNER JOIN to bring in language data about your films using the language_id as the join column.

SELECT title, description
FROM film AS f
INNER JOIN language AS l
  ON f.language_id = l.language_id
  
--3 Use the IN command to limit the results where the language name is either Italian or French.
--Ensure only the release_year of the films is 2005.

SELECT title, description
FROM film AS f
INNER JOIN language AS l
  ON f.language_id = l.language_id
WHERE l.name IN ('Italian','French')
  AND f.release_year = 2005 ;
  
  
                         --Practice the essentials

--In this exercise you are preparing list of your top paying active customers. The data you will need are the names of the customer sorted by the amount they paid.

--Return the first_name, last_name and amount.
--INNER JOIN the tables you need for this query: payment and customer using the customer_id for the join.
--Ensure only active customers are returned.
--Sort the results in DESCending order by the amount paid.

SELECT c.first_name,
	     c.last_name,
       p.amount
FROM payment AS p
INNER JOIN customer AS c
  ON p.customer_id = c.customer_id
WHERE c.active='true'
ORDER BY p.amount desc;


                           --Transform numeric & strings

--For this exercise you are planning to run a 50% off promotion for films released prior to 2006. To prepare for this promotion you will need to return the films
--that qualify for this promotion, to make these titles easier to read you will convert them all to lower case. You will also need to return both the original_rate 
--and the sale_rate.

--Return the LOWER-case titles of the films.
--Return the original rental_rate and the 50% discounted sale_rate by multiplying rental_rate by 0.5.
--Ensure only films prior to 2006 are considered for this promotion.

SELECT lower(title) AS title, 
  rental_rate  AS original_rate, 
  rental_rate * 0.5 AS sale_rate 
FROM film
where release_year<2006;

                           --Extract what you need

--In this exercise you will practice preparing date/time elements by using the EXTRACT() function.

--1 EXTRACT the DAY from payment_date and return this column AS the payment_day.

SELECT payment_date,
  EXTRACT(DAY from payment_date) AS payment_day 
FROM payment;

--2 EXTRACT the YEAR from payment_date and return this column AS the payment_year.

SELECT payment_date,
  EXTRACT(YEAR from payment_date) AS payment_year 
FROM payment;

--3 EXTRACT the HOUR from payment_date and return this column AS the payment_hour.

SELECT payment_date,
  EXTRACT(hour from payment_date) AS payment_hour 
FROM payment;

                           --Aggregating finances

--In this exercise you would like to learn more about the differences in payments between the customers who are active and those who are not.

--Find out the differences in their total number of payments by COUNT()ing the payment_id.
--Find out the differences in their average payments by using AVG().
--Find out the differences in their total payments by using SUM().
--Ensure the aggregate functions GROUP BY whether customer payments are active.

SELECT active, 
       count(payment_id) AS num_transactions, 
       avg(amount) AS avg_amount, 
       sum(amount) AS total_amount
FROM payment AS p
INNER JOIN customer AS c
  ON p.customer_id = c.customer_id
GROUP BY active;

		
				--Aggregating strings
--You are planning to update your storefront window to demonstrate how family-friendly and multi-lingual your DVD collection is. 
--To prepare for this you need to prepare a comma-separated list G-rated film titles by language released in 2010.

--Return a column with a list of comma-separated film titles by using the STRING_AGG() function.
--Limit the results to films that have a release_year of 2010 AND have a rating of 'G'.
--Ensure that the operation is grouped by the language name.

SELECT name, 
	STRING_AGG(title, ',') AS film_titles
FROM film AS f
INNER JOIN language AS l
  ON f.language_id = l.language_id
WHERE release_year = 2010
  AND rating = 'G'
GROUP BY name;



					--Which tables?
/*
You must answer the following question using a query:

Which films are most frequently rented?

Which of these table(s) do you need to prepare the query to answer this question?

Tables	
actor		film_actor
address		inventory
category	language
customer	payment
film		rental

Ans: I need to explore my database to find the data I'm looking for!
*/



							--Chapter 2: Find Your Data

--				LIMITing your search

--You may find yourself working with tables that contain so many records that simple queries can take forever to load. This is especially challenging when you're 
--searching for the right table to use and just need a quick result. For these scenarios the trick is to LIMIT the number of rows that your query returns. 
--In this exercise you will practice using this function.

--1 Use LIMIT to return all columns for the first 10 rows for the payment table.

SELECT * 
FROM payment
limit 10;

--2 Use LIMIT to return all columns for the 10 highest amount paid in the payments

SELECT * 
FROM payment
order by amount desc
LIMIT 10;

			
			--Which table to use?

--Use the SELECT * FROM ___ LIMIT 10 framework to find the table you need to answer the following question:
--What categories of films does this company rent?
-- Ans: category


			-- What tables are in your database?
--You don't have to rely solely on knowing what tables exist. Instead, you can query the pg_catalog.pg_tables to list all of the tables that exist in your database.
--Of course, this will list every table, including system tables so ideally, you want to limit your results to the schema where your data resides which in 
--this case is 'public'.
--Note: This system table is specific to PostgreSQL but similar tables exist for other databases (see slides).


--List the tables that exist in your database by querying the table: pg_catalog.pg_tables.
--Filter the query to ensure the result contains entries where the schemaname is 'public'.

SELECT * 
FROM pg_catalog.pg_tables
where schemaname='public';

			--Determine the monthly income
--Now that you know how to find the table that you need to answer a question and how to use SQL to answer that question let's practice these skills end-to-end.
--How much does this business make per month?
--First, you will need to use pg_catalog.pg_tables to find the possible tables and determine which tables & columns you need to answer that question. 
--Second, you will leverage the tools you learned in the previous chapter to prepare the answer.

--1 Run the first section of code to list your tables.
--Explore the tables to determine which you need to answer the question.
--Once you've figured out which table to use, fill in the blank in this statement SELECT * FROM ___ LIMIT 10
-- List all tables in the public schema
SELECT * 
FROM pg_catalog.pg_tables
WHERE schemaname = 'public';

-- Explore the tables and fill in the correct one
SELECT * 
FROM payment 
LIMIT 10;

--2 Calculate the total_payment per month.

SELECT EXTRACT(MONTH FROM payment_date) AS month, 
       SUM(amount) AS total_payment
FROM payment 
GROUP BY month;


			--


