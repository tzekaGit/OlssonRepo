CREATE VIEW dbo.tbFormDataElement_v_Portal
AS
SELECT DISTINCT 
                         fde.ParentRowId, fde.DocumentId, fde.SectionID, CASE WHEN ISNULL(FieldLookupAllowMultiSelect, '0') <> '0' AND REPLACE(REPLACE(fde.ListId, fde.FieldValue, ''), '-', '') 
                         = '' THEN '0' WHEN ISNULL(FieldLookupAllowMultiSelect, '0') <> '0' AND REPLACE(REPLACE(fde.ListId, fde.FieldValue, ''), '-', '') <> '' THEN REPLACE(REPLACE(fde.ListId, fde.FieldValue, ''), '-', '') 
                         WHEN fde.ListId = '-0' THEN '0' ELSE REPLACE(fde.ListId, '-', '') END AS ContainerID, CASE WHEN ISNULL(sfs.SectionAllowMultiRecord, 0) <> 0 THEN 'section' + CAST(fde.SectionID AS varchar(10)) 
                         + 'container' ELSE 'section' + CAST(fde.SectionID AS varchar(10)) END AS ContainerName
FROM            SEM.dbo.tbFormDataElement AS fde INNER JOIN
                         SEM.dbo.tbFormData AS fd ON fde.ParentRowId = fd.RowId INNER JOIN
                         SEM.dbo.SEM_tbForm AS sf ON sf.FormID = fd.FormID INNER JOIN
                         SEM.dbo.SEM_tbFormSection AS sfs ON sfs.FormID = sf.FormID AND sfs.SectionID = fde.SectionID INNER JOIN
                         SEM.dbo.SEM_tbFormSectionElement AS sfse ON sfs.FormID = sfse.FormID AND sfs.SectionID = sfse.SectionID AND sfse.ElementFieldID = fde.FieldId LEFT OUTER JOIN
                         SEM.dbo.SEM_tbSchemaTable AS sst ON sst.TableID = sfs.SectionSourceTable LEFT OUTER JOIN
                         SEM.dbo.SEM_tbSchemaTableField AS sstf ON sstf.FieldID = fde.FieldId AND sstf.FieldTableID = sst.TableID
WHERE        (CASE WHEN ISNULL(FieldLookupAllowMultiSelect, '0') <> '0' AND REPLACE(REPLACE(fde.ListId, fde.FieldValue, ''), '-', '') = '' THEN '0' WHEN ISNULL(FieldLookupAllowMultiSelect, '0') <> '0' AND 
                         REPLACE(REPLACE(fde.ListId, fde.FieldValue, ''), '-', '') <> '' THEN REPLACE(REPLACE(fde.ListId, fde.FieldValue, ''), '-', '') WHEN fde.ListId = '-0' THEN '0' ELSE REPLACE(fde.ListId, '-', '') END > 0)