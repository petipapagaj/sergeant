SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [SergeantTest].[setup] AS
BEGIN
SET NOCOUNT ON 

DECLARE @version VARCHAR(5) = '0.0.1'

EXEC Sergeant.CreateSchemaVersion @version = @version


RETURN 0
END





GO
