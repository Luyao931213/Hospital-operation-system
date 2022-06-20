
--- DAMG6210 Project Team 7 
--- HOSPITAL MANAGEMENT SYSTEM DATABASE    
--- Team Members:
--- Palash Thaokar
--- Siddhesh Koparde
--- Luyao Xu
--- Sneha Subramanian
--- Aditi Namdev


CREATE DATABASE PROJECTTEAM7;

USE PROJECTTEAM7 

-----------------------------------------------------------
--CREATING TABLES
-----------------------------------------------------------

CREATE TABLE Patients
(
	Patients_ID int Identity not null Primary Key,
	Patients_first_Name varchar(60) not null,
	Patients_last_Name varchar(60) not null,
	Patien_street_no varchar(50) not null,
	Patients_City varchar(50) not null,
	Patients_Zipcode int not null,
	Patients_gender varchar(10) not null,
	Patients_cno varchar(20) not null,
	Patients_DOB date not null,
	Patients_Symptoms varchar(200) not null,
	Patients_PEA varchar(200) not null
);


-----------------------------------------------------------

CREATE TABLE Employee
(
	Employee_ID int Identity not null Primary Key,
	Employee_first_Name varchar(60) not null,
	Employee_last_Name varchar(60) not null,
	Employee_street_no varchar(50) not null,
	Employee_city varchar(50) not null,
	Employee_zipcode int not null,
	Employee_gender varchar(10) not null,
	Employee_cno varchar(20) not null,
	Employee_DOB date not null,
	Employee_Department varchar(200) not null
);

-----------------------------------------------------------

CREATE TABLE Medicine 
(
	Medicine_id int not null Primary key,
	Patients_ID int identity not null references Patients(Patients_ID),
	Medicine_name varchar(50) not null,
	Medicine_type varchar(50) not null,
	Medicine_manufacture varchar(100) not null,
	Medicine_expiry date not null,
	Medicine_mDate date not null,
	Medicine_price float not null
);

-----------------------------------------------------------

CREATE table E_P_Association 
(
	emp_pat_ID int identity not null primary key,
	Employee_ID int not null references Employee(Employee_ID),
	Patients_ID int not null references Patients(Patients_ID)
);

-----------------------------------------------------------

CREATE table Departments
(
	Department_ID int not null primary key,
	Department_type varchar(60) not null,
	Department_name varchar(100) not null,
	Department_location varchar(100) not null 
);

-----------------------------------------------------------

CREATE table E_D_Association
(
	Emp_Dept_ID int not null primary key,
	Employee_ID int not null references Employee(Employee_ID),
	Department_ID int not null references Departments(Department_ID)
);

-----------------------------------------------------------

CREATE table Online_Services
(
	Patients_ID int not null references Patients(Patients_ID),
	Services varchar(200) not null
);

-----------------------------------------------------------

CREATE table Deliveries
(
	Deliveries_ID int not null primary key,
	Patients_ID int not null references Patients(Patients_ID),
	Employee_ID int not null references Employee(Employee_ID),
	Deliveries_time datetime not null
);

-----------------------------------------------------------

CREATE table Hospital_Occupancy
(
	Room_number int not null primary key,
	Patients_ID int not null references Patients(Patients_ID),
	Room_availability varchar(10) not null,
	Room_type varchar(50) not null
);

-----------------------------------------------------------

CREATE table Ambulance_Data
(
	Ambulance_number varchar(10) not null primary key,
	Ambulance_availability varchar(10) not null,
	Employee_ID int not null references Employee(Employee_ID)
);

-----------------------------------------------------------

CREATE table Feedback_Form
(
	Form_id int not null primary key,
	Patients_ID int not null references Patients(Patients_ID),
	Ratings int not null,
	Recommendations varchar(100) not null 
);

-----------------------------------------------------------

CREATE table Covid_Data
(
	Patients_ID int not null references Patients(Patients_ID),
	symptomatic varchar(10) not null
);

-----------------------------------------------------------

create table Patients_status
(
	Patients_ID int not null references Patients(Patients_ID),
	Patients_Conditions varchar(100) not null
);

-----------------------------------------------------------

