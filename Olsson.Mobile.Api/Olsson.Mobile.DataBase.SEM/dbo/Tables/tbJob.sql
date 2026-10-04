CREATE TABLE [dbo].[tbJob] (
    [JobNo]           VARCHAR (50)   NOT NULL,
    [JobName]         VARCHAR (50)   NULL,
    [JobCustomer]     VARCHAR (50)   NULL,
    [JobAddressLine1] VARCHAR (50)   NULL,
    [JobAddressLine2] VARCHAR (50)   NULL,
    [JobAddressCity]  VARCHAR (50)   NULL,
    [JobAddressState] VARCHAR (2)    NULL,
    [JobAdddressZip]  VARCHAR (50)   NULL,
    [JobDescription]  VARCHAR (4000) NULL,
    CONSTRAINT [PK_tbJob] PRIMARY KEY CLUSTERED ([JobNo] ASC)
);

