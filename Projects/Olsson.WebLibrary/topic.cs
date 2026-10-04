using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using Olsson.DataAccess.Entities;


namespace Olsson.WebLibrary
{
    [DefaultProperty("Text")]
    [ToolboxData("<{0}:Topic runat=server></{0}:Topic>")]
    public class TopicContent : Literal
    {
        public TopicContent()
        {


            // this.Load += Page_Load;

        }

        static string topicTitle = "";
        static string topicName = "";
        static int topicLength = 0;
        static string topicPrefix = "";

        public StringBuilder result;


        [Bindable(true)]
        [Category("Appearance")]
        [DefaultValue("")]
        [Localizable(true)]
        public string TopicName { get; set; }


        [Bindable(true)]
        [Category("Appearance")]
        [DefaultValue("")]
        [Localizable(true)]
        public string TopicTitle { get; set; }



        [Bindable(true)]
        [Category("Appearance")]
        [DefaultValue("")]
        [Localizable(true)]
        public string TopicText { get; set; }

        public int TopicID { get; set; }

        protected override void Render(HtmlTextWriter writer)
        {

            return;
            // Response.Write("NavTopic="+ NavTopic);
            if (TopicID > 0)
            {

                    result = new StringBuilder();
                    using (dbEntities db = new dbEntities())
                    {
                    Topic topic = db.Topics.Find(TopicID);

                        TopicTitle = topic.TopicTitle;
                        TopicName = topic.TopicName;
                        TopicText = topic.TopicText;
                        result.Append("<h2>");
                        result.Append(TopicTitle);
                        result.Append("</h2>");
                        result.Append("<div>");
                        result.Append(TopicText);
                        result.Append("</div>");


                }
                   


                    writer.Write(result.ToString());
                    result = null;
                }

            }


        }

}
