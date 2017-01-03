SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test Should return 88 when schema version is already created]
AS
BEGIN

DECLARE @version VARCHAR(10) = '0.0.1'
DECLARE @sha1 VARCHAR(128) = '684sdfg684268dfa6846'
DECLARE @ret INT 

EXEC @ret = Sergeant.CreateSchemaVersion @version = @version, @sha1 = 'notexist' 

EXEC tSQLt.AssertEquals @Expected = 88, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'existence validation failed version' -- nvarchar(max)

SET @ret = 0 

EXEC @ret = Sergeant.CreateSchemaVersion @version = '10.65448', @sha1 = @sha1 

EXEC tSQLt.AssertEquals @Expected = 88, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'existence validation failed sha1' -- nvarchar(max)

  
END;


GO
