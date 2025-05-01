SELECT
  bs.name AS station_name,
  COUNT(s.unique_key) AS nearby_crime_count
FROM
  `bigquery-public-data.san_francisco.bikeshare_stations` bs
JOIN
  `bigquery-public-data.san_francisco.sfpd_incidents` s
ON
  ABS(bs.latitude - s.latitude) < 0.01 AND ABS(bs.longitude - s.longitude) < 0.01
WHERE
  s.latitude IS NOT NULL AND s.longitude IS NOT NULL
GROUP BY
  station_name
ORDER BY
  nearby_crime_count DESC
LIMIT 5;
-- Finds the 5 bike stations that have the highest number of crimes
-- reported nearby, helping identify areas that may be unsafe for cyclists.