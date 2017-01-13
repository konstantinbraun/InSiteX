CREATE TABLE [dbo].[History_TimeSlots]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [TimeSlotGroupID]           INT       NOT NULL, 
    [TimeSlotID]           INT NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [ValidFrom] DATETIME NOT NULL, 
    [ValidUntil] DATETIME NOT NULL, 
    [ValidDays] CHAR(7) NULL, 
    [TimeFrom] TIME NULL, 
    [TimeUntil] TIME NULL, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_History_TimeSlot] PRIMARY KEY ([SystemID], [BpID], [TimeSlotGroupID], [TimeSlotID], [EditOn]),
)
