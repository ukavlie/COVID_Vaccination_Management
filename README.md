COVID-19 VACCINATION MANAGEMENT SYSTEM
Course Assignment -- Hult International Business School
Subject: Database Design & SQL
 

OVERVIEW

 
This project is a relational database system designed to manage and coordinate
COVID-19 vaccination logistics. The database tracks patients, healthcare workers,
hospitals, vaccine inventory, and vaccination schedules -- enabling prioritised
rollout and operational oversight during a mass vaccination campaign.
 
Database name: vaccination_management
Built with:    MySQL
 
 

SCHEMA -- TABLES

 
address
  Shared address registry used by both hospitals and patients.
 
hospital
  Hospitals and vaccination centres with location details.
 
employees
  Healthcare workers, linked to their hospital.
 
patients
  Patient demographics and address reference.
 
insurance
  Insurance provider per patient.
 
medical_record
  Patient health status and conditions relevant to vaccination priority.
 
profession
  Patient occupation and priority tier.
 
vaccine
  Vaccine inventory with supplier and expiry date.
 
schedule
  Vaccination appointments linking patients, employees, hospitals, and vaccines.
 
 
================================================================================
ENTITY RELATIONSHIPS
================================================================================
 
- A patient has one address, one or more insurance records, a medical record,
  and a profession entry.
- A hospital is linked to an address and employs one or more employees.
- A vaccination schedule ties together a patient, employee, hospital, and a
  specific vaccine dose.
 
 
================================================================================
VIEW -- full_patient_detail
================================================================================
 
A consolidated view joining patients, medical_record, profession, and address.
Used as the foundation for the priority_list stored procedure.
 
 
================================================================================
STORED PROCEDURES
================================================================================
 
priority_list(in_tier INT)
---------------------------
Returns a prioritised list of patients based on the COVID-19 vaccination
priority framework:
 
  Tier 1 -- Healthcare workers (profession_id = 150001)
  Tier 2 -- Age 75 or older, or high-risk profession (tier 2)
  Tier 3 -- Pre-existing medical conditions, or age 65-74
  Tier 4 -- Under 65, no conditions, lower-priority profession
 
Example:
  CALL priority_list(1);   -- Returns healthcare workers
  CALL priority_list(3);   -- Returns patients with conditions or aged 65-74
 
 
hospital_pressure(in_date DATE)
--------------------------------
Returns the number of scheduled vaccinations per hospital on a given date,
ordered ascending. Useful for identifying capacity bottlenecks and redistributing
patient load between centres.
 
Example:
  CALL hospital_pressure('2021-04-15');
 
 
================================================================================
SETUP INSTRUCTIONS
================================================================================
 
1. Open MySQL Workbench or any MySQL client.
2. Run the full SQL script: vaccination_management.sql
3. The script will:
     - Create the vaccination_management schema
     - Build all tables with foreign key constraints
     - Create the full_patient_detail view
     - Register both stored procedures
 
Note: Requires MySQL 5.7 or higher. The script runs in strict SQL mode
(ONLY_FULL_GROUP_BY, STRICT_TRANS_TABLES, etc.).
 
 
================================================================================
KEY DESIGN DECISIONS
================================================================================
 
Shared address table
  Both patients and hospitals reference a common address table, avoiding
  duplicated address data across the system.
 
Priority logic computed dynamically
  Vaccination tiers are calculated at query time using DATEDIFF on birth dates
  combined with profession and medical record fields, rather than stored as
  static flags.
 
Flexible scheduling
  The schedule table tracks dose number (vaccine_doze) and status, supporting
  multi-dose vaccine programmes.
 
 
================================================================================
FILES
================================================================================
 
  vaccination_management.sql    Full schema: tables, view, and procedures
  README.txt                    This file
 
 
================================================================================
Hult International Business School -- Database Design Assignment
================================================================================
