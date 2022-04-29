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

