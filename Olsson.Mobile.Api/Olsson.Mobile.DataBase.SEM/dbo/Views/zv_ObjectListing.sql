
CREATE VIEW [dbo].[zv_ObjectListing]
AS
SELECT DISTINCT TOP (100) PERCENT ObjectName, DB, ObjectType
FROM  (SELECT TOP (100) PERCENT OBJ.name AS ObjectName, FLD.name AS FieldName, OBJ.id AS ObjectId, OBJ.xtype AS ObjectTypeCode, FLD.colid AS FieldOrder, 'CW' AS DB, FLD.type AS FieldType, CASE OBJ.xType WHEN 'V' THEN 'View' WHEN 'U' THEN 'Table' WHEN 'FN' THEN 'Function' WHEN 'P' THEN 'Procedure' END AS ObjectType
         FROM  sys.sysobjects AS OBJ INNER JOIN
                  sys.syscolumns AS FLD ON OBJ.id = FLD.id
         WHERE (OBJ.xtype = 'v') OR
                  (OBJ.xtype = 'U') OR
                  (OBJ.xtype = 'FN') OR
                  (OBJ.xtype = 'p')
         ORDER BY ObjectName) AS FakeTable
WHERE (ObjectType = 'View') OR
         (ObjectType = 'Table')
ORDER BY ObjectType, ObjectName