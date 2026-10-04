
-- =============================================
-- SeM Transformation Stored Procedure 
--	Author:	Mike Weisshaar <mweisshaar@sikich.com>
--				
-- Create date: 3/11/2016
-- Name:	SEM_sp_PublishFormXML
-- Description:	 Procedure will return XML for a given form. 
--		Depending on @Action, this procedure will update or pull XML from formXML field in SEM_tbForm.
--
--	Parameters:
--		@FormID - Specifies the Form to publish
--		@Action - Examples:
--					'Draft' -XML is not yet published, will return XML but will not update formXML value in SEM_tbForm.
--					'Publish' -XML will be published. formXML value in SEM_tbForm will be updated. 
--					'Active' -XML is a published form, this will return the current formXML value in SEM_tbForm.
--
-- Execution Examples:
--		EXEC SEM_sp_PublishFormXML 1,'Draft'
--		EXEC SEM_sp_PublishFormXML 1,'Publish'
--		EXEC SEM_sp_PublishFormXML 1,'Active'
--		EXEC SEM_sp_PublishFormXML 1   --Will default to "Active" action.
-- =============================================
--			MODIFICATIONS
-- =============================================
--2016.03.11 - Original Code 
-- =============================================
CREATE PROCEDURE [dbo].[SEM_sp_PublishFormXML] 
	@FormID As int
	,@Action as varchar(50)=NULL
AS
BEGIN

	DECLARE @XML varchar(max) 
		,@OldXML varchar(max)
		,@DateUpdated datetime

	IF ISNULL(@Action,'') <> 'Draft' and ISNULL(@Action,'') <> 'Publish' and ISNULL(@Action,'') <> 'Active'
	BEGIN 
		SET @Action='Active'
	END 

	IF @Action='Draft' or @Action='Publish'
	BEGIN 
		SELECT @XML=CONVERT(varchar(max),(select 'form'+CAST(Form.FormID as varchar(50)) as "@formid"
			,Form.FormName as "@formname"
			,Form.FormStatus as "@formstatus"
			,'formID' as "properties/property/@name"
			,Form.FormID as "properties/property/@value"
			,(SELECT 
				[dbo].[FN_FormSectionXML] (SEM_tbFormSection.FormID,SEM_tbFormSection.SectionID)
					FROM (SELECT FormID, SectionID, SectionSort 
					FROM SEM_tbFormSection
				WHERE SEM_tbFormSection.FormID=@FormID
					UNION 
					SELECT top 1 @FormID as FormID, 0 as SectionID,'99' as SectionSort
				) SEM_tbFormSection
				Order by SectionSort
				FOR XML PATH('row')
					,TYPE
				) as "row"
		FROM 
		dbo.SEM_tbForm Form 
		WHERE Form.FormID = @FormID
			FOR XML PATH('form')
			,TYPE ) )
	END 

	If @Action='Publish' and ISNULL(@XML,'')<>''
	BEGIN 
		SELECT @OldXML=FormXML from SEM_tbForm WHERE FormID=@FormID 
		SET @DateUpdated=getdate() 
		
		INSERT INTO [SEM_tbFormArchive] VALUES (@FormID,@DateUpdated,@OldXML)
	
		UPDATE SEM_tbForm 
		SET FormXML=@XML 
			,FormStatus='Active'
			,Audit_UpdateDate=@DateUpdated
		WHERE FormID=@FormID 
	END
	
	If @Action='Active'
	BEGIN 
		SELECT @XML=formXML FROM SEM_tbForm WHERE FormID=@FormID 
	END 
	
	SELECT ISNULL(@XML,'') as 'XML'

END