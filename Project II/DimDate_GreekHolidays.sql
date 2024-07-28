USE CataskevastichaDW
GO

DECLARE @StartDate DATETIME = '2023-01-01'; -- Starting value of Date Range
DECLARE @EndDate DATETIME = '2026-12-31'; -- End Value of Date Range

DROP TABLE IF EXISTS [dbo].[DimDate];

CREATE TABLE [dbo].[DimDate]
(
    [DateKey] INT PRIMARY KEY,
    [Date] DATETIME,
    [FullDateUK] CHAR(10), -- Date in dd-MM-yyyy format
    [FullDateUSA] CHAR(10),-- Date in MM-dd-yyyy format
    [DayOfMonth] VARCHAR(2), -- Field will hold day number of Month
    [DaySuffix] VARCHAR(4), -- Apply suffix as 1st, 2nd ,3rd etc
    [DayName] VARCHAR(9), -- Contains name of the day, Sunday, Monday
    [DayOfWeekUSA] CHAR(1),-- First Day Sunday=1 and Saturday=7
    [DayOfWeekUK] CHAR(1),-- First Day Monday=1 and Sunday=7
    [DayOfWeekInMonth] VARCHAR(2), --1st Monday or 2nd Monday in Month
    [DayOfWeekInYear] VARCHAR(2),
    [DayOfQuarter] VARCHAR(3),
    [DayOfYear] VARCHAR(3),
    [WeekOfMonth] VARCHAR(1),-- Week Number of Month
    [WeekOfQuarter] VARCHAR(2), --Week Number of the Quarter
    [WeekOfYear] VARCHAR(2),--Week Number of the Year
    [Month] VARCHAR(2), --Number of the Month 1 to 12
    [MonthName] VARCHAR(9),--January, February etc
    [MonthOfQuarter] VARCHAR(2),-- Month Number belongs to Quarter
    [Quarter] CHAR(1),
    [QuarterName] VARCHAR(9),--First,Second..
    [Year] CHAR(4),-- Year value of Date stored in Row
    [YearName] CHAR(7), --CY 2012,CY 2013
    [MonthYear] CHAR(10), --Jan-2013,Feb-2013
    [MMYYYY] CHAR(6),
    [FirstDayOfMonth] DATE,
    [LastDayOfMonth] DATE,
    [FirstDayOfQuarter] DATE,
    [LastDayOfQuarter] DATE,
    [FirstDayOfYear] DATE,
    [LastDayOfYear] DATE,
    [IsHolidayUSA] BIT,-- Flag 1=National Holiday, 0-No National Holiday
    [IsWeekday] BIT,-- 0=Week End ,1=Week Day
    [HolidayUSA] VARCHAR(50),--Name of Holiday in US
    [IsHolidayGreece] BIT, -- Flag 1=National Holiday, 0-No National Holiday
    [HolidayGreece] VARCHAR(50) --Name of Holiday in Greece
);

/********************************************************************************************/

DECLARE @DayOfWeekInMonth INT,
        @DayOfWeekInYear INT,
        @DayOfQuarter INT,
        @WeekOfMonth INT,
        @CurrentYear INT,
        @CurrentMonth INT,
        @CurrentQuarter INT;

DECLARE @DayOfWeek TABLE (DOW INT, MonthCount INT, QuarterCount INT, YearCount INT);

INSERT INTO @DayOfWeek VALUES (1, 0, 0, 0);
INSERT INTO @DayOfWeek VALUES (2, 0, 0, 0);
INSERT INTO @DayOfWeek VALUES (3, 0, 0, 0);
INSERT INTO @DayOfWeek VALUES (4, 0, 0, 0);
INSERT INTO @DayOfWeek VALUES (5, 0, 0, 0);
INSERT INTO @DayOfWeek VALUES (6, 0, 0, 0);
INSERT INTO @DayOfWeek VALUES (7, 0, 0, 0);

DECLARE @CurrentDate AS DATETIME = @StartDate;
SET @CurrentMonth = DATEPART(MM, @CurrentDate);
SET @CurrentYear = DATEPART(YY, @CurrentDate);
SET @CurrentQuarter = DATEPART(QQ, @CurrentDate);

/********************************************************************************************/

