CREATE TABLE [dbo].[System_CompanyTariffs]
(
    [SystemID]         INT            NOT NULL,
    [TariffScopeID]           INT            NOT NULL,
    [CompanyID]        INT            NOT NULL,
    [ValidFrom]        DATE       DEFAULT (sysdatetime()) NOT NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_System_CompanyTariffs] PRIMARY KEY ([SystemID], [TariffScopeID], [CompanyID]), 
)
