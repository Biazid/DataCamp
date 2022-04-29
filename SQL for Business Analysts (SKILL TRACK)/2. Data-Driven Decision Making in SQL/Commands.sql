                       --                   Chapter 1: Introduction to business intelligence for a online movie rental database

         --Exploring the database
--Explore the tables and its columns. Which of the following quantities can't be computed?
--Ans: The number of movies with an international award.


        --Exploring the table renting
/*The table renting includes all records of movie rentals. Each record has a unique ID renting_id. It also contains information about customers (customer_id) and 
which movies they watched (movie_id). Furthermore, customers can give a rating after watching the movie, and the day the movie was rented is recorded.
        */
--1--      Select all columns from renting.
SELECT *  -- Select all
From renting;        -- From table renting  

--2     Now select only those columns from renting which are needed to calculate the average rating per movie.
SELECT movie_id,
       rating  -- Select all columns needed to compute the average rating per movie
FROM renting

--3     In SQL missing values are coded with null. In which column of renting did you notice null values?
--Ans: rating

              --Working with dates
/*For the analysis of monthly or annual changes, it is important to select data from specific time periods. You will select records from the table renting of 
movie rentals. The format of dates is 'YYYY-MM-DD'.
*/
--1      Select all movies rented on October 9th, 2018.

SELECT *
FROM renting
where date_renting = '2018-10-09'; -- Movies rented on October 9th, 2018
--2     Select all records of movie rentals between beginning of April 2018 till end of August 2018.
SELECT *
FROM renting
where date_renting between '2018-04-01' and '2018-08-31'; -- from beginning April 2018 to end August 2018

--3     Put the most recent records of movie rentals on top of the resulting table and order them in decreasing order.
SELECT *
FROM renting
WHERE date_renting BETWEEN '2018-04-01' AND '2018-08-31'
order by date_renting desc


                              --Selecting movies
--The table movies contains all movies available on the online platform.
--1   Select all movies which are not dramas.
SELECT *
FROM movies
where genre <>'Drama'; 

--2   Select the movies 'Showtime', 'Love Actually' and 'The Fighter'.
SELECT *
FROM movies
where title in ('Showtime','Love Actually','The Fighter');

--3   Order the movies by increasing renting price.
SELECT *
FROM movies
order by renting_price desc; 


                              -- Select from renting

--Only some users give a rating after watching a movie. Sometimes it is interesting to explore only those movie rentals where a rating was provided.
--Select from table renting all movie rentals from 2018. Filter only those records which have a movie rating.
SELECT *
FROM renting
WHERE date_renting between '2018-01-01' and '2018-12-31'
AND rating is not null; 

            --Summarizing customer information
--In most business decisions customers are analyzed in groups, such as customers per country or customers per age group.
--1 Count the number of customers born in the 80s.
SELECT count(name) 
FROM customers
-- Select customers born between 1980-01-01 and 1989-12-31
WHERE date_of_birth between '1980-01-01' and '1989-12-31'; 

--2 Count the number of customers from Germany.
SELECT count(*)   -- Count the total number of customers
FROM customers
where country='Germany'; -- Select all customers from Germany

--3 Count the number of countries where MovieNow has customers.
SELECT count(distinct country)   -- Count the number of countries
FROM customers;

                  --Ratings of movie 25
--The movie ratings give us insight into the preferences of our customers. Report summary statistics, such as the minimum, maximum, average, and count,
--of ratings for the movie with ID 25.

--Select all movie rentals of the movie with movie_id 25 from the table renting.
--For those records, calculate the minimum, maximum and average rating and count the number of ratings for this movie. 

SELECT min(rating) min_rating, -- Calculate the minimum rating and use alias min_rating
	   max(rating) max_rating, -- Calculate the maximum rating and use alias max_rating
	   avg(rating) avg_rating, -- Calculate the average rating and use alias avg_rating
	   count(rating) number_ratings -- Count the number of ratings and use alias number_ratings
FROM renting
where movie_id=25; -- Select all records of the movie with ID 25



                          --Examining annual rentals
