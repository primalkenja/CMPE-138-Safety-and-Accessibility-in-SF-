SELECT
  pddistrict AS district,
  EXTRACT(YEAR FROM timestamp) AS year,
  COUNT(*) AS total_crimes,
  COUNTIF(resolution IS NOT NULL AND resolution != 'NONE') AS resolved_crimes
FROM
  `bigquery-public-data.san_francisco.sfpd_incidents`
WHERE
  timestamp IS NOT NULL AND pddistrict IS NOT NULL
GROUP BY
  district, year
ORDER BY
  total_crimes DESC;

-- Shows how many crimes occurred in each police district per year,
-- including how many of them were resolved.
