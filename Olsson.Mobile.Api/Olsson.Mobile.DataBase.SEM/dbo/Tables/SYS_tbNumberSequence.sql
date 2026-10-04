CREATE TABLE [dbo].[SYS_tbNumberSequence] (
    [Field]      VARCHAR (100) NOT NULL,
    [NextNumber] BIGINT        NOT NULL,
    CONSTRAINT [PK_SYS_tbNumberSequence] PRIMARY KEY CLUSTERED ([Field] ASC)
);

