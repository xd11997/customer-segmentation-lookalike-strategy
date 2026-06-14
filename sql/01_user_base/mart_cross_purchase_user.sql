CREATE OR REPLACE TABLE taobao-customer-analytics.taobao_analytics.mart_cross_purchase_user
AS
WITH subsequent_purchase AS(
  SELECT DISTINCT user_id, category_id AS subsequent_category, event_time
FROM (
  SELECT user_id, event_time, category_id, RANK() OVER(PARTITION BY user_id ORDER BY event_time ASC) AS rnk
  FROM taobao-customer-analytics.taobao_analytics.stg_user_behavior s
  WHERE behavior_type = 'buy') t
WHERE rnk > 1 
)
SELECT s.user_id, MIN(event_time) AS feature_date, 1 AS cross_purchase_flag
FROM subsequent_purchase s 
WHERE NOT EXISTS (
    SELECT 1
    FROM taobao-customer-analytics.taobao_analytics.dim_user_first_purchase f
    WHERE f.user_id = s.user_id
      AND f.first_category = s.subsequent_category
)
GROUP BY s.user_id