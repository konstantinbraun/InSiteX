CREATE PROCEDURE [dbo].[GetAccessHistory]
(
	@SystemID int,
	@BpID int,
	@CompanyID int = 0,
	@UserID int,
	@PresentState int = -1
)
AS

	DECLARE @SelfAndSubcontractors bit = 0;
	DECLARE @TypeID int = 0;
	DECLARE @PresentType int;
					
	SELECT @SelfAndSubcontractors = m_r.SelfAndSubcontractors,
		@TypeID = m_r.TypeID
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

	SELECT @PresentType = PresentType
	FROM Master_BuildingProjects
	WHERE SystemID = @SystemID
		AND BpID = @BpID
	;

	DECLARE @Companies table
	(
		SystemID int,
		BpID int,
		CompanyID int,
		ParentID int,
		CompanyCentralID int,
		NameVisible nvarchar(200),
		NameAdditional nvarchar(200),
		PRIMARY KEY (CompanyID)
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

	DECLARE @Employees table
	(
		SystemID int,
		BpID int,
		EmployeeID int,
		CompanyID int,
		ExternalPassID nvarchar(50),
		FirstName nvarchar(50),
		LastName nvarchar(50),
		PRIMARY KEY (EmployeeID)
	)
	;

	IF (@PresentState = -1)
		INSERT INTO @Employees
		(
			SystemID,
			BpID,
			EmployeeID,
			CompanyID,
			ExternalPassID,
			FirstName,
			LastName
		)
		SELECT
			m_e.SystemID,
			m_e.BpID,
			m_e.EmployeeID,
			m_e.CompanyID,
			m_e.ExternalPassID,
			m_a.FirstName,
			m_a.LastName
		FROM Master_Employees AS m_e
			INNER JOIN @Companies c
				ON m_e.SystemID = c.SystemID
					AND m_e.BpID = c.BpID
					AND m_e.CompanyID = c.CompanyID
			INNER JOIN Master_Addresses AS m_a 
				ON m_e.SystemID = m_a.SystemID 
					AND m_e.BpID = m_a.BpID 
					AND m_e.AddressID = m_a.AddressID
		WHERE dbo.EmployeePresentState(m_e.SystemID, m_e.BpID, m_e.EmployeeID) < 3
		;
	ELSE
		INSERT INTO @Employees
		(
			SystemID,
			BpID,
			EmployeeID,
			CompanyID,
			ExternalPassID,
			FirstName,
			LastName
		)
		SELECT
			m_e.SystemID,
			m_e.BpID,
			m_e.EmployeeID,
			m_e.CompanyID,
			m_e.ExternalPassID,
			m_a.FirstName,
			m_a.LastName
		FROM Master_Employees AS m_e
			INNER JOIN @Companies c
				ON m_e.SystemID = c.SystemID
					AND m_e.BpID = c.BpID
					AND m_e.CompanyID = c.CompanyID
			INNER JOIN Master_Addresses AS m_a 
				ON m_e.SystemID = m_a.SystemID 
					AND m_e.BpID = m_a.BpID 
					AND m_e.AddressID = m_a.AddressID
		WHERE dbo.EmployeePresentState(m_e.SystemID, m_e.BpID, m_e.EmployeeID) = @PresentState
		;

	DECLARE @ShortTermVisitors table
	(
		SystemID int,
		BpID int,
		ShortTermVisitorID int,
		PassInternalID nvarchar(50),
		ShortTermPassID nvarchar(50),
		Company nvarchar(200),
		AssignedCompanyID int,
		FirstName nvarchar(50),
		LastName nvarchar(50),
		PassActivatedOn datetime,
		AccessAllowedUntil datetime,
		PRIMARY KEY (ShortTermVisitorID)
	)
	;

	IF (@PresentState = -1)
		INSERT INTO @ShortTermVisitors
		(
			SystemID,
			BpID,
			ShortTermVisitorID,
			PassInternalID,
			ShortTermPassID,
			Company,
			AssignedCompanyID,
			FirstName,
			LastName,
			PassActivatedOn,
			AccessAllowedUntil
		)
		SELECT
			SystemID,
			BpID,
			ShortTermVisitorID,
			PassInternalID,
			ShortTermPassID,
			Company,
			AssignedCompanyID,
			FirstName,
			LastName,
			PassActivatedOn,
			AccessAllowedUntil
		FROM Data_ShortTermVisitors
		WHERE SystemID = @SystemID 
			AND BpID = @BpID
			AND dbo.ShortTermPresentState(SystemID, BpID, ShortTermVisitorID) < 3
	ELSE
		INSERT INTO @ShortTermVisitors
		(
			SystemID,
			BpID,
			ShortTermVisitorID,
			PassInternalID,
			ShortTermPassID,
			Company,
			AssignedCompanyID,
			FirstName,
			LastName,
			PassActivatedOn,
			AccessAllowedUntil
		)
		SELECT
			SystemID,
			BpID,
			ShortTermVisitorID,
			PassInternalID,
			ShortTermPassID,
			Company,
			AssignedCompanyID,
			FirstName,
			LastName,
			PassActivatedOn,
			AccessAllowedUntil
		FROM Data_ShortTermVisitors
		WHERE SystemID = @SystemID 
			AND BpID = @BpID
			AND dbo.ShortTermPresentState(SystemID, BpID, ShortTermVisitorID) = @PresentState

	SELECT        
		d_ae.AccessEventID, 
		d_ae.SystemID, 
		d_ae.BpID, 
		d_ae.AccessOn AS [Timestamp], 
		UPPER(d_ae.InternalID) AS InternalID, 
		m_aa.NameVisible, 
		d_ae.AccessType AS AccessTypeID, 
		d_ae.AccessResult AS Result, 
		m_aa.AccessAreaID, 
		d_ae.CreatedOn, 
		d_ae.OwnerID AS EmployeeID, 
		d_ae.IsManualEntry, 
		d_ae.Remark, 
		d_ae.CreatedFrom, 
		d_ae.EditOn, 
		d_ae.EditFrom, 
		d_ae.IsOnlineAccessEvent, 
		m_e.FirstName + ' ' + m_e.LastName AS EmployeeName, 
		m_c.NameVisible AS CompanyName, 
		m_e.CompanyID, 
		m_e.ExternalPassID, 
		d_ae.PassType,
		d_ae.EntryID,
		d_ae.DenialReason,
		s_rc.OriginalMessage,
		d_ae.AccessEventLinkedID,
		d_ae.CountIt
	FROM  Data_AccessEvents AS d_ae
		INNER JOIN @Employees AS m_e 
			ON m_e.SystemID = d_ae.SystemID 
				AND m_e.BpID = d_ae.BpID 
				AND m_e.EmployeeID = d_ae.OwnerID 
		INNER JOIN @Companies AS m_c 
			ON m_c.SystemID = m_e.SystemID 
				AND m_c.BpID = m_e.BpID 
				AND m_c.CompanyID = m_e.CompanyID 
		INNER JOIN Master_AccessAreas AS m_aa 
			ON m_aa.SystemID = d_ae.SystemID 
				AND m_aa.BpID = d_ae.BpID 
				AND m_aa.AccessAreaID = d_ae.AccessAreaID 
		LEFT OUTER JOIN System_ReturnCodes AS s_rc
			ON d_ae.SystemID = s_rc.SystemID
				AND d_ae.DenialReason = s_rc.ReturnCodeID
	WHERE d_ae.SystemID = @SystemID 
		AND d_ae.BpID = @BpID
		AND d_ae.PassType = 1
		AND ((d_ae.AccessOn >= CAST(SYSDATETIME() AS date) AND @PresentType < 3 AND @TypeID < 50) 
			OR @TypeID >= 50 OR @PresentType = 3)
		AND EXISTS 
			(
				SELECT 1
				FROM Data_PassHistory AS d_ph
				WHERE d_ph.SystemID = m_e.SystemID
					AND d_ph.BpID = m_e.BpID
					AND d_ph.EmployeeID = m_e.EmployeeID
			)

	UNION

	SELECT 
		d_ae.AccessEventID, 
		d_ae.SystemID, 
		d_ae.BpID, 
		d_ae.AccessOn AS Timestamp, 
		UPPER(d_ae.InternalID) AS InternalID, 
		m_aa.NameVisible, 
		d_ae.AccessType AS AccessTypeID, 
		d_ae.AccessResult AS Result, 
		m_aa.AccessAreaID, 
		d_ae.CreatedOn, 
		d_ae.OwnerID AS EmployeeID, 
		d_ae.IsManualEntry, 
		d_ae.Remark, 
		d_ae.CreatedFrom, 
		d_ae.EditOn, 
		d_ae.EditFrom, 
		d_ae.IsOnlineAccessEvent, 
		d_stv.FirstName + ' ' + d_stv.LastName AS EmployeeName, 
		d_stv.Company AS CompanyName, 
		d_stv.AssignedCompanyID AS CompanyID, 
		d_stv.ShortTermPassID AS ExternalPassID, 
		d_ae.PassType,
		d_ae.EntryID,
		d_ae.DenialReason,
		s_rc.OriginalMessage,
		d_ae.AccessEventLinkedID,
		d_ae.CountIt
	FROM Data_AccessEvents AS d_ae
		INNER JOIN @ShortTermVisitors AS d_stv
			ON d_ae.SystemID = d_stv.SystemID
				AND d_ae.BpID = d_stv.BpID
				AND d_ae.InternalID = d_stv.PassInternalID
				AND d_ae.OwnerID = d_stv.ShortTermVisitorID
		INNER JOIN Master_AccessAreas AS m_aa 
			ON d_ae.SystemID = m_aa.SystemID
				AND d_ae.BpID = m_aa.BpID
				AND d_ae.AccessAreaID = m_aa.AccessAreaID
		LEFT OUTER JOIN System_ReturnCodes AS s_rc
			ON d_ae.SystemID = s_rc.SystemID
				AND d_ae.DenialReason = s_rc.ReturnCodeID
	WHERE d_ae.SystemID = @SystemID 
		AND d_ae.BpID = @BpID
		AND d_ae.PassType = 2
		AND ((d_ae.AccessOn >= CAST(SYSDATETIME() AS date) AND @PresentType < 3 AND @TypeID < 50) 
			OR @TypeID >= 50 OR @PresentType = 3)
		-- AND d_ae.AccessOn BETWEEN d_stv.PassActivatedOn AND d_stv.AccessAllowedUntil

	ORDER BY Timestamp DESC
