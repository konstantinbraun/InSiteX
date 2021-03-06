﻿CREATE TABLE [dbo].[History_AccessAreas]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [AccessAreaID]           INT NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [AccessTimeRelevant]        BIT            DEFAULT 1 NOT NULL,
    [CheckInCompelling] BIT NOT NULL DEFAULT 1, 
    [UniqueAccess] BIT NOT NULL DEFAULT 1, 
    [CheckOutCompelling] BIT NOT NULL DEFAULT 1, 
    [CompleteAccessTimes] BIT NOT NULL DEFAULT 1, 
    [PresentTimeHours] INT NOT NULL DEFAULT 0, 
    [PresentTimeMinutes] INT NOT NULL DEFAULT 0, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_History_AccessAreas] PRIMARY KEY ([SystemID], [BpID], [AccessAreaID], [EditOn]), 
)
