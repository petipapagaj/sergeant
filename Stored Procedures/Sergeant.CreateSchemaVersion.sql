SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Sergeant].[CreateSchemaVersion] (@version VARCHAR(10))
AS
SET NOCOUNT ON

BEGIN 

IF @version IS NULL OR EXISTS (SELECT 1 FROM Sergeant.SchemaVersion AS sv WHERE sv.Version = @version)
	RETURN 1 --invalid parameter

DECLARE @xml XML
DECLARE @ret INT 

EXEC @ret = Sergeant.GenerateXML @xml = @xml OUT

IF @ret <> 0
	RETURN @ret

INSERT INTO Sergeant.SchemaVersion ( Version, Created, SCH )
VALUES (@version, GETUTCDATE(), @xml)

RETURN 0

END 
GO
