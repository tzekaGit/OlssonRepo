
-- =============================================
-- SeM Transformation Stored Procedure 
--	Author:	Mike Weisshaar <mweisshaar@sikich.com>
--				
-- Create date: 2/23/2016
-- Name:	SEM_sp_validateField
-- Description:	 Transforms SeM Form Data into HTML consumable XML			
--
-- =============================================
--			MODIFICATIONS
-- =============================================
--2016.03.03 - Original Code 
-- =============================================
CREATE PROCEDURE [dbo].[SEM_sp_validateField] 
	 @RowID as [uniqueidentifier]
	,@TrxID as [uniqueidentifier]
AS
BEGIN
	DECLARE 
		@ErrorMsg as varchar(max)
		
		,@ElementID as INT --Primary Key that binds to SEM configuration data in SEM_tbFormSectionElement
		,@FieldValue as varchar(100) --Value that is being validated. 
		,@ElementCaption as varchar(100) --Caption of element that is read friendly
		,@FieldNameID as varchar(100) -- tbFormDataElement.FieldName aka, the HTML ID for the element that failed validation. 
		,@FieldId as INT -- ID to [SEM_tbSchemaTableField] for Field validation properties (length, data type, etc.) 
		 
		 ,@FieldLength as INT 
		 
		--Initiate Variables
		SET @ErrorMsg = ''
		
		SELECT @ElementID=ElementID ,@FieldValue=FieldValue, @FieldNameID=FieldName
		from tbFormDataElement
		WHERE rowID=@rowID
		
		
		
