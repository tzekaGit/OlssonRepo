CREATE VIEW [dbo].[tbForm]
AS
SELECT DISTINCT semFormRole.FormID, 0 as RoleId, SEM_tbForm.FormName, SEM_tbForm.FormStatus, aspU.UserName
FROM            dbo.AspNetUsers AS aspU INNER JOIN
                         SEM.dbo.SYS_tbNetUsers AS semU ON aspU.UserName = semU.Id INNER JOIN
                         SEM.dbo.SYS_tbNetUserRoles AS semR ON semR.UserId = aspU.UserName INNER JOIN
                         SEM.dbo.SEM_tbFormRoleList AS semFormRole ON semFormRole.RoleID = semR.RoleId INNER JOIN
                         SEM.dbo.SEM_tbForm AS SEM_tbForm ON SEM_tbForm.FormID = semFormRole.FormID