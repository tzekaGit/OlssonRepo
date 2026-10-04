using System;
using System.IO;
using System.Web.Http;
using System.Web.Hosting;
using System.Linq;
using System.Collections.Generic;

using Olsson.Mobile.Api.Models;
using System.Web.Http.Description;

namespace Olsson.Mobile.Api.Controllers
{
    [Authorize]
    public class ImageUploadController : ApiController
    {

        [HttpGet]
        [ResponseType(typeof(tbFormDataElementContainer))]
        public IHttpActionResult Get(string id)
        {
            List<tbFormDataElementContainer> Containers = null;
            using (ApplicationDbContext db = new ApplicationDbContext())
            {
                Containers = db.tbFormDataElementContainer
                .Distinct()
                .Where(itm => itm.ParentRowId.ToString() == id)
                .ToList();
            }
            return CreatedAtRoute("DefaultApi", "UPDATE", Containers);

        }


        public IHttpActionResult Post([FromUri] string FieldName, [FromUri] string imgSize, [FromUri] string docId, [FromBody]Img data)
        {
            byte[] photo = Convert.FromBase64String(data.Value);
            var dir = new DirectoryInfo(HostingEnvironment.ApplicationPhysicalPath);
            string imgName = string.Format("{0}_{1}", docId, FieldName);
            string imgFileName = imgName + "_" + imgSize + ".png";

            //write the image file to database
            using (ApplicationDbContext db = new ApplicationDbContext())
            {
                tbFormDataElement tbFormDataEl = db.tbFormDataElement.Where(itm => itm.DocumentId == docId && itm.FieldName == FieldName).FirstOrDefault();
                Guid ParentRowID = db.tbFormDataElement.Where(itm => itm.DocumentId == docId).FirstOrDefault().ParentRowID;
                
                //Remove all annotations if large image is being loaded.
                if (imgSize == "large")
                {
                    List<tbFormDataElementImageAnnotation> annots = db.tbFormDataElementImageAnnotation.Where(itm => itm.rowID == tbFormDataEl.RowID).ToList();

                    //Delete small annotated image if exists
                    List<tbFormDataElementImage> dbImages = db.tbFormDataElementImage.Where(row => row.RowID == tbFormDataEl.RowID && row.ImageFileName.Contains("_annotation.png")).ToList();
                
                   foreach(var dbImage in dbImages)
                    {
                        db.tbFormDataElementImage.Remove(dbImage);
                    }

                    if (annots.Count() > 0)
                    {                        
                        foreach (tbFormDataElementImageAnnotation Annot in annots)
                        {
                            db.tbFormDataElementImageAnnotation.Remove(Annot);
                        }

                        db.SaveChanges();
                    }

                 }

                if (tbFormDataEl == null)
                {

                    //insert the normal image
                }
                else
                {

                    tbFormDataEl.FieldValue = imgName;
                    tbFormDataEl.DateUpdated = DateTime.Now;
                    db.SaveChanges();
                    saveImages(imgName, imgFileName, docId, tbFormDataEl.RowID, photo);
                }


            }

            using (ApplicationDbContext db = new ApplicationDbContext())
            {
                tbFormData tbForm = db.tbFormData.Where(itm => itm.DocumentId == docId).FirstOrDefault();
                Boolean IsSuccessful = db.SEM_sp_Upsert_Record_Data(tbForm.RowID, tbForm.UserID, tbForm.FormID, Guid.NewGuid(), 1);
            }

            return Ok();
        }


        void saveImages(string imgName, string imgFileName, string docId, Guid RowID, byte[] photo)
        {
            using (ApplicationDbContext db = new ApplicationDbContext())
            {

                var tbFormImg = db.tbFormDataElementImage.Where(img => img.ImageFileName == imgFileName).FirstOrDefault();
                bool isNewImage = false;
                if (tbFormImg == null)
                {
                    tbFormImg = new tbFormDataElementImage();
                    isNewImage = true;
                    tbFormImg.ID = Guid.NewGuid();
                }

                tbFormImg.RowID = RowID;
                tbFormImg.ImageName = imgName;
                tbFormImg.ImageFileName = imgFileName;
                tbFormImg.ImageSource = photo;
                tbFormImg.DateUpdated = DateTime.Now;
                if (isNewImage == true)
                {
                    db.tbFormDataElementImage.Add(tbFormImg);
                }
                db.SaveChanges();

            }
        }


        public IHttpActionResult DeletetbFormDataElementImage(string id, [FromUri] string imageId)
        {
            string imageName = id + "_" + imageId;

            using (ApplicationDbContext db = new ApplicationDbContext())
            {

                List<tbFormDataElementImage> tbFormDataImage = db.tbFormDataElementImage.Where(img => img.ImageName == imageName).ToList();
                if (tbFormDataImage == null)
                {
                    //return NotFound();
                }
                foreach (tbFormDataElementImage img in tbFormDataImage)
                {
                    db.tbFormDataElementImage.Remove(img);
                }

                if (tbFormDataImage != null)
                {
                    Guid ImageRowID = tbFormDataImage.FirstOrDefault().RowID;

                    List<tbFormDataElementImageAnnotation> annots = db.tbFormDataElementImageAnnotation.Where(itm => itm.rowID == ImageRowID).ToList();

                    if (annots.Count() > 0)
                    {
                        foreach (tbFormDataElementImageAnnotation Annot in annots)
                        {
                            db.tbFormDataElementImageAnnotation.Remove(Annot);
                        }

                        db.SaveChanges();
                    }
                }                    

                tbFormDataElement tbFormData = db.tbFormDataElement.Where(row => row.FieldValue == id && row.DocumentId == id).FirstOrDefault();

                if (tbFormData != null)
                {
                    db.tbFormDataElement.Remove(tbFormData);
                }
                db.SaveChanges();

            }

            return Ok();
        }

    }

}
