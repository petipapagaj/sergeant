SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test Should return 2 when index is missing in stored schema]
AS
BEGIN

DECLARE @sql VARCHAR(250)
DECLARE @ret INT 

SELECT TOP 1 @sql = 'CREATE NONCLUSTERED INDEX idx_dingdong ON dbo.' + c.TABLE_NAME + '(' + c.COLUMN_NAME + ')' 
FROM INFORMATION_SCHEMA.COLUMNS AS c
    INNER JOIN INFORMATION_SCHEMA.TABLES AS t ON c.TABLE_NAME = t.TABLE_NAME
WHERE c.TABLE_SCHEMA = 'dbo'
    AND t.TABLE_TYPE = 'BASE TABLE'

EXEC (@sql)

EXEC @ret = Sergeant.HashMatch

EXEC tSQLt.AssertEquals @Expected = 2, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Index validation failed' -- nvarchar(max)



END;




GO
