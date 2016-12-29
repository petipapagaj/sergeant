SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test Should return 0 when creating new data version]
AS
BEGIN
SET NOCOUNT ON 

DECLARE @ret INT 
DECLARE @actual INT
DECLARE @version VARCHAR(5) = '0.1'

EXEC @ret = Sergeant.CreateSchemaVersion @version = @version -- varchar(10)

EXEC tSQLt.AssertEquals @Expected = 0, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Creation of new schema version failed' -- nvarchar(max)

SELECT @actual = COUNT(1) FROM Sergeant.SchemaVersion AS dv WHERE dv.Version = @version

EXEC tSQLt.AssertEquals @Expected = 1, -- sql_variant
    @Actual = @actual, -- sql_variant
    @Message = N'Schema version record is not in the table' -- nvarchar(max)

END;






GO
