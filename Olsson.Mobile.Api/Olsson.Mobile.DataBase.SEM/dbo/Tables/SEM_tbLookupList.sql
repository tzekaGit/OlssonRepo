CREATE TABLE [dbo].[SEM_tbLookupList] (
    [RowId]     INT           IDENTITY (1, 1) NOT NULL,
    [ListName]  VARCHAR (50)  NOT NULL,
    [ListValue] VARCHAR (200) NOT NULL,
    [ListSort]  VARCHAR (50)  NULL,
    CONSTRAINT [PK_SEM_tbLookuList] PRIMARY KEY CLUSTERED ([RowId] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_SEM_tbLookupList]
    ON [dbo].[SEM_tbLookupList]([ListName] ASC, [ListValue] ASC);

