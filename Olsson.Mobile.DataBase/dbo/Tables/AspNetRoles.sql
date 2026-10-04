CREATE TABLE [dbo].[AspNetRoles] (
    [Id]   NVARCHAR (128) CONSTRAINT [DF_AspNetRoles_Id] DEFAULT (newid()) NOT NULL,
    [Name] NVARCHAR (256) NOT NULL,
    CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex]
    ON [dbo].[AspNetRoles]([Name] ASC);

