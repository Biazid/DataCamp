--                                                                Chapter 1: Working with Dates and Times
/*
SQL Server has a number of functions dedicated to working with date types. We will first analyze three functions which return integers representing 
the year, month, and day of month, respectively.

These functions can allow us to group dates together, letting us calculate running totals by year or month-over-month comparisons of expenditures.
We could also analyze sales by calendar day of the month to determine if there is a strong monthly cycle.
*/


--Use the YEAR(), MONTH(), and DAY() functions to determine the year, month, and day for the current date and time.
 DECLARE
	@SomeTime DATETIME2(7) = SYSUTCDATETIME();
-- Retrieve the year, month, and day
SELECT
	year(@SomeTime) AS TheYear,
	month(@SomeTime) AS TheMonth,
	day(@SomeTime) AS TheDay;
 
 
 
 
 
 							--Break a date and time into component parts



/*
Although YEAR(), MONTH(), and DAY() are helpful functions and are easy to remember, we often want to break out dates into different component parts such as 
the day of week, week of year, and second after the minute. This is where functions like DATEPART() and DATENAME() come into play.

Here we will use the night the Berlin Wall fell, November 9th, 1989.
*/


--1 Using the DATEPART() function, fill in the appropriate date parts. 
--For a list of parts, review https://docs.microsoft.com/en-us/sql/t-sql/functions/datepart-transact-sql
DECLARE
	@BerlinWallFalls DATETIME2(7) = '1989-11-09 23:49:36.2294852';
-- Fill in each date part
SELECT
	DATEPART(year, @BerlinWallFalls) AS TheYear,
	DATEPART(month, @BerlinWallFalls) AS TheMonth,
	DATEPART(day, @BerlinWallFalls) AS TheDay,
	DATEPART(DAYOFYEAR, @BerlinWallFalls) AS TheDayOfYear,
    -- Day of week is WEEKDAY
	DATEPART(WEEKDAY, @BerlinWallFalls) AS TheDayOfWeek,
	DATEPART(week, @BerlinWallFalls) AS TheWeek,
	DATEPART(second, @BerlinWallFalls) AS TheSecond,
	DATEPART(nanosecond, @BerlinWallFalls) AS TheNanosecond;
  
  
--2 Using the DATENAME() function, fill in the appropriate function calls.
  DECLARE
	@BerlinWallFalls DATETIME2(7) = '1989-11-09 23:49:36.2294852';

-- Fill in the function to show the name of each date part
SELECT
	DATENAME(YEAR, @BerlinWallFalls) AS TheYear,
	DATENAME(MONTH, @BerlinWallFalls) AS TheMonth,
	DATENAME(DAY, @BerlinWallFalls) AS TheDay,
	DATENAME(DAYOFYEAR, @BerlinWallFalls) AS TheDayOfYear,
    -- Day of week is WEEKDAY
	DATENAME(WEEKDAY, @BerlinWallFalls) AS TheDayOfWeek,
	DATENAME(WEEK, @BerlinWallFalls) AS TheWeek,
	DATENAME(SECOND, @BerlinWallFalls) AS TheSecond,
	DATENAME(NANOSECOND, @BerlinWallFalls) AS TheNanosecond;
  
--3 How many DATENAME() results differ from their DATEPART() counterparts?
--Ans: two


					--Date math and leap years
/*
Some of you may have experience using R and here we note that leap year date math can be tricky with R and the lubridate package. 
lubridate has two types of functions: duration and period.

lubridate::ymd(20120229) - lubridate::dyears(4) --> 2008-03-01, which is wrong.

lubridate::ymd(20120229) - lubridate::dyears(1) --> 2011-03-01, which is correct.

lubridate::ymd(20120229) - lubridate::years(4) --> 2008-02-29, which is correct.

lubridate::ymd(20120229) - lubridate::years(1) --> NA, which is unexpected behavior.

We can use the DATEADD() and DATEDIFF() functions to see how SQL Server deals with leap years to see if it has any of the same eccentricities.

*/


--1 Fill in the date parts and intervals needed to determine how SQL Server works on February 29th of a leap year.
--2012 was a leap year. The leap year before it was 4 years earlier, and the leap year after it was 4 years later.

DECLARE
	@LeapDay DATETIME2(7) = '2012-02-29 18:00:00';
-- Fill in the date parts and intervals as needed
SELECT
	DATEADD(Day, -1, @LeapDay) AS PriorDay,
	DATEADD(Day, 1, @LeapDay) AS NextDay,
    -- For leap years, we need to move 4 years, not just 1
	DATEADD(YEAR, -4, @LeapDay) AS PriorLeapYear,
	DATEADD(YEAR, 4, @LeapDay) AS NextLeapYear,
	DATEADD(YEAR, -1, @LeapDay) AS PriorYear;
  
  
  
--2 Fill in the date parts and intervals needed to determine how SQL Server works on days next to a leap year.
DECLARE
	@PostLeapDay DATETIME2(7) = '2012-03-01 18:00:00';
-- Fill in the date parts and intervals as needed
SELECT
	DATEADD(DAY, -1, @PostLeapDay) AS PriorDay,
	DATEADD(DAY, 1, @PostLeapDay) AS NextDay,
	DATEADD(YEAR, -4, @PostLeapDay) AS PriorLeapYear,
	DATEADD(YEAR, 4, @PostLeapDay) AS NextLeapYear,
	DATEADD(YEAR, -1, @PostLeapDay) AS PriorYear,
    -- Move 4 years forward and one day back
	DATEADD(DAY, -1, DATEADD(YEAR, 4, @PostLeapDay)) AS NextLeapDay,
  DATEADD(DAY, -2, @PostLeapDay) AS TwoDaysAgo;
    
    
    
    
