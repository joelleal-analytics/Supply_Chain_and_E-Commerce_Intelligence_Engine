-- ========================================================
-- Net Profit Margin by Product Category
-- Database: supply_chain_db
-- Objective: Identify products with hight profit margins
-- ========================================================


USE supply_chain_db;

SELECT 
p.category,
ROUND(SUM(t.revenue_usd), 2) AS total_revenue_usd,
ROUND(SUM(t.quantity * s.unit_cost_usd), 2) AS total_supplier_cost_usd,
ROUND(SUM(t.revenue_usd) - SUM(t.quantity * s.unit_cost_usd), 2) AS net_profit_usd,
ROUND(((SUM(t.revenue_usd) - SUM(t.quantity * s.unit_cost_usd)) / SUM(t.revenue_usd)) * 100, 2) AS profit_margin_pct
FROM transactions t 
JOIN products p
	ON t.product_id = p.product_id
JOIN supplier_costs s
	ON t.product_id = s.product_id
GROUP BY p.category
ORDER BY profit_margin_pct DESC
;
