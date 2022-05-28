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
	
	
					--








