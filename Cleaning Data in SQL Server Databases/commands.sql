                                             		--Chapter 1: Cleaning Data in SQL Server Databases
					--Unifying flight formats I
/*
Cleaning data is important because frequently, you may acquire messy data that is not ready for analysis.

In this exercise, you need to get every register with more than 100 delays from the flight_statistics table. In a unique column, 
you have to concatenate the carrier_code, registration_code, and airport_code, having a similar format to this one: "AA - 000000119, JFK".

When analyzing the flight_statistics table, you realize that some registration_code values have different formats. 
A correct registration_code must have nine digits, and if it has fewer, you need to complete it with leading zeros.

To do this, you can use the REPLICATE() function in combination with LEN() and CONCAT().
*/
--Use the appropriate function to concatenate the carrier_code, the leading zeros before a registration code, the registration_code, and airport_code columns.
--Replicate as many zeros as needed by subtracting 9 from the length of each registration_code.
--Filter the registers where the delayed column is more than 100.

SELECT 
	-- Concat the strings
	CONCAT(
		carrier_code, 
		' - ', 
      	-- Replicate zeros
		REPLICATE('0', 9 - LEN(registration_code)), 
		registration_code, 
		', ', 
		airport_code)
	AS registration_code
FROM flight_statistics
-- Filter registers with more than 100 delays
WHERE delayed > 100

							--Unifying flight formats II

/*
In the previous exercise, you used CONCAT(), REPLICATE(), and LEN(). You got every register with more than 100 delays from the flight_statistics table. 
In a unique column, you concatenated the carrier_code, registration_code, and airport_code, having a similar format to this one: "AA - 0000119, JFK".

In this exercise, you will solve the same problem again, this time using the FORMAT() and CONCAT() functions together.
*/

--Concatenate the carrier_code, formatted registration_code, and airport_code together using the appropriate function.
--Format the registration_code column while casting it as an integer.
--Filter registers with more than 100 delays.

SELECT 
    -- Concat the strings
	CONCAT(
		carrier_code, 
		' - ', 
        -- Format the code
		FORMAT(CAST(registration_code AS INT), '0000000'),
		', ', 
		airport_code
	) AS registration_code
FROM flight_statistics
-- Filter registers with more than 100 delays
WHERE delayed > 100


						--Trimming strings I
/*
Messy strings can be a problem because sometimes, it is not easy to analyze them without cleaning them.

When analyzing the airports table, you realize that some values of the airport_name column are messy strings. These strings have leading and trailing spaces.

The TRIM() function can help you to remove these additional spaces for the airports table.
*/

--Examine the content of the airports table to see the leading and trailing spaces.
--Use the appropriate function to remove the leading and trailing spaces.
--Select the source table where the data is.

SELECT 
	airport_code,
	-- Use the appropriate function to remove the extra spaces
    TRIM(airport_name) AS airport_name,
	airport_city,
    airport_state
-- Select the source table
FROM airports	


					--Trimming strings II
/*
In the previous exercise, you used TRIM() to remove the leading and trailing spaces for the values of the airport_name column.

Suppose that the TRIM() function is not available because you are using an older version of SQL Server 2017, so you this time you need to use LTRIM() and RTRIM().

How can you remove these extra spaces?
*/
-- Use the appropriate functions to remove the leading and trailing spaces.
--Select the source table where the data is

SELECT 
	airport_code,
	-- Use the appropriate function to remove the extra spaces
    LTRIM(RTRIM(airport_name)) AS airport_name,
	airport_city,
    airport_state
-- Select the source table
FROM airports


					--Unifying strings
/*
Sometimes it's common to find messy strings when having different values for the same thing. Although all of these values can be valid, 
it is better to unify them to perform better analysis.

You run this query to filter all the airports located in the city of 'Chicago':

SELECT * FROM airports 
WHERE airport_code IN ('ORD', 'MDW')
In the results, you see that there are inconsistent values for 'Chicago' in the airport_city column, with values such as 'ch'. 
You will treat these inconsistent values by replacing them.
*/

