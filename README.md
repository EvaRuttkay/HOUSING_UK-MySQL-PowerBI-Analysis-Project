# HOUSING_UK-MySQL-PowerBI-Analysis-Project

This project generates synthetic housing data (properties, repairs, tenants), loads it into MySQL, and uses it for analytics and Power BI dashboards, including data‑quality monitoring.

### 🎯 Key Skills Demonstrated:
`Python` &nbsp;`Pandas` &nbsp;`Numpy` &nbsp;`Faker` &nbsp;`MySQL` &nbsp; `SQL querying and joins` &nbsp; `Exploratory data analysis` &nbsp; `Query structuring` &nbsp; `Data aggregation and filtering` &nbsp; `Power BI` &nbsp; `Dashboard` &nbsp; `DAX` &nbsp; 

### 🔎 Project overview

You get three core datasets:
- **Properties** – basic property info and condition
- **Repairs** – repair requests, costs, and completion dates
- **Tenants** – satisfaction and complaints

These are generated with Python (Faker), stored as CSV, then loaded into **MySQL** and visualised in **Power BI**.

### 🗂️ Database Overview & Structure

### MySQL schema

#### 📝 Example Queries
-- Total repair cost by year
SELECT YEAR(RequestDate) AS Year, SUM(Cost) AS TotalRepairCost
FROM Repairs
GROUP BY YEAR(RequestDate)
ORDER BY Year;

-- Average completion time by priority
SELECT Priority,
       AVG(DATEDIFF(CompletionDate, RequestDate)) AS AvgDaysToComplete
FROM Repairs
WHERE CompletionDate IS NOT NULL
GROUP BY Priority;


- **Properties** – basic property info and condition
- **Repairs** – repair requests, costs, and completion dates
- **Tenants** – satisfaction and complaints

These are generated with Python (Faker), stored as .CSV, then loaded into **MySQL** and visualised in **Power BI**.

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
