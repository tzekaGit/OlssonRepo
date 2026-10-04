CREATE TABLE [dbo].[SYS_tbUser] (
    [UserID]        NVARCHAR (255) NOT NULL,
    [UserFirstName] NVARCHAR (255) NULL,
    [UserLastName]  NVARCHAR (255) NULL,
    [UserPassword]  NVARCHAR (255) NULL,
    [UserAutoLoad]  INT            NULL,
    [UserGroupID]   NVARCHAR (255) NULL,
    CONSTRAINT [PK_SYS_tbUser] PRIMARY KEY CLUSTERED ([UserID] ASC)
);