--1 Replace 'ch' with 'Chicago' - notice how 'Chicago' became 'Chicagoicago'.

SELECT 
	airport_code,
	airport_name,
    -- Use the appropriate function to unify the values
    REPLACE(airport_city, 'ch', 'Chicago') AS airport_city,
	airport_state
FROM airports  
WHERE airport_code IN ('ORD', 'MDW')

--2 Use CASE to replace 'ch' with 'Chicago' in all the rows that are not 'Chicago'.
--Do not change airport_city otherwise.


SELECT airport_code, airport_name, 
	-- Use the CASE statement
	CASE
    	-- Unify the values
		WHEN airport_city <> 'Chicago' THEN REPLACE(airport_city, 'ch', 'Chicago')
		ELSE airport_city 
	END AS airport_city,
    airport_state
FROM airports
WHERE airport_code IN ('ORD', 'MDW')

--3 Unify 'Chicago' and 'ch' to 'CH' by replacing 'Chicago' with 'ch' and converting the output to upper case.

SELECT 
	airport_code, airport_name,
    	-- Convert to uppercase
    	UPPER(
            -- Replace 'Chicago' with 'ch'.
          	REPLACE(airport_city, 'Chicago', 'ch')
        ) AS airport_city,
    airport_state
FROM airports
WHERE airport_code IN ('ORD', 'MDW')



						--SOUNDEX() and DIFFERENCE()
/*
Sometimes, you can find messy strings that are written differently, but their sounds are similar or almost similar. 
SQL Server provides the SOUNDEX() and DIFFERENCE() functions as a help to detect those strings.

Which of the following is FALSE about these functions?

Ans:  SOUNDEX() returns a three-character code used to evaluate the similarity between strings, based on their pronunciation.
*/
						
						--Comparing names with SOUNDEX()
/*
Messy strings like 'Ilynois' instead of 'Illinois' can cause problems when analyzing data. That is why it is important to detect them.

When analyzing the flight_statistics table, you realize that some statistician_name and statistician_surname are written in a different way, 
such as Miriam Smith and Myriam Smyth. You are afraid there are more differences like this, so you want to check all these names.

You think about comparing with SOUNDEX() the names of the statisticians. If the result of SOUNDEX() is the same, but the texts you are comparing are different, 
you will find the data you need to clean.
*/

--Select the distinct values of statistician_name and statistician_surname columns from S1.
--Inner join the flight_statistics table as S2 on similar-sounding first names and surnames using SOUNDEX().
--Filter out values where the statistician_name and statistician_surname columns are different from each other in S1 and S2, respectively.

SELECT 
    -- First name and surname of the statisticians
	DISTINCT S1.statistician_name, S1.statistician_surname
-- Join flight_statistics with itself
FROM flight_statistics S1 INNER JOIN flight_statistics S2 
	-- The SOUNDEX result of the first name and surname have to be the same
	ON SOUNDEX(S1.statistician_name) = SOUNDEX(S2.statistician_name) 
	AND SOUNDEX(S1.statistician_surname) = SOUNDEX(S2.statistician_surname) 
-- The texts of the first name or the texts of the surname have to be different
WHERE S1.statistician_name <> S2.statistician_name
	OR S1.statistician_surname <> S2.statistician_surname
	
	
					--Comparing names with DIFFERENCE()
/*
In the previous exercise, you used SOUNDEX() to check the names of the statisticians from the flight_statistics table.

This time, you want to do something similar, but using the DIFFERENCE() function. 
DIFFERENCE() returns 4 when there is a similar or identically matching between two strings, and 0 when there is little or no similarity,

If the result of DIFFERENCE() between two strings is 4, but the texts you are comparing are different, you will find the data you need to clean.
*/

--Select the distinct values of statistician_name and statistician_surname columns from S1.
--Inner join the flight_statistics table as S2 on similar-sounding first names and surnames on instances where the DIFFERENCE between each table's column is 4.
--Filter out values where the statistician_name and statistician_surname columns are different from each other in S1 and S2 respectively.

