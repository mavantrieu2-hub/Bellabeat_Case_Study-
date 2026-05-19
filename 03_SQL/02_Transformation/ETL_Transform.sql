-------------------------------------------------- IV. Transform --------------------------------------------------
-- 4. Full Data by Minutes
WITH ProcessCaloriesOutliers_3122016_4112016 AS (
    SELECT Id, ActivityMinute, Calories,
        LAG(Calories) OVER (PARTITION BY Id ORDER BY ActivityMinute) AS 'PrevValues',
        LEAD(Calories) OVER (PARTITION BY Id ORDER BY ActivityMinute) AS 'NextValues'
    FROM minuteCalories_3_12_2016_4_11_2016
),
ProcessMETsOutliers_3122016_4112016 AS (
    SELECT Id, ActivityMinute, METs,
        LAG(METs) OVER (PARTITION BY Id ORDER BY ActivityMinute) AS 'MPrevValues',
        LEAD(METs) OVER (PARTITION BY Id ORDER BY ActivityMinute) AS 'MNextValues'
    FROM minuteMETs_3_12_2016_4_11_2016
),
MinuteActivity_3122016_4112016 AS (
    SELECT 
        C.Id,
        C.ActivityMinute,
        CASE
            WHEN C.Calories < 0.67 OR C.Calories > 22
            THEN ROUND((ISNULL(C.PrevValues,C.NextValues) + ISNULL(C.NextValues,C.PrevValues))/2.0,2)
            ELSE ROUND(C.Calories,2)
        END AS 'Calories',
        I.Intensity,
        CASE
            WHEN M.METs < 9.5 OR M.METs > 230
            THEN ROUND(CAST((ISNULL(M.MPrevValues,M.MNextValues) + ISNULL(M.MNextValues,M.MPrevValues))/2.0 AS FLOAT),2)
            ELSE ROUND(CAST(M.METs AS FLOAT),2)
        END AS 'METs',
        S.Steps
    FROM ProcessCaloriesOutliers_3122016_4112016 AS C
    LEFT JOIN minuteIntensities_3_12_2016_4_11_2016 AS I ON C.Id = I.Id AND C.ActivityMinute = I.ActivityMinute
    LEFT JOIN ProcessMETsOutliers_3122016_4112016 AS M ON C.Id = M.Id AND C.ActivityMinute = M.ActivityMinute
    LEFT JOIN minuteSteps_3_12_2016_4_11_2016 AS S ON C.Id = S.Id AND C.ActivityMinute = S.ActivityMinute
    WHERE C.ActivityMinute < '2016-04-12'
),
ProcessCaloriesOutliers_4122016_5122016 AS (
    SELECT Id, ActivityMinute, Calories,
        LAG(Calories) OVER (PARTITION BY Id ORDER BY ActivityMinute) AS 'PrevValues',
        LEAD(Calories) OVER (PARTITION BY Id ORDER BY ActivityMinute) AS 'NextValues'
    FROM minuteCalories_4_12_2016_5_12_2016
),
ProcessMETsOutliers_4122016_5122016 AS (
    SELECT Id, ActivityMinute, METs,
        LAG(METs) OVER (PARTITION BY Id ORDER BY ActivityMinute) AS 'PrevValues',
        LEAD(METs) OVER (PARTITION BY Id ORDER BY ActivityMinute) AS 'NextValues'
    FROM minuteMETs_4_12_2016_5_12_2016
),
MinuteActivity_4122016_5112016 AS (
    SELECT 
        C.Id,
        C.ActivityMinute,
        CASE
            WHEN C.Calories < 0.67 OR C.Calories > 22
            THEN ROUND((ISNULL(C.PrevValues,C.NextValues) + ISNULL(C.NextValues,C.PrevValues))/2.0,2)
            ELSE ROUND(C.Calories,2)
        END AS 'Calories',
        I.Intensity,
        CASE
            WHEN M.METs < 9.5 OR M.METs > 230
            THEN ROUND(CAST((ISNULL(M.PrevValues,M.NextValues) + ISNULL(M.NextValues,M.PrevValues))/2 AS FLOAT),2)
            ELSE ROUND(CAST(M.METs AS FLOAT),2)
        END AS 'METs',
        S.Steps
    FROM ProcessCaloriesOutliers_4122016_5122016 AS C
    LEFT JOIN minuteIntensities_4_12_2016_5_12_2016 AS I ON C.Id = I.Id AND C.ActivityMinute = I.ActivityMinute
    LEFT JOIN ProcessMETsOutliers_4122016_5122016 AS M ON C.Id = M.Id AND C.ActivityMinute = M.ActivityMinute
    LEFT JOIN minuteSteps_4_12_2016_5_12_2016 AS S ON C.Id = S.Id AND C.ActivityMinute = S.ActivityMinute
    WHERE C.ActivityMinute < '2016-5-12'
),
MinuteActivity_3122016_5112016 AS (
    SELECT * FROM MinuteActivity_3122016_4112016
    UNION ALL
    SELECT * FROM MinuteActivity_4122016_5112016
)
SELECT *
--INTO MinuteActivity_3122016_5112016
FROM MinuteActivity_3122016_5112016

