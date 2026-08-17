-- Databricks notebook source
-- ============================================================
-- BRIGHT TV: USER PROFILE DATA CLEANING & PREPARATION
-- ============================================================


-- 1. INSPECT THE USER PROFILE TABLE
SELECT *
FROM bright_tv_data.bright_dataset.userprofiles;


-- ============================================================
-- 2. CHECK NUMBER OF UNIQUE SUBSCRIBERS
-- ============================================================

SELECT
    COUNT(DISTINCT UserID) AS Subscribers
FROM bright_tv_data.bright_dataset.userprofiles;


-- ============================================================
-- 3. CHECK FOR DUPLICATE USER PROFILES
-- ============================================================

SELECT
    UserID,
    COUNT(*) AS Duplicate_Count
FROM bright_tv_data.bright_dataset.userprofiles
GROUP BY UserID
HAVING COUNT(*) > 1;


-- ============================================================
-- 4. INSPECT THE GENDER COLUMN
-- ============================================================

SELECT DISTINCT Gender
FROM bright_tv_data.bright_dataset.userprofiles;


-- ============================================================
-- 5. STANDARDIZE GENDER
-- ============================================================

SELECT DISTINCT
    CASE
        WHEN Gender IS NULL THEN 'Unknown'
        WHEN TRIM(Gender) = '' THEN 'Unknown'
        WHEN LOWER(TRIM(Gender)) = 'none' THEN 'Unknown'
        ELSE TRIM(Gender)
    END AS Sex
FROM bright_tv_data.bright_dataset.userprofiles;


-- ============================================================
-- 6. INSPECT THE RACE COLUMN
-- ============================================================

SELECT DISTINCT Race
FROM bright_tv_data.bright_dataset.userprofiles;


-- ============================================================
-- 7. STANDARDIZE RACE
-- ============================================================

SELECT DISTINCT
    CASE
        WHEN Race IS NULL THEN 'Unknown'
        WHEN TRIM(Race) = '' THEN 'Unknown'
        WHEN LOWER(TRIM(Race)) IN ('none', 'other') THEN 'Unknown'
        ELSE TRIM(Race)
    END AS Ethnicity
FROM bright_tv_data.bright_dataset.userprofiles;


-- ============================================================
-- 8. COUNT SUBSCRIBERS BY ETHNICITY
-- ============================================================

SELECT
    COUNT(DISTINCT UserID) AS Subscribers,

    CASE
        WHEN Race IS NULL THEN 'Unknown'
        WHEN TRIM(Race) = '' THEN 'Unknown'
        WHEN LOWER(TRIM(Race)) IN ('none', 'other') THEN 'Unknown'
        ELSE TRIM(Race)
    END AS Ethnicity

FROM bright_tv_data.bright_dataset.userprofiles

GROUP BY
    CASE
        WHEN Race IS NULL THEN 'Unknown'
        WHEN TRIM(Race) = '' THEN 'Unknown'
        WHEN LOWER(TRIM(Race)) IN ('none', 'other') THEN 'Unknown'
        ELSE TRIM(Race)
    END

ORDER BY Subscribers DESC;


-- ============================================================
-- 9. INSPECT THE PROVINCE COLUMN
-- ============================================================

SELECT DISTINCT Province
FROM bright_tv_data.bright_dataset.userprofiles;


-- ============================================================
-- 10. STANDARDIZE PROVINCE
-- ============================================================

SELECT DISTINCT
    CASE
        WHEN Province IS NULL THEN 'Unclassified'
        WHEN TRIM(Province) = '' THEN 'Unclassified'
        WHEN LOWER(TRIM(Province)) IN ('none', 'other') THEN 'Unclassified'
        ELSE TRIM(Province)
    END AS Region

FROM bright_tv_data.bright_dataset.userprofiles;


-- ============================================================
-- 11. CHECK AGE STATISTICS
-- ============================================================

SELECT
    MIN(Age) AS Minimum_Age,
    MAX(Age) AS Maximum_Age,
    AVG(Age) AS Average_Age

FROM bright_tv_data.bright_dataset.userprofiles;


-- ============================================================
-- 12. CREATE AGE GROUPS
-- ============================================================

