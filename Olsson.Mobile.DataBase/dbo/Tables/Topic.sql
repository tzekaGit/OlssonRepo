CREATE TABLE [dbo].[Topic] (
    [TopicID]          INT              IDENTITY (1, 1) NOT NULL,
    [TopicGUID]        UNIQUEIDENTIFIER CONSTRAINT [DF_Topic_TopicGUID] DEFAULT (newid()) NOT NULL,
    [TopicName]        NVARCHAR (400)   NOT NULL,
    [TopicTitle]       NVARCHAR (MAX)   NOT NULL,
    [TopicText]        NVARCHAR (MAX)   NULL,
    [ViewBy]           NVARCHAR (100)   NULL,
    [ShowInNavigation] TINYINT          CONSTRAINT [DF_Topic_ShowInSiteMap] DEFAULT ((1)) NOT NULL,
    [DisplayOrder]     INT              CONSTRAINT [DF_Topic_DisplayOrder] DEFAULT ((1)) NOT NULL,
    [CreatedOn]        DATETIME         CONSTRAINT [DF_Topic_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [UpdatedOn]        DATETIME         CONSTRAINT [DF_Topic_UpdatedOn] DEFAULT (getdate()) NOT NULL,
    [UpdatedBy]        INT              NOT NULL,
    [TopicStatus]      TINYINT          CONSTRAINT [DF_Topic_Published] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Topic] PRIMARY KEY CLUSTERED ([TopicID] ASC)
);

