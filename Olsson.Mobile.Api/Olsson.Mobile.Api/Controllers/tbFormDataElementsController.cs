using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using Microsoft.AspNet.Identity;
using System.Security.Claims;
using Olsson.Mobile.Api.Models;

namespace Olsson.Mobile.Api.Controllers
{
    [Authorize]
    public class tbFormDataElementsController : ApiController
    {
        private ApplicationDbContext db = new ApplicationDbContext();
        private string CurrentUserId = string.Empty;
        // GET: api/tbFormDataElements

        public tbFormDataElementsController()
        {

        }

        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        public IQueryable<tbFormDataElement> Get()
        {
            return db.tbFormDataElement;
        }

        // GET: api/tbFormDataElements/5
        [ResponseType(typeof(tbFormDataElement))]
        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        public IHttpActionResult GetImage(string id, [FromUri]string imageId)
        {
            var MediumImg = db.tbFormDataElementImage.Where(img => img.ImageFileName == id + "_" + imageId + "_medium_annotation.png");
            if (MediumImg == null || MediumImg.Count() == 0)
            {
               MediumImg = db.tbFormDataElementImage.Where(img => img.ImageFileName == id + "_" + imageId + "_medium.png");
            }
            if (MediumImg == null || MediumImg.Count()==0) {
                return BadRequest();
            }
            else
            {
                return Ok(MediumImg.FirstOrDefault().ImageSource);
            }
         
        }


        // GET: api/tbFormDataElements/5
        [ResponseType(typeof(tbFormDataElement))]
        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        public IHttpActionResult Get(Guid id)
        {
            List<tbFormDataElement> tbFormDataElement = db.tbFormDataElement.Where(el => el.ParentRowID == id).ToList();
            if (tbFormDataElement == null)
            {
                return NotFound();
            }
            //var imageRows = tbFormDataElement.Select(row => row.RowID).ToArray();

            //get images that have items to the form
            List<tbFormDataElementImage> tbFormDataElementImages = db.tbFormDataElementImage
                    .Where(img => img.ImageFileName.Contains("_small") && db.tbFormDataElement
                    .Any(row => row.RowID == img.RowID)
                    )
             .ToList();
            List<tbFormDataElementImage> tbFormDbElementImages = new List<tbFormDataElementImage>(tbFormDataElementImages); ;
            Guid ID = Guid.Empty;
            foreach (var img in tbFormDataElementImages)
            {
                //get the ID of annotation;
                var elems = tbFormDbElementImages.Find(x => x.ImageName == img.ImageName && (x.ImageFileName.Contains("_small_annotation"))) ;

                if (elems != null)
                {
                    ID = elems.ID;
                    //detele the small image from the list
                    tbFormDbElementImages.RemoveAll(itm => itm.ImageName == img.ImageName && itm.ImageFileName.Contains("_small") && itm.ID != ID);
                }
                
            }
     
            
            string adminMessage = db.tbFormData
                    .Where(doc => doc.RowID == id)
                    .Select(doc => doc.AdminMessage)
                    .FirstOrDefault();

            tbFormDataAndElements formdataEl = new tbFormDataAndElements();
            formdataEl.formDataElement = tbFormDataElement;
            formdataEl.tbFormDataElementImage = tbFormDbElementImages;
            formdataEl.adminMessage = adminMessage;

            return Ok(formdataEl);
        }




        // PUT: api/tbFormDataElements/5
        [HttpPost]
        [ResponseType(typeof(void))]
        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        public IHttpActionResult Put(string id, [FromBody] List<KeyValue> list, [FromUri] int? sbmt)
        {

            Guid ID = Guid.Parse(id);
            tbFormData tbForm = GetUpdatedTbForm(id, list);
            Guid TrxID = Guid.NewGuid();

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (ID != tbForm.RowID)
            {
                return BadRequest();
            }

            db.Entry(tbForm).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!tbFormDataExists(ID))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            //Convert the keyvalue list to tbFormDataElement list
            List<tbFormDataElement> formEls = KeyValueToList(list, tbForm);

            List<tbFormDataElement> tbFormElList = db.tbFormDataElement.Where(row => row.ParentRowID == ID).ToList();

