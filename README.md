# Supply Chain and E-Commerce Intelligence Engine
An End-to-end SQL Analytics Project analyzing sales performance, inventory risk, marketing ROAS, price elasticity, and operational efficiency.

## Executive Summary
It is difficult to track operational efficiency when key performance data is scattered across disconnected sales, returns, and inventory tables. To solve this, I engineered and end-to-end SQL analytics pipeline that unifies fragmented transaction data into a composite Operational Efficiency Index (OEI). This pipeline gives leadership immediate visibility into top profit drivers versus high-leakage products, while providing clear data-driven directions on marketing channel allocation.

## Problem Statement and Dataset Context
Operating a global e-commerce brand involves managing diverse product lines across multiple marketing channels. However, disconnected backend operations create severe blind spots. When inventory holding risk, refund leakages from product returns, and advertising spend are analyzed in isolation, blind spots multiply, turning a potential cash cow into a cash-eating monster.

To uncover operational patterns and unify performance data, I 	queried and connected six core relational tables across the database:

*	**Products and transactions:** Item metadata, gross units sold, and top line revenue.
*	**Returns:** Refund amounts, return volume, and reason codes.
*	**Inventory:** Warehouse stock levels, supplier lead times, and reorder points.
*	**Marketing spend:** Channel-level ad spend and customer acquisition costs.
*	**Price history:** Historical promotional pricing and discount schedules.

## Technical Blueprint
Initially, directly joining unaggregated tables (i.e., transactions, returns, marketing_spend) created a massive Cartesian product. Multiplying every raw transaction row against every marketing channel spend entry and return log generated billions of temporary rows, causing the query to hit a 30-second server timeout.

To eliminate join fan-outs and optimize execution speed, I refactored the architecture into modular Common Table Expressions (CTEs). By pre-aggregating metrics at the product_id level within isolated CTEs (i.e., cat_sales, cat_refunds, and inventory), unnecessary columns were removed before joining. This reduced execution time from a 30-second timeout to under 0.1 seconds. 

To maintain data integrity and prevent runtime errors, I implemented the following defensive SQL functions:
* **COALESCE():** Prevented NULL values from corrupting mathematical calculations when joining products with zero recorded returns (defaulting missing returns to 0).
* **NULLIF():** Paired with division operations guard against division-by-zero runtime errors.
* **ROUND():** Standardized all revenue figures, rates, and scores to 2 decimal places for executive-ready reporting.

Finally, to provide leadership with a single actionable metric, I designed an Operational Efficiency Index (OEI) – a composite scoring model scaled from 0 to 100:

        OEI Score = 100 – (refund_rate_pct * 2) – (avg_stock_units / 100)

* **Baseline (100):** Represents optimal operational health.
* **Quality Penalty (refund_rate_pct):** Heavily penalizes products causing high customer dissatisfaction and revenue leakage.
* **Inventory drag (avg_stock_units / 100):** Penalizes excess inventory holding that ties up operational capital in warehouse space.

## Core Findings and Business Insights
By synthesizing multi-channel marketing data, warehouse inventory levels, transaction histories, and return logs into unified CTE view, the analysis uncovered distinct operational patterns across product lines and acquisition channels. The following three key insights highlight the primary profit driver, revenue leakage risk, and marketing efficiency across the business:

* **Top Operational Performer (PROD0400 FunZone Electronic Item 400):** Achieved the highest OEI score (97.32) across the catalog. Generating $115,039.83 in gross revenue with an exceptionally low refund rate of 1.24% and lean inventory holding (20 units), this product represents optimal operational health having high sales velocity, low customer friction, and minimal tied-up working capital.
* **Top Revenue Leakage Risk (PROD0090 NexGen Sports Item 90):** Ranked lowest in operational efficiency with an OEI of 68.01. This item exhibits a severe 15.88% revenue leakage rate, losing $7,340.58 in refunds out of $46,225.73 gross sales. This indicates underlying product defects or sizing/specification issues that demand an immediate supplier quality audit to prevent further margin erosion.
* **Marketing Funnel Efficiency:** Owned channels have disproportionate returns compared to paid acquisition. Direct search ($130.28 ROAS), organic search ($69.67 ROAS), and email marketing ($62.25 ROAS) lead in channel efficiency. Conversely, paid channels (paid search, social media, and referral) yield significantly lower returns ranging from $6.27 to $11.48 ROAS, indicating a need to reallocate ad spend toward high-intent organic and retention channels.

