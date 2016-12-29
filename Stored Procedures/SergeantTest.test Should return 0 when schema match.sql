SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test Should return 0 when schema match]
AS
BEGIN
SET NOCOUNT ON 

DECLARE @ret INT
DECLARE @actual INT = (SELECT COUNT(1) FROM Sergeant.SchemaVersion AS dv WHERE dv.Version = '0.0.1')

EXEC tSQLt.AssertEquals @Expected = 1, -- sql_variant
    @Actual = @actual, -- sql_variant
    @Message = N'Schema did not created in setup sp' -- nvarchar(max)


EXEC @ret = Sergeant.HashMatch


EXEC tSQLt.AssertEquals @Expected = 0, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Schema does not match' -- nvarchar(max)
 

END;








GO
