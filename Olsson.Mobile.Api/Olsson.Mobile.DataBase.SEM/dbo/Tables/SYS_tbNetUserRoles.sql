CREATE TABLE [dbo].[SYS_tbNetUserRoles] (
    [Id]     INT            IDENTITY (1, 1) NOT NULL,
    [UserId] NVARCHAR (128) NOT NULL,
    [RoleId] INT            NOT NULL,
    CONSTRAINT [PK_SYS_tbNetUserRoles_1] PRIMARY KEY CLUSTERED ([UserId] ASC, [RoleId] ASC)
);

