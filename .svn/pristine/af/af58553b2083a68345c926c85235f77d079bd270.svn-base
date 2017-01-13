CREATE PROCEDURE [dbo].[GetEmployeesDropDown]
(
	@SystemID int,
	@BpID int,
	@CompanyCentralID int = 0,
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
						AND m_c.CompanyCentralID = @CompanyCentralID 

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
	e.SystemID, 
	e.BpID, 
	e.EmployeeID, 
	e.CompanyID, 
	e.[Description], 
	a.FirstName, 
	a.LastName,
	co.NameVisible, 
	co.NameAdditional, 
	e.StatusID, 
	t.NameVisible AS TradeName, 
	(a.LastName + ', ' + a.FirstName + ' (' + co.NameVisible + ')') EmployeeName
	FROM Master_Employees AS e 
		INNER JOIN Master_Addresses AS a 
			ON e.SystemID = a.SystemID 
				AND e.BpID = a.BpID 
				AND e.AddressID = a.AddressID 
		INNER JOIN @Companies co
			ON e.SystemID = co.SystemID 
				AND e.BpID = co.BpID 
				AND e.CompanyID = co.CompanyID 
		INNER JOIN Master_Passes p
			ON e.SystemID = p.SystemID 
				AND e.BpID = p.BpID 
				AND e.EmployeeID = p.EmployeeID 
		LEFT OUTER JOIN Master_Trades AS t
			ON e.SystemID = t.SystemID 
				AND e.BpID = t.BpID 
				AND e.TradeID = t.TradeID 
	WHERE e.SystemID = @SystemID 
		AND e.BpID = @BpID 
		AND e.StatusID = 20
		AND p.ActivatedOn IS NOT NULL
	ORDER BY a.LastName, 
		a.FirstName, 
		co.NameVisible
