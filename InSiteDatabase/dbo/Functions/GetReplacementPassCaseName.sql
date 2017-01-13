CREATE FUNCTION [dbo].[GetReplacementPassCaseName]
(
	@SystemID int,
	@BpID int,
	@ReplacementPassCaseID int
)
RETURNS INT
AS

BEGIN
	DECLARE @CaseName nvarchar(50);
	SELECT @CaseName = NameVisible
	FROM Master_ReplacementPassCases
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND ReplacementPassCaseID = @ReplacementPassCaseID
	IF (@CaseName IS NULL OR @CaseName = '')
		SET @CaseName = 'Erstaustellung / First issue'
	RETURN @CaseName
END
