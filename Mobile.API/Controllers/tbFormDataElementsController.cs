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
    public class tbFormDataElementsController : ApiController
    {
        private ApplicationDbContext db = new ApplicationDbContext();

        // GET: api/tbFormDataElements
        public IQueryable<tbFormDataElement> GettbFormDataElements()
        {
            return db.tbFormDataElements;
        }

        // GET: api/tbFormDataElements/5
        [ResponseType(typeof(tbFormDataElement))]
        public IHttpActionResult GettbFormDataElement(Guid id)
        {
            tbFormDataElement tbFormDataElement = db.tbFormDataElements.Find(id);
            if (tbFormDataElement == null)
            {
                return NotFound();
            }

            return Ok(tbFormDataElement);
        }

        // PUT: api/tbFormDataElements/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PuttbFormDataElement(Guid id, tbFormDataElement tbFormDataElement)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != tbFormDataElement.RowID)
            {
                return BadRequest();
            }

            db.Entry(tbFormDataElement).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!tbFormDataElementExists(id))
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

        // POST: api/tbFormDataElements
        [ResponseType(typeof(tbFormDataElement))]
        public IHttpActionResult PosttbFormDataElement(tbFormDataElement tbFormDataElement)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.tbFormDataElements.Add(tbFormDataElement);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (tbFormDataElementExists(tbFormDataElement.RowID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = tbFormDataElement.RowID }, tbFormDataElement);
        }

        // DELETE: api/tbFormDataElements/5
        [ResponseType(typeof(tbFormDataElement))]
        public IHttpActionResult DeletetbFormDataElement(Guid id)
        {
            tbFormDataElement tbFormDataElement = db.tbFormDataElements.Find(id);
            if (tbFormDataElement == null)
            {
                return NotFound();
            }

            db.tbFormDataElements.Remove(tbFormDataElement);
            db.SaveChanges();

            return Ok(tbFormDataElement);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool tbFormDataElementExists(Guid id)
        {
            return db.tbFormDataElements.Count(e => e.RowID == id) > 0;
        }
    }
}