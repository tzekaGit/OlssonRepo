
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[tbFormData_Errors]
AS
SELECT        RowId, FieldName, ErrorMsg, ValidationType, TrxID,MinLength,MaxLength
FROM            SEM.dbo.tbFormData_Errors AS tbFormData_Errors_1