CREATE proc [dbo].[setUp_dbMail_Plugin]
as
begin
exec(
'CREATE TABLE [dbo].[sys_tb_dbMailSource](
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[MailReason] [nvarchar](255) NULL,
	[sys_DateTimeAdd] [datetime] NOT NULL,
	[sys_DateTimeSent] [datetime] NOT NULL,
	[MailTo] [nvarchar](1000) NULL,
	[MailCC] [nvarchar](1000) NULL,
	[MailBCC] [nvarchar](1000) NULL,
	[MailBody] [nvarchar](max) NOT NULL,
	[MailSubject] [nvarchar](255) NULL,
	[MailBodyFormat] [nvarchar](50) NOT NULL,
	[DBMailProfile] [nvarchar](50) NULL,
	[MailAttachment] [nvarchar](max) NULL,
	[MailItemID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]')

exec('
ALTER TABLE [dbo].[sys_tb_dbMailSource] ADD  CONSTRAINT [DF_sys_tb_dbMailSource_sys_DateTimeAdd]  DEFAULT (getdate()) FOR [sys_DateTimeAdd]
')


exec('ALTER TABLE [dbo].[sys_tb_dbMailSource] ADD  CONSTRAINT [DF_sys_tb_dbMailSource_sys_DateTimeSent]  DEFAULT (''1900-01-01'') FOR [sys_DateTimeSent]')


exec('ALTER TABLE [dbo].[sys_tb_dbMailSource] ADD  CONSTRAINT [DF_sys_tb_dbMailSource_MailBody]  DEFAULT (''<header></header><body></body><footer></footer>'') FOR [MailBody]')


exec('ALTER TABLE [dbo].[sys_tb_dbMailSource] ADD  CONSTRAINT [DF_sys_tb_dbMailSource_MailBodyFormat]  DEFAULT (N''HTML'') FOR [MailBodyFormat]')


exec('EXEC sys.sp_addextendedproperty @name=N''MS_Description'', @value=N''description to be able to filter table by'' , @level0type=N''SCHEMA'',@level0name=N''dbo'', @level1type=N''TABLE'',@level1name=N''sys_tb_dbMailSource'', @level2type=N''COLUMN'',@level2name=N''MailReason''')


exec('
create TRIGGER [dbo].[zsik_trg_Archive_dbMailSource]
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
	where s.sys_DateTimeSent is not null and s.sys_DateTimeSent <> ''1900-01-01''

delete from sys_tb_dbMailSource
where RowID in (select a.RowID from sys_tb_dbMailSource_Archive a
				inner join inserted i
				on i.RowID = a.RowID)

    -- Insert statements for trigger here

END
')


exec('
CREATE TABLE [dbo].[sys_tb_dbMailSource_Archive](
	[RowID] [int] NULL,
	[MailReason] [nvarchar](255) NULL,
	[sys_DateTimeAdd] [datetime] NULL,
	[sys_DateTimeSent] [datetime] NULL,
	[MailTo] [nvarchar](1000) NULL,
	[MailCC] [nvarchar](1000) NULL,
	[MailBCC] [nvarchar](1000) NULL,
	[MailBody] [nvarchar](max) NULL,
	[MailSubject] [nvarchar](255) NULL,
	[MailBodyFormat] [nvarchar](50) NULL,
	[DBMailProfile] [nvarchar](50) NULL,
	[MailAttachment] [nvarchar](max) NULL,
	[MailItemID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
')




exec('
CREATE view [dbo].[sys_v_dbMailSource] as 
select * from sys_tb_dbMailSource
')



exec('
create view [dbo].[sys_v_sysmail_account]
as
select * from msdb.dbo.sysmail_account
')



exec('
create proc [dbo].[zsik_sp_SendDbMailReport]
@body nvarchar(max)
,@toline nvarchar(max)
,@ccline nvarchar(max)
,@bccline nvarchar(max)
,@profile_name nvarchar(max)
,@subject nvarchar(max)
,@bodyRender nvarchar(20)
,@attachement varchar(max)
,@MailItemID int output
as
begin
exec msdb.dbo.sp_send_dbmail 
		@profile_name = @profile_name
		,@Recipients = @toline
		,@copy_recipients = @ccline
		,@blind_copy_recipients = @bccline
		,@subject = @subject
		,@body = @body
		,@body_format = @bodyRender
		,@file_attachments = @attachement
		,@mailitem_id = @MailItemID OUTPUT

end
')



exec('
create proc [dbo].[sys_sp_dbMailSend] 
as
begin
	Declare @body nvarchar(max)
	Declare @toline nvarchar(max)
	Declare @ccline nvarchar(max)
	Declare @bccline nvarchar(max)
	Declare @profile_name nvarchar(max)
	Declare @subject nvarchar(max) 
	Declare @bodyRender nvarchar(20) = ''HTML''
	declare @attachment varchar(max)
	declare @MailItemID int

	declare mailCurs cursor for (select RowID from dbo.sys_v_dbMailSource)
	declare @rowID int

open mailCurs
	fetch next from mailCurs into @rowID
	while(@@FETCH_STATUS = 0)
	begin
		
		SELECT 
			@toline = MailTo
			,@ccline = isnull(MailCC,'''')
			,@bccline = isnull(MailBCC,'''')
			,@body = isnull(MailBody,'''')
			,@subject = isnull(MailSubject,''Mail Subject'')
			,@bodyRender = isnull(MailBodyFormat,''HTML'')
			,@profile_name = case when (isnull(DBMailProfile , '''') = '''')
				then (select ParameterValue from sys_tb_dbMailSetUp where ParamterName = ''DefaultMailProfile'')
				else DBMailProfile
				end
			,@attachment = isnull(MailAttachment,'''')
		FROM sys_v_dbMailSource
		WHERE (RowID = @rowID)
		
		exec zsik_sp_SendDbMailReport @body,@toline,@ccline,@bccline,@profile_name,@subject,@bodyRender,@attachment,@MailItemID OUTPUT

		update s
			set sys_DateTimeSent = getdate()
			,MailItemID = @MailItemID
		--select *
		from sys_v_dbMailSource s
		WHERE (RowID = @rowID)
		
		fetch next from mailCurs into @rowID
	end
close mailCurs
deallocate mailCurs

end
')



end