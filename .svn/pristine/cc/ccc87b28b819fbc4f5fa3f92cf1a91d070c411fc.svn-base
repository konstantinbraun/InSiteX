CREATE PROCEDURE [dbo].[GetStatisticsAccessEvents]
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
	d_sae.SystemID,
	d_sae.BfID,
	d_sae.BpID,
	d_sae.StatisticsDate,
	d_sae.AccessAreaID,
	m_aa.NameVisible,
	m_aa.DescriptionShort,
	d_sae.PassType,
	d_sae.CountEnter,
	d_sae.CountExit,
	d_sae.SnapshotTimestamp
FROM Data_StatisticsAccessEvents AS d_sae
	INNER JOIN Master_AccessAreas AS m_aa
		ON d_sae.SystemID = m_aa.SystemID
			AND d_sae.BpID = m_aa.BpID
			AND d_sae.AccessAreaID = m_aa.AccessAreaID
WHERE d_sae.SystemID = @SystemID
	AND d_sae.BpID = @BpID
	AND d_sae.StatisticsDate = @StatisticsDate

UNION

SELECT 
	d_sae.SystemID,
	d_sae.BfID,
	d_sae.BpID,
	d_sae.StatisticsDate,
	d_sae.AccessAreaID,
	m_aa.NameVisible,
	m_aa.DescriptionShort,
	d_sae.PassType,
	d_sae.CountEnter,
	d_sae.CountExit,
	d_sae.SnapshotTimestamp
FROM Data_StatisticsAccessEvents AS d_sae
	INNER JOIN Master_AccessAreas AS m_aa
		ON d_sae.SystemID = m_aa.SystemID
			AND d_sae.BpID = m_aa.BpID
			AND d_sae.AccessAreaID = m_aa.AccessAreaID
WHERE d_sae.SystemID = @SystemID
	AND d_sae.BpID = @BpID
	AND d_sae.StatisticsDate = CAST(DATEADD(DAY, -1, CAST(@StatisticsDate AS datetime)) AS date)
;