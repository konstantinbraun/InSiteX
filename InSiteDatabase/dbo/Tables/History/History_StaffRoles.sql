﻿CREATE TABLE [dbo].[History_StaffRoles]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [StaffRoleID]           INT NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [IsVisible]        BIT            DEFAULT 1 NOT NULL,
    [IsFirstAider] BIT NOT NULL DEFAULT 0, 
    [IsDisposalExpert] BIT NOT NULL DEFAULT 0, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_History_StaffRoles] PRIMARY KEY ([SystemID], [BpID], [StaffRoleID], [EditOn]), 
)