--Only validate if we were able to determine the ElementID 
IF @ElementID is not null 
BEGIN 	
		SELECT @ElementCaption=ElementCaption 
			,@FieldID=ElementFieldID
		FROM SEM_tbFormSectionElement 
		WHERE ElementID=@ElementID
		
		IF @ElementCaption IS NULL 
		BEGIN 
			SET @ElementCaption=''
		END 
		
		
	--Is field required?
	IF (SELECT ElementFieldRequired FROM SEM_tbFormSectionElement 
		WHERE ElementID=@ElementID) <>0 
		AND (@FieldValue is null or @FieldValue='')
		BEGIN 
			SET @ErrorMsg = @ElementCaption + ' is a required field.'
			INSERT INTO tbFormData_Errors VALUES (NEWID(), @TrxID, 'Required' ,@FieldNameID, @ErrorMsg,null,null)
		END 
	
	--Is length appropriate. 
	IF (SELECT ISNUMERIC(FieldSize) FROM SEM_tbSchemaTableField WHERE FieldID=@FieldID)=1
	BEGIN 
		IF (SELECT LEN(@FieldValue))>(Select FieldSize FROM SEM_tbSchemaTableField WHERE FieldID=@FieldID)
		BEGIN 
			SET @ErrorMsg = @ElementCaption + ' is too long. Must be ' +(SELECT TOP 1 FieldSize FROM SEM_tbSchemaTableField WHERE FieldID=@FieldID) +' characters or less.'
			SET @FieldLength=(SELECT CAST(FLOOR(FieldSize) as INT) FROM SEM_tbSchemaTableField WHERE FieldID=@FieldID)
			
			INSERT INTO tbFormData_Errors VALUES (NEWID(), @TrxID, 'InvalidLength' ,@FieldNameID, @ErrorMsg,0,@FieldLength)
		END 
	END 
	
	
	--Truncate extra decimal places/ validate decimal values 
	IF ((Select FieldType FROM SEM_tbSchemaTableField WHERE FieldID=@FieldID)='Double'
		or (Select FieldType FROM SEM_tbSchemaTableField WHERE FieldID=@FieldID)='Currency')
		AND RTRIM(LTRIM(@FieldValue))<>''
	BEGIN
		IF (SELECT ISNUMERIC(@FieldValue))=0 
		BEGIN 
			SET @ErrorMsg = @ElementCaption + ' is not numeric.'
			INSERT INTO tbFormData_Errors VALUES (NEWID(), @TrxID, 'NumericDataType' ,@FieldNameID, @ErrorMsg,null,null)
		END 
		ELSE 
		BEGIN 
			DECLARE @DecimalLocation int 
			
			SET @DecimalLocation =(select CHARINDEX('.',@FieldValue))
			
			DECLARE @DecimalsAllowed int 
			IF (Select FieldType FROM SEM_tbSchemaTableField WHERE FieldID=@FieldID)='Currency'
			BEGIN 
				SET @DecimalsAllowed=2 
			END
			ELSE 
			BEGIN 
				--Grab decimal field from FieldID 
				SET @DecimalsAllowed=(Select ISNULL(FieldDecimal,0) FROM SEM_tbSchemaTableField WHERE FieldID=@FieldID)
			END 
			
			IF @DecimalLocation<>0
			BEGIN 
				IF (select LEN(@FieldValue)-CHARINDEX('.',@FieldValue))>@DecimalsAllowed
				BEGIN 
					IF @DecimalsAllowed=0 
					BEGIN 
						--Don't include the decimal if no decimals allowed. 
						SET @FieldValue=(Select LEFT(@FieldValue,@DecimalLocation+@DecimalsAllowed-1))
					END 
					ELSE 
					BEGIN 
						--Truncate extra decimal places. 
						SET @FieldValue=(Select LEFT(@FieldValue,@DecimalLocation+@DecimalsAllowed))
					END 
					
					IF @FieldValue=''
					BEGIN
						SET @FieldValue='0'
					END 					
				END 
			END 				
		END 	
	END		
	
	IF (Select FieldType FROM SEM_tbSchemaTableField WHERE FieldID=@FieldID)='Date'
		AND RTRIM(LTRIM(@FieldValue))<>''
	BEGIN 
		IF (select CASE WHEN TRY_PARSE(@FieldValue as datetime) IS NULL THEN 0 ELSE 1 END )=0
		BEGIN 
			SET @ErrorMsg = @ElementCaption + ' is not a valid date.'
			INSERT INTO tbFormData_Errors VALUES (NEWID(), @TrxID, 'ShortDateFormat' ,@FieldNameID, @ErrorMsg,null,null)
		END 
	END 
	
	IF (Select FieldType FROM SEM_tbSchemaTableField WHERE FieldID=@FieldID)='Phone'
		AND RTRIM(LTRIM(@FieldValue))<>''
	BEGIN 
		IF (SELECT ISNUMERIC(@FieldValue))=0 
		BEGIN 
			SET @ErrorMsg = @ElementCaption + ' must be all numbers.'
			INSERT INTO tbFormData_Errors VALUES (NEWID(), @TrxID, 'IntegerDataType' ,@FieldNameID, @ErrorMsg, null,null)
		END 
		
		IF (SELECT ISNUMERIC(FieldSize) FROM SEM_tbSchemaTableField WHERE FieldID=@FieldID)=1
		BEGIN 
			SET @FieldLength=(SELECT CAST(FLOOR(FieldSize) as INT) FROM SEM_tbSchemaTableField WHERE FieldID=@FieldID)
			IF (SELECT LEN(@FieldValue))<>(Select FieldSize FROM SEM_tbSchemaTableField WHERE FieldID=@FieldID)
			BEGIN 
				SET @ErrorMsg = @ElementCaption + ' Must be exactly ' +(SELECT TOP 1 FieldSize FROM SEM_tbSchemaTableField WHERE FieldID=@FieldID) +' numbers.'
				INSERT INTO tbFormData_Errors VALUES (NEWID(), @TrxID, 'InvalidLength' ,@FieldNameID, @ErrorMsg,@FieldLength,@FieldLength)
			END 
		END 
	END 
	
	--Update to the newly validated FieldValue 
	IF @FieldValue <> (SELECT TOP 1 FieldValue FROM tbFormDataElement WHERE rowID=@rowID)
	BEGIN 
		UPDATE tbFormDataElement SET FieldValue=@FieldValue
		WHERE rowID=@rowID
	END 
	
END 	
		
END