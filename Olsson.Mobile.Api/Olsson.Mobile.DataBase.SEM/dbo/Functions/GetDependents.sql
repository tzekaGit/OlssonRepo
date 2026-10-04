CREATE FUNCTION GetDependents(
    @ObjectName AS SYSNAME
)
RETURNS @result TABLE (
	Seq INT IDENTITY, 
	ObjectName SYSNAME, 
	Hierarchy VARCHAR(128))
AS
BEGIN
    ;WITH Obj AS (
        SELECT DISTINCT
            s.id  AS ParentID,
            s.DepID AS ObjectID,
            o1.Name AS ParentName,
            o2.Name AS ChildName,
            QUOTENAME(sch1.name) + '.' + QUOTENAME(o1.Name) 
			+ '(' + RTRIM(o1.type) + ')' 
                COLLATE SQL_Latin1_General_CP1_CI_AS 
			AS ParentObject, 
            QUOTENAME(sch2.name) + '.' + QUOTENAME(o2.Name) 
			+ '(' + RTRIM(o2.type) + ')' 
                COLLATE SQL_Latin1_General_CP1_CI_AS AS ObjectName
        FROM sys.sysdepends s
        INNER JOIN sys.all_objects o1 ON s.id = o1.object_id
        INNER JOIN sys.schemas sch1 ON sch1.schema_id = o1.schema_id
        INNER JOIN sys.all_objects o2 on s.DepID = o2.object_id
        INNER JOIN sys.schemas sch2 ON sch2.schema_id = o2.schema_id
    ), cte AS (
        SELECT 
            0 AS lvl, 
            ParentID,
            ObjectId,
            ParentObject,
            ObjectName,
            CAST(ObjectID AS VARBINARY(512)) AS Sort
        FROM obj WHERE ParentName = @ObjectName
        UNION ALL 
        SELECT
            p.lvl+ 1, 
            c.ParentID,
            c.ObjectId,
            c.ParentObject,
            c.ObjectName,
            CAST(p.sort + CAST(c.ObjectID AS VARBINARY(16)) 
		AS VARBINARY(512))
        FROM cte p 
        INNER JOIN obj c ON p.ObjectID = c.ParentID
    )
    INSERT INTO @result (ObjectName, Hierarchy)
    SELECT 
        ObjectName,
        '|-' + REPLICATE('-',(lvl * 4)) + ObjectName 
    FROM cte
    ORDER BY Sort
    
    RETURN 
END