CREATE FUNCTION [dbo].[HasSubcontractors]
(
	@SystemID int,
	@BpID int,
	@CompanyID int
)
RETURNS INT
AS
BEGIN
	DECLARE @RowCount int = 0;
	
	SELECT @RowCount = COUNT(CompanyID)
	FROM Master_Companies
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND ParentID = @CompanyID;

	IF (@RowCount > 0)
		SET @RowCount = 1;

	RETURN @RowCount;
END
