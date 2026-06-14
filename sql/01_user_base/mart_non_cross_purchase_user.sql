CREATE OR REPLACE TABLE taobao-customer-analytics.taobao_analytics.mart_non_cross_purchase_user
AS
WITH all_users AS(
  SELECT DISTINCT user_id
  FROM taobao-customer-analytics.taobao_analytics.stg_user_behavior
),
non_cross_purchase_users AS(
  SELECT a.user_id
  FROM all_users a LEFT JOIN taobao-customer-analytics.taobao_analytics.mart_cross_purchase_user c USING (user_id)
  WHERE c.user_id IS NULL 
)
SELECT b.user_id, MAX(event_time) AS feature_date, 0 AS cross_purchase_flag
FROM taobao-customer-analytics.taobao_analytics.stg_user_behavior a JOIN non_cross_purchase_users b USING (user_id)
WHERE behavior_type ='buy'
GROUP BY b.user_id 