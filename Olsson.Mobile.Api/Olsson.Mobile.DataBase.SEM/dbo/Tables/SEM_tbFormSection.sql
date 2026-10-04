CREATE TABLE [dbo].[SEM_tbFormSection] (
    [FormID]                  INT            NOT NULL,
    [SectionID]               INT            NOT NULL,
    [SectionName]             VARCHAR (100)  NOT NULL,
    [SectionSort]             VARCHAR (50)   NULL,
    [SectionAllowMultiRecord] INT            NULL,
    [SectionSourceTable]      INT            NULL,
    [SectionCaption]          VARCHAR (1000) NULL,
    [SectionExpanded]         INT            NULL,
    CONSTRAINT [PK_SEM_tbFormSection] PRIMARY KEY CLUSTERED ([FormID] ASC, [SectionID] ASC)
);

