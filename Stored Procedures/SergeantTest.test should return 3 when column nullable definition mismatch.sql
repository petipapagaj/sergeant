SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test should return 3 when column nullable definition mismatch]
AS
BEGIN


DECLARE @sql VARCHAR(128)
DECLARE @ret INT

SELECT TOP 1 @sql = 'ALTER TABLE dbo.' + c.TABLE_NAME + ' ALTER COLUMN ' + c.COLUMN_NAME + ' ' + c.DATA_TYPE + ' NULL '
FROM INFORMATION_SCHEMA.COLUMNS AS c
INNER JOIN INFORMATION_SCHEMA.TABLES AS t ON c.TABLE_NAME = t.TABLE_NAME
WHERE c.TABLE_SCHEMA = 'dbo' AND c.IS_NULLABLE = 'NO' AND c.DATA_TYPE IN ('int', 'bigint', 'tinyint', 'smallint')
AND NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu WHERE kcu.COLUMN_NAME = c.COLUMN_NAME)
AND t.TABLE_TYPE = 'BASE TABLE'

IF @@ROWCOUNT = 0
	RETURN 0 --no that kind of column in db

EXEC (@sql)


EXEC @ret = Sergeant.HashMatch


EXEC tSQLt.AssertEquals @Expected = 3, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Column def validation failed' -- nvarchar(max)

 
  
END;




GO
