SELECT
    month(try_convert(date,service_date)),
    COUNT(DISTINCT CASE 
        WHEN OMNICHANNEL_TIER = 'A' AND field_tier = 'A'
        THEN customer_id 
    END) AS Tier_A_Count,
    COUNT(DISTINCT CASE 
        WHEN OMNICHANNEL_TIER = 'B' AND field_tier = 'B'
        THEN customer_id 
    END) AS Tier_B_Count
FROM Call_Reach_Data
GROUP BY month(try_convert(date,service_date)) order by month(try_convert(date,service_date));




SELECT
    month(try_convert(date,service_date)) as months,
    COUNT(DISTINCT CASE 
        WHEN final_channel='Digital' and field_tier='A' and OMNICHANNEL_TIER='A'
        THEN customer_id 
    END) AS Tier_A_Count,
    COUNT(DISTINCT CASE 
        WHEN final_channel = 'Digital' AND field_tier = 'B' AND OMNICHANNEL_TIER='B'
        THEN customer_id 
    END) AS Tier_B_Count
FROM Call_Reach_Data
GROUP BY month(try_convert(date,service_date))
ORDER BY month(try_convert(date,service_date));



SELECT
    month(try_convert(date,service_date)) as months,
    COUNT(DISTINCT CASE 
        WHEN (final_channel='field' or final_channel='SOS') and field_tier='A' and OMNICHANNEL_TIER='A'
        THEN customer_id 
    END) AS Tier_A_Count,
    COUNT(DISTINCT CASE 
        WHEN (final_channel = 'field' or final_channel='SOS') AND field_tier = 'B' AND OMNICHANNEL_TIER='B'
        THEN customer_id 
    END) AS Tier_B_Count
FROM Call_Reach_Data
GROUP BY month(try_convert(date,service_date))
ORDER BY month(try_convert(date,service_date));



WITH Reporting_Months AS
(
    SELECT DISTINCT
        half_year,
        [month]
    FROM Call_Reach_Data
    WHERE [month] BETWEEN 1 AND 12
      AND
      (
          (omnichannel_tier = 'A' AND field_tier = 'A')
          OR
          (omnichannel_tier = 'B' AND field_tier = 'B')
      )
),
 
Cumulative_Reach AS
(
    SELECT
        rm.half_year,
        rm.[month],
 
        COUNT(DISTINCT d.customer_id)
            AS Cumulative_Distinct_Customers,
 
        COUNT(*)
            AS Cumulative_Total_Calls
 
    FROM Reporting_Months rm
 
    INNER JOIN Call_Reach_Data d
        ON d.half_year = rm.half_year
        AND d.[month] <= rm.[month]
        AND
        (
            (d.omnichannel_tier = 'A' AND d.field_tier = 'A')
            OR
            (d.omnichannel_tier = 'B' AND d.field_tier = 'B')
        )
 
    GROUP BY
        rm.half_year,
        rm.[month]
)
 
SELECT
    half_year AS Omnichannel,
    [month] AS Reporting_Month,
    Cumulative_Distinct_Customers,
    Cumulative_Total_Calls,
 
    CAST(
        100.0 * Cumulative_Distinct_Customers
        / NULLIF(Cumulative_Total_Calls, 0)
        AS decimal(10, 2)
    ) AS Cumulative_Reach_Percentage
 
FROM Cumulative_Reach
 
ORDER BY
    TRY_CAST(RIGHT(half_year, 4) AS int),
    CASE
        WHEN half_year LIKE 'H1-%' THEN 1
        WHEN half_year LIKE 'H2-%' THEN 2
        ELSE 3
    END,
    try_convert(int,[month]);




WITH Reporting_Months AS
(
    SELECT DISTINCT
        half_year,
        [month]
    FROM Call_Reach_Data
    WHERE final_channel='Digital' and [month] BETWEEN 1 AND 12
      AND
      (
          (omnichannel_tier = 'A' AND field_tier = 'A')
          OR
          (omnichannel_tier = 'B' AND field_tier = 'B')
      )
),
 
Cumulative_Reach AS
(
    SELECT
        rm.half_year,
        rm.[month],
 
        COUNT(DISTINCT d.customer_id)
            AS Cumulative_Distinct_Customers,
 
        COUNT(*)
            AS Cumulative_Total_Calls
 
    FROM Reporting_Months rm
 
    INNER JOIN Call_Reach_Data d
        ON d.half_year = rm.half_year
        AND d.[month] <= rm.[month]
        and d.final_channel='Digital'
        AND
        (
            (d.omnichannel_tier = 'A' AND d.field_tier = 'A')
            OR
            (d.omnichannel_tier = 'B' AND d.field_tier = 'B')
        )
 
    GROUP BY
        rm.half_year,
        rm.[month]
)
 
