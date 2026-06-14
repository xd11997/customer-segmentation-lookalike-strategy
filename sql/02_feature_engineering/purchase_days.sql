CREATE OR REPLACE TABLE taobao-customer-analytics.taobao_features.purchase_days
AS
SELECT b.user_id, COUNT(DISTINCT DATE(event_time)) AS purchase_days
FROM taobao-customer-analytics.taobao_analytics.stg_user_behavior a RIGHT JOIN taobao-customer-analytics.taobao_analytics.mart_user_base b ON b.user_id = a.user_id
  AND a.behavior_type = 'buy'
  AND DATE(a.event_time) <= DATE(b.feature_date)
GROUP BY b.user_id, feature_date