SELECT 
    -- First name and surnames of the statisticians
	DISTINCT S1.statistician_name, S1.statistician_surname
-- Join flight_statistics with itself
FROM flight_statistics S1 INNER JOIN flight_statistics S2 
	-- The DIFFERENCE of the first name and surname has to be equals to 4
	ON DIFFERENCE(S1.statistician_name, S2.statistician_name) = 4
	AND DIFFERENCE(S1.statistician_surname, S2.statistician_surname) = 4
-- The texts of the first name or the texts of the surname have to be different
WHERE S1.statistician_name <> S2.statistician_name
	OR S1.statistician_surname <> S2.statistician_surname
	
	
	
	
							--Chapter2:  Dealing with missing data, duplicate data, and different date formats

					--Removing missing values
/*
It is common to find missing values in your data. SQL Server represents missing values with NULL.

IS NULL and IS NOT NULL enable you to select or remove the rows where missing values are represented by NULL.

The airport_city column of the airports table has some NULL values. Try to find them!
*/
--1 Use IS NOT NULL to return all the rows from the airports table where airport_city is not missing.

SELECT *
-- Select the appropriate table
FROM airports
-- Exclude the rows where airport_city is NULL
WHERE airport_city IS NOT NULL

--2 Now, use IS NULL to return all the rows from the airports table where airport_city is missing.

SELECT *
-- Select the appropriate table
FROM airports
-- Return only the rows where airport_city is NULL
WHERE airport_city IS NULL

					--Removing blank spaces
/*
You can also find missing data represented with blank spaces ''.

The comparison operators = and <> can help you to select or remove the rows when missing values are represented with blank spaces ''.

The airport_city column of the airports table has some blank spaces. Try to find them!
*/

--1 Use <> to return all the rows from the airports table where airport_city is not missing.

SELECT *
-- Select the appropriate table
FROM airports
-- Exclude the rows where airport_city is missing
WHERE airport_city <> ''

--2  SELECT *
-- Select the appropriate table
FROM airports
-- Return only the rows where airport_city is missing
WHERE airport_city = ''


					--Filling missing values using ISNULL()
/*
In the previous exercise, you practiced how to exclude and select the rows with NULL values. 
However, depending on the business assumptions behind your data, you may want to select all the rows with NULL values, 
but replacing these NULL values with another value. You can do it using ISNULL().

Now, you want to replace all the NULL values for the airport_city and airport_state columns with the word 'Unknown', using ISNULL().
*/

--Replace the missing values for airport_city column with the 'Unknown' string.
--Replace the missing values for airport_state column with the 'Unknown' string.

SELECT
  airport_code,
  airport_name,
  -- Replace missing values for airport_city with 'Unknown'
  ISNULL(airport_city, 'Unknown') AS airport_city,
  -- Replace missing values for airport_state with 'Unknown'
  ISNULL(airport_state, 'Unknown') AS airport_state
FROM airports

				--Filling missing values using COALESCE()
/*
In the previous exercise, you used the ISNULL() function to replace the NULL values of a column with another value.

Now, you want to create a new column, location, that returns the values of the airport_city column, and in case it has NULL values, 
return the value of airport_state. Finally, if airport_state is also NULL, you want to return the string 'Unknown'.

To do it, you can use COALESCE(), that evaluates the arguments between parenthesis and returns the first argument that is not NULL.
*/
--Use COALESCE() to return the first non NULL value of airport_city, airport_state, or 'Unknown'.

SELECT
airport_code,
airport_name,
-- Replace the missing values
COALESCE(airport_city, airport_state, 'Unknown') AS location
FROM airports


				--Diagnosing duplicates

