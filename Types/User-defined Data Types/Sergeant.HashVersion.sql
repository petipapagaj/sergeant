CREATE TYPE [Sergeant].[HashVersion] AS TABLE
(
[ObjectName] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Type] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[md5] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
