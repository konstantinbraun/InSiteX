CREATE TABLE [dbo].[Master_FirstAiders]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [FirstAiderID]           INT            IDENTITY (1, 1) NOT NULL,
    [MaxPresent]      INT  NOT NULL DEFAULT 0,
    [MinAiders] INT NOT NULL DEFAULT 0, 
    [DescriptionShort] NVARCHAR (200) NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_Master_FirstAiders] PRIMARY KEY ([SystemID], [BpID], [FirstAiderID]), 
)
