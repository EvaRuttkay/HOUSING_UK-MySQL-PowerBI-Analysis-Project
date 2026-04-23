-- Check your tables/counts
SELECT * FROM properties; SELECT COUNT(*) FROM properties;
SELECT * FROM repairs; SELECT COUNT(*) FROM repairs;
SELECT * FROM tenants; SELECT COUNT(*) FROM tenants;

-- FIND NULL VALUES (DIAGNOSTICS)
SELECT * FROM Properties
WHERE Last_inspection_date IS NULL;

SELECT * FROM Repairs
WHERE CompletionDate IS NULL;

SELECT * FROM Tenants
WHERE SatisfactionScore IS NULL;

-- REPLACE NULL SATISFACTION SCORE WITH AVERAGE SCORE
UPDATE Tenants
SET SatisfactionScore = (
    SELECT AVG(SatisfactionScore)
    FROM (SELECT SatisfactionScore FROM Tenants WHERE SatisfactionScore IS NOT NULL) AS t
)
WHERE SatisfactionScore IS NULL;

-- REPLACE NULL SATISFACTION WITH A NEUTRAL VALUE(3)
UPDATE Tenants
SET SatisfactionScore = 3
WHERE SatisfactionScore IS NULL;

-- IF NEEDED - Delete properties with missing inspection dates
DELETE FROM Properties
WHERE Last_inspection_date IS NULL;

-- IF NEEDED - Delete repairs with missing completion dates
DELETE FROM Repairs
WHERE CompletionDate IS NULL;

-- IF NEEDED - Delete tenants with missing satisfaction
DELETE FROM Tenants
WHERE SatisfactionScore IS NULL;


-- 1 TOTAL REPAIR COST BY YEAR
SELECT YEAR(RequestDate) AS Year,
	   SUM(Cost) AS TotalRapairCost
FROM repairs
GROUP BY YEAR(RequestDate)
ORDER BY Year DESC
;

-- 2 AVERAGE REPAIR COST BY REPAIR TYPE
SELECT RepairType,
	   AVG(Cost) AS AvgCost
FROM repairs
GROUP BY RepairType
ORDER BY AvgCost DESC;

-- 3 AVERAGE COMPLETION TIME(DAYS) BY PRIORITY
SELECT 
    Priority,
    AVG(DATEDIFF(CompletionDate, RequestDate)) AS AvgDaysToComplete
FROM Repairs
WHERE CompletionDate IS NOT NULL
GROUP BY Priority;

-- 4 TOP 10 PROPERTIES BY TOTAL REPAIR COST 
SELECT PropertyID,
    COUNT(*) AS RepairCount,
    SUM(Cost) AS TotalRepairCost
FROM Repairs
GROUP BY PropertyID
ORDER BY TotalRepairCost DESC
LIMIT 10;

-- 5 AVERAGE TENANT SATISFACTION BY PROPERTY TYPE
SELECT 
    p.PropertyType,
    AVG(t.SatisfactionScore) AS AvgSatisfaction
FROM Tenants t
JOIN Properties p ON t.PropertyID = p.PropertyID
WHERE t.SatisfactionScore IS NOT NULL
GROUP BY p.PropertyType;

-- 6 COMPLAINT RATE BY CONDITION RATING
SELECT 
    p.ConditionRating,
    SUM(CASE WHEN t.ComplaintFlag = 'Yes' THEN 1 ELSE 0 END) AS Complaints,
    COUNT(*) AS TotalTenants,
    SUM(CASE WHEN t.ComplaintFlag = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS ComplaintRate
FROM Tenants t
JOIN Properties p ON t.PropertyID = p.PropertyID
GROUP BY p.ConditionRating
ORDER BY p.ConditionRating;

-- 7 REPAIRS BY PROPERTY BUILD DECADE
SELECT 
    CONCAT(FLOOR(BuildYear / 10) * 10, 's') AS BuildDecade,
    COUNT(r.RepairID) AS RepairCount,
    SUM(r.Cost) AS TotalRepairCost
FROM Properties p
LEFT JOIN Repairs r ON p.PropertyID = r.PropertyID
GROUP BY BuildDecade
ORDER BY BuildDecade;

-- 8 SATISFACTION VS ANNUAL REPAIR COST PER PROPERTY
SELECT 
    p.PropertyID,
    AVG(t.SatisfactionScore) AS AvgSatisfaction,
    SUM(r.Cost) / COUNT(DISTINCT YEAR(r.RequestDate)) AS AvgAnnualRepairCost
FROM Properties p
LEFT JOIN Tenants t ON p.PropertyID = t.PropertyID
LEFT JOIN Repairs r ON p.PropertyID = r.PropertyID
GROUP BY p.PropertyID;

-- 9 EMERGENCY REPAIRS AS A PERCENTAGE OF ALL REPAIRS
SELECT 
    SUM(CASE WHEN Priority = 'Emergency' THEN 1 ELSE 0 END) AS EmergencyRepairs,
    COUNT(*) AS TotalRepairs,
    SUM(CASE WHEN Priority = 'Emergency' THEN 1 ELSE 0 END) / COUNT(*) AS EmergencyShare
FROM Repairs;



