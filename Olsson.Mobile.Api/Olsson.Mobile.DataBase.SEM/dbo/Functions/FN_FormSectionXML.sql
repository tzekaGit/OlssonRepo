

-- =============================================
-- Author:		Mike Weisshaar
-- Create date: 2016.02.19
-- Description:	Retrieves Section Properties and Section Elements
-- =============================================
CREATE FUNCTION [dbo].[FN_FormSectionXML]
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
	(Select 
		'section' as "element/@control"
		,'section'+CAST(SEM_tbFormSection.SectionID as varchar(50)) as "element/@id"
		,ISNULL(SectionCaption,SectionName) as "element/@text"
		,[dbo].[FN_FormSectionProperties]  (SEM_tbFormSection.FormID,SEM_tbFormSection.SectionID) as "element/properties"	
		,CASE 
			WHEN SEM_tbFormSection.SectionAllowMultiRecord <> 0 --If not 0, this is a section that will allow multiple records
				THEN 
					(Select 
						'container' as "element/@control"
						,'section'+CAST(@SectionID as varchar(10))+'container' as "element/@id"
						,'title' as "element/properties/property/@name"
						,ISNULL(SectionCaption,SectionName) as "element/properties/property/@value"
						,(SELECT
							Name as "property/@name"
							,DefaultValue1 as "property/@value"
							,ISNULL(DefaultValue2,'none') as "property/@display"
							FROM tb_FormProperties 
							WHERE tb_FormProperties.Type='container'	
							FOR XML PATH('')
							,TYPE
							) as "element/properties"	
						,[dbo].[FN_FormElementXML]  (SEM_tbFormSection.FormID,SEM_tbFormSection.SectionID) as "element"
							FROM SEM_tbFormSection
						WHERE SEM_tbFormSection.FormID=@FormID
							and SEM_tbFormSection.SectionID=@SectionID
						Order by SectionSort
						FOR XML PATH('')
							,TYPE
					) 
			ELSE [dbo].[FN_FormElementXML]  (SEM_tbFormSection.FormID,SEM_tbFormSection.SectionID)					
		END as "element"
	FROM SEM_tbFormSection
	WHERE SEM_tbFormSection.FormID=@FormID
		and SEM_tbFormSection.SectionID=@SectionID
	Order by SectionSort
	FOR XML PATH('')
		,TYPE)
END 
ELSE --If section ID is 0, we need to return the form properties
BEGIN 
		SET @secElements = 
	(Select 
		'section' as "element/@control"
		,'section'+CAST(SEM_tbFormSection.SectionID as varchar(50)) as "element/@id"
		,ISNULL(SectionCaption,SectionName) as "element/@text"
		,[dbo].[FN_FormSectionProperties]  (SEM_tbFormSection.FormID,SEM_tbFormSection.SectionID) as "element/properties"	
		,[dbo].[FN_FormElementXML]  (SEM_tbFormSection.FormID,SEM_tbFormSection.SectionID)	 as "element"
	FROM (
		Select top 1 
			Properties.FormID
			, 0 as SectionID
			, 'Properties' as SectionName, 
			'99' as SectionSort
			, 0 as SectionAllowMultiRecord
			, 0 as SectionSourceTable
			, 'Properties' as SectionCaption
			, 0 as SectionExpanded
			FROM SEM_tbFormSection Properties WHERE Properties.FormID=@FormID) SEM_tbFormSection
	Order by SectionSort
	FOR XML PATH('')
		,TYPE)
END 
	
	RETURN @secElements
END