-- 4.1 Check null
SELECT *
FROM MinuteActivity_3122016_5112016
WHERE Id IS NULL OR
    ActivityMinute IS NULL OR
    Calories IS NULL OR
    Intensity IS NULL OR
    METs IS NULL OR
    Steps IS NULL
ORDER BY ActivityMinute DESC

-- 4.2 Check duplicate
SELECT
    Id,
    ActivityMinute,
    COUNT(*) AS 'NumberOfDuplicate'
FROM MinuteActivity_3122016_5112016
GROUP BY Id, ActivityMinute
HAVING COUNT(*) > 1

-- 4.3 Check Outliers
SELECT *
FROM MinuteActivity_3122016_5112016
WHERE (Calories < 0.67 OR Calories > 22) OR (METs < 9.5 OR METs > 230)

-- 5. Data Model
-- 5.1 Data by Hourly
SELECT
    Id,
    DATETRUNC(HOUR, ActivityMinute) AS 'ActivityHour',
    ROUND(SUM(CAST(Calories AS FLOAT)),2) AS 'TotalCalories',
    SUM(CASE WHEN Intensity = 0 THEN 1 ELSE 0 END) AS 'SedentaryMinutes',
    SUM(CASE WHEN Intensity = 1 THEN 1 ELSE 0 END) AS 'LightActiveMinutes',
    SUM(CASE WHEN Intensity = 2 THEN 1 ELSE 0 END) AS 'ModerateActiveMinutes',
    SUM(CASE WHEN Intensity = 3 THEN 1 ELSE 0 END) AS 'VeryActiveMinutes',
    SUM(Steps) AS 'TotalSteps'
-- INTO FactActivityHour
FROM MinuteActivity_3122016_5112016
GROUP BY Id, DATETRUNC(HOUR, ActivityMinute)
ORDER BY Id, DATETRUNC(HOUR, ActivityMinute)

-- DROP TABLE IF EXISTS FactActivityHour
-- 5.2 Dim Hourly
SELECT DISTINCT
    DATETRUNC(HOUR, ActivityMinute) AS 'ActivityHour',
    DATEPART(HOUR,ActivityMinute) AS 'HourNumber'
--INTO DimHour
FROM MinuteActivity_3122016_5112016

-- 5.2 Data by Daily
SELECT
    Id,
    CAST(ActivityMinute AS DATE) AS 'ActivityDay',
    ROUND(SUM(CAST(Calories AS FLOAT)),2) AS 'TotalCalories',
    SUM(Steps) AS 'TotalSteps',
    SUM(CASE WHEN Intensity = 0 THEN 1 ELSE 0 END) AS 'SedentaryMinutes',
    SUM(CASE WHEN Intensity = 1 THEN 1 ELSE 0 END) AS 'LightActiveMinutes',
    SUM(CASE WHEN Intensity = 2 THEN 1 ELSE 0 END) AS 'ModerateActiveMinutes',
    SUM(CASE WHEN Intensity = 3 THEN 1 ELSE 0 END) AS 'VeryActiveMinutes',
    COUNT(*) AS 'TotalActiveMinutes'
--INTO FactActivity
FROM MinuteActivity_3122016_5112016
GROUP BY Id, CAST(ActivityMinute AS DATE)

