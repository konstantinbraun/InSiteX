CREATE PROCEDURE [dbo].[UpdateEmployeeMwStatus]
	@SystemID int,
	@BpID int
AS

DECLARE @MWCheck bit = 0;
DECLARE @MWSeconds bigint;

SELECT 
	@MWCheck = MWCheck,
	@MWSeconds = ISNULL(MWHours, 0) * 3600
FROM Master_BuildingProjects
WHERE SystemID = @SystemID
	AND BpID = @BpID
;

UPDATE mw1
SET StatusCode = 
(
	CASE 
		WHEN mw1.PresenceSeconds <= @MWSeconds 
		THEN 0
		WHEN mw1.Amount >= mw2.Wage_C AND mw1.Amount >= mw2.Wage_E 
		THEN 2 
		WHEN mw1.Amount = 0 
		THEN 1 
		WHEN mw1.Amount < 0 
		THEN 5 
		WHEN mw1.Amount >= mw2.Wage_C AND mw1.Amount < mw2.Wage_E 
		THEN 4 
		WHEN mw1.Amount < mw2.Wage_C 
		THEN 3 
		ELSE 0 
	END
)
FROM Data_EmployeeMinWage AS mw1
	INNER JOIN
	( 
		SELECT 
			d_emw.SystemID,
			d_emw.BpID,
			d_emw.EmployeeID,
			d_emw.MWMonth,
			MIN(ISNULL(s_tw_c.Wage, 0)) AS Wage_C, 
			MIN(ISNULL(s_tw_e.Wage, 0)) AS Wage_E, 
			MAX(m_ewga.ValidFrom) AS ValidFrom_E, 
			MAX(s_tw_c.ValidFrom) AS ValidFrom_C,
			MAX(d_pe.PresenceSeconds) AS PresenceSeconds
		FROM Data_EmployeeMinWage AS d_emw 
			INNER JOIN 
			(
				SELECT 
					SystemID, 
					BpID, 
					EmployeeID, 
					SUM(ISNULL(PresenceSeconds, 0)) AS PresenceSeconds 
				FROM Data_PresenceEmployee 
				WHERE PresenceDay BETWEEN dbo.BeginOfMonth(PresenceDay) AND dbo.EndOfMonth(PresenceDay) 
				GROUP BY 
					SystemID, 
					BpID, 
					EmployeeID
				HAVING SystemID = @SystemID 
					AND BpID = @BpID 
			) AS d_pe 
				ON d_emw.SystemID = d_pe.SystemID 
					AND d_emw.BpID = d_pe.BpID 
					AND d_emw.EmployeeID = d_pe.EmployeeID 
			INNER JOIN Master_Employees AS m_e 
				ON d_emw.SystemID = m_e.SystemID 
					AND d_emw.BpID = m_e.BpID 
					AND d_emw.EmployeeID = m_e.EmployeeID 
			INNER JOIN Master_Addresses AS m_a 
				ON m_e.SystemID = m_a.SystemID 
					AND m_e.BpID = m_a.BpID 
					AND m_e.AddressID = m_a.AddressID 
			LEFT OUTER JOIN Master_CompanyTariffs AS m_ct 
				ON m_ct.SystemID = m_e.SystemID 
					AND m_ct.BpID = m_e.BpID 
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
			LEFT OUTER JOIN Master_EmployeeWageGroupAssignment AS m_ewga 
				ON d_emw.SystemID = m_ewga.SystemID 
					AND d_emw.BpID = m_ewga.BpID 
					AND d_emw.EmployeeID = m_ewga.EmployeeID
			LEFT OUTER JOIN System_TariffWages AS s_tw_e 
				ON s_tw_e.SystemID = m_ewga.SystemID 
					AND s_tw_e.TariffWageGroupID = m_ewga.TariffWageGroupID 
		GROUP BY 
			d_emw.SystemID, 
			d_emw.BpID,
			d_emw.EmployeeID,
			d_emw.MWMonth
		HAVING (MAX(m_ewga.ValidFrom) <= CAST(d_emw.MWMonth AS datetime) 
				OR MAX(m_ewga.ValidFrom) IS NULL) 
			AND (d_emw.SystemID = @SystemID) 
			AND (d_emw.BpID = @BpID) 
				OR (d_emw.SystemID = @SystemID) 
			AND (d_emw.BpID = @BpID) 
			AND (MAX(s_tw_c.ValidFrom) <= CAST(d_emw.MWMonth AS datetime) 
				OR MAX(s_tw_c.ValidFrom) IS NULL)
	) AS mw2
		ON mw1.SystemID = mw2.SystemID
			AND mw1.BpID = mw2.BpID
			AND mw1.EmployeeID = mw2.EmployeeID
			AND mw1.MWMonth = mw2.MWMonth
WHERE mw1.SystemID = @SystemID
	AND mw1.BpID = @BpID
;