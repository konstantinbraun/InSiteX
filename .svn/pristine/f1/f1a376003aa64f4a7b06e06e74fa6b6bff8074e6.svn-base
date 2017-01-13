CREATE TABLE [dbo].[Data_EmployeeAccessLog]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [PassID]           INT            NOT NULL,
    [EmployeeID]             INT            NOT NULL,
    [AccessAreaID]           INT            NOT NULL,
    [Timestamp] DATETIME NOT NULL DEFAULT SYSDATETIME(),
	AccessTypeID int NOT NULL DEFAULT 0,
    [Result]      NVARCHAR (200)  NULL, 
    CONSTRAINT [PK_Data_EmployeeAccessLog] PRIMARY KEY ([SystemID], [BpID], [PassID], [EmployeeID], [AccessAreaID], [Timestamp]),
)
