-- ===========================================================================
-- Price Elasticity and Dynamic Pricing History
-- Database: supply_chain_db
-- Objective: Determine how product pricing impacts sales volume over time
-- ===========================================================================

USE supply_chain_db;

SELECT
category,
is_promotional,
ROUND(AVG(listed_price_usd), 2) AS avg_selling_price_usd,
ROUND(SUM(units_sold), 2) AS total_units_sold,
ROUND(SUM(revenue_usd), 2) AS total_revenue_usd,
ROUND(AVG(price_elasticity), 2) AS avg_price_elasticity
FROM price_history
GROUP BY category, is_promotional
ORDER BY avg_price_elasticity
;
