
-- =============================================
-- SeM Transformation Stored Procedure 
--	Author:	Mike Weisshaar <mweisshaar@sikich.com>
--				
-- Create date: 2/23/2016
-- Name:	SEM_sp_upsert_DocumentHeader
-- Description:	Inserts Document header into tbFormData. Updates if already exists.	
--				Returns DocumentID. 
-- =============================================
--			MODIFICATIONS
-- =============================================
--2016.03.03 - Original Code 
-- =============================================
CREATE PROCEDURE [dbo].[SEM_sp_upsert_DocumentHeader] 
	@RowID as uniqueidentifier
	,@DocumentID As varchar(100)
	,@userID As uniqueidentifier
	,@FormID as INT 
	,@SubmitDocument as INT --1 = Saved; 2 = Posted 
	,@OUTDocumentID As varchar(100) OUTPUT
AS
BEGIN

	DECLARE @DocumentType varchar(100)
		,@DocStatus varchar(50)
	
	SELECT @DocumentType=FormName FROM SEM_tbForm WHERE FormID=@FormID
	
	SET @DocStatus = (SELECT CASE @SubmitDocument WHEN 0 THEN 'Draft' WHEN 1 THEN 'Saved' WHEN 2 THEN 'Posted' END)
	
	IF ISNULL(@DocumentID,'')='' 
	BEGIN 
		SET @DocumentID=dbo.SIKICH_IDGEN(@userID)
		SET @OUTDocumentID=@DocumentID
	END 
	ELSE 
	BEGIN 
		SET @OUTDocumentID=@DocumentID
	END 
	
	--Lookup Form Data for DocumentType
	
	IF EXISTS(SELECT 1 FROM tbFormData WHERE DocumentID=@OUTDocumentID)
	BEGIN 
		UPDATE tbFormData
		SET [Audit_UpdateDate]=GETDATE()
			,[Audit_UpdateBy]=@userID					
		WHERE DocumentID=@DocumentID
	END 	
	ELSE
	BEGIN 
		UPDATE [tbFormData] 
		SET FormID=@FormID,
			UserID=@userID,
			DocumentID=@DocumentID,
			DocumentType=@DocumentType,
			DocumentTitle='DocumentTitle',
			DocumentStatus='Draft',
			Audit_addDate=getdate(),
			Audit_addBy=@userID,
			Audit_UpdateDate=getdate(),
			Audit_UpdateBy=@userID
		WHERE RowID=@RowID
			
		--Update the built in property values in tbFormDataElement
		-- DocumentID, DocumentType, AddedByUser (GUID), AddedOn (short date)
		
		UPDATE tbFormDataElement
		SET FieldValue=@DocumentID
		WHERE ParentRowId=@RowID
			and FieldName='DocumentID'
			
		UPDATE tbFormDataElement
		SET FieldValue=@DocumentType
		WHERE ParentRowId=@RowID
			and FieldName='DocumentType'
			
		UPDATE tbFormDataElement
		SET FieldValue=@userID
		WHERE ParentRowId=@RowID
			and FieldName='AddedByUser'	
					
		UPDATE tbFormDataElement
		SET FieldValue=CONVERT(VARCHAR(10), getdate(), 101)
		WHERE ParentRowId=@RowID
			and FieldName='AddedOn'
			
	END 
END