SELECT DISTINCT
    CASE
        WHEN Age = 0 THEN 'Infant'
        WHEN Age BETWEEN 1 AND 12 THEN 'Kids'
        WHEN Age BETWEEN 13 AND 17 THEN 'Youth'
        WHEN Age BETWEEN 18 AND 35 THEN 'Young Adults'
        WHEN Age BETWEEN 36 AND 50 THEN 'Adults'
        WHEN Age BETWEEN 51 AND 60 THEN 'Elder'
        WHEN Age > 60 THEN 'Pensioner'
        ELSE 'Unknown'
    END AS Age_Group

FROM bright_tv_data.bright_dataset.userprofiles;


-- ============================================================
-- 13. CREATE REFINED USER PROFILE TABLE
-- ============================================================

CREATE OR REPLACE TEMPORARY TABLE refined_userprofiles AS

SELECT

    UserID,
    Email,

    -- Email flag
    CASE
        WHEN Email IS NOT NULL
             AND TRIM(Email) <> ''
        THEN 1
        ELSE 0
    END AS Email_Flag,

    -- Social Media Handle flag
    CASE
        WHEN `Social Media Handle` IS NOT NULL
             AND TRIM(`Social Media Handle`) <> ''
        THEN 1
        ELSE 0
    END AS Social_Media_Handle_Flag,

    -- Gender classification
    CASE
        WHEN Gender IS NULL THEN 'Unknown'
        WHEN TRIM(Gender) = '' THEN 'Unknown'
        WHEN LOWER(TRIM(Gender)) = 'none' THEN 'Unknown'
        ELSE TRIM(Gender)
    END AS Sex,

    -- Race classification
    CASE
        WHEN Race IS NULL THEN 'Unknown'
        WHEN TRIM(Race) = '' THEN 'Unknown'
        WHEN LOWER(TRIM(Race)) IN ('none', 'other') THEN 'Unknown'
        ELSE TRIM(Race)
    END AS Ethnicity,

    -- Province classification
    CASE
        WHEN Province IS NULL THEN 'Unclassified'
        WHEN TRIM(Province) = '' THEN 'Unclassified'
        WHEN LOWER(TRIM(Province)) IN ('none', 'other') THEN 'Unclassified'
        ELSE TRIM(Province)
    END AS Region,

    -- Age classification
    CASE
        WHEN Age = 0 THEN 'Infant'
        WHEN Age BETWEEN 1 AND 12 THEN 'Kids'
        WHEN Age BETWEEN 13 AND 17 THEN 'Youth'
        WHEN Age BETWEEN 18 AND 35 THEN 'Young Adults'
        WHEN Age BETWEEN 36 AND 50 THEN 'Adults'
        WHEN Age BETWEEN 51 AND 60 THEN 'Elder'
        WHEN Age > 60 THEN 'Pensioner'
        ELSE 'Unknown'
    END AS Age_Group

FROM bright_tv_data.bright_dataset.userprofiles;


-- ============================================================
-- 14. INSPECT THE REFINED TABLE
-- ============================================================

SELECT *
FROM refined_userprofiles;



-- ============================================================
-- BRIGHT TV: VIEWERSHIP DATA CLEANING & PREPARATION
-- ============================================================


-- 1. INSPECT THE VIEWERSHIP TABLE
SELECT *
FROM bright_tv_data.bright_dataset.viewership;


-- ============================================================
-- 2. CHECK THE NUMBER OF VIEWING RECORDS
-- ============================================================

SELECT
    COUNT(*) AS Total_Viewing_Records
FROM bright_tv_data.bright_dataset.viewership;


-- ============================================================
-- 3. CHECK UNIQUE VIEWERS
-- ============================================================

SELECT
    COUNT(DISTINCT UserID0) AS Unique_Viewers
FROM bright_tv_data.bright_dataset.viewership
WHERE UserID0 IS NOT NULL;


-- ============================================================
-- 4. CHECK FOR MISSING USER IDs
-- ============================================================

SELECT
    COUNT(*) AS Missing_User_IDs
FROM bright_tv_data.bright_dataset.viewership
WHERE UserID0 IS NULL;


-- ============================================================
-- 5. INSPECT THE RECORD DATE
-- ============================================================

SELECT
    RecordDate2,
    TO_DATE(RecordDate2) AS Watch_Date
FROM bright_tv_data.bright_dataset.viewership
LIMIT 10;


