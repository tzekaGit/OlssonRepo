
-- =============================================
-- SeM Transformation Stored Procedure 
--	Author:	Mike Weisshaar <mweisshaar@sikich.com>
--				
-- Create date: 3/7/2016
-- Name:	SEM_sp_Parse_FieldName
-- Description:	 Parses HTML Field Name and Outputs correct ID's (Element, Section, etc)
--
-- At the minimum, this procedure needs a Parse String (aka ElementName or XML ElementID), a FormID, and a delimiter defined.
-- =============================================
--			MODIFICATIONS
-- =============================================
--2016.03.07 - Original Code 
-- =============================================
CREATE PROCEDURE [dbo].[SEM_sp_Parse_FieldName] 
	 @ParseString varchar(100)
	 ,@delimiter varchar
	 ,@DocumentID varchar(100)
	 ,@FieldName varchar(100) OUTPUT
	 ,@FormID INT  
	 ,@SectionID INT OUTPUT 
	 ,@ElementID INT OUTPUT 
	 ,@FieldID INT OUTPUT
	 ,@LISTID varchar(100) OUTPUT 	 
AS
BEGIN
	DECLARE @tmpElementID int 

	--Set the delimiter default.
	IF ISNULL(@delimiter,'')=''
	BEGIN
		SET @delimiter='-'
	END
	
	SET @FieldName=@ParseString

	DECLARE  @start INT, @end INT , @countID INT

	SELECT @countID=0,@start = 1, @end = CHARINDEX(@delimiter, @ParseString) 
	WHILE @start < LEN(@ParseString) + 1 BEGIN 
		IF @end = 0  
			SET @end = LEN(@ParseString) + 1
		
		IF @countID=0
		BEGIN  --ElementID 
			
			IF ISNUMERIC(CAST(REPLACE(SUBSTRING(@ParseString, @start, @end),@delimiter,'') as varchar(50)))=1 
			BEGIN 
				SET @tmpElementID=CAST(REPLACE(SUBSTRING(@ParseString, @start, @end),@delimiter,'') as int)
			END 
		END 
		
		IF @countID=1
		BEGIN	--What follows 				
			SET @ListID=(Select CAST(SUBSTRING(@ParseString, @start, @end) as varchar(50))) 
		END

		SET @countID=@countID+1
		SET @start = @end + 1 
		SET @end = CHARINDEX(@delimiter, @ParseString, @start)
		
	END 
	
	
	--Find these values from SeM database. 
	SELECT @SectionID=Section.SectionID, @ElementID=Element.ElementID ,@FieldID=Element.ElementFieldID
	FROM  dbo.SEM_tbForm Form
		INNER JOIN dbo.SEM_tbFormSection Section ON Form.FormID = Section.FormID
		INNER JOIN dbo.SEM_tbFormSectionElement Element ON Section.FormID = Element.FormID
					AND Section.SectionID = Element.SectionID
	WHERE Element.ElementID=@tmpElementID
		and Form.FormID=@FormID

	
	--Set Actual List ID if there are more than one of the delimiter (-)
	IF len(@ParseString) - len(replace(@ParseString, @Delimiter, ''))>1
	BEGIN 
		DECLARE @countListID int
		SET @countListID=1
		SELECT @countID=0,@start = 1, @end = CHARINDEX(@delimiter, @ParseString) ,@countListID=len(@ParseString) - len(replace(@ParseString, @Delimiter, ''))
		WHILE @start < LEN(@ParseString) + 1 BEGIN 
			IF @end = 0  
				SET @end = LEN(@ParseString) + 1
		   
			IF @countID=@countListID
			BEGIN					
				SET @ListID=(CAST(SUBSTRING(@ParseString, @start, @end) as varchar(50))) 
			END

			SET @countID=@countID+1
			SET @start = @end + 1 
			SET @end = CHARINDEX(@delimiter, @ParseString, @start)
			
		END 
	END 	
	
	--If, ListID is not numeric. Set it to 0. 
	IF ISNUMERIC(@ListID)=0
	BEGIN 
		SET @ListID='0'
	END 
	
	--If, ListID is null. Set it to 0. 
	IF ISNULL(@ListID,'')=''
	BEGIN 
		SET @ListID='0'
	END 
	
	SET @ListID= @delimiter+@ListID 
	
END