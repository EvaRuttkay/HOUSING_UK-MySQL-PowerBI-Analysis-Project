<!-- Header -->
# HOUSING UK MySQL/PowerBI Analysis Project
This project generates synthetic housing data (properties, repairs, tenants), loads it into MySQL, and uses it for analytics and Power BI dashboards, including data‑quality monitoring.

## 🎯 Key Skills Demonstrated:
`Python` &nbsp;`Pandas` &nbsp;`Numpy` &nbsp;`Faker` &nbsp;`MySQL` &nbsp; `SQL querying and joins` &nbsp; `Exploratory data analysis` &nbsp; `Query structuring` &nbsp; `Data aggregation and filtering` &nbsp; `Power BI` &nbsp; `Dashboards` &nbsp; `DAX` &nbsp; 

## 🧰 Tools & Technologies
- **Python:** Pandas, Numpy, Faker
- **SQL:** MySQL, Mysql Workbench
- **Power BI:** Power Query Editor, Dashboard, DAX
---

## 🔎 Project overview
You get three core datasets. These are generated with Python (Faker), stored as CSV, then loaded into **MySQL** and visualised in **Power BI**.

### 🧭 Python

**1. Properties** – basic property info and condition
- **code example**
```py
num_properties = 100
properties = []

for i in range(1, num_properties + 1):
    build_year = random.randint(1960, 2023)

    # Randomly introduce missing inspection dates
    last_inspection = fake.date_between(start_date='-2y', end_date='today')
    if random.random() < 0.1:  # 10% missing
        last_inspection = None

    properties.append({
        'PropertyID': i,
        'Address': fake.address().replace('\n', ', '),
        'PropertyType': random.choice(['Flat', 'House']),
        'BuildYear': build_year,
        'Last_inspection_date': last_inspection.strftime('%Y-%m-%d') if last_inspection else None,
        'ConditionRating': random.randint(1, 5)
    })

df_properties = pd.DataFrame(properties)
```

**2. Repairs** – repair requests, costs, and completion dates
- **code example**
```py
num_repairs = 500
repairs = []

for i in range(1, num_repairs + 1):
    property_id = random.randint(1, num_properties)
    request_date = fake.date_between(start_date='-2y', end_date='today')

    priority = random.choice(['Routine', 'Urgent', 'Emergency'])

    # Completion date logic
    if priority == 'Emergency':
        completion_date = request_date + timedelta(days=random.randint(1, 3))
    else:
        completion_date = request_date + timedelta(days=random.randint(5, 15))

    # Introduce missing completion dates (e.g., still open)
    if random.random() < 0.05:  # 5% missing
        completion_date = None

    repair_type = random.choice(['Plumbing', 'Electrical', 'Heating', 'Roof'])

    base_cost = {
        'Plumbing': 100,
        'Electrical': 200,
        'Heating': 400,
        'Roof': 600
    }
    cost = base_cost[repair_type] + random.randint(-50, 200)

    repairs.append({
        'RepairID': i,
        'PropertyID': property_id,
        'RequestDate': request_date.strftime('%Y-%m-%d'),
        'CompletionDate': completion_date.strftime('%Y-%m-%d') if completion_date else None,
        'RepairType': repair_type,
        'Priority': priority,
        'Cost': cost
    })

df_properties_repairs = pd.DataFrame(repairs)
```

**3. Tenants** – satisfaction and complaints
- **code example**
```py
tenants = []

for i in range(1, num_properties + 1):
    satisfaction = random.randint(1, 5)

    # Introduce missing satisfaction scores
    if random.random() < 0.05:
        satisfaction = None

    tenants.append({
        'TenantID': i,
        'PropertyID': i,
        'ComplaintFlag': 'Yes' if satisfaction and satisfaction <= 2 else 'No',
        'SatisfactionScore': satisfaction
    })

df_tenants = pd.DataFrame(tenants)
```


### 🗂️ Database Overview & Structure

- **EER Diagram**
<img width="440" height="343" alt="EER Diagram" src="https://github.com/user-attachments/assets/3e1a9ac5-8599-4bee-9ba6-dd71eda9584d" />


