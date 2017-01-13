CREATE PROCEDURE [dbo].[GetPresentFirstAiders]
	@SystemID int,
	@BpID int
AS
BEGIN
	SELECT
		m_c.CompanyID, 
		m_a.AddressID, 
		m_a.FirstName, 
		m_a.LastName, 
		m_a.Phone AS Mobile, 
		m_c.NameVisible AS CompanyName, 
		m_aa.NameVisible AS AccessArea
	FROM Master_StaffRoles AS m_sr 
		RIGHT OUTER JOIN Master_EmployeeQualification AS m_eq 
			ON m_sr.SystemID = m_eq.SystemID 
				AND m_sr.BpID = m_eq.BpID 
				AND m_sr.StaffRoleID = m_eq.StaffRoleID 
		RIGHT OUTER JOIN
		(
			SELECT
				d_ae.SystemID, 
				d_ae.BpID, 
				d_ae.OwnerID
	        FROM Data_AccessEvents AS d_ae 
				INNER JOIN Master_Passes AS m_p 
					ON m_p.SystemID = d_ae.SystemID 
						AND m_p.BpID = d_ae.BpID 
						AND m_p.InternalID = d_ae.InternalID
	        WHERE d_ae.SystemID = @SystemID 
				AND d_ae.BpID = @BpID 
				AND d_ae.AccessResult = 1 
				AND 
				(
					(
						SELECT SUM(CASE WHEN d_ae1.AccessType > 0 THEN 1 ELSE - 1 END)
	                    FROM Data_AccessEvents AS d_ae1
						WHERE d_ae1.SystemID = d_ae.SystemID 
							AND d_ae1.BpID = d_ae.BpID 
							AND d_ae1.OwnerID = d_ae.OwnerID
							AND d_ae1.InternalID = d_ae.InternalID
							AND d_ae1.AccessResult = 1
					) >= 1
				)
			GROUP BY 
				d_ae.SystemID, 
				d_ae.BpID, 
				d_ae.OwnerID
		) AS c 
		INNER JOIN Master_Employees AS m_e 
			ON c.SystemID = m_e.SystemID 
				AND c.BpID = m_e.BpID 
				AND c.OwnerID = m_e.EmployeeID 
		INNER JOIN Master_EmployeeAccessAreas AS m_eaa
			ON m_e.SystemID = m_eaa.SystemID 
				AND m_e.BpID = m_eaa.BpID 
				AND m_e.EmployeeID = m_eaa.EmployeeID
		INNER JOIN Master_AccessAreas AS m_aa 
			ON m_eaa.AccessAreaID = m_aa.AccessAreaID 
		INNER JOIN Master_Addresses AS m_a ON 
			m_a.AddressID = m_e.AddressID  
		INNER JOIN Master_Companies AS m_c 
			ON m_e.SystemID = m_c.SystemID 
				AND m_e.BpID = m_c.BpID 
				AND m_e.CompanyID = m_c.CompanyID 
			ON m_eq.SystemID = m_e.SystemID 
				AND m_eq.BpID = m_e.BpID 
				AND m_eq.EmployeeID = m_e.EmployeeID
		WHERE m_sr.IsFirstAider = 1 AND m_e.LockedOn IS NULL
		ORDER BY m_c.NameVisible, m_a.LastName
END