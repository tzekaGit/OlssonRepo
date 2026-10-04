namespace Olsson.WebApp
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }

        protected void Application_PostAuthenticateRequest(object sender, EventArgs args)
        {

            //redirect to login page
            if (!Request.IsAuthenticated && !Request.Url.ToString().ToLower().Contains("/login"))
            {
                // Response.Redirect("~/" + AppSettings.Configuration.AdminPath + "/login.aspx", true);
            }
        }



    }
}