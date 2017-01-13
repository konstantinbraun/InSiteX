use Insite_Dev
go

begin transaction
insert into Master_UserBuildingProjects(SystemID, BpID, RoleID, UserID, EditFrom)
select 1, 
	MBP.BpID,
	(select m_r.RoleID from Master_Roles m_r where m_r.BpID = MBP.BpID and m_r.NameVisible = 'root'),
	(select UserID from Master_Users where LoginName = 'Seuthed'),
	'Seuthed'
from Master_BuildingProjects MBP where MBP.BpID not in (
	select m_ubp.BpID
	from Master_UserBuildingProjects m_ubp
		inner join Master_Users m_u on m_ubp.UserID = m_u.UserID
		inner join Master_Roles m_r on m_r.RoleID = m_ubp.RoleID
	where m_u.LoginName = 'Seuthed')
rollback
--commit