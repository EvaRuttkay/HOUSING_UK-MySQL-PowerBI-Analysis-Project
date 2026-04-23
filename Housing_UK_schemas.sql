CREATE DATABASE Housing_UK;
USE Housing_UK;

CREATE TABLE Properties (
    PropertyID INT PRIMARY KEY,
    Address VARCHAR(255) NOT NULL,
    PropertyType ENUM('Flat', 'House') NOT NULL,
    BuildYear INT NOT NULL,
    Last_inspection_date DATE NULL,
    ConditionRating INT CHECK (ConditionRating BETWEEN 1 AND 5)
);

CREATE TABLE Repairs (
    RepairID INT PRIMARY KEY,
    PropertyID INT NOT NULL,
    RequestDate DATE NOT NULL,
    CompletionDate DATE NULL,
    RepairType ENUM('Plumbing', 'Electrical', 'Heating', 'Roof') NOT NULL,
    Priority ENUM('Routine', 'Urgent', 'Emergency') NOT NULL,
    Cost DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID)
);

CREATE TABLE Tenants (
    TenantID INT PRIMARY KEY,
    PropertyID INT NOT NULL,
    ComplaintFlag ENUM('Yes', 'No') NOT NULL,
    SatisfactionScore INT NULL CHECK (SatisfactionScore BETWEEN 1 AND 5),
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID)
);

USE Housing_UK;
LOAD DATA LOCAL INFILE '' -- copy path in ''
INTO TABLE Properties
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(PropertyID, Address, PropertyType, BuildYear, Last_inspection_date, ConditionRating);

LOAD DATA LOCAL INFILE '' -- copy path in ''
INTO TABLE Repairs
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(RepairID, PropertyID, RequestDate, CompletionDate, RepairType, Priority, Cost);

LOAD DATA LOCAL INFILE '' -- copy path in ''
INTO TABLE Tenants
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(TenantID, PropertyID, ComplaintFlag, SatisfactionScore);





