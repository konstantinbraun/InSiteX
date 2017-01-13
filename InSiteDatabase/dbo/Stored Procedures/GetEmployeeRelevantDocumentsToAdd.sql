CREATE PROCEDURE [dbo].[GetEmployeeRelevantDocumentsToAdd]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int,
	@RelevantFor int
)
AS

SELECT        
	m_rd.NameVisible, 
	m_rd.RelevantDocumentID,
	m_rd.SampleData
FROM Master_Employees AS m_e 
	INNER JOIN Master_Addresses AS m_a 
		ON m_a.SystemID = m_e.SystemID 
			AND m_a.BpID = m_e.BpID 
			AND m_a.AddressID = m_e.AddressID 
	INNER JOIN Master_Countries AS m_coun 
		ON m_a.SystemID = m_coun.SystemID 
			AND m_a.BpID = m_coun.BpID 
			AND m_a.NationalityID = m_coun.CountryID 
	INNER JOIN Master_Companies AS m_comp 
		ON m_comp.SystemID = m_e.SystemID 
			AND m_comp.BpID = m_e.BpID 
			AND m_comp.CompanyID = m_e.CompanyID 
	INNER JOIN System_Companies 
		ON m_comp.SystemID = System_Companies.SystemID 
			AND m_comp.CompanyCentralID = System_Companies.CompanyID 
	INNER JOIN System_Addresses AS s_a 
		ON s_a.SystemID = System_Companies.SystemID 
			AND s_a.AddressID = System_Companies.AddressID
	INNER JOIN Master_Countries AS m_coun_1 
		ON m_coun_1.SystemID = s_a.SystemID 
			AND m_coun_1.CountryID = s_a.CountryID 
	INNER JOIN Master_DocumentRules AS m_dr 
		ON m_coun.SystemID = m_dr.SystemID 
			AND m_coun.BpID = m_dr.BpID 
			AND m_coun.CountryGroupID = m_dr.CountryGroupIDEmployee 
			AND m_e.EmploymentStatusID = m_dr.EmploymentStatusID 
			AND m_coun_1.BpID = m_comp.BpID 
			AND m_coun_1.SystemID = m_dr.SystemID 
			AND m_coun_1.BpID = m_dr.BpID 
			AND m_coun_1.CountryGroupID = m_dr.CountryGroupIDEmployer 
	INNER JOIN Master_RelevantDocuments AS m_rd 
		ON m_rd.SystemID = m_dr.SystemID 
			AND m_rd.BpID = m_dr.BpID 
			AND m_rd.RelevantDocumentID = m_dr.RelevantDocumentID 
WHERE m_e.SystemID = @SystemID 
	AND m_e.BpID = @BpID 
	AND m_e.EmployeeID = @EmployeeID 
	AND m_coun_1.BpID = @BpID
	AND m_dr.RelevantFor = @RelevantFor