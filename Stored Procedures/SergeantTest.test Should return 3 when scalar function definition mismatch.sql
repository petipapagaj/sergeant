SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test Should return 3 when scalar function definition mismatch]
AS
BEGIN

DECLARE @drop VARCHAR(128)		
DECLARE @create VARCHAR(max)		
DECLARE @ret INT 

SELECT TOP 1 @drop = 'DROP FUNCTION dbo.' + OBJECT_NAME(ao.object_id), @create = REPLACE(OBJECT_DEFINITION(ao.object_id), 'bigint', 'int') 
FROM sys.all_objects ao
INNER JOIN sys.schemas AS s2 ON s2.schema_id = ao.schema_id
WHERE s2.name = 'dbo' AND ao.type = 'FN'
AND EXISTS (SELECT 1 FROM sys.all_objects AS ao2 WHERE OBJECT_DEFINITION(ao.object_id) LIKE '%bigint%' AND ao.object_id = ao2.object_id)

IF @@ROWCOUNT = 0
	RETURN 0

EXEC (@drop)
EXEC (@create)

EXEC @ret = Sergeant.HashMatch

EXEC tSQLt.AssertEquals @Expected = 3, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Function validation failed' -- nvarchar(max)


  
END;


GO
