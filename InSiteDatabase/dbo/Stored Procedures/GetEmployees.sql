CREATE PROCEDURE [dbo].[GetEmployees]
(
	@SystemID int,
	@BpID int,
	@CompanyCentralID int = 0,
	@CompanyID int = 0,
	@EmployeeID int = 0,
	@ExternalPassID nvarchar(50) = '',
	@EmploymentStatusID int = 0,
	@TradeID int = 0,
	@UserID int
)
AS

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

	IF (@UserID = 0)
		SET @SelfAndSubcontractors = 0;

	DECLARE @Companies table
	(
		SystemID int,
		BpID int,
		CompanyID int,
		ParentID int,
		CompanyCentralID int,
		NameVisible nvarchar(200),
		NameAdditional nvarchar(200),
		ReleaseOn datetime,
		LockedOn dateTime
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
				CompanyCentralID, 
				NameVisible, 
				NameAdditional,
				ReleaseOn,
				LockedOn
			)
			SELECT 
				m_c.SystemID, 
				m_c.BpID, 
				m_c.CompanyID, 
				m_c.ParentID,
				m_c.CompanyCentralID,
				s_c.NameVisible,
				s_c.NameAdditional,
				m_c.ReleaseOn,
				m_c.LockedOn
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
					NULL AS ParentID,
					m_c.CompanyCentralID,
					s_c.NameVisible,
					s_c.NameAdditional,
					m_c.ReleaseOn,
					m_c.LockedOn
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
					m_c.CompanyCentralID,
					s_c.NameVisible,
					s_c.NameAdditional,
					m_c.ReleaseOn,
					m_c.LockedOn
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
				CompanyCentralID, 
				NameVisible, 
				NameAdditional,
				ReleaseOn,
				LockedOn
			)
			SELECT 
				SystemID, 
				BpID, 
				CompanyID, 
				ParentID, 
				CompanyCentralID, 
				NameVisible, 
				NameAdditional,
				ReleaseOn,
				LockedOn
			FROM Companies
			;
		END


