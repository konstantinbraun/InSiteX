CREATE PROCEDURE [dbo].[UpdateStatistics]
(
	@SystemID int,
	@BpID int = 0,
	@StatisticsDate date
)

AS

DECLARE @StatisticDateBegin datetime = CAST(@StatisticsDate AS datetime);
DECLARE @StatisticDateEnd datetime = DATEADD(SECOND, -1, DATEADD(DAY, 1, CAST(@StatisticsDate AS datetime)));

-- Bestehenden Statistik Datensatz löschen
DELETE FROM Data_Statistics
WHERE SystemID = @SystemID
	AND BpID = (CASE WHEN @BpID = 0 THEN BpID ELSE @BpID END)
	AND StatisticsDate = @StatisticsDate
;

-- Neuen Statistik Datensatz anlegen
INSERT INTO Data_Statistics
(
	SystemID, 
	BfID,
	BpID,
	StatisticsDate,
	AssignedEmployees,
	AccessEventsCount,
	CorrectedEvents,
	ReplacementPasses,
	MaximumPresentTime,
	PresentOvernight, 
	SnapshotTimestamp
)
SELECT
	SystemID,
	0,
	BpID,
	@StatisticsDate,
	0,
	0,
	0,
	0,
	0,
	0,
	SYSDATETIME()
FROM Master_BuildingProjects
WHERE SystemID = @SystemID
	AND BpID = (CASE WHEN @BpID = 0 THEN BpID ELSE @BpID END)
	AND IsVisible = 1
	AND NOT EXISTS
	(
		SELECT 1 
		FROM Data_Statistics
		WHERE SystemID = @SystemID
			AND BpID = (CASE WHEN @BpID = 0 THEN BpID ELSE @BpID END)
			AND StatisticsDate = @StatisticsDate
	)
;

-- Anzahl der dem BV zugeordneten Mitarbeiter
UPDATE Data_Statistics
SET AssignedEmployees = m_e.AssignedEmployees
FROM Data_Statistics AS d_s
	INNER JOIN 
	(
		SELECT
			SystemID,
			BpID, 
			COUNT(EmployeeID) AS AssignedEmployees
		FROM Master_Employees
		WHERE SystemID = @SystemID
			AND BpID = (CASE WHEN @BpID = 0 THEN BpID ELSE @BpID END)
			AND ReleaseBOn < @StatisticDateEnd
			AND LockedOn IS NULL
		GROUP BY
			SystemID,
			BpID 
	) AS m_e
		ON d_s.SystemID = m_e.SystemID
			AND d_s.BpID = m_e.BpID
WHERE d_s.SystemID = @SystemID
	AND d_s.BpID = (CASE WHEN @BpID = 0 THEN d_s.BpID ELSE @BpID END)
	AND d_s.StatisticsDate = @StatisticsDate
;

-- Anzahl der Zutrittsereignisse
UPDATE Data_Statistics
SET AccessEventsCount = d_ae.AccessEventsCount,
	CorrectedEvents = d_ae.CorrectedEvents
FROM Data_Statistics AS d_s
	INNER JOIN
	(
		SELECT 
			SystemID,
			BpID, 
			COUNT(AccessEventID) AS AccessEventsCount,
			SUM(CASE
					WHEN 
						IsOnlineAccessEvent = 0 
						AND IsManualEntry = 1 
						AND AddedBySystem = 1 
						AND CAST(AccessOn AS date) <> AccessOn
						AND NOT (DATEPART(HOUR, AccessOn) = 23 AND DATEPART(MINUTE, AccessOn) = 59 AND DATEPART(SECOND, AccessOn) = 59)  
					THEN 1 
					ELSE 0 
					END) AS CorrectedEvents
		FROM Data_AccessEvents 
		WHERE SystemID = @SystemID
			AND BpID = (CASE WHEN @BpID = 0 THEN BpID ELSE @BpID END)
			AND CAST(AccessOn AS date) = @StatisticsDate 
		GROUP BY
			SystemID,
			BpID 
	) AS d_ae
		ON d_s.SystemID = d_ae.SystemID
			AND d_s.BpID = d_ae.BpID
