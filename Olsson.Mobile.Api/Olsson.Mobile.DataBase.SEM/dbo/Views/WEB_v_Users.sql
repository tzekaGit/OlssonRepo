
CREATE VIEW [dbo].[WEB_v_Users]
AS
SELECT        Id, Email, EmailConfirmed, PasswordHash, SecurityStamp, PhoneNumber, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEndDateUtc, LockoutEnabled, AccessFailedCount, UserName
FROM            OlssonRoofing_Portal_2016.dbo.AspNetUsers AS aspU