CREATE table Visitors
(
	Visitors_ID int not null primary key,
	Patients_ID int not null references Patients(Patients_ID),
	Visitors_Firstname varchar(50) not null,
	Visitors_Lastname varchar(50) not null,
	Visitors_cno varchar(20)  not null,
	Visitors_gender varchar(10) not null,
	Visitors_age int not null,
	Visitors_streetno varchar(50) not null,
	Visitors_city varchar(50) not null,
	Visitors_zipcode int not null,
	Visitors_relation varchar(50) not null
);

-----------------------------------------------------------

CREATE table Bill 
(
	Bill_ID int not null primary key,
	Patients_ID int not null references Patients(Patients_ID),
	Bill_Transaction_Type varchar(10) not null,
	Bill_date datetime not null,
	Total_amount float not null
);


-----------------------------------------------------------

CREATE table FrontDesk
(
	LOE varchar(100) not null,
	Patients_ID int not null references Patients(Patients_ID),
	Employee_ID int not null references Employee(Employee_ID)
);


-----------------------------------------------------------
--CREATING PROCEDURES
-----------------------------------------------------------

CREATE PROCEDURE ALLPATIENTS
AS
SELECT * FROM PROJECTTEAM7.dbo.Patients
go;

EXEC ALLPATIENTS 

----------------------------------------------------------

CREATE PROCEDURE VIEWPATIENTS
AS 
SELECT p.Patients_ID, p.Patients_first_Name,
		p.Patient_last_name , p.Patients_Symptoms 
FROM PROJECTTEAM7.dbo.Patients p
go;

EXEC VIEWPATIENTS 

-----------------------------------------------------------

CREATE PROCEDURE VIEWEMPLOYEES
AS 
SELECT e.Employee_ID, e.Employee_first_Name,
		e.Employee_last_Name, d.Department_name, d.Department_location 
FROM PROJECTTEAM7.dbo.Employee e
join PROJECTTEAM7.dbo.E_D_Association eda 
on e.Employee_ID = eda.Employee_ID 
JOIN PROJECTTEAM7.dbo.Departments d 
on eda.Department_ID = d.Department_ID 
go;

EXEC VIEWEMPLOYEES

-----------------------------------------------------------

CREATE PROCEDURE VIEWVISITORS
AS
SELECT v.Visitors_ID, v.Visitors_Firstname,
		v.Visitors_Lastname, p.Patients_first_Name, 
		p.Patient_last_name 
FROM PROJECTTEAM7.dbo.Visitors v
join PROJECTTEAM7.dbo.Patients p 
on v.Patients_ID = p.Patients_ID 
go;

EXEC VIEWVISITORS

-----------------------------------------------------------

CREATE PROCEDURE InsertPatient @ID int, @Fname varchar(60), @lname varchar(50),
				@gender varchar(10), @dob date, @p_symp varchar(200), @cno varchar(20), @zip int, 
				@pstno varchar(200), @pcity varchar(50), @ppea varchar(200)
AS 
BEGIN 
	INSERT INTO PROJECTTEAM7.dbo.Patients ( Patients_ID, Patients_first_Name, 
											Patient_last_name, Patients_gender,
											Patients_DOB, Patients_Symptoms, Contact_number,
											Patients_Zipcode, Patient_street_no,
											Patient_City, Patients_pre_existing_ailments  )
							VALUES ( @ID, @Fname, @lname, @gender, @dob, @p_symp, @cno,
									@zip, @pstno, @pcity, @ppea)
	end
	

EXEC InsertPatient(:@ID, :@Fname, :@lname, :@gender, :@dob, :@p_symp, :@cno, :@zip, :@pstno, :@pcity, :@ppea) 	

-----------------------------------------------------------

CREATE PROCEDURE InsertEmployee @ID int, @Fname varchar(60), @lname varchar(50),
				@gender varchar(10), @dob date, @e_dept varchar(200), @zip int, @cno varchar(20), 
				@estno varchar(200), @ecity varchar(50)
AS 
BEGIN 
	INSERT into PROJECTTEAM7.dbo.Employee ( Employee_ID, Employee_first_Name ,
											Employee_last_Name , Employee_gender ,
											Employee_DOB, Employee_Department, Contact_number,
											Employee_zipcode, Employee_Street_noNo, Employee_city )
								VALUES ( @ID, @Fname, @lname, @gender, @dob, @e_dept, @zip, @cno, 
										 @estno, @ecity )
