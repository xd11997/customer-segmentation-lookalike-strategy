CREATE OR REPLACE TABLE taobao-customer-analytics.taobao_features.categories_in_first_purchase
AS
WITH user_first_purchase AS(
  SELECT a.user_id, category_id, event_time, DENSE_RANK() OVER(PARTITION BY a.user_id ORDER BY event_time ASC) AS rnk
  FROM taobao-customer-analytics.taobao_analytics.mart_user_base a LEFT JOIN taobao-customer-analytics.taobao_analytics.stg_user_behavior b
  ON a.user_id = b.user_id AND b.behavior_type = 'buy'
)

SELECT user_id, COUNT(DISTINCT category_id) AS categories_in_first_purchase
FROM user_first_purchase
WHERE rnk = 1
GROUP BY user_id