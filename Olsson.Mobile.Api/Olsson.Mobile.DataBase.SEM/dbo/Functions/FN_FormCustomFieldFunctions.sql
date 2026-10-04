

-- =============================================
-- Author:		Mike Weisshaar
-- Create date: 2016.02.23
-- Description:	returns a value for fields with custom look ups
-- =============================================
CREATE FUNCTION [dbo].[FN_FormCustomFieldFunctions]
(
	@FormID As int
	,@SectionID As int
	,@ElementID AS int
	,@UserID as nvarchar(255) =NULL
	,@DocumentID As varchar(100) =NULL 
	,@ListId As varchar(100) =NULL
	
)
RETURNS varchar(100) 
AS
BEGIN
	DECLARE @functionValue as varchar(100)= ''
	DECLARE @FieldLookUpCustom as varchar(50)
	DECLARE @FieldType as varchar(50)

	SELECT top 1 @FieldLookUpCustom=FieldLookUpCustom, @FieldType=FieldType
	FROM SEM_v_ElementDefinition
	WHERE 
		FormID=@FormID
		and SectionID=@SectionID
		and ElementID=@ElementID

	/* Possible FieldLookUpCustom Functions from SEM_vElementDifinition where ElementDefinition ='label_function' - 2016.02.23
		FormName() --Grabs Form Name 
		GetDate()  --Grabs current date for NON-posted Documents 
		GetDocumentId() --Grabs DocumentID for POSTED Documents 
						--Generates DocumentID for NON-posted Documents
		GetListId() --Grabs ListID for POSTED Documents 
		UserId() --Grabs current user. 
	*/	
				
		
	IF @FieldLookUpCustom='GetDate()' and @FieldType='Date'
	BEGIN 
		SET @functionValue = CAST(GetDate() as varchar(50))
	END 
	
	IF @FieldLookUpCustom='GetDocumentId()' and @DocumentID is not null 
	BEGIN 
		SET @functionValue=@DocumentID
	END 
	
	--DocumentID does not exist yet, create one.
	IF @FieldLookUpCustom='GetDocumentId()' and @DocumentID is null 
	BEGIN 
		SET @functionValue=dbo.Sikich_IDGen (@UserID)
	END 
	
	IF @FieldLookUpCustom='GetListId()' and @DocumentID is not null and @ListId is not null
	BEGIN 
		SET @functionValue=@ListId
	END 
	
	If @FieldLookUpCustom='UserId()' and @UserID is not null
	BEGIN 
		SET @functionValue=@UserID
	END 
	
	If @FieldLookUpCustom='FormName()'
	BEGIN 
		SET @functionValue=(Select FormName from [SEM].[dbo].[SEM_tbForm] WHERE formID=@formID)
	END 	
	
	RETURN @functionValue
END