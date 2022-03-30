--                                                                Chapter 1: Working with Dates and Times

--Use the YEAR(), MONTH(), and DAY() functions to determine the year, month, and day for the current date and time.
 DECLARE
	@SomeTime DATETIME2(7) = SYSUTCDATETIME();
-- Retrieve the year, month, and day
SELECT
	year(@SomeTime) AS TheYear,
	month(@SomeTime) AS TheMonth,
	day(@SomeTime) AS TheDay;
  
--Using the DATEPART() function, fill in the appropriate date parts. 
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
  
  --Using the DATENAME() function, fill in the appropriate function calls.
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
  
--How many DATENAME() results differ from their DATEPART() counterparts?
--Ans: two

--Fill in the date parts and intervals needed to determine how SQL Server works on February 29th of a leap year.
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
  
--Fill in the date parts and intervals needed to determine how SQL Server works on days next to a leap year.
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
    
--Taking TwoDaysAgo from the prior step, use the DATEDIFF() function to test how it handles leap years.
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


--Fill in the appropriate function, CAST(), for each example. Using the aliases as a guide, fill in the appropriate variable for each example.
DECLARE
	@CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245',
	@OlderDateType DATETIME = '2016-11-03 00:30:29.245';

SELECT
	-- Fill in the missing function calls
	CAST(@CubsWinWorldSeries AS DATE) AS CubsWinDateForm,
	CAST(@CubsWinWorldSeries AS NVARCHAR(30)) AS CubsWinStringForm,
	CAST(@OlderDateType AS DATE) AS OlderDateForm,
	CAST(@OlderDateType AS NVARCHAR(30)) AS OlderStringForm;

--For the inner function, turn the date the Cubs won the World Series into a DATE data type using the CAST() function.
--For the outer function, reshape this date as an NVARCHAR(30) using the CAST() function.
DECLARE
	@CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245';

SELECT
	CAST(CAST(@CubsWinWorldSeries AS DATE) AS NVARCHAR(30)) AS DateStringForm;


--Use the CONVERT() function to translate the date the Cubs won the world series into the DATE and NVARCHAR(30) data types.
--The functional form for CONVERT() is CONVERT(DataType, SomeValue).
DECLARE
	@CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245';

SELECT
	CONVERT(DATE, @CubsWinWorldSeries) AS CubsWinDateForm,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries) AS CubsWinStringForm;


--Fill in the correct function call for conversion.
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


--Fill in the function and use the 'd' format parameter (note that this is case sensitive!) to format as short dates. Also, fill in the culture for Japan, 
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

--Use the 'D' format parameter (this is case sensitive!) to build long dates. Also, fill in the culture for Indonesia, which in the .NET framework is id-ID.
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

--Fill in the custom format strings needed to generate the results in preceding comments. Use date parts such as yyyy, MM, MMM, and dd. 
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


	--Working with calendar tables

--Which of the following is not a benefit of using a calendar table?
--Ans: Calendar tables can let you to perform actions you could not otherwise do in T-SQL.

--Find the dates of all Tuesdays in December covering the calendar years 2008 through 2010.
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
	
--Find the dates for fiscal week 29 of fiscal year 2019.
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
	
-- 		Joining to a calendar table
--Fill in the blanks to determine which dates had type 3 incidents during the third fiscal quarter of FY2019.
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
	
--Fill in the gaps in to determine type 4 incidents which happened on weekends in FY2019 after fiscal week 30.

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


--									Chapter 2: Converting to Dates and Times

--Create dates from component parts in the calendar table: calendar year, calendar month, and the day of the month.
-- Create dates from component parts on the calendar table
SELECT TOP(10)
	DATEFROMPARTS(c.CalendarYear, c.CalendarMonth, c.day) AS CalendarDate
FROM dbo.Calendar c
WHERE
	c.CalendarYear = 2017
ORDER BY
	c.FiscalDayOfYear ASC;
	
--Create dates from the component parts of the calendar table. Use the calendar year, calendar month, and day of month.
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


--	Build the date and time (using DATETIME2FROMPARTS()) that Neil and Buzz became the first people to land on the moon. 
--Note the "2" in DATETIME2FROMPARTS(), meaning we want to build a DATETIME2 rather than a DATETIME.
--Build the date and time (using DATETIMEFROMPARTS()) that Neil and Buzz took off from the moon. Note that this is for a DATETIME, not a DATETIME2.

SELECT
	-- Mark the date and time the lunar module touched down
    -- Use 24-hour notation for hours, so e.g., 9 PM is 21
	DATETIME2FROMPARTS(1969, 7, 20, 20, 17, 00, 000, 0) AS TheEagleHasLanded,
	-- Mark the date and time the lunar module took back off
    -- Use 24-hour notation for hours, so e.g., 9 PM is 21
	DATETIMEFROMPARTS(1969, 7, 21, 18, 54, 00, 000) AS MoonDeparture;
	
--Build a DATETIMEOFFSET which represents the last millisecond before the Y2.038K problem hits. The offset should be UTC.
--Build a DATETIMEOFFSET which represents the moment devices hit the Y2.038K issue in UTC time. 
--Then use the AT TIME ZONE operator to convert this to Eastern Standard Time.
SELECT
	-- Fill in the millisecond PRIOR TO chaos
	DATETIMEOFFSETFROMPARTS(2038, 1, 19, 3, 14, 07, 999, 0, 0, 3) AS LastMoment,
    -- Fill in the date and time when we will experience the Y2.038K problem
    -- Then convert to the Eastern Standard Time time zone
	DATETIMEOFFSETFROMPARTS(2038,  1, 19, 3, 14, 08, 0, 0, 0, 3) AT TIME ZONE 'Eastern Standard Time' AS TimeForChaos;
	
	
-- 		Translating date strings
--Cast the input string DateText in the dbo.Dates temp table to the DATE data type.
--Cast the input string DateText in the dbo.Dates temp table to the DATETIME2(7) data type.
SELECT
	d.DateText AS String,
	-- Cast as DATE
	CAST(d.DateText AS DATE) AS StringAsDate,
	-- Cast as DATETIME2(7)
	CAST(d.DateText AS DATETIME2(7)) AS StringAsDateTime2
FROM dbo.Dates d;

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

--Parse DateText as dates using the German locale (de-de).
--Then, parse DateText as the data type DATETIME2(7), still using the German locale.
SELECT
	d.DateText AS String,
	-- Parse as DATE using German
	Parse(d.DateText AS DATE USING 'de-de') AS StringAsDate,
	-- Parse as DATETIME2(7) using German
	Parse(d.DateText AS DATETIME2(7) USING 'de-de') AS StringAsDateTime2
FROM dbo.Dates d;

--		Working with offsets

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

--Create a valid SQL query by dragging and dropping the items into the correct sequence.

--Fill in the time in Phoenix, Arizona, which, being Mountain Standard Time, was UTC -07:00.
--Fill in the time for Tuvalu, which is 12 hours ahead of UTC.
DECLARE
	@OlympicsClosingUTC DATETIME2(0) = '2016-08-21 23:00:00';
SELECT
	-- Fill in 7 hours back and a '-07:00' offset
	TODATETIMEOFFSET(DATEADD(HOUR,-7, @OlympicsClosingUTC), '-07:00') AS PhoenixTime,
	-- Fill in 12 hours forward and a '+12:00' offset.
	TODATETIMEOFFSET(DATEADD(HOUR,+12, @OlympicsClosingUTC), '+12:00') AS TuvaluTime;
	
--		Handling invalid dates
--Starting with the TRY_CONVERT() function, fill in the function name and input parameter for each example.
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
	
--


