SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test Should return 0 when objects with special prefix does not match]
AS
BEGIN

DECLARE @ret INT 
DECLARE @exception dbo.VC128

INSERT INTO @exception VALUES ('deleted_'),('tmp_')


CREATE TABLE dbo.deleted_whatever (id INT)

EXEC @ret = Sergeant.HashMatch @exception = @exception 

EXEC tSQLt.AssertEquals @Expected = 0, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'exception validation failed' -- nvarchar(max)



END;



GO
