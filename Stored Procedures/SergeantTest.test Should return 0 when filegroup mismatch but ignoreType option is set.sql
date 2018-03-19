SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [SergeantTest].[test Should return 0 when filegroup mismatch but ignoreType option is set]
AS
BEGIN

DECLARE @sql VARCHAR(500)
DECLARE @ret INT 
DECLARE @fg VARCHAR(128)

SELECT TOP 1 @sql = 'DROP INDEX ' + i.name + ' ON dbo.' + t.name + ' CREATE NONCLUSTERED INDEX ' + i.name + ' ON dbo.' + t.name + ' ('+ c.name + ')', @fg = f.name
FROM sys.indexes AS i
INNER JOIN sys.index_columns AS ic ON ic.index_id = i.index_id AND ic.object_id = i.object_id
INNER JOIN sys.columns AS c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
INNER JOIN sys.tables AS t ON i.object_id = t.object_id
INNER JOIN sys.schemas AS s  ON s.schema_id = t.schema_id 
INNER JOIN sys.filegroups AS f ON i.data_space_id = f.data_space_id
WHERE s.name = 'dbo' AND i.type = 2
AND i.name NOT IN (
				SELECT DISTINCT i.name
				FROM sys.indexes AS i
				INNER JOIN sys.index_columns AS ic ON ic.index_id = i.index_id AND ic.object_id = i.object_id
				INNER JOIN sys.tables AS t ON i.Object_ID = t.Object_ID 
				INNER JOIN sys.schemas AS s  ON s.schema_id = t.schema_id 
				WHERE ic.key_ordinal = 2 AND s.name = 'dbo'
)
ORDER BY t.Name, i.Name

IF @@ROWCOUNT = 0
	EXEC tSQLt.Fail @Message0 = N'wrong test implementation' -- nvarchar(max)

SELECT TOP 1 @fg = f.name FROM sys.filegroups AS f WHERE f.name <> @fg

SET @sql += ' ON ' + @fg

EXEC (@sql)

DECLARE @type VC128

INSERT INTO @type ( String ) VALUES ( 'FG' )

EXEC @ret = Sergeant.HashMatch @ignoreType = @type

EXEC tSQLt.AssertEquals @Expected = 0, -- sql_variant
    @Actual = @ret, -- sql_variant
    @Message = N'filegroup validation failed' -- nvarchar(max)

END;


GO
