



CREATE FUNCTION [dbo].[Sikich_IDGen](@UserID nvarchar(255)) 
RETURNS nvarchar(255)
AS
BEGIN
-- =============================================
-- Description:      Creates a unique ID based on timestamp and UserID
-- =============================================

       -- Declare the return variable here
       DECLARE @ID nvarchar(255);

       set @ID = 
              RIGHT('0000' + CONVERT(varchar(4),YEAR(GETDATE() )), 4) 
              + RIGHT('00' + CONVERT(varchar(2),MONTH(GETDATE() )), 2) 
        + RIGHT('00' + CONVERT(varchar(2),DAY(GETDATE() )), 2)   
        + RIGHT('00'+ convert(varchar(2),DATEPART(HOUR,GETDATE())),2)
        + RIGHT('00'+ convert(varchar(2),DATEPART(MINUTE  ,GETDATE())),2)
        + RIGHT('00'+ convert(varchar(2),DATEPART(SECOND   ,GETDATE())),2)       


       RETURN @ID

END