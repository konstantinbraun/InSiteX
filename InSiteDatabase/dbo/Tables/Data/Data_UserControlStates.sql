CREATE TABLE [dbo].[Data_UserControlStates]
(
	[SystemID] INT NOT NULL , 
    [UserID] INT NOT NULL, 
    [UserKey] NVARCHAR(200) NOT NULL, 
    [UserSettings] NVARCHAR(MAX) NULL, 
    [LastUpdate] DATETIME NOT NULL, 
    PRIMARY KEY ([SystemID], [UserID], [UserKey]),

)
