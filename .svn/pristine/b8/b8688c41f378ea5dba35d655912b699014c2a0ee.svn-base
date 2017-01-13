CREATE TABLE [dbo].[Master_EmploymentStatus]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [EmploymentStatusID] INT NOT NULL IDENTITY,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [MWObligate] BIT NOT NULL DEFAULT 1, 
    [MWFrom] DATETIME NULL, 
    [MWTo] DATETIME NULL, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NOT NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_Master_EmploymentStatus] PRIMARY KEY ([SystemID], [BpID], [EmploymentStatusID]), 
)
