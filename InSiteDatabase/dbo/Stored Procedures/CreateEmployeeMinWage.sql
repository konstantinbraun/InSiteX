CREATE PROCEDURE [dbo].[CreateEmployeeMinWage]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int
)
AS

DECLARE @BeginOfMonth date = DATEFROMPARTS(DATEPART(YYYY, SYSDATETIME()), DATEPART(M, SYSDATETIME()), 1);

INSERT INTO Data_EmployeeMinWage
(
	SystemID, 
	BpID, 
	EmployeeID, 
	MWMonth, 
	PresenceSeconds, 
	StatusCode, 
	Amount, 
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn
)
SELECT DISTINCT 
	Master_Employees.SystemID, 
	Master_Employees.BpID, 
	Master_Employees.EmployeeID, 
	@BeginOfMonth, 
	0, 
	0, 
	0, 
	'System', 
	SYSDATETIME(), 
	'System', 
	SYSDATETIME()
FROM Master_Employees 
	INNER JOIN Master_Companies 
		ON Master_Employees.SystemID = Master_Companies.SystemID 
			AND Master_Employees.BpID = Master_Companies.BpID 
			AND Master_Employees.CompanyID = Master_Companies.CompanyID 
	INNER JOIN Master_EmploymentStatus 
		ON Master_Employees.SystemID = Master_EmploymentStatus.SystemID 
			AND Master_Employees.BpID = Master_EmploymentStatus.BpID 
			AND Master_Employees.EmploymentStatusID = Master_EmploymentStatus.EmploymentStatusID
WHERE Master_Employees.SystemID = @SystemID 
	AND Master_Employees.BpID = @BpID 
	AND Master_Employees.EmployeeID = @EmployeeID 
	AND Master_Companies.MinWageAttestation = 1 
	AND Master_EmploymentStatus.MWObligate = 1
	AND NOT EXISTS
	(
		SELECT 1
		FROM Data_EmployeeMinWage
		WHERE SystemID = Master_Employees.SystemID
			AND BpID = Master_Employees.BpID
			AND EmployeeID = Master_Employees.EmployeeID
			AND MWMonth = @BeginOfMonth
	)

RETURN @@ROWCOUNT
