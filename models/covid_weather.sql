{{ config(materialized='table') }}
-- getting the weather conditions for each postal code create a table on BQ
SELECT
  postal_code,
  country,
  date,
  avg_temperature_air_2m_f,
  avg_humidity_relative_2m_pct,
  avg_humidity_specific_2m_gpkg
FROM
  `bigquery-public-data.covid19_weathersource_com.postal_code_day_history`
WHERE
  date BETWEEN '2020-03-01'
  AND '2020-05-30'
