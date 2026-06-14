CREATE OR REPLACE TABLE taobao-customer-analytics.taobao_implementation.lookalike_audience_summary
AS
SELECT segment, COUNT(user_id) AS user_count
FROM taobao-customer-analytics.taobao_implementation.lookalike_audience
GROUP BY 1
ORDER BY 2 DESC;