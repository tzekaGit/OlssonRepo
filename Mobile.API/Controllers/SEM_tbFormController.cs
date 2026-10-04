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


namespace Mobile.Api.Controllers
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class SEM_tbFormController : ApiController
    {
        private ApplicationDbContext db = new ApplicationDbContext();

        // GET: api/SEM_tbForm

        [HttpGet]
        public HttpResponseMessage GetSEM_tbForm()
        {
            IQueryable<SEM_tbForm> tbForm = null;
            try
            {
                tbForm =  db.SEM_tbForm;
            }
            catch
            {
                
            }
            var jsonSerialiser = new JavaScriptSerializer();
            var tbFormJSon = jsonSerialiser.Serialize(tbForm);
 
            var resp = new HttpResponseMessage(HttpStatusCode.OK);
            string callback = "callBackFn('" +  tbFormJSon +"')";
            resp.Content = new StringContent(callback, System.Text.Encoding.UTF8, "text/plain");
            return resp;
        }

        // GET: api/SEM_tbForm/5
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

        // PUT: api/SEM_tbForm/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutSEM_tbForm(int id, SEM_tbForm sEM_tbForm)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != sEM_tbForm.FormID)
            {
                return BadRequest();
            }

            db.Entry(sEM_tbForm).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!SEM_tbFormExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return StatusCode(HttpStatusCode.NoContent);
        }

        // POST: api/SEM_tbForm
        [ResponseType(typeof(SEM_tbForm))]
        public IHttpActionResult PostSEM_tbForm(SEM_tbForm sEM_tbForm)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.SEM_tbForm.Add(sEM_tbForm);
            db.SaveChanges();

            return CreatedAtRoute("DefaultApi", new { id = sEM_tbForm.FormID }, sEM_tbForm);
        }

        // DELETE: api/SEM_tbForm/5
        [ResponseType(typeof(SEM_tbForm))]
        public IHttpActionResult DeleteSEM_tbForm(int id)
        {
            SEM_tbForm SEM_tbForm = db.SEM_tbForm.Find(id);
            if (SEM_tbForm == null)
            {
                return NotFound();
            }

            db.SEM_tbForm.Remove(SEM_tbForm);
            db.SaveChanges();

            return Ok(SEM_tbForm);
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