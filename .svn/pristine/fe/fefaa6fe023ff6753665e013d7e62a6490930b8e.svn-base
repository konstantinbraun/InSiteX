CREATE FUNCTION [dbo].[IsFirstAider]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int
)
RETURNS bit

AS

BEGIN
	DECLARE @IsFA bit = 0
	DECLARE @FACount int = 0

	SELECT @FACount = COUNT(m_sr.IsFirstAider)
	FROM Master_EmployeeQualification AS m_eq 
		INNER JOIN Master_StaffRoles AS m_sr 
			ON m_eq.SystemID = m_sr.SystemID 
				AND m_eq.BpID = m_sr.BpID 
				AND m_eq.StaffRoleID = m_sr.StaffRoleID
	WHERE m_eq.SystemID = @SystemID 
		AND m_eq.BpID = @BpID 
		AND m_eq.EmployeeID = @EmployeeID
		AND m_sr.IsFirstAider = 1 
		AND m_sr.IsVisible = 1 

	IF (@@ROWCOUNT > 0)
		SET @IsFA = 1
	ELSE
		SET @IsFA = 0

	RETURN @IsFA
END
