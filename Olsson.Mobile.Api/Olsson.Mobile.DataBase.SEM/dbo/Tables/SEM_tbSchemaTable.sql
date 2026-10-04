CREATE TABLE [dbo].[SEM_tbSchemaTable] (
    [TableID]          INT            IDENTITY (1, 1) NOT NULL,
    [TableName]        VARCHAR (50)   NOT NULL,
    [TableDescription] VARCHAR (2000) NULL,
    [TableType]        VARCHAR (50)   NULL,
    [TableStatus]      VARCHAR (50)   NULL,
    [TableCategory]    VARCHAR (50)   NULL,
    [Audit_AddDate]    DATETIME       NULL,
    [Audit_AddBy]      VARCHAR (50)   NULL,
    [Audit_UpdateDate] DATETIME       NULL,
    [Audit_UpdateBy]   VARCHAR (50)   NULL,
    CONSTRAINT [PK_vTable_tbTable] PRIMARY KEY CLUSTERED ([TableID] ASC)
);

