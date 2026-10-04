CREATE VIEW dbo.tbData_v_RecordData
AS
SELECT        fde.DocumentId, REPLACE(fde.FieldName, fde.ListId, '') AS ElementDataName, fde.FieldValue AS ElementValue, CASE WHEN ISNULL(FieldLookupAllowMultiSelect, '0') <> '0' AND REPLACE(REPLACE(fde.ListId, 
                         fde.FieldValue, ''), '-', '') = '' THEN '0' WHEN ISNULL(FieldLookupAllowMultiSelect, '0') <> '0' AND REPLACE(REPLACE(fde.ListId, fde.FieldValue, ''), '-', '') <> '' THEN REPLACE(REPLACE(fde.ListId, fde.FieldValue, 
                         ''), '-', '') ELSE REPLACE(fde.ListId, '-', '') END AS ListID, sfse.ElementID, fde.FieldName AS ElementFieldName, fde.FieldId, fde.SectionID, sst.TableName, sstf.FieldName, sfs.SectionSort, sfse.ElementSort
FROM            dbo.tbFormDataElement AS fde INNER JOIN
                         dbo.tbFormData AS fd ON fde.ParentRowId = fd.RowId INNER JOIN
                         dbo.SEM_tbForm AS sf ON sf.FormID = fd.FormID INNER JOIN
                         dbo.SEM_tbFormSection AS sfs ON sfs.FormID = sf.FormID AND sfs.SectionID = fde.SectionID INNER JOIN
                         dbo.SEM_tbFormSectionElement AS sfse ON sfs.FormID = sfse.FormID AND sfs.SectionID = sfse.SectionID AND sfse.ElementFieldID = fde.FieldId LEFT OUTER JOIN
                         dbo.SEM_tbSchemaTable AS sst ON sst.TableID = sfs.SectionSourceTable LEFT OUTER JOIN
                         dbo.SEM_tbSchemaTableField AS sstf ON sstf.FieldID = fde.FieldId AND sstf.FieldTableID = sst.TableID