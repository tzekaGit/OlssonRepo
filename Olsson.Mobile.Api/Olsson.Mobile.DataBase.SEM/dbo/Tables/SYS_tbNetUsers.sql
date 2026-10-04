CREATE TABLE [dbo].[SYS_tbNetUsers] (
    [Id]                   NVARCHAR (128) NOT NULL,
    [Email]                NVARCHAR (256) NULL,
    [FirstName]            VARCHAR (50)   NULL,
    [LastName]             VARCHAR (50)   NULL,
    [Password]             VARCHAR (50)   NULL,
    [EmailConfirmed]       INT            NULL,
    [PasswordHash]         NVARCHAR (MAX) NULL,
    [SecurityStamp]        NVARCHAR (MAX) NULL,
    [PhoneNumber]          NVARCHAR (MAX) NULL,
    [PhoneNumberConfirmed] INT            NULL,
    [TwoFactorEnabled]     INT            NULL,
    [LockoutEndDateUtc]    DATETIME       NULL,
    [LockoutEnabled]       INT            NULL,
    [AccessFailedCount]    INT            NULL,
    CONSTRAINT [PK_SYS_tbNetUsers_1] PRIMARY KEY CLUSTERED ([Id] ASC)
);

