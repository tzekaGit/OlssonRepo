CREATE TABLE [dbo].[sys_tb_dbMailSource_Archive] (
    [RowID]            INT             NULL,
    [MailReason]       NVARCHAR (255)  NULL,
    [sys_DateTimeAdd]  DATETIME        NULL,
    [sys_DateTimeSent] DATETIME        NULL,
    [MailTo]           NVARCHAR (1000) NULL,
    [MailCC]           NVARCHAR (1000) NULL,
    [MailBCC]          NVARCHAR (1000) NULL,
    [MailBody]         NVARCHAR (MAX)  NULL,
    [MailSubject]      NVARCHAR (255)  NULL,
    [MailBodyFormat]   NVARCHAR (50)   NULL,
    [DBMailProfile]    NVARCHAR (50)   NULL,
    [MailAttachment]   NVARCHAR (MAX)  NULL,
    [MailItemID]       INT             NULL
);