            try
            {

                tbFormDataElement dbEl = null;
                //update tbFormDataElement table
                using (ApplicationDbContext db = new ApplicationDbContext())
                {

                    foreach (var formEl in formEls)
                    {
                        try
                        {
                            //update the current record
                            dbEl = db.tbFormDataElement.Where(row => row.ParentRowID == formEl.ParentRowID && row.FieldName == formEl.FieldName).FirstOrDefault();
                            if (dbEl != null)
                            {
                                dbEl.FieldValue = formEl.FieldValue;
                                dbEl.DateUpdated = DateTime.Now;

                                db.SaveChanges();
                            }

                            //create a new record
                            else if (!formEl.FieldName.Contains("__EVENT") && !formEl.FieldName.Contains("__VIEWSTATE"))
                            {
                                dbEl = new tbFormDataElement()
                                {
                                    RowID = Guid.NewGuid(),
                                    ParentRowID = formEl.ParentRowID,
                                    FieldName = formEl.FieldName,
                                    FieldValue = formEl.FieldValue,
                                    DateUpdated = DateTime.Now
                                };
                                db.tbFormDataElement.Add(dbEl);
                                db.SaveChanges();

                            }
                        }
                        catch (DbUpdateConcurrencyException)
                        {
                            if (!tbFormDataElementExists(dbEl.RowID))
                            {
                                return NotFound();
                            }
                            else
                            {
                                throw;
                            }
                        }

                        catch (Exception ex)
                        {
                            var err = ex.Message;
                        }
                    }
                }
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!tbFormDataExists(ID))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            //remove elemets with no value
            using (ApplicationDbContext db = new ApplicationDbContext())
            {
                foreach (tbFormDataElement dbRow in tbFormElList)
                {
                    try
                    {
                        var missingRow = formEls.Where(row => row.FieldName == dbRow.FieldName).FirstOrDefault();
                        if (missingRow == null)
                        {
                            tbFormDataElement thisRow = db.tbFormDataElement.Find(dbRow.RowID);
                            db.tbFormDataElement.Remove(thisRow);
                        }

                        List<tbFormDataElementImage> tbFormDataElementImages = db.tbFormDataElementImage
                            .Where(img => img.RowID == missingRow.RowID)
                            .ToList();
                        foreach (tbFormDataElementImage img in tbFormDataElementImages)
                        {
                            db.tbFormDataElementImage.Remove(img);
                        }
                            db.SaveChanges();
                        }
                    catch (Exception ex)
                    {
                        var err = ex.InnerException;
                    }
                }

            }



            //call the sp
            using (ApplicationDbContext db = new ApplicationDbContext())
            {
                if (sbmt == null)
                {
                    sbmt = 1;
                }
                Boolean IsSuccessful = db.SEM_sp_Upsert_Record_Data(tbForm.RowID, tbForm.UserID, tbForm.FormID, TrxID, sbmt);
                db.SaveChanges();
            }
            //If the record is being posted. Check for validation errors.
            List<tbFormData_Errors> formValidation = null;
            List<KeyValue> errList = new List<KeyValue>();

            using (ApplicationDbContext db = new ApplicationDbContext())
            {
                formValidation = db.tbFormData_Errors.Where(Row => Row.TrxID == TrxID).ToList();
            }
         


            List<tbFormDataElement> tbFormElListUpdated = null;
            using (ApplicationDbContext db = new ApplicationDbContext())
            {
                tbFormElListUpdated = db.tbFormDataElement.Distinct().Where(row => row.ParentRowID == tbForm.RowID).OrderBy(row => row.FieldName).ToList();
            }

            //return CreatedAtRoute("DefaultApi", "UPDATE", tbFormElListUpdated);

            tbFormDataElementsAndErrors tbFormDataAndErrors = new tbFormDataElementsAndErrors();
            tbFormDataAndErrors.tbFormElListUpdated = tbFormElListUpdated;
            tbFormDataAndErrors.formValidation = formValidation;

            return CreatedAtRoute("DefaultApi", "New record", tbFormDataAndErrors);


        }


        // POST: api/tbFormDataElements
        [HttpPost]
        [ResponseType(typeof(tbFormDataElement))]
        [HostAuthentication(DefaultAuthenticationTypes.ExternalBearer)]
        public IHttpActionResult Post([FromBody] List<KeyValue> list, [FromUri] int? sbmt)
        {

            var RoowID = "";
            Guid TrxID = Guid.NewGuid();

            tbFormData tbForm = GetUpdatedTbForm(RoowID, list);

            using (ApplicationDbContext db = new ApplicationDbContext())
            {
                db.tbFormData.Add(tbForm);
                try
                {
                    db.SaveChanges();
                    //update tbFormData table  
                    //db.ExecuteSqlCommand("<sp_name>", tbForm.RowID.ToString());

                }
                catch (Exception ex)
                {
                    var err = ex.Message;
                }


            }
            List<tbFormDataElement> tbFormEl = KeyValueToList(list, tbForm);

            using (ApplicationDbContext db = new ApplicationDbContext())
            {
                foreach (var dbForm in tbFormEl)
                {
                    db.tbFormDataElement.Add(dbForm);
                    try
                    {
                        db.SaveChanges();
                    }
                    catch (Exception ex)
                    {
                        var err = ex.Message;
                    }
                }
            }
            if (sbmt == null)
            {
                sbmt = 1;
            }
            Boolean IsSuccessful = db.SEM_sp_Upsert_Record_Data(tbForm.RowID, tbForm.UserID, tbForm.FormID, TrxID, sbmt);


            //If the record is being posted. Check for validation errors.
            List<tbFormData_Errors> formValidation = null;
            List<KeyValue> errList = new List<KeyValue>();

            using (ApplicationDbContext db = new ApplicationDbContext())
            {
                formValidation = db.tbFormData_Errors.Where(Row => Row.TrxID == TrxID).ToList();
            }




            List<tbFormDataElement> tbFormElListNew = null;
            using (ApplicationDbContext db = new ApplicationDbContext())
            {
                tbFormElListNew = db.tbFormDataElement.Where(row => row.ParentRowID == tbForm.RowID).OrderBy(row => row.FieldName).ToList();
            }
            //create a combined list of data and errors
            tbFormDataElementsAndErrors tbFormDataAndErrors = new tbFormDataElementsAndErrors();
            tbFormDataAndErrors.tbFormElListUpdated = tbFormElListNew;
            tbFormDataAndErrors.formValidation = formValidation;
            return CreatedAtRoute("DefaultApi", "New record", tbFormDataAndErrors);
        }

