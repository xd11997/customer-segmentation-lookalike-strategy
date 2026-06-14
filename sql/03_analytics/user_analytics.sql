CREATE OR REPLACE TABLE taobao-customer-analytics.taobao_cross_sell_analytics.user_analytics AS
SELECT
  b.*,
  f3.days_from_prev_purchase,
  f4.purchase_days,
  f5.max_consecutive_active_days,
  f6.avg_events_per_active_day,
  f1.distinct_items_viewed,
  f2.distinct_categories_viewed,
  f7.item_depth_ratio,
  f8.cart_to_pv_ratio,
  f9.fav_to_pv_ratio,
  f10.categories_in_first_purchase
FROM taobao-customer-analytics.taobao_analytics.mart_user_base b
LEFT JOIN taobao-customer-analytics.taobao_features.distinct_items_viewed f1
  USING (user_id)
LEFT JOIN taobao-customer-analytics.taobao_features.distinct_categories_viewed f2
  USING (user_id)
LEFT JOIN taobao-customer-analytics.taobao_features.days_from_prev_purchase f3
  USING (user_id)
LEFT JOIN taobao-customer-analytics.taobao_features.purchase_days f4
  USING (user_id)
LEFT JOIN taobao-customer-analytics.taobao_features.max_consecutive_active_days f5
  USING (user_id)
LEFT JOIN taobao-customer-analytics.taobao_features.avg_events_per_active_day f6
  USING (user_id)
LEFT JOIN taobao-customer-analytics.taobao_features.item_depth_ratio f7
  USING (user_id)
LEFT JOIN taobao-customer-analytics.taobao_features.cart_to_pv_ratio f8
  USING (user_id)
LEFT JOIN taobao-customer-analytics.taobao_features.fav_to_pv_ratio f9
  USING (user_id)
LEFT JOIN taobao-customer-analytics.taobao_features.categories_in_first_purchase f10
  USING (user_id)
ORDER BY user_id ASC;