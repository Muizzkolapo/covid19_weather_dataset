{{ config(materialized='view') }}
  --- getting the average weather conditions for each country we are doing this because running the average on the original table
  ---consumes more resources than breaking it down like this
  with covid19_avg_weather AS (
  SELECT
    AVG(avg_temperature_air_2m_f) AS avg_temp_percountry,
    AVG(avg_humidity_relative_2m_pct) AS avg_humd_percountry,
    AVG(avg_humidity_specific_2m_gpkg) AS avg_spec_humd_percountry,
    country,
    date
  FROM
    `project-kphash.covid19_weather.covid_weather`
  GROUP BY
    country,
    date
  ORDER BY
    country ASC ),
  ------creating a table combining weather and covid case for a specific date
  covid19_infected_avgweather AS(
  SELECT
    a.date AS date,
    daily_confirmed_cases,
    confirmed_cases,
    countries_and_territories,
    geo_id,
    country,
    b.avg_temp_percountry AS avg_temp_percountry,
    b.avg_humd_percountry AS avg_humd_percountry,
    b.avg_spec_humd_percountry AS avg_spec_humd_percountry
  FROM
    `project-kphash.covid19_weather.covid_cases` AS a
  LEFT JOIN
    covid19_avg_weather AS b
  ON
    a.geo_id = b.country
    AND a.date = b.date ),
  ------------------- creating dataset with the logic considering infected and testing times
  covid19_date_dump AS (
  SELECT
    DISTINCT date AS date_case_confirmed,
  FROM
    covid19_infected_avgweather ),
  ------------------------Performing the calculation to get the assumed infected date
  covid19_assumed_infected_date_dump AS (
  SELECT
    date_case_confirmed,
    DATE_SUB(date_case_confirmed, INTERVAL 15 DAY) AS assumed_infected_date
  FROM
    covid19_date_dump),
  ----- Getting the final table that shows the cases and assumed infected day(date case was confirmed - 15 days)
  final_covid_table AS (
  SELECT
    date_case_confirmed,
    assumed_infected_date,
    avg_temp_percountry,
    avg_humd_percountry,
    avg_spec_humd_percountry,
    countries_and_territories,
    country
  FROM
    covid19_infected_avgweather AS a
  LEFT JOIN
    covid19_assumed_infected_date_dump AS b
  ON
    a.date = b.assumed_infected_date)
SELECT
  *
FROM
  final_covid_table