        // DELETE: api/tbFormDataElements/5

        [ResponseType(typeof(tbFormDataElement))]
        public IHttpActionResult DeletetbFormDataElement(Guid id)
        {
            tbFormDataElement tbFormDataElement = db.tbFormDataElement.Find(id);
            if (tbFormDataElement == null)
            {
                return NotFound();
            }

            db.tbFormDataElement.Remove(tbFormDataElement);
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

        private bool tbFormDataExists(Guid id)
        {
            return db.tbFormData.Count(e => e.RowID == id) > 0;
        }

        private bool tbFormDataElementExists(Guid id)
        {
            return db.tbFormDataElement.Count(e => e.RowID == id) > 0;
        }

        private tbFormData GetUpdatedTbForm(string tblKey, List<KeyValue> list)
        {
            //get form values
            CurrentUserId = User.Identity.GetUserId();
            var DocID = list.Where(key => key.name.ToLower() == "documentid").Select(itm => itm.value).FirstOrDefault();
            var DocTitle = list.Where(key => key.name.ToLower() == "documenttitle").Select(itm => itm.value).FirstOrDefault();
            var DocType = list.Where(key => key.name.ToLower() == "documenttype").Select(itm => itm.value).FirstOrDefault();
            var UserID = new Guid(CurrentUserId.ToString()); //list.Where(key => key.name.ToLower() == "userid").Select(itm => itm.value).ToString();
            int FormID = int.Parse(list.Where(key => key.name.ToLower() == "formid").Select(itm => itm.value).FirstOrDefault());

            tbFormData tbForm;
            Guid RowID;

            //check for new values
            DocID = DocID == null || DocID == string.Empty ? "" : DocID;
            DocTitle = DocTitle == null || DocTitle == string.Empty ? "" : DocTitle;
            DocType = DocType == null || DocType == string.Empty ? "" : DocType;
            RowID = tblKey.Length == 0 ? Guid.NewGuid() : Guid.Parse(tblKey);
            tbForm = tblKey.Length == 0 ? new tbFormData() : db.tbFormData.Where(row => row.RowID == RowID).FirstOrDefault();


            //update list values
            tbForm.FormID = FormID;
            tbForm.RowID = RowID;
            tbForm.DocumentTitle = DocTitle;
            tbForm.DocumentId = DocID;
            tbForm.DocumentType = DocType;
            tbForm.UserID = UserID;

            return tbForm;
        }

        private List<tbFormDataElement> KeyValueToList(List<KeyValue> list, tbFormData tbForm)
        {
            List<tbFormDataElement> tbFormList = list
                .Where(key => !key.name.Contains("__EVENT") && !key.name.Contains("__VIEW") && !key.name.Equals("rowID") && !key.name.Equals("formid"))
                .Select(itm => new tbFormDataElement
                {
                    RowID = Guid.NewGuid(),
                    ParentRowID = tbForm.RowID,
                    FieldName = itm.name,
                    FieldValue = itm.value,
                    DocumentId = tbForm.DocumentId,

                }).ToList();

            return tbFormList;
        }
    }

    public class KeyValue
    {
        public string name { get; set; }
        string _value = "";
        public string value
        {
            get { return _value; }
            set { _value = value ?? string.Empty; }
        }
    }

    public class tbFormDataElementsAndErrors
    {

        public List<tbFormDataElement> tbFormElListUpdated { get; set; }
        public List<tbFormData_Errors> formValidation { get; set; }
    }

    public class tbFormDataAndElements
    {

        public List<tbFormDataElement> formDataElement { get; set; }
        public List<tbFormDataElementImage> tbFormDataElementImage { get; set; }
        public string adminMessage { get; set; }
    }

    

}