SELECT
    half_year AS Digital,
    [month] AS Reporting_Month,
    Cumulative_Distinct_Customers,
    Cumulative_Total_Calls,
 
    CAST(
        100.0 * Cumulative_Distinct_Customers
        / NULLIF(Cumulative_Total_Calls, 0)
        AS decimal(10, 2)
    ) AS Cumulative_Reach_Percentage
 
FROM Cumulative_Reach
 
ORDER BY
    TRY_CAST(RIGHT(half_year, 4) AS int),
    CASE
        WHEN half_year LIKE 'H1-%' THEN 1
        WHEN half_year LIKE 'H2-%' THEN 2
        ELSE 3
    END,
    try_convert(int,[month]);




WITH Reporting_Months AS
(
    SELECT DISTINCT
        half_year,
        [month]
    FROM Call_Reach_Data
    WHERE (final_channel='field' or final_channel='sos') and [month] BETWEEN 1 AND 12
      AND
      (
          (omnichannel_tier = 'A' AND field_tier = 'A')
          OR
          (omnichannel_tier = 'B' AND field_tier = 'B')
      )
),
 
Cumulative_Reach AS
(
    SELECT
        rm.half_year,
        rm.[month],
 
        COUNT(DISTINCT d.customer_id)
            AS Cumulative_Distinct_Customers,
 
        COUNT(*)
            AS Cumulative_Total_Calls
 
    FROM Reporting_Months rm
 
    INNER JOIN Call_Reach_Data d
        ON d.half_year = rm.half_year
        AND d.[month] <= rm.[month]
        and (d.final_channel='Field' or d.final_channel='sos')
        AND
        (
            (d.omnichannel_tier = 'A' AND d.field_tier = 'A')
            OR
            (d.omnichannel_tier = 'B' AND d.field_tier = 'B')
        )
 
    GROUP BY
        rm.half_year,
        rm.[month]
)
 
SELECT
    half_year AS Salesforce,
    [month] AS Reporting_Month,
    Cumulative_Distinct_Customers,
    Cumulative_Total_Calls,
 
    CAST(
        100.0 * Cumulative_Distinct_Customers
        / NULLIF(Cumulative_Total_Calls, 0)
        AS decimal(10, 2)
    ) AS Cumulative_Reach_Percentage
 
FROM Cumulative_Reach
 
ORDER BY
    TRY_CAST(RIGHT(half_year, 4) AS int),
    CASE
        WHEN half_year LIKE 'H1-%' THEN 1
        WHEN half_year LIKE 'H2-%' THEN 2
        ELSE 3
    END,
    try_convert(int,[month]);



select half_year,
cast(count(case when (final_channel='Field' or final_channel='SOS') and OMNICHANNEL_TIER='A' and field_tier='A' THEN customer_id END)*1.0/count(distinct case when (final_channel='Field' or final_channel='SOS') and OMNICHANNEL_TIER='A' and field_tier='A' THEN customer_id END) as decimal(18,2)) as salesforce_frequency,
cast(count(case when final_channel='digital' and OMNICHANNEL_TIER='A' and field_tier='A' THEN customer_id END)*1.0/count(distinct case when final_channel='digital' and OMNICHANNEL_TIER='A' and field_tier='A' THEN customer_id END) as decimal(18,2)) as digital_frequency,
cast(count(case when OMNICHANNEL_TIER='A' and field_tier='A' THEN customer_id END)*1.0/count(distinct case when OMNICHANNEL_TIER='A' and field_tier='A' THEN customer_id END) as decimal(18,2)) as omnichannel_frequency
from Call_Reach_Data 
group by half_year order by half_year;

select half_year,
cast(count(case when (final_channel='Field' or final_channel='SOS') and OMNICHANNEL_TIER='B' and field_tier='B' THEN customer_id END)*1.0/count(distinct case when (final_channel='Field' or final_channel='SOS') and OMNICHANNEL_TIER='B' and field_tier='B' THEN customer_id END) as decimal(18,2)) as salesforce_frequency,
cast(count(case when final_channel='digital' and OMNICHANNEL_TIER='B' and field_tier='B' THEN customer_id END)*1.0/count(distinct case when final_channel='digital' and OMNICHANNEL_TIER='B' and field_tier='B' THEN customer_id END) as decimal(18,2)) as digital_frequency,
cast(count(case when OMNICHANNEL_TIER='B' and field_tier='B' THEN customer_id END)*1.0/count(distinct case when OMNICHANNEL_TIER='B' and field_tier='B' THEN customer_id END) as decimal(18,2)) as omnichannel_frequency
from Call_Reach_Data 
group by half_year order by half_year;

