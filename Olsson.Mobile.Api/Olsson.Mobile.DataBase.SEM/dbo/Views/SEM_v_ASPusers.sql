  CREATE VIEW [SEM_v_ASPusers]
  AS
  Select aspU.* from [OlssonRoofing_Portal_2016].[dbo].AspNetUsers  aspU
inner join [SEM].[dbo].[SYS_tbNetUsers] semU on aspU.username = semU.Id