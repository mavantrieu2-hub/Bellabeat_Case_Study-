-------------------------------------------------- III. CHECK THE DATA FOR ERRORS --------------------------------------------------
-- 2.1 Check Schema Data

SELECT *
FROM INFORMATION_SCHEMA.TABLES

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS

-- 2.2 Check Completeness
-- 2.2.1 Check Null data
SELECT '01_dailyActivity_3_12_2016_4_11_2016' AS 'TableName', COUNT(*) AS 'RowsWithNull' FROM dailyActivity_3_12_2016_4_11_2016
WHERE Id IS NULL OR ActivityDate IS NULL OR TotalSteps IS NULL OR Calories IS NULL OR TotalDistance IS NULL
UNION ALL
SELECT '02_hourly_Caloriies_3_12_2016_4_11_2016', COUNT(*) FROM hourlyCalories_3_12_2016_4_11_2016
WHERE Id IS NULL OR ActivityHour IS NULL OR Calories IS NULL
UNION ALL
SELECT '03_minuteMETs_3_12_2016_4_11_2016', COUNT(*) FROM minuteMETs_3_12_2016_4_11_2016
WHERE Id IS NULL OR ActivityMinute IS NULL OR METs IS NULL
UNION ALL
SELECT '04_Daily_4_12_2016_5_12_2016', COUNT(*) FROM dailyActivity_4_12_2016_5_12_2016
WHERE Id IS NULL OR ActivityDate IS NULL OR Calories IS NULL OR TotalSteps IS NULL
UNION ALL
SELECT '05_hourly_Intensities_3_12_2016_4_11_2016', COUNT(*) FROM hourlyIntensities_4_12_2016_5_12_2016
WHERE Id IS NULL OR ActivityHour IS NULL OR TotalIntensity IS NULL
UNION ALL
SELECT '06_minute_4_12_2016_5_12_2016', COUNT(*) FROM minuteSteps_4_12_2016_5_12_2016
WHERE Id IS NULL OR ActivityMinute IS NULL OR Steps IS NULL

-- 2.2.2 Check duplicate
SELECT '01_dailyActivity_3_12_2016_4_11_2016' AS 'TableName',
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT CAST(Id AS VARCHAR) + CAST(ActivityDate AS VARCHAR)) AS 'UniqueRows'
FROM dailyActivity_3_12_2016_4_11_2016
UNION ALL
SELECT '02_hourlyCalories_3_12_2016_4_11_2016',
    COUNT(*),
    COUNT(DISTINCT CAST(Id AS VARCHAR) + CAST(ActivityHour AS VARCHAR))
FROM hourlyCalories_3_12_2016_4_11_2016
UNION ALL
SELECT '03_minuteMETs_3_12_2016_4_11_2016',
    COUNT(*),
    COUNT(DISTINCT CAST(Id AS VARCHAR) + CAST(ActivityMinute AS VARCHAR))
FROM minuteMETs_3_12_2016_4_11_2016
UNION ALL
SELECT '04_dailyActivity_4_12_2016_5_12_2016', 
    COUNT(*), 
    COUNT(DISTINCT CAST(Id AS VARCHAR) + CAST(ActivityDate AS VARCHAR))
FROM dailyActivity_4_12_2016_5_12_2016
UNION ALL
SELECT '05_hourlyIntensities_4_12_2016_5_12_2016',
    COUNT(*),
    COUNT(DISTINCT CAST(Id AS VARCHAR) + CAST(ActivityHour AS VARCHAR))
FROM hourlyIntensities_4_12_2016_5_12_2016
UNION ALL
SELECT '06_minuteCalories_4_12_2016_5_12_2016',
    COUNT(*),
    COUNT(DISTINCT CAST(Id AS VARCHAR) + CAST(ActivityMinute AS VARCHAR))
FROM minuteCalories_4_12_2016_5_12_2016
ORDER BY TableName

-- 2.2.3 Check Range data from 3/12/2016 - 4/11/2016
SELECT '01_daily_3_12_2016_4_11_2016' AS 'TableName',
    MIN(ActivityDate) AS 'Min',
    MAX(ActivityDate) AS 'Max'
FROM dailyActivity_3_12_2016_4_11_2016
UNION ALL
SELECT '02_hourlyCalorires_3_12_2016_4_11_2016',
    MIN(ActivityHour),
    MAX(ActivityHour)
