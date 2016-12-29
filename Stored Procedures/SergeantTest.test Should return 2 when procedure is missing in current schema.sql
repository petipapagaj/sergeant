SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test Should return 2 when procedure is missing in current schema]
AS
BEGIN

DECLARE @sql VARCHAR(500)
DECLARE @ret INT 

SELECT @sql = 'DROP PROCEDURE dbo.'+ ao.name 
FROM sys.all_objects AS ao
INNER JOIN sys.schemas AS s ON s.schema_id = ao.schema_id
WHERE ao.type = 'P' AND s.name = 'dbo'

IF @@ROWCOUNT = 0
	RETURN 0 -- no sp

EXEC (@sql)
  
EXEC @ret = Sergeant.HashMatch 

EXEC tSQLt.AssertEquals @Expected = 2, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Procedure validation failed' -- nvarchar(max)



END;


GO
