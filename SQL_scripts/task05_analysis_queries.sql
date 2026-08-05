-- =========================================================
-- Marketing Spend vs Revenue Generation (ROAS)
-- Database: supply_chain_db
-- Objective: Evaluate the efficiency of marketing channels
-- =========================================================

USE supply_chain_db;

WITH ad_spend AS (
SELECT
channel,
ROUND(SUM(spend_usd), 2) AS total_ad_spend_usd
FROM marketing_spend
GROUP BY channel
) 
SELECT
t.channel,
ROUND(SUM(t.revenue_usd), 2) AS total_revenue_usd,
a.total_ad_spend_usd,
ROUND(COALESCE(SUM(t.revenue_usd) / NULLIF(a.total_ad_spend_usd, 0), 0), 2) AS ROAS_usd
FROM transactions t
JOIN ad_spend a
	ON t.channel = a.channel
GROUP BY t.channel, a.total_ad_spend_usd
ORDER BY ROAS_usd DESC
;



