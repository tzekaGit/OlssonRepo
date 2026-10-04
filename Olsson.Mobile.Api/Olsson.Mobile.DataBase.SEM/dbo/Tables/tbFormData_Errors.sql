CREATE TABLE [dbo].[tbFormData_Errors] (
    [RowId]          UNIQUEIDENTIFIER NOT NULL,
    [TrxID]          UNIQUEIDENTIFIER NOT NULL,
    [ValidationType] VARCHAR (100)    NULL,
    [FieldName]      VARCHAR (100)    NULL,
    [ErrorMsg]       VARCHAR (MAX)    NULL,
    [MinLength]      INT              NULL,
    [MaxLength]      INT              NULL,
    CONSTRAINT [PK_tbFormData_Errors] PRIMARY KEY CLUSTERED ([RowId] ASC)
);

