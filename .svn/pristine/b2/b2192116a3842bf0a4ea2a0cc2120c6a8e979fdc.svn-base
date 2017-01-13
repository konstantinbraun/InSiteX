CREATE PROCEDURE [dbo].[GetEmployeesWithTimeSlot]
(
	@SystemID int,
	@BpID int,
	@TimeSlotID int 
)
AS

SELECT DISTINCT
	m_ts.TimeSlotGroupID,
	m_eaa.EmployeeID
FROM Master_TimeSlots m_ts
	INNER JOIN Master_EmployeeAccessAreas m_eaa
		ON m_ts.SystemID = m_eaa.SystemID
			AND m_ts.BpID = m_eaa.BpID
			AND m_ts.TimeSlotGroupID = m_eaa.TimeSlotGroupID
WHERE m_ts.SystemID = @SystemID
	AND m_ts.BpID = @BpID
	AND m_ts.TimeSlotID = @TimeSlotID
	AND m_ts.ValidUntil >= DATEADD(D, -8, CAST(SYSDATETIME() AS smalldatetime))
