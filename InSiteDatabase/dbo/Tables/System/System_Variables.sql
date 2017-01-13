CREATE TABLE [dbo].[System_Variables]
(
	[SystemID] INT NOT NULL , 
    [FieldID] INT NOT NULL , 
    [VariableName] NVARCHAR(50) NOT NULL, 
    [VariablePattern] NVARCHAR(50) NOT NULL, 
    [VariableType] INT NOT NULL DEFAULT 0, 
    [VariableValue] NVARCHAR(MAX) NULL, 
    [ResourceID] NVARCHAR(50) NULL, 
    [FormatPattern] NVARCHAR(50) NULL, 
    CONSTRAINT [PK_System_Variables] PRIMARY KEY ([SystemID], [FieldID], [VariableName]), 
)
