CREATE TYPE [dbo].[FieldsConfigType] AS TABLE
(
	DialogIsActive bit,
	ActionIsActive bit,
	ActionID int,
	IsVisible bit,
	IsEditable bit,
	IsMandatory bit,
	DefaultValue nvarchar(10),
	InternalName nvarchar(50),
	TypeID tinyint,
	NameTranslated nvarchar(50),
	DescriptionTranslated nvarchar(200),
	ResourceID nvarchar(50),
	NodeID int
)
