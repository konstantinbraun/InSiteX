CREATE TABLE [dbo].[System_Salutations]
(
	[SalutationID] INT NOT NULL  IDENTITY, 
    [Salutation] NVARCHAR(50) NULL, 
    [GenderID] INT NOT NULL DEFAULT 0, 
    CONSTRAINT [PK_System_Salutations] PRIMARY KEY ([SalutationID])
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID der Anrede',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Salutations',
    @level2type = N'COLUMN',
    @level2name = N'SalutationID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Anrede',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Salutations',
    @level2type = N'COLUMN',
    @level2name = N'Salutation'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'zugeordnetes Geschlecht',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Salutations',
    @level2type = N'COLUMN',
    @level2name = N'GenderID'