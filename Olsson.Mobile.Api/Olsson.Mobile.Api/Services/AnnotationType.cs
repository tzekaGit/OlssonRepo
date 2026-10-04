using System;
using System.Drawing;

namespace Olsson.Mobile.Api
{

	public interface AnnotationableType
	{
		void LoadFromString(string str);
		string SaveAsString();
	}

	public class CircleAnnotation : AnnotationableType
	{
		private int _radius;
		
		public int Radius
		{
			get { return _radius; }
		}

		public CircleAnnotation(int radius)
		{
			_radius = radius;
		}

		public void LoadFromString(string str)
		{
			try
			{
				_radius = int.Parse(str);
			}
			catch
			{
				_radius = 3;
			}
		}

		public string SaveAsString()
		{
			return _radius.ToString();
		}
	}

	public class RectangleAnnotation : AnnotationableType
	{
		private int _width;
		private int _height;
		
		public int Width
		{
			get { return _width; }
		}

		public int Height
		{
			get { return _height; }
		}

		public RectangleAnnotation(int width, int height)
		{
			_width = width;
			_height = height;
		}

		public void LoadFromString(string str)
		{
			string[] tmp = str.Split(',');
			try
			{
				_width = int.Parse(tmp[0]);
				_height = int.Parse(tmp[1]);
			}
			catch
			{
				_width = 3;
				_height = 3;
			}
		}

		public string SaveAsString()
		{
			return _width.ToString() + "," + _height.ToString();
		}
	}

	public class ImageAnnotation : AnnotationableType
	{
		private string _fspath;
		
		public Bitmap Image
		{
			get {
					string path = System.Web.HttpContext.Current.Server.MapPath(_fspath);

					if (System.IO.File.Exists(path))
					{
						return new Bitmap(path);
					}
					else
					{
						return null;
					}
				}
		}

		public ImageAnnotation(string path)
		{
			_fspath = path;
		}

		public void LoadFromString(string str)
		{
			_fspath = str;
		}

		public string SaveAsString()
		{
			return _fspath;
		}
	}

	public class TextAnnotation : AnnotationableType
	{
		private string _text;

		public string Text
		{
			get { return _text; }
		}
		
		public TextAnnotation(string text)
		{
			_text = text;
		}

		public void LoadFromString(string str)
		{
			_text = str;
		}

		public string SaveAsString()
		{
			return _text;
		}
	}

	
}
