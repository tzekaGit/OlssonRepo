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

namespace Mobile.Api.Controllers
{
    public class SEM_FormController : ApiController
    {
        private ApplicationDbContext db = new ApplicationDbContext();

        // GET: api/SEM_Form
        public IQueryable<SEM_Form> GetSEM_Forms()
        {
            return db.SEM_Forms;
        }

        // GET: api/SEM_Form/5
        [ResponseType(typeof(SEM_Form))]
        public IHttpActionResult GetSEM_Form(int id)
        {
            SEM_Form sEM_Form = db.SEM_Forms.Find(id);
            if (sEM_Form == null)
            {
                return NotFound();
            }

            return Ok(sEM_Form);
        }

        // PUT: api/SEM_Form/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutSEM_Form(int id, SEM_Form sEM_Form)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != sEM_Form.FormID)
            {
                return BadRequest();
            }

            db.Entry(sEM_Form).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!SEM_FormExists(id))
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

        // POST: api/SEM_Form
        [ResponseType(typeof(SEM_Form))]
        public IHttpActionResult PostSEM_Form(SEM_Form sEM_Form)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.SEM_Forms.Add(sEM_Form);
            db.SaveChanges();

            return CreatedAtRoute("DefaultApi", new { id = sEM_Form.FormID }, sEM_Form);
        }

        // DELETE: api/SEM_Form/5
        [ResponseType(typeof(SEM_Form))]
        public IHttpActionResult DeleteSEM_Form(int id)
        {
            SEM_Form sEM_Form = db.SEM_Forms.Find(id);
            if (sEM_Form == null)
            {
                return NotFound();
            }

            db.SEM_Forms.Remove(sEM_Form);
            db.SaveChanges();

            return Ok(sEM_Form);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool SEM_FormExists(int id)
        {
            return db.SEM_Forms.Count(e => e.FormID == id) > 0;
        }
    }
}