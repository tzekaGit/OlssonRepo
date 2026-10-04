

-- =============================================
-- Author:		Mike Weisshaar
-- Create date: 2016.02.19
-- Description:	Retrieves Section Form Properties
-- =============================================
CREATE FUNCTION [dbo].[FN_FormSectionProperties]
(
	@FormID AS int,
	@SectionID As int
)
RETURNS XML 
AS
BEGIN
	DECLARE @secProperties XML

IF @SectionID<>0 
BEGIN 	
	SET @secProperties = 
	(SELECT
			Name as "property/@name"
			,CASE 
				WHEN tb_FormProperties.Name='text'
					THEN ISNULL(SectionCaption,SectionName)
				--If SEM_tbFormSection.SectionExpanded is not 0, it will be expanded from the start
				WHEN tb_FormProperties.Name='collapsed' and ISNULL(SEM_tbFormSection.SectionExpanded,0)<>0
					THEN 'false'
				ELSE tb_FormProperties.DefaultValue1
			END as "property/@value"
		FROM 
			SEM_tbFormSection inner join 
				tb_FormProperties ON tb_FormProperties.Type='section'	
		WHERE SEM_tbFormSection.SectionID=@SectionID
			and SEM_tbFormSection.FormID=@FormID
		FOR XML PATH('')
		,TYPE)
END 
ELSE --Section ID=0, Default Form Properties
BEGIN 
	SET @secProperties = 
	(SELECT
			Name as "property/@name"
			,DefaultValue1 as "property/@value"
		FROM tb_FormProperties
			WHERE Type='sectionMaster'
		FOR XML PATH('')
		,TYPE)
END 
	
	RETURN @secProperties
END