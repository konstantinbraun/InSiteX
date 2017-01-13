CREATE PROCEDURE [dbo].[GetEmployeesWithCountry]
(
	@SystemID int,
	@BpID int,
	@CountryID nvarchar(10) 
)
AS

SELECT DISTINCT
	EmployeeID
FROM
	(
		SELECT m_e.EmployeeID
		FROM Master_Employees m_e
			INNER JOIN Master_Addresses m_a
				ON m_e.SystemID = m_a.SystemID
					AND m_e.BpID = m_a.BpID
					AND m_e.AddressID = m_a.AddressID
		WHERE m_e.SystemID = @SystemID
			AND m_e.BpID = @BpID
			AND m_a.NationalityID = @CountryID

		UNION

		SELECT m_e.EmployeeID
		FROM Master_Employees m_e
			INNER JOIN Master_Companies m_c
				ON m_e.SystemID = m_c.SystemID
					AND m_e.BpID = m_c.BpID
					AND m_e.CompanyID = m_c.CompanyID
			INNER JOIN System_Addresses s_a
				ON m_c.SystemID = s_a.SystemID
					AND m_c.AddressID = s_a.AddressID
		WHERE m_e.SystemID = @SystemID
			AND m_e.BpID = @BpID
			AND s_a.CountryID = @CountryID

	) employees

