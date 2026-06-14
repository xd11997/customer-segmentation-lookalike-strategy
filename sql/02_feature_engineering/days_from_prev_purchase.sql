CREATE OR REPLACE TABLE taobao-customer-analytics.taobao_features.days_from_prev_purchase
AS
WITH purchase_user_base AS(
  SELECT *
  FROM taobao-customer-analytics.taobao_analytics.mart_cross_purchase_user
  UNION ALL
  SELECT *
  FROM taobao-customer-analytics.taobao_analytics.mart_non_cross_purchase_user
),
user_prev_date AS(
  SELECT b.user_id, b.cross_purchase_flag AS label, MAX(event_time) AS prev_date, feature_date
  FROM taobao-customer-analytics.taobao_analytics.stg_user_behavior a RIGHT JOIN purchase_user_base b ON a.user_id = b.user_id
  AND event_time < feature_date AND a.behavior_type = 'buy'
  GROUP BY b.user_id, b.feature_date, b.cross_purchase_flag
)
SELECT user_id, label, DATE_DIFF(DATE(feature_date), DATE(prev_date), DAY) AS days_from_prev_purchase
FROM user_prev_date