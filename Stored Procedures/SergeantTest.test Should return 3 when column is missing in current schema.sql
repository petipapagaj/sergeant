SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test Should return 3 when column is missing in current schema]
AS
BEGIN

DECLARE @sql VARCHAR(500)
DECLARE @ret INT 

SELECT @sql = 'ALTER TABLE dbo.' + c.TABLE_NAME + ' DROP COLUMN ' + c.COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS AS c
WHERE c.TABLE_SCHEMA = 'dbo'
AND NOT EXISTS (
				SELECT 1
				FROM sys.indexes AS i
				INNER JOIN sys.index_columns AS ic ON ic.index_id = i.index_id AND ic.object_id = i.object_id
				INNER JOIN sys.all_columns AS ac ON ac.column_id = ic.column_id AND ac.object_id = ic.object_id
				INNER JOIN sys.tables AS t ON i.Object_ID = t.Object_ID 
				WHERE i.type <> 0 AND t.name = c.TABLE_NAME AND ac.name = c.COLUMN_NAME)
AND NOT EXISTS (
				SELECT 1
				FROM sys.all_columns AS ac 
				INNER JOIN sys.default_constraints AS dc ON ac.default_object_id = dc.object_id
				INNER JOIN sys.tables AS t ON t.object_id = ac.object_id
				WHERE ac.name = c.COLUMN_NAME AND t.name = c.TABLE_NAME
)

AND NOT EXISTS (
				SELECT 1
				FROM sys.fulltext_index_columns AS fic 
				INNER JOIN sys.all_columns AS ac ON ac.column_id = fic.column_id AND ac.object_id = fic.object_id
				WHERE OBJECT_NAME(ac.object_id) = c.TABLE_NAME AND ac.name = c.COLUMN_NAME
)

EXEC (@sql)
  
EXEC @ret = Sergeant.HashMatch 

EXEC tSQLt.AssertEquals @Expected = 3, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Column drop validation failed' -- nvarchar(max)



END;






GO
