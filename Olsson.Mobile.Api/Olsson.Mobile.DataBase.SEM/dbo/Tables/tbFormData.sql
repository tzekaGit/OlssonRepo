CREATE TABLE [dbo].[tbFormData] (
    [RowId]                     UNIQUEIDENTIFIER NOT NULL,
    [FormID]                    INT              NULL,
    [UserID]                    UNIQUEIDENTIFIER NULL,
    [DocumentId]                VARCHAR (100)    NOT NULL,
    [DocumentType]              VARCHAR (100)    NOT NULL,
    [DocumentTitle]             VARCHAR (1000)   NOT NULL,
    [DocumentStatus]            VARCHAR (50)     NULL,
    [Audit_AddDate]             DATETIME         NULL,
    [Audit_AddBy]               VARCHAR (50)     NULL,
    [Audit_UpdateDate]          DATETIME         NULL,
    [Audit_UpdateBy]            VARCHAR (50)     NULL,
    [AdminStatus]               VARCHAR (50)     NULL,
    [AdminMessage]              VARCHAR (1000)   NULL,
    [AdminDownloadDateTime]     DATETIME         NULL,
    [AdminNotificationDateTime] DATETIME         NULL,
    CONSTRAINT [PK_tb_FormData_1] PRIMARY KEY CLUSTERED ([RowId] ASC)
);


GO
CREATE TRIGGER [dbo].[SK_tgtbFormData_DELETE]
    ON [dbo].[tbFormData]
    FOR DELETE
    AS
    BEGIN
	DELETE FROM tbFormDataElementImage
	FROM  Deleted INNER JOIN
         tbFormDataElement ON Deleted.RowId = tbFormDataElement.ParentRowId INNER JOIN
         tbFormDataElementImage ON tbFormDataElement.RowId = tbFormDataElementImage.RowID

	DELETE FROM tbFormDataElement
	FROM  Deleted INNER JOIN
         tbFormDataElement ON Deleted.RowId = tbFormDataElement.ParentRowId

    SET NOCOUNT ON
    END