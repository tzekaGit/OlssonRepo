CREATE VIEW dbo.tbFormDataElement
AS
SELECT        RowId, DocumentId, ListId, FieldId, FieldName, FieldValue, SectionID, ParentRowId, DateCreated, DateUpdated
FROM            SEM.dbo.tbFormDataElement AS tbFormDataElement_1