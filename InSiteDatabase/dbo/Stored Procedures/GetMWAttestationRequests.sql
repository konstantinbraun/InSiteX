CREATE PROCEDURE [dbo].[GetMWAttestationRequests]
(
	@SystemID int,
	@BpID int,
	@CompanyID int = 0,
	@RequestID int = 0
)

AS

SELECT 
	d_mwar.SystemID,
	d_mwar.BpID,
	d_mwar.RequestID,
	d_mwar.CompanyID,
	d_mwar.MWMonth,
	d_mwar.[FileName],
	d_mwar.FileType,
	(CASE WHEN @RequestID = 0 THEN NULL ELSE d_mwar.FileData END) AS FileData, 
	d_mwar.CreatedFrom,
	d_mwar.CreatedOn,
	m_c.NameVisible 
FROM Data_MWAttestationRequest AS d_mwar 
	INNER JOIN Master_Companies AS m_c 
		ON d_mwar.SystemID = m_c.SystemID 
			AND d_mwar.BpID = m_c.BpID 
			AND d_mwar.CompanyID = m_c.CompanyID 
WHERE d_mwar.SystemID = @SystemID 
	AND d_mwar.BpID = @BpID 
	AND d_mwar.CompanyID = (CASE WHEN @CompanyID = 0 THEN d_mwar.CompanyID ELSE @CompanyID END) 
	AND d_mwar.RequestID = (CASE WHEN @RequestID = 0 THEN d_mwar.RequestID ELSE @RequestID END) 
ORDER BY d_mwar.MWMonth DESC
