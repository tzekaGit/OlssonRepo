using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Olsson.Mobile.Api.Services;
using Olsson.Mobile.Api.Models;
using System.Drawing;

namespace Olsson.Mobile.Api.Controllers
{
    public class AnnotationMVCController: Controller
    {
        // GET: CircleAnnotation
        public ActionResult Index()
        {

            return View();
        }

        // GET: CircleAnnotation/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult Image()
        {
            Guid RowID = Guid.Empty;
            string fieldname = "15";
            string imagesize = "large";
          
            using (ApplicationDbContext db = new ApplicationDbContext())
            {
               
                Guid rowid = db.tbFormDataElement.Where(row => row.RowID == RowID).FirstOrDefault().RowID;
                ViewBag.Title = "Annotation Page";
                ViewBag.MyLabel = "Hello";

                CreateAnnotation createAnnotation = new CreateAnnotation();
                 createAnnotation.CreateAnnotationImage(RowID, imagesize);
                createAnnotation = null;
                //Return as file result
                var bitmapBytes  = db.tbFormDataElementImage.Where(row => row.RowID == rowid && row.ImageFileName.Replace(row.ImageName, "") == "_" + imagesize  + "_annotation.png").FirstOrDefault().ImageSource;

                return File(bitmapBytes, "image/jpeg"); 
            }

            

        }

        // GET: CircleAnnotation/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: CircleAnnotation/Create
        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: CircleAnnotation/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: CircleAnnotation/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: CircleAnnotation/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: CircleAnnotation/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
