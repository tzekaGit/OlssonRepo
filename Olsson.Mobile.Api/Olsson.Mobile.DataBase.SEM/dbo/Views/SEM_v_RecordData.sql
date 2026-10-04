/*WARNING! ERRORS ENCOUNTERED DURING SQL PARSING! */
CREATE VIEW dbo.SEM_v_RecordData
AS
SELECT TOP (100) PERCENT fde.DocumentId, fd.DocumentStatus, fd.DocumentTitle, f.FormName, fs.SectionName, fse.ElementName, fde.FieldValue, fse.ElementSort, fde.ElementID, fde.FieldName, fde.ListId, fse.ElementCaption, 
                  fse.ElementFieldCalculation, fse.ElementFieldID, fse.ElementFieldRequired, fse.ElementText, fse.ElementType, fse.ElementValueListDisplay, fs.SectionID, fs.SectionAllowMultiRecord, fs.SectionCaption, 
                  fs.SectionExpanded, fs.SectionSort, fs.SectionSourceTable, f.FormID, f.FormState, f.FormStatus, f.FormXML, Usr.UserName, UsrUpdBy.UserName AS UpdatedBy_UserName, 
                  UsrAddBy.UserName AS AddedBy_UserName, fd.UserID, fd.Audit_AddBy, fd.Audit_AddDate, fd.Audit_UpdateBy, fd.Audit_UpdateDate, fde.ParentRowId, fde.RowId, ISNULL(CAST(REPLACE(fde.ListId, 'Value', '') 
                  AS INT), 0) * - 1 AS ListSort, CASE isnull(SectionAllowMultiRecord, 0) WHEN 0 THEN 'N' ELSE 'Y' END AS IsMultiRec, ISNULL(dbo.SEM_tbSchemaTableField.FieldType, '') AS DataFieldType, fd.AdminStatus, 
                  fd.AdminMessage, fd.AdminDownloadDateTime, fd.AdminNotificationDateTime
FROM     dbo.SEM_tbFormSection AS fs LEFT OUTER JOIN
                  dbo.SEM_tbForm AS f ON f.FormID = fs.FormID RIGHT OUTER JOIN
                  dbo.SEM_tbSchemaTableField RIGHT OUTER JOIN
                  dbo.SEM_tbFormSectionElement AS fse ON dbo.SEM_tbSchemaTableField.FieldID = fse.ElementFieldID ON fs.FormID = fse.FormID AND fs.SectionID = fse.SectionID RIGHT OUTER JOIN
                  dbo.SEM_v_ASPusers AS UsrAddBy RIGHT OUTER JOIN
                  dbo.tbFormData AS fd INNER JOIN
                  dbo.tbFormDataElement AS fde ON fd.RowId = fde.ParentRowId ON UsrAddBy.Id = fd.Audit_AddBy LEFT OUTER JOIN
                  dbo.SEM_v_ASPusers AS UsrUpdBy ON fd.Audit_UpdateBy = UsrUpdBy.Id LEFT OUTER JOIN
                  dbo.SEM_v_ASPusers AS Usr ON fd.UserID = Usr.Id ON fse.ElementID = fde.ElementID
ORDER BY f.FormName, fde.DocumentId, fs.SectionSort, ListSort, fse.ElementSort