WHILE @CurrentDate <= @EndDate
BEGIN

    IF @CurrentMonth != DATEPART(MM, @CurrentDate)
    BEGIN
        UPDATE @DayOfWeek
        SET MonthCount = 0;
        SET @CurrentMonth = DATEPART(MM, @CurrentDate);
    END

    IF @CurrentQuarter != DATEPART(QQ, @CurrentDate)
    BEGIN
        UPDATE @DayOfWeek
        SET QuarterCount = 0;
        SET @CurrentQuarter = DATEPART(QQ, @CurrentDate);
    END

    IF @CurrentYear != DATEPART(YY, @CurrentDate)
    BEGIN
        UPDATE @DayOfWeek
        SET YearCount = 0;
        SET @CurrentYear = DATEPART(YY, @CurrentDate);
    END

    UPDATE @DayOfWeek
    SET
        MonthCount = MonthCount + 1,
        QuarterCount = QuarterCount + 1,
        YearCount = YearCount + 1
    WHERE DOW = DATEPART(DW, @CurrentDate);

    SELECT
        @DayOfWeekInMonth = MonthCount,
        @DayOfQuarter = QuarterCount,
        @DayOfWeekInYear = YearCount
    FROM @DayOfWeek
    WHERE DOW = DATEPART(DW, @CurrentDate);

    INSERT INTO DimDate
    SELECT
        CONVERT(char(8), @CurrentDate, 112) AS DateKey,
        @CurrentDate AS Date,
        CONVERT(char(10), @CurrentDate, 103) AS FullDateUK,
        CONVERT(char(10), @CurrentDate, 101) AS FullDateUSA,
        DATEPART(DD, @CurrentDate) AS DayOfMonth,
        CASE
            WHEN DATEPART(DD, @CurrentDate) IN (11, 12, 13) THEN CAST(DATEPART(DD, @CurrentDate) AS VARCHAR) + 'th'
            WHEN RIGHT(CAST(DATEPART(DD, @CurrentDate) AS VARCHAR), 1) = '1' THEN CAST(DATEPART(DD, @CurrentDate) AS VARCHAR) + 'st'
            WHEN RIGHT(CAST(DATEPART(DD, @CurrentDate) AS VARCHAR), 1) = '2' THEN CAST(DATEPART(DD, @CurrentDate) AS VARCHAR) + 'nd'
            WHEN RIGHT(CAST(DATEPART(DD, @CurrentDate) AS VARCHAR), 1) = '3' THEN CAST(DATEPART(DD, @CurrentDate) AS VARCHAR) + 'rd'
            ELSE CAST(DATEPART(DD, @CurrentDate) AS VARCHAR) + 'th'
        END AS DaySuffix,
        DATENAME(DW, @CurrentDate) AS DayName,
        DATEPART(DW, @CurrentDate) AS DayOfWeekUSA,
        CASE DATEPART(DW, @CurrentDate)
            WHEN 1 THEN 7
            WHEN 2 THEN 1
            WHEN 3 THEN 2
            WHEN 4 THEN 3
            WHEN 5 THEN 4
            WHEN 6 THEN 5
            WHEN 7 THEN 6
        END AS DayOfWeekUK,
        @DayOfWeekInMonth AS DayOfWeekInMonth,
        @DayOfWeekInYear AS DayOfWeekInYear,
        @DayOfQuarter AS DayOfQuarter,
        DATEPART(DY, @CurrentDate) AS DayOfYear,
        DATEPART(WW, @CurrentDate) + 1 - DATEPART(WW, DATEADD(DD, -DATEPART(DD, @CurrentDate) + 1, @CurrentDate)) AS WeekOfMonth,
        (DATEDIFF(DD, DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0), @CurrentDate) / 7) + 1 AS WeekOfQuarter,
        DATEPART(WW, @CurrentDate) AS WeekOfYear,
        DATEPART(MM, @CurrentDate) AS Month,
        DATENAME(MM, @CurrentDate) AS MonthName,
        CASE
            WHEN DATEPART(MM, @CurrentDate) IN (1, 4, 7, 10) THEN 1
            WHEN DATEPART(MM, @CurrentDate) IN (2, 5, 8, 11) THEN 2
            WHEN DATEPART(MM, @CurrentDate) IN (3, 6, 9, 12) THEN 3
        END AS MonthOfQuarter,
        DATEPART(QQ, @CurrentDate) AS Quarter,
        CASE DATEPART(QQ, @CurrentDate)
            WHEN 1 THEN 'First'
            WHEN 2 THEN 'Second'
            WHEN 3 THEN 'Third'
            WHEN 4 THEN 'Fourth'
        END AS QuarterName,
        DATEPART(YEAR, @CurrentDate) AS Year,
        'CY ' + CONVERT(VARCHAR, DATEPART(YEAR, @CurrentDate)) AS YearName,
        LEFT(DATENAME(MM, @CurrentDate), 3) + '-' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS MonthYear,
        RIGHT('0' + CONVERT(VARCHAR, DATEPART(MM, @CurrentDate)), 2) + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS MMYYYY,
        DATEADD(D, -DATEPART(DD, @CurrentDate) + 1, @CurrentDate) AS FirstDayOfMonth,
        EOMONTH(@CurrentDate) AS LastDayOfMonth,
        DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0) AS FirstDayOfQuarter,
        DATEADD(DD, -1, DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate) + 1, 0)) AS LastDayOfQuarter,
        DATEADD(YY, DATEDIFF(YY, 0, @CurrentDate), 0) AS FirstDayOfYear,
        DATEADD(DD, -1, DATEADD(YY, DATEDIFF(YY, 0, @CurrentDate) + 1, 0)) AS LastDayOfYear,
        CASE
            WHEN DATEPART(WEEKDAY, @CurrentDate) IN (1, 7) THEN 0
            ELSE 1
        END AS IsWeekday,
        0 AS IsHolidayUSA,
        '' AS HolidayUSA,
        0 AS IsHolidayGreece,
        '' AS HolidayGreece;

    SET @CurrentDate = DATEADD(DD, 1, @CurrentDate);

