SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test should return 3 when column datasize mismatch]
AS
BEGIN
 

DECLARE @sql VARCHAR(128)
DECLARE @ret INT

SELECT TOP 1 @sql = 'ALTER TABLE dbo.' + c.TABLE_NAME + ' ALTER COLUMN ' + c.COLUMN_NAME + ' ' + c.DATA_TYPE + '(7654) ' 
+ CASE c.IS_NULLABLE WHEN 'YES' THEN 'NULL' WHEN 'NO' THEN 'NOT NULL' ELSE '' END
FROM INFORMATION_SCHEMA.COLUMNS AS c
WHERE c.TABLE_SCHEMA = 'dbo' AND c.DATA_TYPE = 'varchar' AND c.CHARACTER_MAXIMUM_LENGTH <> '-1'

IF @@ROWCOUNT = 0
	RETURN 0 --no varchar other than max in db

EXEC (@sql)


EXEC @ret = Sergeant.HashMatch


EXEC tSQLt.AssertEquals @Expected = 3, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Column def validation failed' -- nvarchar(max)

 



 
END;




GO
