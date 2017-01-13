CREATE PROCEDURE [dbo].[GetStatisticsTerminals]
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
	d_st.SystemID,
	d_st.BfID,
	d_st.BpID,
	d_st.StatisticsDate,
	d_st.AccessAreaID,
	m_aa.NameVisible AS AccessAreaName,
	m_aa.DescriptionShort,
	d_st.TerminalID,
	m_t.NameVisible AS TerminalName,
	m_t.FirmwareVersion,
	m_t.SoftwareVersion,
	d_st.OnlineTime,
	d_st.EnterEvents,
	d_st.ExitEvents,
	d_st.OnOffChanges,
	d_st.ErrorEvents,
	d_st.SnapshotTimestamp,
	m_t.TerminalType,
	m_t.IsActivated
FROM Data_StatisticsTerminals AS d_st
	INNER JOIN Master_Terminal AS m_t
		ON d_st.SystemID = m_t.SystemID
			AND d_st.BfID = m_t.BfID
			AND d_st.BpID = m_t.BpID
			AND d_st.TerminalID = m_t.TerminalID
	INNER JOIN Master_AccessAreas AS m_aa
		ON d_st.SystemID = m_aa.SystemID
			AND d_st.BpID = m_aa.BpID
			AND d_st.AccessAreaID = m_aa.AccessAreaID
WHERE d_st.SystemID = @SystemID
	AND d_st.BpID = @BpID
	AND d_st.StatisticsDate = @StatisticsDate

UNION

SELECT
	d_st.SystemID,
	d_st.BfID,
	d_st.BpID,
	d_st.StatisticsDate,
	d_st.AccessAreaID,
	m_aa.NameVisible AS AccessAreaName,
	m_aa.DescriptionShort,
	d_st.TerminalID,
	m_t.NameVisible AS TerminalName,
	m_t.FirmwareVersion,
	m_t.SoftwareVersion,
	d_st.OnlineTime,
	d_st.EnterEvents,
	d_st.ExitEvents,
	d_st.OnOffChanges,
	d_st.ErrorEvents,
	d_st.SnapshotTimestamp,
	m_t.TerminalType,
	m_t.IsActivated
FROM Data_StatisticsTerminals AS d_st
	INNER JOIN Master_Terminal AS m_t
		ON d_st.SystemID = m_t.SystemID
			AND d_st.BfID = m_t.BfID
			AND d_st.BpID = m_t.BpID
			AND d_st.TerminalID = m_t.TerminalID
	INNER JOIN Master_AccessAreas AS m_aa
		ON d_st.SystemID = m_aa.SystemID
			AND d_st.BpID = m_aa.BpID
			AND d_st.AccessAreaID = m_aa.AccessAreaID
WHERE d_st.SystemID = @SystemID
	AND d_st.BpID = @BpID
	AND d_st.StatisticsDate = CAST(DATEADD(DAY, -1, CAST(@StatisticsDate AS datetime)) AS date)
;