END

UPDATE DimDate
SET IsHolidayUSA = 1, HolidayUSA = 'New Year''s Day'
WHERE [Month] = 1 AND [DayOfMonth] = 1;

UPDATE DimDate
SET IsHolidayUSA = 1, HolidayUSA = 'Independence Day'
WHERE [Month] = 7 AND [DayOfMonth] = 4;

UPDATE DimDate
SET IsHolidayUSA = 1, HolidayUSA = 'Veterans Day'
WHERE [Month] = 11 AND [DayOfMonth] = 11;

UPDATE DimDate
SET IsHolidayUSA = 1, HolidayUSA = 'Christmas Day'
WHERE [Month] = 12 AND [DayOfMonth] = 25;

UPDATE DimDate
SET IsHolidayUSA = 1, HolidayUSA = 'Martin Luther King Jr. Day'
WHERE [Month] = 1 AND [DayName] = 'Monday' AND [DayOfWeekInMonth] = 3;

UPDATE DimDate
SET IsHolidayUSA = 1, HolidayUSA = 'President''s Day'
WHERE [Month] = 2 AND [DayName] = 'Monday' AND [DayOfWeekInMonth] = 3;

UPDATE DimDate
SET IsHolidayUSA = 1, HolidayUSA = 'Memorial Day'
WHERE [Month] = 5 AND [DayName] = 'Monday' AND [DayOfWeekInMonth] = 5;

UPDATE DimDate
SET IsHolidayUSA = 1, HolidayUSA = 'Labor Day'
WHERE [Month] = 9 AND [DayName] = 'Monday' AND [DayOfWeekInMonth] = 1;

UPDATE DimDate
SET IsHolidayUSA = 1, HolidayUSA = 'Columbus Day'
WHERE [Month] = 10 AND [DayName] = 'Monday' AND [DayOfWeekInMonth] = 2;

UPDATE DimDate
SET IsHolidayUSA = 1, HolidayUSA = 'Thanksgiving Day'
WHERE [Month] = 11 AND [DayName] = 'Thursday' AND [DayOfWeekInMonth] = 4;

UPDATE DimDate
SET IsHolidayGreece = 1, HolidayGreece = 'New Year''s Day'
WHERE [Month] = 1 AND [DayOfMonth] = 1;

UPDATE DimDate
SET IsHolidayGreece = 1, HolidayGreece = 'Epiphany'
WHERE [Month] = 1 AND [DayOfMonth] = 6;

UPDATE DimDate
SET IsHolidayGreece = 1, HolidayGreece = 'Clean Monday'
WHERE [Date] IN ('2024-03-18', '2025-03-03', '2026-02-23');

UPDATE DimDate
SET IsHolidayGreece = 1, HolidayGreece = 'Annunciation'
WHERE [Month] = 3 AND [DayOfMonth] = 25;

UPDATE DimDate
SET IsHolidayGreece = 1, HolidayGreece = 'Good Friday'
WHERE [Date] IN ('2024-05-03', '2025-04-18', '2026-04-10');

UPDATE DimDate
SET IsHolidayGreece = 1, HolidayGreece = 'Easter Monday'
WHERE [Date] IN ('2024-05-06', '2025-04-21', '2026-04-13');

UPDATE DimDate
SET IsHolidayGreece = 1, HolidayGreece = 'Labor Day'
WHERE [Month] = 5 AND [DayOfMonth] = 1;

UPDATE DimDate
SET IsHolidayGreece = 1, HolidayGreece = 'Holy Spirit Monday'
WHERE [Date] IN ('2024-06-24', '2025-06-09', '2026-05-31');

UPDATE DimDate
SET IsHolidayGreece = 1, HolidayGreece = 'Assumption Day'
WHERE [Month] = 8 AND [DayOfMonth] = 15;

UPDATE DimDate
SET IsHolidayGreece = 1, HolidayGreece = 'OHI Day'
WHERE [Month] = 10 AND [DayOfMonth] = 28;

UPDATE DimDate
SET IsHolidayGreece = 1, HolidayGreece = 'Christmas Day'
WHERE [Month] = 12 AND [DayOfMonth] = 25;

UPDATE DimDate
SET IsHolidayGreece = 1, HolidayGreece = 'Synaxis of the Mother of God'
WHERE [Month] = 12 AND [DayOfMonth] = 26;

