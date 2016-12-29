SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test Should return 2 when view is missing in stored schema]
AS
BEGIN

DECLARE @table VARCHAR(128)
DECLARE @ret INT

SELECT TOP 1 @table = t.TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES AS t
WHERE t.TABLE_SCHEMA = 'dbo' AND t.TABLE_TYPE = 'BASE TABLE'



EXEC ('CREATE VIEW dbo.dicsakbuksi AS SELECT * FROM dbo.' + @table)

EXEC @ret = Sergeant.HashMatch

EXEC tSQLt.AssertEquals @Expected = 2, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'View validation failed' -- nvarchar(max)

END;




GO
