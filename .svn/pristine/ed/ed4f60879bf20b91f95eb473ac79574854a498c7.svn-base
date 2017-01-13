CREATE PROCEDURE [dbo].[GetEmployeeDuplicates]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int
)
AS

DECLARE @Soundex nvarchar(1000);
DECLARE @Email nvarchar(200);
DECLARE @Zip nvarchar(10);
DECLARE @Birthdate datetime;
DECLARE @CompanyID int;

SELECT 
	@Soundex = m_a.[Soundex], 
	@Email = m_a.Email, 
	@Zip = m_a.Zip, 
	@Birthdate = m_a.BirthDate,
	@CompanyID = m_e.CompanyID
FROM Master_Employees m_e
	INNER JOIN Master_Addresses m_a
		ON m_e.SystemID = m_a.SystemID
			AND m_e.BpID = m_a.BpID
			AND m_e.AddressID = m_a.AddressID
WHERE m_e.SystemID = @SystemID
	AND m_e.BpID = @BpID
	AND m_e.EmployeeID = @EmployeeID
;

SELECT 
	m_e.EmployeeID, 
	m_a.FirstName,
	m_a.LastName,
	m_a.Email,
	m_a.BirthDate,
	m_a.Zip,
	(CASE 
		-- WHEN m_a.[Soundex] = @Soundex AND m_a.Email = @Email THEN 1
		-- WHEN m_a.[Soundex] = @Soundex AND m_a.BirthDate = @Birthdate THEN 2
		WHEN m_a.[Soundex] = @Soundex AND m_a.Zip = @Zip THEN 3
	END) AS Match
FROM Master_Employees m_e
	INNER JOIN Master_Addresses m_a
		ON m_e.SystemID = m_a.SystemID
			AND m_e.BpID = m_a.BpID
			AND m_e.AddressID = m_a.AddressID
WHERE m_e.SystemID = @SystemID
	AND m_e.BpID = @BpID
	AND m_e.CompanyID = @CompanyID
	AND m_e.EmployeeID != @EmployeeID
	AND m_a.[Soundex] = @Soundex 
	AND m_a.Zip = @Zip
--	AND (
--			(m_a.[Soundex] = @Soundex AND m_a.Email = @Email) 
--			OR (m_a.[Soundex] = @Soundex AND m_a.Zip = @Zip) 
--			OR (m_a.[Soundex] = @Soundex AND m_a.BirthDate = @Birthdate)
--		)
ORDER BY
	Match,
	m_a.LastName,
	m_a.FirstName
;