/*
In this lesson, you learned how to use the ROW_NUMBER() function. ROW_NUMBER() returns a number which begins at 1 for the first row in every partition,
and provides a sequential number for each row within the same partition.

Considering that the partition for the statistics_flight table is formed by the columns airport_code, carrier_code, and registration_date, 
can you guess what value will give the ROW_NUMBER() function in the row_num column for the last row?


|registration_code|airport_code|carrier_code|registration_date|canceled|on_time|row_num|
|-----------------|------------|------------|-----------------|--------|-------|-------|
|000000137        |MSP         |EV          |2014-01-01       |117     |369    |1      |
|000000138        |MSP         |F9          |2014-01-01       |0       |60     |1      |
|000000139        |MSP         |FL          |2014-01-01       |8       |83     |1      |
|000000140        |MSP         |MQ          |2014-01-01       |20      |67     |1      |
|000000141        |MSP         |OO          |2014-01-01       |76      |1031   |1      |
|000000142        |MSP         |OO          |2014-01-01       |76      |1031   |2      |
|000000143        |MSP         |OO          |2014-01-01       |76      |1031   |???????|
----------------------------------------------------------------------------------------

Ans: 3
*/


						--Treating duplicates
/*
In the previous exercise, you reviewed the concept of ROW_NUMBER(). In this exercise, you will use it in your code.

You want to select all the rows from the flight_statistics table that are duplicated. After that, you want to get all the rows without duplicates. 
You consider that the repeating group for this table is formed by the columns airport_code, carrier_code, and registration_date.
*/

--1 First of all, apply the ROW_NUMBER() function to the flight_statistics table.
--Consider that partitions will be formed by the columns airport_code, carrier_code, and registration_date.


SELECT *,
	   -- Apply ROW_NUMBER()
       ROW_NUMBER() OVER (
         	-- Write the partition
            PARTITION BY 
                airport_code, 
                carrier_code, 
                registration_date
			ORDER BY 
                airport_code, 
                carrier_code, 
                registration_date
        ) row_num
FROM flight_statistics

--2 Wrap the previous query with the WITH clause to select the duplicate rows.
--Get just the duplicate rows comparing row_num with a number.

-- Use the WITH clause
WITH cte AS (
    SELECT *, 
        ROW_NUMBER() OVER (
            PARTITION BY 
                airport_code, 
                carrier_code, 
                registration_date
			ORDER BY 
                airport_code, 
                carrier_code, 
                registration_date
        ) row_num
    FROM flight_statistics
)
SELECT * FROM cte
-- Get only duplicates
WHERE row_num > 1;


--3 Modify the previous query to exclude the duplicate rows by comparing row_num with a number.

WITH cte AS (
    SELECT *, 
        ROW_NUMBER() OVER (
            PARTITION BY 
                airport_code, 
                carrier_code, 
                registration_date
			ORDER BY 
                airport_code, 
                carrier_code, 
                registration_date
        ) row_num
    FROM flight_statistics
)
SELECT * FROM cte
-- Exclude duplicates
WHERE row_num = 1;



					--Using CONVERT()
/*
The CONVERT() function can help you to convert dates into the desired format.

You need to get a report of the airports, carriers, canceled flights, and registration dates, registered in the first six months of the year 2014. 
You realize that the format of the registration_date column is yyyy-mm-dd, and you want to show the results in the format of mm/dd/yyyy, which is hardcoded as 101, using the CONVERT() function.

Notice that the type of the registration_date column is VARCHAR(10) and not a date.
*/

--Convert the type of the registration_date column to DATE and print it in mm/dd/yyyy format.
--Convert the registration_date column to mm/dd/yyyy format to filter the results.
--Filter the results for the first six months of 2014 in mm/dd/yyyy format.

SELECT 
    airport_code,
    carrier_code,
    canceled,
    -- Convert the registration_date to a DATE and print it in mm/dd/yyyy format
    CONVERT(VARCHAR(10), CAST(registration_date AS DATE), 101) AS registration_date
FROM flight_statistics 
-- Convert the registration_date to mm/dd/yyyy format
WHERE CONVERT(VARCHAR(10), CAST(registration_date AS DATE), 101) 
	-- Filter the first six months of 2014 in mm/dd/yyyy format 
	BETWEEN '01/01/2014' AND '06/31/2014'



				--Using FORMAT()
