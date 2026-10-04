CREATE TABLE [dbo].[SEM_tbSchemaTableField] (
    [FieldID]                     INT            IDENTITY (1, 1) NOT NULL,
    [FieldTableID]                INT            NOT NULL,
    [FieldPos]                    VARCHAR (50)   NULL,
    [FieldName]                   VARCHAR (100)  NOT NULL,
    [FieldCaption]                VARCHAR (100)  NOT NULL,
    [FieldRequired]               INT            CONSTRAINT [DF_vTable_tbTableField_vField_Required] DEFAULT ((0)) NULL,
    [FieldType]                   VARCHAR (50)   NOT NULL,
    [FieldSize]                   VARCHAR (50)   NULL,
    [FieldDecimal]                DECIMAL (18)   NULL,
    [FieldLookUpType]             VARCHAR (50)   NULL,
    [FieldLookUpCustom]           VARCHAR (4000) NULL,
    [FieldLookUpListCode]         VARCHAR (100)  NULL,
    [FieldLookupAllowMultiSelect] INT            CONSTRAINT [DF_vTable_tbTableField_vField_LookupAllowMultiSelect] DEFAULT ((0)) NULL,
    [Audit_AddDate]               DATETIME       NULL,
    [Audit_AddBy]                 VARCHAR (50)   NULL,
    [Audit_UpdateDate]            DATETIME       NULL,
    [Audit_UpdateBy]              VARCHAR (50)   NULL,
    CONSTRAINT [PK_vTable_tbTableField] PRIMARY KEY CLUSTERED ([FieldID] ASC),
    CONSTRAINT [FK_vTable_tbTableField_vTable_tbTable] FOREIGN KEY ([FieldTableID]) REFERENCES [dbo].[SEM_tbSchemaTable] ([TableID])
);