--You are asked to provide a report about the development of the company. Specifically, your manager is interested in the total number of movie rentals,
--the total number of ratings and the average rating of all movies since the beginning of 2019.

--First, select all records of movie rentals since January 1st 2019.
select *
from renting
where date_renting >= '2019-01-01'

--Now, count the number of movie rentals and calculate the average rating since the beginning of 2019.
SELECT 
	count(*), -- Count the total number of rented movies
	avg(rating) -- Add the average rating
FROM renting
WHERE date_renting >= '2019-01-01';

--Use as alias column names number_renting and average_rating respectively.
SELECT 
	COUNT(*) number_renting, -- Give it the column name number_renting
	AVG(rating) average_rating  -- Give it the column name average_rating
FROM renting
WHERE date_renting >= '2019-01-01';

--Finally, count how many ratings exist since 2019-01-01.
SELECT 
	COUNT(*) AS number_renting,
	AVG(rating) AS average_rating, 
    count(rating) AS number_ratings -- Add the total number of ratings here.
FROM renting
WHERE date_renting >= '2019-01-01';



                                                               --Chapter2: Decision Making with simple SQL queries


                --    First account for each country.

--Conduct an analysis to see when the first customer accounts were created for each country.
--Create a table with a row for each country and columns for the country name and the date when the first customer account was created.
--Use the alias first_account for the column with the dates.
--Order by date in ascending order.
SELECT country, -- For each country report the earliest date when an account was created
	min(date_account_start) AS first_account
FROM customers
GROUP BY country
ORDER BY first_account desc;

                --    Average movie ratings
--For each movie the average rating, the number of ratings and the number of views has to be reported. Generate a table with meaningful column names.
--Group the data in the table renting by movie_id and report the ID and the average rating.
SELECT movie_id, 
       avg(rating)    -- Calculate average rating per movie
FROM renting
Group by movie_id;

--Add two columns for the number of ratings and the number of movie rentals to the results table.
--Use alias names avg_rating, number_rating and number_renting for the corresponding columns.
SELECT movie_id, 
       AVG(rating) AS avg_rating, -- Use as alias avg_rating
       count(rating) AS number_rating ,      -- Add column for number of ratings with alias number_rating
       count(date_renting) AS number_renting      -- Add column for number of movie rentals with alias number_renting
FROM renting
GROUP BY movie_id;

--Order the rows of the table by the average rating such that it is in decreasing order.
--Observe what happens to NULL values.
SELECT movie_id, 
       AVG(rating) AS avg_rating,
       COUNT(rating) AS number_ratings,
       COUNT(*) AS number_renting
FROM renting
GROUP BY movie_id
order by avg_rating desc; -- Order by average rating in decreasing order


--Which statement is true for the movie with average rating null?
--Ans: The average is null because all of the ratings of the movie are null.
	
	
	
			--Average rating per customer

--Similar to what you just did, you will now look at the average movie ratings, this time for customers. So you will obtain a table with the average rating given 
--by each customer. Further, you will include the number of ratings and the number of movie rentals per customer. You will report these summary statistics only for 
--customers with more than 7 movie rentals and order them in ascending order by the average rating.

--Group the data in the table renting by customer_id and report the customer_id, the average rating, the number of ratings and the number of movie rentals.
--Select only customers with more than 7 movie rentals.
--Order the resulting table by the average rating in ascending order.
SELECT customer_id,  -- Report the customer_id
       AVG(rating), -- Report the average rating per customer
       COUNT(rating), -- Report the number of ratings per customer
       COUNT(*) -- Report the number of movie rentals per customer
FROM renting
GROUP BY customer_id
HAVING COUNT(*) > 7 -- Select only customers with more than 7 movie rentals
ORDER BY AVG(rating); -- Order by the average rating in ascending order


		--Join renting and customers
--For many analyses it is necessary to add customer information to the data in the table renting.

--1  Augment the table renting with all columns from the table customers with a LEFT JOIN.
--Use as alias' for the tables r and c respectively.
SELECT * -- Join renting with customers
FROM renting
LEFT JOIN customers
ON renting.customer_id=customers.customer_id;

