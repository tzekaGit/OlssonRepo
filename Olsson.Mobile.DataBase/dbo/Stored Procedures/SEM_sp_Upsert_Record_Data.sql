
-- =============================================
-- SeM Transformation Stored Procedure 
--	Author:	Mike Weisshaar <mweisshaar@sikich.com>
--				
-- Create date: 3/7/2016
-- Name:	SEM_sp_Upsert_Record_Data
-- Description:	 Inserts/Updates Form Data into tbFormData and tbFormDataElement.	
--
-- EXEC SEM_sp_Upsert_Record_Data '83DC3D1E-9C4C-4BDD-90E1-D96094571EDE', 'testuser',1,'',1,'' OUTPUT 
-- 
-- =============================================
--			MODIFICATIONS
-- =============================================
--2016.03.07 - Original Code 
-- =============================================
CREATE PROCEDURE [dbo].[SEM_sp_Upsert_Record_Data] 
	 @ParentRowID As uniqueidentifier
	,@userID As uniqueidentifier --varchar(100)
	,@FormID as INT 
	,@TrxID As uniqueidentifier
	,@SubmitDocument as INT --0 = Draft; 1 = Saved; 2 = Posted (Submitted for Validation).
	,@IsSuccessful as BIT OUTPUT --1 is successful, 0 means that there were validation errors for that Transaction (TrxID)
AS
BEGIN
	EXEC SeM.dbo.SEM_sp_Upsert_Record_Data @ParentRowID, @userID, @FormID, @TrxID, @SubmitDocument, @IsSuccessful OUTPUT
END