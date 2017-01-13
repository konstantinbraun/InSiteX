CREATE PROCEDURE [dbo].[GetStatistics]
(
	@SystemID int,
	@BpID int,
	@StatisticsDate date,
	@EvaluationPeriod int
)

AS

IF (@EvaluationPeriod = 7)
	-- Nur letzter Tag
	SET @StatisticsDate = CAST(DATEADD(DAY, -1, SYSDATETIME()) AS date);
;

SELECT
	d_s.SystemID, 
	d_s.BfID,
	d_s.BpID,
	m_bp.NameVisible,
	m_bp.DescriptionShort,
	m_bp.BuilderName,
	d_s.StatisticsDate,
	d_s.AssignedEmployees,
	d_s.AccessEventsCount,
	d_s.LastCompression,
	d_s.LastCorrection,
	d_s.CorrectedEvents,
	d_s.ReplacementPasses,
	d_s.MaximumPresentTime,
	d_s.PresentOvernight, 
	d_s.SnapshotTimestamp
FROM Data_Statistics AS d_s
	INNER JOIN Master_BuildingProjects AS m_bp
		ON d_s.SystemID = m_bp.SystemID
			AND d_s.BpID = m_bp.BpID
WHERE d_s.SystemID = @SystemID
	AND d_s.BpID = @BpID
	AND d_s.StatisticsDate = @StatisticsDate

UNION

SELECT
	d_s.SystemID, 
	d_s.BfID,
	d_s.BpID,
	m_bp.NameVisible,
	m_bp.DescriptionShort,
	m_bp.BuilderName,
	d_s.StatisticsDate,
	d_s.AssignedEmployees,
	d_s.AccessEventsCount,
	d_s.LastCompression,
	d_s.LastCorrection,
	d_s.CorrectedEvents,
	d_s.ReplacementPasses,
	d_s.MaximumPresentTime,
	d_s.PresentOvernight, 
	d_s.SnapshotTimestamp
FROM Data_Statistics AS d_s
	INNER JOIN Master_BuildingProjects AS m_bp
		ON d_s.SystemID = m_bp.SystemID
			AND d_s.BpID = m_bp.BpID
WHERE d_s.SystemID = @SystemID
	AND d_s.BpID = @BpID
	AND d_s.StatisticsDate = CAST(DATEADD(DAY, -1, CAST(@StatisticsDate AS datetime)) AS date)
;
