CREATE PROCEDURE [dbo].[GetAccessHistoryEmployee]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int
)

AS

DECLARE @PresentType int;

SELECT @PresentType = PresentType
FROM Master_BuildingProjects
WHERE SystemID = @SystemID
	AND BpID = @BpID
;

DECLARE @DateFrom datetime;
IF (@PresentType < 3)
	SET @DateFrom = CAST(SYSDATETIME() as date)
ELSE
	SET @DateFrom = CAST('01-01-2010' as date)


SELECT        
	d_ae.AccessEventID, 
	d_ae.SystemID, 
	d_ae.BpID, 
	d_ae.AccessOn AS [Timestamp], 
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
	d_ae.DenialReason, 
	s_rc.OriginalMessage
FROM Master_AccessAreas AS m_aa 
	INNER JOIN Data_AccessEvents AS d_ae 
		ON m_aa.SystemID = d_ae.SystemID 
			AND m_aa.BpID = d_ae.BpID 
			AND m_aa.AccessAreaID = d_ae.AccessAreaID 
	LEFT OUTER JOIN System_ReturnCodes AS s_rc 
		ON d_ae.SystemID = s_rc.SystemID 
			AND d_ae.DenialReason = s_rc.ReturnCodeID
WHERE d_ae.SystemID = @SystemID 
	AND d_ae.BpID = @BpID 
	AND d_ae.OwnerID = @EmployeeID 
	AND d_ae.PassType = 1
	AND d_ae.AccessOn >= @DateFrom
ORDER BY Timestamp DESC