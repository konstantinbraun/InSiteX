CREATE PROCEDURE [dbo].[GetPassPrintData]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int,
	@PassCaseID int
)
AS

	-- ID der Firma zum Benutzer ermitteln
	DECLARE @CompanyID int;

	SELECT @CompanyID = e.CompanyID
	FROM Master_Employees e
	WHERE e.SystemID = @SystemID
		AND e.BpID = @BpID
		AND e.EmployeeID = @EmployeeID
	;

	-- Hilfstabelle zum Ermitteln des HU
	DECLARE @ParentContractor table
	(
		SystemID int,
		BpID int,
		CompanyID int PRIMARY KEY,
		ParentID int,
		NameVisible nvarchar(50),
		IndentLevel int
	)
	;

	-- HU ermitteln
	INSERT @ParentContractor
	EXEC dbo.GetParentContractors @SystemID, @BpID, @CompanyID, 2
	;

	DECLARE @MainContractorID int;
	DECLARE @MainContractorName nvarchar(50);
	SELECT 
		@MainContractorID = CompanyID,
		@MainContractorName = NameVisible
	FROM @ParentContractor
	;

	-- Druckdaten aufbereiten
	SELECT
		e.SystemID,
		e.BpID,
		e.EmployeeID,
		c.NameVisible AS CompanyName,
		c.NameAdditional AS CompanyNameAdditional,
		m_c_1.NameVisible AS ClientName,
		m_c_1.NameAdditional AS ClientNameAdditional,
		a.FirstName,
		a.LastName,
		(CASE WHEN a.LastName IS NULL THEN '' ELSE a.LastName + ', ' END) + ISNULL(a.FirstName, '') AS EmployeeName,
		a.PhotoData,
		l.CountryName,
		p.InternalID,
		p.ExternalID,
		b.NameVisible AS BuildingProjectName,
		t.NameVisible AS TradeName,
		p.PrintedOn,
		p.PassID,
		ISNULL(m_es.MWObligate, 0) AS MWObligate,
		m_rpc.NameVisible AS PassCaseName,
		ISNULL(m_rpc.WillBeCharged, 0) AS WillBeCharged,
		(ISNULL(m_rpc.WillBeCharged, 0) * ISNULL(m_rpc.Cost, 0)) AS Cost,
		RTRIM(ISNULL(m_abp.PassColor, m_tg.PassColor)) AS TradeColor,
		RTRIM(m_abp.PassColor) AS EmployeeColor,
		p.BarcodeData,
		e.StaffFunction,
		a.BirthDate,
		m_es.NameVisible AS EmploymentStatus,
		e.UserBit1,
		e.UserBit2,
		e.UserBit3,
		e.UserBit4,
		e.UserString1,
		e.UserString2,
		e.UserString3,
		e.UserString4,
		m_abp.NameVisible AS AttributeName,
		m_abp.DescriptionShort AS AttributeDescription,
		@MainContractorID AS MainContractorID,
		@MainContractorName AS MainContractorName
	FROM Master_Employees e
		INNER JOIN Master_Addresses a
			ON a.SystemID = e.SystemID
				AND a.BpID = e.BpID
				AND a.AddressID = e.AddressID
		INNER JOIN Master_Passes p
			ON p.SystemID = e.SystemID
				AND p.BpID = e.BpID
				AND p.EmployeeID = e.EmployeeID
		INNER JOIN Master_Companies c
			ON c.SystemID = e.SystemID
				AND c.BpID = e.BpID
				AND c.CompanyID = e.CompanyID
		LEFT OUTER JOIN Master_Companies m_c_1
			ON m_c_1.SystemID = c.SystemID
				AND m_c_1.BpID = c.BpID
				AND m_c_1.CompanyID = c.ParentID
		LEFT OUTER JOIN View_Countries AS l
			ON l.CountryID = a.NationalityID
		INNER JOIN Master_BuildingProjects b
			ON b.SystemID = e.SystemID
				AND b.BpID = e.BpID
		LEFT OUTER JOIN Master_Trades t
			ON t.SystemID = e.SystemID
				AND t.BpID = e.BpID
				AND t.TradeID = e.TradeID
		LEFT OUTER JOIN Master_TradeGroups m_tg
			ON m_tg.SystemID = t.SystemID
				AND m_tg.BpID = t.BpID
				AND m_tg.TradeGroupID = t.TradeGroupID
		LEFT OUTER JOIN Master_EmploymentStatus m_es
			ON m_es.SystemID = e.SystemID
				AND m_es.BpID = e.BpID
				AND m_es.EmploymentStatusID = e.EmploymentStatusID
		LEFT OUTER JOIN Master_ReplacementPassCases m_rpc
			ON m_rpc.SystemID = e.SystemID
				AND m_rpc.BpID = e.BpID
		LEFT OUTER JOIN Master_AttributesBuildingProject m_abp
			ON m_abp.SystemID = e.SystemID
				AND m_abp.BpID = e.BpID
				AND m_abp.AttributeID = e.AttributeID
	WHERE e.SystemID = @SystemID
		AND e.BpID = @BpID
		AND e.EmployeeID = @EmployeeID
		AND p.PrintedOn IS NOT NULL
		AND ((m_es.MWFrom <= SYSDATETIME() AND m_es.MWTo >= SYSDATETIME()) OR (m_es.MWFrom IS NULL OR m_es.MWTo IS NULL))
		AND (m_rpc.ReplacementPassCaseID = @PassCaseID OR m_rpc.ReplacementPassCaseID IS NULL)

RETURN 0