--3 Taking TwoDaysAgo from the prior step, use the DATEDIFF() function to test how it handles leap years.
DECLARE
	@PostLeapDay DATETIME2(7) = '2012-03-01 18:00:00',
    @TwoDaysAgo DATETIME2(7);
SELECT
	@TwoDaysAgo = DATEADD(DAY, -2, @PostLeapDay);
SELECT
	@TwoDaysAgo AS TwoDaysAgo,
	@PostLeapDay AS SomeTime,
    -- Fill in the appropriate function and date types
	DATEDIFF(DAY, @TwoDaysAgo, @PostLeapDay) AS DaysDifference,
	DATEDIFF(HOUR, @TwoDaysAgo, @PostLeapDay) AS HoursDifference,
	DATEDIFF(MINUTE, @TwoDaysAgo, @PostLeapDay) AS MinutesDifference;
  
  
  
  				--Rounding dates

/*
SQL Server does not have an intuitive way to round down to the month, hour, or minute. You can, however, combine the DATEADD() and DATEDIFF() functions to perform 
this rounding.

To round the date 1914-08-16 down to the year, we would call DATEADD(YEAR, DATEDIFF(YEAR, 0, '1914-08-16'), 0). To round that date down to the month, we would call 
DATEADD(MONTH, DATEDIFF(MONTH, 0, '1914-08-16'), 0). This works for several other date parts as well.
*/  
  
  
  
--Use DATEADD() and DATEDIFF() in conjunction with date parts to round down our time to the day, hour, and minute.
DECLARE
	@SomeTime DATETIME2(7) = '2018-06-14 16:29:36.2248991';
-- Fill in the appropriate functions and date parts
SELECT
	DATEADD(DAY, DATEDIFF(DAY, 0, @SomeTime), 0) AS RoundedToDay,
	DATEADD(HOUR, DATEDIFF(HOUR, 0, @SomeTime), 0) AS RoundedToHour,
	DATEADD(MINUTE, DATEDIFF(MINUTE, 0, @SomeTime), 0) AS RoundedToMinute;
	
RoundedToDay		RoundedToHour		RoundedToMinute
2018-06-14 00:00:00	2018-06-14 16:00:00	2018-06-14 16:29:00






						-- 1.2 Formatting dates for reporting
/*
We can use the CAST() function to translate data between various data types, including between date/time types and string types. 
The CONVERT() function takes three parameters: a data type, an input value, and an optional format code.

In this exercise, we will see how we can use the CAST() and CONVERT() functions to translate dates to strings for formatting by looking at the (late) night the 
Chicago Cubs won the World Series in the US in 2016. In the process, we will see one difference between the DATETIME and the DATETIME2 data types for CAST()
and the added flexibility of CONVERT().
*/



--1 Fill in the appropriate function, CAST(), for each example. Using the aliases as a guide, fill in the appropriate variable for each example.
DECLARE
	@CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245',
	@OlderDateType DATETIME = '2016-11-03 00:30:29.245';

SELECT
	-- Fill in the missing function calls
	CAST(@CubsWinWorldSeries AS DATE) AS CubsWinDateForm,
	CAST(@CubsWinWorldSeries AS NVARCHAR(30)) AS CubsWinStringForm,
	CAST(@OlderDateType AS DATE) AS OlderDateForm,
	CAST(@OlderDateType AS NVARCHAR(30)) AS OlderStringForm;


--2 For the inner function, turn the date the Cubs won the World Series into a DATE data type using the CAST() function.
--For the outer function, reshape this date as an NVARCHAR(30) using the CAST() function.
DECLARE
	@CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245';

SELECT
	CAST(CAST(@CubsWinWorldSeries AS DATE) AS NVARCHAR(30)) AS DateStringForm;



--3 Use the CONVERT() function to translate the date the Cubs won the world series into the DATE and NVARCHAR(30) data types.
--The functional form for CONVERT() is CONVERT(DataType, SomeValue).
DECLARE
	@CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245';

SELECT
	CONVERT(DATE, @CubsWinWorldSeries) AS CubsWinDateForm,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries) AS CubsWinStringForm;



--4 Fill in the correct function call for conversion.
--The UK date formats are 3 and 103, representing two-digit year (dmy) and four-digit year (dmyyyy), respectively.
--The corresponding US date formats are 1 and 101.

DECLARE
	@CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245';

SELECT
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 0) AS DefaultForm,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 3) AS UK_dmy,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 1) AS US_mdy,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 103) AS UK_dmyyyy,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 101) AS US_mdyyyy;


				--Formatting dates with FORMAT()
/*
The FORMAT() function allows for additional flexibility in building dates. It takes in three parameters: the input value, the input format, and an optional culture 
(such as en-US for US English or zh-cn for Simplified Chinese).

In the following exercises, we will investigate three separate methods for formatting dates using the FORMAT() function against the day that Python 3 became generally 
available: December 3rd, 2008.
*/


--1 Fill in the function and use the 'd' format parameter (note that this is case sensitive!) to format as short dates. Also, fill in the culture for Japan, 
--which in the .NET framework is jp-JP (this is not case sensitive).
DECLARE
	@Python3ReleaseDate DATETIME2(3) = '2008-12-03 19:45:00.033';
SELECT
	-- Fill in the function call and format parameter
	FORMAT(@Python3ReleaseDate, 'd', 'en-US') AS US_d,
	FORMAT(@Python3ReleaseDate, 'd', 'de-DE') AS DE_d,
	-- Fill in the locale for Japan
	FORMAT(@Python3ReleaseDate, 'd', 'jp-JP') AS JP_d,
	FORMAT(@Python3ReleaseDate, 'd', 'zh-cn') AS CN_d;
--Output:		
US_d		DE_d		JP_d		CN_d
12/3/2008	03.12.2008	12/03/2008	2008/12/3	



