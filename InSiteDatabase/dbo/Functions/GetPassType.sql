CREATE FUNCTION [dbo].[GetPassType]
(
	@SystemID int,
	@BpID int,
	@InternalID nvarchar(50),
	@OwnerID int
)

RETURNS INT

AS

BEGIN
	DECLARE @PassCount int = 0;
	DECLARE @PassType int = 0;

	SELECT @PassCount = COUNT(m_p.PassID)
	FROM Master_Passes m_p
	WHERE m_p.SystemID = @SystemID
		AND m_p.BpID = @BpID
		AND m_p.InternalID = @InternalID
		AND m_p.EmployeeID = @OwnerID
		AND m_p.ActivatedOn IS NOT NULL
	;

	IF (@PassCount = 0)
		BEGIN
			SELECT @PassCount = COUNT(d_stp.ShortTermPassID)
			FROM Data_ShortTermVisitors d_stp
			WHERE d_stp.SystemID = @SystemID
				AND d_stp.BpID = @BpID
				AND d_stp.PassInternalID = @InternalID
				AND d_stp.ShortTermVisitorID = @OwnerID
				AND d_stp.PassActivatedOn IS NOT NULL
			;

			IF (@PassCount > 0)
				SET @PassType = 2;
		END
	ELSE
		BEGIN
			SET @PassType = 1;
		END

	RETURN @PassType
END
