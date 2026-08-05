-- =================================================================
-- Executive Revenue and Order KPIs (Monthly Breakdown)
-- Database: supply_chain_db
-- Objective: Track monthly growht in revenue, order volume, and AOV
-- =================================================================

USE supply_chain_db;

SELECT 
DATE_FORMAT(date, '%Y-%m') sales_month,
COUNT(DISTINCT transaction_id) total_orders,
SUM(quantity) total_units_sold,
ROUND(SUM(revenue_usd)/COUNT(DISTINCT transaction_id), 2) avg_order_value,
ROUND(SUM(revenue_usd), 2) total_revenue_usd
FROM transactions 
WHERE status = 'Çompleted'
GROUP BY DATE_FORMAT(date, '%Y-%m')
ORDER BY sales_month ASC
;
