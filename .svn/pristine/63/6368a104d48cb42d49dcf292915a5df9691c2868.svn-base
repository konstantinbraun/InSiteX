CREATE PROCEDURE [dbo].[GetCompanyStatistics]
(
	@SystemID int,
	@BpID int,
	@CompanyID int
)
AS

DECLARE @SubContractorsTotal int;
DECLARE @SubContractorsDirect int;
DECLARE @EmployeesTotal int;
DECLARE @EmployeesSelf int;

-- Subunternehmer gesamt
WITH Companies AS
(
	SELECT m_c.SystemID, m_c.BpID, m_c.CompanyID, m_c.ParentID
	FROM Master_Companies m_c
		WHERE m_c.SystemID = @SystemID 
			AND m_c.BpID = @BpID 
			AND m_c.CompanyID = @CompanyID 

	UNION ALL
	
	SELECT m_c.SystemID, m_c.BpID, m_c.CompanyID, m_c.ParentID
	FROM Master_Companies m_c
		INNER JOIN Companies
			ON Companies.SystemID = m_c.SystemID
				AND Companies.BpID = m_c.BpID
				AND Companies.CompanyID = m_c.ParentID
)
SELECT @SubContractorsTotal = COUNT(CompanyID) - 1 
FROM Companies;

-- Subunternehmer direkt
SELECT @SubContractorsDirect = COUNT(CompanyID)
FROM Master_Companies
WHERE SystemID = @SystemID 
	AND BpID = @BpID 
	AND ParentID = @CompanyID; 

-- Mitarbeiter gesamt
WITH Companies AS
(
	SELECT m_c.SystemID, m_c.BpID, m_c.CompanyID, m_c.ParentID
	FROM Master_Companies m_c
		WHERE m_c.SystemID = @SystemID 
			AND m_c.BpID = @BpID 
			AND m_c.CompanyID = @CompanyID 

	UNION ALL
	
	SELECT m_c.SystemID, m_c.BpID, m_c.CompanyID, m_c.ParentID
	FROM Master_Companies m_c
		INNER JOIN Companies
			ON Companies.SystemID = m_c.SystemID
				AND Companies.BpID = m_c.BpID
				AND Companies.CompanyID = m_c.ParentID
)
SELECT @EmployeesTotal = COUNT(m_e.EmployeeID) 
FROM Companies 
	INNER JOIN Master_Employees m_e
		ON m_e.SystemID = Companies.SystemID
			AND m_e.BpID = Companies.BpID
			AND m_e.CompanyID = Companies.CompanyID; 

-- Eigene Mitarbeiter
SELECT @EmployeesSelf = COUNT(m_e.EmployeeID) 
FROM Master_Companies m_c 
	INNER JOIN Master_Employees m_e
		ON m_e.SystemID = m_c.SystemID
			AND m_e.BpID = m_c.BpID
			AND m_e.CompanyID = m_c.CompanyID 
WHERE m_c.SystemID = @SystemID 
	AND m_c.BpID = @BpID 
	AND m_c.CompanyID = @CompanyID; 


SELECT @SubContractorsTotal SubContractorsTotal, @SubContractorsDirect SubContractorsDirect, @EmployeesTotal EmployeesTotal, @EmployeesSelf EmployeesSelf;


