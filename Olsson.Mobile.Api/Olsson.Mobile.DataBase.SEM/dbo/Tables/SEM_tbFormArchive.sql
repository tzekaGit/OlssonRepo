CREATE TABLE [dbo].[SEM_tbFormArchive] (
    [ArchiveID]        INT           IDENTITY (1, 1) NOT NULL,
    [FormID]           INT           NOT NULL,
    [Audit_UpdateDate] DATETIME      NULL,
    [FormXML]          VARCHAR (MAX) NULL,
    CONSTRAINT [PK_SEM_tbFormArchive] PRIMARY KEY CLUSTERED ([ArchiveID] ASC)
);

