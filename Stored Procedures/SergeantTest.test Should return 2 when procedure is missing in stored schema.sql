SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test Should return 2 when procedure is missing in stored schema]
AS
BEGIN

DECLARE @sql VARCHAR(500) = 'CREATE PROCEDURE dbo.ohmyprocedure (@var int) AS BEGIN RETURN 1 END '
DECLARE @ret INT

EXEC (@sql)

EXEC @ret = Sergeant.HashMatch

EXEC tSQLt.AssertEquals @Expected = 2, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Procedure validation failed' -- nvarchar(max)



END;
GO
