SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Sergeant].[HashMatch] (@version VARCHAR(10) = NULL, @showObjects BIT = 0)

AS
SET NOCOUNT ON

BEGIN

DECLARE @CurrentXML XML
DECLARE @StoredXML XML
DECLARE @diff INT = 0
--DECLARE @ret INT = 0

SELECT TOP 1 @StoredXML = sv.SCH 
FROM Sergeant.SchemaVersion AS sv
WHERE @version IS NULL OR sv.Version = @version
ORDER BY sv.Created DESC

IF @@ROWCOUNT = 0
	RETURN 1 --invalid parameter


EXEC Sergeant.GenerateXML @xml = @CurrentXML OUT

IF @CurrentXML IS NULL
	RETURN 99 --system failure


DECLARE @CurrentData Sergeant.HashVersion
DECLARE @StoredData Sergeant.HashVersion


INSERT INTO @StoredData (ObjectName, Type, md5)
EXEC Sergeant.ParseXML @StoredXML

INSERT INTO @CurrentData (ObjectName, Type, md5)
EXEC Sergeant.ParseXML @CurrentXML

DECLARE @objects TABLE (Object VARCHAR(256))

INSERT INTO @objects ( Object )
SELECT ISNULL(cd.ObjectName, sd.ObjectName) 
FROM @CurrentData AS cd
FULL OUTER JOIN @StoredData AS sd ON sd.ObjectName = cd.ObjectName AND sd.Type = cd.Type
WHERE cd.ObjectName IS NULL OR sd.ObjectName IS NULL


IF @@ROWCOUNT > 0
BEGIN
	IF @showObjects = 1
		SELECT DISTINCT o.Object FROM @objects AS o
	
	RETURN 2 --object mismatch
END


    
INSERT INTO @objects ( Object )
SELECT ISNULL(cd.ObjectName, sd.ObjectName) 
FROM @CurrentData AS cd
FULL OUTER JOIN @StoredData AS sd ON cd.ObjectName = sd.ObjectName AND cd.Type = sd.Type AND cd.md5 = sd.md5
WHERE cd.md5 IS NULL OR sd.md5 IS NULL 


IF @@ROWCOUNT > 0
BEGIN 
	IF @showObjects = 1
		SELECT DISTINCT o.Object FROM @objects AS o

	RETURN 3 --schema mismatch
END


RETURN 0

END



GO
