CREATE TABLE [dbo].[SEM_tbFileAttachment] (
    [AttachID]          UNIQUEIDENTIFIER CONSTRAINT [DF_CEM_tbFileAttachment_AttachID] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [ObjType]           VARCHAR (50)     NOT NULL,
    [ObjID]             VARCHAR (50)     NOT NULL,
    [FileName]          VARCHAR (100)    NULL,
    [FileRootDirectory] VARCHAR (1000)   NULL,
    [FileSystemFolder]  VARCHAR (250)    NULL,
    [FileFullPath]      VARCHAR (1000)   NULL,
    [FileTitle]         VARCHAR (100)    NULL,
    [FileDescription]   VARCHAR (250)    NULL,
    [FileActive]        INT              NULL,
    [Audit_AddDate]     DATETIME         NULL,
    [Audit_AddBy]       VARCHAR (50)     NULL,
    [Audit_UpdateDate]  DATETIME         NULL,
    [Audit_UpdateBy]    VARCHAR (50)     NULL,
    CONSTRAINT [PK_CEM_tbFileAttachment] PRIMARY KEY CLUSTERED ([AttachID] ASC)
);

