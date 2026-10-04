


CREATE VIEW [dbo].[SEM_v_XML_NewForm]
AS
SELECT ( SELECT TOP 100 PERCENT
Form.FormID 
	,Form.FormName
	,Section.SectionName
	,Section.SectionCaption
	,Section.SectionSort
	,Section.SectionAllowMultiRecord
	,Element.ElementSort
	,Element.ElementType
	,Element.ElementName
	,Element.ElementCaption
	,Element.ElementText
	,Element.ElementFieldCalculation
	,Element.ElementFieldID
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
INNER JOIN dbo.SEM_tbFormSection Section	
	ON Form.FormID = Section.FormID
INNER JOIN 
	dbo.SEM_tbFormSectionElement Element 
		ON Section.FormID = Element.FormID
			AND Section.SectionID = Element.SectionID
LEFT OUTER JOIN dbo.SEM_tbSchemaTableField FieldSchema
	ON Element.ElementFieldID = FieldSchema.FieldID
LEFT OUTER JOIN dbo.SEM_tbSchemaTable as TableSchema ON FieldSchema.FieldTableID = TableSchema.TableID
ORDER BY Section.SectionSort
	,Element.ElementSort
FOR XML AUTO 
	,TYPE
	,ELEMENTS 
	) as XML