FROM hourlyCalories_3_12_2016_4_11_2016
UNION ALL
SELECT '03_minuteMETs_3_12_2016_4_11_2016',
    MIN(ActivityMinute),
    MAX(ActivityMinute)
FROM minuteMETs_3_12_2016_4_11_2016
UNION ALL
SELECT '04_daily_04_12_2016_5_12_2016',
    MIN(ActivityDate),
    MAX(ActivityDate)
FROM dailyActivity_4_12_2016_5_12_2016
UNION ALL
SELECT '05_hourlyIntensities_4_12_2016_5_12_2016',
    MIN(ActivityHour),
    MAX(ActivityHour)
FROM hourlyIntensities_4_12_2016_5_12_2016
UNION ALL
SELECT '06_minuteCalories_4_12_2016_5_12_2016',
    MIN(ActivityMinute),
    MAX(ActivityMinute)
FROM minuteCalories_4_12_2016_5_12_2016
ORDER BY TableName

-- 2.2.4 Ids
WITH CheckNumberOfIds AS (
    SELECT '01_dailyActivity_3_12_2016_4_11_2016' AS 'FilesName', COUNT(DISTINCT Id) AS 'NumberOfIds' FROM dailyActivity_3_12_2016_4_11_2016
    UNION ALL
    SELECT '02_hourlySteps_3_12_2016_4_11_2016', COUNT(DISTINCT Id) FROM hourlySteps_3_12_2016_4_11_2016
    UNION ALL
    SELECT '03_minuteCalories_4_12_2016_5_12_2016', COUNT(DISTINCT Id) FROM minuteCalories_3_12_2016_4_11_2016
    UNION ALL
    SELECT '04_dailyActivity_4_12_2016_5_12_2016', COUNT(DISTINCT Id) FROM dailyActivity_4_12_2016_5_12_2016
    UNION ALL
    SELECT '05_hourlyCalories_4_12_2016_5_12_2016', COUNT(DISTINCT Id) FROM hourlyCalories_4_12_2016_5_12_2016
    UNION ALL
    SELECT '06_minuteMETs_4_12_2016_5_12_2016', COUNT(DISTINCT Id) FROM minuteMETs_4_12_2016_5_12_2016
)
SELECT *
FROM CheckNumberOfIds
ORDER BY FilesName

-- 2.2.5 Check Discrepant IDs

SELECT Id FROM minuteIntensities_3_12_2016_4_11_2016
EXCEPT
SELECT Id FROM minuteCalories_3_12_2016_4_11_2016

SELECT Id FROM hourlyIntensities_3_12_2016_4_11_2016
EXCEPT
SELECT Id FROM hourlySteps_3_12_2016_4_11_2016

SELECT Id FROM minuteIntensities_3_12_2016_4_11_2016
EXCEPT
SELECT Id FROM hourlySteps_3_12_2016_4_11_2016

SELECT Id FROM dailyActivity_3_12_2016_4_11_2016
EXCEPT
SELECT Id FROM hourlySteps_3_12_2016_4_11_2016

SELECT Id FROM minuteIntensities_4_12_2016_5_12_2016
EXCEPT
SELECT Id FROM minuteCalories_4_12_2016_5_12_2016

SELECT Id FROM hourlyCalories_4_12_2016_5_12_2016
EXCEPT
SELECT Id FROM hourlySteps_4_12_2016_5_12_2016

SELECT Id FROM minuteIntensities_4_12_2016_5_12_2016
EXCEPT
SELECT Id FROM hourlySteps_4_12_2016_5_12_2016

SELECT Id FROM dailyActivity_4_12_2016_5_12_2016
EXCEPT
SELECT Id FROM hourlySteps_4_12_2016_5_12_2016

SELECT Id FROM minuteIntensities_3_12_2016_4_11_2016
EXCEPT
SELECT Id FROM hourlySteps_4_12_2016_5_12_2016

SELECT Id FROM dailyActivity_3_12_2016_4_11_2016
EXCEPT
SELECT Id FROM hourlySteps_4_12_2016_5_12_2016

SELECT Id FROM hourlySteps_4_12_2016_5_12_2016
EXCEPT
SELECT Id FROM minuteIntensities_3_12_2016_4_11_2016;

