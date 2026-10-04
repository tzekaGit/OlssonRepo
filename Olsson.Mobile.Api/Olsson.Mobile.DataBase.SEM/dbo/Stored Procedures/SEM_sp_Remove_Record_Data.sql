
-- =============================================
-- SeM Transformation Stored Procedure 
--	Author:	Mike Weisshaar <mweisshaar@sikich.com>
--				
-- Create date: 5/3/2016
-- Name:	SEM_sp_Remove_Record_Data
-- Description:	 Removes all record data associated with parent row id.
--
-- EXEC SEM_sp_Remove_Record_Data '83DC3D1E-9C4C-4BDD-90E1-D96094571EDE' 
-- 
-- =============================================
--			MODIFICATIONS
-- =============================================
--2016.05.03 - Original Code 
-- =============================================
CREATE PROCEDURE [dbo].[SEM_sp_Remove_Record_Data] 
	 @ParentRowID As uniqueidentifier

AS
BEGIN
	DELETE FROM tbFormData where rowID=@ParentRowID
	DELETE FROM tbFormDataElementImage 
	where RowID in (select rowID from tbFormDataElement where parentrowid=@parentrowid)
	
	DELETE FROM tbFormDataElement where parentrowid=@parentrowid	

END