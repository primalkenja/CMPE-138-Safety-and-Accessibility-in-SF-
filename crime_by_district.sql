SELECT
  police_district,
  EXTRACT(YEAR FROM date) AS year,
  COUNT(*) AS total_crimes,
  COUNTIF(resolution != 'NONE') AS resolved_crimes
FROM
  `bigquery-public-data.san_francisco.crime`
GROUP BY
  police_district, year
ORDER BY
  total_crimes DESC;
-- Shows how many crimes occurred in each police district per year,
-- including how many of them were resolved.