WITH FullID AS (
    SELECT Id FROM dailyActivity_3_12_2016_4_11_2016
    UNION
    SELECT Id FROM hourlySteps_3_12_2016_4_11_2016
    UNION
    SELECT Id FROM minuteIntensities_4_12_2016_5_12_2016
)
SELECT 
    F.Id AS 'Id',
    CASE WHEN D1.Id IS NOT NULL THEN '1' ELSE '0' END AS 'Daily1',
    CASE WHEN H1.Id IS NOT NULL THEN '1' ELSE '0' END AS 'Hourly1',
    CASE WHEN M1.Id IS NOT NULL THEN '1' ELSE '0' END AS 'Minute1',
    CASE WHEN D2.Id IS NOT NULL THEN '1' ELSE '0' END AS 'Daily2',
    CASE WHEN H2.Id IS NOT NULL THEN '1' ELSE '0' END AS 'Hourly2',
    CASE WHEN M2.Id IS NOT NULL THEN '1' ELSE '0' END AS 'Minute2'
FROM FullID AS F
LEFT JOIN (SELECT DISTINCT Id FROM dailyActivity_3_12_2016_4_11_2016) AS D1 ON F.Id = D1.Id
LEFT JOIN (SELECT DISTINCT Id FROM hourlyIntensities_3_12_2016_4_11_2016) AS H1 ON F.Id = H1.Id
LEFT JOIN (SELECT DISTINCT Id FROM minuteCalories_3_12_2016_4_11_2016) AS M1 ON F.Id = M1.Id
LEFT JOIN (SELECT DISTINCT Id FROM dailyActivity_4_12_2016_5_12_2016) AS D2 ON F.Id = D2.Id
LEFT JOIN (SELECT DISTINCT Id FROM hourlySteps_4_12_2016_5_12_2016) AS H2 ON F.Id = H2.Id
LEFT JOIN (SELECT DISTINCT Id FROM minuteMETs_4_12_2016_5_12_2016) AS M2 ON F.Id = M2.Id
-- WHERE D1.Id IS NULL OR H1.Id IS NULL OR M2.Id IS NULL

WITH 
D1 AS (SELECT Id, COUNT(DISTINCT ActivityDate) AS 'Day' FROM dailyActivity_3_12_2016_4_11_2016 GROUP BY Id),
H1 AS (SELECT Id, COUNT(DISTINCT CAST(ActivityHour AS DATE)) AS 'Day' FROM hourlyCalories_3_12_2016_4_11_2016 GROUP BY Id),
M1 AS (SELECT Id, COUNT(DISTINCT CAST(ActivityMinute AS DATE)) AS 'Day' FROM minuteIntensities_3_12_2016_4_11_2016 GROUP BY Id),
D2 AS (SELECT Id, COUNT(DISTINCT ActivityDate) AS 'Day' FROM dailyActivity_4_12_2016_5_12_2016 GROUP BY Id),
H2 AS (SELECT Id, COUNT(DISTINCT CAST(ActivityHour AS DATE)) AS 'Day' FROM hourlyIntensities_4_12_2016_5_12_2016 GROUP BY Id),
M2 AS (SELECT Id, COUNT(DISTINCT CAST(ActivityMinute AS DATE)) AS 'Day' FROM minuteSteps_4_12_2016_5_12_2016 GROUP BY Id),
FullID AS (
    SELECT Id FROM D1
    UNION
    SELECT Id FROM H1
    UNION
    SELECT Id FROM M2
)
SELECT
    F.Id,
    D1.Day AS 'Daily_3_12_2016_4_11_2016',
    H1.Day AS 'Hourly_3_12_2016_4_11_2016',
    M1.Day AS 'Minute_3_12_2016_4_11_2016',
    D2.Day AS 'Daily_4_12_2016_5_12_2016',
    H2.Day AS 'Hourly_4_12_2016_5_12_2016',
    M2.Day AS 'Minute_4_12_2016_5_12_2016'
FROM FullId AS F
LEFT JOIN D1 ON F.Id = D1.Id
LEFT JOIN H1 ON F.Id = H1.Id
LEFT JOIN M1 ON F.Id = M1.Id
LEFT JOIN D2 ON F.Id = D2.Id
LEFT JOIN H2 ON F.Id = H2.Id
LEFT JOIN M2 ON F.Id = M2.Id

