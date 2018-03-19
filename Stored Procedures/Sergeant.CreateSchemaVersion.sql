SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Sergeant].[CreateSchemaVersion] (@version VARCHAR(10), @sha1 VARCHAR(128), @data XML = NULL OUTPUT)
AS
SET NOCOUNT ON

BEGIN 

IF @version IS NULL OR @sha1 IS NULL
	RETURN -1 --invalid parameter

IF EXISTS (SELECT 1 FROM Sergeant.SchemaVersion AS sv WHERE sv.Version = @version OR sv.GitReference = @sha1)
	RETURN 88 --version already created

DECLARE @xml XML
DECLARE @ret INT 

EXEC @ret = Sergeant.GenerateXML @xml = @xml OUT

IF @ret <> 0
	RETURN @ret

INSERT INTO Sergeant.SchemaVersion ( Version, GitReference, Created, SCH )
VALUES (@version, @sha1, GETUTCDATE(), @xml)

IF @@ROWCOUNT > 0
	SET @data = @xml

RETURN 0

END 



GO
