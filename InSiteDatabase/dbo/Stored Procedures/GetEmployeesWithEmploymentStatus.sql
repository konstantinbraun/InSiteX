CREATE PROCEDURE [dbo].[GetEmployeesWithEmploymentStatus]
(
	@SystemID int,
	@BpID int,
	@CountryGroupIDEmployer int,
	@CountryGroupIDEmployee int,
	@EmploymentStatusID int 
)
AS

SELECT m_e.EmployeeID
FROM Master_Employees m_e
	INNER JOIN Master_Addresses m_a
		ON m_e.SystemID = m_a.SystemID
			AND m_e.BpID = m_a.BpID
			AND m_e.AddressID = m_a.AddressID
	INNER JOIN Master_Countries m_ct1
		ON m_a.SystemID = m_ct1.SystemID
			AND m_a.BpID = m_ct1.BpID
			AND m_a.NationalityID = m_ct1.CountryID
	INNER JOIN Master_Companies m_c
		ON m_e.SystemID = m_c.SystemID
			AND m_e.BpID = m_c.BpID
			AND m_e.CompanyID = m_c.CompanyID
	INNER JOIN System_Addresses s_a
		ON m_c.SystemID = s_a.SystemID
			AND m_c.AddressID = s_a.AddressID
	INNER JOIN Master_Countries m_ct2
		ON s_a.SystemID = m_ct2.SystemID
			AND s_a.CountryID = m_ct2.CountryID
WHERE m_e.SystemID = @SystemID
	AND m_e.BpID = @BpID
	AND m_e.EmploymentStatusID = @EmploymentStatusID
	AND m_ct1.CountryGroupID = @CountryGroupIDEmployee
	AND m_ct2.BpID = @BpID
	AND m_ct2.CountryGroupID = @CountryGroupIDEmployer
