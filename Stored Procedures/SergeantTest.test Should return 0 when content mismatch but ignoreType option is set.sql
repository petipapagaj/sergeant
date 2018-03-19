SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test Should return 0 when content mismatch but ignoreType option is set]
AS
BEGIN

DECLARE @drop VARCHAR(128)		
DECLARE @create VARCHAR(max)		
DECLARE @ret INT 

SELECT TOP 1 @drop = 'DROP PROCEDURE dbo.' + OBJECT_NAME(ao.object_id), @create = REPLACE(OBJECT_DEFINITION(ao.object_id), 'bigint', 'int')
FROM sys.all_objects ao
INNER JOIN sys.schemas AS s2 ON s2.schema_id = ao.schema_id
WHERE s2.name = 'dbo' AND ao.type = 'P'
AND EXISTS (SELECT 1 FROM sys.all_objects AS ao2 WHERE OBJECT_DEFINITION(ao.object_id) LIKE '%bigint%' AND ao.object_id = ao2.object_id)

IF @@ROWCOUNT = 0
	RETURN 0

EXEC (@drop)
EXEC (@create)

DECLARE @ignoreType dbo.VC128
INSERT INTO @ignoreType VALUES ('P'), ('PRM')

EXEC @ret = Sergeant.HashMatch @ignoreType = @ignoreType

EXEC tSQLt.AssertEquals @Expected = 0, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'ignoreType option validation failed' -- nvarchar(max)

END;



GO
