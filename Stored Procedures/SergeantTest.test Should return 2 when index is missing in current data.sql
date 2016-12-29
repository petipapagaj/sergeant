SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test Should return 2 when index is missing in current data]
AS
BEGIN

DECLARE @sql VARCHAR(250)
DECLARE @ret INT

SELECT TOP 1 @sql = 'DROP INDEX ' + i.name + ' ON ' + t.name
FROM sys.indexes AS i
INNER JOIN sys.index_columns AS ic ON ic.index_id = i.index_id AND ic.object_id = i.object_id
INNER JOIN sys.all_columns AS ac ON ac.column_id = ic.column_id AND ac.object_id = ic.object_id
INNER JOIN sys.tables AS t ON i.Object_ID = t.Object_ID 
INNER JOIN sys.schemas AS s  ON s.schema_id = t.schema_id 
WHERE s.name = 'dbo' AND i.type <> 0
ORDER BY t.Name, i.Name

EXEC (@sql)

EXEC @ret = Sergeant.HashMatch

EXEC tSQLt.AssertEquals @Expected = 2, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Index validation failed' -- nvarchar(max)



END;




GO
