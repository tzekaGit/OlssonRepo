-- =============================================
-- SeM Admin Stored Procedure 
--	Author:	Mike Weisshaar <mweisshaar@sikich.com>
--				
-- Create date: 4/15/2016
-- Name:	SEM_sp_Copy_Record_Data
-- Description:	 Copy's data from an existing record
--
-- EXEC SEM_sp_Copy_Record_Data 
--	'83DC3D1E-9C4C-4BDD-90E1-D96094571EDE', '83DC3D1E-9C4C-4BDD-90E1-D96094571EDE'
-- 
-- =============================================
--			MODIFICATIONS
-- =============================================
--2016.04.15 - Original Code 
-- =============================================
CREATE PROCEDURE [dbo].[SEM_sp_Copy_Record_Data] 
	 @CopyFromParentRowID As uniqueidentifier ,
	@CopyToUser As uniqueidentifier
AS
BEGIN
	DECLARE @DocID varchar(100),
			@NewParentRowID uniqueidentifier,
		--Cursor Variables 
		@Curs as cursor,
		@CRListID varchar(100),
		@CRfieldId int,
		@CRFieldName varchar(100),
		@CRFieldVal varchar(100),
		@CRsectionID int,
		@CRelementID int,
		--Document Header Variables 
		@hdrFormID int,
		@hdrDocType varchar(100),
		@hdrDocTitle varchar(100),
		@hdrDocStatus varchar(50)
		
		
	select @DocID=dbo.Sikich_IDGen('')
	SET @NewParentRowID=NewID()
	
	SELECT @hdrFormID=FormID, @hdrDocType=DocumentType, @hdrDocStatus=DocumentStatus, @hdrDocTitle=DocumentTitle
	FROM tbFormData
	WHERE RowID=@CopyFromParentRowID
	
	
	INSERT INTO tbFormData VALUES (@NewParentRowID,@hdrFormID,@CopyToUser,@DocID,@hdrDocType,@hdrDocTitle,@hdrDocStatus,GETDATE(),@CopyToUser,GETDATE(),@CopyToUser)
	

	SET @Curs = CURSOR FOR 
		SELECT ListId,FieldId,FieldName,FieldValue,SectionID,elementID
		FROM tbFormDataElement fde
		where ParentRowID=@CopyFromParentRowID

	
	OPEN @Curs
	FETCH NEXT FROM @Curs INTO @CRListID, @CRfieldId, @CRFieldName, @CRFieldVal, @CRsectionID,@CRelementID
	WHILE @@FETCH_STATUS=0 
	BEGIN 
		IF @CRFieldName='DocumentID'
		BEGIN
			SET @CRFieldVal=@DocID
		END 
		
		INSERT INTO tbFormDataElement VALUES(NewID(),@NewParentRowID,@DocID,@CRListID,@CRFieldID,@CRFieldName,@CRFieldVal,@CRsectionID,GETDATE(),GETDATE(),@CRelementID)
		
	FETCH NEXT FROM @Curs INTO @CRListID, @CRfieldId, @CRFieldName, @CRFieldVal, @CRsectionID,@CRelementID
	END 
		
	CLOSE @Curs
	DEALLOCATE @Curs
END