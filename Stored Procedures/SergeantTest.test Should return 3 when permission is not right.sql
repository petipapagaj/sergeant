SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test Should return 3 when permission is not right]
AS
BEGIN

DECLARE @proc VARCHAR(128)
DECLARE @ret INT

SELECT TOP 1 @proc = p.name
FROM sys.procedures AS p
INNER JOIN sys.database_permissions dp ON p.name = OBJECT_NAME(dp.major_id) AND OBJECT_NAME(dp.major_id) IS NOT NULL 
WHERE p.schema_id = SCHEMA_ID('dbo') AND dp.state_desc = 'GRANT' AND dp.permission_name = 'EXECUTE'

EXEC ('DENY EXECUTE ON dbo.' + @proc + ' TO public')


EXEC @ret = Sergeant.HashMatch

EXEC tSQLt.AssertEquals @Expected = 3, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Permission validation failed' -- nvarchar(max)  

END;


GO
