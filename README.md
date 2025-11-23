# Retail Sales Analysis | Python • SQL • Power BI

# Executive Summary:
Utilized Python, SQL, and Power BI in the analysis of 6.6M retail transactions to unlock pricing inefficiencies, discount-driven revenue losses, and category performance across markets. The analyses showed that 20% discounts consistently decreased AOV, mid-tier products remained underpriced despite solid demand, and some cities generated disproportionately higher revenues.

To enhance profitability, pricing strategy, and inventory efficiency, I would recommend:

- Removing the 20% discount and switching to a more standardized 10% mode
- Repricing mid-tier items to better reflect demand levels and strong revenue opportunities
- Using high-volume categories, such as Confections, to drive cross-selling

---

# Business problem
Despite having a very high volume of 6.6M retail transactions, the business struggles to convert strong sales activity into sustainable revenue growth, as pricing inefficiencies and poorly optimized discount structures continue to erode margins.

This strategic breakdown is driven by two critical challenges:

**Discount Erosion:** The broad usage of 20% discounts erodes AOV and thus leads to substantial revenue leakage rather than incremental demand.

**Pricing Imbalance:** Medium-tier products, while having the highest unit volume in sales, give the company disproportionately low revenues, showing misaligned pricing to the real market demand.

---

# Methodology
**Python (Pandas):** Cleaned and standardized all tables, merged product prices into the sales table, and calculated gross price, net price, and purchase-frequency metrics.  
**SQL (PostgreSQL):** Ran large-scale analysis to assess discount effectiveness, product-tier performance, and revenue patterns across cities and categories.  
**Power BI:** Built an interactive dashboard to visualize core KPIs such as AOV trends, discount impact, and product/category performance.

---

# Skills
**SQL:** CTEs, Joins, CASE logic, Aggregate Functions, Window Functions, Indexing, and Data Modeling.  
**Python:** ETL with Pandas, data cleaning and preprocessing, feature engineering (price fields, frequency metrics), EDA (df.info(), describe()), and NumPy transformations.  
**Power BI:** Interactive dashboard design, data modeling, KPI visualization, DAX basics.  
**General:** Pricing analysis, category insights, customer behavior analysis, and data storytelling.

---

# Key behaviroul insights
- **Discount Drag:** 20% discounts consistently lower AOV, indicating margin loss without meaningful demand gain.
- **Tier Imbalance:** Medium-tier products sell the most units but generate the least revenue, revealing clear pricing misalignment.
- **Category Pressure:** Confections drive high volume but limited revenue, while other categories rely heavily on discounts to move inventory.
- **Geographic Concentration:** A few cities—like Tucson and Jackson—contribute a disproportionate share of revenue, highlighting strong regional pockets.

---

# Actionable Business Recommendations
**Optimize Discounts:** Retire the 20% discount and standardize on 10% to reduce margin erosion.

**Medium Tier Repricing:** Ensure that medium-tier pricing aligns revenue with demand.

**Improve Inventory Efficiency:** Keep lean safety stock since the purchase patterns remain stable.

**Leverage high-volume categories:** Use the highest-volume category, Confections, as a strategic traffic driver to direct customers to higher revenue items through targeted placement and bundled promotions, along with curated cross-sell opportunities.
