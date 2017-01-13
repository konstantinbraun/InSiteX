CREATE TABLE [dbo].[History_CostLocations]
(
	[SystemID] INT NOT NULL , 
    [CostLocationID]           INT NOT NULL,
    [CostLocationNumber] NVARCHAR(50) NOT NULL, 
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [TypeID]           TINYINT        DEFAULT ((1)) NOT NULL,
    [IsVisible]        BIT            DEFAULT ((1)) NOT NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_History_CostLocations] PRIMARY KEY ([SystemID], [CostLocationID], [EditOn]),
)

GO