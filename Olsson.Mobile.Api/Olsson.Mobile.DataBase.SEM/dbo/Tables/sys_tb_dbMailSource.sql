CREATE TABLE [dbo].[sys_tb_dbMailSource] (
    [RowID]            INT             IDENTITY (1, 1) NOT NULL,
    [MailReason]       NVARCHAR (255)  NULL,
    [sys_DateTimeAdd]  DATETIME        CONSTRAINT [DF_sys_tb_dbMailSource_sys_DateTimeAdd] DEFAULT (getdate()) NOT NULL,
    [sys_DateTimeSent] DATETIME        CONSTRAINT [DF_sys_tb_dbMailSource_sys_DateTimeSent] DEFAULT ('1900-01-01') NULL,
    [MailTo]           NVARCHAR (1000) NULL,
    [MailCC]           NVARCHAR (1000) NULL,
    [MailBCC]          NVARCHAR (1000) NULL,
    [MailBody]         NVARCHAR (MAX)  CONSTRAINT [DF_sys_tb_dbMailSource_MailBody] DEFAULT ('<header></header><body></body><footer></footer>') NOT NULL,
    [MailSubject]      NVARCHAR (255)  NULL,
    [MailBodyFormat]   NVARCHAR (50)   CONSTRAINT [DF_sys_tb_dbMailSource_MailBodyFormat] DEFAULT (N'HTML') NOT NULL,
    [DBMailProfile]    NVARCHAR (50)   NULL,
    [MailAttachment]   NVARCHAR (MAX)  NULL,
    [MailItemID]       INT             NULL,
    CONSTRAINT [PK_sys_tb_dbMailSource] PRIMARY KEY CLUSTERED ([RowID] ASC)
);


GO

CREATE TRIGGER [dbo].[zsik_trg_Archive_dbMailSource]
   ON [dbo].[sys_tb_dbMailSource]
   AFTER update
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

INSERT INTO sys_tb_dbMailSource_Archive
                         (RowID, MailReason, sys_DateTimeAdd, sys_DateTimeSent, MailTo, MailCC, MailBCC, MailBody, MailSubject, MailBodyFormat, DBMailProfile, MailAttachment,MailItemID)
SELECT        RowID, MailReason, sys_DateTimeAdd, sys_DateTimeSent, MailTo, MailCC, MailBCC, MailBody, MailSubject, MailBodyFormat, DBMailProfile, 
                         MailAttachment,MailItemID
FROM      inserted s
	where s.sys_DateTimeSent is not null and s.sys_DateTimeSent <> '1900-01-01'

delete from sys_tb_dbMailSource
where RowID in (select a.RowID from sys_tb_dbMailSource_Archive a
				inner join inserted i
				on i.RowID = a.RowID)

    -- Insert statements for trigger here

END