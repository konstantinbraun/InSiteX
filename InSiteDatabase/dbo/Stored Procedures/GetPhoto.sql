CREATE PROCEDURE [dbo].[GetPhoto]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int
)
AS

SELECT
	m_a.PhotoFileName,
	m_a.PhotoData
FROM Master_Employees m_e
	INNER JOIN Master_Addresses m_a
		ON m_e.SystemID = m_a.SystemID
			AND m_e.BpID = m_a.BpID
			AND m_e.AddressID = m_a.AddressID
WHERE m_e.SystemID = @SystemID
	AND m_e.BpID = @BpID
	AND m_e.EmployeeID = @EmployeeID