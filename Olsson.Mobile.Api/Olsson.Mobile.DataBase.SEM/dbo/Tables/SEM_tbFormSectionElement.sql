CREATE TABLE [dbo].[SEM_tbFormSectionElement] (
    [FormID]                  INT            NOT NULL,
    [SectionID]               INT            NOT NULL,
    [ElementID]               INT            IDENTITY (1, 1) NOT NULL,
    [ElementSort]             VARCHAR (50)   NULL,
    [ElementType]             VARCHAR (50)   NOT NULL,
    [ElementCaption]          VARCHAR (100)  NULL,
    [ElementText]             VARCHAR (4000) NULL,
    [ElementFieldID]          INT            NULL,
    [ElementFieldCalculation] VARCHAR (1000) NULL,
    [ElementFieldRequired]    INT            NULL,
    [ElementName]             VARCHAR (100)  NULL,
    [ElementValueListDisplay] VARCHAR (50)   NULL,
    CONSTRAINT [PK_SEM_tbFormSectionElement] PRIMARY KEY CLUSTERED ([FormID] ASC, [SectionID] ASC, [ElementID] ASC)
);

