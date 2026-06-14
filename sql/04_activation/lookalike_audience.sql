CREATE OR REPLACE TABLE taobao-customer-analytics.taobao_implementation.lookalike_audience
AS
WITH loyal_threshold AS(
  SELECT feature_name, threshold,
  FROM taobao-customer-analytics.taobao_implementation.lookalike_thresholds
  WHERE `cluster` = 0
),
explorer_threshold AS(
  SELECT feature_name, threshold
  FROM taobao-customer-analytics.taobao_implementation.lookalike_thresholds
  WHERE `cluster` = 2
)
SELECT user_id, 'loyal' AS segment
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics
WHERE 
  cross_purchase_flag = 0 
  AND purchase_days > (SELECT threshold * 0.8 FROM loyal_threshold WHERE feature_name = 'purchase_days') 
  AND cart_to_pv_ratio > (SELECT threshold * 0.8 FROM loyal_threshold WHERE feature_name = 'cart_to_pv_ratio')

UNION ALL

SELECT user_id, 'explorer' AS segment
FROM taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics
WHERE 
  cross_purchase_flag = 0 
  AND distinct_items_viewed > (SELECT threshold * 0.8 FROM explorer_threshold WHERE feature_name = 'distinct_items_viewed')
  AND distinct_categories_viewed > (SELECT threshold * 0.8 FROM explorer_threshold WHERE feature_name = 'distinct_categories_viewed')