CREATE FUNCTION [dbo].[EndOfMonth]
(
	@DateInMonth datetime
)
RETURNS date
AS
BEGIN
	DECLARE @EndOfMonth date = DATEADD(DAY, -1, DATEADD(MONTH, 1, dbo.BeginOfMonth(@DateInMonth)));
	RETURN @EndOfMonth;
END
