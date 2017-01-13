CREATE PROCEDURE [dbo].[GetShortTermPassPrintData]
(
	@SystemID int,
	@BpID int,
	@UserName nvarchar(50)
)
AS
SELECT        
	d_stp.ShortTermPassID, 
	m_stp.NameVisible AS TypeName, 
	d_stp.StatusID, 
	d_stp.InternalID, 
	@UserName AS PrintedFrom, 
	SYSDATETIME() AS PrintedOn
FROM Data_ShortTermPasses AS d_stp 
	INNER JOIN Master_ShortTermPassTypes AS m_stp 
		ON d_stp.SystemID = m_stp.SystemID 
			AND d_stp.BpID = m_stp.BpID 
			AND d_stp.ShortTermPassTypeID = m_stp.ShortTermPassTypeID
WHERE d_stp.SystemID = @SystemID 
	AND d_stp.BpID = @BpID
	AND d_stp.CreatedFrom = @UserName
	AND d_stp.PrintedOn IS NULL

UPDATE Data_ShortTermPasses
SET PrintedFrom = @UserName,
	PrintedOn = SYSDATETIME()
WHERE SystemID = @SystemID 
	AND BpID = @BpID
	AND CreatedFrom = @UserName
	AND PrintedOn IS NULL
