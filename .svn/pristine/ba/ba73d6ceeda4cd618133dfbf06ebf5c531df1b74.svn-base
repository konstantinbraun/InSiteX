CREATE PROCEDURE [dbo].[ResetAccessRights]
(
	@SystemID int,
	@BpID int,
	@PassID int,
	@OwnerID int,
	@DeactivationMessage nvarchar(500)
)
AS

DECLARE @PassType int
SELECT @PassType = PassType
FROM Data_AccessRightEvents
WHERE SystemID = @SystemID
	AND BpID = @BpID
	AND PassID = @PassID
	AND OwnerID = @OwnerID
	AND IsNewest = 1

UPDATE Data_AccessRightEvents
SET DeliveryMessage = ISNULL(DeliveryMessage, '') + ' === deactivated due to newer version ===',
	IsNewest = 0,
	IsDelivered = 0,
	DeliveredAt = NULL,
	EditOn = SYSDATETIME(),
	EditFrom = 'SYSTEM'
WHERE SystemID = @SystemID
	AND BpID = @BpID
	AND PassID = @PassID
	AND OwnerID = @OwnerID
	AND IsNewest = 1

UPDATE Data_AccessRightEvents
SET DeliveryMessage = ISNULL(DeliveryMessage, '') + ' === deactivated due to newer version ===',
	HasSubstitute = 1,
	IsNewest = 0,
	IsDelivered = 0,
	DeliveredAt = NULL,
	EditOn = SYSDATETIME(),
	EditFrom = 'SYSTEM'
WHERE SystemID = @SystemID
	AND BpID = @BpID
	AND PassID != @PassID
	AND OwnerID = @OwnerID
	AND PassType = @PassType
	AND HasSubstitute = 0
