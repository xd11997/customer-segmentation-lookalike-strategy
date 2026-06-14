CREATE OR REPLACE TABLE taobao-customer-analytics.taobao_features.fav_to_pv_ratio
AS
WITH user_pv AS(
  SELECT a.user_id, COUNT(b.item_id) AS pv_count
  FROM taobao-customer-analytics.taobao_analytics.mart_user_base a LEFT JOIN taobao-customer-analytics.taobao_analytics.stg_user_behavior b
  ON a.user_id = b.user_id AND b.behavior_type = 'pv' AND b.event_time < a.feature_date
  GROUP BY a.user_id
),
user_cart AS (
  SELECT a.user_id, COUNT(b.item_id) AS fav_count
  FROM taobao-customer-analytics.taobao_analytics.mart_user_base a LEFT JOIN taobao-customer-analytics.taobao_analytics.stg_user_behavior b
  ON a.user_id = b.user_id AND b.behavior_type = 'fav' AND b.event_time < a.feature_date
  GROUP BY a.user_id
)
SELECT c.user_id, COALESCE(ROUND(fav_count / NULLIF(pv_count, 0), 2), 0) AS fav_to_pv_ratio
FROM user_pv c JOIN user_cart d ON c.user_id = d.user_id