END

exec InsertEmployee(:@ID, :@Fname, :@lname, :@gender, :@dob, :@e_dept, :@zip, :@cno, :@estno, :@ecity) 

-----------------------------------------------------------

CREATE PROCEDURE VIEWCOVID
AS
SELECT p.Patients_ID, p.Patients_first_Name, p.Patient_last_name, cd.symptomatic 
FROM PROJECTTEAM7.dbo.Patients p
join PROJECTTEAM7.dbo.Covid_Data cd 
on p.Patients_ID = cd.Patients_ID 
go;

exec VIEWCOVID

-----------------------------------------------------------

CREATE PROCEDURE AvailableAmbulance
AS 
SELECT COUNT(a.Ambulance_number) as [Number of available Ambulance] 
FROM PROJECTTEAM7.dbo.Ambulance_Data a
WHERE Ambulance_availability = 'Yes'
go;

EXEC AvailableAmbulance 

-----------------------------------------------------------
-- Column level Encryption for Patient Contact number
-----------------------------------------------------------


CREATE MASTER KEY ENCRYPTION BY   
PASSWORD = 'ProjectTeam7';


CREATE CERTIFICATE Hospital  
   WITH SUBJECT = 'Hospital Data Security';  
  

CREATE SYMMETRIC KEY H_key  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE Hospital;  
  

USE PROJECTTEAM7;  
  

-- Create a column in which to store the encrypted data.  
ALTER TABLE PROJECTTEAM7.dbo.Patients  
    ADD EncryptedCNO varbinary(128);   
  

-- Open the symmetric key with which to encrypt the data.  
OPEN SYMMETRIC KEY H_key  
   DECRYPTION BY CERTIFICATE Hospital;  

-- Encrypt the value in column Contact_number with symmetric   
-- key H_key. Save the result in column EncryptedCNO.  
UPDATE PROJECTTEAM7.dbo.Patients  
SET EncryptedCNO = EncryptByKey(Key_GUID('H_key'), Contact_number);  
  

-- Verify the encryption.  
-- First, open the symmetric key with which to decrypt the data.  
OPEN SYMMETRIC KEY H_key  
   DECRYPTION BY CERTIFICATE Hospital;  
  

-- Now list the original Contact_number, the encrypted Contact_number, and the   
-- decrypted ciphertext. If the decryption worked, the original  
-- and the decrypted ID will match.  
SELECT p.Contact_number , EncryptedCNO   
    AS 'Encrypted Contact Number',  
    CONVERT(nvarchar, DecryptByKey(EncryptedCNO))   
    AS 'Decrypted Contact Number'  
    FROM Patients p ;  

-- we Get the original table using

ALTER TABLE dbo.Patients DROP COLUMN EncryptedCNO;


SELECT * from Patients p;

-----------------------------------------------------------
--CREATING FUNCTIONS
-----------------------------------------------------------

--- Function Sales tax  based on the price in Medicine table.The tax rate is define to be 6%. ---
CREATE FUNCTION dbo.tax(
 @price float
)
RETURNS float AS
BEGIN
 DECLARE @return_value float;
 SET @return_value = @price*0.06;
    RETURN @return_value
END;

select dbo.tax(5000) as 'Sales Tax'
-----------------------------------------------------------

--- Function for Price check. If the price is equal or bigger than 0, then the function return 1, else return 0 ---
CREATE FUNCTION dbo.price_check(
 @price float
)
RETURNS INT AS
BEGIN
 DECLARE @return_value INT;
 IF (@price >= 0.00) SET @return_value = 1;
 IF (@price < 0.00) SET @return_value = 0;
return @return_value
END;

select dbo.price_check(-3.62) As 'Price Check'
-----------------------------------------------------------

--- Function for Computing columns for number of visitors for one patient---
CREATE FUNCTION dbo.NumOfPatients(@patientid INT)
RETURNS INT AS
BEGIN 
	DECLARE @total INT = 
		(SELECT COUNT(Visitors_ID) FROM Visitors WHERE Patients_ID = @patientid)
	SET @total = ISNULL(@total, 0);
	RETURN @total
END
ALTER TABLE dbo.Visitors 
ADD [Visitors Number] AS (dbo.NumOfPatients(Visitors_ID));
-----------------------------------------------------------


