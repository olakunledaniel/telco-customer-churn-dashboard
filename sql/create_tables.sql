/* =====================================================
   Telco Customer Churn Dashboard
   Database: TelcoChurnDB
   Purpose:  Create a normalized 3-table relational schema
             (demographics, services, subscriptions) linked
             on customerID, ready for import from Excel-split
             CSV files and downstream use in Power BI.
   ===================================================== */

-- 1. Create and select the database
CREATE DATABASE TelcoChurnDB;
GO
USE TelcoChurnDB;
GO

-- 2. Demographics table
-- Holds customer identity and background attributes
CREATE TABLE demographics (
    customerID     VARCHAR(50) NOT NULL,
    gender         VARCHAR(10),
    SeniorCitizen  INT,
    Partner        VARCHAR(5),
    Dependents     VARCHAR(5),
    CONSTRAINT PK_demographics PRIMARY KEY (customerID)
);
GO

-- 3. Services table
-- Holds the utilities/features each customer has signed up for
CREATE TABLE services (
    customerID         VARCHAR(50) NOT NULL,
    PhoneService        VARCHAR(5),
    MultipleLines        VARCHAR(20),
    InternetService       VARCHAR(20),
    OnlineSecurity        VARCHAR(20),
    OnlineBackup          VARCHAR(20),
    DeviceProtection      VARCHAR(20),
    TechSupport           VARCHAR(20),
    StreamingTV           VARCHAR(20),
    StreamingMovies       VARCHAR(20),
    CONSTRAINT PK_services PRIMARY KEY (customerID),
    CONSTRAINT FK_services_demographics FOREIGN KEY (customerID)
        REFERENCES demographics(customerID)
);
GO

-- 4. Subscriptions table (fact table)
-- Holds billing, contract, and churn outcome data
CREATE TABLE subscriptions (
    customerID          VARCHAR(50) NOT NULL,
    tenure               INT,
    Contract             VARCHAR(20),
    PaperlessBilling     VARCHAR(5),
    PaymentMethod        VARCHAR(30),
    MonthlyCharges       DECIMAL(10, 2),
    TotalCharges         DECIMAL(10, 2),
    Churn                VARCHAR(5),
    CONSTRAINT PK_subscriptions PRIMARY KEY (customerID),
    CONSTRAINT FK_subscriptions_demographics FOREIGN KEY (customerID)
        REFERENCES demographics(customerID),
    CONSTRAINT FK_subscriptions_services FOREIGN KEY (customerID)
        REFERENCES services(customerID)
);
GO

/* =====================================================
   Data import
   Each table was populated from its corresponding CSV
   (demographics.csv, services.csv, subscriptions.csv)
   using the SSMS Import Data Wizard, in this order:
     1. demographics
     2. services
     3. subscriptions
   Import order matters because services and subscriptions
   both hold a Foreign Key reference back to demographics.
   ===================================================== */

-- Quick validation queries used after import
-- SELECT COUNT(*) FROM demographics;   -- expect 7043
-- SELECT COUNT(*) FROM services;       -- expect 7043
-- SELECT COUNT(*) FROM subscriptions;  -- expect 7043

-- SELECT TOP 5 * FROM subscriptions;


/* =====================================================
   Example transformation queries used for analysis
   ===================================================== */

-- Convert SeniorCitizen binary flag into readable text
SELECT
    customerID,
    CASE WHEN SeniorCitizen = 1 THEN 'Senior' ELSE 'Not Senior' END AS SeniorCitizenLabel
FROM demographics;

-- Bucket customers into tenure cohorts
SELECT
    s.customerID,
    s.tenure,
    CASE
        WHEN s.tenure <= 6  THEN '0-6 Months'
        WHEN s.tenure <= 12 THEN '7-12 Months'
        WHEN s.tenure <= 24 THEN '1-2 Years'
        ELSE '2+ Years'
    END AS Tenure_Cohort
FROM subscriptions AS s;

-- Combined view joining all three tables for Power BI
CREATE VIEW vw_TelcoChurn AS
SELECT
    d.customerID,
    d.gender,
    d.SeniorCitizen,
    d.Partner,
    d.Dependents,
    sv.PhoneService,
    sv.MultipleLines,
    sv.InternetService,
    sv.OnlineSecurity,
    sv.OnlineBackup,
    sv.DeviceProtection,
    sv.TechSupport,
    sv.StreamingTV,
    sv.StreamingMovies,
    sub.tenure,
    sub.Contract,
    sub.PaperlessBilling,
    sub.PaymentMethod,
    sub.MonthlyCharges,
    sub.TotalCharges,
    sub.Churn
FROM demographics AS d
JOIN services AS sv       ON d.customerID = sv.customerID
JOIN subscriptions AS sub ON d.customerID = sub.customerID;
GO
