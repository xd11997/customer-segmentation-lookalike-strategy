CREATE OR REPLACE TABLE taobao-customer-analytics.taobao_cross_sell_analytics.feature_tgi_summary_per_cluster
AS
WITH cluster_avg_summary AS(
-- ignoreed days_from_prev_purchase, since 90%+ rows are null.
SELECT 
  'purchase_days' AS feature_name,
  avg(CASE WHEN `cluster` = 0 THEN purchase_days END) AS cluster_1_avg, 
  avg(CASE WHEN `cluster` = 1 THEN purchase_days END) AS cluster_2_avg,
  avg(CASE WHEN `cluster` = 2 THEN purchase_days END) AS cluster_3_avg
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics_with_clusters

UNION ALL

SELECT 
  'max_consecutive_active_days',
  avg(CASE WHEN `cluster` = 0 THEN max_consecutive_active_days END), 
  avg(CASE WHEN `cluster` = 1 THEN max_consecutive_active_days END),
  avg(CASE WHEN `cluster` = 2 THEN max_consecutive_active_days END)
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics_with_clusters

UNION ALL

SELECT 
  'avg_events_per_active_day',
  avg(CASE WHEN `cluster` = 0 THEN avg_events_per_active_day END), 
  avg(CASE WHEN `cluster` = 1 THEN avg_events_per_active_day END),
  avg(CASE WHEN `cluster` = 2 THEN avg_events_per_active_day END)
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics_with_clusters

UNION ALL

SELECT 
  'distinct_items_viewed',
  avg(CASE WHEN `cluster` = 0 THEN distinct_items_viewed END), 
  avg(CASE WHEN `cluster` = 1 THEN distinct_items_viewed END),
  avg(CASE WHEN `cluster` = 2 THEN distinct_items_viewed END)
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics_with_clusters

UNION ALL

SELECT 
  'distinct_categories_viewed',
  avg(CASE WHEN `cluster` = 0 THEN distinct_categories_viewed END), 
  avg(CASE WHEN `cluster` = 1 THEN distinct_categories_viewed END),
  avg(CASE WHEN `cluster` = 2 THEN distinct_categories_viewed END)
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics_with_clusters

UNION ALL

SELECT 
  'item_depth_ratio',
  avg(CASE WHEN `cluster` = 0 THEN item_depth_ratio END), 
  avg(CASE WHEN `cluster` = 1 THEN item_depth_ratio END),
  avg(CASE WHEN `cluster` = 2 THEN item_depth_ratio END)
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics_with_clusters

UNION ALL

SELECT 
  'cart_to_pv_ratio',
  avg(CASE WHEN `cluster` = 0 THEN cart_to_pv_ratio END), 
  avg(CASE WHEN `cluster` = 1 THEN cart_to_pv_ratio END),
  avg(CASE WHEN `cluster` = 2 THEN cart_to_pv_ratio END)
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics_with_clusters

UNION ALL

SELECT 
  'fav_to_pv_ratio',
  avg(CASE WHEN `cluster` = 0 THEN fav_to_pv_ratio END), 
  avg(CASE WHEN `cluster` = 1 THEN fav_to_pv_ratio END),
  avg(CASE WHEN `cluster` = 2 THEN fav_to_pv_ratio END)
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics_with_clusters

UNION ALL

SELECT 
  'categories_in_first_purchase',
  avg(CASE WHEN `cluster` = 0 THEN categories_in_first_purchase END), 
  avg(CASE WHEN `cluster` = 1 THEN categories_in_first_purchase END),
  avg(CASE WHEN `cluster` = 2 THEN categories_in_first_purchase END)
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics_with_clusters),

overall_avg AS(
  SELECT feature_name, overall_avg
  FROM taobao-customer-analytics.taobao_cross_sell_analytics.feature_tgi_summary
)

SELECT 
  a.feature_name, 
  ROUND(a.cluster_1_avg, 2) AS cluster_1_avg, 
  ROUND(cluster_2_avg, 2) AS cluster_2_avg,
  ROUND(cluster_3_avg, 2) AS cluster_3_avg,
  COALESCE(ROUND(cluster_1_avg/NULLIF(overall_avg, 0) *100, 2), 0) AS cluster_1_tgi, 
  COALESCE(ROUND(cluster_2_avg/NULLIF(overall_avg, 0) *100, 2), 0) AS cluster_2_tgi,
  COALESCE(ROUND(cluster_3_avg/NULLIF(overall_avg, 0) *100, 2), 0) AS cluster_3_tgi
FROM cluster_avg_summary a LEFT JOIN overall_avg b ON a.feature_name = b.feature_name
ORDER BY cluster_1_tgi DESC, cluster_2_tgi DESC, cluster_3_tgi DESC




