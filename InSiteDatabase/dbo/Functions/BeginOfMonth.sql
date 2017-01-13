CREATE FUNCTION [dbo].[BeginOfMonth]
(
	@DateInMonth datetime
)
RETURNS date

AS

BEGIN
	DECLARE @BeginOfMonth date = DATEFROMPARTS(YEAR(@DateInMonth), MONTH(@DateInMonth), 1);
	RETURN @BeginOfMonth;
END