SELECT 
	UPPER(LEFT (a.LastName, 1)) AS FirstChar, 
	e.SystemID, 
	e.BpID, 
	e.EmployeeID, 
	p.ExternalID, 
	p.InternalID,
	e.AddressID, 
	e.CompanyID, 
	e.TradeID, 
	e.StaffFunction, 
	e.EmploymentStatusID, 
	e.MaxHrsPerMonth, 
	e.AttributeID, 
	p.ExternalID ExternalPassID, 
	e.[Description], 
	e.CreatedFrom, 
	e.CreatedOn, 
	e.EditFrom, 
	e.EditOn, 
	e.ReleaseCFrom, 
	e.ReleaseCOn, 
	e.ReleaseBFrom, 
	e.ReleaseBOn, 
	e.LockedFrom, 
	e.LockedOn, 
	a.Salutation, 
	a.Title, 
	a.FirstName, 
	a.MiddleName, 
	a.LastName,
	(CASE WHEN a.Address1 IS NOT NULL AND a.Address1 <> '' THEN a.Address1 + '<br/>' ELSE '' END) 
		+ (CASE WHEN a.CountryID IS NOT NULL AND a.CountryID <> '' THEN a.CountryID + ' ' ELSE '' END)  
		+ (CASE WHEN a.Zip IS NOT NULL AND a.Zip <> '' THEN a.Zip + ' ' ELSE '' END) 
		+ (CASE WHEN a.City IS NOT NULL AND a.City <> '' THEN a.City END) FullAddress,
	a.Address1, 
	a.Address2, 
	a.Zip, 
	a.City, 
	a.[State], 
	a.DenominationID, 
	a.CountryID, 
	a.LanguageID, 
	a.NationalityID, 
	a.Phone, 
	a.Mobile, 
	a.Email, 
	a.WWW, 
	a.BirthDate, 
	a.Gender, 
	a.PhotoFileName, 
	CAST(NULL AS image) AS PhotoData,
	a.ThumbnailData, 
	co.NameVisible, 
	co.NameAdditional, 
	e.StatusID, 
	e.UserString1, 
	e.UserString2, 
	e.UserString3, 
	e.UserString4, 
	e.UserBit1, 
	e.UserBit2, 
	e.UserBit3, 
	e.UserBit4, 
	t.NameVisible AS TradeName, 
	(a.FirstName + ' ' + a.LastName) EmployeeName,
	p.PassID,
	e.AccessRightValidUntil AS ValidUntil,
	(CASE WHEN p.DeactivatedOn IS NULL AND p.ActivatedOn IS NOT NULL AND p.PassID IS NOT NULL THEN 1 ELSE 0 END) AS PassActive,
	(CASE WHEN p.LockedOn IS NOT NULL AND p.PassID IS NOT NULL THEN 1 ELSE 0 END) AS PassLocked,
	(CASE WHEN co.ReleaseOn IS NOT NULL AND co.LockedOn IS NULL THEN 1 ELSE 0 END) AS CompanyActive,
	s_l.CountryName AS NationalityName,
	s_l.FlagName,
	ISNULL(d_are.AccessAllowed, 0) AS AccessAllowed,
	ISNULL(d_are.AccessDenialReason, '') AccessDenialReason,
	d_are.CreatedOn AccessDenialTimeStamp,
	ISNULL(m_abp.PassColor, ISNULL(m_tg.PassColor, '')) AS PassColor,
	dbo.EmployeePresentState(e.SystemID, e.BpID, e.EmployeeID) AS Present,
	ISNULL((SELECT MAX(AccessOn) FROM Data_AccessEvents WHERE SystemID = @SystemID AND BpID = @BpID AND OwnerID = e.EmployeeID AND AccessResult = 1), e.CreatedOn) AS AccessTime,
	e.AccessRightValidUntil, 
	a.[Soundex] AS Duplicates,
	m_es.NameVisible AS EmploymentStatus
	FROM Master_Employees AS e 
		INNER JOIN Master_Addresses AS a 
			ON e.SystemID = a.SystemID 
				AND e.BpID = a.BpID 
				AND e.AddressID = a.AddressID 
		INNER JOIN @Companies co
			ON e.SystemID = co.SystemID 
				AND e.BpID = co.BpID 
				AND e.CompanyID = co.CompanyID 
		LEFT OUTER JOIN Master_EmploymentStatus AS m_es
			ON e.SystemID = m_es.SystemID
				AND e.BpID = m_es.BpID
				AND e.EmploymentStatusID = m_es.EmploymentStatusID
		LEFT OUTER JOIN Master_Trades AS t
			ON e.SystemID = t.SystemID 
				AND e.BpID = t.BpID 
				AND e.TradeID = t.TradeID 
		LEFT OUTER JOIN Master_TradeGroups AS m_tg
			ON t.SystemID = m_tg.SystemID 
				AND t.BpID = m_tg.BpID 
				AND t.TradeGroupID = m_tg.TradeGroupID 
		LEFT OUTER JOIN Master_Passes AS p
			ON e.SystemID = p.SystemID 
				AND e.BpID = p.BpID 
				AND e.EmployeeID = p.EmployeeID 
		LEFT OUTER JOIN View_Countries AS s_l
			ON a.NationalityID = s_l.CountryID
		LEFT OUTER JOIN 
		(
			SELECT 
				SystemID,
				BpID,
				OwnerID,
				PassID,
				AccessAllowed,
				AccessDenialReason,
				MAX(CreatedOn) CreatedOn 
			FROM Data_AccessRightEvents
			WHERE IsNewest = 1
				AND HasSubstitute = 0
				AND PassType = 1
			GROUP BY 
				SystemID,
				BpID,
				OwnerID,
				PassID,
				AccessAllowed,
				AccessDenialReason

		) d_are
			ON e.SystemID = d_are.SystemID
				AND e.BpID = d_are.BpID
				AND e.EmployeeID = d_are.OwnerID
				AND p.PassID = d_are.PassID
		LEFT OUTER JOIN Master_AttributesBuildingProject m_abp
			ON e.SystemID = m_abp.SystemID
				AND e.BpID = m_abp.BpID
				AND e.AttributeID = m_abp.AttributeID
	WHERE e.SystemID = @SystemID 
		AND e.BpID = @BpID 
		AND e.EmployeeID = (CASE WHEN @EmployeeID = 0 THEN e.EmployeeID ELSE @EmployeeID END)
		AND e.CompanyID = (CASE WHEN @CompanyID = 0 THEN e.CompanyID ELSE @CompanyID END)
		AND e.ExternalPassID = (CASE WHEN @ExternalPassID = '' THEN e.ExternalPassID ELSE @ExternalPassID END)
		AND e.EmploymentStatusID = (CASE WHEN @EmploymentStatusID = 0 THEN e.EmploymentStatusID ELSE @EmploymentStatusID END)
		AND e.TradeID = (CASE WHEN @TradeID = 0 THEN e.TradeID ELSE @TradeID END)
	ORDER BY a.LastName, 
		a.FirstName, 
		co.NameVisible