-- 2.3 Check consistency
-- 2.3.1 Check Consistency Daily, Hourly, Minutes
WITH
SumDailyId1 AS (SELECT Id, SUM(Calories) AS 'Calorires' FROM DailyActivity_3_12_2016_4_11_2016 GROUP BY Id),
SumHourlyCalories1 AS (SELECT Id, SUM(Calories) AS 'Calories' FROM hourlyCalories_3_12_2016_4_11_2016 GROUP BY Id),
SumMinuteCalories1 AS (SELECT Id, SUM(Calories) AS 'Calories' FROM minuteCalories_3_12_2016_4_11_2016 GROUP BY Id), 
SumDailyId2 AS (SELECT Id, SUM(TotalSteps) AS 'Steps' FROM DailyActivity_4_12_2016_5_12_2016 GROUP BY Id),
SumHourlySteps2 AS (SELECT Id, SUM(StepTotal) AS 'Steps' FROM hourlySteps_4_12_2016_5_12_2016 GROUP BY Id),
SumMinuteSteps2 AS (SELECT Id, SUM(Steps) AS 'Steps' FROM minuteSteps_4_12_2016_5_12_2016 GROUP BY Id)
SELECT
    D1.Id,
    D1.Calorires,
    H1.Calories,
    M1.Calories,
    D2.Steps,
    H2.Steps,
    M2.Steps
FROM SumDailyId1 AS D1
LEFT JOIN SumHourlyCalories1 AS H1 ON D1.Id = H1.Id
LEFT JOIN SumMinuteCalories1 AS M1 ON D1.Id = M1.Id
LEFT JOIN SumDailyId2 AS D2 ON D1.Id = D2.Id
LEFT JOIN SumHourlySteps2 AS H2 ON D1.Id = H2.Id
LEFT JOIN SumMinuteSteps2 AS M2 ON D1.Id = M2.Id

-- 2.3.2 Check Consisency Minutes
WITH FullIdAndTime AS(
    SELECT Id, ActivityMinute FROM minuteCalories_3_12_2016_4_11_2016 WHERE ActivityMinute < '2016-04-12'
    UNION
    SELECT Id, ActivityMinute FROM minuteIntensities_3_12_2016_4_11_2016 WHERE ActivityMinute < '2016-04-12'
    UNION
    SELECT Id, ActivityMinute FROM minuteMETs_3_12_2016_4_11_2016 WHERE ActivityMinute < '2016-04-12'
    UNION
    SELECT Id, ActivityMinute FROM minuteSteps_3_12_2016_4_11_2016 WHERE ActivityMinute < '2016-04-12'
)
SELECT
    F.Id,
    F.ActivityMinute,
    C.Calories,
    I.Intensity,
    M.METs,
    S.Steps
FROM FullIdAndTime AS F
LEFT JOIN minuteCalories_3_12_2016_4_11_2016 AS C ON F.Id = C.Id AND F.ActivityMinute = C.ActivityMinute
LEFT JOIN minuteIntensities_3_12_2016_4_11_2016 AS I ON F.Id = I.Id AND F.ActivityMinute = I.ActivityMinute
LEFT JOIN minuteMETs_3_12_2016_4_11_2016 AS M ON F.Id = M.Id AND F.ActivityMinute = M.ActivityMinute
LEFT JOIN minuteSteps_3_12_2016_4_11_2016 AS S ON F.Id = S.Id AND F.ActivityMinute = S.ActivityMinute
WHERE Calories IS NULL OR Intensity IS NULL OR METs IS NULL OR Steps IS NULL

WITH FullIdAndTime AS(
    SELECT Id, ActivityMinute FROM minuteCalories_4_12_2016_5_12_2016 WHERE ActivityMinute < '2016-05-12'
    UNION
    SELECT Id, ActivityMinute FROM minuteIntensities_4_12_2016_5_12_2016 WHERE ActivityMinute < '2016-05-12'
    UNION
    SELECT Id, ActivityMinute FROM minuteMETs_4_12_2016_5_12_2016 WHERE ActivityMinute < '2016-05-12'
    UNION
    SELECT Id, ActivityMinute FROM minuteSteps_4_12_2016_5_12_2016 WHERE ActivityMinute < '2016-05-12'
)
SELECT
    F.Id,
    F.ActivityMinute,
    C.Calories,
    I.Intensity,
    M.METs,
    S.Steps
FROM FullIdAndTime AS F
LEFT JOIN minuteCalories_4_12_2016_5_12_2016 AS C ON F.Id = C.Id AND F.ActivityMinute = C.ActivityMinute
LEFT JOIN minuteIntensities_4_12_2016_5_12_2016 AS I ON F.Id = I.Id AND F.ActivityMinute = I.ActivityMinute
LEFT JOIN minuteMETs_4_12_2016_5_12_2016 AS M ON F.Id = M.Id AND F.ActivityMinute = M.ActivityMinute
LEFT JOIN minuteSteps_4_12_2016_5_12_2016 AS S ON F.Id = S.Id AND F.ActivityMinute = S.ActivityMinute
WHERE Calories IS NULL OR Intensity IS NULL OR METs IS NULL OR Steps IS NULL

