CREATE PROCEDURE [dbo].[GetPassInfo]
	@InternalID nvarchar(50)
AS

DECLARE @Passes table
(
	SystemID int,
	BpID int,
	PassID int,
	StatusID int,
	OwnerID int,
	FirstName nvarchar(50),
	LastName nvarchar(50),
	ExternalID nvarchar(50),
	PassType int,
	PrintedOn datetime,
	AssignedOn datetime,
	ActivatedOn datetime,
	DeactivatedOn datetime,
	LockedOn datetime,
	IsDuplicate bit
);

-- Mitarbeiterausweise
INSERT INTO @Passes
(
	SystemID,
	BpID,
	PassID,
	StatusID,
	OwnerID,
	FirstName,
	LastName,
	ExternalID,
	PassType,
	PrintedOn,
	AssignedOn,
	ActivatedOn,
	DeactivatedOn,
	LockedOn,
	IsDuplicate
)
SELECT
	m_p.SystemID,
	m_p.BpID,
	m_p.PassID,
	(CASE WHEN m_p.PrintedOn IS NOT NULL AND m_p.ActivatedOn IS NULL AND m_p.DeactivatedOn IS NULL AND m_p.LockedOn IS NULL THEN 7 ELSE
		(CASE WHEN m_p.ActivatedOn IS NOT NULL AND m_p.DeactivatedOn IS NULL AND m_p.LockedOn IS NULL THEN 25 ELSE
			(CASE WHEN m_p.ActivatedOn IS NULL AND m_p.DeactivatedOn IS NOT NULL AND m_p.LockedOn IS NULL THEN -5 ELSE
				(CASE WHEN m_p.ActivatedOn IS NULL AND m_p.DeactivatedOn IS NULL AND m_p.LockedOn IS NOT NULL THEN -10 ELSE 0 END) 
			END) 
		END)
	END) AS StatusID,
	m_p.EmployeeID AS OwnerID,
	m_a.FirstName,
	m_a.LastName,
	m_p.ExternalID,
	1 AS PassType,
	m_p.PrintedOn,
	NULL AS AssignedOn,
	m_p.ActivatedOn,
	m_p.DeactivatedOn,
	m_p.LockedOn,
	0 AS IsDuplicate
FROM Master_Passes m_p
	LEFT OUTER JOIN Master_Employees m_e
		ON m_p.SystemID = m_e.SystemID
			AND m_p.BpID = m_e.BpID
			AND m_p.EmployeeID = m_e.EmployeeID 
	LEFT OUTER JOIN Master_Addresses m_a
		ON m_e.SystemID = m_a.SystemID
			AND m_e.BpID = m_a.BpID
			AND m_e.AddressID = m_a.AddressID
WHERE m_p.InternalID = @InternalID;

-- Kurzzeitausweise
INSERT INTO @Passes
(
	SystemID,
	BpID,
	PassID,
	StatusID,
	OwnerID,
	FirstName,
	LastName,
	ExternalID,
	PassType,
	PrintedOn,
	AssignedOn,
	ActivatedOn,
	DeactivatedOn,
	LockedOn,
	IsDuplicate
)
SELECT
	d_stp.SystemID,
	d_stp.BpID,
	d_stp.ShortTermPassID AS PassID,
	d_stp.StatusID,
	ISNULL(d_stv.ShortTermVisitorID, 0) AS OwnerID,
	d_stv.FirstName,
	d_stv.LastName,
	d_stp.ExternalID,
	2 AS PassType,
	d_stp.CreatedOn AS PrintedOn,
	d_stp.AssignedOn,
	d_stv.PassActivatedOn AS ActivatedOn,
	d_stv.PassDeactivatedOn AS DeactivatedOn,
	d_stv.PassLockedOn AS LockedOn,
	0 AS IsDuplicate
FROM Data_ShortTermPasses d_stp
	LEFT OUTER JOIN Data_ShortTermVisitors d_stv
		ON d_stp.SystemID = d_stv.SystemID
			AND d_stp.BpID = d_stv.BpID
			AND d_stp.ShortTermPassID = d_stv.ShortTermPassID 
WHERE d_stp.InternalID = @InternalID;

-- Duplikate feststellen
DECLARE @PassCount int;
SELECT @PassCount = COUNT(*) FROM @Passes WHERE ActivatedOn IS NOT NULL AND DeactivatedOn IS NULL AND LockedOn IS NULL;
IF (@PassCount > 1)
	UPDATE @Passes SET IsDuplicate = 1;

SELECT * FROM @Passes;