## Strategic Recommendations and Action Plan
To translate these analytical findings into measurable business value, leadership should execute three immediate, high impact operational initiatives:
* **Protect Margins via Quality Control:** Flag low-OEI products, specifically PROD0090, for immediate inventory and supplier quality audits. Halt aggressive promotional scaling on products exhibiting refund leakage rates above 10% until return root causes are resolved.
* **Scale High Efficiency Winners:** Prioritize inventory stocking and homepage placement for top-OEI products like PROD0400, which demonstrates strong cashflow generation without creating warehouse congestion or customer support overhead.
* **Reallocate Marketing Capital:** Reallocate paid acquisition budgets away from low-performing paid search, social media, and referral channels ($6.27 to $11.48 ROAS) and reinvest into retention campaigns, email, and organic search infrastructure ($62.25 to $130.28 ROAS).

## Appendix

**Table 1. Top 5 SKUs by Operational Efficiency Index (OEI) Score**
[![Top 5 SKUs by Operational Efficiency Index (OEI) Score](https://github.com/joelleal-analytics/Supply_Chain_and_E-Commerce_Intelligence_Engine/blob/main/appendix_images/Top%205%20SKUs%20by%20Operational%20Efficiency%20Index%20(OEI)%20Score.png)](https://github.com/joelleal-analytics/Supply_Chain_and_E-Commerce_Intelligence_Engine/blob/main/appendix_images/Top%205%20SKUs%20by%20Operational%20Efficiency%20Index%20(OEI)%20Score.png)

**Table 2. Bottom 5 SKUs by Operational Efficiency Index (OEI) Score**
[![Bottom 5 SKUs by Operational Efficiency Index (OEI) Score](https://github.com/joelleal-analytics/Supply_Chain_and_E-Commerce_Intelligence_Engine/blob/main/appendix_images/Bottom%205%20SKUs%20by%20Operational%20Efficiency%20Index%20(OEI)%20Score.png)](https://github.com/joelleal-analytics/Supply_Chain_and_E-Commerce_Intelligence_Engine/blob/main/appendix_images/Bottom%205%20SKUs%20by%20Operational%20Efficiency%20Index%20(OEI)%20Score.png)

**Table 3. Marketing Acquisition Efficiency (ROAS) by Channel**
[![Marketing Acquisition Efficiency (ROAS) by Channel](https://github.com/joelleal-analytics/Supply_Chain_and_E-Commerce_Intelligence_Engine/blob/main/appendix_images/Marketing%20Acquisition%20Efficiency%20(ROAS)%20by%20Channel.png)](https://github.com/joelleal-analytics/Supply_Chain_and_E-Commerce_Intelligence_Engine/blob/main/appendix_images/Marketing%20Acquisition%20Efficiency%20(ROAS)%20by%20Channel.png)

---

## Tools and Concepts Used:
* **Tool:** `SQL (MySQL)`
* **Concepts:** `Advanced CTE Architecture` `Data Modeling` `Relational Aggregations` `Defensive SQL (COALESCE, NULLIF)`

> **Exploratory Data Analysis:**
> 
> Before building the final OEI framework, I conducted a thorough exploratory data analysis across all 8 relational tables. This foundational phase covers data sanitization, customer segmentation, promotional price elasticity, supplier lead-time profiling, and channel-level ROAS attribution. You can explore the complete, fully documented query sequence in the **[`/SQL_scripts`](https://github.com/joelleal-analytics/Supply_Chain_and_E-Commerce_Intelligence_Engine/tree/main/SQL_scripts)** directory.
