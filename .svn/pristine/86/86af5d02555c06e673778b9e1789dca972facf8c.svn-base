-- Zutrittsereignisse von einem bestimmten Ausweis
select d_a.BpID, d_a.AccessEventID, d_a.AccessOn, d_a.AccessType, d_a.AccessResult, d_a.IsManualEntry, d_a.CreatedOn, d_a.CreatedFrom, d_a.EditOn, d_a.EditFrom, m_a.LastName, m_a.FirstName, m_p.InternalID as EmployeePass, d_stp.InternalID as VisitorPass
from Master_Employees m_e inner join
	Master_Addresses m_a on m_e.AddressID = m_a.AddressID inner join
	Data_AccessEvents d_a on d_a.OwnerID = m_e.EmployeeID left join
	Master_Passes m_p on m_p.EmployeeID = m_e.EmployeeID left join
	Data_ShortTermPasses d_stp on d_stp.ShortTermVisitorID = d_a.OwnerID
where --m_a.LastName = 'Todorov' and m_a.FirstName = 'Leonid' and
	(d_a.AccessOn between '2016-11-28T00:00:00' and '2016-11-30T00:00:00' and
	(m_p.InternalID = '04138CE2663480' or d_stp.InternalID = '04138CE2663480')) or
	d_a.AccessEventID in (2046109, 2046116, 2045891, 2045688)
	--DATEDIFF(day, d_a.AccessOn, d_a.CreatedOn) > 1 and
	--d_a.CreatedFrom = 'Aditus'
order by --d_a.AccessOn
	d_a.AccessEventID --desc
--
-- Zu welcher Stunde treten wieviel Zutrittsereignisse auf
select
	Count(d_a.AccessEventID) as Menge,
	DATEPART(hour, DATEADD(minute, 0, d_a.AccessOn)) as Stunde
from Data_AccessEvents d_a
where d_a.AccessOn between '2016-01-01T00:00:00' and '2016-12-31T23:59:59'
group by DATEPART(hour, DATEADD(minute, 0, d_a.AccessOn))
order by stunde
--
-- Differenz zwischen Zutrittsereignis und Meldung an InSite 
select
	count(d_a.AccessOn) AccessCount,
	--d_a.CreatedOn,
	DATEDIFF(minute, d_a.AccessOn, d_a.CreatedOn) TimeDiff
from Data_AccessEvents d_a
where d_a.AccessOn between '2016-01-01T00:00:00' and '2016-12-31T23:59:59' and
	d_a.CreatedFrom = 'Aditus' and
	DATEDIFF(hour, d_a.AccessOn, d_a.CreatedOn) = 0
group by DATEDIFF(minute, d_a.AccessOn, d_a.CreatedOn)
order by --TimeDiff
	AccessCount desc
