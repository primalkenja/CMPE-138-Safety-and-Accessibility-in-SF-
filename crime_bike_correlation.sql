WITH sfpd_incidents AS (
  SELECT
    unique_key,
    category,
    descript,
    timestamp,
    latitude,
    longitude,
    ST_GEOGPOINT(longitude, latitude) AS crime_location
  FROM
    `bigquery-public-data.san_francisco.sfpd_incidents`
  WHERE
    latitude IS NOT NULL AND longitude IS NOT NULL
),

bike_stations AS (
  SELECT
    station_id,
    name,
    latitude,
    longitude,
    ST_GEOGPOINT(longitude, latitude) AS station_location
  FROM
    `bigquery-public-data.san_francisco.bikeshare_stations`
),

trip_counts AS (
  SELECT
    start_station_id AS station_id,
    COUNT(*) AS trip_count
  FROM
    `bigquery-public-data.san_francisco.bikeshare_trips`
  GROUP BY start_station_id
)

SELECT
  bs.name AS station_name,
  COUNT(s.unique_key) AS nearby_crime_count,
  tc.trip_count
FROM
  bike_stations bs
LEFT JOIN
  sfpd_incidents s
ON
  ST_DWITHIN(bs.station_location, s.crime_location, 500) -- 500 meters radius
LEFT JOIN
  trip_counts tc
ON
  bs.station_id = tc.station_id
GROUP BY
  station_name, trip_count
ORDER BY
  nearby_crime_count DESC;


-- Compares crime counts and bike trip activity by ZIP code,
-- helping identify if areas with more bike usage also see more crime.