--2 Use the 'D' format parameter (this is case sensitive!) to build long dates. Also, fill in the culture for Indonesia, which in the .NET framework is id-ID.
DECLARE
	@Python3ReleaseDate DATETIME2(3) = '2008-12-03 19:45:00.033';
SELECT
	-- Fill in the format parameter
	FORMAT(@Python3ReleaseDate, 'D', 'en-US') AS US_D,
	FORMAT(@Python3ReleaseDate, 'D', 'de-DE') AS DE_D,
	-- Fill in the locale for Indonesia
	FORMAT(@Python3ReleaseDate,	'D', 'id-ID') AS ID_D,
	FORMAT(@Python3ReleaseDate, 'D', 'zh-cn') AS CN_D;
	
US_D				DE_D				ID_D			CN_D
Wednesday, December 3, 2008	Mittwoch, 3. Dezember 2008	Rabu, 03 Desember 2008	2008年12月3日



--3 Fill in the custom format strings needed to generate the results in preceding comments. Use date parts such as yyyy, MM, MMM, and dd. 
--Capitalization is important for the FORMAT() function! See the full list at https://bit.ly/30SGA5a.
DECLARE
	@Python3ReleaseDate DATETIME2(3) = '2008-12-03 19:45:00.033';
SELECT
	-- 20081203
	FORMAT(@Python3ReleaseDate, 'yyyyMMdd') AS F1,
	-- 2008-12-03
	FORMAT(@Python3ReleaseDate, 'yyyy-MM-dd') AS F2,
	-- Dec 03+2008 (the + is just a "+" character)
	FORMAT(@Python3ReleaseDate, 'MMM dd+yyyy') AS F3,
	-- 12 08 03 (month, two-digit year, day)
	FORMAT(@Python3ReleaseDate, 'MM yy dd') AS F4,
	-- 03 07:45 2008.00
    -- (day hour:minute year.second)
	FORMAT(@Python3ReleaseDate, 'dd hh:mm yyyy.ss') AS F5;

	
	
	
	
	
					--1.3Working with calendar tables
					--The benefits of calendar tables

--Which of the following is not a benefit of using a calendar table?
--Ans: Calendar tables can let you to perform actions you could not otherwise do in T-SQL.






					--Try out a calendar table
					
/*
Calendar tables are also known in the warehousing world as date dimensions. A calendar table is a helpful utility table which you can use to perform date range 
calculations quickly and efficiently. This is especially true when dealing with fiscal years, which do not always align to a calendar year, or holidays which may 
not be on the same date every year.

In our example company, the fiscal year starts on July 1 of the current calendar year, so Fiscal Year 2019 started on July 1, 2019 and goes through June 30, 2020. 
All of this information is in a table called dbo.Calendar.
*/


--1 Find the dates of all Tuesdays in December covering the calendar years 2008 through 2010.
-- Find Tuesdays in December for calendar years 2008-2010

	
SELECT
	c.Date
FROM dbo.calendar c
WHERE
	c.monthname = 'December'
	AND c.DayName = 'Tuesday'
	AND c.CalendarYear BETWEEN 2008 AND 2010
ORDER BY
	c.Date;
	
	
	
--2 Find the dates for fiscal week 29 of fiscal year 2019.
-- Find fiscal week 29 of fiscal year 2019


SELECT
	c.Date
FROM dbo.Calendar c
WHERE
    -- Instead of month, use the fiscal week
	c.FiscalWeekOfYear = 29
    -- Instead of calendar year, use fiscal year
	AND c.FiscalYear = 2019
ORDER BY
	c.Date ASC;
	
	
	
	
	
	
				-- Joining to a calendar table
/*
In the prior exercise, we looked at a new table, dbo.Calendar. This table contains pre-calculated date information stretching 
from January 1st, 2000 through December 31st, 2049. Now we want to use this calendar table to filter another table, dbo.IncidentRollup.

The Incident Rollup table contains artificially-generated data relating to security incidents at a fictitious company.

You may recall from prerequisite courses how to join tables. Here's an example of joining to a calendar table:

SELECT
    t.Column1,
    t.Column2
FROM dbo.Table t
    INNER JOIN dbo.Calendar c
        ON t.Date = c.Date;
				
*/

				
--1 Fill in the blanks to determine which dates had type 3 incidents during the third fiscal quarter of FY2019.
SELECT
	ir.IncidentDate,
	c.FiscalDayOfYear,
	c.FiscalWeekOfYear
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
    -- Incident type 3
	ir.IncidentTypeID = 3
    -- Fiscal year 2019
	AND c.FiscalYear = 2019
    -- Fiscal quarter 3
	AND c.FiscalQuarter = 3;
	
	
	
--2 Fill in the gaps in to determine type 4 incidents which happened on weekends in FY2019 after fiscal week 30.


SELECT
	ir.IncidentDate,
	c.FiscalDayOfYear,
	c.FiscalWeekOfYear
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
    -- Incident type 4
	ir.IncidentTypeID = 4
    -- Fiscal year 2019
	AND c.FiscalYear = 2019
    -- Beyond fiscal week of year 30
	AND c.FiscalWeekOfYear	 > 30
    -- Only return weekends
	AND c.IsWeekend	 = 1;





								--Chapter 2: Converting to Dates and Times
				--2.1 Build dates from parts
/*
The DATEFROMPARTS() function allows us to turn a series of numbers representing date parts into a valid DATE data type. In this exercise, 
we will learn how to use DATEFROMPARTS() to build dates from components in a calendar table.

Although the calendar table already has dates in it, this helps us visualize circumstances in which the base table has integer date components but no date value, 
which might happen when importing data from flat files directly into a database.
*/



