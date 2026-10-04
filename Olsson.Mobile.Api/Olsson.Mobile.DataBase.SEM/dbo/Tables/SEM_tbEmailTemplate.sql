CREATE TABLE [dbo].[SEM_tbEmailTemplate] (
    [EmailTemplateCode] VARCHAR (25)   NOT NULL,
    [EmailTemplateName] VARCHAR (100)  NULL,
    [EmailBodyPrefix]   VARCHAR (4000) NULL,
    [EmailBodySuffix]   VARCHAR (4000) NULL,
    CONSTRAINT [PK_SEM_tbEmailTemplate] PRIMARY KEY CLUSTERED ([EmailTemplateCode] ASC)
);

