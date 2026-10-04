
CREATE proc [dbo].[sys_sp_dbMailSend] 
as
begin
	Declare @body nvarchar(max)
	Declare @toline nvarchar(max)
	Declare @ccline nvarchar(max)
	Declare @bccline nvarchar(max)
	Declare @profile_name nvarchar(max)
	Declare @subject nvarchar(max) 
	Declare @bodyRender nvarchar(20) = 'HTML'
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
			,@ccline = isnull(MailCC,'')
			,@bccline = isnull(MailBCC,'')
			,@body = isnull(MailBody,'')
			,@subject = isnull(MailSubject,'Mail Subject')
			,@bodyRender = isnull(MailBodyFormat,'HTML')
			,@profile_name = case when (isnull(DBMailProfile , '') = '')
				then (select ParameterValue from sys_tb_dbMailSetUp where ParamterName = 'DefaultMailProfile')
				else DBMailProfile
				end
			,@attachment = isnull(MailAttachment,'')
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