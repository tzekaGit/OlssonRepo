


CREATE FUNCTION [dbo].[Sikich_IDGen](@IntgrID nvarchar(255)) 
RETURNS nvarchar(255)
AS
BEGIN
-- =============================================
-- Description:      Creates a batch ID number based on a Process ID
-- =============================================

       -- Declare the return variable here
       DECLARE @ID nvarchar(255);

       set @ID = @IntgrID 
              + RIGHT('0000' + CONVERT(varchar(4),YEAR(GETDATE() )), 2) 
              + RIGHT('00' + CONVERT(varchar(2),MONTH(GETDATE() )), 2) 
        + RIGHT('00' + CONVERT(varchar(2),DAY(GETDATE() )), 2)   
        + RIGHT('00'+ convert(varchar(2),DATEPART(HOUR,GETDATE())),2)
        + RIGHT('00'+ convert(varchar(2),DATEPART(MINUTE  ,GETDATE())),2)
        + RIGHT('00'+ convert(varchar(2),DATEPART(SECOND   ,GETDATE())),2)
       -- Return the result of the function
       RETURN @ID

END