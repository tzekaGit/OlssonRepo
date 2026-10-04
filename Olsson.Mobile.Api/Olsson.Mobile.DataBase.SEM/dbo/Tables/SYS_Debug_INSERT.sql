CREATE TABLE [dbo].[SYS_Debug_INSERT] (
    [ParentRowId]    UNIQUEIDENTIFIER NULL,
    [UserId]         UNIQUEIDENTIFIER NULL,
    [FormId]         INT              NULL,
    [TrxId]          UNIQUEIDENTIFIER NULL,
    [SubmitDocument] INT              NULL,
    [dateEntered]    DATETIME         NULL,
    [note]           VARCHAR (500)    NULL,
    [documentID]     VARCHAR (100)    NULL
);

