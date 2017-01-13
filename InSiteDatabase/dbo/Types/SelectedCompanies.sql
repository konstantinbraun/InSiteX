CREATE TYPE [dbo].[SelectedCompanies] AS TABLE
(
	SystemID int,
	BpID int,
	CompanyID int,
	ParentID int,
	NameVisible nvarchar(200),
	NameAdditional nvarchar(200),
	TreeLevel nvarchar(50),
	IndentLevel int,
	PRIMARY KEY (SystemID, BpID, CompanyID)
)