WHERE d_s.SystemID = @SystemID
	AND d_s.BpID = (CASE WHEN @BpID = 0 THEN d_s.BpID ELSE @BpID END)
	AND d_s.StatisticsDate = @StatisticsDate
;

-- Zeitpunkt der letzten Verdichtung der Zutrittsdaten
-- Zeitpunkt der letzten Korrektur der Zutrittsdaten
UPDATE Data_Statistics
SET LastCompression = m_as.LastCompress,
	LastCorrection = m_as.LastAddition
FROM Data_Statistics AS d_s
	INNER JOIN Master_AccessSystems m_as
		ON d_s.SystemID = m_as.SystemID
			AND d_s.BpID = m_as.BpID
WHERE d_s.SystemID = @SystemID
	AND d_s.BpID = (CASE WHEN @BpID = 0 THEN d_s.BpID ELSE @BpID END)
	AND d_s.StatisticsDate = @StatisticsDate
;
	
-- Anzahl der bereinigten Inkonsistenzen	
UPDATE Data_Statistics
SET CorrectedEvents = d_ae.CorrectionCount
FROM Data_Statistics AS d_s
	INNER JOIN
	(
		SELECT 
			SystemID,
			BpID, 
			COUNT(AccessEventID) AS CorrectionCount
		FROM Data_AccessEvents
		WHERE CorrectedOn BETWEEN @StatisticDateBegin AND @StatisticDateEnd
		GROUP BY
			SystemID,
			BpID 
	) AS d_ae
		ON d_s.SystemID = d_ae.SystemID
			AND d_s.BpID = d_ae.BpID
WHERE d_s.SystemID = @SystemID
	AND d_s.BpID = (CASE WHEN @BpID = 0 THEN d_s.BpID ELSE @BpID END)
	AND d_s.StatisticsDate = @StatisticsDate
;

-- Anzahl der Mitarbeiter mit Korrekturbuchungen wegen Überschreitung der maximalen Anwesenheitszeit		
UPDATE Data_Statistics
SET MaximumPresentTime = d_ae.MaximumPresentTimeCount
FROM Data_Statistics AS d_s
	INNER JOIN
	(
		SELECT 
			SystemID,
			BpID,
			COUNT(a.OwnerID) AS MaximumPresentTimeCount
		FROM
		(
			SELECT 
				SystemID, 
				BpID, 
				OwnerID
			FROM Data_AccessEvents
			WHERE PassType = 1
				AND CorrectedOn BETWEEN @StatisticDateBegin AND @StatisticDateEnd
				AND MaxPresentTimeExc = 1
			GROUP BY
				SystemID,
				BpID,
				OwnerID
		) AS a
		GROUP BY
			SystemID,
			BpID
	) AS d_ae
		ON d_s.SystemID = d_ae.SystemID
			AND d_s.BpID = d_ae.BpID
WHERE d_s.SystemID = @SystemID
	AND d_s.BpID = (CASE WHEN @BpID = 0 THEN d_s.BpID ELSE @BpID END)
	AND StatisticsDate = @StatisticsDate
;

-- Davon tagesübergreifend
UPDATE Data_Statistics
SET MaximumPresentTime = d_ae.MaximumPresentTimeCount
FROM Data_Statistics AS d_s
	INNER JOIN
	(
		SELECT 
			SystemID,
			BpID,
			COUNT(a.OwnerID) AS MaximumPresentTimeCount
		FROM
		(
			SELECT 
				SystemID, 
				BpID, 
				OwnerID
			FROM Data_AccessEvents
			WHERE PassType = 1
				AND CorrectedOn BETWEEN @StatisticDateBegin AND @StatisticDateEnd
				AND MaxPresentTimeExc = 1
				AND PresentOvernight = 1
			GROUP BY
				SystemID,
				BpID,
				OwnerID
		) AS a
		GROUP BY
			SystemID,
			BpID
	) AS d_ae
		ON d_s.SystemID = d_ae.SystemID
			AND d_s.BpID = d_ae.BpID
