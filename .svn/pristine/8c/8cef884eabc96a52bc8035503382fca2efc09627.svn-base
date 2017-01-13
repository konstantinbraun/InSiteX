CREATE PROCEDURE [dbo].[GetCompanyInfo]
(
	@SystemID int,
	@BpID int,
	@CompanyID int = 0
)

AS

SELECT        
	m_c.SystemID, 
	m_c.BpID, 
	m_c.CompanyID, 
	m_c.NameVisible, 
	m_c.NameAdditional, 
	m_c.TradeAssociation, 
	m_c.BlnSOKA, 
	m_c.IsPartner, 
	m_c.RiskAssessment, 
    m_c.MinWageAttestation, 
	m_c.MinWageAccessRelevance, 
	s_a.Address1, 
	s_a.Zip, 
	s_a.City, 
	s_a.CountryID, 
	m_c_mc.CompanyID AS ClientCompanyID, 
	m_c_mc.NameVisible AS ClientNameVisible, 
	m_c_mc.NameAdditional AS ClientNameAdditional,
	s_c.UserID,
	m_c.CompanyCentralID
FROM Master_Companies AS m_c 
	INNER JOIN System_Companies AS s_c 
		ON m_c.SystemID = s_c.SystemID 
			AND m_c.CompanyCentralID = s_c.CompanyID 
	INNER JOIN System_Addresses AS s_a 
		ON s_c.SystemID = s_a.SystemID 
			AND s_c.AddressID = s_a.AddressID 
	LEFT OUTER JOIN Master_Companies AS m_c_mc 
		ON m_c.SystemID = m_c_mc.SystemID 
			AND m_c.BpID = m_c_mc.BpID 
			AND m_c.ParentID = m_c_mc.CompanyID
WHERE m_c.SystemID = @SystemID 
	AND m_c.BpID = @BpID 
	AND m_c.CompanyID = (CASE WHEN @CompanyID = 0 THEN m_c.CompanyID ELSE @CompanyID END)