SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test should return 3 when default constraint definition mismatch]
AS
BEGIN


DECLARE @sql VARCHAR(500)
DECLARE @ret INT

SELECT TOP 1 @sql = 'ALTER TABLE dbo.' + t.name + ' DROP CONSTRAINT ['+ dc.name + ']' 
		+ ' ALTER TABLE dbo.' + t.name + ' ADD CONSTRAINT [' + dc.name + '] DEFAULT ' 
						+ REPLACE(dc.definition, 0, 1) + ' FOR ' + ac.name
FROM sys.all_columns AS ac 
INNER JOIN sys.default_constraints AS dc ON ac.default_object_id = dc.object_id
INNER JOIN sys.tables AS t ON t.object_id = ac.object_id
WHERE dc.definition LIKE '%0%'


IF @@ROWCOUNT = 0
	RETURN 0 --no this kind of default

EXEC (@sql)

EXEC @ret = Sergeant.HashMatch

EXEC tSQLt.AssertEquals @Expected = 3, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Default constraint def validation failed' -- nvarchar(max)


  

END;




GO
