CREATE TABLE [dbo].[SEM_tbForm] (
    [FormID]            INT           NOT NULL,
    [FormName]          VARCHAR (100) NOT NULL,
    [FormStatus]        VARCHAR (50)  NOT NULL,
    [Audit_AddDate]     DATETIME      NULL,
    [Audit_AddBy]       VARCHAR (50)  NULL,
    [Audit_UpdateDate]  DATETIME      NULL,
    [Audit_UpdateBy]    VARCHAR (50)  NULL,
    [FormXML]           VARCHAR (MAX) NULL,
    [FormState]         VARCHAR (50)  NULL,
    [EmailOnStatus]     VARCHAR (50)  NULL,
    [EmailTo]           VARCHAR (200) NULL,
    [EmailCC]           VARCHAR (200) NULL,
    [EmailTemplateCode] VARCHAR (25)  NULL,
    [DataDefaultState]  VARCHAR (50)  NULL,
    CONSTRAINT [PK_SEM_tbForm] PRIMARY KEY CLUSTERED ([FormID] ASC)
);

