CREATE TABLE [dbo].[zstbCode] (
    [ID]       UNIQUEIDENTIFIER CONSTRAINT [DF_zstbCode_ID] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [Title]    VARCHAR (100)    NOT NULL,
    [DateTime] DATETIME         NULL,
    [Code]     TEXT             NULL,
    CONSTRAINT [PK_zstbCode] PRIMARY KEY CLUSTERED ([ID] ASC)
);