/*
Unlike the CONVERT() function, the FORMAT() function takes in the format as a string as such 'dd/MM/yyyy'.

You need to get a report of all the pilots. You realize that the format of the entry_date column is 'yyyy-MM-dd',
and you want to show the results in the format of 'dd/MM/yyyy'. As this table contains few data, you think about using the FORMAT() function.

Notice that the type of the entry_date column is VARCHAR(10) and not a date.
*/

--Convert the type of the entry_date column to DATE and print it in 'dd/MM/yyyy' format.

SELECT 
	pilot_code,
	pilot_name,
	pilot_surname,
	carrier_code,
    -- Convert the entry_date to a DATE and print it in dd/MM/yyyy format
	FORMAT(CAST(entry_date AS DATE), 'dd/MM/yyyy') AS entry_date
from pilots



				--CONVERT() vs FORMAT()
/*
In this lesson, you learned how to use the CONVERT() and the FORMAT() functions.

Which of the following features about them is true?
Ans: FORMAT() is more flexible, but it is not recommended for high volumes of data because it is slower.

*/


						--Chapter 3: Dealing with out of range values, different data types, and pattern matching
				--Out of range values or inaccurate data?
/*
In this lesson, you learned the concepts of out of range values and inaccurate data.

Which of the following features about them is true?

1. Out of range values are values that are outside the expected range of valid data. For example, the color of the car of a person who doesn't have a car.

2. Inaccurate data happens when two or more values are contradictory. For example, a person who is 400 inches tall.

3. None of the above. (ANS)
*/

				--Detecting out of range values
/*
Sometimes you can find out of range values in your data. If you don't detect them before analyzing, they can disrupt your results.

The logical operator BETWEEN, and the comparison operators > and <, can help you to detect the rows with out of range values.

The num_ratings column of the series table stores the number of ratings each series has received. The total amount of people surveyed is 5000. However, 
this column has some out of range values, i.e., there are values greater than 5000 or smaller than 0.
*/
--1 Find rows in series where num_ratings is not between 0 and 5000.

SELECT * FROM series
-- Detect the out of range values
WHERE num_ratings NOT BETWEEN 0 AND 5000

--2 Similarly, use < and > to detect the rows from the series table where num_ratings is not between 0 and 5000.

SELECT * FROM series
-- Detect the out of range values
WHERE num_ratings < 0 OR num_ratings > 5000


					--Excluding out of range values
/*
In the previous exercise, you detected the rows with a number of ratings that were out of range.

The logical operator BETWEEN, and the comparison operators >, <, and =, can help you to exclude the rows with out of range values.

This time, you want to get all the rows from the series table, ranging from 0 to 5000.
*/
--1 Use BETWEEN to detect all the rows from the series table where num_ratings is a value ranging from 0 to 5000.

SELECT * FROM series
-- Exclude the out of range values
WHERE num_ratings BETWEEN 0 AND 5000

--2 Similarly, use <, >, and = to detect the rows from the series table where num_ratings is between 0 and 5000.

SELECT * FROM series
-- Exclude the out of range values
WHERE num_ratings >= 0 AND num_ratings <= 5000


				--Detecting and excluding inaccurate data
/*
In this lesson, you also learned that if you don't detect inaccurate data before analyzing, this data can disrupt your results.

The series table has a boolean column named is_adult, that stores whether the series is for adults or not. There is also another column, min_age, 
that stores the minimum age the audience should have. Unfortunately, there are contradictory values, 
because some rows with a TRUE value in its is_adult column have a number smaller than 18 in its min_age column.

Can you find these rows with inaccurate data?
*/

--1 Detect the series with a true value in its is_adult column that have a value smaller than 18 in its min_age column.

SELECT * FROM series
-- Detect series for adults
WHERE is_adult = 1
-- Detect series with the minimum age smaller than 18
AND min_age < 18

--2 Now exclude the series with a true value in its is_adult column that have a value smaller than 18 in its min_age column.

