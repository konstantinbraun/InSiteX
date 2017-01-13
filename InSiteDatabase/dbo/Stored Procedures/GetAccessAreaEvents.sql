CREATE PROCEDURE [dbo].[GetAccessAreaEvents]
(
	@SystemID int,
	@BpID int,
	@AccessRightEventID int
)
AS

SELECT d_aae.*, m_aa.NameVisible AccessAreaName, m_ts.NameVisible TimeSlotName 
FROM Data_AccessAreaEvents d_aae
	INNER JOIN Master_AccessAreas m_aa
		ON m_aa.SystemID = d_aae.SystemID
			AND m_aa.BpID = d_aae.BpID
			AND m_aa.AccessAreaID = d_aae.AccessAreaID
	LEFT OUTER JOIN Master_TimeSlots m_ts
		ON m_ts.SystemID = d_aae.SystemID
			AND m_ts.BpID = d_aae.BpID
			AND m_ts.TimeSlotID = d_aae.TimeSlotID
WHERE d_aae.SystemID = @SystemID
	AND d_aae.BpID = @BpID
	AND d_aae.AccessRightEventID = @AccessRightEventID
	AND d_aae.ValidUntil >= DATEADD(D, -2, CAST(SYSDATETIME() AS smalldatetime))  
