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
SELECT *
FROM renting AS r
LEFT JOIN customers c   -- Add customer information
on r.customer_id=c.customer_id
LEFT JOIN movies m   -- Add movie information
on m.movie_id=r.movie_id;

--2--Select only those records of customers born in the 70s.
SELECT *
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
where c.date_of_birth between '1970-01-01' and '1979-12-31'; -- Select customers born in the 70s

--3--For each movie, report the number of times it was rented, as well as the average rating. Limit your results to customers born in the 1970s.

SELECT m.title, 
    count(*), -- Report number of views per movie
    avg(r.rating) -- Report the average rating per movie
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE c.date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'
group by m.title;

--4--Remove those movies from the table with only one rental.
--Order the result table such that movies with highest rating come first.
SELECT m.title, 
COUNT(*),
AVG(r.rating) 
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE c.date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'
GROUP BY m.title
HAVING COUNT(*) > 1  -- Remove movies with only one rental
ORDER BY AVG(r.rating) DESC; -- Order with highest rating first


		--Identify favorite actors for Spain

--You're now going to explore actor popularity in Spain. Use as alias the first letter of the table, except for the table actsin use ai instead.
--1--Augment the table renting with information about customers and actors.

SELECT *
FROM renting as r 
LEFT JOIN customers c  -- Augment table renting with information about customers 
on r.customer_id=c.customer_id
LEFT JOIN actsin ai  -- Augment the table renting with the table actsin
on ai.movie_id=r.movie_id
LEFT JOIN actors a  -- Augment table renting with information about actors
on a.actor_id=act.actor_id

--2--Report the number of movie rentals and the average rating for each actor, separately for male and female customers.
--Report only actors with more than 5 movie rentals.

SELECT a.name,  c.gender,
       COUNT(*) AS number_views, 
       AVG(r.rating) AS avg_rating
FROM renting as r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN actsin as ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors as a
ON ai.actor_id = a.actor_id
GROUP BY a.name, c.gender -- For each actor, separately for male and female customers
HAVING AVG(r.rating) IS NOT NULL 
  AND COUNT(*) > 5 -- Report only actors with more than 5 movie rentals
ORDER BY avg_rating DESC, number_views DESC;


--3--Now, report the favorite actors only for customers from Spain.
SELECT a.name,  c.gender,
       COUNT(*) AS number_views, 
       AVG(r.rating) AS avg_rating
FROM renting as r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN actsin as ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors as a
ON ai.actor_id = a.actor_id
Where c.country='Spain' -- Select only customers from Spain
GROUP BY a.name, c.gender
HAVING AVG(r.rating) IS NOT NULL 
  AND COUNT(*) > 5 
ORDER BY avg_rating DESC, number_views DESC;


		--KPIs per country

/*
In chapter 1 you were asked to provide a report about the development of the company. This time you have to prepare a similar report with KPIs for each country 
separately. Your manager is interested in the total number of movie rentals, the average rating of all movies and the total revenue for each country since the 
beginning of 2019.
*/
--1--Augment the table renting with information about customers and movies.
--Use as alias the first latter of the table name.
--Select only records about rentals since beginning of 2019.

SELECT *
FROM renting r-- Augment the table renting with information about customers
LEFT JOIN customers c
on r.customer_id=c.customer_id
LEFT JOIN movies m-- Augment the table renting with information about movies
on m.movie_id=r.movie_id
where date_renting>= '2019-01-01'; 

--2--Calculate the number of movie rentals.
--Calculate the average rating.
--Calculate the revenue from movie rentals.
--Report these KPIs for each country.

SELECT 
	distinct country ,                   -- For each country report
	count(*) AS number_renting, -- The number of movie rentals
	avg(rating) AS average_rating, -- The average rating
	sum(renting_price) AS revenue         -- The revenue from movie rentals
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE date_renting >= '2019-01-01'
group by country;




								--Chapter 3: Data Driven Decision Making with advanced SQL queries


		--Often rented movies	

--Your manager wants you to make a list of movies excluding those which are hardly ever watched. This list of movies will be used for advertising. 
--List all movies with more than 5 views using a nested query which is a powerful tool to implement selection conditions.