--1 Create dates from component parts in the calendar table: calendar year, calendar month, and the day of the month.
-- Create dates from component parts on the calendar table
SELECT TOP(10)
	DATEFROMPARTS(c.CalendarYear, c.CalendarMonth, c.day) AS CalendarDate
FROM dbo.Calendar c
WHERE
	c.CalendarYear = 2017
ORDER BY
	c.FiscalDayOfYear ASC;
	
	
	
--2 Create dates from the component parts of the calendar table. Use the calendar year, calendar month, and day of month.
SELECT TOP(10)
	c.CalendarQuarterName,
	c.MonthName,
	c.CalendarDayOfYear
FROM dbo.Calendar c
WHERE
	-- Create dates from component parts
	DATEFROMPARTS(c.calendaryear, c.calendarmonth, c.day) >= '2018-06-01'
	AND c.DayName = 'Tuesday'
ORDER BY
	c.FiscalYear,
	c.FiscalDayOfYear ASC;






				--Build dates and times from parts

/*
SQL Server has several functions for generating date and time combinations from parts. In this exercise, we will look at DATETIME2FROMPARTS() and DATETIMEFROMPARTS().

Neil Armstrong and Buzz Aldrin landed the Apollo 11 Lunar Module--nicknamed The Eagle--on the moon on July 20th, 1969 at 20:17 UTC. They remained on the moon for 
approximately 21 1/2 hours, taking off on July 21st, 1969 at 18:54 UTC.
*/	
		
		
--Build the date and time (using DATETIME2FROMPARTS()) that Neil and Buzz became the first people to land on the moon. 
--Note the "2" in DATETIME2FROMPARTS(), meaning we want to build a DATETIME2 rather than a DATETIME.
--Build the date and time (using DATETIMEFROMPARTS()) that Neil and Buzz took off from the moon. Note that this is for a DATETIME, not a DATETIME2.


SELECT
	-- Mark the date and time the lunar module touched down
    -- Use 24-hour notation for hours, so e.g., 9 PM is 21
	DATETIME2FROMPARTS(1969, 7, 20, 20, 17, 00, 000, 0) AS TheEagleHasLanded,
	-- Mark the date and time the lunar module took back off
    -- Use 24-hour notation for hours, so e.g., 9 PM is 21
	DATETIMEFROMPARTS(1969, 7, 21, 18, 54, 00, 000) AS MoonDeparture;
	
	
	
	
	
	
				--Build dates and times with offsets from parts
/*
The DATETIMEOFFSETFROMPARTS() function builds a DATETIMEOFFSET out of component values. It has the most input parameters of any date and time builder function.

On January 19th, 2038 at 03:14:08 UTC (that is, 3:14:08 AM), we will experience the Year 2038 (or Y2.038K) problem. This is the moment that 32-bit devices will 
reset back to the date 1900-01-01. This runs the risk of breaking every 32-bit device using POSIX time, which is the number of seconds elapsed since January 1, 1970 
at midnight UTC.
*/

		
--Build a DATETIMEOFFSET which represents the last millisecond before the Y2.038K problem hits. The offset should be UTC.
--Build a DATETIMEOFFSET which represents the moment devices hit the Y2.038K issue in UTC time. 
--Then use the AT TIME ZONE operator to convert this to Eastern Standard Time.
SELECT
	-- Fill in the millisecond PRIOR TO chaos
	DATETIMEOFFSETFROMPARTS(2038, 1, 19, 3, 14, 07, 999, 0, 0, 3) AS LastMoment,
    -- Fill in the date and time when we will experience the Y2.038K problem
    -- Then convert to the Eastern Standard Time time zone
	DATETIMEOFFSETFROMPARTS(2038,  1, 19, 3, 14, 08, 0, 0, 0, 3) AT TIME ZONE 'Eastern Standard Time' AS TimeForChaos;
	
	
	
	
	
	
	
					--2.2  Translating date strings
					--Cast strings to dates
/*
The CAST() function allows us to turn strings into date and time data types. In this example, we will review many of the formats CAST() can handle.

Review the data in the dbo.Dates table which has been pre-loaded for you. Then use the CAST() function to convert these dates twice: once into a DATE type and 
once into a DATETIME2(7) type. Because one of the dates includes data down to the nanosecond, we cannot convert to a DATETIME type or any DATETIME2 type with 
less precision.

NOTE: the CAST() function is language- and locale-specific, meaning that for a SQL Server instance configured for US English, it will translate 08/23/2008 as 
2008-08-23 but it will fail on 23/08/2008, which a SQL Server with the French Canadian locale can handle.
*/
					
					
--Cast the input string DateText in the dbo.Dates temp table to the DATE data type.
--Cast the input string DateText in the dbo.Dates temp table to the DATETIME2(7) data type.
SELECT
	d.DateText AS String,
	-- Cast as DATE
	CAST(d.DateText AS DATE) AS StringAsDate,
	-- Cast as DATETIME2(7)
	CAST(d.DateText AS DATETIME2(7)) AS StringAsDateTime2
FROM dbo.Dates d;



				
				
				--Convert strings to dates
/*
The CONVERT() function behaves similarly to CAST(). When translating strings to dates, the two functions do exactly the same work under the covers. 
Although we used all three parameters for CONVERT() during a prior exercise in Chapter 1, we will only need two parameters here: the data type and input expression.

In this exercise, we will once again look at a table called dbo.Dates. This time around, we will get dates in from our German office. 
In order to handle German dates, we will need to use SET LANGUAGE to change the language in our current session to German. 
This affects date and time formats and system messages.

Try querying the dbo.Dates table first to see how things differ from the prior exercise.
*/


--Use the CONVERT() function to translate DateText into a date data type. 
--Then use the CONVERT() function to translate DateText into a DATETIME2(7) data type.
SET LANGUAGE 'GERMAN'

