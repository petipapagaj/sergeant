SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test Should return 0 when brackets is the only difference]
AS
BEGIN
 


DECLARE @drop VARCHAR(128)		
DECLARE @create VARCHAR(max)		
DECLARE @ret INT 

SELECT TOP 1 @drop = 'DROP PROCEDURE dbo.' + OBJECT_NAME(ao.object_id), @create = REPLACE(REPLACE(OBJECT_DEFINITION(ao.object_id), '[', ''), ']','' )
FROM sys.all_objects ao
INNER JOIN sys.schemas AS s2 ON s2.schema_id = ao.schema_id
WHERE s2.name = 'dbo' AND ao.type = 'P'
AND OBJECT_DEFINITION(ao.object_id) LIKE '%\[dbo%'  ESCAPE '\'

IF @@ROWCOUNT = 0
	RETURN 0

EXEC (@drop)
EXEC (@create)

EXEC @ret = Sergeant.HashMatch

EXEC tSQLt.AssertEquals @Expected = 0, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'SP validation failed' -- nvarchar(max)
  
END;


GO
