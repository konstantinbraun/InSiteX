CREATE PROCEDURE [dbo].[GetCompanyCentralDuplicates]
(
	@SystemID int,
	@CompanyID int
)
AS

DECLARE @Soundex nvarchar(1000);
DECLARE @Zip nvarchar(10);

SELECT 
	@Soundex = s_c.[Soundex], 
	@Zip = s_a.Zip
FROM System_Companies s_c
	INNER JOIN System_Addresses s_a
		ON s_c.SystemID = s_a.SystemID
			AND s_c.AddressID = s_a.AddressID
WHERE s_c.SystemID = @SystemID
	AND s_c.CompanyID = @CompanyID
;

SELECT 
	s_c.CompanyID, 
	s_c.NameVisible,
	s_c.NameAdditional,
	s_a.Address1,
	s_a.Zip,
	s_a.City,
	s_a.CountryID
FROM System_Companies s_c
	INNER JOIN System_Addresses s_a
		ON s_c.SystemID = s_a.SystemID
			AND s_c.AddressID = s_a.AddressID
WHERE s_c.SystemID = @SystemID
	AND s_c.CompanyID != @CompanyID
	AND (s_c.[Soundex] = @Soundex 
		OR s_a.Zip = @Zip) 
ORDER BY
	s_c.NameVisible,
	s_c.NameAdditional,
	s_a.Address1,
	s_a.Zip
;
