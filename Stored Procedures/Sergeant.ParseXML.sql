SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [Sergeant].[ParseXML] (@SCH XML)
AS
BEGIN
	SET NOCOUNT ON

	IF @SCH IS NULL 
		RETURN -1

	SELECT ca.tabs.value('@name', 'varchar(128)'),
				ca.tabs.value('Type[1]', 'varchar(128)'),
				ca.tabs.value('MD5[1]', 'varchar(128)')
	FROM @SCH.nodes('//object') ca (tabs)

RETURN 0

END

GO
