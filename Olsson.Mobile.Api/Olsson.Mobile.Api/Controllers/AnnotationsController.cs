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
using Olsson.Mobile.Api.Models;
using Olsson.Mobile.Api.Services;

namespace Olsson.Mobile.Api.Controllers
{
    [Authorize]
    public class AnnotationsController : ApiController
    {
        private ApplicationDbContext db = new ApplicationDbContext();

        // GET: api/Annotations
        public IQueryable<tbFormDataElementImageAnnotation> GetAnnotations()
        {


            return db.tbFormDataElementImageAnnotation;
        }

        // GET: api/Annotations/5
        [ResponseType(typeof(List<tbFormDataElementImageAnnotation>))]
        public IHttpActionResult GetAnnotation(Guid id, [FromBody] string[] publish)
        {

            List<tbFormDataElementImageAnnotation> annotationList = db.tbFormDataElementImageAnnotation.Where(itm => itm.rowID == id).ToList();

            if (annotationList == null)
            {
                return NotFound();
            }

            return Ok(annotationList);
        }

        // GET: api/Annotations/5
        [ResponseType(typeof(tbFormDataElementImage))]
        public IHttpActionResult GetAnnotation(string id, [FromUri] string fieldname)
        {
            //string docid = "20160722143559";
            //string fieldname = "15";
            using (ApplicationDbContext db = new ApplicationDbContext())
            {
                Guid rowid = db.tbFormDataElement.Where(row => row.DocumentId == id && row.FieldName == fieldname).FirstOrDefault().RowID;                

                tbFormDataElementImage dbImage = null;
                dbImage = db.tbFormDataElementImage.Where(row => row.RowID == rowid && row.ImageFileName.Replace(row.ImageName, "") == "_large.png").FirstOrDefault();

                if (dbImage != null)
                {
                    return Ok(dbImage);
                }
                else
                {
                    return null;
                }

            }
        }


        // PUT: api/Annotations/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutAnnotation(Guid id, tbFormDataElementImageAnnotation annotation)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != annotation.id)
            {
                return BadRequest();
            }

            db.Entry(annotation).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!AnnotationExists(id))
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

        // POST: api/Annotations
        [HttpPost]
        [ResponseType(typeof(tbFormDataElementImageAnnotation))]
        public IHttpActionResult PostAnnotation(Guid id, [FromBody] List<tbFormDataElementImageAnnotation> annotations)
        {
            //if (!ModelState.IsValid)
            //{
            //    return BadRequest(ModelState);
            //}

            //db.tbFormDataElementImageAnnotation.Add(annotations);

            tbFormDataElementImageAnnotation dbAnnot;
          
            //Clear out all previous annotations for this image
            using (ApplicationDbContext db = new ApplicationDbContext())
            {
                if (id != null)
                {
                    List<tbFormDataElementImageAnnotation> oldAnnots = db.tbFormDataElementImageAnnotation.Where(row => row.rowID == id).ToList();

                    foreach (var annot in oldAnnots)
                    {
                        dbAnnot = db.tbFormDataElementImageAnnotation.Find(annot.id);
                        db.tbFormDataElementImageAnnotation.Remove(dbAnnot);
                        db.SaveChanges();
                    }
                }
            }

            

            using (ApplicationDbContext db = new ApplicationDbContext())
            {
                if (annotations != null)
                {
                    foreach (var annot in annotations)
                    {
                        //clean annotation of null values 

                        annot.imageName = annot.imageName == null || annot.imageName == string.Empty ? "" : annot.imageName;
                        annot.description = annot.description == null || annot.description == string.Empty ? "" : annot.description;
                        annot.shape = annot.shape == null || annot.shape == string.Empty ? "" : annot.shape;
                        annot.color = annot.color == null || annot.color == string.Empty ? "" : annot.color;
                        annot.size = annot.size == null || annot.size == string.Empty ? "" : annot.size;
                        annot.imageName = annot.imageName == null || annot.imageName == string.Empty ? "" : annot.imageName;

                        //check for new values

                        dbAnnot = db.tbFormDataElementImageAnnotation.Where(row => row.id == annot.id).FirstOrDefault();

                        if (dbAnnot != null)
                        {

                            dbAnnot.rowID = annot.rowID;
                            dbAnnot.xPos = annot.xPos;
                            dbAnnot.yPos = annot.yPos;
                            dbAnnot.imageName = annot.imageName;
                            dbAnnot.color = annot.color;
                            dbAnnot.shape = annot.shape;
                            dbAnnot.description = annot.description;
                            dbAnnot.sequenceID = annot.sequenceID;
                            dbAnnot.title = annot.title;
                            dbAnnot.size = annot.size;
                            dbAnnot.source = annot.source;

                            db.SaveChanges();

                        }
                        else
                        {
                            //Does not exist. Assign guid, and add to database
                            dbAnnot = new tbFormDataElementImageAnnotation()
                            {
                                id = Guid.NewGuid(),
                                rowID = annot.rowID,
                                xPos = annot.xPos,
                                yPos = annot.yPos,
                                imageName = annot.imageName,
                                color = annot.color,
                                shape = annot.shape,
                                description = annot.description,
                                sequenceID = annot.sequenceID,
                                title = annot.title,
                                size = annot.size,
                                source = annot.source
                            };

                            db.tbFormDataElementImageAnnotation.Add(dbAnnot);
                            db.SaveChanges();
                        }

                    }
                }
            }

            return CreatedAtRoute("DefaultApi", "AnnotationsUpdated", "DefaultApi");
            // return CreatedAtRoute("DefaultApi", new { id = annotation.ID }, annotation);
        }



        // POST: api/Annotations
        [ResponseType(typeof(void))]
        [HttpPost]
        public IHttpActionResult PublishAnnotation(Guid id, [FromUri] string fieldname)
        {
            //create annotated image routine
            Guid rowid;
            using (ApplicationDbContext db = new ApplicationDbContext())
            {
              var imgRrows = db.tbFormDataElementImage.Where(row => row.RowID == id && !row.ImageFileName.EndsWith("_annotation.png"));
                if (imgRrows != null)
                {
                    CreateAnnotation createAnnotation = new CreateAnnotation();
                    foreach (var imgRow in imgRrows)
                    {
                        rowid = imgRow.RowID;

                        string imgSize = "";
                        if (imgRow.ImageFileName.EndsWith("_small.png"))
                         {
                            imgSize = "small";
                        }
                        else if (imgRow.ImageFileName.EndsWith("_medium.png"))
                        {
                            imgSize = "medium";
                        } else if (imgRow.ImageFileName.EndsWith("_large.png"))
                        {
                            imgSize = "large";
                        }

                        createAnnotation.CreateAnnotationImage(imgRow.ID, imgSize);

                    }
                    createAnnotation = null;
                    return Ok(true);
                }
                else
                {
                    return Ok(false); 
                }
            }

        
            


        }

        // DELETE: api/Annotations/5
        [ResponseType(typeof(tbFormDataElementImageAnnotation))]
        public IHttpActionResult DeleteAnnotation(Guid id)
        {
            tbFormDataElementImageAnnotation annotation = db.tbFormDataElementImageAnnotation.Find(id);
            if (annotation == null)
            {
                return NotFound();
            }

            db.tbFormDataElementImageAnnotation.Remove(annotation);
            db.SaveChanges();

            return Ok(annotation);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool AnnotationExists(Guid id)
        {
            return db.tbFormDataElementImageAnnotation.Count(e => e.id == id) > 0;
        }
    }
}