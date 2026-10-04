CREATE TABLE [dbo].[tb_FormProperties] (
    [PropertyID]    INT           IDENTITY (1, 1) NOT NULL,
    [Name]          VARCHAR (100) NOT NULL,
    [Description]   VARCHAR (100) NULL,
    [Type]          VARCHAR (100) NULL,
    [DefaultValue1] VARCHAR (100) NULL,
    [DefaultValue2] VARCHAR (100) NULL
);