-- ============================================================
-- 6. EXTRACT DATE INFORMATION
-- ============================================================

SELECT
    UserID0,
    RecordDate2,

    TO_DATE(RecordDate2) AS Watch_Date,

    DAYNAME(TO_DATE(RecordDate2)) AS Day_Name,

    MONTHNAME(TO_DATE(RecordDate2)) AS Month_Name,

    YEAR(TO_DATE(RecordDate2)) AS Event_Year,

    DAY(TO_DATE(RecordDate2)) AS Event_Day

FROM bright_tv_data.bright_dataset.viewership;


-- ============================================================
-- 7. CONVERT UTC TIME TO SOUTH AFRICAN TIME
-- ============================================================

SELECT
    RecordDate2,

    FROM_UTC_TIMESTAMP(
        RecordDate2,
        'Africa/Johannesburg'
    ) AS RecordDate_SAST

FROM bright_tv_data.bright_dataset.viewership;


-- ============================================================
-- 8. CREATE REFINED VIEWERSHIP TABLE
-- ============================================================

CREATE OR REPLACE TEMPORARY TABLE refined_viewership AS

SELECT

    -- User ID
    UserID0 AS UserID,

    -- Convert UTC timestamp to South African time
    FROM_UTC_TIMESTAMP(
        RecordDate2,
        'Africa/Johannesburg'
    ) AS RecordDate_SAST,

    -- Date
    TO_DATE(
        FROM_UTC_TIMESTAMP(
            RecordDate2,
            'Africa/Johannesburg'
        )
    ) AS Watch_Date,

    -- Day
    DAYNAME(
        TO_DATE(
            FROM_UTC_TIMESTAMP(
                RecordDate2,
                'Africa/Johannesburg'
            )
        )
    ) AS Day_Name,

    -- Month
    MONTHNAME(
        TO_DATE(
            FROM_UTC_TIMESTAMP(
                RecordDate2,
                'Africa/Johannesburg'
            )
        )
    ) AS Month_Name,

    -- Year
    YEAR(
        TO_DATE(
            FROM_UTC_TIMESTAMP(
                RecordDate2,
                'Africa/Johannesburg'
            )
        )
    ) AS Event_Year,

    -- Day number
    DAY(
        TO_DATE(
            FROM_UTC_TIMESTAMP(
                RecordDate2,
                'Africa/Johannesburg'
            )
        )
    ) AS Event_Day,

    -- Hour of the day
    HOUR(
        FROM_UTC_TIMESTAMP(
            RecordDate2,
            'Africa/Johannesburg'
        )
    ) AS Hour_Of_Day,

    -- Weekday / Weekend classification
    CASE
        WHEN DAYNAME(
            TO_DATE(
                FROM_UTC_TIMESTAMP(
                    RecordDate2,
                    'Africa/Johannesburg'
                )
            )
        ) IN ('Sat', 'Sun')
        THEN '02. Weekend'

        ELSE '01. Weekday'
    END AS Day_Classification,

    -- Watch time
    DATE_FORMAT(
        FROM_UTC_TIMESTAMP(
            RecordDate2,
            'Africa/Johannesburg'
        ),
        'HH:mm:ss'
    ) AS Watch_Time,

    -- Time of day
    CASE

        WHEN HOUR(
            FROM_UTC_TIMESTAMP(
                RecordDate2,
                'Africa/Johannesburg'
            )
        ) BETWEEN 0 AND 5
        THEN '01. Midnight'

        WHEN HOUR(
            FROM_UTC_TIMESTAMP(
                RecordDate2,
                'Africa/Johannesburg'
            )
        ) BETWEEN 6 AND 11
        THEN '02. Morning'

        WHEN HOUR(
            FROM_UTC_TIMESTAMP(
                RecordDate2,
                'Africa/Johannesburg'
            )
        ) BETWEEN 12 AND 16
        THEN '03. Afternoon'

        WHEN HOUR(
            FROM_UTC_TIMESTAMP(
                RecordDate2,
                'Africa/Johannesburg'
            )
        ) BETWEEN 17 AND 23
        THEN '04. Evening'

    END AS Time_Of_Day,

    -- Channel
    CASE

        WHEN Channel2 IN ('SawSee', 'Sawsee')
        THEN 'SawSee'

        WHEN Channel2 IN (
            'SuperSport Live Events',
            'Live on SuperSport',
            'Supersport Live Events',
            'DStv Events 1'
        )
        THEN 'Live Events'

        ELSE Channel2

    END AS TV_Channel,

    -- Original duration
    `Duration 2` AS Original_Duration,

    -- Duration formatted as time
    DATE_FORMAT(
        TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss'),
        'HH:mm:ss'
    ) AS Duration,

    -- Duration in hours
    (
        HOUR(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss'))
        +
        MINUTE(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss')) / 60.0
        +
        SECOND(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss')) / 3600.0
    ) AS Duration_Hours,

    -- Duration in seconds
    (
        HOUR(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss')) * 3600
        +
        MINUTE(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss')) * 60
        +
        SECOND(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss'))
    ) AS Duration_Seconds,

    -- Screen time classification
    CASE

        WHEN (
            HOUR(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss')) * 3600
            +
            MINUTE(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss')) * 60
            +
            SECOND(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss'))
        ) BETWEEN 300 AND 1800
        THEN '01. Low Usage (<30 min)'

        WHEN (
            HOUR(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss')) * 3600
            +
            MINUTE(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss')) * 60
            +
            SECOND(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss'))
        ) BETWEEN 1801 AND 3599
        THEN '02. Medium Usage (<60 min)'

        WHEN (
            HOUR(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss')) * 3600
            +
            MINUTE(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss')) * 60
            +
            SECOND(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss'))
        ) >= 3600
        THEN '03. High Usage (>60 min)'

        ELSE '04. No Usage'

    END AS Screen_Time_Bucket

FROM bright_tv_data.bright_dataset.viewership

WHERE UserID0 IS NOT NULL;


-- ============================================================
-- BRIGHT TV: CTE (USERPROFILE & VIEWERSHIP)
-- ============================================================

WITH user_profiles AS (

    SELECT
        UserID,

        -- Creating gender classification
        CASE
            WHEN Gender = 'None' THEN 'Unknown'
            WHEN TRIM(Gender) = '' THEN 'Unknown'
            WHEN Gender IS NULL THEN 'Unknown'
            ELSE Gender
        END AS Sex,

        -- Classifying race
        CASE
            WHEN Race = 'None' THEN 'Unknown'
            WHEN TRIM(Race) = '' THEN 'Unknown'
            WHEN LOWER(Race) = 'other' THEN 'Unknown'
            WHEN Race IS NULL THEN 'Unknown'
            ELSE Race
        END AS Ethnicity,

        -- Classifying age
        CASE
            WHEN Age = 0 THEN 'Infant'
            WHEN Age BETWEEN 1 AND 12 THEN 'Kids'
            WHEN Age BETWEEN 13 AND 17 THEN 'Youth'
            WHEN Age BETWEEN 18 AND 35 THEN 'Young Adults'
            WHEN Age BETWEEN 36 AND 50 THEN 'Adults'
            WHEN Age BETWEEN 51 AND 60 THEN 'Elder'
            WHEN Age > 60 THEN 'Pensioner'
            ELSE 'Unknown'
        END AS Age_Group,

        -- Classifying province
        CASE
            WHEN Province = 'None' THEN 'Unclassified'
            WHEN TRIM(Province) = '' THEN 'Unclassified'
            WHEN LOWER(Province) = 'other' THEN 'Unclassified'
            WHEN Province IS NULL THEN 'Unclassified'
            ELSE Province
        END AS Region,

        -- Email flag
        CASE
            WHEN Email IS NOT NULL
                 AND TRIM(Email) <> ''
            THEN 1
            ELSE 0
        END AS Email_Flag,

        -- Social media handle flag
        CASE
            WHEN `Social Media Handle` IS NOT NULL
                 AND TRIM(`Social Media Handle`) <> ''
            THEN 1
            ELSE 0
        END AS Social_Media_Handle_Flag

    FROM bright_tv_data.bright_dataset.userprofiles
),

Base_viewership AS (

    SELECT
        COALESCE(UserID0, userid4) AS User_ID,

        -- Convert UTC timestamp to South African time
        FROM_UTC_TIMESTAMP(
            RecordDate2,
            'Africa/Johannesburg'
        ) AS RecordDate_SAST,

        Channel2,
        `Duration 2`

    FROM bright_tv_data.bright_dataset.viewership
),

Viewership_Dates AS (

    SELECT
        User_ID,
        RecordDate_SAST,

        TO_DATE(RecordDate_SAST) AS Watch_Date,

        DAYNAME(TO_DATE(RecordDate_SAST)) AS Day_Name,

        MONTHNAME(TO_DATE(RecordDate_SAST)) AS Month_Name,

        YEAR(TO_DATE(RecordDate_SAST)) AS Event_Year,

        DAY(TO_DATE(RecordDate_SAST)) AS Event_Day,

        HOUR(RecordDate_SAST) AS Hour_of_Day,

        CASE
            WHEN DAYNAME(TO_DATE(RecordDate_SAST))
                 IN ('Sat', 'Sun')
            THEN '02. Weekend'
            ELSE '01. Weekday'
        END AS Day_Classification,

        DATE_FORMAT(
            RecordDate_SAST,
            'HH:mm:ss'
        ) AS Watch_Time,

        `Duration 2`,

        DATE_FORMAT(
            `Duration 2`,
            'HH:mm:ss'
        ) AS Duration,

        Channel2

    FROM Base_viewership
),

Viewership_Cleaned AS (

    SELECT
        User_ID,
        RecordDate_SAST,
        Watch_Date,
        Day_Name,
        Month_Name,
        Event_Year,
        Event_Day,
        Hour_of_Day,
        Day_Classification,
        Watch_Time,

        -- Classify time of day
        CASE
            WHEN Watch_Time BETWEEN '00:00:00' AND '05:59:59'
                THEN '01. Midnight'

            WHEN Watch_Time BETWEEN '06:00:00' AND '11:59:59'
                THEN '02. Morning'

            WHEN Watch_Time BETWEEN '12:00:00' AND '16:59:59'
                THEN '03. Afternoon'

            WHEN Watch_Time BETWEEN '17:00:00' AND '23:59:59'
                THEN '04. Evening'

            ELSE 'Unknown'
        END AS Time_of_Day,

        Duration,

        -- Convert duration to hours
        (
            HOUR(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss'))
            +
            MINUTE(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss')) / 60.0
            +
            SECOND(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss')) / 3600.0
        ) AS Duration_Hours,

        -- Convert duration to seconds
        (
            HOUR(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss')) * 3600
            +
            MINUTE(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss')) * 60
            +
            SECOND(TO_TIMESTAMP(`Duration 2`, 'HH:mm:ss'))
        ) AS Duration_Seconds,

        -- Clean channel names
        CASE
            WHEN Channel2 IN ('SawSee', 'Sawsee')
                THEN 'SawSee'

            WHEN Channel2 IN (
                'SuperSport Live Events',
                'Live on SuperSport',
                'Supersport Live Events',
                'DStv Events 1'
            )
                THEN 'Live Events'

            ELSE Channel2
        END AS TV_Channel

    FROM Viewership_Dates
),

Final_Data AS (

    SELECT
        A.User_ID AS Sub_ID,

        B.Sex,
        B.Ethnicity,
        B.Age_Group,
        B.Region,
        B.Email_Flag,
        B.Social_Media_Handle_Flag,

        A.RecordDate_SAST,
        A.Watch_Date,
        A.Day_Name,
        A.Month_Name,
        A.Event_Year,
        A.Event_Day,
        A.Hour_of_Day,
        A.Day_Classification,
        A.Watch_Time,
        A.Time_of_Day,

        A.Duration,
        A.Duration_Hours,
        A.Duration_Seconds,

        -- Screen time classification
        CASE
            WHEN A.Duration_Seconds BETWEEN 300 AND 1800
                THEN '01. Low Usage (<30 min)'

            WHEN A.Duration_Seconds BETWEEN 1801 AND 3599
                THEN '02. Medium Usage (<60 min)'

            WHEN A.Duration_Seconds >= 3600
                THEN '03. High Usage (>60 min)'

            ELSE '04. No Usage'
        END AS Screen_Time_Bucket,

        A.TV_Channel

    FROM Viewership_Cleaned AS A

    LEFT JOIN user_profiles AS B
        ON A.User_ID = B.UserID
)

SELECT *
FROM Final_Data;


