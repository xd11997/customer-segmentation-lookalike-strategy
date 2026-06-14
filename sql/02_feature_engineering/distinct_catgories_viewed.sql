CREATE OR REPLACE TABLE taobao-customer-analytics.taobao_features.distinct_catgories_viewed
AS
SELECT a.user_id, COUNT(DISTINCT category_id) AS distinct_categories_viewed
FROM taobao-customer-analytics.taobao_analytics.mart_user_base a LEFT JOIN taobao-customer-analytics.taobao_analytics.stg_user_behavior b 
ON a.user_id = b.user_id AND b.event_time < a.feature_date AND b.behavior_type = 'pv'
GROUP BY a.user_id