-- 2.4. Outliers
-- 2.4.1 Calories
SELECT
    Id,
    MIN(Calories) AS 'MinCalories',
    MAX(Calories) AS 'MaxCalories',
    SUM(CASE WHEN Calories < 0.67 OR Calories > 22 THEN 1 ELSE 0 END) AS 'NumOfOutliers'
FROM minuteCalories_3_12_2016_4_11_2016
WHERE ActivityMinute < '2016-04-12'
GROUP BY Id
HAVING MIN(Calories) < 0.67 OR MAX (Calories) > 22

SELECT
    Id,
    MIN(Calories) AS 'MinCalories',
    MAX(Calories) AS 'MaxCalories',
    SUM(CASE WHEN Calories < 0.67 OR Calories > 22 THEN 1 ELSE 0 END) AS 'NumOfOutlier'
FROM minuteCalories_4_12_2016_5_12_2016
WHERE ActivityMinute < '2016-05-12'
GROUP BY Id
HAVING MIN(Calories) < 0.67 OR MAX (Calories) > 22

-- 2.4.2 Surrouding Calories outliers
WITH Tempp AS (
    SELECT Id, ActivityMinute, Calories,
        MIN(Calories) OVER (PARTITION BY Id ORDER BY ActivityMinute ROWS BETWEEN 5 PRECEDING AND 5 FOLLOWING) AS WinMin,
        MAX(Calories) OVER (PARTITION BY Id ORDER BY ActivityMinute ROWS BETWEEN 5 PRECEDING AND 5 FOLLOWING) AS WinMax
    FROM minuteCalories_3_12_2016_4_11_2016
)
SELECT
    Id,
    ActivityMinute,
    Calories
FROM Tempp
WHERE ActivityMinute < '2016-4-12' AND (WinMin < 0.67 OR WinMax > 22)

WITH Tempp AS (
    SELECT Id, ActivityMinute, Calories,
        MIN(Calories) OVER (PARTITION BY Id ORDER BY ActivityMinute ROWS BETWEEN 5 PRECEDING AND 5 FOLLOWING) AS WinMin,
        MAX(Calories) OVER (PARTITION BY Id ORDER BY ActivityMinute ROWS BETWEEN 5 PRECEDING AND 5 FOLLOWING) AS WinMax
    FROM minuteCalories_4_12_2016_5_12_2016
)
SELECT
    Id,
    ActivityMinute,
    Calories
FROM Tempp
WHERE ActivityMinute < '2016-5-12' AND (WinMin < 0.67 OR WinMax > 22)

-- 2.4.3 Intensities
SELECT
    Id,
    MIN(Intensity) AS 'MinCalories1',
    MAX(Intensity) AS 'MaxCalories2',
    SUM(CASE WHEN Intensity < 0 OR Intensity > 3 THEN 1 ELSE 0 END) AS 'NumOfOutliers'
FROM minuteIntensities_3_12_2016_4_11_2016
WHERE ActivityMinute < '2016-04-12'
GROUP BY Id

SELECT
    Id,
    MIN(Intensity) AS 'MinCalories2',
    MAX(Intensity) AS 'MaxCalories2',
    SUM(CASE WHEN Intensity < 0 OR Intensity > 3 THEN 1 ELSE 0 END) AS 'NumOfOutliers'
FROM minuteIntensities_4_12_2016_5_12_2016
WHERE ActivityMinute < '2016-05-12'
GROUP BY Id

SELECT ActivityMinute FROM minuteIntensities_3_12_2016_4_11_2016
EXCEPT
SELECT ActivityMinute FROM minuteCalories_3_12_2016_4_11_2016
EXCEPT
SELECT ActivityMinute FROM minuteMETs_3_12_2016_4_11_2016
EXCEPT
SELECT ActivityMinute FROM minuteSteps_3_12_2016_4_11_2016;

