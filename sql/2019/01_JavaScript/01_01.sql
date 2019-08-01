#standardSQL
# 01_01: Distribution of JS bytes
# TODO(rviscomi): Should this be a histogram?
SELECT
  APPROX_QUANTILES(ROUND(bytesJs / 1024, 2), 100) AS distribution_js_kbytes
FROM
  `httparchive.summary_pages.2019_07_01_*`