--- Function for number of Medicine orders for one patient ---
CREATE FUNCTION dbo.NumOfMed(@patientid INT)
RETURNS INT AS
BEGIN
	DECLARE @total INT = 
		(SELECT COUNT(Medicine_ID) FROM Medicine WHERE Patients_ID = @patientid)
	SET @total = ISNULL(@total, 0);
	RETURN @total
END
ALTER TABLE dbo.Medicine
ADD [Medicine Number] AS (dbo.NumOfMed(Medicine_ID));
-----------------------------------------------------------


--- Function for age validation. If the age is >0 and <200, then it will return 1. ---
CREATE FUNCTION dbo.age_check(
@age INT
)
RETURNS INT AS
BEGIN
DECLARE @return_value INT;
SET @return_value = 0;
IF (@age >= 0 and @age <=200) SET @return_value = 1;
return @return_value
END;
ALTER TABLE Visitors

ADD CONSTRAINT Age_Valid CHECK (dbo.age_check(Visitors_age)=1);

select dbo.age_check(150) as 'Age Check';
select dbo.age_check(-6) as 'Age Check';
-----------------------------------------------------------

--- Function to calculate number of employees in a given department ---
CREATE FUNCTION dbo.NumOfEmp(@eID INT)
RETURNS INT AS
BEGIN
DECLARE @total INT =
(SELECT COUNT(Employee_ID) FROM DBO.E_D_Association WHERE Department_ID = @eID)
SET @total = ISNULL(@total, 0);
RETURN @total
END

SELECT dbo.NumOfEmp('3007') AS NUM_OF_EMP7;
SELECT dbo.NumOfEmp('3004') AS NUM_OF_EMP4;
SELECT dbo.NumOfEmp('3001') AS NUM_OF_EMP1;
SELECT dbo.NumOfEmp('3003') AS NUM_OF_EMP3;
-----------------------------------------------------------


--- Function to calculate age of the patient ---
CREATE FUNCTION dbo.abcd (@Patients_ID INT)
RETURNS INT AS
BEGIN
DECLARE @ab INT = (SELECT FLOOR(DATEDIFF(year, dbo.Patients.Patients_DOB, CAST(GETDATE() AS DATE))) FROM dbo.Patients WHERE Patients_ID = @Patients_ID)
SET @ab = ISNULL(@ab, 0);
RETURN @ab
END


select dbo.abcd(2001) AS 'Age';
select dbo.abcd(2021) AS 'Age';
select dbo.abcd(1998) as 'Age';  
-----------------------------------------------------------


--- Function of Action on Feedback Function ---
ALTER TABLE dbo.Feedback_Form
ADD update_onstatus varchar(25);
select * from dbo.Feedback_Form;

CREATE FUNCTION dbo.fb (@PatientsID INT)
RETURNS VARCHAR AS
BEGIN
    DECLARE @ax INT = (SELECT dbo.Feedback_Form.Ratings FROM dbo.Feedback_Form) , 
	@ay VARCHAR = (SELECT dbo.Feedback_Form.update_onstatus FROM dbo.Feedback_Form);
	RETURN @ax
	IF @ax <= 2
	   SET @ay = 'CALL ASAP ON FEEDBACK'
	ELSE
	   SET @ay = 'WE ARE GOOD'
	RETURN @ay
END

select dbo.fb
-----------------------------------------------------------

--- Function to check if the phone number is 10 digits. ---
CREATE FUNCTION dbo.PhNo(@phno int)
RETURNS Bit AS
BEGIN
DECLARE @big AS Bit
IF (@phno >= 1000000000 AND @phno <= 9999999999)
SET @big = 1 
ELSE
SET @big = 0
RETURN @big
END

select dbo.PhNo(61730985632) As 'Phone Number 10 Digit check';
select dbo.PhNo(6173098562) As 'Phone Number 10 Digit check';

ALTER TABLE dbo.Patients ADD CONSTRAINT checknumberpat CHECK (dbo.PhNo(Contact_number)=1);
ALTER TABLE dbo.Employee ADD CONSTRAINT checknumberzemp CHECK (dbo.PhNo(Contact_number)=1);


-----------------------------------------------------------
--CREATING TRIGGERS
-----------------------------------------------------------

