SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test should return 3 when column collation mismatch]
AS
BEGIN

DECLARE @sql VARCHAR(128)
DECLARE @ret INT


SELECT TOP 1 @sql = 'ALTER TABLE dbo.' + c.TABLE_NAME + ' ALTER COLUMN ' + c.COLUMN_NAME + ' ' + c.DATA_TYPE + '(' + REPLACE(c.CHARACTER_MAXIMUM_LENGTH, '-1', 'max') + ') COLLATE French_CI_AS ' 
+ CASE c.IS_NULLABLE WHEN 'YES' THEN 'NULL' WHEN 'NO' THEN 'NOT NULL' ELSE '' END
FROM INFORMATION_SCHEMA.COLUMNS AS c
WHERE c.TABLE_SCHEMA = 'dbo' AND c.COLLATION_NAME <> 'French_CI_AS' AND c.COLLATION_NAME IS NOT NULL 
AND NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu WHERE kcu.TABLE_NAME = c.TABLE_NAME AND kcu.COLUMN_NAME = c.COLUMN_NAME)
AND NOT EXISTS (
				SELECT 1
				FROM sys.indexes AS i
				INNER JOIN sys.index_columns AS ic ON ic.index_id = i.index_id AND ic.object_id = i.object_id
				INNER JOIN sys.all_columns AS ac ON ac.column_id = ic.column_id AND ac.object_id = ic.object_id
				INNER JOIN sys.tables AS t ON i.Object_ID = t.Object_ID 
				WHERE i.type <> 0 AND t.name = c.TABLE_NAME AND ac.name = c.COLUMN_NAME)
AND EXISTS (SELECT 1 FROM sys.columns AS c2 WHERE c2.is_computed = 0 AND c.COLUMN_NAME = c2.name)
ORDER BY c.COLUMN_NAME

IF @@ROWCOUNT = 0
	RETURN 0 --no this kind of collation

EXEC (@sql)

EXEC @ret = Sergeant.HashMatch

EXEC tSQLt.AssertEquals @Expected = 3, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Column def validation failed' -- nvarchar(max)


  
END;









GO
