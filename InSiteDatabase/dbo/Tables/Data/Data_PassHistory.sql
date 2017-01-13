CREATE TABLE [dbo].[Data_PassHistory]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [PassID]           INT            NOT NULL,
    [EmployeeID]             INT            NOT NULL, 
    [Timestamp] DATETIME NOT NULL DEFAULT SYSDATETIME(), 
    [Reason] NVARCHAR(200) NULL, 
    [ActionID] INT NULL , 
    [ReplacementPassCaseID] INT NULL, 
    CONSTRAINT [PK_Data_PassHistory] PRIMARY KEY ([SystemID], [BpID], [PassID], [EmployeeID], [Timestamp]),
)
