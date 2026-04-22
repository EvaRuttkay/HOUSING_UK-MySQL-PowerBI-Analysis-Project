<!-- Header -->
# HOUSING UK MySQL/PowerBI Analysis Project
This project generates synthetic housing data (properties, repairs, tenants), loads it into MySQL, and uses it for analytics and Power BI dashboards, including data‑quality monitoring.

### 🎯 Key Skills Demonstrated:
`Python` &nbsp;`Pandas` &nbsp;`Numpy` &nbsp;`Faker` &nbsp;`MySQL` &nbsp; `SQL querying and joins` &nbsp; `Exploratory data analysis` &nbsp; `Query structuring` &nbsp; `Data aggregation and filtering` &nbsp; `Power BI` &nbsp; `Dashboard` &nbsp; `DAX` &nbsp; 

### 🧰 Tools & Technologies
- **Python:** Pandas, Numpy, Faker
- **SQL:** MySQL, Mysql Workbench
- **Power BI:** Power Query Editor, Dashboard, DAX
---

### 🔎 Project overview
#### 🧭 Python
You get three core datasets:
- **Properties** – basic property info and condition
- **Repairs** – repair requests, costs, and completion dates
- **Tenants** – satisfaction and complaints

These are generated with Python (Faker), stored as CSV, then loaded into **MySQL** and visualised in **Power BI**.

### 🗂️ Database Overview & Structure

### MySQL schema

#### 📝 Example Queries

**1. Total repair cost by year**
```sql
SELECT YEAR(RequestDate) AS Year,
	   SUM(Cost) AS TotalRapairCost
FROM repairs
GROUP BY YEAR(RequestDate)
ORDER BY Year DESC;
```
**2. Average completion time by priority**
```sql
SELECT Priority,
       AVG(DATEDIFF(CompletionDate, RequestDate)) AS AvgDaysToComplete
FROM Repairs
WHERE CompletionDate IS NOT NULL
GROUP BY Priority;
```
**3. TOP 10 Properties by total repair cost**
```sql
SELECT PropertyID,
    COUNT(*) AS RepairCount,
    SUM(Cost) AS TotalRepairCost
FROM Repairs
GROUP BY PropertyID
ORDER BY TotalRepairCost DESC
LIMIT 10;
```
**4. Complaint rate by condition rating** 
```sql
SELECT 
    p.ConditionRating,
    SUM(CASE WHEN t.ComplaintFlag = 'Yes' THEN 1 ELSE 0 END) AS Complaints,
    COUNT(*) AS TotalTenants,
    SUM(CASE WHEN t.ComplaintFlag = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS ComplaintRate
FROM Tenants t
JOIN Properties p ON t.PropertyID = p.PropertyID
GROUP BY p.ConditionRating
```
**5. SATISFACTION VS ANNUAL REPAIR COST PER PROPERTY**
```sql
SELECT 
    p.PropertyID,
    AVG(t.SatisfactionScore) AS AvgSatisfaction,
    SUM(r.Cost) / COUNT(DISTINCT YEAR(r.RequestDate)) AS AvgAnnualRepairCost
FROM Properties p
LEFT JOIN Tenants t ON p.PropertyID = t.PropertyID
LEFT JOIN Repairs r ON p.PropertyID = r.PropertyID
GROUP BY p.PropertyID;
```
---
## 🛠️Tech stack

- **Python** (pandas, Faker, numpy) 
- **MySQL** (data storage & SQL analytics)
- **Power BI** (dashboards & data‑quality reports)

---

## 📊 Dashboard Preview

### **Executive Summary**
![Executive Summary](images/executive_summary.png)

### **Repairs Performance**
![Repairs Performance](images/repairs_performance.png)

### **Tenant Satisfaction**
![Tenant Satisfaction](images/tenant_satisfaction.png)

### **Data Quality Dashboard**
![Data Quality](images/data_quality.png)

---
## 📌 How to Use
## 3. Python data generation
1. Download or clone this repository.
2. Install Python dependencies.
3. Run the analysis.


## 📦 Requirements

`Python` &nbsp;

`MySQL` &nbsp;

`Power BI Desktop` &nbsp;
