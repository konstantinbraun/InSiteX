CREATE TABLE [dbo].[Data_ShortTermAccessAreas]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [ShortTermVisitorID]  INT            NOT NULL,
    [AccessAreaID]     INT            NOT NULL, 
    [TimeSlotGroupID] INT NOT NULL DEFAULT 0, 
    [AdditionalRights] INT NOT NULL DEFAULT 0, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_Data_ShortTermAccessAreas] PRIMARY KEY ([SystemID], [BpID], [ShortTermVisitorID], [AccessAreaID], [TimeSlotGroupID]),
)
