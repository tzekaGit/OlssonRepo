CREATE TABLE [dbo].[SYS_tbHelp] (
    [HelpID]         UNIQUEIDENTIFIER CONSTRAINT [DF_SYS_tbHelp_HelpID] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [HelpFormName]   VARCHAR (100)    NOT NULL,
    [HelpText]       VARCHAR (4000)   NOT NULL,
    [HelpTitle]      VARCHAR (100)    NULL,
    [HelpAttachment] VARCHAR (250)    NULL,
    CONSTRAINT [PK_SYS_tbHelp] PRIMARY KEY CLUSTERED ([HelpID] ASC)
);

