CREATE TABLE [dbo].[Master_EmployeeWageGroupAssignment]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [EmployeeID]             INT            NOT NULL,
    [TariffWageGroupID]           INT            NOT NULL,
    [ValidFrom]      DATETIME  NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_Master_EmployeeWageGroupAssignment] PRIMARY KEY ([SystemID], [BpID], [EmployeeID], [TariffWageGroupID]), 
)
