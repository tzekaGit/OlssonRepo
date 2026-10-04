using System.Configuration;
using System.Web;

namespace Olsson.DataAccess
{
    public class AppSettings
    {
        public struct Configuration
        {
            public static string AppPath = HttpContext.Current.Request.ApplicationPath == @"/" ? "" : HttpContext.Current.Request.ApplicationPath;
            public static string AdminPath = ConfigurationManager.AppSettings["AdminPath"].ToString();
            public static string dbConnection = ConfigurationManager.ConnectionStrings["dbConnection"].ToString();
            public static string ExcelFolderLocation = ConfigurationManager.AppSettings["ExcelFolderLocation"].ToString();

        }
    }
}
