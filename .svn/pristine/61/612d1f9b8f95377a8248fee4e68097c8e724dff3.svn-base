CREATE FUNCTION [dbo].[GetTemplateNameFromParams]
(
	@Params xml
)
RETURNS nvarchar(50)

AS

BEGIN
	DECLARE @Template nvarchar(50);

    SELECT @Template = properties.property.value('ReportName[1]', 'nvarchar(50)')
    FROM @Params.nodes(N'/Report') AS properties(property)
	;

	IF (@Template IS NULL)
		SET @Template = ''

	RETURN @Template;
END
