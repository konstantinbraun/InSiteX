CREATE TABLE [dbo].[History_FirstAiders]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [FirstAiderID]           INT      NOT NULL,
    [MaxPresent]      INT  NOT NULL DEFAULT 0,
    [MinAiders] INT NOT NULL DEFAULT 0, 
    [DescriptionShort] NVARCHAR (200) NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_History_FirstAiders] PRIMARY KEY ([SystemID], [BpID], [FirstAiderID], [EditOn]), 
)
