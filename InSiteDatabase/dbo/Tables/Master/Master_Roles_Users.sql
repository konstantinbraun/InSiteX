CREATE TABLE [dbo].[Master_Roles_Users]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [RoleID]           INT            NOT NULL,
    [UserID]      INT           NOT NULL, 
    CONSTRAINT [PK_Master_Roles_Users] PRIMARY KEY ([SystemID], [BpID], [RoleID], [UserID])
)
