

-- =============================================
-- Author:		Mike Weisshaar
-- Create date: 2016.02.24
-- Description:	Retrieves Element List Items
-- =============================================
CREATE FUNCTION [dbo].[FN_FormElementListItems]
(
	@FormID AS int,
	@SectionID As int,
	@ElementID AS int
)
RETURNS XML 
AS
BEGIN
	DECLARE @listitems XML
	
		/* Possible Element Definitions from SEM_vElementDifinition - 2016.02.23
			dropdownlist_lookuplist
			dropdownlist_valuelist
			dropdownlist_multi_lookuplist
			dropdownlist_multi_valuelist
			image
			label_calculated
			label_caption
			label_date
			label_function
			memo
			textbox
	*/
	DECLARE @ElementDefinition varchar(50)

	SELECT top 1 @ElementDefinition=ElementDefinition
	FROM SEM_v_ElementDefinition
	WHERE 
		FormID=@FormID
		and SectionID=@SectionID
		and ElementID=@ElementID

	IF @ElementDefinition='switch'
	BEGIN 
		SET @listitems = 
		(SELECT
				'No' as "listitem/@text"			
				,'0' as "listitem/@value"
				,(select 
					'Yes' as "@text"			
					,'1' as "@value"	
					FOR XML PATH('listitem')
					,TYPE
				 )		
			FOR XML PATH('')
			,TYPE)
	END 

	IF @ElementDefinition='dropdownlist_lookuplist' or @ElementDefinition ='checkbox_lookuplist' 
		or @ElementDefinition ='dropdownlist_multi_lookuplist' 
		or @ElementDefinition='switch_lookuplist' or @ElementDefinition='radio_lookuplist'
	BEGIN
		SET @listitems = 
			(select
				 lu.ListValue as "listitem/@text"
				 , lu.ListValue as "listitem/@value"
				from SEM_v_ElementDefinition v
					inner join 
						SEM_tbLookupList lu on v.FieldLookUpListCode = lu.ListName
				where 
						v.FormID=@FormID
					and v.SectionID=@SectionID
					and v.ElementID=@ElementID
				order by lu.ListSort
				FOR XML PATH('')
				,TYPE)
	END 

	IF @ElementDefinition='checkbox_valuelist' or @ElementDefinition ='dropdownlist_valuelist' 
		or @ElementDefinition ='dropdownlist_multi_valuelist' 
		or @ElementDefinition='switch_valuelist' or @ElementDefinition='radio_valuelist'
	BEGIN
		DECLARE @parseList as varchar(max)=(Select top 1 FieldLookUpCustom FROM SEM_v_ElementDefinition v 
											WHERE v.FormID=@FormID and v.SectionID=@SectionID
													and v.ElementID=@ElementID)

		SET @listitems = 
			(select
				 name as "listitem/@text"
				 , value as "listitem/@value"
				from [dbo].[fn_SplitString_Value] (@parseList,';')
				FOR XML PATH('')
				,TYPE)
	END 
	
		IF @ElementDefinition='switch_lookuplist'
	BEGIN
		SET @listitems = 
			(select top 2
				 lu.ListValue as "listitem/@text"
				 , lu.ListValue as "listitem/@value"
				from SEM_v_ElementDefinition v
					inner join 
						SEM_tbLookupList lu on v.FieldLookUpListCode = lu.ListName
				where 
						v.FormID=@FormID
					and v.SectionID=@SectionID
					and v.ElementID=@ElementID
				order by lu.ListSort
				FOR XML PATH('')
				,TYPE)
	END 

	IF @ElementDefinition='switch_valuelist'
	BEGIN
		DECLARE @parseSwitchList as varchar(max)=(Select top 1 FieldLookUpCustom FROM SEM_v_ElementDefinition v 
											WHERE v.FormID=@FormID and v.SectionID=@SectionID
													and v.ElementID=@ElementID)
		--Because "Switch" we will only select top 2. This will prevent errors if they provide a list that is greater than 2 for a switch. 
		SET @listitems = 
			(select top 2
				 name as "listitem/@text"
				 , value as "listitem/@value"
				from [dbo].[fn_SplitString_Value] (@parseSwitchList,';')
				FOR XML PATH('')
				,TYPE)
	END 

	RETURN @listitems
END