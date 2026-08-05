-- ===============================================================================
-- Product Return Rate and Revenue Leakages
-- Database: supply_chain_db
-- Objective: Identify products causing revenue leakage due t excessive returns
-- ===============================================================================

USE supply_chain_db;

WITH return_summary AS (
SELECT
product_id,
COUNT(return_id) AS total_returned_units,
ROUND(SUM(refund_amount_usd), 2) AS total_refund_usd
FROM returns
GROUP BY product_id
) 
SELECT
t.product_id,
p.name,
p.category,
SUM(t.quantity) AS total_units_sold,
ROUND(SUM(t.revenue_usd), 2) AS total_revenue_usd,
ROUND((COALESCE(r.total_returned_units, 0) / SUM(t.quantity)) *100, 0) AS return_rate_pct, 
ROUND(COALESCE(r.total_refund_usd, 0) / SUM(t.revenue_usd) *100, 0)  AS revenue_leakage_pct
FROM transactions t
JOIN return_summary r 
	ON t.product_id = r.product_id
JOIN products p
	ON t.product_id = p.product_id
GROUP BY t.product_id, p.category, p.name
ORDER BY revenue_leakage_pct DESC
;