WITH FullIdAndTime AS(
    SELECT Id, ActivityMinute FROM minuteCalories_3_12_2016_4_11_2016 WHERE ActivityMinute < '2016-04-12'
    UNION
    SELECT Id, ActivityMinute FROM minuteIntensities_3_12_2016_4_11_2016 WHERE ActivityMinute < '2016-04-12'
    UNION
    SELECT Id, ActivityMinute FROM minuteMETs_3_12_2016_4_11_2016 WHERE ActivityMinute < '2016-04-12'
    UNION
    SELECT Id, ActivityMinute FROM minuteSteps_3_12_2016_4_11_2016 WHERE ActivityMinute < '2016-04-12'
)
SELECT
    F.Id,
    F.ActivityMinute,
    C.Calories,
    I.Intensity,
    M.METs,
    S.Steps
FROM FullIdAndTime AS F
LEFT JOIN minuteCalories_3_12_2016_4_11_2016 AS C ON F.Id = C.Id AND F.ActivityMinute = C.ActivityMinute
LEFT JOIN minuteIntensities_3_12_2016_4_11_2016 AS I ON F.Id = I.Id AND F.ActivityMinute = I.ActivityMinute
LEFT JOIN minuteMETs_3_12_2016_4_11_2016 AS M ON F.Id = M.Id AND F.ActivityMinute = M.ActivityMinute
LEFT JOIN minuteSteps_3_12_2016_4_11_2016 AS S ON F.Id = S.Id AND F.ActivityMinute = S.ActivityMinute
WHERE Calories IS NULL OR Intensity IS NULL OR METs IS NULL OR Steps IS NULL

WITH FullIdAndTime AS(
    SELECT Id, ActivityMinute FROM minuteCalories_4_12_2016_5_12_2016 WHERE ActivityMinute < '2016-05-12'
    UNION
    SELECT Id, ActivityMinute FROM minuteIntensities_4_12_2016_5_12_2016 WHERE ActivityMinute < '2016-05-12'
    UNION
    SELECT Id, ActivityMinute FROM minuteMETs_4_12_2016_5_12_2016 WHERE ActivityMinute < '2016-05-12'
    UNION
    SELECT Id, ActivityMinute FROM minuteSteps_4_12_2016_5_12_2016 WHERE ActivityMinute < '2016-05-12'
)
SELECT
    F.Id,
    F.ActivityMinute,
    C.Calories,
    I.Intensity,
    M.METs,
    S.Steps
FROM FullIdAndTime AS F
LEFT JOIN minuteCalories_4_12_2016_5_12_2016 AS C ON F.Id = C.Id AND F.ActivityMinute = C.ActivityMinute
LEFT JOIN minuteIntensities_4_12_2016_5_12_2016 AS I ON F.Id = I.Id AND F.ActivityMinute = I.ActivityMinute
LEFT JOIN minuteMETs_4_12_2016_5_12_2016 AS M ON F.Id = M.Id AND F.ActivityMinute = M.ActivityMinute
LEFT JOIN minuteSteps_4_12_2016_5_12_2016 AS S ON F.Id = S.Id AND F.ActivityMinute = S.ActivityMinute
WHERE Calories IS NULL OR Intensity IS NULL OR METs IS NULL OR Steps IS NULL

-- 2.4.4 METs
SELECT
    Id,
    MIN(METs),
    MAX(METs),
    SUM(CASE WHEN METs < 9.5 OR METs > 230 THEN 1 ELSE 0 END) AS 'NumOfOutliers'
FROM minuteMETs_3_12_2016_4_11_2016
WHERE ActivityMinute < '2016-04-12'
GROUP BY Id

SELECT
    Id,
    MIN(METs),
    MAX(METs),
    SUM(CASE WHEN METs < 9.5 OR METs > 230 THEN 1 ELSE 0 END) AS 'NumOfOutliers'
FROM minuteMETs_4_12_2016_5_12_2016
WHERE ActivityMinute < '2016-05-12'
GROUP BY Id;

-- 2.4.5 Surrounding METs Outliers 
WITH Tempp AS (
    SELECT Id, ActivityMinute, METs,
        MIN(METs) OVER (PARTITION BY Id ORDER BY ActivityMinute ROWS BETWEEN 5 PRECEDING AND 5 FOLLOWING) AS 'WinMin',
        MAX(METs) OVER (PARTITION BY Id ORDER BY ActivityMinute ROWS BETWEEN 5 PRECEDING AND 5 FOLLOWING) AS 'WinMax'
    FROM minuteMETs_3_12_2016_4_11_2016
)
SELECT
    Id,
    ActivityMinute,
    METs
FROM Tempp
WHERE ActivityMinute < '2016-5-12' AND (WinMin < 9.5 OR WinMax > 230)