WHERE d_s.SystemID = @SystemID
	AND d_s.BpID = (CASE WHEN @BpID = 0 THEN d_s.BpID ELSE @BpID END)
	AND StatisticsDate = @StatisticsDate

-- Anzahl der ausgestellten Ersatzausweise
UPDATE Data_Statistics
SET ReplacementPasses = rp.CountPasses
FROM Data_Statistics AS d_s
	INNER JOIN
	(
		SELECT 
			d_ph.SystemID, 
			d_ph.BpID,
			COUNT(d_ph.PassID) AS CountPasses
		FROM Data_PassHistory AS d_ph 
			INNER JOIN Master_ReplacementPassCases AS m_rpc 
				ON d_ph.SystemID = m_rpc.SystemID 
				AND d_ph.BpID = m_rpc.BpID 
				AND d_ph.ReplacementPassCaseID = m_rpc.ReplacementPassCaseID
		WHERE d_ph.ActionID = 11 
			AND m_rpc.IsInitialIssue = 0 
			AND m_rpc.CreatedOn BETWEEN @StatisticDateBegin AND @StatisticDateEnd
		GROUP BY 
			d_ph.SystemID, 
			d_ph.BpID
	) AS rp
		ON d_s.SystemID = rp.SystemID
			AND d_s.BpID = rp.BpID
WHERE d_s.SystemID = @SystemID
	AND d_s.BpID = (CASE WHEN @BpID = 0 THEN d_s.BpID ELSE @BpID END)
	AND d_s.StatisticsDate = @StatisticsDate
;

DELETE Data_StatisticsAccessEvents
WHERE SystemID = @SystemID
	AND BpID = (CASE WHEN @BpID = 0 THEN BpID ELSE @BpID END)
	AND StatisticsDate = @StatisticsDate
;

-- Anzahl der Zutrittsereignisse differenziert nach Zutrittsbereich und Richtung
INSERT INTO Data_StatisticsAccessEvents
(
	SystemID,
	BfID,
	BpID,
	StatisticsDate,
	AccessAreaID,
	PassType,
	CountEnter,
	CountExit,
	SnapshotTimestamp
)
SELECT
	SystemID,
	BfID,
	BpID,
	@StatisticsDate,
	AccessAreaID,
	PassType,
	SUM(CASE WHEN AccessType = 1 THEN 1 ELSE 0 END),
	SUM(CASE WHEN AccessType = 0 THEN 1 ELSE 0 END),
	SYSDATETIME()
FROM Data_AccessEvents d_ae
WHERE d_ae.SystemID = @SystemID
	AND d_ae.BpID = @BpID
	AND AccessOn BETWEEN @StatisticDateBegin AND @StatisticDateEnd
	AND OwnerID > 0
	AND NOT EXISTS
	(
		SELECT 1
		FROM Data_StatisticsAccessEvents d_sae
		WHERE d_sae.SystemID = d_ae.SystemID
			AND d_sae.BfID = d_ae.BfID
			AND d_sae.BpID = d_ae.BpID
			AND d_sae.StatisticsDate = @StatisticsDate
			AND d_sae.AccessAreaID = d_ae.AccessAreaID
			AND d_sae.PassType = d_ae.PassType
	)
GROUP BY
	SystemID,
	BfID,
	BpID,
	AccessAreaID,
	PassType
;

-- Update der Terminalstatistik
UPDATE Data_StatisticsTerminals
SET EnterEvents = a.CountEnter,
	ExitEvents = a.CountExit,
	ErrorEvents = a.CountError
