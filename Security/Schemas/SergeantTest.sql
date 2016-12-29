CREATE SCHEMA [SergeantTest]
AUTHORIZATION [dbo]
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'tSQLt.TestClass', @xp, 'SCHEMA', N'SergeantTest', NULL, NULL, NULL, NULL
GO