SELECT * FROM series
-- Filter series for adults
WHERE is_adult = 1
-- Exclude series with the minimum age greater or equals to 18
AND min_age >= 18


				--Using CAST() and CONVERT()
/*
In this lesson, you learned that your tables could store data with different types than you want. Sometimes you will need to convert these types to the correct ones to perform the operations you want.

The series table has a column named num_ratings that stores integer numbers, but this time it was designed as VARCHAR(5). You want to calculate the average of the num_ratings column, but you think that this column is an integer number.

You prepare the following query:

SELECT AVG(num_ratings)
FROM series
WHERE num_ratings BETWEEN 0 AND 5000

*/
--1 Run the query given above to check there are errors.
--Use CAST() to convert the type of num_ratings to integer.

-- Use CAST() to convert the num_ratings column
SELECT AVG(CAST(num_ratings AS INT))
FROM series
-- Use CAST() to convert the num_ratings column
WHERE CAST(num_ratings AS INT) BETWEEN 0 AND 5000

--2 Now, use CONVERT() instead of CAST() to convert the type of the num_ratings column to integer.

-- Use CONVERT() to convert the num_ratings column
SELECT AVG(CONVERT(INT, num_ratings))
FROM series
-- Use CONVERT() to convert the num_ratings column
WHERE CONVERT(INT, num_ratings) BETWEEN 0 AND 5000


			--The series with most episodes
/*
In the episodes table, there is a column named number. It stores the number of each episode within a season for every series. 
This column was designed as VARCHAR(5), but it actually stores numbers.

Can you guess which is the series with most episodes within a season?

Note: To get the name of the series you will need to perform an INNER JOIN between series and episodes, matching the columns series.id with episodes.series_id.

Ans: Adventure Time
*/

				--Characters to specify a patterns
/*
In this lesson, you learned the different characters we can use to specify patterns.

Which of the following statements about these characters is false?

Ans: [] matches any single character, not within the specified range or set.

*/
				--Matching urls
/*
In this lesson you learned that SQL Server provides the LIKE operator, which determines if a string matches a specified pattern.

You need to verify the URLs of the official sites of every series. You prepare a script that checks every official_site value from the series table to analyze possible wrong URLs.

To make it easier, suppose that the format of the URLs you have to validate must start with 'www.', although we know that there are URLs that have other beginnings.

*/

--Select the URLs of the official sites.
--Get the URLs that don't match the pattern.
--Write the pattern.

SELECT 
	name,
    -- URL of the official site
	official_site
FROM series
-- Get the URLs that don't match the pattern
WHERE official_site NOT LIKE 'www.%'

				--Checking phone numbers
/*
As you learned in this lesson, the underscore _ symbol matches any single character.

You want to prepare a script that checks every contact_number value from the series table to get those numbers that don't start with three fives followed by a 
hyphen as such 555-, then three characters followed by another hyphen and finally, another four characters (555-###-####).

Can you find them?
*/
--Select the contact number.
--Get the numbers of contacts that don't match the pattern.
--Write the pattern that the numbers have to match.

SELECT 
	name,
    contact_number
FROM series
WHERE contact_number NOT LIKE '555-___-____'	


							
							--Chapter 4: Combining, splitting, and transforming data

					--Combining cities and states using +
/*
In this lesson, you learned how to combine columns into one.

The clients table has one column, city, to store the cities where the clients live, and another column, state, to store the state of the city.

| client_id | client_name | client_surname | city      | state    |
|-----------|-------------|----------------|-----------|----------|
| 1         | Miriam      | Antona         | Las Vegas | Nevada   |
| 2         | Astrid      | Harper         | Chicago   | Illinois |
| 3         | David       | Madden         | Phoenix   | Arizona  |
| ...       | ...         | ...            | ...       | ...      |
You need to combine city and state columns into one, to have the following format: 'Las Vegas, Nevada'.

You will use + operator to do it.
*/

--1 Concatenate the names of the cities with the states using the + operator without worrying about NULL values.











