SELECT
	d.DateText AS String,
	-- Convert to DATE
	Convert(DATE, d.DateText) AS StringAsDate,
	-- Convert to DATETIME2(7)
	Convert(DATETIME2(7), d.DateText) AS StringAsDateTime2
FROM dbo.Dates d;



					
					
					--Parse strings to dates
/*
Changing our language for data loading is not always feasible. Instead of using the SET LANGUAGE syntax, 
we can instead use the PARSE() function to parse a string as a date type using a specific locale.

We will once again use the dbo.Dates table, this time parsing all of the dates as German using the de-de locale.
*/


--Parse DateText as dates using the German locale (de-de).
--Then, parse DateText as the data type DATETIME2(7), still using the German locale.
SELECT
	d.DateText AS String,
	-- Parse as DATE using German
	Parse(d.DateText AS DATE USING 'de-de') AS StringAsDate,
	-- Parse as DATETIME2(7) using German
	Parse(d.DateText AS DATETIME2(7) USING 'de-de') AS StringAsDateTime2
FROM dbo.Dates d;




					--2.3 Working with offsets
					--Changing a date's offset
/*
We can use the SWITCHOFFSET() function to change the time zone of a DATETIME, DATETIME2, or DATETIMEOFFSET typed date or a valid date string. 
SWITCHOFFSET() takes two parameters: the date or string as input and the time zone offset. It returns the time in that new time zone, so 3:00 AM Eastern Daylight 
Time will become 2:00 AM Central Daylight Time.

The 2016 Summer Olympics in Rio de Janeiro started at 11 PM UTC on August 8th, 2016. Starting with a string containing that date and time, we can see what time that 
was in other locales.
*/




--Fill in the appropriate function call for Brasilia, Brazil.
--Fill in the appropriate function call and time zone for Chicago, Illinois. In August, Chicago is 2 hours behind Brasilia Standard Time.
--Fill in the appropriate function call and time zone for New Delhi, India. India does not observe Daylight Savings Time, so in August, 
--New Delhi is 8 1/2 hours ahead of Brasilia Standard Time. Note when calculating time zones that Brasilia and New Delhi are on opposite sides of UTC.
DECLARE
	@OlympicsUTC NVARCHAR(50) = N'2016-08-08 23:00:00';
SELECT
	-- Fill in the time zone for Brasilia, Brazil
	SWITCHOFFSET(@OlympicsUTC, '-03:00') AS BrasiliaTime,
	-- Fill in the time zone for Chicago, Illinois
	SWITCHOFFSET(@OlympicsUTC, '-05:00') AS ChicagoTime,
	-- Fill in the time zone for New Delhi, India
	SWITCHOFFSET(@OlympicsUTC, '+05:30') AS NewDelhiTime;





					--Using the time zone DMV to look up times
/*
The SWITCHOFFSET() function has an undesirable limitation: you need to know the offset value yourself. You might memorize that US Eastern Standard Time is 
UTC -5:00 and Eastern Daylight Time is UTC -04:00, but knowing India Standard Time or Tuvalu Time might be a stretch.

Fortunately, we have a Dynamic Management View (DMV) available to help us: sys.time_zone_info. This searches the set of time zones available on the operating 
system (in the Windows registry or /usr/share/zoneinfo on Linux or macOS).

The 2016 Summer Olympics in Rio de Janeiro started at 11 PM UTC on August 8th, 2016. Starting with a string containing that date and time, we can see what time that
was in other locales knowing only the time zone name but not its offset.
*/



--Create a valid SQL query by dragging and dropping the items into the correct sequence.





						
					--Converting to a date offset
					
/*
In addition to SWITCHOFFSET(), we can use the TODATETIMEOFFSET() to turn an existing date into a date type with an offset. 
If our starting time is in UTC, we will need to correct for time zone and then append an offset. To correct for the time zone, we can add or subtract hours 
(and minutes) manually.

Closing ceremonies for the 2016 Summer Olympics in Rio de Janeiro began at 11 PM UTC on August 21st, 2016. Starting with a string containing that date and time, 
we can see what time that was in other locales. For the time in Phoenix, Arizona, you know that they observe Mountain Standard Time, which is UTC -7 year-round. 
The island chain of Tuvalu has its own time which is 12 hours ahead of UTC.
*/



--Fill in the time in Phoenix, Arizona, which, being Mountain Standard Time, was UTC -07:00.
--Fill in the time for Tuvalu, which is 12 hours ahead of UTC.
DECLARE
	@OlympicsClosingUTC DATETIME2(0) = '2016-08-21 23:00:00';
SELECT
	-- Fill in 7 hours back and a '-07:00' offset
	TODATETIMEOFFSET(DATEADD(HOUR,-7, @OlympicsClosingUTC), '-07:00') AS PhoenixTime,
	-- Fill in 12 hours forward and a '+12:00' offset.
	TODATETIMEOFFSET(DATEADD(HOUR,+12, @OlympicsClosingUTC), '+12:00') AS TuvaluTime;
	
	
	
	
	
	
	
	
						--2.4 Handling invalid dates
						--Try out type-safe date functions
/*
In this exercise, we will try out the TRY_CONVERT(), TRY_CAST(), and TRY_PARSE() set of functions. Each of these functions will safely parse string data and attempt 
to convert to another type, returning NULL if the conversion fails. Conversion to, e.g., a date type can fail for several reasons. If the input string is not a date, 
conversion will fail. If the input type is in a potentially ambiguous format, conversion might fail. An example of this is the date 04/01/2019 which has a different 
meaning in the United States (April 1, 2019) versus most European countries (January 4th, 2019).
*/



