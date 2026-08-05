-- ================================================================================================================
-- End-to-end Operational Efficiency Index (OEI) Score
-- Database: supply_chain_db
-- Objective: Rank all products in terms of sales volume, profit margins, return rates, and stock availability
-- ================================================================================================================

USE supply_chain_db;

WITH cat_refunds AS (
SELECT
p.product_id,
ROUND(SUM(r.refund_amount_usd), 2) AS total_refund
FROM returns r
JOIN products p 
	ON r.product_id = p.product_id
GROUP BY p.product_id),
cat_sales AS (
SELECT
p.category,
p.product_id,
p.name,
ROUND(SUM(t.revenue_usd), 2) AS total_revenue_usd
FROM transactions t
JOIN products p
	ON t.product_id = p.product_id
GROUP BY p.category, p.product_id, p.name
),
inventory AS(
SELECT
product_id,
AVG(stock_units) AS avg_stock_units
FROM inventory
GROUP BY product_id
)
 SELECT
s.product_id,
s.name,
s.category,
ROUND(COALESCE(i.avg_stock_units, 0), 0) AS avg_stock_units,
s.total_revenue_usd,
COALESCE(r.total_refund, 0) AS total_refunds_usd,
ROUND((COALESCE(r.total_refund, 0) / s.total_revenue_usd) *100, 2) AS refund_rate_pct,
ROUND(
100 
- (ROUND((COALESCE(r.total_refund, 0) / s.total_revenue_usd) *100, 2) *2)
- (COALESCE(i.avg_stock_units, 0) /100), 2
) AS OEI_score
FROM cat_sales s 
LEFT JOIN cat_refunds r
	ON s.product_id = r.product_id
LEFT JOIN inventory i 
	ON s.product_id = i.product_id
ORDER BY OEI_score DESC
;
