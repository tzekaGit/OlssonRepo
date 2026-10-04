CREATE VIEW dbo.view_FormData
AS
SELECT        SEM.dbo.SEM_tbForm.FormID, ISNULL(SEM.dbo.tbFormData.RowId, CAST(CAST(0 AS binary) AS uniqueidentifier)) AS RowID, SEM.dbo.tbFormData.DocumentId, SEM.dbo.tbFormData.DocumentType, 
                         SEM.dbo.tbFormData.DocumentTitle, SEM.dbo.tbFormData.DocumentStatus, SEM.dbo.tbFormData.Audit_AddDate, SEM.dbo.tbFormData.Audit_AddBy, SEM.dbo.tbFormData.Audit_UpdateDate, 
                         SEM.dbo.tbFormData.Audit_UpdateBy, SEM.dbo.SEM_tbForm.FormName, SEM.dbo.SEM_tbForm.FormStatus, SEM.dbo.SEM_tbForm.Audit_AddDate AS Expr2, SEM.dbo.SEM_tbForm.Audit_AddBy AS Expr3, 
                         SEM.dbo.SEM_tbForm.Audit_UpdateDate AS Expr4, SEM.dbo.SEM_tbForm.Audit_UpdateBy AS Expr5, SEM.dbo.tbFormData.UserID, SEM.dbo.tbFormData.AdminMessage, SEM.dbo.tbFormData.AdminStatus
FROM            SEM.dbo.SEM_tbForm LEFT OUTER JOIN
                         SEM.dbo.tbFormData ON SEM.dbo.SEM_tbForm.FormID = SEM.dbo.tbFormData.FormID