select half_year,
cast(count(case when (final_channel='Field' or final_channel='SOS') and ((OMNICHANNEL_TIER='A' and field_tier='A') or (OMNICHANNEL_TIER='B' and field_tier='B')) THEN customer_id END)*1.0/count(distinct case when (final_channel='Field' or final_channel='SOS') and ((OMNICHANNEL_TIER='A' and field_tier='A') or (OMNICHANNEL_TIER='B' and field_tier='B')) THEN customer_id END) as decimal(18,2)) as salesforce_frequency,
cast(count(case when final_channel='digital' and ((OMNICHANNEL_TIER='A' and field_tier='A') or (OMNICHANNEL_TIER='B' and field_tier='B')) THEN customer_id END)*1.0/count(distinct case when final_channel='digital' and ((OMNICHANNEL_TIER='A' and field_tier='A') or (OMNICHANNEL_TIER='B' and field_tier='B')) THEN customer_id END) as decimal(18,2)) as digital_frequency,
cast(count(case when (OMNICHANNEL_TIER='A' and field_tier='A') or (OMNICHANNEL_TIER='B' and field_tier='B') THEN customer_id END)*1.0/count(distinct case when (OMNICHANNEL_TIER='A' and field_tier='A') or (OMNICHANNEL_TIER='B' and field_tier='B') THEN customer_id END) as decimal(18,2)) as omnichannel_frequency
from Call_Reach_Data 
group by half_year order by half_year;




;WITH Clean_Data AS(
    SELECT
        customer_id,
        TRY_CONVERT(DATE, service_date) AS activity_date,
        UPPER(LTRIM(RTRIM(final_channel))) AS final_channel,
        UPPER(LTRIM(RTRIM(region))) AS region,
        UPPER(LTRIM(RTRIM(district))) AS district,
        UPPER(LTRIM(RTRIM(OMNICHANNEL_TIER))) AS OMNICHANNEL_TIER,
        UPPER(LTRIM(RTRIM(field_tier))) AS field_tier
    FROM Call_Reach_Data
    WHERE TRY_CONVERT(DATE, service_date) >= '2023-01-01'
      AND TRY_CONVERT(DATE, service_date) <  '2024-01-01'
      AND customer_id IS NOT NULL
),

Base_Data AS(
    SELECT
        customer_id,
        activity_date,
        final_channel,
        region,
        district,

        CASE
            WHEN OMNICHANNEL_TIER = 'A'
             AND field_tier = 'A'
                THEN 'A'

            WHEN OMNICHANNEL_TIER = 'B'
             AND field_tier = 'B'
                THEN 'B'
        END AS Tier_Group,

        DATEADD
        (
            DAY,
            -(DATEDIFF(DAY, '19000101', activity_date) % 7),
            activity_date
        ) AS Week_Start

    FROM Clean_Data

    WHERE
           (OMNICHANNEL_TIER = 'A' AND field_tier = 'A')
        OR (OMNICHANNEL_TIER = 'B' AND field_tier = 'B')
),

Geography_Data AS
(
    /* National */
    SELECT
        customer_id,
        activity_date,
        Week_Start,
        final_channel,
        Tier_Group,
        CAST('NATIONAL' AS VARCHAR(100)) AS Geography
    FROM Base_Data

    UNION ALL

    /* Regions */
    SELECT
        customer_id,
        activity_date,
        Week_Start,
        final_channel,
        Tier_Group,
        CAST(region AS VARCHAR(100)) AS Geography
    FROM Base_Data
    WHERE region IN ('EAST REGION', 'WEST REGION')

    UNION ALL

    /* Districts */
    SELECT
        customer_id,
        activity_date,
        Week_Start,
        final_channel,
        Tier_Group,
        CAST(district AS VARCHAR(100)) AS Geography
    FROM Base_Data
    WHERE district IN
    (
        'GREAT LAKES',
        'GULF COAST',
        'MID ATLANTIC',
        'NORTHEAST',
        'PACIFIC',
        'ROCKY MOUNTAIN',
        'SOUTHEAST',
        'SOUTHWEST'
    )
),

Channel_Data AS
(
    /* Salesforce: Field and SOS */
    SELECT
        customer_id,
        activity_date,
        Week_Start,
        Tier_Group,
        Geography,
        CAST('Salesforce' AS VARCHAR(50)) AS Metric
    FROM Geography_Data
    WHERE final_channel IN ('FIELD', 'SOS')

    UNION ALL

    /* Digital */
    SELECT
        customer_id,
        activity_date,
        Week_Start,
        Tier_Group,
        Geography,
        CAST('Digital' AS VARCHAR(50)) AS Metric
    FROM Geography_Data
    WHERE final_channel = 'DIGITAL'

    UNION ALL

    /* Omnichannel */
    SELECT
        customer_id,
        activity_date,
        Week_Start,
        Tier_Group,
        Geography,
        CAST('Omnichannel' AS VARCHAR(50)) AS Metric
    FROM Geography_Data
    WHERE final_channel IN ('FIELD', 'SOS', 'DIGITAL')
),

