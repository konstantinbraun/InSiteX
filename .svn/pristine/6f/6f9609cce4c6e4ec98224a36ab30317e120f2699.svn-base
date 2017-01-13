CREATE PROCEDURE [dbo].[GetCompaniesData]
(
	@SystemID int,
	@BpID int,
	@CompanyCentralID int = 0,
	@ShowList bit = 0,
	@SearchText nvarchar(50),
	@UserID int,
	@CompanyID int = 0 
)
AS
	IF (@SearchText IS NULL OR @SearchText = '')
		SET @SearchText = '%';
	ELSE 
		SET @SearchText = '%' + @SearchText + '%';

	DECLARE @SelfAndSubcontractors bit = 0;

	SELECT @SelfAndSubcontractors = m_r.SelfAndSubcontractors
	FROM Master_Users m_u
		INNER JOIN Master_UserBuildingProjects m_ubp
			ON m_u.SystemID = m_ubp.SystemID
				AND m_u.UserID = m_ubp.UserID
		INNER JOIN Master_Roles m_r
			ON m_ubp.SystemID = m_r.SystemID
				AND m_ubp.BpID = m_r.BpID
				AND m_ubp.RoleID = m_r.RoleID
	WHERE m_u.SystemID = @SystemID
		AND m_u.UserID = @UserID
		AND m_ubp.BpID = @BpID
	;

	DECLARE @Companies table
	(
		SystemID int,
		BpID int,
		CompanyID int,
		ParentID int,
		ParentNodeID int,
		CompanyCentralID int,
		NameVisible nvarchar(200),
		NameAdditional nvarchar(200)
	)
	;

	IF (@CompanyCentralID = 0)
		BEGIN
			INSERT INTO @Companies
			(
				SystemID, 
				BpID, 
				CompanyID, 
				ParentID, 
				ParentNodeID,
				CompanyCentralID, 
				NameVisible, 
				NameAdditional
			)
			SELECT 
				m_c.SystemID, 
				m_c.BpID, 
				m_c.CompanyID, 
				m_c.ParentID,
				m_c.ParentID AS ParentNodeID,
				m_c.CompanyCentralID,
				s_c.NameVisible,
				s_c.NameAdditional
			FROM Master_Companies m_c
				INNER JOIN System_Companies AS s_c
					ON m_c.SystemID = s_c.SystemID 
						AND m_c.CompanyCentralID = s_c.CompanyID
				WHERE m_c.SystemID = @SystemID 
					AND m_c.BpID = @BpID 
			;
		END
	
	ELSE
		BEGIN
			WITH Companies AS
			(
				SELECT 
					m_c.SystemID, 
					m_c.BpID, 
					m_c.CompanyID, 
					m_c.ParentID,
					NULL AS ParentNodeID,
					m_c.CompanyCentralID,
					s_c.NameVisible,
					s_c.NameAdditional
				FROM Master_Companies m_c
					INNER JOIN System_Companies AS s_c
						ON m_c.SystemID = s_c.SystemID 
							AND m_c.CompanyCentralID = s_c.CompanyID
					WHERE m_c.SystemID = @SystemID 
						AND m_c.BpID = @BpID 
						AND m_c.CompanyCentralID = @CompanyCentralID 

				UNION ALL
	
				SELECT 
					m_c.SystemID, 
					m_c.BpID, 
					m_c.CompanyID, 
					m_c.ParentID,
					m_c.ParentID AS ParentNodeID,
					m_c.CompanyCentralID,
					s_c.NameVisible,
					s_c.NameAdditional
				FROM Master_Companies m_c
					INNER JOIN Companies
						ON Companies.SystemID = m_c.SystemID
							AND Companies.BpID = m_c.BpID
							AND Companies.CompanyID = m_c.ParentID
							AND m_c.CompanyID <> m_c.ParentID
					INNER JOIN System_Companies AS s_c
						ON m_c.SystemID = s_c.SystemID 
							AND m_c.CompanyCentralID = s_c.CompanyID
				WHERE m_c.CompanyCentralID = CASE WHEN @SelfAndSubcontractors = 1 THEN m_c.CompanyCentralID ELSE @CompanyCentralID END
			)
			INSERT INTO @Companies
			(
				SystemID, 
				BpID, 
				CompanyID, 
				ParentID, 
				ParentNodeID,
				CompanyCentralID, 
				NameVisible, 
				NameAdditional
			)
			SELECT 
				SystemID, 
				BpID, 
				CompanyID, 
				ParentID, 
				ParentNodeID,
				CompanyCentralID, 
				NameVisible, 
				NameAdditional
			FROM Companies
			;
		END

	SELECT 
		co.SystemID, 
		co.BpID, 
		co.CompanyID, 
		co.CompanyCentralID, 
		s_c.NameVisible, 
		s_c.NameAdditional, 
		m_c.[Description], 
		m_c.AddressID, 
		m_c.IsVisible,
		m_c.IsValid, 
		m_c.TradeAssociation, 
		m_c.IsPartner, 
		m_c.BlnSOKA, 
		m_c.MinWageAttestation, 
		m_c.StatusID, 
		m_c.CreatedFrom, 
		m_c.CreatedOn, 
		m_c.EditFrom, 
		m_c.EditOn,
		m_c.RequestFrom, 
		m_c.RequestOn, 
		m_c.ReleaseFrom, 
		m_c.ReleaseOn, 
		m_c.LockedFrom, 
		m_c.LockedOn, 
		s_a.Address1, 
		m_c.RegistrationCode, 
		m_c.CodeValidUntil,
		s_a.Address2, 
		s_a.Zip, 
		s_a.City, 
		s_a.[State], 
		s_a.CountryID, 
		s_a.Phone, 
		s_a.Email, 
		s_a.WWW, 
		m_c.UserString1, 
		m_c.UserString2, 
		m_c.UserString3, 
		m_c.UserString4,
		m_c.UserBit1, 
		m_c.UserBit2, 
		m_c.UserBit3, 
		m_c.UserBit4, 
		co.ParentID,
		(CASE WHEN @ShowList = 0 THEN co.ParentNodeID ELSE NULL END) ParentIDReal,
		s_c_p.NameVisible AS ParentNameVisible, 
		s_c_p.NameAdditional AS ParentNameAdditional, 
		v_c.CountryName, 
		v_c.FlagName, 
		m_c.LockSubContractors,
		m_c.MinWageAccessRelevance, 
		m_c.PassBudget, 
		m_c.AllowSubcontractorEdit
	FROM @Companies co 
		INNER JOIN Master_Companies AS m_c
			ON co.SystemID = m_c.SystemID
				AND co.BpID = m_c.BpID
				AND co.CompanyID = m_c.CompanyID
		INNER JOIN System_Addresses AS s_a
			ON m_c.SystemID = s_a.SystemID 
				AND m_c.AddressID = s_a.AddressID
		INNER JOIN System_Companies s_c
			ON co.SystemID = s_c.SystemID
				AND m_c.CompanyCentralID = s_c.CompanyID
		LEFT OUTER JOIN Master_Companies AS m_c_p
			ON m_c.SystemID = m_c_p.SystemID 
				AND m_c.BpID = m_c_p.BpID 
				AND m_c.ParentID = m_c_p.CompanyID
		LEFT OUTER JOIN System_Companies s_c_p
			ON m_c_p.SystemID = s_c_p.SystemID
				AND m_c_p.CompanyCentralID = s_c_p.CompanyID
		LEFT OUTER JOIN View_Countries AS v_c
			ON s_a.CountryID = v_c.CountryID
	WHERE co.CompanyID = (CASE WHEN @CompanyID = 0 THEN co.CompanyID ELSE @CompanyID END)
		AND (s_c.NameVisible LIKE @SearchText 
		OR ISNULL(s_c.NameAdditional, '') LIKE @SearchText 
		OR s_a.Address1 LIKE @SearchText 
		OR s_a.City LIKE @SearchText)
RETURN 0
