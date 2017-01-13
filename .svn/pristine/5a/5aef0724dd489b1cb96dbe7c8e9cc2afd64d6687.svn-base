CREATE PROCEDURE [dbo].[GetTradeContainerManagement]
	@SystemID int,
	@BpID int,
	@TradeID int
AS
SELECT
	m_t.SystemID,
	m_t.BpID,
	m_t.TradeID,
	m_t.NameVisible,
	m_t.DescriptionShort,
	m_bp.ContainerManagementName
FROM Master_Trades AS m_t
	INNER JOIN Master_BuildingProjects AS m_bp
		ON m_t.SystemID = m_bp.SystemID
			AND m_t.BpID = m_bp.BpID
WHERE m_t.SystemID = @SystemID 
	AND m_t.BpID = @BpID 
	AND m_t.TradeID = CASE WHEN @TradeID = 0 THEN m_t.TradeID ELSE @TradeID END
	AND m_bp.ContainerManagementName IS NOT NULL 
	AND m_bp.ContainerManagementName <> ''
