CREATE PROCEDURE [dbo].[GetCompaniesCentralNotAddedToBp]
(
	@SystemID int,
	@BpID int
)
AS
	SELECT 
		c.SystemID, 
		c.BpID, 
		c.CompanyID, 
		c.NameVisible + (CASE WHEN c.NameAdditional IS NULL THEN '' ELSE ', ' + c.NameAdditional END) + (CASE WHEN a.City IS NULL THEN '' ELSE ', ' + a.City END) AS CompanyName 
	FROM Master_Companies AS c 
		LEFT OUTER JOIN System_Addresses AS a 
			ON c.SystemID = a.SystemID 
				AND c.AddressID = a.AddressID 
	WHERE c.SystemID = @SystemID 
		AND c.BpID = @BpID 
		AND c.ReleaseOn IS NOT NULL
		AND LockedOn IS NULL 
	ORDER BY c.NameVisible 

RETURN 0
