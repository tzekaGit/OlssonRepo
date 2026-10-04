CREATE TABLE [dbo].[tbFormDataElementImage] (
    [ID]                    UNIQUEIDENTIFIER CONSTRAINT [DF_tbFormImage_ID] DEFAULT (newid()) NOT NULL,
    [RowID]                 UNIQUEIDENTIFIER NOT NULL,
    [ImageName]             VARCHAR (100)    NOT NULL,
    [ImageFileName]         VARCHAR (100)    NULL,
    [ImageSource]           IMAGE            NULL,
    [DateCreated]           DATETIME         CONSTRAINT [DF_Table_1_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [DateUpdated]           DATETIME         NULL,
    [AdminDownloadDateTime] DATETIME         NULL,
    CONSTRAINT [PK_tbFormDataElementImage] PRIMARY KEY CLUSTERED ([ID] ASC)
);

