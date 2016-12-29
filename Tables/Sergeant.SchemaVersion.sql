CREATE TABLE [Sergeant].[SchemaVersion]
(
[Version] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Created] [datetime] NULL,
[SCH] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Sergeant].[SchemaVersion] ADD CONSTRAINT [PK_Version] PRIMARY KEY CLUSTERED  ([Version]) ON [PRIMARY]
GO