--- Trigger for 10%  discount for pateints having bill amount > $50000 ---
CREATE Trigger Pat_discount ON dbo.bill
AFTER INSERT, UPDATE 
AS
BEGIN

    UPDATE dbo.Bill
    SET dbo.bill.Total_amount = dbo.bill.Total_amount - (dbo.bill.Total_amount * 0.1)
    WHERE dbo.bill.Total_amount > 50000
end

insert into dbo.Bill(Bill_ID,Patients_ID,Bill_Transaction_Type,Bill_date,Total_amount)
values (1732,2024,'Credit',2020-06-25,60000);
insert into dbo.Bill(Bill_ID,Patients_ID,Bill_Transaction_Type,Bill_date,Total_amount)
values (1733,2025,'insurance',2020-08-23,49000.99);

select * from dbo.Bill
-----------------------------------------------------------

--- Trigger for if an ambulance is assigned to an employee the availability becomes no and yes if the employee id column is null 
CREATE TRIGGER dbo.Statu ON dbo.Ambulance_Data
AFTER INSERT, UPDATE
AS
BEGIN
UPDATE dbo.Ambulance_Data
SET Ambulance_availability = 'Yes'
WHERE Employee_ID IS NULL;
END;

insert into dbo.Ambulance_Data(Ambulance_number,Ambulance_availability)
Values(7,'No')

select * from dbo.Ambulance_Data


-----------------------------------------------------------

--- Trigger displays the date and time of delivery of medicine after values are inserted.
CREATE TRIGGER dbo.FillDelDate ON dbo.Deliveries
AFTER INSERT, UPDATE
AS
BEGIN
UPDATE dbo.Deliveries
SET delivery_time = (SELECT getdate())
WHERE Deliveries_ID = (SELECT Deliveries_ID FROM inserted);
END;

INSERT INTO dbo.Deliveries( Deliveries_ID , Patients_ID, Employee_ID )
VALUES (9013, 2022, 1022),
(9014, 2005, 1016);

select * from Deliveries;
-----------------------------------------------------------


-----------------------------------------------------------
--CREATING VIEWS
-----------------------------------------------------------

--- View for Number of employees working at every Location ---
CREATE VIEW NumberOfEmployeess AS
	SELECT dbo.Employee.Employee_zipcode AS [LocationID], COUNT(dbo.Employee.Employee_ID) AS [Number of Employees]
	FROM dbo.Employee
	GROUP BY dbo.Employee.Employee_zipcode;

Select * from NumberOfEmployeess;
-----------------------------------------------------------

--- View for the ambulance assigned to the employees working on duty ---
CREATE VIEW EmployeeAmbulanceDat AS
select dbo.Employee.Employee_ID  as 'Employee ID',dbo.Employee.Employee_first_Name as 'First Name',dbo.Employee.Employee_last_Name as 'Last Name', dbo.Ambulance_Data.Ambulance_number as 'Ambulance Number', dbo.Ambulance_Data.Ambulance_availability as 'Ambulance Availability'
from dbo.Employee
join dbo.Ambulance_Data
on dbo.Employee.Employee_ID = dbo.Ambulance_data.Employee_ID
group by dbo.Employee.Employee_ID,dbo.Employee.Employee_first_Name,dbo.Employee.Employee_last_Name,dbo.Ambulance_Data.Ambulance_number,dbo.Ambulance_Data.Ambulance_availability

Select * from EmployeeAmbulanceDat;
-----------------------------------------------------------


--- View for Compulated column of sale tax ---
CREATE VIEW Medicine_v_2 AS
SELECT *, dbo.tax(Medicine_price) AS Sale_Tax
FROM Medicine

Select * from Medicine_v_2

---pirce check constraint---
ALTER TABLE Medicine
ADD CONSTRAINT Price_Valid CHECK (dbo.price_check(Medicine_Price)=1);

select * from Medicine_v_2;
-----------------------------------------------------------


--- View for Calculated total expense per patient ---
CREATE VIEW Patient_Expense_V AS
SELECT P.Patients_ID, P.Patients_first_Name, SUM(M.Medicine_price) AS Total_Expense
FROM Patients AS P, Medicine AS M
WHERE P.Patients_ID = M.Patients_ID
GROUP BY Patients_first_Name, P.Patients_ID

Select * from Patient_Expense_V;
-----------------------------------------------------------



