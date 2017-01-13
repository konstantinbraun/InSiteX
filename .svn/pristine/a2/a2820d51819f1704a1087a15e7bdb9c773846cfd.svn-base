USE Insite_Dev;

--{ INSITE-1125 ****************************************************************

ALTER PROCEDURE [dbo].[GetEmployees]
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


--} INSITE-1125

GO

--{ INSITE-1142 ****************************************************************

ALTER PROCEDURE [dbo].[GetPassBillings]
	@SystemID int,
	@BpID int,
	@CompanyID int = 0,
	@EvaluationPeriod int,
	@DateFrom datetime,
	@DateUntil datetime,
	@CompanyLevel int,
	@Remarks nvarchar(200)
AS

DECLARE @MinDate datetime = '01-01-2000 00:00:00';
DECLARE @BeginOfWeek datetime = CAST(DATEADD(D, - (DATEPART(DW, CAST(SYSDATETIME() AS date)) + @@DATEFIRST - 2) % 7, CAST(SYSDATETIME() AS date)) AS datetime);
DECLARE @BeginOfMonth date = DATEFROMPARTS(DATEPART(YYYY, CAST(SYSDATETIME() AS date)), DATEPART(M, CAST(SYSDATETIME() AS date)), 1);

IF (@EvaluationPeriod = 2)
	-- Aufgelaufen bis gestern
	BEGIN
		SET @DateFrom = @MinDate
		SET @DateUntil = DATEADD(MILLISECOND, -10, CAST(CAST(SYSDATETIME() AS date) AS datetime))
	END

ELSE IF (@EvaluationPeriod = 3)
	-- Aufgelaufen bis letzte Woche
	BEGIN
		SET @DateFrom = @MinDate
		SET @DateUntil = DATEADD(MILLISECOND, -10, @BeginOfWeek)
	END

ELSE IF (@EvaluationPeriod = 4)
	-- Aufgelaufen bis letzten Monat
	BEGIN
		SET @DateFrom = @MinDate
		SET @DateUntil = DATEADD(MILLISECOND, -10, CAST(@BeginOfMonth AS datetime))
	END

ELSE IF (@EvaluationPeriod = 5)
	-- Nur letzter Monat
	BEGIN
		IF DATEPART(M, CAST(SYSDATETIME() AS date)) = 1
			SET @DateFrom = DATEFROMPARTS(YEAR(SYSDATETIME())-1, 12, 1)
		ELSE
			SET @DateFrom = DATEFROMPARTS(DATEPART(YYYY, CAST(SYSDATETIME() AS date)), DATEPART(M, CAST(SYSDATETIME() AS date)) - 1, 1)
		SET @DateUntil = DATEADD(MILLISECOND, -10, CAST(@BeginOfMonth AS datetime))
	END

ELSE IF (@EvaluationPeriod = 6)
	-- Nur letzte Woche
	BEGIN
		SET @DateFrom = DATEADD(WEEK, -1, @BeginOfWeek)
		SET @DateUntil = DATEADD(MILLISECOND, -10, @BeginOfWeek)
	END

ELSE IF (@EvaluationPeriod = 7)
	-- Nur letzter Tag
	BEGIN
		SET @DateFrom = DATEADD(D, -1, CAST(CAST(SYSDATETIME() AS date) AS datetime))
		SET @DateUntil = DATEADD(MILLISECOND, -10, CAST(CAST(SYSDATETIME() AS date) AS datetime))
	END

ELSE IF (@EvaluationPeriod = 8)
	-- Aufgelaufen aktueller Monat bis gestern
	BEGIN
		SET @DateFrom = @BeginOfMonth
		SET @DateUntil = DATEADD(MILLISECOND, -10, CAST(CAST(SYSDATETIME() AS date) AS datetime))
	END

ELSE IF (@EvaluationPeriod = 9)
	-- Aufgelaufen aktuelle Woche bis gestern
	BEGIN
		SET @DateFrom = @BeginOfWeek
		SET @DateUntil = DATEADD(MILLISECOND, -10, CAST(CAST(SYSDATETIME() AS date) AS datetime))
	END
;

-- Hilfstabelle für selektierte Firmen
DECLARE @SelectedCompanies SelectedCompanies;

IF (@CompanyLevel = 1)
	-- Hauptunternehmer selektieren
	INSERT INTO @SelectedCompanies 
	(
		SystemID,
		BpID,
		CompanyID,
		ParentID,
		NameVisible,
		NameAdditional,
		TreeLevel,
		IndentLevel
	)
	SELECT
		SystemID,
		BpID,
		CompanyID,
		ParentID,
		NameVisible,
		NameAdditional,
		CAST(RIGHT(CONCAT('000', CAST(ROW_NUMBER() OVER(PARTITION BY ParentID ORDER BY NameVisible) AS nvarchar(50))), 3) AS nvarchar(50)) AS TreeLevel, 
		1
	FROM Master_Companies
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND CompanyID = (CASE WHEN @CompanyID = 0 THEN CompanyID ELSE @CompanyID END)
		AND ParentID = (CASE WHEN @CompanyID = 0 THEN 0 ELSE ParentID END)
	;

IF (@CompanyLevel = 2)
	-- Hauptunternehmer und direkte Subunternehmer selektieren
	WITH Companies AS
	(
		SELECT 
			SystemID, 
			BpID, 
			CompanyID, 
			ParentID, 
			NameVisible, 
			NameAdditional, 
			CAST(RIGHT(CONCAT('000', CAST(ROW_NUMBER() OVER(PARTITION BY ParentID ORDER BY NameVisible) AS nvarchar(50))), 3) AS nvarchar(50)) AS TreeLevel, 
			1 AS IndentLevel
		FROM Master_Companies
			WHERE SystemID = @SystemID 
				AND BpID = @BpID 
				AND CompanyID = (CASE WHEN @CompanyID = 0 THEN CompanyID ELSE @CompanyID END) 
				AND ParentID = (CASE WHEN @CompanyID = 0 THEN 0 ELSE ParentID END)

		UNION ALL
	
		SELECT 
			m_c.SystemID, 
			m_c.BpID, 
			m_c.CompanyID, 
			m_c.ParentID, 
			m_c.NameVisible, 
			m_c.NameAdditional, 
			CAST(TreeLevel + ';' + RIGHT(CONCAT('000', CAST(ROW_NUMBER() OVER(PARTITION BY m_c.ParentID ORDER BY m_c.NameVisible) AS nvarchar(50))), 3) AS nvarchar(50)) AS TreeLevel,
			IndentLevel + 1 AS IndentLevel
		FROM Master_Companies m_c
			INNER JOIN Companies
				ON Companies.SystemID = m_c.SystemID
					AND Companies.BpID = m_c.BpID
					AND Companies.CompanyID = m_c.ParentID
	)
	INSERT INTO @SelectedCompanies 
	(
		SystemID,
		BpID,
		CompanyID,
		ParentID,
		NameVisible,
		NameAdditional,
		TreeLevel,
		IndentLevel
	)
	SELECT DISTINCT
		SystemID,
		BpID,
		CompanyID,
		ParentID,
		REPLICATE(CHAR(9), IndentLevel - 1) + NameVisible,
		NameAdditional,
		TreeLevel,
		IndentLevel 
	FROM Companies
	WHERE IndentLevel <= 2
	ORDER BY TreeLevel
	;

ELSE IF (@CompanyLevel = 3)
	-- Hauptunternehmer und alle Subunternehmer selektieren
	WITH Companies AS
	(
		SELECT 
			SystemID, 
			BpID, 
			CompanyID, 
			ParentID, 
			NameVisible, 
			NameAdditional, 
			CAST(RIGHT(CONCAT('000', CAST(ROW_NUMBER() OVER(PARTITION BY ParentID ORDER BY NameVisible) AS nvarchar(50))), 3) AS nvarchar(50)) AS TreeLevel, 
			1 AS IndentLevel
		FROM Master_Companies
			WHERE SystemID = @SystemID 
				AND BpID = @BpID 
				AND CompanyID = (CASE WHEN @CompanyID = 0 THEN CompanyID ELSE @CompanyID END) 
				AND ParentID = (CASE WHEN @CompanyID = 0 THEN 0 ELSE ParentID END)

		UNION ALL
	
		SELECT 
			m_c.SystemID, 
			m_c.BpID, 
			m_c.CompanyID, 
			m_c.ParentID, 
			m_c.NameVisible, 
			m_c.NameAdditional, 
			CAST(TreeLevel + ';' + RIGHT(CONCAT('000', CAST(ROW_NUMBER() OVER(PARTITION BY m_c.ParentID ORDER BY m_c.NameVisible) AS nvarchar(50))), 3) AS nvarchar(50)) AS TreeLevel,
			IndentLevel + 1 AS IndentLevel
		FROM Master_Companies m_c
			INNER JOIN Companies
				ON Companies.SystemID = m_c.SystemID
					AND Companies.BpID = m_c.BpID
					AND Companies.CompanyID = m_c.ParentID
	)
	INSERT INTO @SelectedCompanies 
	(
		SystemID,
		BpID,
		CompanyID,
		ParentID,
		NameVisible,
		NameAdditional,
		TreeLevel,
		IndentLevel
	)
	SELECT DISTINCT
		SystemID,
		BpID,
		CompanyID,
		ParentID,
		REPLICATE('·  ', IndentLevel - 1) + NameVisible,
		NameAdditional,
		TreeLevel,
		IndentLevel 
	FROM Companies
	ORDER BY TreeLevel
	;

-- Addressdaten Hauptunternehmer
SELECT DISTINCT
	m_c.SystemID,
	m_c.BpID,
	m_c.CompanyID,
	0 AS ParentID,
	1 AS IsMainContractor,
	m_c.NameVisible AS CompanyName,
	m_c.NameAdditional,
	s_a.Address1,
	s_a.Address2,
	s_a.Zip,
	s_a.City,
	s_a.CountryID,
	0 AS EmployeeID,
	'' AS FirstName,
	'' AS LastName,
	'' AS ReplacementCase,
	0 AS PassID,
	'' AS ExternalID,
	'' AS Reason,
	NULL AS PrintedOn,
	'' AS PrintedFrom,
	0 AS PrintCount,
	NULL AS ActivatedOn,
	'' AS ActivatedFrom,
	0  AS ActiveCount,
	NULL AS LockedOn,
	'' AS LockedFrom,
	0 AS LockCount,
	0 AS Cost,
	'' AS Currency,
	CONVERT(bit, 0) AS CreditForOldPass,
	'' AS InvoiceTo,
	CONVERT(bit, 0) AS WillBeCharged,
	@Remarks AS Remarks,
	sc.TreeLevel,
	m_c.PassBudget,
	0 AS FirstPassCount,
	0 AS SecondPassCount
FROM Master_Companies m_c
	INNER JOIN System_Addresses s_a
		ON s_a.SystemID = m_c.SystemID
			AND s_a.AddressID = m_c.AddressID
	INNER JOIN @SelectedCompanies sc
		ON sc.CompanyID = m_c.CompanyID
WHERE m_c.SystemID = @SystemID
	AND m_c.BpID = @BpID
	AND sc.IndentLevel = 1

UNION

-- Abrechnungsdaten selektieren
SELECT 
	d_ph.SystemID,
	d_ph.BpID,
	m_c.CompanyID,
	(CASE WHEN m_c.ParentID = 0 OR m_c.ParentID = @CompanyID THEN m_c.CompanyID ELSE m_c.ParentID END) AS ParentID,
	(CASE WHEN m_c.ParentID = 0 OR m_c.ParentID = @CompanyID THEN 1 ELSE 0 END) AS IsMainContractor,
	m_c.NameVisible AS CompanyName,
	m_c.NameAdditional,
	s_a.Address1,
	s_a.Address2,
	s_a.Zip,
	s_a.City,
	s_a.CountryID,
	d_ph.EmployeeID AS EmployeeID,
	m_ae.FirstName,
	m_ae.LastName,
	m_rpc.NameVisible AS ReplacementCase,
	d_ph.PassID,
	m_p.ExternalID,
	d_ph.Reason,
	m_p.PrintedOn,
	m_p.PrintedFrom,
	(CASE WHEN m_p.PrintedOn IS NULL THEN 0 ELSE 1 END) AS PrintCount,
	m_p.ActivatedOn,
	m_p.ActivatedFrom,
	(CASE WHEN m_p.LockedOn IS NULL AND m_p.ActivatedOn IS NOT NULL THEN 1 ELSE 0 END) AS ActiveCount,
	m_p.LockedOn,
	m_p.LockedFrom,
	(CASE WHEN m_p.LockedOn IS NULL THEN 0 ELSE 1 END) AS LockCount,
	m_rpc.Cost,
	m_rpc.Currency,
	m_rpc.CreditForOldPass,
	m_rpc.InvoiceTo,
	m_rpc.WillBeCharged,
	@Remarks AS Remarks,
	sc.TreeLevel,
	m_c.PassBudget,
	(CASE WHEN m_rpc.IsInitialIssue = 1 THEN 1 ELSE 0 END) AS FirstPassCount,
	(CASE WHEN m_rpc.IsInitialIssue = 1 THEN 0 ELSE 1 END) AS SecondPassCount
FROM Data_PassHistory d_ph
	INNER JOIN Master_ReplacementPassCases m_rpc
		ON m_rpc.SystemID = d_ph.SystemID
			AND m_rpc.BpID = d_ph.BpID
			AND m_rpc.ReplacementPassCaseID = d_ph.ReplacementPassCaseID
	INNER JOIN Master_Employees m_e
		ON m_e.SystemID = d_ph.SystemID
			AND m_e.BpID = d_ph.BpID
			AND m_e.EmployeeID = d_ph.EmployeeID
	INNER JOIN Master_Addresses m_ae
		ON m_ae.SystemID = m_e.SystemID
			AND m_ae.BpID = m_e.BpID
			AND m_ae.AddressID = m_e.AddressID
	INNER JOIN @SelectedCompanies sc
		ON sc.CompanyID = m_e.CompanyID
	INNER JOIN Master_Companies m_c
		ON m_c.SystemID = m_e.SystemID
			AND m_c.BpID = m_e.BpID
			AND m_c.CompanyID = m_e.CompanyID
	INNER JOIN System_Addresses s_a
		ON s_a.SystemID = m_c.SystemID
			AND s_a.AddressID = m_c.AddressID
	LEFT OUTER JOIN Master_Passes m_p
		ON m_p.SystemID = d_ph.SystemID
			AND m_p.BpID = d_ph.BpID
			AND m_p.PassID = d_ph.PassID
WHERE d_ph.SystemID = @SystemID
	AND d_ph.BpID = @BpID
	AND d_ph.ActionID = 11
	AND d_ph.ReplacementPassCaseID IS NOT NULL
	AND EXISTS 
		(
			SELECT 1
			FROM Data_PassHistory d_ph1
			WHERE d_ph1.SystemID = @SystemID
				AND d_ph1.BpID = @BpID
				AND d_ph1.PassID = d_ph.PassID
				AND d_ph1.ActionID = 12
				AND d_ph1.ReplacementPassCaseID IS NULL
				AND d_ph1.[Timestamp] BETWEEN @DateFrom AND @DateUntil
		)
ORDER BY 
	sc.TreeLevel, 
	EmployeeID, 
	ReplacementCase

--} INSITE-1142

