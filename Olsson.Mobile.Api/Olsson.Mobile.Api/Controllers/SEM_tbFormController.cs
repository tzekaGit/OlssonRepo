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
    public class SEM_tbFormController : ApiController
    {


        private ApplicationDbContext db = new ApplicationDbContext();

        // GET: api/SEM_tbForm
        [HttpGet]
        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        public IHttpActionResult GetSEM_tbForm()
        {
            IQueryable<SEM_tbForm> tbForm = null;
            try
            {
                tbForm =  db.SEM_tbForm;                
            }
            catch
            {
                
            }
            return Ok(tbForm);
        }

        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        [ResponseType(typeof(SEM_tbForm))]
        public IHttpActionResult GetSEM_tbForm(int id)
        {
            SEM_tbForm sEM_tbForm = db.SEM_tbForm.Find(id);
            if (sEM_tbForm == null)
            {
                return NotFound();
            }

            return Ok(sEM_tbForm);
        }


        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool SEM_tbFormExists(int id)
        {
            return db.SEM_tbForm.Count(e => e.FormID == id) > 0;
        }
    }
}