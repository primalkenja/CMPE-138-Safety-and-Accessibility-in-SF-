SELECT
  station_id,
  COUNTIF(bikes_available <= 2) AS low_availability_events,
  COUNT(*) AS total_snapshots,
  ROUND(COUNTIF(bikes_available <= 2) * 100.0 / COUNT(*), 2) AS percent_low_availability
FROM
  `bigquery-public-data.san_francisco.bikeshare_status`
WHERE
  bikes_available IS NOT NULL
GROUP BY
  station_id
ORDER BY
  percent_low_availability DESC
LIMIT 10;
-- Identifies the top 10 bike stations with the highest percentage of low availability
-- (defined as having 2 or fewer bikes available during status updates).
