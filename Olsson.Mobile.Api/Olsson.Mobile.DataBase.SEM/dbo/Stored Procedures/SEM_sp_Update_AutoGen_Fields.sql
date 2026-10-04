
-- =============================================
-- SeM Transformation Stored Procedure 
--	Author:	Mike Weisshaar <mweisshaar@sikich.com>
--				
-- Create date: 3/9/2016
-- Name:	SEM_sp_Update_AutoGen_Fields
-- Description:	 Updates Form Data for Auto-Generated fields	
--
-- Sets tbFormDataElement Auto-Generated/Calculated fields
-- =============================================
--			MODIFICATIONS
-- =============================================
--2016.03.09 - Original Code 
-- =============================================
CREATE PROCEDURE [dbo].[SEM_sp_Update_AutoGen_Fields] 
	@ParentRowID as uniqueidentifier
	,@ElementID as INT
	,@DocumentID as varchar(100)
AS
BEGIN
	DECLARE @CalculatedFieldCursor CURSOR 
		,@FieldName varchar(100)
		,@FormID int 
		,@userID uniqueidentifier
		,@FormName varchar(100)
		,@FieldLookUpCustom varchar(100)
		,@ElementFieldCalculation varchar(100)
		,@SplitField nvarchar(max)
		,@CalculatedField varchar(max) 
		,@CurrentFieldValue varchar(100)
		
	SELECT top 1 @FormID=FormID, @ElementFieldCalculation=ElementFieldCalculation, @FieldLookUpCustom=FieldLookUpCustom, @CurrentFieldValue=FieldValue, @userID=UserID, @FormName=FormName,@FieldName=ElementName
		FROM SEM_v_DataElements
		WHERE ParentRowId=@ParentRowID
			and ElementID=@ElementID
	
	--If ElementFieldCalculation is not nothing, then this is a calculated field.
	IF ISNULL(@ElementFieldCalculation,'')<>''
	BEGIN 
		SET @CalculatedField=''
		SET 	@CalculatedFieldCursor = CURSOR	FOR	Select ltrim(rtrim(splitdata))
									from dbo.fn_SplitString(@ElementFieldCalculation,'+')

		OPEN @CalculatedFieldCursor
		FETCH NEXT FROM @CalculatedFieldCursor INTO @SplitField
		WHILE @@FETCH_STATUS=0 
		BEGIN 
			select @SplitField=FieldValue
			from SEM_v_DataElements
			where ParentRowID=@ParentRowID
			and ElementName=@SplitField
			
			SET @CalculatedField= @CalculatedField + REPLACE(@SplitField,'''','')

		FETCH NEXT FROM @CalculatedFieldCursor INTO @SplitField
		END 
		CLOSE @CalculatedFieldCursor
		DEALLOCATE @CalculatedFieldCursor
		
		IF ISNULL(@CalculatedField,'')<>''
		BEGIN 
			UPDATE tbFormDataElement
			SET FieldValue=@CalculatedField
			WHERE ParentRowId=@ParentRowID
				and ElementID=@ElementID								
		END
		
		IF @FieldName='DocumentTitle' and ISNULL(@CalculatedField,'')<>''--Update DocumentTitle 
		BEGIN 
			UPDATE tbFormData 
			SET DocumentTitle=@CalculatedField
			WHERE RowId=@ParentRowID
			
			UPDATE tbFormDataElement
			SET FieldValue=@CalculatedField
			WHERE ParentRowId=@ParentRowID
				and FieldName='DocumentTitle'
		END 
	END 
	
	IF @FieldLookUpCustom='GetDate()'
	BEGIN 
		SET @CalculatedField = CONVERT(VARCHAR(10), getdate(), 101)
		
		--If field is "AddedOn" or "AddDate" only update if the field is null. Otherwise, leave as is. 
		IF LOWER(@FieldName) like '%addedon%' or LOWER(@FieldName) like '%adddate%'
		BEGIN 
			IF ISNULL(@CurrentFieldValue,'')=''
			BEGIN 
				UPDATE tbFormDataElement
				SET FieldValue=@CalculatedField
				WHERE ParentRowId=@ParentRowID
					and ElementID=@ElementID
				
				/*
				UPDATE tbFormDataElement
				SET FieldValue=@CalculatedField
				WHERE ParentRowId=@ParentRowID
					and FieldName='AddedOn'
					*/
			END 
		END 
		ELSE
		BEGIN --Set GetDate() FieldLookUp 
			UPDATE tbFormDataElement
			SET FieldValue=@CalculatedField
			WHERE ParentRowId=@ParentRowID
				and ElementID=@ElementID
		END 
	END 
	
	IF @FieldLookUpCustom='GetDocumentId()'
	BEGIN 
		SET @CalculatedField=@DocumentID
		
		UPDATE tbFormDataElement
		SET FieldValue=@CalculatedField
		WHERE ParentRowId=@ParentRowID
				and ElementID=@ElementID
			
		/*	
		UPDATE tbFormDataElement
		SET FieldValue=@CalculatedField
		WHERE ParentRowId=@ParentRowID
				and FieldName='DocumentID'	
		*/		
	END 
	
	IF @FieldLookUpCustom='GetListId()'
	BEGIN 
		UPDATE tbFormDataElement
		SET FieldValue=REPLACE(ISNULL(ListID,0),'-','')
		WHERE ParentRowId=@ParentRowID
				and ElementID=@ElementID
	END
	
	IF @FieldLookUpCustom='UserId()'
	BEGIN 
		SET @CalculatedField=@userID
		
		SELECT @CalculatedField=username FROM [SEM_v_ASPusers] WHERE Id=@userID
		
		UPDATE tbFormDataElement
		SET FieldValue=@CalculatedField
		WHERE ParentRowId=@ParentRowID
				and ElementID=@ElementID
		
		/*	
		IF (Select ISNULL(FieldValue,'') FROM tbFormDataElement WHERE ParentRowId=@ParentRowID
					and FieldName='AddedByUser')=''
		BEGIN 
			UPDATE tbFormDataElement
			SET FieldValue=CAST(@userID as varchar(100))
			WHERE ParentRowId=@ParentRowID
					and FieldName='AddedByUser'	
		END
		*/
	END 
	
	IF @FieldLookUpCustom='FormName()'
	BEGIN 
		SET @CalculatedField=@FormName
		
		UPDATE tbFormDataElement
		SET FieldValue=@CalculatedField
		WHERE ParentRowId=@ParentRowID
				and ElementID=@ElementID

		/*			
		UPDATE tbFormDataElement
		SET FieldValue=@CalculatedField
		WHERE ParentRowId=@ParentRowID
				and FieldName='DocumentType'	
		*/
	END 
		
END