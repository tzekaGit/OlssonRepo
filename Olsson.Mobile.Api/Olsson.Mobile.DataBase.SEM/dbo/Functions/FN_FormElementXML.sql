

-- =============================================
-- Author:		Mike Weisshaar
-- Create date: 2016.02.19
-- Description:	Retrieves Elements for a Section
-- =============================================
CREATE FUNCTION [dbo].[FN_FormElementXML]
(
	@FormID As int,
	@SectionID As int
)
RETURNS XML 
AS
BEGIN
	DECLARE @secElements XML

	IF @SectionID<>0
	BEGIN 
		SET @secElements = 
		(SELECT
				[dbo].[FN_FormElementPropertiesXML]  (FormID,SectionID,ElementID) as "row" 
			FROM SEM_tbFormSectionElement
			WHERE SectionID=@SectionID
				and FormID=@FormID
			order by ElementSort
			FOR XML PATH('')
			,TYPE)
	END 
	ELSE 
	BEGIN --Built in Form Properties
			SET @secElements = (SELECT
				[dbo].[FN_FormElementPropertiesXML]  (@FormID,@SectionID,0) as "row" 
			FOR XML PATH('')
			,TYPE)
	END 
	
	RETURN @secElements
END