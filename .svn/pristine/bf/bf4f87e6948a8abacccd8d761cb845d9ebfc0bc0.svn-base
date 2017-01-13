CREATE PROCEDURE [dbo].[GetAccessRightEvents]
(
	@SystemID int,
	@BpID int,
	@OwnerID int = 0,
	@NewestOnly bit = 1
)
AS

SELECT 
	d_are.* ,
	m_p.InternalID 
FROM Data_AccessRightEvents d_are
	INNER JOIN Master_Passes m_p
		ON m_p.SystemID = d_are.SystemID
			AND m_p.BpID = d_are.BpID
			AND m_p.PassID = d_are.PassID
WHERE d_are.SystemID = @SystemID
	AND d_are.BpID = @BpID
	AND d_are.OwnerID = (CASE WHEN @OwnerID = 0 THEN d_are.OwnerID ELSE @OwnerID END)
	AND d_are.IsNewest = (CASE WHEN @NewestOnly = 1 THEN 1 ELSE d_are.IsNewest END)
	AND d_are.HasSubstitute = (CASE WHEN @NewestOnly = 1 THEN 0 ELSE d_are.IsNewest END)
