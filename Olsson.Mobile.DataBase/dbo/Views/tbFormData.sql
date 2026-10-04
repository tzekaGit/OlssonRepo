CREATE VIEW dbo.tbFormData
AS
SELECT        RowId, FormID, UserID, DocumentId, DocumentType, DocumentTitle, DocumentStatus, Audit_AddDate, Audit_AddBy, Audit_UpdateDate, Audit_UpdateBy, AdminStatus, AdminMessage
FROM            SEM.dbo.tbFormData