FROM Data_StatisticsTerminals d_st
	INNER JOIN 
	(
		SELECT 
			SystemID,
			BfID,
			BpID,
			AccessAreaID,
			EntryID,
			SUM(CASE WHEN AccessType = 1 AND AccessResult = 1 THEN 1 ELSE 0 END) AS CountEnter,
			SUM(CASE WHEN AccessType = 0 AND AccessResult = 1 THEN 1 ELSE 0 END) AS CountExit,
			SUM(CASE WHEN AccessResult = 0 THEN 1 ELSE 0 END) AS CountError
		FROM Data_AccessEvents d_ae
		WHERE SystemID = @SystemID
			AND BpID = (CASE WHEN @BpID = 0 THEN BpID ELSE @BpID END)
			AND AccessOn BETWEEN @StatisticDateBegin AND @StatisticDateEnd
			AND IsManualEntry = 0
			AND OwnerID > 0
		GROUP BY 
			SystemID,
			BfID,
			BpID,
			AccessAreaID,
			EntryID
	) AS a
		ON d_st.SystemID = a.SystemID
			AND d_st.BfID = a.BfID
			AND d_st.BpID = a.BpID
			AND d_st.AccessAreaID = a.AccessAreaID
			AND d_st.TerminalID = a.EntryID
WHERE d_st.SystemID = @SystemID
	AND d_st.BpID = (CASE WHEN @BpID = 0 THEN d_st.BpID ELSE @BpID END)
	AND d_st.StatisticsDate = @StatisticsDate
;

-- Neuanlage der Terminalstatistik, falls nicht vorhanden
INSERT INTO Data_StatisticsTerminals
(
	SystemID,
	BfID,
	BpID,
	StatisticsDate,
	AccessAreaID,
	TerminalID,
	OnlineTime,
	EnterEvents,
	ExitEvents,
	OnOffChanges,
	ErrorEvents,
	SnapshotTimestamp
)
SELECT
	SystemID,
	BfID,
	BpID,
	@StatisticsDate,
	AccessAreaID,
	EntryID,
	0,
	SUM(CASE WHEN AccessType = 1 AND AccessResult = 1 THEN 1 ELSE 0 END) AS CountEnter,
	SUM(CASE WHEN AccessType = 0 AND AccessResult = 1 THEN 1 ELSE 0 END) AS CountExit,
	0,
	SUM(CASE WHEN AccessResult = 0 THEN 1 ELSE 0 END) AS CountError,
	SYSDATETIME()
FROM Data_AccessEvents AS d_ae
WHERE SystemID = @SystemID
	AND BpID = (CASE WHEN @BpID = 0 THEN BpID ELSE @BpID END)
	AND AccessOn BETWEEN @StatisticDateBegin AND @StatisticDateEnd
	AND IsManualEntry = 0
	AND OwnerID > 0
	AND NOT EXISTS 
	(
		SELECT 1
		FROM Data_StatisticsTerminals AS d_st
		WHERE d_st.SystemID = d_ae.SystemID
			AND d_st.BfID = d_ae.BfID
			AND d_st.BpID = d_ae.BpID
			AND d_st.StatisticsDate = @StatisticsDate
			AND d_st.AccessAreaID = d_ae.AccessAreaID
			AND d_st.TerminalID = d_ae.EntryID
	)
GROUP BY 
	SystemID,
	BfID,
	BpID,
	AccessAreaID,
	EntryID
;

-- Update von OnOffChanges und OnlineTime vom Vortag
UPDATE Data_StatisticsTerminals
SET OnOffChanges = m_t.OnOffChangesLast,
	OnlineTime = m_t.OnlineTimeLast
FROM Data_StatisticsTerminals AS d_st
	INNER JOIN Master_Terminal AS m_t
		ON d_st.SystemID = m_t.SystemID
			AND d_st.BfID = m_t.BfID
			AND d_st.BpID = m_t.BpID
			AND d_st.TerminalID = m_t.TerminalID
WHERE d_st.SystemID = @SystemID
	AND d_st.BpID = (CASE WHEN @BpID = 0 THEN d_st.BpID ELSE @BpID END)
	AND d_st.StatisticsDate BETWEEN @StatisticDateBegin AND @StatisticDateEnd
	AND m_t.StatusTimestampLast BETWEEN @StatisticDateBegin AND @StatisticDateEnd
;