--1--Select all movie IDs which have more than 5 views.

SELECT movie_id, count(*) 
FROM renting
group by movie_id
having count(*)>5

--2--Select all information about movies with more than 5 views.

SELECT *
FROM movies
where movie_id in
	(SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(*) > 5)
	
	
		--Frequent customers
--Report a list of customers who frequently rent movies on MovieNow.

--List all customer information for customers who rented more than 10 movies.

SELECT *
FROM customers
WHERE customer_id IN 
	(SELECT customer_id
	FROM renting
	GROUP BY customer_id
	HAVING COUNT(*) > 10);
	
	
		--Movies with rating above average


--For the advertising campaign your manager also needs a list of popular movies with high ratings. Report a list of movies with rating above average.

--1 Calculate the average over all ratings.
select avg(rating)
from renting

--2 Select movie IDs and calculate the average rating of movies with rating above average.

SELECT movie_id, -- Select movie IDs and calculate the average rating 
       avg(rating)
FROM renting
group by movie_id
having avg(rating) >        
	(SELECT AVG(rating)
	FROM renting);


--3 The advertising team only wants a list of movie titles. Report the movie titles of all movies with average rating higher than the total average.

SELECT title 
WHERE movie_id in
	(SELECT movie_id
	 FROM renting
     GROUP BY movie_id
     HAVING AVG(rating) > 
		(SELECT AVG(rating)
		 FROM renting));
		 	
			
			
			--Analyzing customer behavior
			
			
--A new advertising campaign is going to focus on customers who rented fewer than 5 movies. Use a correlated query to extract all customer information 
--for the customers of interest.

--1 First, count number of movie rentals for customer with customer_id=45. Give the table renting the alias r.

-- Count movie rentals of customer 45
select count(*)
from renting r
where r.customer_id=45;

--2 Now select all columns from the customer table where the number of movie rentals is smaller than 5.

-- Select customers with less than 5 movie rentals
SELECT *
FROM customers as c
WHERE 5> 
	(SELECT count(*)
	FROM renting as r
	WHERE r.customer_id = c.customer_id);
	
	
	
			--Customers who gave low ratings



--Identify customers who were not satisfied with movies they watched on MovieNow. Report a list of customers with minimum rating smaller than 4.

--1 Calculate the minimum rating of customer with ID 7.


-- Calculate the minimum rating of customer with ID 7
SELECT min(rating)
from renting
where customer_id=7;

--2 Select all customers with a minimum rating smaller than 4. Use the first letter of the table as an alias.

SELECT *
FROM customers c
WHERE 4 > 
	(SELECT MIN(rating)
	FROM renting AS r
	WHERE r.customer_id = c.customer_id);
	
		
		
		--Movies and ratings with correlated queries



--Report a list of movies that received the most attention on the movie platform, (i.e. report all movies with more than 5 ratings and all movies 
--with an average rating higher than 8).

--1 Select all movies with more than 5 ratings. Use the first letter of the table as an alias.

SELECT *
FROM movies m
WHERE 5 < -- Select all movies with more than 5 ratings
	(SELECT count(rating)
	FROM renting r
	WHERE r.movie_id=m.movie_id);
	
--2 Select all movies with an average rating higher than 8.

SELECT *
FROM movies AS m
WHERE 8 < 
	(SELECT avg(rating)
	FROM renting AS r
	WHERE r.movie_id = m.movie_id);



				--Customers with at least one rating

						
-- Having active customers is a key performance indicator for MovieNow. Make a list of customers who gave at least one rating.

--1  Select all records of movie rentals from customer with ID 115.
select *
from renting
where customer_id=115;

--2 Select all records of movie rentals from the customer with ID 115 and exclude records with null ratings.
SELECT *
FROM renting
WHERE rating is not null 
AND customer_id = 115;

--3 Select all records of movie rentals from the customer with ID 1, excluding null ratings.
SELECT *
FROM renting
WHERE rating is not null 
and customer_id=1;

