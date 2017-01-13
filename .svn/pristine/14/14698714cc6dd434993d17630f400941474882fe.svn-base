CREATE FUNCTION [dbo].[BestTariffScope]
(
	@SystemID int,
	@BpID int,
	@TariffScopeIDCo int
)
RETURNS INT
AS
BEGIN
	DECLARE @TariffScopeID int
	DECLARE @WageCo decimal(19,4)
	DECLARE @TariffScopeIDBp int
	DECLARE @WageBp decimal(19,4)
	DECLARE @ScopeID int
	DECLARE @TariffContractIDCo int

	-- Tarif laut zentraler Firma
	SELECT
		@WageCo = MAX(Wage),
		@TariffContractIDCo = TariffContractID
	FROM System_TariffWages AS s_tw
	WHERE ValidFrom < SYSDATETIME() 
		AND SystemID = @SystemID
		AND TariffScopeID = @TariffScopeIDCo
	GROUP BY TariffScopeID,
		TariffContractID
	
	-- Vorbelegung des Tarifgebietes aus dem Bauvorhaben
	SELECT @ScopeID = DefaultTariffScope
	FROM Master_BuildingProjects
	WHERE SystemID = @SystemID	
		AND BpID = @BpID

	-- Zwischentabelle für die Tarife laut Bauvorhaben
	DECLARE @TariffWagesBp TABLE
	(
		TariffScopeID int,
		Wage decimal(19, 4)
	)

	-- Tarife laut Bauvorhaben
	INSERT INTO @TariffWagesBp
	(
		TariffScopeID,
		Wage
	)
	SELECT
		s_ts.TariffScopeID, 
		s_tw.Wage
	FROM System_TariffScopes AS s_ts 
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
	WHERE s_ts.SystemID = @SystemID 
		AND s_ts.TariffContractID = @TariffContractIDCo
		AND s_ts.ScopeID = @ScopeID
		AND s_tw.ValidFrom < SYSDATETIME()

	-- Satz mit dem besten Tarif selektieren
	SELECT TOP(1)
		@TariffScopeIDBp = TariffScopeID, 
		@WageBp = Wage
	FROM @TariffWagesBp
	ORDER BY Wage DESC

	-- Null-Werte abfangen
	SET @WageCo = ISNULL(@WageCo, 0)
	SET @WageBp = ISNULL(@WageBp, 0)

	-- Besten Tarif aus Firma und Bauvorhaben wählen
	IF (@WageCo <= @WageBp AND @TariffScopeIDBp IS NOT NULL )
		SET @TariffScopeID = @TariffScopeIDBp
	ELSE 
		SET @TariffScopeID = @TariffScopeIDCo

	RETURN @TariffScopeID
END
