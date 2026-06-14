CREATE OR REPLACE TABLE taobao-customer-analytics.taobao_features.max_consecutive_active_days
AS
WITH user_events AS(
  SELECT DISTINCT a.user_id, DATE(b.event_time) AS event_date, ROW_NUMBER() OVER(PARTITION BY a.user_id ORDER BY FORMAT_DATE('%Y-%m-%d', event_time) ASC) AS rnk
  FROM taobao-customer-analytics.taobao_analytics.mart_user_base a LEFT JOIN taobao-customer-analytics.taobao_analytics.stg_user_behavior b
  ON a.user_id = b.user_id
  WHERE event_time < feature_date
),
user_streak AS (
  SELECT user_id, DATE_SUB(event_date, INTERVAL rnk DAY) AS grp, COUNT(*) AS streak
  FROM user_events
  GROUP BY user_id, grp
)
SELECT user_id, MAX(streak) AS max_consecutive_active_days
FROM user_streak
GROUP BY user_id