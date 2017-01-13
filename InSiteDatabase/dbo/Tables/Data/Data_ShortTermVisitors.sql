﻿CREATE TABLE [dbo].[Data_ShortTermVisitors]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [ShortTermVisitorID]           INT            IDENTITY (1, 1) NOT NULL,
    [Salutation]       NVARCHAR (50)  NULL,
    [FirstName]   NVARCHAR (50) NULL,
    [LastName]    NVARCHAR (50) NULL,
    [Company]     NVARCHAR (100) NULL,
    [NationalityID] NVARCHAR(10) NOT NULL DEFAULT 'GB', 
    [IdentifiedWith]     NVARCHAR (100) NULL,
    [DocumentID]    NVARCHAR (50) NULL,
    [AssignedCompanyID]             INT            NOT NULL DEFAULT 0,
    [AssignedEmployeeID]             INT            NOT NULL DEFAULT 0,
    [AccessAllowedUntil]        DATETIME NULL,
    [LastAccess] DATETIME NULL, 
    [LastExit] DATETIME NULL, 
    [ShortTermPassID]           INT        NOT NULL,
    [ShortTermPassTypeID] INT NULL, 
    [PassStatusID] INT NOT NULL DEFAULT 0, 
    [PassInternalID] NVARCHAR(50) NULL, 
    [PassActivatedFrom] NVARCHAR(50) NULL, 
    [PassActivatedOn] DATETIME NULL, 
    [PassDeactivatedFrom] NVARCHAR(50) NULL, 
    [PassDeactivatedOn] DATETIME NULL, 
    [PassLockedFrom] NVARCHAR(50) NULL, 
    [PassLockedOn] DATETIME NULL, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_Data_ShortTermVisitors] PRIMARY KEY ([SystemID], [BpID], [ShortTermVisitorID]), 
)
