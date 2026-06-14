CREATE OR REPLACE TABLE taobao-customer-analytics.taobao_cross_sell_analytics.feature_tgi_summary
AS
WITH feature_summary AS(
-- ignoreed days_from_prev_purchase, since 90%+ rows are null.
SELECT 
  'purchase_days' AS feature_name,
  avg(CASE WHEN cross_purchase_flag = 1 THEN purchase_days END) AS cross_avg,
  avg(CASE WHEN cross_purchase_flag = 0 THEN purchase_days END) AS non_cross_avg,
  avg(purchase_days) AS overall_avg
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics

UNION ALL

SELECT 
  'max_consecutive_active_days',
  avg(CASE WHEN cross_purchase_flag = 1 THEN max_consecutive_active_days END),
  avg(CASE WHEN cross_purchase_flag = 0 THEN max_consecutive_active_days END),
  avg(max_consecutive_active_days)
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics

UNION ALL

SELECT 
  'avg_events_per_active_day',
  avg(CASE WHEN cross_purchase_flag = 1 THEN avg_events_per_active_day END),
  avg(CASE WHEN cross_purchase_flag = 0 THEN avg_events_per_active_day END),
  avg(avg_events_per_active_day)
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics

UNION ALL

SELECT 
  'distinct_items_viewed',
  avg(CASE WHEN cross_purchase_flag = 1 THEN distinct_items_viewed END),
  avg(CASE WHEN cross_purchase_flag = 0 THEN distinct_items_viewed END),
  avg(distinct_items_viewed)
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics

UNION ALL

SELECT 
  'distinct_categories_viewed',
  avg(CASE WHEN cross_purchase_flag = 1 THEN distinct_categories_viewed END),
  avg(CASE WHEN cross_purchase_flag = 0 THEN distinct_categories_viewed END),
  avg(distinct_categories_viewed)
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics

UNION ALL

SELECT 
  'item_depth_ratio',
  avg(CASE WHEN cross_purchase_flag = 1 THEN item_depth_ratio END),
  avg(CASE WHEN cross_purchase_flag = 0 THEN item_depth_ratio END),
  avg(item_depth_ratio)
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics

UNION ALL

SELECT 
  'cart_to_pv_ratio',
  avg(CASE WHEN cross_purchase_flag = 1 THEN cart_to_pv_ratio END),
  avg(CASE WHEN cross_purchase_flag = 0 THEN cart_to_pv_ratio END),
  avg(cart_to_pv_ratio)
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics

UNION ALL

SELECT 
  'fav_to_pv_ratio',
  avg(CASE WHEN cross_purchase_flag = 1 THEN fav_to_pv_ratio END),
  avg(CASE WHEN cross_purchase_flag = 0 THEN fav_to_pv_ratio END),
  avg(fav_to_pv_ratio)
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics

UNION ALL

SELECT 
  'categories_in_first_purchase',
  avg(CASE WHEN cross_purchase_flag = 1 THEN categories_in_first_purchase END),
  avg(CASE WHEN cross_purchase_flag = 0 THEN categories_in_first_purchase END),
  avg(categories_in_first_purchase)
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics)

SELECT feature_name, ROUND(cross_avg, 2) AS cross_avg, ROUND(non_cross_avg, 2) AS non_cross_avg, ROUND(overall_avg, 2) AS overall_avg, COALESCE(ROUND(cross_avg/NULLIF(overall_avg, 0) *100, 2), 0) AS tgi, COALESCE(ROUND(cross_avg/NULLIF(non_cross_avg, 0) *100, 2), 0) AS lift
FROM feature_summary
ORDER BY tgi DESC, lift DESC





