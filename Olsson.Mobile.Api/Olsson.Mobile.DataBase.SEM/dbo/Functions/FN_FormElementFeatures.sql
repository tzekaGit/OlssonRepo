

-- =============================================
-- Author:		Mike Weisshaar
-- Create date: 2016.07.13
-- Description:	Retrieves Element Form Features
-- =============================================
CREATE FUNCTION [dbo].[FN_FormElementFeatures]
(
	@FormID AS int,
	@SectionID As int,
	@ElementID AS int
)
RETURNS XML 
AS
BEGIN
	DECLARE @elemProperties XML
	
			/* Possible Element Definitions from SEM_vElementDifinition - 2016.03.10
				
		label_datenow
		label_user
		label_docID
		label_function
		label_calculated
		image
		imageLowRes
		imageHighRes
		memo
		switch
		field_date
		textbox_currency
		textbox_phone
		textbox
		checkbox_valuelist
		checkbox_lookuplist
		radio_valuelist
		radio_lookuplist
		switch_valuelist
		switch_lookuplist
		dropdownlist_valuelist
		dropdownlist_lookuplist
		label_calculated
		unknown (Element is undefined) 


	*/
	
	SET @elemProperties = 
	
	(SELECT
			tb_FormElementFeatures.Name as "property/@name"			
			,CASE 
				WHEN SEM_tbFormSectionElement.ElementType='text[delete]'
					THEN SEM_tbFormSectionElement.ElementText
				ELSE 
					tb_FormElementFeatures.DefaultValue1 
			END as "property/@value"
		FROM 
			SEM_tbFormSectionElement 
				inner join SEM_v_ElementDefinition
					ON SEM_v_ElementDefinition.SectionID=SEM_tbFormSectionElement.SectionID
						AND SEM_v_ElementDefinition.FormID=SEM_tbFormSectionElement.FormID
						AND SEM_v_ElementDefinition.ElementID=SEM_tbFormSectionElement.ElementID
					inner join tb_FormElementFeatures
						ON tb_FormElementFeatures.Type=SEM_v_ElementDefinition.ElementDefinition
		WHERE SEM_tbFormSectionElement.SectionID=@SectionID
			and SEM_tbFormSectionElement.FormID=@FormID
			and SEM_tbFormSectionElement.ElementID=@ElementID
		FOR XML PATH('')
		,TYPE)		
	
	RETURN @elemProperties
END