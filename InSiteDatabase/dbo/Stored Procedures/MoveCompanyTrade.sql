CREATE PROCEDURE [dbo].[MoveCompanyTrade]
	@SystemID int,
	@BpID int,
	@CompanyID int,
	@TradeID int,
	@User nvarchar(50)
AS
	DECLARE @Direction int
	SET @Direction = (  SELECT COUNT(*) 
						FROM Master_CompanyTrades
						WHERE SystemID = @SystemID
							AND BpID = @BpID
							AND CompanyID = @CompanyID
							AND TradeID = @TradeID)
	IF (@Direction = 0)
		BEGIN
			-- Einfügen
			INSERT INTO Master_CompanyTrades
			(
				SystemID,
				BpID,
				TradeGroupID,
				TradeID,
				CompanyID,
				CreatedFrom,
				CreatedOn,
				EditFrom,
				EditOn
			)
			SELECT 
				@SystemID,
				@BpID,
				TradeGroupID,
				TradeID,
				@CompanyID,
				@User,
				SYSDATETIME(),
				@User,
				SYSDATETIME()
			FROM Master_Trades
			WHERE SystemID = @SystemID
				AND BpID = @BpID
				AND TradeID = @TradeID
		END

	ELSE
		BEGIN
			-- Entfernen
			DELETE FROM Master_CompanyTrades
			WHERE SystemID = @SystemID
				AND BpID = @BpID
				AND CompanyID = @CompanyID
				AND TradeID = @TradeID
		END

RETURN 0
