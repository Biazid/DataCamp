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


			--What columns are in your database?
--Just like pg_catalog.pg_tables can be incredibly helpful for listing all the tables in your database, information_schema.columns can be used to list the columns 
--of these tables. In this exercise, you will combine these system tables to get a list of all of the columns for all your tables (in the 'public' schema).
--Note: These system tables are specific to PostgreSQL but similar tables exist for other databases (see slides).

--1 View all of the data in the information_schema.columns table by SELECTing all the columns within it.
select *
from information_schema.columns;

--2 Limit your results to only the columns you need: table_name and column_name.
--Filter the results where the table_schema is public

SELECT table_name, column_name
FROM information_schema.columns
where table_schema='public';


			--A VIEW of all your columns

--In this exercise you will create a new tool for finding the tables and columns you need. Using the system table information_schema.columns you will concatenate
--the list of each table's columns into a single entry.
--Once you've done this you will make this query easily reusable by creating a new VIEW for it called table_columns.

--1 Concatenate the column_name(s) for each table_name into a comma-separated list using the STRING_AGG() function and save this as a new field called columns.


SELECT table_name, 
       STRING_AGG(column_name, ', ') AS columns
FROM information_schema.columns
WHERE table_schema = 'public'
GROUP BY table_name;

--2 Store the previous query result in a new VIEW called table_columns.
--Query your newly created view by SELECTing all its rows & columns.

-- Create a new view called table_columns
CREATE View table_columns AS
SELECT table_name, 
	   STRING_AGG(column_name, ', ') AS columns
FROM information_schema.columns
WHERE table_schema = 'public'
GROUP BY table_name;

-- Query the newly created view table_columns
select *
from table_columns;

		
				
				--Testing out your new VIEW
--You are interested in calculating the average movie length for every category. Which tables & columns will you need to create this query?
--Note: The table_columns view is now stored in your database and can be used to help you with this question.
--Ans: Tables: film & category -- Join on: film_id



				--The average length of films by category

--From the previous exercise you've learned that the tables film and category have the necessary information to calculate the average movie length for every category. 
--You've also learned that they share a common field film_id which can be used to join these tables. Now you will use this information to query a list of
--average length for each category.

--Calculate the average length and return this column as average_length.
--Join the two tables film and category.
--Ensure that the result is in ascending order by the average length of each category.

-- Calculate the average_length for each category
SELECT c.category, 
	   avg(f.length) AS average_length
FROM film AS f
-- Join the tables film & category
INNER JOIN category AS c
  ON f.film_id = c.film_id
GROUP BY c.category
-- Sort the results in ascending order by length
order by average_length;



				--Build the entity relationship diagram
--Using the skills you learned throughout this chapter you will build an entity relationship diagram to trace and connect the tables needed to answer the 
--following question:
--Which films are most frequently rented?

--1 The first piece of information for this diagram is the list of films you will need.
--Which table should you query to get this information?
--Ans: film

--2 Question
--Next, you need records of film's that were rented.
--Which table should you query to get this information?
--Ans: rental

--3 Question
--As you can see in the diagram below, the two tables you identified do not share a common id and hence cannot be joined directly.
--What intermediate table can you use to join these tables and get the data that you need?
--Ans: Inventory


				--Which films are most frequently rented?

--Now that you've figured out the relationships between the tables and their columns, you are ready to answer the question we started with:
--Which films are most frequently rented?
--Use the relationship diagram to answer this question.

--Use the entity diagram above to correctly join the required tables to answer this question.

SELECT title, COUNT(title)
FROM film AS f
INNER JOIN inventory AS i
  ON f.film_id = i.film_id
INNER JOIN rental AS r
  ON i.inventory_id = r.inventory_id
GROUP BY title
ORDER BY count DESC;





							--Chapter 3: Manage Your Data


				--