--1 Starting with the TRY_CONVERT() function, fill in the function name and input parameter for each example.
DECLARE
	@GoodDateINTL NVARCHAR(30) = '2019-03-01 18:23:27.920',
	@GoodDateDE NVARCHAR(30) = '13.4.2019',
	@GoodDateUS NVARCHAR(30) = '4/13/2019',
	@BadDate NVARCHAR(30) = N'SOME BAD DATE';
SELECT
	-- Fill in the correct data type based on our input
	TRY_CONVERT(DATETIME2(3), @GoodDateINTL) AS GoodDateINTL,
	-- Fill in the correct function
	TRY_CONVERT(DATE, @GoodDateDE) AS GoodDateDE,
	TRY_CONVERT(DATE, @GoodDateUS) AS GoodDateUS,
	-- Fill in the correct input parameter for BadDate
	TRY_CONVERT(DATETIME2(3), @BadDate) AS BadDate;
	
	


--2 With the prior TRY_CONVERT() solution in mind, use TRY_CAST() to see how they compare.

DECLARE
	@GoodDateINTL NVARCHAR(30) = '2019-03-01 18:23:27.920',
	@GoodDateDE NVARCHAR(30) = '13.4.2019',
	@GoodDateUS NVARCHAR(30) = '4/13/2019',
	@BadDate NVARCHAR(30) = N'SOME BAD DATE';

/*-- The prior solution using TRY_CONVERT
SELECT
	TRY_CONVERT(DATETIME2(3), @GoodDateINTL) AS GoodDateINTL,
	TRY_CONVERT(DATE, @GoodDateDE) AS GoodDateDE,
	TRY_CONVERT(DATE, @GoodDateUS) AS GoodDateUS,
	TRY_CONVERT(DATETIME2(3), @BadDate) AS BadDate;
*/
SELECT
	-- Fill in the correct data type based on our input
	TRY_CAST(@GoodDateINTL AS DATETIME2(3)) AS GoodDateINTL,
    -- Be sure to match these data types with the
    -- TRY_CONVERT() examples above!
	TRY_CAST(@GoodDateDE AS DATE) AS GoodDateDE,
	TRY_CAST(@GoodDateUS AS DATE) AS GoodDateUS,
	TRY_CAST(@BadDate AS DATETIME2(3)) AS BadDate;
	
	
	
--3 One of our good dates returns NULL. Use TRY_PARSE() and specify de-de for the German date and en-us for the US date.

DECLARE
	@GoodDateINTL NVARCHAR(30) = '2019-03-01 18:23:27.920',
	@GoodDateDE NVARCHAR(30) = '13.4.2019',
	@GoodDateUS NVARCHAR(30) = '4/13/2019',
	@BadDate NVARCHAR(30) = N'SOME BAD DATE';
/*
-- The prior solution using TRY_CAST
SELECT
	TRY_CAST(@GoodDateINTL AS DATETIME2(3)) AS GoodDateINTL,
	TRY_CAST(@GoodDateDE AS DATE) AS GoodDateDE,
	TRY_CAST(@GoodDateUS AS DATE) AS GoodDateUS,
	TRY_CAST(@BadDate AS DATETIME2(3)) AS BadDate; */
SELECT
	TRY_PARSE(@GoodDateINTL AS DATETIME2(3)) AS GoodDateINTL,
    -- Fill in the correct region based on our input
    -- Be sure to match these data types with the
    -- TRY_CAST() examples above!
	TRY_PARSE(@GoodDateDE AS DATE USING 'de-de') AS GoodDateDE,
	TRY_PARSE(@GoodDateUS AS DATE USING 'en-us') AS GoodDateUS,
    -- TRY_PARSE can't fix completely invalid dates
	TRY_PARSE(@BadDate AS DATETIME2(3) USING 'sk-sk') AS BadDate;
	
	
	
					
					--Convert imported data to dates with time zones
/*
Now that we have seen the three type-safe conversion functions, we can begin to apply them against real data sets. 
In this scenario, we will parse data from the dbo.ImportedTime table. 
We used a different application to load data from this table and looked at it in a prior exercise. This time, we will retrieve data for all rows, 
not just the ones the importing application marked as valid.
*/
/*
Fill in the missing TRY_XXX() function name inside the EventDates common table expression.
Convert the EventDateOffset event dates to 'UTC'. Call this output EventDateUTC.
Convert the EventDateOffset event dates to 'US Eastern Standard Time' using AT TIME ZONE. Call this output EventDateUSEast.
*/


WITH EventDates AS
(
    SELECT
        -- Fill in the missing try-conversion function
        TRY_CONVERT(DATETIME2(3), it.EventDate) AT TIME ZONE it.TimeZone AS EventDateOffset,
        it.TimeZone
    FROM dbo.ImportedTime it
        INNER JOIN sys.time_zone_info tzi
			ON it.TimeZone = tzi.name
)
SELECT
    -- Fill in the approppriate event date to convert
	CONVERT(NVARCHAR(50), ed.EventDateOffset) AS EventDateOffsetString,
	CONVERT(DATETIME2(0), ed.EventDateOffset) AS EventDateLocal,
	ed.TimeZone,
    -- Convert from a DATETIMEOFFSET to DATETIME at UTC
	CAST(ed.EventDateOffset AT TIME ZONE 'UTC' AS DATETIME2(0)) AS EventDateUTC,
    -- Convert from a DATETIMEOFFSET to DATETIME with time zone
	CAST(ed.EventDateOffset AT TIME ZONE 'US Eastern Standard Time'  AS DATETIME2(0)) AS EventDateUSEast
FROM EventDates ed;

	
	
	
	
					--Test type-safe conversion function performance
					