WITH Tempp AS (
    SELECT Id, ActivityMinute, METs,
        MIN(METs) OVER (PARTITION BY Id ORDER BY ActivityMinute ROWS BETWEEN 5 PRECEDING AND 5 FOLLOWING) AS 'WinMin',
        MAX(METs) OVER (PARTITION BY Id ORDER BY ActivityMinute ROWS BETWEEN 5 PRECEDING AND 5 FOLLOWING) AS 'WinMax'
    FROM minuteMETs_4_12_2016_5_12_2016
)
SELECT
    Id,
    ActivityMinute,
    METs
FROM Tempp
WHERE ActivityMinute < '2016-05-12' AND (WinMin < 9.5 OR WinMax > 230)

-- 2.4.6 Steps
SELECT
    Id,
    MIN(Steps) AS 'MinSteps1',
    MAX(Steps) AS 'MaxSteps1',
    SUM(CASE WHEN Steps < 0 OR Steps > 220 THEN 1 ELSE 0 END) AS 'NumOfOutliers'
FROM minuteSteps_3_12_2016_4_11_2016
WHERE ActivityMinute < '2016-04-12'
GROUP BY Id

SELECT
    Id,
    MIN(Steps) AS 'MinSteps2',
    MAX(Steps) AS 'MaxSteps2',
    SUM(CASE WHEN Steps < 0 OR Steps > 220 THEN 1 ELSE 0 END) AS 'NumOfOutliers'
FROM minuteSteps_4_12_2016_5_12_2016
WHERE ActivityMinute < '2016-05-12'
GROUP BY Id

-- 3. Transfrom
-- 3.1 Remove Day Errors
SELECT TOP 5 *
FROM minuteCalories_3_12_2016_4_11_2016
WHERE ActivityMinute < '2016-04-12'
ORDER BY ActivityMinute DESC

SELECT TOP 5 *
FROM minuteMETs_4_12_2016_5_12_2016
WHERE ActivityMinute < '2016-05-12'
ORDER BY ActivityMinute DESC

-- 3.2  Merger Data 
WITH MinuteActivity_3122016_4112016 AS (
    SELECT C.Id, C.ActivityMinute, C.Calories, I.Intensity, M.METs, S.Steps
    FROM minuteCalories_3_12_2016_4_11_2016 AS C
    LEFT JOIN minuteIntensities_3_12_2016_4_11_2016 AS I ON C.Id = I.Id AND C.ActivityMinute = I.ActivityMinute
    LEFT JOIN minuteMETs_3_12_2016_4_11_2016 AS M ON C.Id = M.Id AND C.ActivityMinute = M.ActivityMinute
    LEFT JOIN minuteSteps_3_12_2016_4_11_2016 AS S ON C.Id = S.Id AND C.ActivityMinute = S.ActivityMinute
    WHERE C.ActivityMinute < '2016-04-12'
),
MinuteActivity_4122016_5112016 AS (
    SELECT C.Id, C.ActivityMinute, C.Calories, I.Intensity, M.METs, S.Steps
    FROM minuteCalories_4_12_2016_5_12_2016 AS C
    LEFT JOIN minuteIntensities_4_12_2016_5_12_2016 AS I ON C.Id = I.Id AND C.ActivityMinute = I.ActivityMinute
    LEFT JOIN minuteMETs_4_12_2016_5_12_2016 AS M ON C.Id = M.Id AND C.ActivityMinute = M.ActivityMinute
    LEFT JOIN minuteSteps_4_12_2016_5_12_2016 AS S ON C.Id = S.Id AND C.ActivityMinute = S.ActivityMinute
    WHERE C.ActivityMinute < '2016-5-12'
)
SELECT * FROM MinuteActivity_3122016_4112016
UNION
SELECT * FROM MinuteActivity_4122016_5112016;

-- 3.3 Replace Missing Calories Values

WITH ReplaceCalories_3122016_4112016 AS (
    SELECT Id, ActivityMinute, Calories,
        MIN(Calories) OVER (PARTITION BY Id ORDER BY ActivityMinute ROWS BETWEEN 5 PRECEDING AND 5 FOLLOWING) AS 'WinMin',
        MAX(Calories) OVER (PARTITION BY Id ORDER BY ActivityMinute ROWS BETWEEN 5 PRECEDING AND 5 FOLLOWING) AS 'WinMax',
        LAG(Calories) OVER (PARTITION BY Id ORDER BY ActivityMinute) AS 'PrevValue',
        LEAD(Calories) OVER (PARTITION BY Id ORDER BY ActivityMinute) AS 'NextValue'
    FROM minuteCalories_3_12_2016_4_11_2016
    WHERE ActivityMinute < '2016-04-12'
)
SELECT
    Id,
    ActivityMinute,
    Calories,
    CASE
        WHEN Calories < 0.67 OR Calories > 22
        THEN (ISNULL(PrevValue,NextValue) + ISNULL(NextValue,PrevValue))/2
        ELSE Calories
    END AS 'CaloriesReplace'
