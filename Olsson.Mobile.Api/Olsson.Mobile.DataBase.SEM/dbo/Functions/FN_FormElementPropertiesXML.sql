


-- =============================================
-- Author:		Mike Weisshaar
-- Create date: 2016.02.19
-- Description:	Retrieves Elements for a Section
-- =============================================
CREATE FUNCTION [dbo].[FN_FormElementPropertiesXML]
(
	@FormID As int
	,@SectionID As int
	,@ElementID AS int	
)
RETURNS XML 
AS
BEGIN
	DECLARE @secElements XML
	DECLARE @ElementDefinition varchar(50)
	--DECLARE @delimiter varchar = ':'
	DECLARE @fieldIdentity varchar(max) 
	
	--SET @fieldIdentity=@delimiter+CAST(@FormID as varchar(50))+@delimiter+CAST(@SectionID as varchar(50))+@delimiter+CAST(@ElementID as varchar(50))
	SET @fieldIdentity='' --Not utilizing fieldIdentities at the moment.

	/* Possible Element Definitions from SEM_vElementDifinition - 2016.03.10
				
		label_datenow
		label_user
		label_docID
		label_function
		label_caption
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
		dropdownlist_multi_lookuplist
		dropdownlist_multi_valuelist
		label_calculated
		unknown (Element is undefined) 
		AnnotatedImage

	*/
	
	SELECT top 1 @ElementDefinition=ElementDefinition
	FROM SEM_v_ElementDefinition
	WHERE 
		FormID=@FormID
		and SectionID=@SectionID
		and ElementID=@ElementID
	
	
	IF @ElementDefinition = 'textbox' or @ElementDefinition = 'textbox_phone' or @ElementDefinition = 'textbox_currency' or @ElementDefinition='field_date'
	BEGIN 
	SET @secElements = 
		(SELECT 
		'formlabel' as "element/@control"
		,ISNULL(ElementText,'') as "element/@text"
		,ISNULL(@ElementID,'')	as "element/@for"
			,(SELECT
				'textbox' as "@control"
				,@ElementID	as "@id"
				,ISNULL(ElementText,'') as "@text"		
				,[dbo].[FN_FormElementProperties]  (FormID,SectionID,ElementID) as "properties"
				,[dbo].[FN_FormElementFeatures]  (@FormID,@SectionID,ElementID) as "features"
				FROM 
					(Select FormID,SectionID,ElementID,ElementSort, ElementType, ElementText, ElementName
						FROM SEM_tbFormSectionElement a 
						WHERE
								a.SectionID=@SectionID
							and a.ElementID=@ElementID
							and a.FormID=@FormID
						) Element
				WHERE Element.SectionID=@SectionID
					and Element.ElementID=@ElementID
				FOR XML PATH('element')
				,TYPE)
			FROM 
				(SELECT FormID,SectionID, ElementID, ElementSort,'Caption' as ElementType, ElementCaption as ElementText, ElementName
					FROM SEM_tbFormSectionElement b
					WHERE b.ElementType='Field'
					and b.SectionID=@SectionID
					and b.ElementID=@ElementID
					and b.FormID=@FormID) caption
			FOR XML PATH('')
			,TYPE		
			)
	END 
	
	IF @ElementDefinition='memo' 
	BEGIN 
	SET @secElements = 
		(SELECT 
		'formlabel' as "element/@control"
		,ISNULL(ElementText,'') as "element/@text"
		,ISNULL(@ElementID,'')	as "element/@for"
			,(SELECT
				'textarea' as "@control"
				,@ElementID	as "@id"
				,ISNULL(ElementText,'') as "@text"		
				,[dbo].[FN_FormElementProperties]  (FormID,SectionID,ElementID) as "properties"
				,[dbo].[FN_FormElementFeatures]  (@FormID,@SectionID,ElementID) as "features"
				FROM 
					(Select FormID,SectionID,ElementID,ElementSort, ElementType, ElementText, ElementName
						FROM SEM_tbFormSectionElement a 
						WHERE
								a.SectionID=@SectionID
							and a.ElementID=@ElementID
							and a.FormID=@FormID
						) Element
				WHERE Element.SectionID=@SectionID
					and Element.ElementID=@ElementID
				FOR XML PATH('element')
				,TYPE)
			FROM 
				(SELECT FormID,SectionID, ElementID, ElementSort,'Caption' as ElementType, ElementCaption as ElementText, ElementName
					FROM SEM_tbFormSectionElement b
					WHERE b.ElementType='Field'
					and b.SectionID=@SectionID
					and b.ElementID=@ElementID
					and b.FormID=@FormID) caption
			FOR XML PATH('')
			,TYPE		
			)
	END 
	
	If @ElementDefinition='label_caption'
	BEGIN 
		SET @secElements = (Select 
		'label' as "element/@control"
		,ISNULL(ElementText,'') as "element/@text"
		--,[dbo].[FN_FormElementProperties]  (FormID,SectionID,ElementID) as "properties"
			FROM 
				(SELECT FormID,SectionID,ElementID,ElementSort, ElementType, ElementText, ElementName
					FROM SEM_tbFormSectionElement a
					WHERE 
						a.SectionID=@SectionID
					and a.ElementID=@ElementID
					and a.FormID=@FormID) caption
		FOR XML PATH('')
		,TYPE	)
	END 
		
	If @ElementDefinition='label_function' 
		or @ElementDefinition='label_datenow' or @ElementDefinition= 'label_docID'
		or @ElementDefinition= 'label_user' or @ElementDefinition='label_calculated'
	BEGIN 
		
		
		/* Label Function values will be set upon Saving the record. (See sproc: SEM_sp_Update_AutoGen_Fields)  -2016.03.10
		
		DECLARE @functionValue as varchar(100)
		IF @ElementDefinition='label_function' 
		BEGIN
			SET @functionValue= dbo.FN_FormCustomFieldFunctions (@FormID,@SectionID,@ElementID,@UserID,@DocumentID,@ListId)
		END
		ELSE
		BEGIN
			SET @functionValue=''
		END 
		*/

		SET @secElements = (Select 
		'formlabel' as "element/@control"
		,ElementCaption as "element/@text"
		,ISNULL(@ElementID,'') as "element/@for"
		,(SELECT 'textbox' as "@control"
				,'' as "@text"
				,@ElementID as "@id"
				--,'readonly' as "properties/property/@name"
				--,'true' as "properties/property/@value"
				,[dbo].[FN_FormElementProperties]  (FormID,SectionID,ElementID) as "properties"
				,[dbo].[FN_FormElementFeatures]  (@FormID,@SectionID,ElementID) as "features"
				FROM 
				(SELECT ElementName
					FROM SEM_tbFormSectionElement a
					WHERE 
						a.SectionID=@SectionID
					and a.ElementID=@ElementID
					and a.FormID=@FormID) element
				FOR XML PATH('element')
				,TYPE)
		--,[dbo].[FN_FormElementProperties]  (FormID,SectionID,ElementID) as "properties"
			FROM 
				(SELECT FormID,SectionID,ElementID,ElementCaption,ElementSort, ElementType, ElementText, ElementName
					FROM SEM_tbFormSectionElement a
					WHERE 
						a.SectionID=@SectionID
					and a.ElementID=@ElementID
					and a.FormID=@FormID) caption
					
		FOR XML PATH('')
		,TYPE	)
	END 
	
	IF @ElementDefinition = 'image' or @ElementDefinition = 'imageLowRes' or @ElementDefinition = 'imageHighRes' or @ElementDefinition =  'AnnotatedImage'
	BEGIN 
	SET @secElements = 
		(SELECT 
		'formlabel' as "element/@control"
		,ISNULL(ElementText,'') as "element/@text"
		,ISNULL(@ElementID,'')	as "element/@for"
			,(SELECT
				'imagecapture' as "@control"
				,@ElementID as "@id"					
				,[dbo].[FN_FormElementProperties]  (FormID,SectionID,ElementID) as "properties"
				,[dbo].[FN_FormElementFeatures]  (@FormID,@SectionID,ElementID) as "features"
				FROM 
					(Select FormID,SectionID,ElementID,ElementSort, ElementType, ElementText, ElementName
						FROM SEM_tbFormSectionElement a 
						WHERE
								a.SectionID=@SectionID
							and a.ElementID=@ElementID
							and a.FormID=@FormID
						) Element
				WHERE Element.SectionID=@SectionID
					and Element.ElementID=@ElementID
				FOR XML PATH('element')
				,TYPE)
			FROM 
				(SELECT FormID,SectionID, ElementID, ElementSort,'Caption' as ElementType, ElementCaption as ElementText, ElementName
					FROM SEM_tbFormSectionElement b
					WHERE 
						b.SectionID=@SectionID
					and b.ElementID=@ElementID
					and b.FormID=@FormID) caption
			FOR XML PATH('')
			,TYPE		
			)
	END 

	IF @ElementDefinition = 'dropdownlist_lookuplist' or @ElementDefinition='dropdownlist_valuelist' 
		or @ElementDefinition = 'dropdownlist_multi_lookuplist' or @ElementDefinition='dropdownlist_multi_valuelist' 
		or @ElementDefinition = 'checkbox_valuelist' or @ElementDefinition ='checkbox_lookuplist'
		or @ElementDefinition = 'switch' or @ElementDefinition = 'switch_lookuplist' or @ElementDefinition = 'switch_valuelist'
		or @ElementDefinition = 'radio_valuelist' or @ElementDefinition ='radio_lookuplist'
	BEGIN 
	SET @secElements = 
		(SELECT 
		'formlabel' as "element/@control"
		,ISNULL(ElementText,'') as "element/@text"
		,ISNULL(@ElementID,'')	as "element/@for"
			,(SELECT
				CASE
					WHEN @ElementDefinition = 'radio_valuelist' or @ElementDefinition ='radio_lookuplist'
						THEN 'radiobuttonlist'
					WHEN @ElementDefinition='switch' or @ElementDefinition = 'switch_lookuplist' or @ElementDefinition = 'switch_valuelist'
						THEN 'flipswitch'
					WHEN @ElementDefinition='dropdownlist_lookuplist' or @ElementDefinition='dropdownlist_valuelist'
						or @ElementDefinition='dropdownlist_multi_lookuplist' or @ElementDefinition='dropdownlist_multi_valuelist'
						THEN 'dropdownlist'	
					WHEN @ElementDefinition = 'checkbox_valuelist' or @ElementDefinition ='checkbox_lookuplist'
						THEN 'checkboxlist'
				END	as "@control"
				,@ElementID as "@id"					
				,[dbo].[FN_FormElementProperties]  (FormID,SectionID,ElementID) as "properties"
				,[dbo].[FN_FormElementFeatures]  (@FormID,@SectionID,ElementID) as "features"
				,[dbo].[FN_FormElementListItems]  (FormID,SectionID,ElementID) as "listitems"
				FROM 
					(Select FormID,SectionID,ElementID,ElementSort, ElementType, ElementText, ElementName
						FROM SEM_tbFormSectionElement a 
						WHERE
								a.SectionID=@SectionID
							and a.ElementID=@ElementID
							and a.FormID=@FormID
						) Element
				WHERE Element.SectionID=@SectionID
					and Element.ElementID=@ElementID
				FOR XML PATH('element')
				,TYPE)
			FROM 
				(SELECT FormID,SectionID, ElementID, ElementSort,'Caption' as ElementType, ElementCaption as ElementText, ElementName
					FROM SEM_tbFormSectionElement b
					WHERE 
						b.SectionID=@SectionID
					and b.ElementID=@ElementID
					and b.FormID=@FormID) caption
			FOR XML PATH('')
			,TYPE		
			)
	END
		
		
	If @SectionID=0 --Built in Properties
	BEGIN 			

		SET @secElements = (Select 
		'formlabel' as "element/@control"
		,ElementCaption as "element/@text"
		,ISNULL(@ElementID,'') as "element/@for"
		,(SELECT 'textbox' as "@control"
				,'' as "@text"
				,ElementName as "@id"
				--,'readonly' as "properties/property/@name"
				--,'true' as "properties/property/@value"
				,[dbo].[FN_FormElementProperties]  (@FormID,@SectionID,ElementID) as "properties"
				,[dbo].[FN_FormElementFeatures]  (@FormID,@SectionID,ElementID) as "features"
				FOR XML PATH('element')
				,TYPE)
		--,[dbo].[FN_FormElementProperties]  (FormID,SectionID,ElementID) as "properties"
			FROM 
				(SELECT top 1 @FormID as FormID,@SectionID as SectionID,0 as ElementID,'DocumentID' as ElementCaption,'99' as ElementSort,  'DocumentID' as ElementName FROM SEM_tbFormSectionElement
					UNION 
					SELECT top 1 @FormID as FormID,@SectionID as SectionID,0 as ElementID,'DocumentTitle' as ElementCaption,'99' as ElementSort,  'DocumentTitle' as ElementName FROM SEM_tbFormSectionElement
					UNION 
					SELECT top 1 @FormID as FormID,@SectionID as SectionID,0 as ElementID,'AddedByUser' as ElementCaption,'99' as ElementSort,  'AddedByUser' as ElementName FROM SEM_tbFormSectionElement
					UNION 
					SELECT top 1 @FormID as FormID,@SectionID as SectionID,0 as ElementID,'AddedOn' as ElementCaption,'99' as ElementSort,  'AddedOn' as ElementName FROM SEM_tbFormSectionElement
					UNION 
					SELECT top 1 @FormID as FormID,@SectionID as SectionID,0 as ElementID,'DocumentType' as ElementCaption,'99' as ElementSort,  'DocumentType' as ElementName FROM SEM_tbFormSectionElement
					--UNION 
					--SELECT top 1 @FormID as FormID,@SectionID as SectionID,0 as ElementID,'formid' as ElementCaption,'99' as ElementSort,  'formid' as ElementName FROM SEM_tbFormSectionElement
				) caption		
		FOR XML PATH('')
		,TYPE	)
	END 	
		
	RETURN @secElements
END