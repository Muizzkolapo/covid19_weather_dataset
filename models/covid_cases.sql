{{ config(materialized='table') }}
--- getting the total number of confirmed cases and daily cases for each country create a table on BQ
 SELECT
   date,
   daily_confirmed_cases,
   confirmed_cases,
   countries_and_territories,
   geo_id
 FROM
   `bigquery-public-data.covid19_ecdc.covid_19_geographic_distribution_worldwide`
 WHERE
   date BETWEEN '2020-03-01'
   AND '2020-05-30'
