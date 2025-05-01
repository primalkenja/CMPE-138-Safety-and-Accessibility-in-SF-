-- Calculates the average time it takes for the fire department
-- to respond to calls in each neighborhood by year.
SELECT
  zipcode_of_incident AS zipcode,
  EXTRACT(YEAR FROM received_timestamp) AS year,
  AVG(TIMESTAMP_DIFF(on_scene_timestamp, dispatch_timestamp, SECOND)) AS avg_response_seconds
FROM
  `bigquery-public-data.san_francisco.sffd_service_calls`
WHERE
  dispatch_timestamp IS NOT NULL
  AND on_scene_timestamp IS NOT NULL
  AND zipcode_of_incident IS NOT NULL
  AND TRIM(zipcode_of_incident) != ''
GROUP BY
  zipcode, year
ORDER BY
  avg_response_seconds ASC;
