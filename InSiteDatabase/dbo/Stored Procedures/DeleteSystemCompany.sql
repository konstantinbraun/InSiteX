CREATE PROCEDURE [dbo].[DeleteSystemCompany]
(
	@SystemID int,
	@CompanyID int
)
AS

BEGIN TRANSACTION

	BEGIN TRY

		-- Mitarbeiter der zugeordneten BV-Firmen mit allen Unterstrukturen löschen
		DELETE m_eaa FROM Master_EmployeeAccessAreas m_eaa
		WHERE m_eaa.SystemID = @SystemID
			AND EXISTS
			(
				SELECT *
				FROM Master_Companies m_c
					INNER JOIN Master_Employees m_e
						ON m_c.SystemID = m_e.SystemID
							AND m_c.BpID = m_e.BpID
							AND m_c.CompanyID = m_e.CompanyID
				WHERE m_c.SystemID = m_eaa.SystemID
					AND m_c.CompanyCentralID = @CompanyID 
					AND m_e.EmployeeID = m_eaa.EmployeeID
			)

		DELETE m_eaa FROM Master_EmployeeMinWageAttestation m_eaa
		WHERE m_eaa.SystemID = @SystemID
			AND EXISTS
			(
				SELECT *
				FROM Master_Companies m_c
					INNER JOIN Master_Employees m_e
						ON m_c.SystemID = m_e.SystemID
							AND m_c.BpID = m_e.BpID
							AND m_c.CompanyID = m_e.CompanyID
				WHERE m_c.SystemID = m_eaa.SystemID
					AND m_c.CompanyCentralID = @CompanyID 
					AND m_e.EmployeeID = m_eaa.EmployeeID
			)

		DELETE m_eaa FROM Master_EmployeeQualification m_eaa
		WHERE m_eaa.SystemID = @SystemID
			AND EXISTS
			(
				SELECT *
				FROM Master_Companies m_c
					INNER JOIN Master_Employees m_e
						ON m_c.SystemID = m_e.SystemID
							AND m_c.BpID = m_e.BpID
							AND m_c.CompanyID = m_e.CompanyID
				WHERE m_c.SystemID = m_eaa.SystemID
					AND m_c.CompanyCentralID = @CompanyID 
					AND m_e.EmployeeID = m_eaa.EmployeeID
			)

		DELETE m_eaa FROM Master_EmployeeRelevantDocuments m_eaa
		WHERE m_eaa.SystemID = @SystemID
			AND EXISTS
			(
				SELECT *
				FROM Master_Companies m_c
					INNER JOIN Master_Employees m_e
						ON m_c.SystemID = m_e.SystemID
							AND m_c.BpID = m_e.BpID
							AND m_c.CompanyID = m_e.CompanyID
				WHERE m_c.SystemID = m_eaa.SystemID
					AND m_c.CompanyCentralID = @CompanyID 
					AND m_e.EmployeeID = m_eaa.EmployeeID
			)

		DELETE m_eaa FROM Master_EmployeeWageGroupAssignment m_eaa
		WHERE m_eaa.SystemID = @SystemID
			AND EXISTS
			(
				SELECT *
				FROM Master_Companies m_c
					INNER JOIN Master_Employees m_e
						ON m_c.SystemID = m_e.SystemID
							AND m_c.BpID = m_e.BpID
							AND m_c.CompanyID = m_e.CompanyID
				WHERE m_c.SystemID = m_eaa.SystemID
					AND m_c.CompanyCentralID = @CompanyID 
					AND m_e.EmployeeID = m_eaa.EmployeeID
			)

		INSERT INTO History_Employees
		SELECT m_e.* 
		FROM Master_Employees m_e
		WHERE m_e.SystemID = @SystemID
			AND EXISTS
			(
				SELECT *
				FROM Master_Companies m_c
				WHERE m_c.SystemID = m_e.SystemID
					AND m_c.CompanyID = m_e.CompanyID
					AND m_c.CompanyCentralID = @CompanyID 
			)

		DELETE m_e  
		FROM Master_Employees m_e
		WHERE m_e.SystemID = @SystemID
			AND EXISTS
			(
				SELECT *
				FROM Master_Companies m_c
				WHERE m_c.SystemID = m_e.SystemID
					AND m_c.CompanyID = m_e.CompanyID
					AND m_c.CompanyCentralID = @CompanyID 
			)

		-- BV Firma historisieren
		INSERT INTO History_Companies
		SELECT *
		FROM Master_Companies
		WHERE SystemID = @SystemID
			AND CompanyCentralID = @CompanyID 

		-- BV Firma löschen
		DELETE Master_Companies
		WHERE SystemID = @SystemID
			AND CompanyCentralID = @CompanyID 

		-- Zuordnung Benutzer zu Bauvorhaben löschen
		DELETE m_ubp FROM Master_UserBuildingProjects m_ubp
		WHERE m_ubp.SystemID = @SystemID
			AND EXISTS 
			(
				SELECT *
				FROM Master_Users m_u
				WHERE m_u.SystemID = m_ubp.SystemID
					AND m_u.UserID = m_ubp.UserID
					AND m_u.CompanyID = @CompanyID 
			)

		-- Benutzer historiseren
		INSERT INTO History_Users
		SELECT *
		FROM Master_Users
		WHERE SystemID = @SystemID
			AND CompanyID = @CompanyID

		-- Einträge für Benutzer in Vorgangsverwaltung löschen
        DELETE d_pe 
		FROM Data_ProcessEvents d_pe
        WHERE d_pe.SystemID = @SystemID 
			AND d_pe.BpID = 0 
			AND d_pe.DialogID = 92
			AND EXISTS
			(
				SELECT 1
				FROM Master_Users m_u
				WHERE m_u.SystemID = @SystemID
					AND m_u.UserID = d_pe.RefID
					AND m_u.CompanyID = @CompanyID
			)
		; 

		-- Benutzer löschen
		DELETE FROM Master_Users
		WHERE SystemID = @SystemID
			AND CompanyID = @CompanyID

		-- Zugeordnete Tarife löschen
		DELETE FROM System_CompanyTariffs
		WHERE SystemID = @SystemID
			AND CompanyID = @CompanyID

		-- Firma historisieren
		INSERT INTO History_S_Companies
		SELECT *
		FROM System_Companies
		WHERE SystemID = @SystemID
			AND CompanyID = @CompanyID

		-- Einträge für Firma in Vorgangsverwaltung löschen
		DELETE FROM Data_ProcessEvents
        WHERE SystemID = @SystemID 
			AND BpID = 0 
			AND DialogID = 91 
			AND RefID = @CompanyID;

		-- Firma löschen
		DELETE FROM System_Companies
		WHERE SystemID = @SystemID
			AND CompanyID = @CompanyID
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION
		RETURN -1
	END CATCH

COMMIT TRANSACTION
RETURN 0