--4 Select all customers with at least one rating. Use the first letter of the table as an alias.
SELECT *
FROM customers AS c 
WHERE EXISTS
	(SELECT *
	FROM renting AS r
	WHERE rating IS NOT NULL 
	AND r.customer_id = c.customer_id);
	
	
		--Actors in comedies

--In order to analyze the diversity of actors in comedies, first, report a list of actors who play in comedies and then, the number of actors for each
--nationality playing in comedies.

--1 Select the records of all actors who play in a Comedy. Use the first letter of the table as an alias.
SELECT *
FROM actsin AS ai
LEFT JOIN movies AS m
on ai.movie_id=m.movie_id
WHERE m.genre = 'Comedy';

--2 Make a table of the records of actors who play in a Comedy and select only the actor with ID 1.
SELECT *
FROM actsin AS ai
LEFT JOIN movies AS m
ON m.movie_id = ai.movie_id
WHERE m.genre = 'Comedy'
AND ai.actor_id=1; 

--3 Create a list of all actors who play in a Comedy. Use the first letter of the table as an alias.
SELECT *
FROM actors AS a
WHERE EXISTS
	(SELECT *
	 FROM actsin AS ai
	 LEFT JOIN movies AS m
	 ON m.movie_id = ai.movie_id
	 WHERE m.genre = 'Comedy'
	 AND ai.actor_id = a.actor_id);

--4 Report the nationality and the number of actors for each nationality.
SELECT a.nationality, count(*)
FROM actors AS a
WHERE EXISTS
	(SELECT ai.actor_id
	 FROM actsin AS ai
	 LEFT JOIN movies AS m
	 ON m.movie_id = ai.movie_id
	 WHERE m.genre = 'Comedy'
	 AND ai.actor_id = a.actor_id)
Group by a.nationality;

		
			
			-- Young actors not coming from the USA
			
--As you've just seen, the operators UNION and INTERSECT are powerful tools when you work with two or more tables. 
--Identify actors who are not from the USA and actors who were born after 1990.

--1 Report the name, nationality and the year of birth of all actors who are not from the USA.

SELECT name,  -- Report the name, nationality and the year of birth
       nationality, 
       year_of_birth
FROM actors
where nationality<>'USA'; -- Of all actors who are not from the USA

--2 Report the name, nationality and the year of birth of all actors who were born after 1990.

SELECT name, 
       nationality, 
       year_of_birth
FROM actors
where year_of_birth>1990;

--3 Select all actors who are not from the USA and all actors who are born after 1990.

SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA'
UNION 
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990;

--4 Select all actors who are not from the USA and who are also born after 1990.

SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA'
INTERSECT 
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990;


					--	Dramas with high ratings

--The advertising team has a new focus. They want to draw the attention of the customers to dramas. 
--Make a list of all movies that are in the drama genre and have an average rating higher than 9.

--1 Select the IDs of all dramas.

SELECT movie_id 
FROM movies
where genre='Drama';

--2 Select the IDs of all movies with average rating higher than 9.

SELECT movie_id
FROM renting
GROUP BY movie_id
having avg(rating)>9;

--3 Select the IDs of all dramas with average rating higher than 9.

SELECT movie_id
FROM movies
WHERE genre = 'Drama'
INTERSECT  
SELECT movie_id
FROM renting
GROUP BY movie_id
HAVING AVG(rating)>9;

--4 Select all movies of in the drama genre with an average rating higher than 9.

SELECT *
FROM movies
where movie_id in
   (SELECT movie_id
    FROM movies
    WHERE genre = 'Drama'
    INTERSECT
    SELECT movie_id
    FROM renting
    GROUP BY movie_id
    HAVING AVG(rating)>9);
    
    
	
				--	Chapter 4: Data Driven Decision Making with OLAP SQL queries	--
				--------------------------------------------------------------------------
				
				
			--Groups of customers

--Use the CUBE operator to extract the content of a pivot table from the database. Create a table with the total number of male and female customers from each country.

--Create a table with the total number of customers, of all female and male customers, of the number of customers for each country and the number of men and 
--women from each country.

SELECT gender, -- Extract information of a pivot table of gender and country for the number of customers
	   country,
	   count(*)
