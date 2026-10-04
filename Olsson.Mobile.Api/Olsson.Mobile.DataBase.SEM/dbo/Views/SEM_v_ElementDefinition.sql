









--select * from SEM_v_elementDefinition
--where ElementDefinition='label_function'

--select * from [dbo].[SEM_v_ElementDefinition] 


CREATE VIEW [dbo].[SEM_v_ElementDefinition] 
as
 SELECT 
Form.FormID 
,Form.FormName
,Form.FormStatus
,Section.SectionID
,Element.ElementID

,CASE 
	WHEN ElementType = 'Display'
		THEN CASE 
			WHEN FieldSchema.FieldLookUpType = 'Calculated' and FieldSchema.FieldLookUpCustom = 'GetDate()' and FieldType='Date'
				THEN 'label_datenow'
			WHEN FieldSchema.FieldLookUpType = 'Calculated' and FieldSchema.FieldLookUpCustom = 'UserId()' 
				THEN 'label_user'
			WHEN FieldSchema.FieldLookUpType = 'Calculated' and FieldSchema.FieldLookUpCustom = 'GetDocumentId()' 
				THEN 'label_docID'
			WHEN FieldSchema.FieldLookUpType = 'Calculated' and FieldSchema.FieldLookUpCustom is not null
				THEN 'label_function'
			WHEN FieldSchema.FieldLookUpType = 'Calculated' and Element.ElementFieldCalculation is not null
				THEN 'label_calculated'
			ELSE 'unknown'
		END 			
	WHEN ElementType = 'Field'
		THEN CASE 
			WHEN FieldSchema.FieldType = 'Image'
				THEN 'image'
			WHEN FieldSchema.FieldType = 'Image Low Res'
				THEN 'imageLowRes'
			WHEN FieldSchema.FieldType = 'Image High Res'
				THEN 'imageHighRes'
			WHEN FieldSchema.FieldType = 'Annotated Image'
				THEN 'AnnotatedImage'
			WHEN FieldSchema.FieldType = 'Memo'
				THEN 'memo'
			WHEN FieldSchema.FieldType = 'Yes/No'
				THEN 'switch'
			WHEN FieldSchema.FieldType ='Date'
				THEN 'field_date'
			WHEN FieldSchema.FieldType ='Currency'
				THEN 'textbox_currency'	
			WHEN FieldSchema.FieldType ='Phone'
				THEN 'textbox_phone'		
			WHEN FieldSchema.FieldType = 'Text' or FieldSchema.FieldType='Lookup'
				THEN CASE
					WHEN FieldSchema.FieldLookUpType is NULL
						THEN 'textbox'
					WHEN FieldSchema.FieldLookUpType = 'ValueList' and Element.ElementValueListDisplay='Radio Button List' 
							and FieldSchema.FieldLookupAllowMultiSelect = 0
						THEN 'radio_valuelist'
					WHEN FieldSchema.FieldLookUpType = 'LookupList' and Element.ElementValueListDisplay='Radio Button List' 
							and FieldSchema.FieldLookupAllowMultiSelect = 0
						THEN 'radio_lookuplist'	
					WHEN FieldSchema.FieldLookUpType = 'ValueList' and Element.ElementValueListDisplay='Switch' 
							and FieldSchema.FieldLookupAllowMultiSelect = 0
						THEN 'switch_valuelist'		
					WHEN FieldSchema.FieldLookUpType = 'LookupList' and Element.ElementValueListDisplay='Switch' 
							and FieldSchema.FieldLookupAllowMultiSelect = 0
						THEN 'switch_lookuplist'		
					WHEN FieldSchema.FieldLookUpType = 'ValueList' and Element.ElementValueListDisplay='Drop-down List' 
							and FieldSchema.FieldLookupAllowMultiSelect = 0
						THEN 'dropdownlist_valuelist'
					WHEN FieldSchema.FieldLookUpType = 'LookupList' and Element.ElementValueListDisplay='Drop-down List' 
							and FieldSchema.FieldLookupAllowMultiSelect = 0
						THEN 'dropdownlist_lookuplist'			
					WHEN FieldSchema.FieldLookUpType = 'ValueList' and Element.ElementValueListDisplay='Drop-down List' 
							and FieldSchema.FieldLookupAllowMultiSelect = 1
						THEN 'dropdownlist_multi_valuelist'
					WHEN FieldSchema.FieldLookUpType = 'LookupList' and Element.ElementValueListDisplay='Drop-down List' 
							and FieldSchema.FieldLookupAllowMultiSelect = 1
						THEN 'dropdownlist_multi_lookuplist'	
					WHEN FieldSchema.FieldLookUpType = 'ValueList' and FieldSchema.FieldLookupAllowMultiSelect = 0
						THEN 'dropdownlist_valuelist'
					WHEN FieldSchema.FieldLookUpType = 'LookupList' and FieldSchema.FieldLookupAllowMultiSelect = 0
						THEN 'dropdownlist_lookuplist'
					WHEN FieldSchema.FieldLookUpType = 'Calculated'
						THEN 'label_calculated'
					WHEN FieldSchema.FieldLookUpType = 'ValueList' and FieldSchema.FieldLookupAllowMultiSelect <> 0
						THEN 'checkbox_valuelist'
					WHEN FieldSchema.FieldLookUpType = 'LookupList' and FieldSchema.FieldLookupAllowMultiSelect <> 0
						THEN 'checkbox_lookuplist'
					ELSE 'unknown'
				END	
			ELSE 'unknown'	
			END 
	WHEN ElementType = 'Text'
		THEN 'label_caption'
	ELSE 'unknown'
END as ElementDefinition


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
	,Element.ElementValueListDisplay
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