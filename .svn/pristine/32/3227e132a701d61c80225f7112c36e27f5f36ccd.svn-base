CREATE FUNCTION [dbo].[GetQualification]
(
	-- Add the parameters for the function here
	@SystemId INT,
	@BpId INT,
	@EmployeeId INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Qualification NVARCHAR(MAX)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Qualification = COALESCE(@Qualification + ', ','')  + SF.NameVisible  
	FROM 
		Master_StaffRoles AS SF INNER JOIN
		Master_EmployeeQualification AS EQ ON SF.BpID = EQ.BpID AND SF.SystemID = EQ.SystemID AND SF.StaffRoleID = EQ.StaffRoleID 
	WHERE
		EQ.EmployeeID = @EmployeeID AND EQ.BpID = @BpId AND EQ.SystemID = @SystemId
		

	-- Return the result of the function
	RETURN @Qualification

END
