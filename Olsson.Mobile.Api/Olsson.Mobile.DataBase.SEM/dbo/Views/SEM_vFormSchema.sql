/* Note 
	- If no element name the entry is text/instructional
	- Element Type: Display and
					Field are both data elements and must be captured
						Display is calculated where field is user input
					Text is only for instructional information and does not need to be included in the xml document?

***************************************
View Name: SEM_vFormSchema

Note 
	- If no element name the entry is text/instructional
	- Element Type: Display and
					Field are both data elements and must be captured
						Display is calculated where field is user input
					Text is only for instructional information and does not need to be included in the xml document?
*****************************************/
CREATE VIEW dbo.SEM_vFormSchema
AS
SELECT TOP (100) PERCENT Form.FormID, Form.FormName, Section.SectionID, Section.SectionName, Section.SectionCaption, CASE isnull(Section.SectionCaption, '') 
                  WHEN '' THEN Section.SectionName ELSE Section.SectionCaption END AS cSectionCaption, Section.SectionSort, ABS(Section.SectionAllowMultiRecord) AS cSectionMultiRecord, 
                  CASE Abs(Section.SectionAllowMultiRecord) WHEN 1 THEN Section.SectionName ELSE 'MainRecord' END AS XMLSection, Element.ElementSort, Element.ElementType, Element.ElementName, Element.ElementCaption, 
                  Element.ElementText, Element.ElementFieldCalculation, Element.ElementFieldID, Element.ElementFieldRequired, ABS(Element.ElementFieldRequired) AS cRequired, Element.ElementValueListDisplay, 
                  FieldCollection.TableID AS FieldCatalogId, FieldCollection.TableName AS FieldCatalogName, FieldSchema.FieldID, FieldSchema.FieldPos, FieldSchema.FieldName, FieldSchema.FieldCaption, FieldSchema.FieldType, 
                  FieldSchema.FieldSize, FieldSchema.FieldDecimal, FieldSchema.FieldLookUpType, FieldSchema.FieldLookUpCustom, FieldSchema.FieldLookUpListCode, FieldSchema.FieldLookupAllowMultiSelect, 
                  ABS(FieldSchema.FieldLookupAllowMultiSelect) AS cFieldLookUpMultiSelect, Element.ElementID
FROM     dbo.SEM_tbForm AS Form INNER JOIN
                  dbo.SEM_tbFormSection AS Section ON Form.FormID = Section.FormID INNER JOIN
                  dbo.SEM_tbFormSectionElement AS Element ON Section.FormID = Element.FormID AND Section.SectionID = Element.SectionID LEFT OUTER JOIN
                  dbo.SEM_tbSchemaTableField AS FieldSchema ON Element.ElementFieldID = FieldSchema.FieldID LEFT OUTER JOIN
                  dbo.SEM_tbSchemaTable AS FieldCollection ON FieldSchema.FieldTableID = FieldCollection.TableID
ORDER BY Form.FormName, Section.SectionSort, Element.ElementSort