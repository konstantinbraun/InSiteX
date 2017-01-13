CREATE TABLE [dbo].[History_TimeSlotGroups]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [TimeSlotGroupID]           INT NOT NULL, 
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_History_TimeSlotGroup] PRIMARY KEY ([SystemID], [BpID], [TimeSlotGroupID], [EditOn]),
)
