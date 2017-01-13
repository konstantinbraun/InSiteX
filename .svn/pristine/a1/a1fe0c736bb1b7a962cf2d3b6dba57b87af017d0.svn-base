CREATE PROCEDURE [dbo].[GetTariffData]
(
	@SystemID int,
	@TariffID int,
	@TariffContractID int,
	@TariffScopeID int,
	@BpID int,
	@CompanyID int,
	@EvaluationPeriod int,
	@DateFrom datetime,
	@DateUntil datetime,
	@ReportVariant int
)
AS

DECLARE @MinDate datetime = '01-01-2000 00:00:00';
DECLARE @BeginOfWeek datetime = CAST(DATEADD(D, - (DATEPART(DW, CAST(SYSDATETIME() AS date)) + @@DATEFIRST - 2) % 7, CAST(SYSDATETIME() AS date)) AS datetime);
DECLARE @BeginOfMonth date = DATEFROMPARTS(DATEPART(YYYY, CAST(SYSDATETIME() AS date)), DATEPART(M, CAST(SYSDATETIME() AS date)), 1);

IF (@EvaluationPeriod = 2)
	-- Aufgelaufen bis gestern
	BEGIN
		SET @DateFrom = @MinDate;
		SET @DateUntil = DATEADD(MILLISECOND, -10, CAST(CAST(SYSDATETIME() AS date) AS datetime));
	END

ELSE IF (@EvaluationPeriod = 3)
	-- Aufgelaufen bis letzte Woche
	BEGIN
		SET @DateFrom = @MinDate;
		SET @DateUntil = DATEADD(MILLISECOND, -10, @BeginOfWeek);
	END

ELSE IF (@EvaluationPeriod = 4)
	-- Aufgelaufen bis letzten Monat
	BEGIN
		SET @DateFrom = @MinDate;
		SET @DateUntil = DATEADD(MILLISECOND, -10, @BeginOfMonth);
	END

ELSE IF (@EvaluationPeriod = 5)
	-- Nur letzter Monat
	BEGIN
		SET @DateFrom = DATEFROMPARTS(DATEPART(YYYY, CAST(SYSDATETIME() AS date)), DATEPART(M, CAST(SYSDATETIME() AS date)) - 1, 1);
		SET @DateUntil = DATEADD(MILLISECOND, -10, @BeginOfMonth);
	END

ELSE IF (@EvaluationPeriod = 6)
	-- Nur letzte Woche
	BEGIN
		SET @DateFrom = DATEADD(WEEK, -1, @BeginOfWeek);
		SET @DateUntil = DATEADD(MILLISECOND, -10, @BeginOfWeek);
	END

ELSE IF (@EvaluationPeriod = 7)
	-- Nur letzter Tag
	BEGIN
		SET @DateFrom = DATEADD(D, -1, CAST(CAST(SYSDATETIME() AS date) AS datetime));
		SET @DateUntil = DATEADD(MILLISECOND, -10, CAST(CAST(SYSDATETIME() AS date) AS datetime));
	END

ELSE IF (@EvaluationPeriod = 8)
	-- Aufgelaufen aktueller Monat bis gestern
	BEGIN
		SET @DateFrom = @BeginOfMonth;
		SET @DateUntil = DATEADD(MILLISECOND, -10, CAST(CAST(SYSDATETIME() AS date) AS datetime));
	END

ELSE IF (@EvaluationPeriod = 9)
	-- Aufgelaufen aktuelle Woche bis gestern
	BEGIN
		SET @DateFrom = @BeginOfWeek;
		SET @DateUntil = DATEADD(MILLISECOND, -10, CAST(CAST(SYSDATETIME() AS date) AS datetime));
	END

DECLARE @Report AS table
(
	SystemID int,
	TariffID int,
	TariffName nvarchar(50),
	TariffContractID int,
	TariffContractName nvarchar(50),
	ValidFrom date,
	ValidTo date,
	TariffScopeID int,
	TariffScopeName nvarchar(50),
	TariffWageGroupID int,
	TariffWageGroupName nvarchar(50),
	TariffWageID int,
	TariffWageName nvarchar(50),
	TariffWageValidFrom date,
	TariffWage decimal
)
;

