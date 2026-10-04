CREATE TABLE [dbo].[SYS_tbElementAudit] (
    [RowId]         UNIQUEIDENTIFIER CONSTRAINT [DF_SYS_tbElementAudit_RowId] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [Element_RowId] VARCHAR (1000)   NOT NULL,
    [DateChanged]   DATETIME         NOT NULL,
    [OldValue]      VARCHAR (4000)   NULL,
    CONSTRAINT [PK_SYS_tbElementAudit] PRIMARY KEY CLUSTERED ([RowId] ASC)
);

