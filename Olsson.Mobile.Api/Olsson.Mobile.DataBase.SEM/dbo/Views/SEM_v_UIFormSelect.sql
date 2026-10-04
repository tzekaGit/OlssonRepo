CREATE VIEW dbo.SEM_v_UIFormSelect
AS
SELECT        TOP (100) PERCENT Name, ID
FROM            (SELECT        FormName AS Name, FormID AS ID
                          FROM            dbo.SEM_tbForm
                          UNION
                          SELECT        '** Add New **' AS Name, '' AS ID) AS T1
ORDER BY Name