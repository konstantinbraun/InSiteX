CREATE TABLE [dbo].[Master_AttributesCompany]
(
    [SystemID] INT NOT NULL, 
    [BpID] INT NOT NULL,
	[AttributeID] INT NOT NULL, 
    [CompanyID] INT NOT NULL, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    PRIMARY KEY ([SystemID], [BpID], [AttributeID], [CompanyID]), 
)
