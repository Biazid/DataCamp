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

        





