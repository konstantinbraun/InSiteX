CREATE FUNCTION [dbo].[GetCountWithSubcontractors]
(
	@SystemID int,
	@BpID int,
	@CompanyID int,
	@DateFrom datetime,
	@DateUntil datetime 
)
RETURNS INT
AS
BEGIN
	DECLARE @CountAs int = 0;

	DECLARE @CompaniesPresenceData table
	(
		SystemID int,
		BpID int,
		CompanyID int,
		ParentID int,
		CountAs int,
		PresenceSeconds bigint
	)

	INSERT INTO @CompaniesPresenceData
	(
		SystemID,
		BpID,
		CompanyID,
		ParentID,
		CountAs,
		PresenceSeconds
	)
	SELECT        
		m_c.SystemID, 
		m_c.BpID, 
		m_c.CompanyID, 
		m_c.ParentID, 
		SUM(CAST(ISNULL(d_pc.CountAs, 0) AS int)) AS CountAs, 
		SUM(ISNULL(d_pc.PresenceSeconds, 0)) AS PresenceSeconds
	FROM Master_Companies AS m_c 
		LEFT OUTER JOIN Data_PresenceCompany AS d_pc 
			ON m_c.SystemID = d_pc.SystemID 
				AND m_c.BpID = d_pc.BpID 
				AND m_c.CompanyID = d_pc.CompanyID
		WHERE m_c.SystemID = @SystemID
			AND m_c.BpID = @BpID
			AND (d_pc.PresenceDay BETWEEN @DateFrom AND @DateUntil OR d_pc.PresenceDay IS NULL)
	GROUP BY 
		m_c.SystemID, 
		m_c.BpID, 
		m_c.CompanyID, 
		m_c.ParentID
	;

	WITH PresenceData AS
	(
		SELECT 
			d_pc.SystemID,
			d_pc.BpID,
			d_pc.CompanyID,
			d_pc.CountAs
		FROM @CompaniesPresenceData AS d_pc
		WHERE d_pc.CompanyID = @CompanyID

		UNION ALL

		SELECT 
			d_pc.SystemID,
			d_pc.BpID,
			d_pc.CompanyID,
			d_pc.CountAs
		FROM @CompaniesPresenceData AS d_pc
			INNER JOIN PresenceData AS p
				ON d_pc.SystemID = p.SystemID
					AND d_pc.BpID = p.BpID
					AND d_pc.ParentID = p.CompanyID
	)
	SELECT 
		@CountAs = SUM(CountAs)
	FROM PresenceData
	;

	RETURN @CountAs;
END
