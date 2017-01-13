CREATE PROCEDURE [dbo].[GetEmployeeAccessArea]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int
)
AS

	SELECT
		aa.NameVisible AS AccessAreaName
	FROM Master_EmployeeAccessAreas eaa, Master_AccessAreas aa
	WHERE eaa.SystemID = @SystemID
		AND eaa.BpID = @BpID
		AND eaa.EmployeeID = @EmployeeID
		AND aa.SystemID = eaa.SystemID
		AND aa.BpID = eaa.BpID
		AND aa.AccessAreaID = eaa.AccessAreaID

RETURN 0