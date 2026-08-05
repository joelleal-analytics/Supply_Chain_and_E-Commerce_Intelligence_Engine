-- ==============================================
-- Inventory Turnover and Stockout Risk Analysis
-- Database: supply_chain_db
-- Objective: Pinpoint inventory bottlenecks
-- ==============================================

USE supply_chain_db;

WITH sales_summary AS
(
SELECT
product_id,
SUM(quantity) AS total_units_sold,
DATEDIFF(MAX(date), MIN(date)) +1 AS active_days
FROM transactions
GROUP BY product_id
)
SELECT
p.product_id,
p.name,
p.category,
COALESCE(s.total_units_sold, 0) AS total_units_sold,
ROUND(COALESCE(s.total_units_sold, 0) / s.active_days, 2) AS daily_sales_rate,
i.stock_units AS current_stock,
ROUND(
i.stock_units / NULLIF((COALESCE(s.total_units_sold, 0) / s.active_days), 0)
) AS days_of_supply_remaining,

CASE 
	WHEN (i.stock_units / NULLIF((COALESCE(s.total_units_sold, 0) / s.active_days), 0)) <=7 THEN 'Critical - Stockout Risk'
	WHEN (i.stock_units / NULLIF((COALESCE(s.total_units_sold, 0) / s.active_days), 0)) BETWEEN 8 AND 30 THEN 'Low Stock' 
	WHEN (i.stock_units / NULLIF((COALESCE(s.total_units_sold, 0) / s.active_days), 0)) BETWEEN 31 AND 90 THEN 'Healthy Stock'
	ELSE 'Overstock/ Slow moving'
END AS inventory_status

FROM products p
JOIN inventory i
	ON p.product_id = i.product_id
LEFT JOIN sales_summary s
	ON p.product_id = s.product_id
ORDER BY days_of_supply_remaining ASC
;


