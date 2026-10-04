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
using Olsson.Mobile.Api.Models;
using Microsoft.AspNet.Identity;

namespace Olsson.Mobile.Api.Controllers
{
    [Authorize]
    public class View_FormDataController : ApiController
    {

        private string CurrentUserID = string.Empty;

        public View_FormDataController()
        {
            
        }


        [HttpGet]
        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        public IHttpActionResult GetView_FormData(int id)
        {
            List<View_FormData> tbForm = null;
            using (ApplicationDbContext db = new ApplicationDbContext())
            {
                try
                {
                    CurrentUserID = User.Identity.GetUserId();
                    tbForm = db.View_FormData.Where(form => form.FormID == id && form.UserID.ToString().Equals(CurrentUserID, StringComparison.InvariantCultureIgnoreCase))
                   .OrderByDescending(itm => itm.Audit_UpdateDate)
                   .ToList();
                }
                catch (Exception ex)
                {
                    return StatusCode(HttpStatusCode.BadRequest);
                }
            }

            return CreatedAtRoute("DefaultApi", "", tbForm);
        }

        private bool View_FormDataExists(int id)
        {
            using (ApplicationDbContext db = new ApplicationDbContext())
            {
                return db.View_FormData.Count(e => e.FormID == id) > 0;
            }
        }

        [ResponseType(typeof(View_FormData))]
        public IHttpActionResult DeleteView_FormData(Guid id, [FromUri] string Action)
        {
            //(Guid id,string FromURL, string Action)
            using (ApplicationDbContext db = new ApplicationDbContext())
            {

                View_FormData view_FormData = db.View_FormData.Find(id);
                if (view_FormData == null)
                {
                    return NotFound();
                }

                if (Action == "RemoveRecord")
                {
                    //db.View_FormData.Remove(view_FormData);
                    db.SEM_sp_Remove_Record_Data(id);
                }
                else
                {
                    //Enumerators.documentStatus dsStatus = new Enumerators.documentStatus();
                    view_FormData.DocumentStatus = Action;
                }

                db.SaveChanges();

                return Ok();
            }

        }


    }
}