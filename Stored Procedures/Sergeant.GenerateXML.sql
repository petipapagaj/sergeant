SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Sergeant].[GenerateXML] (@xml XML OUTPUT)
AS
BEGIN 
SET NOCOUNT ON 

DECLARE @objects TABLE (Type CHAR(3), ObjectName VARCHAR(256), MD5 VARBINARY(128))
DECLARE @TVTVP TABLE (object_id INT, name VARCHAR(128), type CHAR(3))

--TYPE, VIEW, TVP DEFINITIONS
INSERT INTO @TVTVP ( object_id, name, type )
SELECT t.object_id, t.name, 'T'
FROM sys.tables t
INNER JOIN sys.schemas AS s ON t.schema_id = s.schema_id
WHERE s.name = 'dbo'
UNION ALL
SELECT t.object_id, t.name, 'VW'
FROM sys.views AS t
INNER JOIN sys.schemas AS s ON t.schema_id = s.schema_id
WHERE s.name = 'dbo'
UNION ALL 
SELECT tt.type_table_object_id, tt.name, 'TVP'
FROM sys.table_types AS tt
INNER JOIN sys.schemas AS s ON tt.schema_id = s.schema_id
WHERE s.name = 'dbo'


INSERT INTO @objects ( Type, ObjectName, MD5 )
SELECT t.type, t.name TableName, master.sys.fn_repl_hash_binary( CONVERT( VARBINARY(MAX), 
		' COLUMN:' + STUFF((SELECT ','+ac.name + ' | ' +CAST(ac.system_type_id AS VARCHAR(4)) + ' | ' + CAST(ac.max_length AS VARCHAR(5)) + ' | ' + CAST(ac.precision AS VARCHAR(5))
									+ ' | ' + CAST(ac.scale AS VARCHAR(5)) + ' | ' + CAST(ac.is_nullable AS VARCHAR(1)) + ' | ' + ISNULL(ac.collation_name,'NA') 
									+ ' | ' + ISNULL(dc.name,'NA') + ' | ' + ISNULL(dc.definition,'NA')
							FROM sys.all_columns AS ac 
							LEFT JOIN sys.default_constraints AS dc ON ac.default_object_id = dc.object_id
							WHERE ac.object_id = t.object_id
							ORDER BY ac.name
							FOR XML PATH('')
							), 1, 1, '')
		)) MD5
FROM @TVTVP AS t
ORDER BY t.name

--FUNCTIONS, STORED PROCEDURE
INSERT INTO @objects ( Type, ObjectName, MD5 )
SELECT ao.type, OBJECT_NAME(ao.object_id), master.sys.fn_repl_hash_binary( CONVERT( VARBINARY(MAX), OBJECT_DEFINITION(ao.object_id)))
FROM sys.all_objects AS ao
WHERE SCHEMA_NAME(ao.schema_id) = 'dbo'
AND ao.type IN ('FN', 'TF', 'IF', 'P')

--INDEXES (CLUSTERED,NONCLUSTERED)
INSERT INTO @objects ( Type, ObjectName, MD5 )
SELECT 'IDX', t.name +'.' + i.name, master.sys.fn_repl_hash_binary( CONVERT( VARBINARY(MAX), 
	STUFF((SELECT ', COL:' +ac.name + ' | ' + CAST(ic.key_ordinal AS VARCHAR(2)) + ' | ' + CAST(ic.is_descending_key AS VARCHAR(1)) + ' | ' + CAST(ic.is_included_column AS VARCHAR(1))
			FROM sys.index_columns AS ic 
			INNER JOIN sys.all_columns AS ac ON ac.column_id = ic.column_id AND ac.object_id = ic.object_id
			WHERE ic.index_id = i.index_id AND ic.object_id = i.object_id
			FOR XML PATH ('')
		) + ' ,IDX ' + CAST(i.is_primary_key AS VARCHAR(1)) + ' | ' + CAST(i.type AS VARCHAR(1)) ,1,1,'') ))
FROM sys.indexes AS i
INNER JOIN sys.tables AS t ON i.Object_ID = t.Object_ID 
INNER JOIN sys.schemas AS s  ON s.schema_id = t.schema_id 
WHERE s.name = 'dbo' AND i.type <> 0
ORDER BY t.Name, i.Name

--FULL-TEXT INDEXES
INSERT INTO @objects ( Type, ObjectName, MD5 )
SELECT 'FTI', OBJECT_NAME(fi.object_id), master.sys.fn_repl_hash_binary( CONVERT( VARBINARY(MAX), 
			STUFF ((
				SELECT ',' + ac.name
				FROM sys.fulltext_index_columns AS fic 
				INNER JOIN sys.all_columns AS ac ON ac.column_id = fic.column_id AND ac.object_id = fic.object_id
				WHERE fic.object_id = fi.object_id
				FOR XML PATH ('')
			),1,1,'')
		))
FROM sys.fulltext_indexes AS fi
ORDER BY OBJECT_NAME(fi.object_id)


SELECT @xml = (
SELECT o.ObjectName [@name], o.Type, o.MD5
FROM @objects AS o
ORDER BY o.Type, o.ObjectName
FOR XML PATH('object'), ROOT('objects'), ELEMENTS
)


RETURN 0

END
GO
