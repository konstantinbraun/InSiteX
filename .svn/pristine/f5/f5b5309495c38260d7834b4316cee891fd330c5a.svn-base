CREATE PROCEDURE [dbo].[GetAccessRightEventsExtended]
(
	@SystemID int,
	@BpID int,
	@ChangesSince datetime
)
AS

SELECT 
	d_are.SystemID,
	d_are.BpID,
	d_are.AccessRightEventID,
	d_are.PassID,
	d_are.PassType,
	d_are.ExternalID, 
	d_are.OwnerID,
	d_are.IsActive,
	d_are.ValidUntil,
	d_are.AccessAllowed,
	d_are.AccessDenialReason,
	d_are.[Message],
	d_are.MessageFrom,
	d_are.MessageUntil,
	d_are.CreatedFrom,
	d_are.CreatedOn,
	d_are.EditFrom,
	d_are.EditOn,
	d_are.IsDelivered,
	d_are.DeliveredAt,
	d_are.DeliveryMessage,
	d_are.IsNewest,
	d_are.HasSubstitute,
	m_p.InternalID, 
	m_a.FirstName, 
	m_a.LastName, 
	m_c.NameVisible AS CompanyName, 
	m_t.NameVisible AS TradeName, 
	m_a.LanguageID,
	NULL AS PhotoData,
	m_a.PhotoFileName 
FROM Data_AccessRightEvents d_are
	LEFT OUTER JOIN Master_Passes m_p
		ON m_p.SystemID = d_are.SystemID
			AND m_p.BpID = d_are.BpID
			AND m_p.PassID = d_are.PassID
	LEFT OUTER JOIN Master_Employees m_e
		ON d_are.SystemID = m_e.SystemID
			AND d_are.BpID = m_e.BpID
			AND d_are.OwnerID = m_e.EmployeeID
	LEFT OUTER JOIN Master_Companies m_c
		ON m_e.SystemID = m_c.SystemID
			AND m_e.BpID = m_c.BpID
			AND m_e.CompanyID = m_c.CompanyID
	LEFT OUTER JOIN Master_Trades m_t
		ON m_e.SystemID = m_t.SystemID
			AND m_e.BpID = m_t.BpID
			AND m_e.TradeID = m_t.TradeID
	LEFT OUTER JOIN Master_Addresses m_a
		ON m_e.SystemID = m_a.SystemID		
			AND m_e.BpID = m_a.BpID		
			AND m_e.AddressID = m_a.AddressID
WHERE d_are.SystemID = @SystemID
	AND d_are.BpID = @BpID
	AND d_are.IsNewest = 1
	AND d_are.PassType = 1
	AND d_are.CreatedOn > @ChangesSince

UNION

SELECT 
	d_are.SystemID,
	d_are.BpID,
	d_are.AccessRightEventID,
	d_are.PassID,
	d_are.PassType,
	d_stp.ShortTermPassID AS ExternalID, 
	d_are.OwnerID,
	d_are.IsActive,
	d_are.ValidUntil,
	d_are.AccessAllowed,
	d_are.AccessDenialReason,
	d_are.[Message],
	d_are.MessageFrom,
	d_are.MessageUntil,
	d_are.CreatedFrom,
	d_are.CreatedOn,
	d_are.EditFrom,
	d_are.EditOn,
	d_are.IsDelivered,
	d_are.DeliveredAt,
	d_are.DeliveryMessage,
	d_are.IsNewest,
	d_are.HasSubstitute,
	d_stp.InternalID, 
	d_stv.FirstName, 
	d_stv.LastName, 
	d_stv.Company AS CompanyName, 
	'' AS TradeName, 
	d_stv.NationalityID AS LanguageID,
	NULL AS PhotoData,
	'' AS PhotoFileName 
FROM Data_AccessRightEvents d_are
	LEFT OUTER JOIN Master_Passes m_p
		ON m_p.SystemID = d_are.SystemID
			AND m_p.BpID = d_are.BpID
			AND m_p.PassID = d_are.PassID
	LEFT OUTER JOIN Data_ShortTermVisitors d_stv
		ON d_are.SystemID = d_stv.SystemID
			AND d_are.BpID = d_stv.BpID
			AND d_are.OwnerID = d_stv.ShortTermVisitorID
			AND d_are.PassID = d_stv.ShortTermPassID
	LEFT OUTER JOIN Data_ShortTermPasses AS d_stp 
		ON d_stv.SystemID = d_stp.SystemID 
			AND d_stv.BpID = d_stp.BpID 
			AND d_stv.ShortTermPassID = d_stp.ShortTermPassID
WHERE d_are.SystemID = @SystemID
	AND d_are.BpID = @BpID
	AND d_are.IsNewest = 1
	AND d_are.PassType = 2
	AND d_are.CreatedOn > @ChangesSince
ORDER BY d_are.AccessRightEventID DESC