GO

--{ INSITE-1108 ****************************************************************

CREATE TABLE [dbo].[System_Reports](
	[ReportId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ReportVisibility] [int] NOT NULL,
	[ReportData] [nvarchar](MAX) NULL,
 CONSTRAINT [PK_System_Reports] PRIMARY KEY CLUSTERED 
(
	[ReportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO 

CREATE TABLE [dbo].[System_ReportToProject](
	[ReportToProjectId] [int] IDENTITY(1,1) NOT NULL,
	[ReportId] [int] NOT NULL,
	[BpID] [int] NOT NULL,
	[SystemID] [int] NOT NULL,
 CONSTRAINT [PK_System_ReportProject] PRIMARY KEY CLUSTERED 
(
	[ReportToProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
    CONSTRAINT [FK_System_ReportProject_System_ReportProject] FOREIGN KEY([ReportId]) REFERENCES [dbo].[System_Reports] ([ReportId]) ON DELETE CASCADE, 
    CONSTRAINT [FK_System_ReportToProject_Master_BuildingProjects] FOREIGN KEY([SystemID], [BpID]) REFERENCES [dbo].[Master_BuildingProjects] ([SystemID], [BpID]) ON UPDATE CASCADE ON DELETE CASCADE, 
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[System_ReportToRole](
	[ReportToRoleId] [int] IDENTITY(1,1) NOT NULL,
	[ReportId] [int] NOT NULL,
	[ReportRoleId] [int] NOT NULL,
 CONSTRAINT [PK_System_ReportToRole] PRIMARY KEY CLUSTERED 
(
	[ReportToRoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	CONSTRAINT [FK_System_ReportToRole_System_Reports] FOREIGN KEY([ReportId]) REFERENCES [dbo].[System_Reports] ([ReportId]) ON UPDATE CASCADE ON DELETE CASCADE
) ON [PRIMARY]

GO
--} INSITE-1108