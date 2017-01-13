CREATE PROCEDURE [dbo].[GetReportMWAttestationRequestDetails]
(
	@SystemID int,
	@BpID int,
	@MonthUntil date,
	@CompanyID int
)
AS

DECLARE @MWResult AS table
(
	SystemID int NOT NULL,
	BpID int NOT NULL,
	EmployeeID int NOT NULL,
	MWMonth date NOT NULL,
	PresenceSeconds bigint NOT NULL,
	StatusID int DEFAULT 0 NOT NULL,
	StatusCode nvarchar(10),
	Amount decimal(18,4), 
	RequestListID int, 
    CreatedFrom nvarchar(50), 
	CreatedOn datetime NOT NULL, 
	EditFrom nvarchar(50), 
	EditOn datetime NOT NULL, 
	FirstName nvarchar(50), 
	LastName nvarchar(50), 
	BirthDate date, 
	CompanyID int NOT NULL, 
	StaffFunction nvarchar(50),
	RequestedFrom nvarchar(50),
	RequestedOn date, 
	ReceivedFrom nvarchar(50), 
	ReceivedOn date, 
	WageE decimal(18,4), 
	WageC decimal(18,4), 
	Wage decimal(18,4), 
	ValidFrom datetime, 
	WageGroupName nvarchar(50),
	PRIMARY KEY (SystemID, BpID, EmployeeID, MWMonth) 
)
;

INSERT INTO @MWResult
(
	SystemID,
	BpID,
	EmployeeID,
	MWMonth,
	PresenceSeconds,
	StatusID,
	StatusCode,
	Amount, 
	RequestListID, 
    CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn, 
	FirstName, 
	LastName, 
	BirthDate, 
	CompanyID, 
	StaffFunction,
	RequestedFrom,
	RequestedOn, 
	ReceivedFrom, 
	ReceivedOn, 
	WageE,
	WageC,
	Wage, 
	ValidFrom, 
	WageGroupName 
)
SELECT DISTINCT 
	d_emw.SystemID, 
	d_emw.BpID, 
	d_emw.EmployeeID, 
	d_emw.MWMonth, 
	d_emw.PresenceSeconds, 
	0,
	'', 
	d_emw.Amount, 
	d_emw.RequestListID, 
    d_emw.CreatedFrom, 
	d_emw.CreatedOn, 
	d_emw.EditFrom, 
	d_emw.EditOn, 
	m_a.FirstName, 
	m_a.LastName, 
	m_a.BirthDate, 
	m_e.CompanyID, 
	m_e.StaffFunction,
	d_emw.RequestedFrom,
	d_emw.RequestedOn, 
	d_emw.ReceivedFrom, 
	d_emw.ReceivedOn, 
	MIN(ISNULL(s_tw_e.Wage, 0.0)),
	MIN(ISNULL(s_tw_c.Wage, 0.0)),
	MIN(CASE WHEN s_tw_e.Wage IS NULL THEN s_tw_c.Wage ELSE s_tw_e.Wage END), 
	MAX(CASE WHEN m_ewga.ValidFrom IS NULL THEN s_tw_c.ValidFrom ELSE m_ewga.ValidFrom END), 
	MAX(CASE WHEN s_twg_e.NameVisible IS NULL THEN (CASE WHEN s_tw_c.NameVisible IS NULL THEN 'LG-Zuordnung fehlt!' ELSE s_tw_c.NameVisible END) ELSE s_twg_e.NameVisible END) 
