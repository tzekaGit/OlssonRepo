using System;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System.Data.Entity;
using Microsoft.AspNet.Identity.Owin;
using System.Data.Entity.Infrastructure;
using System.Data.Entity.Core.Objects;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;


namespace Olsson.Mobile.Api.Models
{
    // You can add profile data for the user by adding more properties to your ApplicationUser class, please visit http://go.microsoft.com/fwlink/?LinkID=317594 to learn more.
    public class ApplicationUser : IdentityUser
    {
        public async Task<ClaimsIdentity> GenerateUserIdentityAsync(UserManager<ApplicationUser> manager, string authenticationType)
        {
            // Note the authenticationType must match the one defined in CookieAuthenticationOptions.AuthenticationType
            var userIdentity = await manager.CreateIdentityAsync(this, authenticationType);
            // Add custom user claims here
            return userIdentity;
        }
    }
  
      public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
        {
            public ApplicationDbContext()
                : base("dbConnection", throwIfV1Schema: false)
            {
        }
        
        public static ApplicationDbContext Create()
        {
            return new ApplicationDbContext();
        }

      
        public System.Data.Entity.DbSet<tbFormDataElementImageAnnotation> tbFormDataElementImageAnnotation { get; set; }
        public System.Data.Entity.DbSet<tbForm> tbForm { get; set; }
        public System.Data.Entity.DbSet<View_FormData> View_FormData { get; set; }
        public System.Data.Entity.DbSet<tbFormDataElement> tbFormDataElement { get; set; }
        public System.Data.Entity.DbSet<tbFormData> tbFormData { get; set; }
        public System.Data.Entity.DbSet<tbFormData_Errors> tbFormData_Errors { get; set; }
        public System.Data.Entity.DbSet<tbFormDataElement_v_Portal> tbFormDataElement_v_Portal { get; set; }
        public System.Data.Entity.DbSet<tbFormDataElementContainer> tbFormDataElementContainer { get; set; }
        public System.Data.Entity.DbSet<tbFormDataElementImage> tbFormDataElementImage { get; set; }
        

    public Boolean SEM_sp_Upsert_Record_Data(Guid RowId, Guid userID, Nullable<int> FormID, Guid TrxID, Nullable<int> SubmitDocument)
        {
            string IsSuccessful = "False";
            string conString = System.Configuration.ConfigurationManager.ConnectionStrings["SEMConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conString))
            {
                using (SqlCommand cmd = new SqlCommand("SEM_sp_Upsert_Record_Data", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    //cmd.Parameters.Add("@ParentRowID", SqlDbType.UniqueIdentifier).Value= RowId;
                    
                    cmd.Parameters.AddWithValue("@ParentRowID", RowId);
                    cmd.Parameters.AddWithValue("@userID", userID);
                    cmd.Parameters.AddWithValue("@FormID", FormID);
                    cmd.Parameters.AddWithValue("@TrxID", TrxID);
                    cmd.Parameters.AddWithValue("@SubmitDocument", SubmitDocument);
                    //cmd.Parameters.AddWithValue("@IsSuccessful", IsSuccessful);

                    cmd.Parameters.Add("@IsSuccessful", SqlDbType.Bit, 1);
                    cmd.Parameters["@IsSuccessful"].Direction = ParameterDirection.Output;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();    
                    
                    IsSuccessful= cmd.Parameters["@IsSuccessful"].Value.ToString();
                    if (IsSuccessful=="True")
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }

        }

        public Boolean SEM_sp_Remove_Record_Data(Guid RowId)
        {
            string conString = System.Configuration.ConfigurationManager.ConnectionStrings["SEMConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conString))
            {
                using (SqlCommand cmd = new SqlCommand("SEM_sp_Remove_Record_Data", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    //cmd.Parameters.Add("@ParentRowID", SqlDbType.UniqueIdentifier).Value= RowId;

                    cmd.Parameters.AddWithValue("@ParentRowID", RowId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();

                    return true;
                }
            }

        }

        

        // SEMConnectionString
    }
}