


CREATE VIEW [dbo].[SEM_v_XML_SubmittedForm]
AS
SELECT ( SELECT TOP 100 PERCENT
Form.FormID 
	,Form.FormName
	,Document.DocumentID
	,Document.DocumentTitle
	,Document.DocumentStatus
	,Section.SectionName
	,Section.SectionCaption
	,Section.SectionSort
	,Section.SectionAllowMultiRecord
	,Section.ListID
	,Element.ElementSort
	,Element.ElementType
	,Element.ElementName
	,Element.ElementCaption
	,Element.ElementText
	,Element.ElementFieldCalculation
	,Element.ElementFieldID
	,ElementData.ListID as ElementListID
	,ElementData.FieldValue
	,TableSchema.TableID
	,TableSchema.TableName
	,FieldSchema.FieldID
	,FieldSchema.FieldPos
	,FieldSchema.FieldName
	,FieldSchema.FieldCaption
	,FieldSchema.FieldType
	,FieldSchema.FieldSize
	,FieldSchema.FieldDecimal
	,FieldSchema.FieldLookUpType
	,FieldSchema.FieldLookUpCustom
	,FieldSchema.FieldLookUpListCode
	,FieldSchema.FieldLookupAllowMultiSelect
FROM dbo.SEM_tbForm Form
INNER JOIN dbo.tbFormData Document ON Form.FormName = Document.DocumentType
INNER JOIN 
	(Select sec.SectionName,sec.SectionCaption,sec.SectionSort,sec.SectionAllowMultiRecord,sec.FormID, sec.SectionID, secData.ListID, secData.DocumentID FROM dbo.SEM_tbFormSection sec 
		LEFT OUTER JOIN 
			(select distinct DocumentID, ListID, SectionID FROM dbo.tbFormDataElement) secData on secData.SectionID = sec.SectionID 
	) Section	
	ON Form.FormID = Section.FormID
		AND Section.DocumentID = Document.DocumentID
INNER JOIN 
	dbo.SEM_tbFormSectionElement Element 
		ON Section.FormID = Element.FormID
			AND Section.SectionID = Element.SectionID
LEFT OUTER JOIN dbo.SEM_tbSchemaTableField FieldSchema
	ON Element.ElementFieldID = FieldSchema.FieldID
LEFT OUTER JOIN dbo.tbFormDataElement ElementData
	ON FieldSchema.FieldID = ElementData.FieldID
		and Element.ElementName = ElementData.FieldName
		and Section.DocumentID = ElementData.DocumentID
		and Section.ListID = ElementData.ListID 
LEFT OUTER JOIN dbo.SEM_tbSchemaTable as TableSchema ON FieldSchema.FieldTableID = TableSchema.TableID
ORDER BY Section.SectionSort
	,ElementData.ListID
	,Element.ElementSort
FOR XML AUTO 
	,TYPE
	,ELEMENTS 
	) as XML