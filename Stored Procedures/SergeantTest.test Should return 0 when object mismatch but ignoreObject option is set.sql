SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test Should return 0 when object mismatch but ignoreObject option is set]
AS
BEGIN

DECLARE @sql VARCHAR(500)
DECLARE @ret INT 
DECLARE @function VARCHAR(128)

SELECT @sql = 'DROP FUNCTION dbo.'+ ao.name, @function = ao.name 
FROM sys.all_objects AS ao
INNER JOIN sys.schemas AS s ON s.schema_id = ao.schema_id
WHERE ao.type = 'FN' AND s.name = 'dbo'

IF @@ROWCOUNT = 0
	RETURN 0 --no function

EXEC (@sql)

DECLARE @ignoreObject dbo.VC128
INSERT INTO @ignoreObject VALUES (@function)

EXEC @ret = Sergeant.HashMatch @ignoreObject = @ignoreObject

EXEC tSQLt.AssertEquals @Expected = 0, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'ignoreObject option validation failed' -- nvarchar(max)

  
END;



GO