FROM customers
GROUP BY CUBE (gender, country)
ORDER BY country;

		--Categories of movies
--Give an overview on the movies available on MovieNow. List the number of movies for different genres and release years.

--1 List the number of movies for different genres and the year of release on all aggregation levels by using the CUBE operator.

SELECT genre,
       year_of_release,
       count(*)
FROM movies
GROUP BY CUBE(genre, year_of_release)
ORDER BY year_of_release;

--2 Which statement is NOT correct about the result table?

--Ans: The year of release with most movies is 2014.

		
		--Analyzing average ratings

--Prepare a table for a report about the national preferences of the customers from MovieNow comparing the average rating of movies across countries and genres.

--1 Augment the records of movie rentals with information about movies and customers, in this order. Use the first letter of the table names as alias.

SELECT *
FROM renting as r 
LEFT JOIN movies as m 
ON r.movie_id=m.movie_id
LEFT JOIN customers as c 
ON r.customer_id=c.customer_id;


--2 Calculate the average rating for each country.

SELECT 
	c.country,
    avg(r.rating)
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
Group by c.country;


--3 Calculate the average rating for all aggregation levels of country and genre.

SELECT 
	c.country, 
	m.genre, 
	AVG(r.rating) AS avg_rating -- Calculate the average rating 
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY CUBE(c.country,m.genre);

--4 What is the average rating over all records, rounded to two digits?
--Ans: 7.94


		--Number of customers
-- You have to give an overview of the number of customers for a presentation.

--Generate a table with the total number of customers, the number of customers for each country, and the number of female and male customers for each country.
--Order the result by country and gender.
SELECT country,
       gender,
	   COUNT(*)
FROM customers
Group by rollup (country, gender)
order by country, gender;


		--Analyzing preferences of genres across countries
--You are asked to study the preferences of genres across countries. Are there particular genres which are more popular in specific countries? 
--Evaluate the preferences of customers by averaging their ratings and counting the number of movies rented from each genre.

--1 Augment the renting records with information about movies and customers.

SELECT *
FROM renting AS r
left join movies AS m
ON m.movie_id=r.movie_id
left join customers AS c
ON r.customer_id=c.customer_id;

--2 Calculate the average ratings and the number of ratings for each country and each genre. Include the columns country and genre in the SELECT clause.

SELECT 
	country, -- Select country
	genre, -- Select genre
	avg(rating), -- Average ratings
	count(*)  -- Count number of movie rentals
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY country, genre -- Aggregate for each country and each genre
ORDER BY c.country, m.genre;


--3 Finally, calculate the average ratings and the number of ratings for each country and genre, as well as an aggregation over all genres for each country 
--and the overall average and total number.


-- Group by each county and genre with OLAP extension
SELECT 
	c.country, 
	m.genre, 
	AVG(r.rating) AS avg_rating, 
	COUNT(*) AS num_rating
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY rollup(c.country,m.genre)
ORDER BY c.country, m.genre;

		
			--Queries with GROUPING SETS
--What question CANNOT be answered by the following query?

SELECT 
  r.customer_id, 
  m.genre, 
  AVG(r.rating), 
  COUNT(*)
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
GROUP BY GROUPING SETS ((r.customer_id, m.genre), (r.customer_id), ());

--How many movies were watched by each customer?

--What is the average rating for each genre?

--What is the average rating of customer 75 for movies of the Comedy genre?

--What is the overall average rating for all movies from all customers?


--Ans: What is the average rating for each genre?


		--Exploring nationality and gender of actors
--For each movie in the database, the three most important actors are identified and listed in the table actors. This table includes the nationality and 
--gender of the actors. We are interested in how much diversity there is in the nationalities of the actors and how many actors and actresses are in the list.

--Count the number of actors in the table actors from each country, the number of male and female actors and the total number of actors.

SELECT 
	nationality, -- Select nationality of the actors
    gender, -- Select gender of the actors
    count(*) -- Count the number of actors
FROM actors
GROUP BY GROUPING SETS ((nationality), (gender), ());

		--Exploring rating by country and gender
