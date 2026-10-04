CREATE TABLE [dbo].[SYS_tbLookupList] (
    [LookupID]    INT           IDENTITY (1, 1) NOT NULL,
    [LookupList]  VARCHAR (100) NOT NULL,
    [LookupValue] VARCHAR (250) NOT NULL,
    [LookupSort]  VARCHAR (50)  NULL,
    CONSTRAINT [PK_SYS_tbLookupList] PRIMARY KEY CLUSTERED ([LookupID] ASC)
);

