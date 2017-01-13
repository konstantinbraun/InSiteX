CREATE PROCEDURE [dbo].[HasValidDocumentRelevantFor]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int
)
AS

SELECT 
	m_erd.RelevantFor, 
	m_erd.DocumentReceived, 
	ISNULL(m_rd.IsAccessRelevant, 0) IsAccessRelevant,
	(CASE WHEN ISNULL(m_rd.IsAccessRelevant, 0) = 1 THEN m_erd.ExpirationDate ELSE NULL END) ExpirationDate, 
	ISNULL(m_rd.NameVisible, '') AS NameVisible, 
	s_rf.ResourceID 
FROM Master_EmployeeRelevantDocuments m_erd
	LEFT OUTER JOIN Master_RelevantDocuments m_rd
		ON m_rd.SystemID = m_erd.SystemID
			AND m_rd.BpID = m_erd.BpID
			AND m_rd.RelevantDocumentID = m_erd.RelevantDocumentID
	INNER JOIN System_RelevantFor s_rf
		ON s_rf.SystemID = m_erd.SystemID
			AND s_rf.RelevantFor = m_erd.RelevantFor
WHERE m_erd.SystemID = @SystemID
	AND m_erd.BpID = @BpID
	AND m_erd.EmployeeID = @EmployeeID
