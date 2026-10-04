CREATE VIEW dbo.SEM_v_Record
AS
SELECT dbo.tbFormData.FormID, dbo.SEM_tbForm.FormName, dbo.tbFormData.UserID, dbo.tbFormData.DocumentId, dbo.tbFormData.DocumentType, dbo.tbFormData.DocumentTitle, dbo.tbFormData.DocumentStatus, 
                  dbo.tbFormData.Audit_AddDate, dbo.tbFormData.Audit_AddBy, dbo.tbFormData.Audit_UpdateDate, dbo.tbFormData.Audit_UpdateBy, dbo.tbFormData.RowId, Usr.UserName, 
                  UsrAddBy.UserName AS AddedBy_UserName, UsrUpdBy.UserName AS UpdatedBy_UserName, CONVERT(varchar(2), DATEPART(M, dbo.tbFormData.Audit_AddDate)) + '/' + CONVERT(varchar(2), DATEPART(d, 
                  dbo.tbFormData.Audit_AddDate)) + '/' + CONVERT(varchar(4), DATEPART(year, dbo.tbFormData.Audit_AddDate)) AS AddedDate, dbo.tbFormData.AdminStatus, dbo.tbFormData.AdminMessage, 
                  dbo.tbFormData.AdminDownloadDateTime, dbo.tbFormData.AdminNotificationDateTime
FROM     dbo.SEM_v_ASPusers AS UsrUpdBy RIGHT OUTER JOIN
                  dbo.SEM_v_ASPusers AS UsrAddBy RIGHT OUTER JOIN
                  dbo.tbFormData INNER JOIN
                  dbo.SEM_tbForm ON dbo.tbFormData.FormID = dbo.SEM_tbForm.FormID ON UsrAddBy.Id = dbo.tbFormData.Audit_AddBy ON UsrUpdBy.Id = dbo.tbFormData.Audit_UpdateBy LEFT OUTER JOIN
                  dbo.SEM_v_ASPusers AS Usr ON dbo.tbFormData.UserID = Usr.Id