
-- =============================================
-- SeM Transformation Stored Procedure 
--	Author:	Mike Weisshaar <mweisshaar@sikich.com>
--				
-- Create date: 2/23/2016
-- Name:	SEM_sp_FormXMLTransformation
-- Description:	 Transforms SeM Form Data into HTML consumable XML			
--
--	Parameters:
--		@FormID - Specifies the Form to display
--		@UserID - Specifies the user pulling the form
--		@DocumentID - If loading a saved document, specifies the DocumentID 
--						Otherwise, if this is a new document, leave @DocumentID null. 
-- =============================================
--			MODIFICATIONS
-- =============================================
--2016.02.23 - Original Code 
-- =============================================
CREATE PROCEDURE [dbo].[SEM_sp_FormXMLTransformation] 
	@FormID As int
AS
BEGIN

DECLARE @UserID nvarchar(255)
	,@DocumentID varchar(100) 


SELECT (select 'form'+CAST(Form.FormID as varchar(50)) as "@formid"
		,Form.FormName as "@formname"
		,Form.FormStatus as "@formstatus"
		,'formID' as "properties/property/@name"
		,Form.FormID as "properties/property/@value"
		,(SELECT 
			[dbo].[FN_FormSectionXML] (SEM_tbFormSection.FormID,SEM_tbFormSection.SectionID)
				FROM SEM_tbFormSection
			WHERE SEM_tbFormSection.FormID=@FormID
			Order by SectionSort
			FOR XML PATH('row')
				,TYPE
			) as "row"
	FROM 
	dbo.SEM_tbForm Form 
	WHERE Form.FormID = @FormID
		FOR XML PATH('form')
		,TYPE ) AS [XML]
		
	
END