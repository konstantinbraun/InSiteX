CREATE PROCEDURE [dbo].[GetShortTermPasses]
	@SystemID int,
	@BpID int,
	@ShortTermPassID int = 0
AS

SELECT 
	d_stv.SystemID, 
	d_stv.BpID,
	d_stv.ShortTermVisitorID,
	d_stv.Salutation,
	d_stv.NationalityID,
	d_stv.FirstName,
	d_stv.LastName,
	d_stv.Company,
	d_stv.IdentifiedWith,
	d_stv.DocumentID,
	d_stv.AssignedCompanyID,
	d_stv.AssignedEmployeeID,
	d_stv.AccessAllowedUntil,
	d_stv.LastAccess,
	d_stv.LastExit,
	d_stv.ShortTermPassID,
	d_stv.ShortTermPassTypeID,
	d_stv.PassStatusID,
	d_stv.PassInternalID,
	d_stv.PassActivatedFrom,
	d_stv.PassActivatedOn,
	d_stv.PassDeactivatedFrom,
	d_stv.PassDeactivatedOn,
	d_stv.PassLockedFrom,
	d_stv.PassLockedOn,
	d_stv.CreatedFrom,
	d_stv.CreatedOn,
	d_stv.EditFrom,
	d_stv.EditOn,
	m_stpt.NameVisible AS TypeName, 
	d_stp.ExternalID
FROM Data_ShortTermVisitors AS d_stv 
	INNER JOIN Data_ShortTermPasses AS d_stp
		ON d_stv.SystemID = d_stp.SystemID 
			AND d_stv.BpID = d_stp.BpID 
			AND d_stv.ShortTermPassID = d_stp.ShortTermPassID
	INNER JOIN Master_ShortTermPassTypes AS m_stpt 
		ON d_stv.SystemID = m_stpt.SystemID 
			AND d_stv.BpID = m_stpt.BpID 
			AND d_stv.ShortTermPassTypeID = m_stpt.ShortTermPassTypeID
WHERE d_stv.SystemID = @SystemID 
	AND d_stv.BpID = @BpID 
	AND d_stv.ShortTermPassID = @ShortTermPassID
ORDER BY d_stv.EditOn DESC
