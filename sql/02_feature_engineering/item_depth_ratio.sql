CREATE OR REPLACE TABLE taobao-customer-analytics.taobao_features.item_depth_ratio
AS
WITH user_views AS(
  SELECT a.user_id, COUNT(b.item_id) AS pv_count, COUNT(DISTINCT item_id) AS items_viewed
  FROM taobao-customer-analytics.taobao_analytics.mart_user_base a LEFT JOIN taobao-customer-analytics.taobao_analytics.stg_user_behavior b
  ON a.user_id = b.user_id AND b.event_time < a.feature_date AND b.behavior_type = 'pv'
  GROUP BY a.user_id
)
SELECT user_id, COALESCE(ROUND(pv_count / NULLIF(items_viewed, 0), 2), 0) AS item_depth_ratio
FROM user_views