SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test Should be valid xml when generating xml data]
AS
BEGIN
SET NOCOUNT ON 

	DECLARE @ret INT 
	DECLARE @xml XML
	DECLARE @data TABLE (xml xml)
	DECLARE @actual INT

	EXEC @ret = Sergeant.GenerateXML @xml = @xml OUTPUT
    

	EXEC tSQLt.AssertEquals @Expected = 0, -- sql_variant
	    @Actual = @ret, -- sql_variant
	    @Message = N'Generate xml data failed' -- nvarchar(max)


	INSERT INTO @data ( xml ) VALUES  ( @xml )

	SELECT @actual = COUNT(1) FROM @data AS d

	EXEC tSQLt.AssertEquals @Expected = 1, -- sql_variant
	    @Actual = @actual, -- sql_variant
	    @Message = N'Not valid xml data generated' -- nvarchar(max)
	


END;
GO
