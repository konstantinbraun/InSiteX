CREATE PROCEDURE [dbo].[GetPresenceCountTrend]
	@SystemID int,
	@BpID int
AS

SELECT AccessHour, COUNT(c.OwnerID)
FROM (SELECT DATEPART(HOUR, d_ae.AccessOn) AS AccessHour, d_ae.OwnerID
		FROM Data_AccessEvents d_ae
			INNER JOIN Master_Passes m_p
				ON m_p.SystemID = d_ae.SystemID
					AND m_p.BpID = d_ae.BpID
					AND m_p.InternalID = d_ae.InternalID
		WHERE d_ae.SystemID = @SystemID 
			AND d_ae.BpID = @BpID
			AND d_ae.AccessResult = 1
			AND d_ae.AccessOn BETWEEN DATEADD(DAY, -1, SYSDATETIME()) AND SYSDATETIME()
			AND 
			(
				SELECT SUM(CASE WHEN d_ae1.AccessType > 0 THEN 1 ELSE -1 END) 
				FROM Data_AccessEvents AS d_ae1 
				WHERE d_ae1.SystemID = d_ae.SystemID
					AND d_ae1.BpID = d_ae.BpID
					AND d_ae1.OwnerID = d_ae.OwnerID
					AND d_ae1.InternalID = d_ae.InternalID
					AND d_ae1.AccessResult = 1
			) >= 1
		GROUP BY DATEPART(HOUR, d_ae.AccessOn),
			d_ae.OwnerID
	) AS c 
GROUP BY AccessHour

