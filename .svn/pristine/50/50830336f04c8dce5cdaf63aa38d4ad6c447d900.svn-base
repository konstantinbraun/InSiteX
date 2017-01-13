CREATE PROCEDURE [dbo].[GetParentCustomers]
(
	@SystemID int,
	@BpID int,
	@CompanyID int
)
AS
WITH Companies 
(
	SystemID, 
	BpID, 
	CompanyID, 
	CompanyCentralID, 
	LockedOn, 
	LockSubContractors,
	ParentID
) 
AS 
(
	SELECT 
		SystemID, 
		BpID, 
		CompanyID, 
		CompanyCentralID, 
		LockedOn, 
		LockSubContractors,
		ParentID 
	FROM Master_Companies 
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND CompanyID = @CompanyID 
 
	UNION ALL 

	SELECT 
		c.SystemID, 
		c.BpID, 
		c.CompanyID, 
		c.CompanyCentralID, 
		c.LockedOn, 
		c.LockSubContractors,
		c.ParentID 
	FROM Master_Companies c
	JOIN Companies 
		ON c.SystemID = Companies.SystemID 
			AND c.BpID = Companies.BpID 
			AND c.CompanyID = Companies.ParentID 
) 
SELECT DISTINCT 
	SystemID, 
	BpID, 
	CompanyID, 
	CompanyCentralID, 
	LockedOn, 
	LockSubContractors,
	ParentID 
FROM Companies 

