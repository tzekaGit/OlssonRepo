using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http.Results;
using System.Web.Mvc;
using Mobile.Api.Models;
using System.Web.Http.Cors;
using Olsson.Mobile.Api.Models;


namespace Olsson.Mobile.Api.Controllers
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class LoginController : Controller
    {
        private static Token _myToken;

        private static string ApiUri = ConfigurationManager.AppSettings["ApiUri"].ToString(); 

        public ActionResult Index()
        {
            ViewBag.Title = "Login";
            return View();
        }

        [HttpPost]
        public async Task<HttpStatusCodeResult> Register(string username, string email, string password, string passwordConfirm)
        {
            if (String.IsNullOrEmpty(username) || String.IsNullOrEmpty(email) ||
                String.IsNullOrEmpty(password) ||
                !String.Equals(password, passwordConfirm))
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest,
                    "Registration form is invalid");
            }

            var registerModel = new Dictionary<string, string>
            {
                {"Username", username},
                {"Email", email},
                {"Password", password},
                {"ConfirmPassword", password}
            };

            var response = await CallApiTask("api/Account/Register", registerModel);

            if (response.IsSuccessStatusCode)
                return new HttpStatusCodeResult(response.StatusCode);

            var errors = await response.Content.ReadAsAsync<ResponseErrors>();
            return new HttpStatusCodeResult(response.StatusCode, errors.ToString());
        }

        [HttpPost]
        public async Task<JsonResult> GetAccessToken(string tokenUserName, string tokenPassword)
        {
            if (String.IsNullOrEmpty(tokenUserName) || String.IsNullOrEmpty(tokenPassword))
            {
                throw new ArgumentNullException();
            }

            var tokenModel = new Dictionary<string, string>
            {
                {"grant_type", "password"},
                {"username", tokenUserName},
                {"password", tokenPassword},
            };

            var response = await CallApiTask("api/authtoken", tokenModel);

            if (!response.IsSuccessStatusCode)
            {
                var errors = await response.Content.ReadAsStringAsync();
                throw new Exception(errors);
            }
            //override error fro selt asigned certificate
            ServicePointManager.ServerCertificateValidationCallback = delegate { return true; };
            _myToken = response.Content.ReadAsAsync<Token>(new[] { new JsonMediaTypeFormatter() }).Result;

            return Json(_myToken);
        }

        public ActionResult Logout()
        {
            _myToken = null;

            return RedirectToAction("Login");
        }

        public async Task<ICollection<string>> GetValues()
        {
            if (_myToken != null)
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(ApiUri);
                    client.DefaultRequestHeaders.Accept.Clear();

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", _myToken.AccessToken);
                    var authorizedResponse = client.GetAsync("api/values").Result;

                    if (!authorizedResponse.IsSuccessStatusCode) return null;

                    var res = await authorizedResponse.Content.ReadAsAsync<List<string>>();
                    return res;
                }
            }
            return null;
        }

        private static async Task<HttpResponseMessage> CallApiTask(string apiEndPoint, Dictionary<string, string> model = null)
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(ApiUri);
                client.DefaultRequestHeaders.Accept.Clear();

                if (_myToken != null)
                {
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", _myToken.AccessToken);
                }
                else
                {
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                }
                ServicePointManager.ServerCertificateValidationCallback = delegate { return true; };
                return await client.PostAsync(apiEndPoint, model != null ? new FormUrlEncodedContent(model) : null);
            }
        }
    }
}
