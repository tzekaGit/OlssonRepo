CREATE TABLE [dbo].[SYS_tbUserGroup] (
    [UserGroupId]   NVARCHAR (255) NOT NULL,
    [UserGroupName] NVARCHAR (255) NULL,
    CONSTRAINT [PK_SYS_tbUserGroup] PRIMARY KEY CLUSTERED ([UserGroupId] ASC)
);

