CREATE TABLE [dbo].[History_Roles] (
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [RoleID]           INT NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [TypeID]           TINYINT        DEFAULT ((1)) NOT NULL,
    [IsVisible]        BIT            DEFAULT ((1)) NOT NULL,
    [ShowInList] BIT NOT NULL DEFAULT 1, 
    [SelfAndSubcontractors] BIT NOT NULL DEFAULT 0, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [PK_History_Role] PRIMARY KEY CLUSTERED ([SystemID], [BpID], [RoleID], [EditOn])
);
