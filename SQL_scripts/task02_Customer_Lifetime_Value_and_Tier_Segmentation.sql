-- ===============================================================
-- Customer Lifetime Value (LTV) and Tier Segmentation
-- Database: supply_chain_db
-- Objective: Customer segmentation to tailor retention campaigns
-- ===============================================================

USE supply_chain_db;

WITH customer_spend AS
(
SELECT
customer_id,
ROUND(SUM(revenue_usd), 0) AS total_spend,
CASE
	WHEN SUM(revenue_usd) >= 6910 THEN 'High'
    WHEN SUM(revenue_usd) >= 3638 THEN 'Medium'
    ELSE 'Low'
END AS customer_tier
FROM transactions
GROUP BY customer_id
)
SELECT
customer_tier,
COUNT(customer_id) total_customers,
ROUND(AVG(total_spend), 2) AS avg_spend_per_customer_usd,
ROUND(SUM(total_spend), 2) AS total_tier_revenue_usd
FROM customer_spend
GROUP BY customer_tier
ORDER BY total_tier_revenue_usd DESC
;
