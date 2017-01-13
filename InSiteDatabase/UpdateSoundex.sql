UPDATE Master_Addresses
SET Soundex = dbo.SoundexGer(LastName)
;

UPDATE System_Addresses
SET Soundex = dbo.SoundexGer(LastName)
;

UPDATE Master_Users
SET Soundex = dbo.SoundexGer(LastName)
;

UPDATE System_Companies
SET Soundex = dbo.SoundexGer(NameVisible)
;
