SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test Should return 3 when column is missing in stored schema]
AS
BEGIN

DECLARE @sql VARCHAR(200)
DECLARE @ret INT 

SELECT TOP 1 @sql = 'ALTER TABLE dbo.' + t.TABLE_NAME + ' ADD veryNiceTestColumn BIT NULL ' 
FROM INFORMATION_SCHEMA.TABLES AS t
WHERE t.TABLE_SCHEMA = 'dbo' AND t.TABLE_TYPE = 'BASE TABLE'

EXEC (@sql)

EXEC @ret = Sergeant.HashMatch

EXEC tSQLt.AssertEquals @Expected = 3, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Column definition does not match' -- nvarchar(max)

END;




GO
