CREATE TABLE [dbo].[Master_EmployeeQualification]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [EmployeeID]             INT            NOT NULL,
    [StaffRoleID]           INT            NOT NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_Master_EmployeeQualification] PRIMARY KEY ([SystemID], [BpID], [EmployeeID], [StaffRoleID]), 
)
