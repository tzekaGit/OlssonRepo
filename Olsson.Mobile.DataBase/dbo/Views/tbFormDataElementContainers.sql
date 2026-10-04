CREATE VIEW dbo.tbFormDataElementContainers
AS
SELECT DISTINCT 
                         SEMs.SectionName + CAST(el.ListId * - 1 AS varchar(5)) AS id, el.ListId * - 1 AS ContainerID, el.SectionID, SEMs.SectionName, 'section' + CAST(el.SectionID AS varchar(3)) + 'container' AS containerName, 
                         el.ParentRowId, el.DocumentId
FROM            dbo.tbFormDataElement AS el INNER JOIN
                         SEM.dbo.tbFormData AS tbfd ON tbfd.RowId = el.ParentRowId INNER JOIN
                         SEM.dbo.SEM_tbFormSection AS SEMs ON SEMs.SectionID = el.SectionID AND SEMs.FormID = tbfd.FormID
WHERE        (isNumeric(el.ListId) = 1) AND (el.ListId < 0) AND (el.SectionID > 0)