/*
In the last two exercises, we looked at the TRY_CAST(), TRY_CONVERT(), and TRY_PARSE() functions. These functions do not all perform equally well. 
In this exercise, you will run a performance test against all of the dates in our calendar table.

To make it easier, we have pre-loaded dates in the dbo.Calendar table into a temp table called DateText, where there is a single NVARCHAR(50) column called DateText.

For the first three steps, the instructions will be the same: fill in missing values to complete the relevant function call. 
After doing that, observe the amount of time each operation takes and keep the results in mind. You will then summarize your results in step 4.
*/


	
--1 Fill in the correct conversion function based on its parameter signature.
--Note the amount of time returned in the DATEDIFF() call.
--Do not use @StartTimeCast or @EndTimeCast in your answer; these are for calculating execution time.


-- Try out how fast the TRY_CAST() function is
-- by try-casting each DateText value to DATE
DECLARE @StartTimeCast DATETIME2(7) = SYSUTCDATETIME();
SELECT TRY_CAST(DateText as DATE) AS TestDate FROM #DateText;
DECLARE @EndTimeCast DATETIME2(7) = SYSUTCDATETIME();
-- Determine how much time the conversion took by
-- calculating the date difference from @StartTimeCast to @EndTimeCast
SELECT
    DATEDIFF(MILLISECOND, @StartTimeCast, @EndTimeCast) AS ExecutionTimeCast;
    
    
    
    
--2 Fill in the correct conversion function based on its parameter signature.
--Note the amount of time returned in the DATEDIFF() call.
--Do not use @StartTimeCast or @EndTimeCast in your answer; these are for calculating execution time.

-- Try out how fast the TRY_CONVERT() function is
-- by try-converting each DateText value to DATE
DECLARE @StartTimeConvert DATETIME2(7) = SYSUTCDATETIME();
SELECT TRY_CONVERT(DATE, DateText) AS TestDate FROM #DateText;
DECLARE @EndTimeConvert DATETIME2(7) = SYSUTCDATETIME();
--Ans: 8

-- Determine how much time the conversion took by
-- calculating the difference from start time to end time
SELECT
    DATEDIFF(MILLISECOND, @StartTimeConvert, @EndTimeConvert) AS ExecutionTimeConvert;
--Ans: 8





--3 Fill in the correct conversion function based on its parameter signature.
--Note the amount of time returned in the DATEDIFF() call.
--Do not use @StartTimeCast or @EndTimeCast in your answer; these are for calculating execution time.



-- Try out how fast the TRY_PARSE() function is
-- by try-parsing each DateText value to DATE
DECLARE @StartTimeParse DATETIME2(7) = SYSUTCDATETIME();
SELECT TRY_PARSE(DateText as DATE) AS TestDate FROM #DateText;
DECLARE @EndTimeParse DATETIME2(7) = SYSUTCDATETIME();

-- Determine how much time the conversion took by
-- calculating the difference from start time to end time
SELECT
    DATEDIFF(MILLISECOND, @StartTimeParse, @EndTimeParse) AS ExecutionTimeParse;
-- Ans: 646    


    
--4      Based on what you have learned so far, how would you compare the performance of TRY_PARSE() versus TRY_CAST() and TRY_CONVERT()?
--	Ans:TRY_CAST() and TRY_CONVERT() are both faster than TRY_PARSE().






							--Chapter3: Aggregating Time Series Data
				--3.1 Basic aggregate functions
							
/*							
There are several useful aggregate functions in SQL Server which we can use to summarize our data over time frames and gain insights. 
In the following example, you will look at a set of incident reports at a fictional company. They have already rolled up their incidents to the daily grain,
giving us a number of incidents per type and day. We would like to investigate further and review incidents over a three-month period, 
from August 1 through October 31st, and gain basic insights through aggregation.

The key aggregate functions we will use are COUNT(), SUM(), MIN(), and MAX(). In the next exercise, we will look at some of the statistical aggregate functions.							
*/

--Fill in the appropriate aggregate function based on the column name. Choose from COUNT(), SUM(), MIN(), and MAX() for each.

-- Fill in the appropriate aggregate functions
SELECT
	it.IncidentType,
	COUNT(1) AS NumberOfRows,
	SUM(ir.NumberOfIncidents) AS TotalNumberOfIncidents,
	MIN(ir.NumberOfIncidents) AS MinNumberOfIncidents,
	MAX(ir.NumberOfIncidents) AS MaxNumberOfIncidents,
	MIN(ir.IncidentDate) As MinIncidentDate,
	MAX(ir.IncidentDate) AS MaxIncidentDate
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.IncidentType it
		ON ir.IncidentTypeID = it.IncidentTypeID
WHERE
	ir.IncidentDate BETWEEN '2019-08-01' AND '2019-10-31'
GROUP BY
	it.IncidentType;




				--Calculating distinct counts
/*
The COUNT() function has a variant which can be quite useful: COUNT(DISTINCT). This distinct count function allows us to calculate the number of unique elements 
in a data set, so COUNT(DISTINCT x.Y) will get the unique number of values for column Y on the table aliased as x.

In this example, we will continue to look at incident rollup data in the dbo.IncidentRollup table. Management would like to know how many unique incident types we 
have in our three-month data set as well as the number of days with incidents. They already know the total number of incidents because you gave them that information 
in the last exercise.
*/
/*
Return the count of distinct incident type IDs as NumberOfIncidentTypes
Return the count of distinct incident dates as NumberOfDaysWithIncidents
Fill in the appropriate function call and input column to determine number of unique incident types and number of days with incidents in our rollup table.
*/

-- Fill in the functions and columns
SELECT
	COUNT(distinct ir.IncidentTypeID) AS NumberOfIncidentTypes,
	COUNT(distinct ir.IncidentDate) AS NumberOfDaysWithIncidents
FROM dbo.IncidentRollup ir
WHERE
ir.IncidentDate BETWEEN '2019-08-01' AND '2019-10-31';




				--Calculating filtered aggregates
