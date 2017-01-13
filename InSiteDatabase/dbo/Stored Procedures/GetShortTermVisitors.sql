CREATE PROCEDURE [dbo].[GetShortTermVisitors]
	@SystemID int,
	@BpID int
AS

SELECT DISTINCT
	d_stv.ShortTermVisitorID, 
	m_stpt.NameVisible AS TypeName, 
	d_stv.PassInternalID AS InternalID, 
	(CASE WHEN d_stv.PassStatusID = 25 AND d_stv.AccessAllowedUntil < SYSDATETIME() THEN -2 ELSE d_stv.PassStatusID END) AS StatusID, 
	d_stv.FirstName, 
	d_stv.LastName, 
	d_stv.Company, 
	m_c.NameVisible AS CompanyName, 
	m_a.FirstName + ' ' + m_a.LastName AS EmployeeName, 
	d_stv.AccessAllowedUntil, 
	d_stv.EditOn, 
	d_stv.PassActivatedFrom AS ActivatedFrom, 
	d_stv.PassActivatedOn AS ActivatedOn, 
	d_stv.PassDeactivatedFrom AS DeactivatedFrom, 
	d_stv.PassDeactivatedOn AS DeactivatedOn, 
	ISNULL((SELECT MAX(AccessOn) FROM Data_AccessEvents WHERE SystemID = @SystemID AND BpID = @BpID AND OwnerID = d_stv.ShortTermVisitorID AND AccessType = 1 AND AccessResult = 1), d_stv.PassActivatedOn) AS LastAccess,
	ISNULL((SELECT MAX(AccessOn) FROM Data_AccessEvents WHERE SystemID = @SystemID AND BpID = @BpID AND OwnerID = d_stv.ShortTermVisitorID AND AccessType = 0 AND AccessResult = 1), d_stv.PassActivatedOn) AS LastExit,
	d_stv.CreatedFrom, 
	d_stv.CreatedOn, 
	d_stv.EditFrom, 
	d_stv.Salutation, 
	d_stv.ShortTermPassID, 
	d_stv.IdentifiedWith, 
	d_stv.AssignedCompanyID, 
	d_stv.AssignedEmployeeID, 
	d_stv.SystemID, 
	d_stv.BpID, 
	d_stv.DocumentID, 
	d_stv.FirstName + ' ' + d_stv.LastName AS VisitorName, 
	d_stv.PassLockedFrom AS LockedFrom, 
	d_stv.PassLockedOn AS LockedOn, 
	d_stv.NationalityID, 
	dbo.ShortTermPresentState(d_stv.SystemID, d_stv.BpID, d_stv.ShortTermVisitorID) AS Present,
	ISNULL((SELECT MAX(AccessOn) FROM Data_AccessEvents WHERE SystemID = @SystemID AND BpID = @BpID AND OwnerID = d_stv.ShortTermVisitorID AND InternalID = d_stv.PassInternalID AND AccessResult = 1), d_stv.PassActivatedOn) AS AccessTime
FROM Master_Addresses AS m_a 
	INNER JOIN Master_Employees AS m_e 
		ON m_a.SystemID = m_e.SystemID 
			AND m_a.BpID = m_e.BpID 
			AND m_a.AddressID = m_e.AddressID 
	RIGHT OUTER JOIN Data_ShortTermVisitors AS d_stv 
	INNER JOIN Master_ShortTermPassTypes AS m_stpt 
		ON d_stv.SystemID = m_stpt.SystemID 
			AND d_stv.BpID = m_stpt.BpID 
			AND d_stv.ShortTermPassTypeID = m_stpt.ShortTermPassTypeID 
		ON m_e.SystemID = d_stv.SystemID 
			AND m_e.BpID = d_stv.BpID 
			AND m_e.EmployeeID = d_stv.AssignedEmployeeID 
	LEFT OUTER JOIN Master_Companies AS m_c 
		ON d_stv.SystemID = m_c.SystemID 
			AND d_stv.BpID = m_c.BpID 
			AND d_stv.AssignedCompanyID = m_c.CompanyID 
WHERE d_stv.SystemID = @SystemID 
	AND d_stv.BpID = @BpID 
ORDER BY StatusID DESC, d_stv.AccessAllowedUntil DESC, d_stv.EditOn DESC
