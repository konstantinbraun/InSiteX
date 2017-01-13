CREATE FUNCTION [dbo].[ShortTermPresentState]
(
	@SystemID int,
	@BpID int,
	@ShortTermVisitorID int
)
RETURNS int

AS

BEGIN
	DECLARE @PresentState int = 3;
	-- 0 = Abwesend
	-- 1 = Anwesend
	-- 2 = Inkonsistent
	-- 3 = Kein Zutrittsereignis bisher

	-- Typ des letzten Zutrittsereignisses feststellen
	SELECT TOP 1 @PresentState = d_ae.AccessType 
	FROM Data_AccessEvents d_ae
		INNER JOIN Master_AccessAreas m_aa
			ON d_ae.SystemID = m_aa.SystemID
				AND d_ae.BpID = m_aa.BpID
				AND d_ae.AccessAreaID = m_aa.AccessAreaID
	WHERE d_ae.SystemID = @SystemID 
		AND d_ae.BpID = @BpID 
		AND d_ae.OwnerID = @ShortTermVisitorID 
		AND d_ae.AccessResult = 1
		AND d_ae.PassType = 2
		AND m_aa.AccessTimeRelevant = 1
		AND m_aa.CheckInCompelling = 1
		AND m_aa.CheckOutCompelling = 1
	ORDER BY d_ae.AccessOn DESC
	;


	IF (@PresentState <> 3)
		-- Zutrittsereignisse vorhanden
		BEGIN
			DECLARE @ResultSum int;

			-- Summe aller Zutrittsereignisse
			SELECT @ResultSum = SUM(CASE WHEN AccessType = 0 THEN -1 ELSE 1 END)
			FROM Data_AccessEvents d_ae
				INNER JOIN Master_AccessAreas m_aa
					ON d_ae.SystemID = m_aa.SystemID
						AND d_ae.BpID = m_aa.BpID
						AND d_ae.AccessAreaID = m_aa.AccessAreaID
			WHERE d_ae.SystemID = @SystemID 
				AND d_ae.BpID = @BpID 
				AND d_ae.OwnerID = @ShortTermVisitorID 
				AND d_ae.AccessResult = 1
				AND d_ae.PassType = 2
				AND m_aa.AccessTimeRelevant = 1
				AND m_aa.CheckInCompelling = 1
				AND m_aa.CheckOutCompelling = 1
			;

			-- Wenn konsistent, dann ist Summe gleich dem Typ des letzten Zutrittsereignisses
			IF (@ResultSum <> @PresentState OR (@ResultSum < 0 OR @ResultSum > 1))
				-- Inkosistent, wenn Summe < 0 oder > 1
				SET @PresentState = 2
			;
		END

	RETURN @PresentState
END