update Master_AllowedLanguages
set LanguageID = SUBSTRING(LanguageID, 1, 2);

update Master_Translations
set LanguageID = SUBSTRING(LanguageID, 1, 2);

update Master_Addresses
set LanguageID = SUBSTRING(LanguageID, 1, 2);

update Master_Users
set LanguageID = SUBSTRING(LanguageID, 1, 2);

update System_Addresses
set LanguageID = SUBSTRING(LanguageID, 1, 2);


