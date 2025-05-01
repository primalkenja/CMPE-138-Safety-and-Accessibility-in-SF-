
WITH crimes_by_zip AS (
  SELECT
    incident_id,
    incident_category,
    incident_subcategory,
    date,
    EXTRACT(YEAR FROM date) AS year,
    CASE
      WHEN latitude IS NOT NULL AND longitude IS NOT NULL THEN
        ST_GEOGPOINT(longitude, latitude)
    END AS location
  FROM `bigquery-public-data.san_francisco.crime`
),
bike_stations_with_zip AS (
  SELECT
    station_id,
    name,
    latitude,
    longitude,
    zip_code,
    ST_GEOGPOINT(longitude, latitude) AS station_location
  FROM `bigquery-public-data.san_francisco.bike_share_stations`
),
bike_counts AS (
  SELECT
    start_station_id AS station_id,
    COUNT(*) AS trip_count
  FROM `bigquery-public-data.san_francisco.bike_share_trips`
  GROUP BY start_station_id
)
SELECT
  bs.zip_code,
  COUNT(c.incident_id) AS total_crimes,
  SUM(bc.trip_count) AS total_bike_trips
FROM
  crimes_by_zip c
JOIN
  bike_stations_with_zip bs
ON
  ST_DWITHIN(c.location, bs.station_location, 1000) -- within 1km
JOIN
  bike_counts bc
ON
  bs.station_id = bc.station_id
GROUP BY
  bs.zip_code
ORDER BY
  total_crimes DESC;

-- Compares crime counts and bike trip activity by ZIP code,
-- helping identify if areas with more bike usage also see more crime.
