# COVID-19 Vaccination Management System
A relational database system for managing and coordinating COVID-19 vaccination
logistics, including patient prioritisation, scheduling, and hospital capacity
monitoring.

## Motivation
During a mass vaccination campaign, operational data is spread across multiple
domains — patient demographics, medical history, occupational risk, hospital
capacity, and vaccine inventory. Without a structured data model, prioritising
the right patients at the right time becomes operationally intractable.

This project models a vaccination management system that encodes the public
health priority framework directly in the database logic, enabling:

- **Prioritised patient lists** based on age, occupation tier and medical
  status, reflecting real-world COVID-19 rollout criteria.
- **Hospital pressure monitoring** to identify capacity bottlenecks on any
  given vaccination date and support redistribution of patient load.
- **End-to-end traceability** linking each vaccination event to a specific
  patient, employee, hospital, vaccine batch and scheduled date.

## Structure

1. **Address** — shared address registry referenced by both patients and
   hospitals, avoiding duplicated location data across the schema.

2. **Hospital & Employees** — hospitals are linked to addresses and employ
   one or more healthcare workers, who are in turn assigned to vaccination
   events in the schedule.

3. **Patients** — core patient table storing demographics and address
   reference, extended by four satellite tables: insurance, medical_record,
   profession and schedule.

4. **Profession & Medical Record** — profession stores occupational category
   and priority tier; medical_record stores health status flags used to
   determine clinical vulnerability. Both feed directly into the priority
   logic.

5. **Vaccine** — inventory table tracking supplier and expiry date per
   vaccine batch, referenced at the point of scheduling.

6. **Schedule** — central fact table linking patient, employee, hospital and
   vaccine for each vaccination event, with dose number and status fields
   supporting multi-dose programme tracking.

7. **View: full_patient_detail** — consolidated view joining patients,
   medical_record, profession and address into a single flat structure, used
   as the foundation for the priority_list procedure.

8. **Stored Procedures** — two procedures implement the operational logic:
   priority_list for patient prioritisation across four tiers, and
   hospital_pressure for date-specific capacity reporting.

## Key Logic

**priority_list(in_tier INT)**

Implements a four-tier vaccination priority framework computed dynamically
at query time from age, profession tier and medical status:

| Tier | Criteria |
|------|----------|
| 1 | Healthcare workers (profession_id = 150001) |
| 2 | Age 75 or older, or high-risk profession (tier 2) |
| 3 | Pre-existing medical conditions, or age 65–74 |
| 4 | Under 65, no conditions, lower-priority profession |

Age is computed dynamically using DATEDIFF against the current date, so the
tier assignments remain correct without any manual updates to the data.

**hospital_pressure(in_date DATE)**

Returns scheduled vaccination counts per hospital on a given date, ordered
ascending. Intended as an operational tool for identifying which centres are
under- or over-loaded on a specific day.

## Methods & Tools

- **MySQL 5.7+**: InnoDB engine, foreign key constraints, strict SQL mode
- **Views**: `full_patient_detail` as a reusable join layer across procedures
- **Stored Procedures**: conditional branching (IF/ELSEIF) and dynamic age
  calculation via DATEDIFF for tier assignment
- **Schema design**: normalised to 3NF with a shared address table and
  surrogate integer primary keys throughout

## Setup

1. Open MySQL Workbench or any MySQL client.

2. Run the full schema script:
```sql
SOURCE vaccination_management.sql;
```

3. The script will:
   - Create the `vaccination_management` schema
   - Build all tables with foreign key constraints
   - Create the `full_patient_detail` view
   - Register both stored procedures

## Usage Examples

```sql
-- Get all tier 1 priority patients (healthcare workers)
CALL priority_list(1);

-- Get clinically vulnerable patients (conditions or age 65-74)
CALL priority_list(3);

-- Check hospital load on a specific date
CALL hospital_pressure('2021-04-15');
```

## Files

```
vaccination_management.sql    Full schema: tables, view, and procedures
README.md                     This file
```

---
*Hult International Business School — Database Design Assignment*