Daily_Reach AS
(
    SELECT
        Week_Start,
        activity_date,
        Tier_Group,
        Metric,
        Geography,
        COUNT(DISTINCT customer_id) AS Daily_Distinct_HCPs
    FROM Channel_Data
    GROUP BY
        Week_Start,
        activity_date,
        Tier_Group,
        Metric,
        Geography
),

Weekly_Daily_Sum AS
(
    SELECT
        Week_Start,
        Tier_Group,
        Metric,
        Geography,
        SUM(Daily_Distinct_HCPs) AS Sum_Of_Daily_Distinct_HCPs
    FROM Daily_Reach
    GROUP BY
        Week_Start,
        Tier_Group,
        Metric,
        Geography
),

Weekly_Distinct AS
(
    SELECT
        Week_Start,
        Tier_Group,
        Metric,
        Geography,
        COUNT(DISTINCT customer_id) AS Weekly_Distinct_HCPs
    FROM Channel_Data
    GROUP BY
        Week_Start,
        Tier_Group,
        Metric,
        Geography
),

Weekly_Reach AS
(
    SELECT
        wd.Week_Start,
        wd.Tier_Group,
        wd.Metric,
        wd.Geography,

        CAST
        (
            100.0 * wd.Weekly_Distinct_HCPs
            / NULLIF(wds.Sum_Of_Daily_Distinct_HCPs, 0)
            AS DECIMAL(18,4)
        ) AS Weekly_Reach_Percentage

    FROM Weekly_Distinct AS wd

    INNER JOIN Weekly_Daily_Sum AS wds
        ON wd.Week_Start = wds.Week_Start
       AND wd.Tier_Group = wds.Tier_Group
       AND wd.Metric = wds.Metric
       AND wd.Geography = wds.Geography
),

Average_Weekly_Reach AS
(
    SELECT
        Tier_Group,
        Metric,
        Geography,
        AVG(Weekly_Reach_Percentage) AS Average_Weekly_Reach
    FROM Weekly_Reach
    GROUP BY
        Tier_Group,
        Metric,
        Geography
)

SELECT
    Tier_Group AS [Tier],
    Metric AS [Metric],

    CAST(MAX(CASE
        WHEN Geography = 'NATIONAL'
        THEN Average_Weekly_Reach
    END) AS DECIMAL(18,2)) AS [National],

    CAST(MAX(CASE
        WHEN Geography = 'EAST REGION'
        THEN Average_Weekly_Reach
    END) AS DECIMAL(18,2)) AS [East],

    CAST(MAX(CASE
        WHEN Geography = 'NORTHEAST'
        THEN Average_Weekly_Reach
    END) AS DECIMAL(18,2)) AS [North East],

    CAST(MAX(CASE
        WHEN Geography = 'MID ATLANTIC'
        THEN Average_Weekly_Reach
    END) AS DECIMAL(18,2)) AS [Mid-Atlantic],

    CAST(MAX(CASE
        WHEN Geography = 'GREAT LAKES'
        THEN Average_Weekly_Reach
    END) AS DECIMAL(18,2)) AS [Great Lakes],

    CAST(MAX(CASE
        WHEN Geography = 'SOUTHEAST'
        THEN Average_Weekly_Reach
    END) AS DECIMAL(18,2)) AS [South East],

    CAST(MAX(CASE
        WHEN Geography = 'WEST REGION'
        THEN Average_Weekly_Reach
    END) AS DECIMAL(18,2)) AS [West],

    CAST(MAX(CASE
        WHEN Geography = 'GULF COAST'
        THEN Average_Weekly_Reach
    END) AS DECIMAL(18,2)) AS [Gulf Coast],

    CAST(MAX(CASE
        WHEN Geography = 'ROCKY MOUNTAIN'
        THEN Average_Weekly_Reach
    END) AS DECIMAL(18,2)) AS [Rocky Mountain],

    CAST(MAX(CASE
        WHEN Geography = 'SOUTHWEST'
        THEN Average_Weekly_Reach
    END) AS DECIMAL(18,2)) AS [South West],

    CAST(MAX(CASE
        WHEN Geography = 'PACIFIC'
        THEN Average_Weekly_Reach
    END) AS DECIMAL(18,2)) AS [Pacific]

FROM Average_Weekly_Reach

GROUP BY
    Tier_Group,
    Metric

ORDER BY
    CASE Tier_Group
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
    END,

    CASE Metric
        WHEN 'Salesforce' THEN 1
        WHEN 'Digital' THEN 2
        WHEN 'Omnichannel' THEN 3
    END;