CREATE PROCEDURE [dbo].[GetEmployeeQualification]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int
)
AS

	SELECT
		sr.NameVisible AS QualificationName
	FROM Master_EmployeeQualification eq, Master_StaffRoles sr
	WHERE eq.SystemID = @SystemID
		AND eq.BpID = @BpID
		AND eq.EmployeeID = @EmployeeID
		AND sr.SystemID = eq.SystemID
		AND sr.BpID = eq.BpID
		AND sr.StaffRoleID = eq.StaffRoleID

RETURN 0