FROM Data_EmployeeMinWage AS d_emw
	INNER JOIN Master_Employees AS m_e           
		ON d_emw.SystemID = m_e.SystemID 
			AND d_emw.BpID = m_e.BpID 
			AND d_emw.EmployeeID = m_e.EmployeeID 
	LEFT OUTER JOIN Master_CompanyTariffs AS m_ct 
		ON m_e.SystemID = m_e.SystemID 
			AND m_e.BpID = m_e.BpID 
			AND m_ct.CompanyID = m_e.CompanyID 
	LEFT OUTER JOIN System_TariffWageGroups AS s_twg_c 
		ON m_ct.SystemID = s_twg_c.SystemID 
			AND m_ct.TariffScopeID = s_twg_c.TariffScopeID 
	LEFT OUTER JOIN System_TariffWages AS s_tw_c 
		ON s_twg_c.SystemID = s_tw_c.SystemID 
			AND s_twg_c.TariffID = s_tw_c.TariffID 
			AND s_twg_c.TariffContractID = s_tw_c.TariffContractID 
			AND s_twg_c.TariffScopeID = s_tw_c.TariffScopeID 
			AND s_twg_c.TariffWageGroupID = s_tw_c.TariffWageGroupID 
	INNER JOIN Master_Addresses AS m_a 
		ON m_e.SystemID = m_a.SystemID 
			AND m_e.BpID = m_a.BpID 
			AND m_e.AddressID = m_a.AddressID 
	LEFT OUTER JOIN Master_EmployeeWageGroupAssignment AS m_ewga 
		ON d_emw.SystemID = m_ewga.SystemID 
			AND d_emw.BpID = m_ewga.BpID 
			AND d_emw.EmployeeID = m_ewga.EmployeeID
	LEFT OUTER JOIN System_TariffWages AS s_tw_e 
		ON s_tw_e.SystemID = m_ewga.SystemID 
			AND s_tw_e.TariffWageGroupID = m_ewga.TariffWageGroupID 
	LEFT OUTER JOIN System_TariffWageGroups AS s_twg_e 
		ON s_tw_e.SystemID = s_twg_e.SystemID 
			AND s_tw_e.TariffWageGroupID = s_twg_e.TariffWageGroupID 
GROUP BY 
	d_emw.BpID, 
	d_emw.SystemID, 
	d_emw.EmployeeID, 
	d_emw.MWMonth, 
	d_emw.PresenceSeconds, 
	d_emw.StatusCode, 
	d_emw.Amount, 
	d_emw.RequestListID, 
    d_emw.CreatedFrom, 
	d_emw.CreatedOn, 
	d_emw.EditFrom, 
	d_emw.EditOn, 
	m_a.FirstName, 
	m_a.LastName, 
	m_a.BirthDate, 
	m_e.CompanyID, 
	m_e.StaffFunction,
	d_emw.RequestedFrom, 
    d_emw.RequestedOn, 
	d_emw.ReceivedFrom, 
	d_emw.ReceivedOn 
HAVING d_emw.SystemID = @SystemID 
		AND d_emw.BpID = @BpID
		AND d_emw.MWMonth <= @MonthUntil
		AND d_emw.StatusCode IN (1, 3, 4, 5) 
		AND m_e.CompanyID = @CompanyID 
		AND ((MAX(m_ewga.ValidFrom) <= CAST(d_emw.MWMonth AS datetime) OR MAX(m_ewga.ValidFrom) IS NULL)
			OR (MAX(s_tw_c.ValidFrom) <= CAST(d_emw.MWMonth AS datetime) OR MAX(s_tw_c.ValidFrom) IS NULL))
;

UPDATE @MWResult
SET StatusID = 
CASE 
	WHEN Amount = 0 THEN 1
	WHEN Amount >= WageC AND Amount >= WageE THEN 2 
	WHEN Amount >= WageC AND Amount < WageE THEN 4
	WHEN Amount < WageC THEN 5
	ELSE 3
END
;

UPDATE @MWResult
SET StatusCode = dbo.GetMWStatusCode(StatusID)
;

SELECT
	SystemID,
	BpID,
	EmployeeID,
	MWMonth,
	PresenceSeconds,
	StatusCode,
	Amount, 
	RequestListID, 
    CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn, 
	FirstName, 
	LastName, 
	BirthDate, 
	CompanyID, 
	StaffFunction,
	RequestedFrom,
	RequestedOn, 
	ReceivedFrom, 
	ReceivedOn, 
	WageE,
	WageC,
	Wage, 
	ValidFrom, 
	WageGroupName 
FROM @MWResult
WHERE StatusID IN (1, 3, 4, 5) 
; 
