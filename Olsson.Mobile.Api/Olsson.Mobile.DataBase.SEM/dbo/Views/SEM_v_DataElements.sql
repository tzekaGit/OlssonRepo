



CREATE VIEW [dbo].[SEM_v_DataElements]
AS
SELECT REPLACE(d.FieldName, d.ListId, '') AS DataElement
	,CASE SectionAllowMultiRecord
		WHEN 0
			THEN 'singleRecord'
		ELSE 'multirecord'
		END AS SectionType
	,ElementDefinition
	,ed.FieldName AS FieldSchemaName
	,ed.FormName
	,d.DocumentId
	,f.UserID
	,d.ParentRowId
	,d.RowId
	,d.ListId
	,d.FieldName
	,d.FieldValue
	,d.FieldId
	,ed.TableID
	,f.FormID
	,d.SectionID
	,ed.ElementID
	,ed.SectionName
	,ed.ElementType
	,ed.ElementName
	,ed.FieldLookUpType
	,ed.FieldLookUpCustom
	,ed.FieldLookUpListCode
	,ed.ElementFieldCalculation
	,ed.ElementSort
	,ed.SectionSort
FROM tbFormDataElement d
INNER JOIN tbFormData f ON f.DocumentId = d.DocumentId
INNER JOIN SEM_v_ElementDefinition ed ON f.FormID = ed.FormID
	--and d.FieldId=ed.FieldID
	AND d.ElementID = ed.ElementID