using System;
using System.Web;
using System.Web.Security;
using System.Configuration.Provider;
using System.Collections.Specialized;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using Olsson.DataAccess.Entities;
using System.Linq;

namespace Olsson.Security
{

    public sealed class CustomRoleProvider : System.Web.Security.RoleProvider
    {
        public override string ApplicationName
        {
            get
            {
                throw new NotImplementedException();
            }

            set
            {
                throw new NotImplementedException();
            }
        }


        public override string[] GetRolesForUser(string username)
        {
            return new string[] {"Administrtor" }; ;
        }


        public override void AddUsersToRoles(string[] usernames, string[] roleNames)
        {
            //throw new NotImplementedException();
        }

        public override void CreateRole(string roleName)
        {
            throw new NotImplementedException();
        }

        public override bool DeleteRole(string roleName, bool throwOnPopulatedRole)
        {
            throw new NotImplementedException();
        }

        public override string[] FindUsersInRole(string roleName, string usernameToMatch)
        {
            throw new NotImplementedException();
        }

        public override string[] GetAllRoles()
        {
            throw new NotImplementedException();
        }

       

        public override string[] GetUsersInRole(string roleName)
        {
            throw new NotImplementedException();
        }

        public override bool IsUserInRole(string username, string roleName)
        {
            return true;
            //throw new NotImplementedException();
        }

        public override void RemoveUsersFromRoles(string[] usernames, string[] roleNames)
        {
            throw new NotImplementedException();
        }

        public override bool RoleExists(string roleName)
        {
            if (roleName != "Administrator")
                return true;
            else
                return false;

        }
    }

}

