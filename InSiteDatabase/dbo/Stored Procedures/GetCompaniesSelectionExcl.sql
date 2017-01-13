CREATE PROCEDURE [dbo].[GetCompaniesSelectionExcl]
(
	@SystemID int,
	@BpID int,
	@CompanyID int = 0,
	@UserID int,
	@CompanyIDExcl int 
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

	DECLARE @Companies table
	(
		SystemID int,
		BpID int,
		CompanyID int,
		ParentID int,
		CompanyCentralID int,
		NameVisible nvarchar(200),
		NameAdditional nvarchar(200)
	)
	;

	IF (@CompanyID = 0)
		BEGIN
			INSERT INTO @Companies
			(
				SystemID, 
				BpID, 
				CompanyID, 
				ParentID, 
				CompanyCentralID, 
				NameVisible, 
				NameAdditional
			)
			SELECT 
				m_c.SystemID, 
				m_c.BpID, 
				m_c.CompanyID, 
				m_c.ParentID,
				m_c.CompanyCentralID,
				s_c.NameVisible,
				s_c.NameAdditional
			FROM Master_Companies m_c
				INNER JOIN System_Companies AS s_c
					ON m_c.SystemID = s_c.SystemID 
						AND m_c.CompanyCentralID = s_c.CompanyID
				WHERE m_c.SystemID = @SystemID 
					AND m_c.BpID = @BpID 
					AND m_c.StatusID = 20
					AND m_c.CompanyID <> @CompanyIDExcl
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
					s_c.NameAdditional
				FROM Master_Companies m_c
					INNER JOIN System_Companies AS s_c
						ON m_c.SystemID = s_c.SystemID 
							AND m_c.CompanyCentralID = s_c.CompanyID
					WHERE m_c.SystemID = @SystemID 
						AND m_c.BpID = @BpID 
						AND m_c.CompanyCentralID = @CompanyID 
						AND m_c.StatusID = 20
						AND m_c.CompanyID <> @CompanyIDExcl

				UNION ALL
	
				SELECT 
					m_c.SystemID, 
					m_c.BpID, 
					m_c.CompanyID, 
					m_c.ParentID,
					m_c.CompanyCentralID,
					s_c.NameVisible,
					s_c.NameAdditional
				FROM Master_Companies m_c
					INNER JOIN Companies
						ON Companies.SystemID = m_c.SystemID
							AND Companies.BpID = m_c.BpID
							AND Companies.CompanyID = m_c.ParentID
					INNER JOIN System_Companies AS s_c
						ON m_c.SystemID = s_c.SystemID 
							AND m_c.CompanyCentralID = s_c.CompanyID
				WHERE m_c.CompanyCentralID = CASE WHEN @SelfAndSubcontractors = 1 THEN m_c.CompanyCentralID ELSE @CompanyID END
						AND m_c.StatusID = 20
			)
			INSERT INTO @Companies
			(
				SystemID, 
				BpID, 
				CompanyID, 
				ParentID, 
				CompanyCentralID, 
				NameVisible, 
				NameAdditional
			)
			SELECT 
				SystemID, 
				BpID, 
				CompanyID, 
				ParentID, 
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
		(CASE WHEN co.ParentID = 0 THEN NULL ELSE co.ParentID END) AS ParentID,
		co.CompanyCentralID, 
		co.NameVisible, 
		co.NameAdditional
	FROM @Companies co 
	WHERE dbo.HasLockedMainContractor(co.SystemID, co.BpID, co.CompanyID) = 0
	ORDER BY co.NameVisible
	;

RETURN 0