IF (@ReportVariant = 1)
	BEGIN
		INSERT INTO @Report
		(
			SystemID,
			TariffID,
			TariffName,
			TariffContractID,
			TariffContractName,
			ValidFrom,
			ValidTo,
			TariffScopeID,
			TariffScopeName,
			TariffWageGroupID,
			TariffWageGroupName,
			TariffWageID,
			TariffWageName,
			TariffWageValidFrom,
			TariffWage
		)
		SELECT DISTINCT
			s_t.SystemID, 
			s_t.TariffID, 
			s_t.NameVisible AS TariffName, 
			s_tc.TariffContractID, 
			s_tc.NameVisible AS TariffContractName, 
			s_tc.ValidFrom AS TariffContractValidFrom, 
			s_tc.ValidTo AS TariffContractValidUntil,
			s_ts.TariffScopeID, 
			s_ts.NameVisible AS TariffScopeName, 
			s_twg.TariffWageGroupID, 
			s_twg.NameVisible AS TariffWageGroupName, 
			s_tw.TariffWageID, 
			s_tw.NameVisible AS TariffWageName, 
			s_tw.ValidFrom AS TariffWageValidFrom, 
			s_tw.Wage 
		FROM System_Tariffs AS s_t 
			INNER JOIN System_TariffContracts AS s_tc 
				ON s_t.SystemID = s_tc.SystemID 
					AND s_t.TariffID = s_tc.TariffID 
			INNER JOIN System_TariffScopes AS s_ts 
				ON s_tc.SystemID = s_ts.SystemID 
					AND s_tc.TariffID = s_ts.TariffID 
					AND s_tc.TariffContractID = s_ts.TariffContractID 
			INNER JOIN System_TariffWageGroups AS s_twg 
				ON s_ts.SystemID = s_twg.SystemID 
					AND s_ts.TariffID = s_twg.TariffID 
					AND s_ts.TariffContractID = s_twg.TariffContractID 
					AND s_ts.TariffScopeID = s_twg.TariffScopeID 
			INNER JOIN System_TariffWages AS s_tw 
				ON s_twg.SystemID = s_tw.SystemID 
					AND s_twg.TariffID = s_tw.TariffID 
					AND s_twg.TariffContractID = s_tw.TariffContractID 
					AND s_twg.TariffScopeID = s_tw.TariffScopeID 
					AND s_twg.TariffWageGroupID = s_tw.TariffWageGroupID
		WHERE s_t.SystemID = @SystemID 
			AND s_t.TariffID = (CASE WHEN @TariffID = 0 THEN s_t.TariffID ELSE @TariffID END) 
			AND s_tc.TariffContractID = (CASE WHEN @TariffContractID = 0 THEN s_tc.TariffContractID ELSE @TariffContractID END) 
			AND s_ts.TariffScopeID = (CASE WHEN @TariffScopeID = 0 THEN s_ts.TariffScopeID ELSE @TariffScopeID END)
			AND s_tw.ValidFrom BETWEEN @DateFrom AND @DateUntil 
		;
	END
ELSE
	BEGIN
		INSERT INTO @Report
		(
			SystemID,
			TariffID,
			TariffName,
			TariffContractID,
			TariffContractName,
			ValidFrom,
			ValidTo,
			TariffScopeID,
			TariffScopeName,
			TariffWageGroupID,
			TariffWageGroupName,
			TariffWageID,
			TariffWageName,
			TariffWageValidFrom,
			TariffWage
		)
		SELECT DISTINCT
			s_t.SystemID, 
			s_t.TariffID, 
			s_t.NameVisible AS TariffName, 
			s_tc.TariffContractID, 
			s_tc.NameVisible AS TariffContractName, 
			s_tc.ValidFrom AS TariffContractValidFrom, 
			s_tc.ValidTo AS TariffContractValidUntil,
			s_ts.TariffScopeID, 
			s_ts.NameVisible AS TariffScopeName, 
			s_twg.TariffWageGroupID, 
			s_twg.NameVisible AS TariffWageGroupName, 
			s_tw.TariffWageID, 
			s_tw.NameVisible AS TariffWageName, 
			m_ct.ValidFrom AS TariffWageValidFrom, 
			s_tw.Wage 
		FROM System_Tariffs AS s_t 
			INNER JOIN System_TariffContracts AS s_tc 
				ON s_t.SystemID = s_tc.SystemID 
					AND s_t.TariffID = s_tc.TariffID 
			INNER JOIN System_TariffScopes AS s_ts 
				ON s_tc.SystemID = s_ts.SystemID 
					AND s_tc.TariffID = s_ts.TariffID 
					AND s_tc.TariffContractID = s_ts.TariffContractID 
			INNER JOIN Master_CompanyTariffs AS m_ct 
				ON s_ts.SystemID = m_ct.SystemID 
					AND s_ts.TariffScopeID = m_ct.TariffScopeID
			INNER JOIN System_TariffWageGroups AS s_twg 
				ON s_ts.SystemID = s_twg.SystemID 
					AND s_ts.TariffID = s_twg.TariffID 
					AND s_ts.TariffContractID = s_twg.TariffContractID 
					AND s_ts.TariffScopeID = s_twg.TariffScopeID 
			INNER JOIN System_TariffWages AS s_tw 
				ON s_twg.SystemID = s_tw.SystemID 
					AND s_twg.TariffID = s_tw.TariffID 
					AND s_twg.TariffContractID = s_tw.TariffContractID 
					AND s_twg.TariffScopeID = s_tw.TariffScopeID 
					AND s_twg.TariffWageGroupID = s_tw.TariffWageGroupID
		WHERE s_t.SystemID = @SystemID 
			AND m_ct.BpID = @BpID 
			AND m_ct.CompanyID = (CASE WHEN @CompanyID = 0 THEN m_ct.CompanyID ELSE @CompanyID END)
			AND m_ct.ValidFrom BETWEEN @DateFrom AND @DateUntil 
		;
	END

SELECT 
	SystemID,
	TariffID,
	TariffName,
	TariffContractID,
	TariffContractName,
	ValidFrom,
	ValidTo,
	TariffScopeID,
	TariffScopeName,
	TariffWageGroupID,
	TariffWageGroupName,
	TariffWageID,
	TariffWageName,
	TariffWageValidFrom,
	TariffWage
 FROM @Report
 ;
