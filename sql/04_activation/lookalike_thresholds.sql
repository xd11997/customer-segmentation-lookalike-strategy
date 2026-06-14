CREATE OR REPLACE TABLE taobao-customer-analytics.taobao_implementation.lookalike_thresholds
AS

SELECT
  0 AS `cluster`,
  'purchase_days' AS feature_name,
  AVG(purchase_days) AS threshold
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics_with_clusters
WHERE cluster = 0

UNION ALL

SELECT
  0,
  'cart_to_pv_ratio',
  AVG(cart_to_pv_ratio)
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics_with_clusters
WHERE cluster = 0

UNION ALL

SELECT
  2,
  'distinct_items_viewed',
  AVG(distinct_items_viewed)
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics_with_clusters
WHERE cluster = 2

UNION ALL

SELECT
  2,
  'distinct_categories_viewed',
  AVG(distinct_categories_viewed)
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics_with_clusters
WHERE cluster = 2
;