

-----define two functions: 1. calculated sale tax based on the price in Medine table.
-- The tax rate is defined to be 0.06; 2. Define a function to check if the price in the medine is valid. 
---If the price is equal or bigger than 0, then the function return 1, else return 0-----

---Pirce valid check function---

USE PROJECTTEAM7;

CREATE FUNCTION dbo.tax(
 @price float
)
RETURNS float AS
BEGIN
 DECLARE @return_value float;
 SET @return_value = @price*0.06;
    RETURN @return_value
END;

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

---view1 :Compulated column of sale tax---
CREATE VIEW Medicine_v_2 AS
SELECT *, dbo.tax(Medicine_price) AS Sale_Tax
FROM Medicine
---pirce check constraint---
ALTER TABLE Medicine
ADD CONSTRAINT Price_Valid CHECK (dbo.price_check(Medicine_Price)=1);

---view2:Calculated total expense per patient---
CREATE VIEW Patient_Expense_V AS
SELECT P.Patients_ID, P.Patients_first_Name, SUM(M.Medicine_price) AS Total_Expense
FROM Patients AS P, Medicine AS M
WHERE P.Patients_ID = M.Patients_ID
GROUP BY Patients_first_Name, P.Patients_ID


-----compute columns for number of visitors for one patient---
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


-----number of Medicine orders for one patient---

CREATE FUNCTION dbo.NumOfMed(@patientid INT)
RETURNS INT AS
BEGIN
	DECLARE @total INT = 
		(SELECT COUNT(Medicine_ID) FROM Medicine WHERE Patients_ID = @patientid)
	SET @total = ISNULL(@total, 0);
	RETURN @total
END
ALTER TABLE dbo.Medicine  ADD [Medicine Number] AS (dbo.NumOfMed(Medicine_ID));



CREATE TRIGGER dbo.FillOrderDate ON dbo.Deliveries
AFTER INSERT, UPDATE
AS 
BEGIN
	UPDATE dbo.Deliveries
	SET  delivery_time = (SELECT CONVERT(date, getdate()))
	WHERE Deliveries_ID = (SELECT Deliveries_ID FROM inserted);
END;
DROP TRIGGER dbo.FillOrderDate;

CREATE FUNCTION dbo.NumOfEmployees(@locationID INT)
RETURNS INT AS
BEGIN 
	DECLARE @total INT = 
		(SELECT COUNT(Employee_ID) FROM DBO.E_D_Association WHERE Department_ID = @locationid)
	SET @total = ISNULL(@total, 0);
	RETURN @total
END

ALTER TABLE dbo.Departments ADD [Number of Employees] AS (dbo.NumOfEmployees(LocationID));


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
	   SET @ay = 'I THINK WE GOOD'
	RETURN @ay
END

select * from Feedback_Form;










