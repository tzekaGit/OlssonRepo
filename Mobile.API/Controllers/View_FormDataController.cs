using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using Mobile.Api.Models;
using System.Web.Http.Cors;
using System.Web.Script.Serialization;
using Mobile.Api;

namespace Mobile.Api.Controllers
{
    public class View_FormDataController : ApiController
    {
        private ApplicationDbContext db = new ApplicationDbContext();

        [HttpGet]
        public HttpResponseMessage GetView_FormData(int id)
        {
            List<View_FormData> tbForm = null;
            try
            {
                tbForm = db.View_FormData.Where(form => form.FormID == id).ToList();
            }
            catch
            {

            }
            var jsonSerialiser = new JavaScriptSerializer();
            var tbFormJSon = jsonSerialiser.Serialize(tbForm);

      
           var aa =   Json(jsonSerialiser.Serialize(tbFormJSon));
           
            var resp = new HttpResponseMessage(HttpStatusCode.OK);
            string callback = "callBackFn(" + aa.Content + ")";
            resp.Content = new StringContent(callback, System.Text.Encoding.UTF8, "text/plain");
            return resp;
        }

        //// GET: api/View_FormData/5
        //[ResponseType(typeof(View_FormData))]
        //public async Task<IHttpActionResult> GetView_FormData(int id)
        //{
        //    View_FormData view_FormData = await db.View_FormData.FindAsync(id);
        //    if (view_FormData == null)
        //    {
        //        return NotFound();
        //    }

        //    return Ok(view_FormData);
        //}

        // PUT: api/View_FormData/5
        [ResponseType(typeof(void))]
        public async Task<IHttpActionResult> PutView_FormData(int id, View_FormData view_FormData)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != view_FormData.FormID)
            {
                return BadRequest();
            }

            db.Entry(view_FormData).State = EntityState.Modified;

            try
            {
                await db.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!View_FormDataExists(id))
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

        // POST: api/View_FormData
        [ResponseType(typeof(View_FormData))]
        public async Task<IHttpActionResult> PostView_FormData(View_FormData view_FormData)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.View_FormData.Add(view_FormData);
            await db.SaveChangesAsync();

            return CreatedAtRoute("DefaultApi", new { id = view_FormData.FormID }, view_FormData);
        }

        // DELETE: api/View_FormData/5
        [ResponseType(typeof(View_FormData))]
        public async Task<IHttpActionResult> DeleteView_FormData(int id)
        {
            View_FormData view_FormData = await db.View_FormData.FindAsync(id);
            if (view_FormData == null)
            {
                return NotFound();
            }

            db.View_FormData.Remove(view_FormData);
            await db.SaveChangesAsync();

            return Ok(view_FormData);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool View_FormDataExists(int id)
        {
            return db.View_FormData.Count(e => e.FormID == id) > 0;
        }
    }
}