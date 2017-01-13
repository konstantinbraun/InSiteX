CREATE PROCEDURE [dbo].[ConsiderMaxPresence]
(
	@SystemID int,
	@BpID int
)
AS

INSERT INTO Data_AccessEvents 
(
	SystemID, 
	BfID, 
	BpID, 
	AccessAreaID, 
	EntryID, 
	PoeID, 
	OwnerID, 
	InternalID, 
	IsOnlineAccessEvent, 
	AccessOn, 
	AccessType, 
	AccessResult, 
	MessageShown, 
	DenialReason, 
	IsManualEntry, 
	CountIt, 
	Remark, 
	CreatedOn, 
	CreatedFrom, 
	EditOn, 
	EditFrom, 
	PassType,
	AddedBySystem
)
SELECT
	d_ae.SystemID, 
	d_ae.BfID, 
	d_ae.BpID, 
	d_ae.AccessAreaID, 
	d_ae.EntryID, 
	d_ae.PoeID, 
	d_ae.OwnerID, 
	d_ae.InternalID, 
	0 AS IsOnlineAccessEvent, 
	DATEADD(MINUTE, CAST(m_aa.PresentTimeMinutes AS int), DATEADD(HOUR, CAST(m_aa.PresentTimeHours AS int), d_ae.AccessOn)) AS AccessOn, 
	0 AS AccessType, 
	d_ae.AccessResult, 
	d_ae.MessageShown, 
	d_ae.DenialReason, 
	1 AS IsManualEntry, 
	d_ae.CountIt, 
	'Max present time exceeded' AS Remark, 
	SYSDATETIME() AS CreatedOn, 
	'System' AS CreatedFrom, 
	SYSDATETIME() AS EditOn, 
	'System' AS EditFrom, 
	d_ae.PassType,
	1 AS AddedBySystem
FROM Data_AccessEvents AS d_ae
	INNER JOIN
	(
		SELECT
			SystemID,
			BfID,
			BpID,
			AccessAreaID,
			OwnerID,
			InternalID,
			MAX(AccessOn) AS AccessOn
		FROM Data_AccessEvents 
		WHERE SystemID = @SystemID
			AND BfID = 0
			AND BpID = @BpID
			AND AccessResult = 1
			AND AccessOn >= DATEADD(DAY, -30, SYSDATETIME())
			AND NOT (DATEPART(HOUR, AccessOn) = 0 AND DATEPART(MINUTE, AccessOn) = 0 AND DATEPART(SECOND, AccessOn) = 0)
		GROUP BY
			SystemID,
			BfID,
			BpID,
			AccessAreaID,
			OwnerID,
			InternalID
	) AS d
		ON d_ae.SystemID = d.SystemID
			AND d_ae.BfID = d.BfID
			AND d_ae.BpID = d.BpID
			AND d_ae.AccessAreaID = d.AccessAreaID
			AND d_ae.OwnerID = d.OwnerID
			AND d_ae.InternalID = d.InternalID
			AND d_ae.AccessOn = d.AccessOn
	INNER JOIN Master_AccessAreas AS m_aa
		ON d_ae.SystemID = m_aa.SystemID
			AND d_ae.BpID = m_aa.BpID
			AND d_ae.AccessAreaID = m_aa.AccessAreaID
WHERE d_ae.SystemID = @SystemID
	AND d_ae.BfID = 0
	AND d_ae.BpID = @BpID
	AND d_ae.AccessType = 1
	AND d_ae.AccessOn >= DATEADD(DAY, -30, SYSDATETIME())
	AND d_ae.AccessOn < DATEADD(MINUTE, CAST(m_aa.PresentTimeMinutes AS int) * (-1), DATEADD(HOUR, CAST(m_aa.PresentTimeHours AS int) * (-1), SYSDATETIME()))
