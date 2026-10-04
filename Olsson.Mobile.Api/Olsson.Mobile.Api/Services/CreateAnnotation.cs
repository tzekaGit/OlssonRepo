using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Olsson.Mobile.Api.Models;
using System.Drawing.Imaging;


namespace Olsson.Mobile.Api.Services
{
    public struct Mark {
        public string Name;
        public string Size;
        public double Width;
        public double Height;
        public Single FontSize;
        public string FontFamily;
    }

    public struct MarkCorrection
    {
        public int xCorr;
        public int yCorr;
        public int txtXCorr;
        public int txtYCorr;

    }

    public class CreateAnnotation
    {

        public CreateAnnotation()
        {
        }

        public byte[] CreateAnnotationImage(Guid id, string imageSize)
        {
          

            tbFormDataElementImage tbFormImg;
            byte[] bitmapBytes = null;
            using (ApplicationDbContext db = new ApplicationDbContext())
            {
                //get the form image
                tbFormImg = db.tbFormDataElementImage.Where(row => row.ID == id).FirstOrDefault();

                //get the annotation list of the image
                List<tbFormDataElementImageAnnotation> annotationList = db.tbFormDataElementImageAnnotation.Where(itm => itm.rowID == tbFormImg.RowID).ToList();

                CreateAnnotation createAnnotation = new CreateAnnotation();
                Mark mark = new Mark();
                mark.Size = imageSize;
                if (imageSize == "small")
                {
                    mark.Width = -20;
                    mark.Height = 15;
                    mark.FontSize = 10F;
                    mark.FontFamily = "Arial";
                }
                else if (imageSize == "medium")
                    {
                        mark.Width = -10;
                        mark.Height = 10;
                        mark.FontSize = 12F;
                        mark.FontFamily = "Arial";
                    }

                else if (imageSize == "large")
                {
                    mark.Width = 15;
                    mark.Height = 17;
                    mark.FontSize = 14F;
                    mark.FontFamily = "Arial";
                }
               bitmapBytes = createAnnotation.PinAnnotations(tbFormImg.ImageSource, annotationList, mark);
            }

            //save image in the database
            using (ApplicationDbContext db = new ApplicationDbContext())
            {
                string imgFileName = "_" + imageSize + "_annotation.png";
                //check if it exists
                tbFormDataElementImage tbFormdbElementImg = db.tbFormDataElementImage
                    .Where(row => row.RowID == tbFormImg.RowID && row.ImageFileName.Replace(row.ImageName, "") == imgFileName)
                    .FirstOrDefault();

                if (tbFormdbElementImg != null && bitmapBytes != null)
                {
                    tbFormdbElementImg.ImageSource = bitmapBytes;
                    tbFormdbElementImg.DateUpdated = DateTime.Now;
                    db.SaveChanges();
                }
                else
                {
                    tbFormdbElementImg = new tbFormDataElementImage()
                    {
                        ID = Guid.NewGuid(),
                        ImageName = tbFormImg.ImageName,
                        ImageFileName = tbFormImg.ImageName + "_"+ imageSize + "_annotation.png",
                        ImageSource = bitmapBytes,
                        RowID = tbFormImg.RowID,
                        DateUpdated = DateTime.Now,
                        

                    };
                    db.tbFormDataElementImage.Add(tbFormdbElementImg);
                    db.SaveChanges();
                }

            }

            return bitmapBytes;

        }
        private byte[] PinAnnotations(byte[] imageMapData, List<tbFormDataElementImageAnnotation> annotations, Mark mark)
        {
            Bitmap bitmap;
            using (var ms = new MemoryStream(imageMapData))
            {
                bitmap = new Bitmap(ms);
            }

            Graphics g = Graphics.FromImage(bitmap);
            g.SmoothingMode = SmoothingMode.AntiAlias;

            // Draw each annotation object of MarkableType, ; separated

            int width = bitmap.Width;
            int height = bitmap.Height;
            ArrayList Pins = new ArrayList(annotations.Count());

            CircleAnnotation circlPin = new CircleAnnotation(15);
            Pins.Add(circlPin);
            RectangleAnnotation rectPin = new RectangleAnnotation(15, 15);
            Pins.Add(rectPin);
            TextAnnotation txtPin = new TextAnnotation("");
            Pins.Add(txtPin);

            foreach (var annotation in annotations)
            {

                // Get x, y
                double? xPos = annotation.xPos==null ?0: annotation.xPos;
                double? yPos = annotation.yPos == null ? 0 : annotation.yPos;

                int x = (int)(xPos * width);
                int y = (int)(yPos * height);
  

                // The number of marks is i
                SolidBrush brush = new SolidBrush(Color.Yellow);
           
                string familyName = mark.FontFamily;
                Font font = new Font(familyName, mark.FontSize, FontStyle.Bold);

                StringFormat format = new StringFormat();
                format.Alignment = StringAlignment.Center;
                format.LineAlignment = StringAlignment.Center;

                MarkCorrection markCorr = new MarkCorrection();
                markCorr.xCorr = (int)mark.Width / 2;
                markCorr.yCorr = (int)mark.Height * 2;
                // Draw the annotation itself
                // Get type
                string typeid = annotation.shape;

                // Get the rest as the arguments
                string param = string.Empty;

                // Create MarkableType oject from its string form
                AnnotationableType pin = AnnotationManager.CreateByID(typeid);
                AnnotationableType pinText = AnnotationManager.CreateByID("2");


                AnnotationManager.Draw(g, x + markCorr.xCorr, y - markCorr.yCorr, (AnnotationableType)Pins[0]);

                markCorr.xCorr = Convert.ToInt32(mark.Width * 1.5);
                markCorr.yCorr = (int)mark.Height;

                // Draw an identifier
                if (mark.Size == "small"){
                    markCorr.xCorr += 35;
                }
                if (mark.Size == "medium")
                {
                    markCorr.xCorr += 25;
                    markCorr.yCorr += -7;
                }

                g.DrawString(annotation.sequenceID.ToString(), font, brush, new Point(x + markCorr.xCorr, y - markCorr.yCorr), format);
           
                brush.Dispose();
            }

            // Send the bitmap to the output stream
   
         

            using (MemoryStream memStream = new MemoryStream())
            {
                bitmap.Save(memStream, ImageFormat.Jpeg);
                return memStream.ToArray();
            }
    
       
        }

       
    }


}
