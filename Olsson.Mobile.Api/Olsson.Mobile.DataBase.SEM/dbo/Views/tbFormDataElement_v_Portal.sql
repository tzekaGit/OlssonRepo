
CREATE VIEW [dbo].[tbFormDataElement_v_Portal]
as
select fde.RowId, fde.ParentRowId,fde.DocumentId, fde.ListId, fde.FieldName, fde.FieldValue,fde.SectionID, fde.DateCreated, fde.DateUpdated,
				CASE 
					WHEN 	
					ISNULL(FieldLookupAllowMultiSelect,'0')<>'0' and REPLACE(REPLACE(fde.ListId,fde.FieldValue,''),'-','') ='' 
							THEN '0'
						WHEN ISNULL(FieldLookupAllowMultiSelect,'0')<>'0' and REPLACE(REPLACE(fde.ListId,fde.FieldValue,''),'-','')<>'' 	
							THEN REPLACE(REPLACE(fde.ListId,fde.FieldValue,''),'-','')
						WHEN fde.ListId = '-0'
							THEN '0'
						ELSE REPLACE(fde.ListId,'-','')
					END
as ContainerID,


CASE 
	WHEN ISNULL(sfs.SectionAllowMultiRecord,0)<>0
		THEN 'section' + Cast(fde.SectionID as varchar(10))+'container'
		
	ELSE 
		'section' + Cast(fde.SectionID as varchar(10))
END as ContainerName

from tbFormDataElement fde
	inner join tbFormData fd on fde.ParentRowID = fd.RowId
	inner join SEM_tbForm sf on sf.FormID=fd.FormID
	inner join SEM_tbFormSection sfs on sfs.FormID=sf.FormID and sfs.SectionID=fde.SectionID
	inner join SEM_tbFormSectionElement sfse on sfs.FormID=sfse.FormID and sfs.SectionID=sfse.SectionID
			and sfse.ElementFieldID=fde.FieldId
	left outer join SEM_tbSchemaTable sst on sst.TableID=sfs.SectionSourceTable 
	left outer join SEM_tbSchemaTableField sstf on sstf.FieldID=fde.FieldId and sstf.FieldTableID=sst.TableID