--2  Select only records from customers coming from Belgium.

SELECT *
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
Where c.country='Belgium'; 

--3  Average ratings of customers from Belgium.

SELECT avg(rating) -- Average ratings of customers from Belgium
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
WHERE c.country='Belgium';


		--Aggregating revenue, rentals and active customers

--The management of MovieNow wants to report key performance indicators (KPIs) for the performance of the company in 2018. They are interested in measuring the
--financial successes as well as user engagement. Important KPIs are, therefore, the profit coming from movie rentals, the number of movie rentals and the number 
--of active customers.


--1  First, you need to join movies on renting to include the renting_price from the movies table for each renting record.
--Use as alias' for the tables m and r respectively.

SELECT *
FROM renting AS r
Left JOIN movies AS m -- Choose the correct join statment
ON r.movie_id=m.movie_id;

--2	Calculate the revenue coming from movie rentals, the number of movie rentals and the number of customers who rented a movie.

SELECT 
	SUM(m.renting_price), -- Get the revenue from movie rentals
	COUNT(*), -- Count the number of rentals
	COUNT(DISTINCT r.customer_id) -- Count the number of customers
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id;

--3	Now, you can report these values for the year 2018. Calculate the revenue in 2018, the number of movie rentals and the number of active customers in 2018. 
--An active customer is a customer who rented at least one movie in 2018.

SELECT 
	SUM(m.renting_price), 
	COUNT(*), 
	COUNT(DISTINCT r.customer_id)
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
-- Only look at movie rentals in 2018
WHERE date_renting between '2018-01-01' and '2018-12-31' ;

	
		--Movies and actors
--You are asked to give an overview of which actors play in which movie.

--Create a list of actor names and movie titles in which they act. Make sure that each combination of actor and movie appears only once.
--Use as an alias for the table actsin the two letters ai.
SELECT m.title, -- Create a list of movie titles and actor names
       a.name
FROM actsin at
LEFT JOIN movies AS m
ON m.movie_id = at.movie_id
LEFT JOIN actors AS a
ON a.actor_id = at.actor_id;

		--Income from movies

--How much income did each movie generate? To answer this question subsequent SELECT statements can be used.

--1	Use a join to get the movie title and price for each movie rental.

SELECT m.title, -- Use a join to get the movie title and price for each movie rental
       m.renting_price
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id=m.movie_id;

--2 	Report the total income for each movie.
--Order the result by decreasing income.

SELECT rm.title, -- Report the income from movie rentals for each movie 
       sum(renting_price) AS income_movie
FROM
       (SELECT m.title,  
               m.renting_price
       FROM renting AS r
       LEFT JOIN movies AS m
       ON r.movie_id=m.movie_id) AS rm
group by rm.title
ORDER BY income_movie desc; -- Order the result by decreasing income

--3	Which statement about the movie 'Django Unchained' is NOT correct?
--Ans: The income from 'Django Unchained' is higher than from 'Simone'.


		--Age of actors from the USA
--Now you will explore the age of American actors and actresses. Report the date of birth of the oldest and youngest US actor and actress.

--Create a subsequent SELECT statements in the FROM clause to get all information about actors from the USA.
--Give the subsequent SELECT statement the alias a.
--Report for actors from the USA the year of birth of the oldest and the year of birth of the youngest actor and actress.

SELECT gender, -- Report for male and female actors from the USA 
       max(year_of_birth), -- The year of birth of the oldest actor
       min(year_of_birth) -- The year of birth of the youngest actor
FROM
   (SELECT *-- Use a subsequen SELECT to get all information about actors from the USA
   from actors
   where nationality= 'USA') As a  -- Give the table the name a
GROUP BY gender;


		--Identify favorite movies for a group of customers
--Which is the favorite movie on MovieNow? Answer this question for a specific group of customers: for all customers born in the 70s.

    --1-- Augment the table renting with customer information and information about the movies.
--For each join use the first letter of the table name as alias.