- **Example MySQL schemas**:
```sql
CREATE TABLE Properties (
    PropertyID INT PRIMARY KEY,
    Address VARCHAR(255) NOT NULL,
    PropertyType ENUM('Flat', 'House') NOT NULL,
    BuildYear INT NOT NULL,
    Last_inspection_date DATE NULL,
    ConditionRating INT CHECK (ConditionRating BETWEEN 1 AND 5)
);
```

- **Example Queries**:

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
<img width="235" height="166" alt="TOP_10_by_Repair" src="https://github.com/user-attachments/assets/2670c5e3-c365-4395-a852-2075f86854a1" />

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
<img width="299" height="166" alt="Complaint_rate_by_Rating" src="https://github.com/user-attachments/assets/cdb39232-b8e8-41bc-b49d-218ade6ecc21" />

**5. Satisfaction vs annual repair cost per property**
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
### 📊 Power BI Dashboard

### Dashboard Pages

**1. Executive Summary** 

Give a quick snapshot of overall performance: cost, workload, speed, satisfaction.

**1. High‑level KPIs**:
- Total Repair Cost
- Open Repairs
- Avg Days to Complete
- Avg Tenant Satisfaction
- Repairs by Priority & Type

**2. Repairs Performance**
Operational insights:
- Completion time analysis
- Cost by repair type
- Open repairs table
- Cost vs duration scatter

**3. Property Insights**
Property‑level analytics:
- Top/Bottom properties by repair cost
- Build year trends
- Condition rating distribution

**4. Tenant Satisfaction**
Customer experience:
- Satisfaction distribution
- Complaint rate
- Satisfaction vs repair cost

### Example DAX
```DAX
Total Repair Cost = SUM(Repairs[Cost])

Open Repairs =
COUNTROWS(
    FILTER(Repairs, ISBLANK(Repairs[CompletionDate]))
)

Avg Days to Complete =
AVERAGEX(
    FILTER(Repairs, NOT ISBLANK(Repairs[CompletionDate])),
    DATEDIFF(Repairs[RequestDate], Repairs[CompletionDate], DAY)
)

Average Satisfaction = AVERAGE(Tenants[SatisfactionScore])

Repairs Count = COUNTROWS(Repairs)

Complaint Count =
COUNTROWS(
    FILTER(Tenants, Tenants[ComplaintFlag] = "Yes")
)

Tenant Count = COUNTROWS(Tenants)

Complaint Rate =
DIVIDE([Complaint Count], [Tenant Count])

```

### Dashboard Preview

#### **Executive Summary**
<img width="468" height="210" alt="High level KPI" src="https://github.com/user-attachments/assets/75061280-2176-463c-888b-f071610eaae7" />

#### **Repairs Performance**
<img width="468" height="210" alt="Repairs Performance" src="https://github.com/user-attachments/assets/fe9d5117-f78e-4332-a831-91cc89edcdfd" />

#### **Tenant Satisfaction**
<img width="468" height="210" alt="Property_insights" src="https://github.com/user-attachments/assets/008c029c-ae0f-408a-b933-bf620ae89ef8" />


---
## 🛠️Tech stack

- `Python (Pandas, Faker, Numpy)` &nbsp; 
- `MySQL (data storage & SQL analytics)` &nbsp; 
- `Power BI (dashboards & data quality reports)` &nbsp;
---
## 📌 How to Use
1. Download or clone this repository.
2. Install Python dependencies.
3. Install Pandas, Numpy, Faker.
4. Run the generator.
5. Set up Mysql.
6. Create Database, tables and load CSVs into Mysql.
7. Validate the data.
8. Open Power BI Desktop.
9. Get data from Mysql Database.
10. Load the three tables.
11. Build dashboards & DAX measures.

## 🤝 Contact

* [Project created by **EvaRuttkay**.](https://github.com/EvaRuttkay)
  
* [Link to LinkedIn](https://www.linkedin.com/in/evaruttkay)
