CREATE OR REPLACE TABLE taobao-customer-analytics.taobao_analytics.mart_user_base
AS
SELECT *
FROM taobao-customer-analytics.taobao_analytics.mart_cross_purchase_user
UNION ALL
SELECT *
FROM taobao-customer-analytics.taobao_analytics.mart_non_cross_purchase_user;