--Now you will investigate the average rating of customers aggregated by country and gender.

--1 Select the columns country, gender, and rating and use the correct join to combine the table renting with customer.
SELECT 
	country, 
    gender,
    rating
FROM renting AS r
Left Join customers AS c
ON c.customer_id=r.customer_id;

--2 Use GROUP BY to calculate the average rating over country and gender. Order the table by country and gender.


SELECT 
	c.country, 
    c.gender,
	avg(rating) -- Calculate average rating
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
Group by c.country, c.gender -- Order and group by country and gender
ORDER BY c.country, c.gender;


--3 Now, use GROUPING SETS to get the same result, i.e. the average rating over country and gender.


SELECT 
	c.country, 
    c.gender,
	AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
Group by Grouping SETS ((Country, gender));

--4 Report all information that is included in a pivot table for country and gender in one SQL table.


SELECT 
	c.country, 
    c.gender,
	AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
-- Report all info from a Pivot table for country and gender
GROUP BY GROUPING SETS ((country, gender), (country), (gender), ());


			--Customer preference for genres

--You just saw that customers have no clear preference for more recent movies over older ones. Now the management considers investing money 
--in movies of the best rated genres.

--1 Augment the records of movie rentals with information about movies. Use the first letter of the table as alias.

SELECT *
FROM renting AS r
Left Join movies AS m -- Augment the table with information about movies
on r.movie_id=m.movie_id;

--2 Select records of movies with at least 4 ratings, starting from 2018-04-01.

SELECT *
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING count(rating)>=4)
AND r.date_renting>'2018-04-01'; 

--3 For each genre, calculate the average rating (use the alias avg_rating), the number of ratings (use the alias n_rating), the number of movie rentals 
--(use the alias n_rentals), and the number of distinct movies (use the alias n_movies).

SELECT m.genre, 
	   avg(rating) avg_rating, -- The average rating and use the alias avg_rating
	   count(rating) n_rating, -- The number of ratings and use the alias n_rating
	   count(*) n_rentals,     -- The number of movie rentals and use the alias n_rentals
	   count(distinct r.movie_id) n_movies -- The number of distinct movies and use the alias n_movies
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 3)
AND r.date_renting >= '2018-01-01'
Group By m.genre;

--4 Order the table by decreasing average rating.

SELECT genre,
	   AVG(rating) AS avg_rating,
	   COUNT(rating) AS n_rating,
       COUNT(*) AS n_rentals,     
	   COUNT(DISTINCT m.movie_id) AS n_movies 
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 3 )
AND r.date_renting >= '2018-01-01'
GROUP BY genre
order by avg_rating desc; 


					--Customer preference for actors

--The last aspect you have to analyze are customer preferences for certain actors.

-- 1 Join the tables.

SELECT *
FROM renting AS r
LEFT JOIN actsin AS ai
on r.movie_id=ai.movie_id
LEFT JOIN actors AS a
on a.actor_id=ai.actor_id;			
			
			
-- 2 For each combination of the actors' nationality and gender, calculate the average rating, the number of ratings, the number of movie rentals, 
--and the number of actors.

SELECT a.nationality,
       a.gender,
	   AVG(r.rating) AS avg_rating, -- The average rating
	   COUNT(r.rating) AS n_rating, -- The number of ratings
	   COUNT(*) AS n_rentals, -- The number of movie rentals
	   COUNT(DISTINCT a.actor_id) AS n_actors -- The number of actors
FROM renting AS r
LEFT JOIN actsin AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN actors AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >=4 )
AND r.date_renting >= '2018-04-01'
GROUP BY a.nationality, a.gender;

--3 Provide results for all aggregation levels represented in a pivot table.

SELECT a.nationality,
       a.gender,
	   AVG(r.rating) AS avg_rating,
	   COUNT(r.rating) AS n_rating,
	   COUNT(*) AS n_rentals,
	   COUNT(DISTINCT a.actor_id) AS n_actors
FROM renting AS r
LEFT JOIN actsin AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN actors AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 4)
AND r.date_renting >= '2018-04-01'
GROUP BY CUBE (nationality,gender); 


			
			
			
			
