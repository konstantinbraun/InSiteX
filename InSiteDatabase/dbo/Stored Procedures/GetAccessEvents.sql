CREATE PROCEDURE [dbo].[GetAccessEvents]
(
	@SystemID int,
	@BpID int,
	@LastID int
)
AS

DECLARE @LookBackTo datetime = DATEADD(DAY, -7, SYSDATETIME());

SELECT        
	AccessEventID, 
	SystemID, 
	BfID, 
	BpID, 
	AccessAreaID, 
	EntryID, 
	PoeID, 
	OwnerID, 
	InternalID, 
	IsOnlineAccessEvent, 
	AccessOn, 
	AccessType, 
	AccessResult, 
    MessageShown, 
	DenialReason, 
	IsManualEntry, 
	AddedBySystem,
	Remark, 
	CreatedOn, 
	CreatedFrom, 
	EditOn, 
	EditFrom
FROM Data_AccessEvents
WHERE SystemID = @SystemID
	AND BpID = @BpID 
	AND AccessEventID > @LastID 
	AND AccessOn > @LookBackTo
	AND IsOnlineAccessEvent = 0
	AND IsManualEntry = 1
	AND Remark <> 'Added by Aditus'
ORDER BY AccessOn
;