FROM ReplaceCalories_3122016_4112016
WHERE WinMin < 0.67 OR WinMax > 22

WITH ReplaceCalories_4122016_5112016 AS (
    SELECT Id, ActivityMinute, Calories,
        MIN(Calories) OVER (PARTITION BY Id ORDER BY ActivityMinute ROWS BETWEEN 5 PRECEDING AND 5 FOLLOWING) AS 'WinMin',
        MAX(Calories) OVER (PARTITION BY Id ORDER BY ActivityMinute ROWS BETWEEN 5 PRECEDING AND 5 FOLLOWING) AS 'WinMax',
        LAG(Calories) OVER (PARTITION BY Id ORDER BY ActivityMinute) AS 'PrevValue',
        LEAD(Calories) OVER (PARTITION BY Id ORDER BY ActivityMinute) AS 'NextValue'
    FROM minuteCalories_4_12_2016_5_12_2016
    WHERE ActivityMinute < '2016-05-12'
)
SELECT
    Id,
    ActivityMinute,
    Calories,
    CASE
        WHEN Calories < 0.67 OR Calories > 22
        THEN (ISNULL(PrevValue,NextValue) + ISNULL(NextValue,PrevValue))/2
        ELSE Calories 
    END AS 'CaloriesReplace'
FROM ReplaceCalories_4122016_5112016
WHERE WinMin < 0.67 OR WinMax > 22

-- 3.4 Replace Missing METs
WITH ReplaceMETs_3122016_4112016 AS (
    SELECT Id, ActivityMinute, METs,
        MIN(METs) OVER (PARTITION BY Id ORDER BY ActivityMinute ROWS BETWEEN 5 PRECEDING AND 5 FOLLOWING) AS 'WinMin',
        MAX(METs) OVER (PARTITION BY Id ORDER BY ActivityMinute ROWS BETWEEN 5 PRECEDING AND 5 FOLLOWING) AS 'WinMax',
        LAG(METs) OVER (PARTITION BY Id ORDER BY ActivityMinute) AS 'PrevValue',
        LEAD(METs) OVER (PARTITION BY Id ORDER BY ActivityMinute) AS 'NextValue'
    FROM minuteMETs_3_12_2016_4_11_2016
    WHERE ActivityMinute < '2016-04-12'
)
SELECT
    Id,
    ActivityMinute,
    METs,
    CASE
        WHEN METs < 9.5 OR METs > 230
        THEN (ISNULL(PrevValue,NextValue) + ISNULL(NextValue,PrevValue))/2
        ELSE METs
    END AS 'CaloriesReplace'
FROM ReplaceMETs_3122016_4112016
WHERE WinMin < 9.5 OR WinMax > 230

WITH ReplaceMETs_4122016_5112016 AS (
    SELECT Id, ActivityMinute, METs,
        MIN(METs) OVER (PARTITION BY Id ORDER BY ActivityMinute ROWS BETWEEN 5 PRECEDING AND 5 FOLLOWING) AS 'WinMin',
        MAX(METs) OVER (PARTITION BY Id ORDER BY ActivityMinute ROWS BETWEEN 5 PRECEDING AND 5 FOLLOWING) AS 'WinMax',
        LAG(METs) OVER (PARTITION BY Id ORDER BY ActivityMinute) AS 'PrevValue',
        LEAD(METs) OVER (PARTITION BY Id ORDER BY ActivityMinute) AS 'NextValue'
    FROM minuteMETs_4_12_2016_5_12_2016
    WHERE ActivityMinute < '2016-05-12'
)
SELECT
    Id,
    ActivityMinute,
    METs,
    CASE
        WHEN METs < 9.5 OR METs > 230
        THEN (ISNULL(PrevValue,NextValue) + ISNULL(NextValue,PrevValue))/2
        ELSE METs
    END AS 'CaloriesReplace'
FROM ReplaceMETs_4122016_5112016
WHERE WinMin < 9.5 OR WinMax > 230