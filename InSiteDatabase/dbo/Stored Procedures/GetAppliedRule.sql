CREATE PROCEDURE [dbo].[GetAppliedRule]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int
)
AS

DECLARE @RuleID int = 0

SELECT 
	@RuleID = ISNULL(mdcr.CheckingRuleID, 0)
FROM Master_Employees AS me 
	INNER JOIN Master_Addresses AS ma 
		ON me.SystemID = ma.SystemID 
			AND me.BpID = ma.BpID 
			AND me.AddressID = ma.AddressID 
	INNER JOIN Master_Companies AS mcom 
		ON me.SystemID = mcom.SystemID 
			AND me.BpID = mcom.BpID 
			AND me.CompanyID = mcom.CompanyID 
	INNER JOIN System_Companies AS sc 
		ON mcom.SystemID = sc.SystemID 
			AND mcom.CompanyCentralID = sc.CompanyID 
	INNER JOIN System_Addresses AS sa 
		ON sc.SystemID = sa.SystemID 
			AND sc.AddressID = sa.AddressID 
	INNER JOIN Master_Countries AS mc1 
		ON ma.SystemID = mc1.SystemID 
			AND ma.BpID = mc1.BpID 
			AND ma.NationalityID = mc1.CountryID 
	INNER JOIN Master_DocumentCheckingRules AS mdcr 
		ON mc1.CountryGroupID = mdcr.CountryGroupIDEmployee 
			AND mc1.SystemID = mdcr.SystemID 
			AND mc1.BpID = mdcr.BpID 
			AND me.EmploymentStatusID = mdcr.EmploymentStatusID
	INNER JOIN Master_Countries AS mc2 
		ON sa.SystemID = mc2.SystemID 
			AND sa.CountryID = mc2.CountryID 
			AND me.BpID = mc2.BpID 
			AND mdcr.SystemID = mc2.SystemID 
			AND mdcr.BpID = mc2.BpID 
			AND mdcr.CountryGroupIDEmployer = mc2.CountryGroupID
WHERE me.SystemID = @SystemID 
	AND me.BpID = @BpID 
	AND me.EmployeeID = @EmployeeID

SELECT @RuleID
