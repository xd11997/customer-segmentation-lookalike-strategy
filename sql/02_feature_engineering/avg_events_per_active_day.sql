CREATE OR REPLACE TABLE taobao-customer-analytics.taobao_features.avg_events_per_active_day
AS
WITH user_events AS(
  SELECT user_id, COUNT(DISTINCT DATE(event_time)) AS active_days, COUNT(*) AS total_events
  FROM taobao-customer-analytics.taobao_analytics.stg_user_behavior a JOIN taobao-customer-analytics.taobao_analytics.mart_user_base b USING (user_id)
  WHERE event_time < feature_date
  GROUP BY user_id
)
SELECT user_id, ROUND(total_events / NULLIF(active_days, 0), 2) AS avg_events_per_active_day
FROM user_events