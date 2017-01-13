CREATE PROCEDURE [dbo].[GetVisitorAccessAreas]
(
	@SystemID int,
	@BpID int,
	@ShortTermVisitorID int = 0
)
AS

SELECT
	d_staa.SystemID,
	d_staa.BpID,
	d_staa.AccessAreaID,
	d_staa.TimeSlotGroupID,
	d_staa.AdditionalRights,
	m_aa.NameVisible AS AccessAreaName,
	m_aa.AccessTimeRelevant,
	m_aa.CheckInCompelling,
	m_aa.UniqueAccess,
	m_aa.CheckOutCompelling,
	m_aa.CompleteAccessTimes,
	m_aa.PresentTimeHours,
	m_aa.PresentTimeMinutes,
	m_ts.TimeSlotID,
	m_ts.NameVisible AS TimeSlotName,
	SYSDATETIME() ValidFrom,
	d_stv.AccessAllowedUntil ValidUntil,
	m_ts.ValidDays,
	m_ts.TimeFrom,
	m_ts.TimeUntil
FROM Data_ShortTermAccessAreas d_staa
	INNER JOIN Data_ShortTermVisitors d_stv
		ON d_staa.SystemID = d_stv.SystemID
			AND d_staa.BpID = d_stv.BpID
			AND d_staa.ShortTermVisitorID = d_stv.ShortTermVisitorID
	INNER JOIN Master_AccessAreas m_aa
		ON d_staa.SystemID = m_aa.SystemID
			AND d_staa.BpID = m_aa.BpID
			AND d_staa.AccessAreaID = m_aa.AccessAreaID
	INNER JOIN Master_TimeSlots m_ts
		ON d_staa.SystemID = m_ts.SystemID
			AND d_staa.BpID = m_ts.BpID
			AND d_staa.TimeSlotGroupID = m_ts.TimeSlotGroupID
WHERE d_staa.SystemID = @SystemID
	AND d_staa.BpID = @BpID
	AND d_staa.ShortTermVisitorID = (CASE WHEN @ShortTermVisitorID = 0 THEN d_staa.ShortTermVisitorID ELSE @ShortTermVisitorID END)

