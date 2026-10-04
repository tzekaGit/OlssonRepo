CREATE PROCEDURE [dbo].[GetNextNumber]
@NextNumber AS BIGINT OUTPUT,
@IncrementBy BIGINT = 1,
@FieldName AS varchar(100)
AS
SET NOCOUNT ON;
UPDATE [dbo].SYS_tbNumberSequence
SET @NextNumber = [NextNumber] = [NextNumber] + ISNULL(@IncrementBy,0)
WHERE Field=@FieldName

RETURN @NEXTNUMBER