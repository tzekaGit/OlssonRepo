using System;
using System.Drawing;

namespace Olsson.Mobile.Api
{
	public class AnnotationManager
	{
		public static AnnotationableType CreateByID(string typeid)
		{
			switch(typeid)
			{
                case "0": case "rectangular":
					return new RectangleAnnotation(15, 15);

				case "1": case "circle":
                    return new CircleAnnotation(15);

				case "2": case "text":
                    return new TextAnnotation("TEXT");

				case "3": case "bitmap":
                    return new ImageAnnotation("plus.bmp");

				default:
					return null;
			}
		}

		public static void Draw(Graphics g, int x, int y, AnnotationableType annotation)
		{
			if (annotation is RectangleAnnotation)
			{
				Draw(g, x, y, (RectangleAnnotation) annotation);
			}
			else if (annotation is CircleAnnotation)
			{
				Draw(g, x, y, (CircleAnnotation) annotation);
			}
			else if (annotation is TextAnnotation)
			{
				Draw(g, x, y, (TextAnnotation) annotation);
			}
			else if (annotation is ImageAnnotation)
			{
				Draw(g, x, y, (ImageAnnotation) annotation);
			}
		}

		public static void Draw(Graphics g, int x, int y, RectangleAnnotation rect)
		{
			Pen pen = new Pen(Color.Red, 1.5f);
			g.DrawRectangle(pen, x, y, rect.Width, rect.Height);
		}

		public static void Draw(Graphics g, int x, int y, CircleAnnotation circle)
		{
			
			SolidBrush brush = new SolidBrush(Color.Red);
			g.FillEllipse(brush, x, y, circle.Radius*2, circle.Radius*2);
		}

		public static void Draw(Graphics g, int x, int y, TextAnnotation text)
		{
			SolidBrush brush = new SolidBrush(Color.Green);

			string familyName = "Tahoma";

			Font font;
			font = new Font(familyName, 12F, FontStyle.Bold);

			StringFormat format = new StringFormat();
			format.Alignment = StringAlignment.Center;
			format.LineAlignment = StringAlignment.Center;

			g.DrawString(text.Text, font, brush, 
				x, y, format);
		}

		public static void Draw(Graphics g, int x, int y, ImageAnnotation image)
		{
			if (image.Image != null)
			{
				g.DrawImage(image.Image, x, y);
			}
		}
	}
}
