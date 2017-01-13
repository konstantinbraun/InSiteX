CREATE PROCEDURE [dbo].[GetPresentPersonsCount]
	@SystemID int,
	@BpID int
AS

DECLARE @EmployeesCount int
DECLARE @EmployeesFaultyCount int
DECLARE @VisitorCount int
DECLARE @VisitorFaultyCount int
DECLARE @LastUpdate datetime
DECLARE @LastAccess datetime
DECLARE @LastExit datetime

DECLARE @PresenceDay date = CAST(SYSDATETIME() AS date)
DECLARE @EndOfDay datetime = DATEADD(d, 1, @PresenceDay);
SET @EndOfDay = DATEADD(s, -1, @EndOfDay);

SELECT @EmployeesCount = COUNT(m_e.EmployeeID)
		FROM Master_Employees m_e 
			INNER JOIN Master_Passes m_p
				ON m_p.SystemID = m_e.SystemID
					AND m_p.BpID = m_e.BpID
					AND m_p.EmployeeID = m_e.EmployeeID
			INNER JOIN Data_AccessEvents d_ae
				ON m_e.EmployeeID = d_ae.OwnerID
		WHERE m_e.SystemID = @SystemID 
			AND m_e.BpID = @BpID
			AND m_p.ActivatedOn IS NOT NULL
			AND m_p.DeActivatedOn IS NULL
			AND m_p.LockedOn IS NULL
			AND dbo.EmployeePresentState(m_e.SystemID, m_e.BpID, m_e.EmployeeID) = 1
			AND d_ae.AccessOn BETWEEN CAST(@PresenceDay AS datetime) AND @EndOfDay
			
SELECT @EmployeesFaultyCount = COUNT(m_e.EmployeeID)
		FROM Master_Employees m_e 
			INNER JOIN Master_Passes m_p
				ON m_p.SystemID = m_e.SystemID
					AND m_p.BpID = m_e.BpID
					AND m_p.EmployeeID = m_e.EmployeeID
			INNER JOIN Data_AccessEvents d_ae
				ON m_e.EmployeeID = d_ae.OwnerID
		WHERE m_e.SystemID = @SystemID 
			AND m_e.BpID = @BpID
			AND m_p.ActivatedOn IS NOT NULL
			AND m_p.DeActivatedOn IS NULL
			AND m_p.LockedOn IS NULL
			AND dbo.EmployeePresentState(m_e.SystemID, m_e.BpID, m_e.EmployeeID) = 2
			AND d_ae.AccessOn BETWEEN CAST(@PresenceDay AS datetime) AND @EndOfDay

SELECT @VisitorCount = COUNT(d_stv.ShortTermVisitorID)
FROM Data_ShortTermVisitors d_stv 
	INNER JOIN Data_ShortTermPasses d_stp
		ON d_stv.SystemID = d_stp.SystemID
			AND d_stv.BpID = d_stp.BpID
			AND d_stv.ShortTermPassID = d_stp.ShortTermPassID
			INNER JOIN Data_AccessEvents d_ae
				ON d_stv.ShortTermVisitorID = d_ae.OwnerID
WHERE d_stv.SystemID = @SystemID 
	AND d_stv.BpID = @BpID
	AND d_stv.PassActivatedOn IS NOT NULL
	AND d_stv.PassDeActivatedOn IS NULL
	AND d_stv.PassLockedOn IS NULL
	AND dbo.ShortTermPresentState(d_stv.SystemID, d_stv.BpID, d_stv.ShortTermVisitorID) = 1
	AND d_ae.AccessOn BETWEEN CAST(@PresenceDay AS datetime) AND @EndOfDay

SELECT @VisitorFaultyCount = COUNT(d_stv.ShortTermVisitorID)
FROM Data_ShortTermVisitors d_stv 
	INNER JOIN Data_ShortTermPasses d_stp
		ON d_stv.SystemID = d_stp.SystemID
			AND d_stv.BpID = d_stp.BpID
			AND d_stv.ShortTermPassID = d_stp.ShortTermPassID
			INNER JOIN Data_AccessEvents d_ae
				ON d_stv.ShortTermVisitorID = d_ae.OwnerID
WHERE d_stv.SystemID = @SystemID 
	AND d_stv.BpID = @BpID
	AND d_stv.PassActivatedOn IS NOT NULL
	AND d_stv.PassDeActivatedOn IS NULL
	AND d_stv.PassLockedOn IS NULL
	AND dbo.ShortTermPresentState(d_stv.SystemID, d_stv.BpID, d_stv.ShortTermVisitorID) = 2
	AND d_ae.AccessOn BETWEEN CAST(@PresenceDay AS datetime) AND @EndOfDay

SELECT @LastUpdate = LastUpdate
FROM Master_AccessSystems
WHERE SystemID = @SystemID 
	AND BpID = @BpID

SELECT @LastAccess = MAX(AccessOn)
FROM Data_AccessEvents
WHERE SystemID = @SystemID 
	AND BpID = @BpID
	AND AccessType = 1
	AND AccessResult = 1

SELECT @LastExit = MAX(AccessOn)
FROM Data_AccessEvents
WHERE SystemID = @SystemID 
	AND BpID = @BpID
	AND AccessType = 0
	AND AccessResult = 1

SELECT 
	ISNULL(@EmployeesCount, 0) AS EmployeesCount, 
	ISNULL(@VisitorCount, 0) AS VisitorCount, 
	ISNULL(@EmployeesFaultyCount, 0) AS EmployeesFaultyCount, 
	ISNULL(@VisitorFaultyCount, 0) AS VisitorFaultyCount,
	@LastUpdate AS LastUpdate,
	@LastAccess AS LastAccess,
	@LastExit AS LastExit
