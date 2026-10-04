CREATE TABLE [dbo].[tbFormDataElementImageAnnotation] (
    [ID]          UNIQUEIDENTIFIER CONSTRAINT [DF_tbFormAntImage_ID] DEFAULT (newid()) NOT NULL,
    [RowID]       UNIQUEIDENTIFIER NOT NULL,
    [SequenceID]  INT              NOT NULL,
    [xPos]        FLOAT (53)       NULL,
    [yPos]        FLOAT (53)       NULL,
    [Title]       VARCHAR (250)    NULL,
    [Description] VARCHAR (500)    NULL,
    [Shape]       VARCHAR (50)     NULL,
    [Color]       VARCHAR (50)     NULL,
    [Size]        VARCHAR (50)     NULL,
    [ImageName]   VARCHAR (50)     NULL,
    [Source]      IMAGE            NULL,
    CONSTRAINT [PK_tbFormDataElementAnnotatableImage] PRIMARY KEY CLUSTERED ([ID] ASC)
);

