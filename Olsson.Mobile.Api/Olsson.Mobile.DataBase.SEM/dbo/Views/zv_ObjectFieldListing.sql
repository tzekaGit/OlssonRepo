CREATE VIEW dbo.zv_ObjectFieldListing
AS
SELECT TOP (100) PERCENT u.name + '.' + t.name AS [table], td.value AS table_desc, c.name AS [column], cd.value AS column_desc, c.colorder
FROM  sys.sysobjects AS t INNER JOIN
         sys.sysusers AS u ON u.uid = t.uid LEFT OUTER JOIN
         sys.extended_properties AS td ON td.major_id = t.id AND td.minor_id = 0 AND td.name = 'MS_Description' INNER JOIN
         sys.syscolumns AS c ON c.id = t.id LEFT OUTER JOIN
         sys.extended_properties AS cd ON cd.major_id = c.id AND cd.minor_id = c.colid AND cd.name = 'MS_Description'
WHERE (t.type = 'u')
ORDER BY t.name, c.colorder