
CREATE proc [dbo].[zsik_sp_SendDbMailReport]
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

--declare @ret int

-- exec msdb.dbo.sp_send_dbmail 
--	@profile_name = 'SikichDev'
--		,@Recipients = 'cobrien@sikich.com'
--		,@subject = 'Test Sub'
--		,@body = 'Test bod'
--		,@mailitem_id = @ret OUTPUT
--select @ret