-- DROP TABLE IF EXISTS DailyActivity_3122016_5112016;
--     COUNT(DISTINCT DATETRUNC(HOUR,ActivityMinute)) AS 'NumberHourOfDay',
-- DATENAME(Weekday,CAST(ActivityMinute AS DATE)) AS 'DayName',

-- 5.3 Dim Date
SELECT DISTINCT
    CAST(ActivityMinute AS DATE) AS 'Date',
    DATENAME(Weekday,CAST(ActivityMinute AS DATE)) AS 'DayName',
    CASE
        WHEN DATEPART(Weekday, CAST(ActivityMinute AS DATE)) = 2 THEN '2'
        WHEN DATEPART(Weekday, CAST(ActivityMinute AS DATE)) = 3 THEN '3'
        WHEN DATEPART(Weekday, CAST(ActivityMinute AS DATE)) = 4 THEN '4'
        WHEN DATEPART(Weekday, CAST(ActivityMinute AS DATE)) = 5 THEN '5'
        WHEN DATEPART(Weekday, CAST(ActivityMinute AS DATE)) = 6 THEN '6'
        WHEN DATEPART(Weekday, CAST(ActivityMinute AS DATE)) = 7 THEN '7'
        ELSE 8
    END AS 'DayNumber'
--INTO DimDate
FROM MinuteActivity_3122016_5112016

DROP TABLE IF EXISTS DimDate

-- 5.4 Dim users
SELECT
    DISTINCT Id
--INTO DimUser
FROM MinuteActivity_3122016_5112016

-- 6. Test Analyze
SELECT
    Id,
    AVG(TotalSteps) AS 'AVGStepsperDay'
FROM FactActivity

-- Wekday
SELECT
    Id,
    CAST(ActivityMinute AS DATE),
    DATENAME(WeekDay, CAST(ActivityMinute AS DATE)) AS 'WeekDay',
    SUM(Calories),
    SUM(Intensity),
    SUM(METs),
    SUM(Steps)
FROM MinuteActivity_3122016_5112016
GROUP BY Id, CAST(ActivityMinute AS DATE)

-- Time segment:
SELECT
    Id,
    CAST(ActivityMinute AS DATE),
    CASE
        WHEN DATEPART(HOUR, ActivityMinute) BETWEEN 6 AND 11 THEN 'Morning'
            WHEN DATEPART(HOUR, ActivityMinute) BETWEEN 12 AND 17 THEN 'Afternoon'
            WHEN DATEPART(HOUR, ActivityMinute) BETWEEN 18 AND 22 THEN 'Evening'
            ELSE 'Night'
        END AS 'TimeOfDay',
    SUM(Calories),
    SUM(Intensity),
    SUM(METs),
    SUM(Steps)
FROM MinuteActivity_3122016_5112016
GROUP BY Id, CAST(ActivityMinute AS DATE),
    CASE
        WHEN DATEPART(HOUR, ActivityMinute) BETWEEN 6 AND 11 THEN 'Morning'
            WHEN DATEPART(HOUR, ActivityMinute) BETWEEN 12 AND 17 THEN 'Afternoon'
            WHEN DATEPART(HOUR, ActivityMinute) BETWEEN 18 AND 22 THEN 'Evening'
            ELSE 'Night'
        END
ORDER BY Id, CAST(ActivityMinute AS DATE)

SELECT 
    Id,
    CAST(ActivityMinute AS DATE),
    SUM(Intensity)
FROM MinuteActivity_3122016_5112016
GROUP BY Id, CAST(ActivityMinute AS DATE);

-- Trend 1:
WITH DailyActivity_3122016_5112016 AS (
    SELECT
        Id,
        CAST(ActivityMinute AS DATE) AS 'ActivityDay',
        ROUND(SUM(CAST(Calories AS FLOAT)),2) AS 'TotalCalories',
        ROUND(AVG(CAST(Intensity AS FLOAT)),2) AS 'AvgIntensity',
        ROUND(SUM(Steps),2) AS 'TotalSteps'
    FROM MinuteActivity_3122016_5112016
    GROUP BY Id, CAST(ActivityMinute AS DATE)
)
SELECT *
FROM DailyActivity_3122016_5112016
WHERE TotalCalories < 1800
ORDER BY Id, ActivityDay