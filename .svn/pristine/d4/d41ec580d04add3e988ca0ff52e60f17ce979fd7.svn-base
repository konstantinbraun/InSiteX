CREATE PROCEDURE [dbo].[TreeItemHasActiveChildItems]
(
	@SystemID int,
	@BpID int,
	@RoleID int,
	@DialogID int
)
AS

DECLARE @ActiveChilds int;

WITH Nodes AS
(
	SELECT m_tn.SystemID, m_tn.NodeID, m_tn.ParentID, m_tn.DialogID, m_r_d.BpID, m_r_d.RoleID
	FROM Master_TreeNodes AS m_tn 
		INNER JOIN Master_Roles_Dialogs AS m_r_d 
			ON m_tn.SystemID = m_r_d.SystemID 
				AND m_tn.DialogID = m_r_d.DialogID
	WHERE m_tn.SystemID = @SystemID 
		AND m_tn.DialogID = @DialogID 
		AND m_r_d.BpID = @BpID 
		AND m_r_d.RoleID = @RoleID
		AND m_r_d.IsActive = 1

	UNION ALL
	
	SELECT m_tn.SystemID, m_tn.NodeID, m_tn.ParentID, m_tn.DialogID, m_r_d.BpID, m_r_d.RoleID
	FROM Master_TreeNodes AS m_tn 
		INNER JOIN Master_Roles_Dialogs AS m_r_d 
			ON m_tn.SystemID = m_r_d.SystemID 
				AND m_tn.DialogID = m_r_d.DialogID
		INNER JOIN Nodes
			ON Nodes.SystemID = m_tn.SystemID
				AND Nodes.NodeID = m_tn.ParentID
	WHERE m_r_d.IsActive = 1
)
SELECT @ActiveChilds = COUNT(NodeID) - 1
FROM Nodes; 
