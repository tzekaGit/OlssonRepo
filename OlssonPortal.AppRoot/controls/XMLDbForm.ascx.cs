
using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.ComponentModel;
using System.Data.SqlClient;

using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

using System.Xml;
using System.Xml.Xsl;
using System.Xml.XPath;
using System.IO;

using System.Configuration;

namespace Olsson.WebApp.Controls
{
    public partial class XMLDbForm : UserControl
    {
        string formLblColWidth = "175px";
        string ActionID = "";
        protected void Page_Load(Object sender , EventArgs e)
        {
            SqlCommand sqlComm = new SqlCommand();
            string sqlConn = ConfigurationManager.ConnectionStrings["SEMConnectionString"].ToString();
            var ID = Request["id"];
            int FormID = 0;
            ActionID = Request["ActionID"] == null ? "" : Request["ActionID"].ToString();
            if (int.TryParse(ID, out FormID)){
              
                if (FormID == 0)
                {
                    return;
                }
            }


           string xml = "";
           using (SqlConnection objConn = new SqlConnection(sqlConn))
            {

                objConn.Open();
                sqlComm.Connection = objConn;
                sqlComm.CommandText = "SEM_sp_FormXMLTransformation";
                sqlComm.CommandType = CommandType.StoredProcedure;

                sqlComm.Parameters.AddWithValue("@FormID", FormID);
                //sqlComm.Parameters.AddWithValue("@ActionID", ActionID);
                var src = sqlComm.ExecuteScalar();
                // Response.Write("src," + src);
                if (src != null && src.ToString().Length > 0)
                {
                    xml = src.ToString();
                }
                else
                {
                    Response.Write("no form found");
                    return;
                }

            }
            //Response.Write(xml);
            //return;
            string xslSource = Server.MapPath("~/") + @"App_Data\xsl_template\Html5FormTemplate.xslt";
            string xmlSource = xml; // MapPath("~/") + @"app_data\xmlPackages\form_2.xml";
          

            XslCompiledTransform xmltransform = new XslCompiledTransform();
            System.Xml.XmlDocument myDoc = new System.Xml.XmlDocument();
            XsltArgumentList args = new XsltArgumentList();

            xmlSource = ApplyFormStyle(xmlSource);
            //
            //myDoc.Load(xmlSource);
            myDoc.LoadXml(xmlSource);

            System.IO.MemoryStream txt = new System.IO.MemoryStream();
            System.Xml.XmlTextWriter output = new System.Xml.XmlTextWriter(txt, System.Text.Encoding.UTF8);

            xmltransform.Load(xslSource);

            xmltransform.Transform(myDoc, args, output, null);
            output.Flush();
            txt.Position = 0;

            StreamReader sr = new StreamReader(txt);
            string result = sr.ReadToEnd();
            result = result.ToString().Replace("xmlns:asp=\\\"remove\\\"", "").Replace("<", "<").Replace(">", ">");
            result = result.ToString().Replace("xmlns:hyper=\\\"remove\\\"", "").Replace("<", "<").Replace(">", ">");
            sr.Close();
            Control ctrl = Page.ParseControl(result);
            PhlForm.Controls.Add(ctrl);

        }

        private string ApplyFormStyle(string xmlSource)
        {
            xmlSource = xmlSource.Replace("#LABELSTYLE#", "width:" + formLblColWidth);
            xmlSource = xmlSource.Replace("#REQUIREDSTYLE#", "width:10px;");
            xmlSource = xmlSource.Replace("#FIELDSTYLE#", "width:auto;");
            xmlSource = xmlSource.Replace("#HELPSTYLE#", "width:10px;");
            xmlSource = xmlSource.Replace("#ERRORSTYLE#", "width:20px;");
            //Response.Write(xmlSource)
            return xmlSource;
        }

    }
}

