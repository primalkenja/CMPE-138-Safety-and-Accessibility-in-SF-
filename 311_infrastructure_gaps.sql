-- Highlights the most frequently reported public service and infrastructure issues
-- by neighborhood and complaint type, using 311 service request data.

SELECT
  neighborhood,
  complaint_type,
  COUNT(*) AS request_count
FROM
  `bigquery-public-data.san_francisco.311_service_requests`
WHERE
  neighborhood IS NOT NULL
  AND TRIM(neighborhood) != ''
  AND complaint_type IS NOT NULL
  AND TRIM(complaint_type) != ''
GROUP BY
  neighborhood, complaint_type
ORDER BY
  request_count DESC
LIMIT 50;