/*
If we want to count the number of occurrences of an event given some filter criteria, we can take advantage of aggregate functions like SUM(), MIN(), and MAX(),
as well as CASE expressions. For example, SUM(CASE WHEN ir.IncidentTypeID = 1 THEN 1 ELSE 0 END) will return the count of incidents associated with incident type 1. 
If you include one SUM() statement for each incident type, you have pivoted the data set by incident type ID.

In this scenario, management would like us to tell them, by incident type, how many "big-incident" days we have had versus "small-incident" days. Management defines 
a big-incident day as having more than 5 occurrences of the same incident type on the same day, and a small-incident day has between 1 and 5.
*/
/*
Fill in a CASE expression which lets us use the SUM() function to calculate the number of big-incident and small-incident days.
In the CASE expression, you should return 1 if the appropriate filter criterion is met and 0 otherwise.
Be sure to specify the alias when referencing a column, like ir.IncidentDate or it.IncidentType!
*/

SELECT
	it.IncidentType,
    -- Fill in the appropriate expression
	SUM(CASE WHEN ir.NumberOfIncidents > 5 THEN 1 ELSE 0 END) AS NumberOfBigIncidentDays,
    -- Number of incidents will always be at least 1, so
    -- no need to check the minimum value, just that it's
    -- less than or equal to 5
    SUM(CASE WHEN ir.NumberOfIncidents <= 5 THEN 1 ELSE 0 END) AS NumberOfSmallIncidentDays
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.IncidentType it
		ON ir.IncidentTypeID = it.IncidentTypeID
WHERE
	ir.IncidentDate BETWEEN '2019-08-01' AND '2019-10-31'
GROUP BY
it.IncidentType;





					--3.2 Statistical aggregate functions
					--Working with statistical aggregate functions
/*
SQL Server offers several aggregate functions for statistical purpose. The AVG() function generates the mean of a sample. STDEV() and STDEVP() give us the standard 
deviation of a sample and of a population, respectively. VAR() and VARP() give us the variance of a sample and a population, respectively. These are in addition to the
aggregate functions we learned about in the previous exercise, including SUM(), COUNT(), MIN(), and MAX().

In this exercise, we will look once more at incident rollup and incident type data, this time for quarter 2 of calendar year 2020. We would like to get an idea of how
much spread there is in incident occurrence--that is, if we see a consistent number of incidents on a daily basis or if we see wider swings.
*/

--Fill in the missing aggregate functions. For standard deviation and variance, use the sample functions rather than population functions.

SELECT
	it.IncidentType,
	AVG(ir.NumberOfIncidents) AS MeanNumberOfIncidents,
	AVG(CAST(ir.NumberOfIncidents AS DECIMAL(4,2))) AS MeanNumberOfIncidents,
	STDEV(ir.NumberOfIncidents) AS NumberOfIncidentsStandardDeviation,
	VAR(ir.NumberOfIncidents) AS NumberOfIncidentsVariance,
	COUNT(1) AS NumberOfRows
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.IncidentType it
		ON ir.IncidentTypeID = it.IncidentTypeID
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE c.CalendarQuarter = 2 AND c.CalendarYear = 2020
GROUP BY it.IncidentType;




					--Calculating median in SQL Server
/*
There is no MEDIAN() function in SQL Server. The closest we have is PERCENTILE_CONT(), which finds the value at the nth percentile across a data set.

We would like to figure out how far the median differs from the mean by incident type in our incident rollup set. To do so, we can compare the AVG() function from the
prior exercise to PERCENTILE_CONT(). These are window functions, which we will cover in more detail in chapter 4. For now, know that PERCENTILE_CONT() takes a 
parameter, the percentile (a decimal ranging from from 0. to 1.). The percentile must be within an ordered group inside the WITHIN GROUP clause and OVER a certain 
range if you need to partition the data. In the WITHIN GROUP section, we need to order by the column whose 50th percentile we want.
*/

--Fill in the missing value for PERCENTILE_CONT().
--Inside the WITHIN GROUP() clause, order by number of incidents descending.
--In the OVER() clause, partition by IncidentType (the actual text value, not the ID).

SELECT DISTINCT
	it.IncidentType,
	AVG(CAST(ir.NumberOfIncidents AS DECIMAL(4,2)))
	    OVER(PARTITION BY it.IncidentType) AS MeanNumberOfIncidents,
    --- Fill in the missing value
	PERCENTILE_CONT(0.5)
    	-- Inside our group, order by number of incidents DESC
    	WITHIN GROUP (ORDER BY ir.NumberOfIncidents DESC)
        -- Do this for each IncidentType value
        OVER (PARTITION BY it.IncidentType) AS MedianNumberOfIncidents,
	COUNT(1) OVER (PARTITION BY it.IncidentType) AS NumberOfRows
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.IncidentType it
		ON ir.IncidentTypeID = it.IncidentTypeID
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
	c.CalendarQuarter = 2
	AND c.CalendarYear = 2020;
	
	
	
	
					--3.2Downsampling and upsampling data
					--Downsample to a daily grain
/*
Rolling up data to a higher grain is a common analytical task. We may have a set of data with specific time stamps and a need to observe aggregated results. 
In SQL Server, there are several techniques available depending upon your desired grain.

For these exercises, we will look at a fictional day spa. Spa management sent out coupons to potential new customers for the period June 16th through 20th of 2020 
and would like to see if this campaign spurred on new visits.

In this exercise, we will look at one of the simplest downsampling techniques: converting a DATETIME2 or DATETIME data type to a data type with just a date and 
no time component: the DATE type.
*/

--Downsample customer visit start times to the daily grain and aggregate results.
--Fill in the GROUP BY clause with any non-aggregated values in the SELECT clause (but without aliases like AS Day).

















