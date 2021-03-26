-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema vaccination_management
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema vaccination_management
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `vaccination_management` DEFAULT CHARACTER SET utf8 ;
USE `vaccination_management` ;

-- -----------------------------------------------------
-- Table `vaccination_management`.`address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vaccination_management`.`address` (
  `adress_id` INT NOT NULL,
  `address` VARCHAR(45) NULL DEFAULT NULL,
  `district` VARCHAR(45) NULL DEFAULT NULL,
  `postal_code` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`adress_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `vaccination_management`.`hospital`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vaccination_management`.`hospital` (
  `hospital_id` INT NOT NULL,
  `hospital_name` VARCHAR(45) NULL DEFAULT NULL,
  `district` VARCHAR(45) NULL DEFAULT NULL,
  `address` VARCHAR(45) NULL DEFAULT NULL,
  `postal_code` VARCHAR(45) NULL DEFAULT NULL,
  `adress_id` INT NOT NULL,
  PRIMARY KEY (`hospital_id`, `adress_id`),
  INDEX `fk_Hospital_Address1_idx` (`adress_id` ASC) VISIBLE,
  CONSTRAINT `fk_Hospital_Address1`
    FOREIGN KEY (`adress_id`)
    REFERENCES `vaccination_management`.`address` (`adress_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `vaccination_management`.`employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vaccination_management`.`employees` (
  `emp_no` INT NOT NULL,
  `first_name` VARCHAR(45) NULL DEFAULT NULL,
  `last_name` VARCHAR(45) NULL DEFAULT NULL,
  `hospital_id` INT NOT NULL,
  PRIMARY KEY (`emp_no`, `hospital_id`),
  INDEX `fk_Employees_Hospital1_idx` (`hospital_id` ASC) VISIBLE,
  CONSTRAINT `fk_Employees_Hospital1`
    FOREIGN KEY (`hospital_id`)
    REFERENCES `vaccination_management`.`hospital` (`hospital_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `vaccination_management`.`patients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vaccination_management`.`patients` (
  `patient_id` INT NOT NULL,
  `first_name` VARCHAR(45) NULL DEFAULT NULL,
  `last_name` VARCHAR(45) NULL DEFAULT NULL,
  `birth_date` DATE NULL DEFAULT NULL,
  `adress_id` INT NOT NULL,
  PRIMARY KEY (`patient_id`, `adress_id`),
  INDEX `fk_Patients_Address1_idx` (`adress_id` ASC) VISIBLE,
  CONSTRAINT `fk_Patients_Address1`
    FOREIGN KEY (`adress_id`)
    REFERENCES `vaccination_management`.`address` (`adress_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `vaccination_management`.`insurance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vaccination_management`.`insurance` (
  `insurance_id` INT NOT NULL,
  `insurance_supplier` VARCHAR(45) NULL DEFAULT NULL,
  `patient_id` INT NOT NULL,
  PRIMARY KEY (`insurance_id`, `patient_id`),
  INDEX `fk_insurance_patients1_idx` (`patient_id` ASC) VISIBLE,
  CONSTRAINT `fk_insurance_patients1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `vaccination_management`.`patients` (`patient_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `vaccination_management`.`medical_record`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vaccination_management`.`medical_record` (
  `date` DATE NOT NULL,
  `description` VARCHAR(45) NULL DEFAULT NULL,
  `status` VARCHAR(45) NULL DEFAULT NULL,
  `patient_id` INT NOT NULL,
  INDEX `fk_medical_record_patients1_idx` (`patient_id` ASC) VISIBLE,
  CONSTRAINT `fk_medical_record_patients1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `vaccination_management`.`patients` (`patient_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `vaccination_management`.`profession`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vaccination_management`.`profession` (
  `profession_id` INT NOT NULL,
  `profession_name` VARCHAR(45) NULL DEFAULT NULL,
  `profession_tier` INT NULL DEFAULT NULL,
  `patient_id` INT NOT NULL,
  PRIMARY KEY (`profession_id`, `patient_id`),
  INDEX `fk_profession_patients1_idx` (`patient_id` ASC) VISIBLE,
  CONSTRAINT `fk_profession_patients1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `vaccination_management`.`patients` (`patient_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `vaccination_management`.`vaccine`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vaccination_management`.`vaccine` (
  `vaccine_id` INT NOT NULL,
  `vaccine_supplier` VARCHAR(45) NULL DEFAULT NULL,
  `expir_date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`vaccine_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `vaccination_management`.`schedule`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vaccination_management`.`schedule` (
  `vaccination_id` INT NOT NULL,
  `schedule` DATE NULL DEFAULT NULL,
  `vaccine_doze` INT NULL DEFAULT NULL,
  `vaccine_id` INT NOT NULL,
  `hospital_id` INT NOT NULL,
  `emp_no` INT NOT NULL,
  `patient_id` INT NOT NULL,
  `status` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`vaccination_id`, `patient_id`),
  INDEX `fk_Injection_Vaccine1_idx` (`vaccine_id` ASC) VISIBLE,
  INDEX `fk_Injection_Hospital1_idx` (`hospital_id` ASC) VISIBLE,
  INDEX `fk_Injection_Employees1_idx` (`emp_no` ASC) VISIBLE,
  INDEX `fk_Injection_Patients1_idx` (`patient_id` ASC) VISIBLE,
  CONSTRAINT `fk_Injection_Employees1`
    FOREIGN KEY (`emp_no`)
    REFERENCES `vaccination_management`.`employees` (`emp_no`),
  CONSTRAINT `fk_Injection_Hospital1`
    FOREIGN KEY (`hospital_id`)
    REFERENCES `vaccination_management`.`hospital` (`hospital_id`),
  CONSTRAINT `fk_Injection_Patients1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `vaccination_management`.`patients` (`patient_id`),
  CONSTRAINT `fk_Injection_Vaccine1`
    FOREIGN KEY (`vaccine_id`)
    REFERENCES `vaccination_management`.`vaccine` (`vaccine_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

USE `vaccination_management` ;

-- -----------------------------------------------------
-- Placeholder table for view `vaccination_management`.`full_patient_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vaccination_management`.`full_patient_detail` (`patient_id` INT, `first_name` INT, `last_name` INT, `birth_date` INT, `address` INT, `postal_code` INT, `profession_id` INT, `profession_tier` INT, `status` INT);

-- -----------------------------------------------------
-- procedure hospital_pressure
-- -----------------------------------------------------

DELIMITER $$
USE `vaccination_management`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `hospital_pressure`(IN in_date_dd_mm_Y date)
BEGIN

select h.hospital_name, a.address, count(s.patient_id) AS "Count"
from hospital h, schedule s, address a 
where h.hospital_id = s.hospital_id
and h.adress_id = a.adress_id
and s.schedule = in_date_dd_mm_Y
order by count(s.patient_id) asc;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure priority_list
-- -----------------------------------------------------

DELIMITER $$
USE `vaccination_management`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `priority_list`(IN in_tier int)
BEGIN


create or replace view full_patient_detail as (
select p.patient_id, p.first_name, p.last_name, p.birth_date, a.address, a.postal_code ,pr.profession_id, pr.profession_tier, mr.status
from patients p
left join medical_record mr
on p.patient_id = mr.patient_id
left join profession pr
on p.patient_id = pr.patient_id
left join address a
on p.adress_id = a.adress_id);


if in_tier = 1
	then select first_name, last_name, address, postal_code
	from full_patient_detail
	where profession_id = 150001;
elseif in_tier = 2
	then select first_name, last_name, address, postal_code
	from full_patient_detail
	where datediff(date(now()), birth_date)/365>=75
    or profession_tier = 2;
elseif in_tier = 3
	then select first_name, last_name, address, postal_code
	from full_patient_detail
    where status is not null
    or datediff(date(now()), birth_date)/365 between 65 and 74;
elseif in_tier = 4
	then select first_name, last_name, address, postal_code
    from full_patient_detail
    where status is null
    and datediff(date(now()), birth_date)/365<65
    and profession_tier>2;
end if;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `vaccination_management`.`full_patient_detail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vaccination_management`.`full_patient_detail`;
USE `vaccination_management`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vaccination_management`.`full_patient_detail` AS select `p`.`patient_id` AS `patient_id`,`p`.`first_name` AS `first_name`,`p`.`last_name` AS `last_name`,`p`.`birth_date` AS `birth_date`,`a`.`address` AS `address`,`a`.`postal_code` AS `postal_code`,`pr`.`profession_id` AS `profession_id`,`pr`.`profession_tier` AS `profession_tier`,`mr`.`status` AS `status` from (((`vaccination_management`.`patients` `p` left join `vaccination_management`.`medical_record` `mr` on((`p`.`patient_id` = `mr`.`patient_id`))) left join `vaccination_management`.`profession` `pr` on((`p`.`patient_id` = `pr`.`patient_id`))) left join `vaccination_management`.`address` `a` on((`p`.`adress_id` = `a`.`adress_id`)));

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
