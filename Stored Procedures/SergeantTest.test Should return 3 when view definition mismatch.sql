SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test Should return 3 when view definition mismatch]
AS
BEGIN

DECLARE @view VARCHAR(128)
DECLARE @col VARCHAR(128)
DECLARE @ret INT 

SELECT TOP 1 @view = t.TABLE_NAME, @col = c.COLUMN_NAME 
FROM INFORMATION_SCHEMA.TABLES AS t
INNER JOIN INFORMATION_SCHEMA.COLUMNS AS c ON c.TABLE_NAME = t.TABLE_NAME AND c.TABLE_SCHEMA = t.TABLE_SCHEMA
WHERE t.TABLE_TYPE = 'VIEW'
AND t.TABLE_SCHEMA = 'dbo'

DECLARE @def VARCHAR(max)
SELECT TOP 1 @def = REPLACE( REPLACE(OBJECT_DEFINITION(ao.object_id),'*', @col), 'CREATE VIEW', 'ALTER VIEW')
FROM sys.all_objects AS ao WHERE OBJECT_DEFINITION(ao.object_id) LIKE '%' + @view + '%' AND ao.type = 'V' AND OBJECT_DEFINITION(ao.object_id) LIKE '%*%'

IF @@ROWCOUNT = 0
	RETURN 0 --no view

EXEC (@def)

EXEC @ret = Sergeant.HashMatch
  

EXEC tSQLt.AssertEquals @Expected = 3, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'Procedure validation failed' -- nvarchar(max)



END;



GO
