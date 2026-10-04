CREATE TABLE [dbo].[tbFormDataElement] (
    [RowId]               UNIQUEIDENTIFIER NOT NULL,
    [ParentRowId]         UNIQUEIDENTIFIER NULL,
    [DocumentId]          VARCHAR (100)    NULL,
    [ListId]              VARCHAR (100)    NULL,
    [FieldId]             INT              NULL,
    [FieldName]           VARCHAR (100)    NULL,
    [FieldValue]          VARCHAR (4000)   NULL,
    [SectionID]           INT              NULL,
    [DateCreated]         DATETIME         CONSTRAINT [DF_tbFormDataElement_DateCreated] DEFAULT (getdate()) NOT NULL,
    [DateUpdated]         DATETIME         NULL,
    [ElementID]           INT              NULL,
    [FieldValueOriginal]  VARCHAR (4000)   NULL,
    [FieldValueConverted] VARCHAR (4000)   NULL,
    CONSTRAINT [PK_tb_FormData] PRIMARY KEY CLUSTERED ([RowId] ASC)
);


GO
-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE TRIGGER [dbo].[skTrg_tbFormDataElement_Audit]
   ON   [dbo].[tbFormDataElement]
   AFTER INSERT, UPDATE
AS 
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
	INSERT INTO SYS_tbElementAudit
           (OldValue, Element_RowId, DateChanged)
	SELECT FieldValue, RowId, GETDATE() AS ChangeDate
	FROM   Inserted AS i
    -- Insert statements for trigger here

END