SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Sergeant].[UpdateSchemaVersion]
    @version VARCHAR(10),
	@data XML = NULL OUTPUT
AS
SET NOCOUNT ON 
BEGIN 

IF @version IS NULL OR NOT EXISTS (SELECT 1 FROM Sergeant.SchemaVersion AS sv WHERE sv.Version = @version)
	RETURN -1 --invalid parameter

DECLARE @xml XML
DECLARE @ret INT 

EXEC @ret = Sergeant.GenerateXML @xml = @xml OUT

IF @ret <> 0
	RETURN @ret

UPDATE Sergeant.SchemaVersion
SET Created = GETDATE(),
	SCH = @xml
WHERE Version = @version

IF @@ROWCOUNT > 0
	SET @data = @xml

RETURN 0

END


GO
