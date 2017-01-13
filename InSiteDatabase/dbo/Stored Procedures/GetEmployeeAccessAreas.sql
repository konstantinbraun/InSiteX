CREATE PROCEDURE [dbo].[GetEmployeeAccessAreas]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int = 0
)
AS

SELECT
	m_eaa.SystemID,
	m_eaa.BpID,
	m_eaa.AccessAreaID,
	m_eaa.TimeSlotGroupID,
	m_eaa.AdditionalRights,
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
	m_ts.ValidFrom,
	m_ts.ValidUntil,
	m_ts.ValidDays,
	m_ts.TimeFrom,
	m_ts.TimeUntil
FROM Master_EmployeeAccessAreas m_eaa
	INNER JOIN Master_AccessAreas m_aa
		ON m_eaa.SystemID = m_aa.SystemID
			AND m_eaa.BpID = m_aa.BpID
			AND m_eaa.AccessAreaID = m_aa.AccessAreaID
	INNER JOIN Master_TimeSlots m_ts
		ON m_eaa.SystemID = m_ts.SystemID
			AND m_eaa.BpID = m_ts.BpID
			AND m_eaa.TimeSlotGroupID = m_ts.TimeSlotGroupID
WHERE m_eaa.SystemID = @SystemID
	AND m_eaa.BpID = @BpID	  
	AND m_eaa.EmployeeID = @EmployeeID	
	AND m_ts.ValidUntil >= DATEADD(DAY, -7, SYSDATETIME())  
