using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using Mobile.Api.Models;
using System.Web.Http.Cors;
using System.Web.Script.Serialization;
using Olsson.Mobile.Api.Models;
using Microsoft.AspNet.Identity;

namespace Olsson.Mobile.Api.Controllers
{
    [Authorize]
    public class tbFormController : ApiController
    {
        private ApplicationDbContext db = new ApplicationDbContext();

        // GET: api/SEM_tbForm
        [HttpGet]
        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        public IHttpActionResult GettbForm()
        {
            IQueryable<tbForm> tbform = null;
            try
            {
                string currentUser = User.Identity.GetUserName();
                tbform = db.tbForm
                    .Where(form => form.FormStatus.Equals("Active", StringComparison.InvariantCultureIgnoreCase) && form.UserName.Equals(currentUser, StringComparison.InvariantCultureIgnoreCase));
            }
            catch
            {

            }
            return Ok(tbform);
        }

        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        [ResponseType(typeof(SEM_tbForm))]
        public IHttpActionResult GettbForm(int id)
        {
            using (ApplicationDbContext db = new ApplicationDbContext())
            {

                tbForm tbform = db.tbForm.Find(id);
                if (tbform == null)
                {
                    return NotFound();
                }

                return Ok(tbform);
            }
        }


        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool bFormExists(int id)
        {
            using (ApplicationDbContext db = new ApplicationDbContext())
            {
                return db.tbForm.Count(e => e.FormID == id) > 0;
            }
        }
    }
}