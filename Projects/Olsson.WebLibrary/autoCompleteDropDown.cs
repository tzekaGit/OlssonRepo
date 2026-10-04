using System;
using System.ComponentModel;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace Olsson.WebLibrary
{
    [DefaultProperty("Text")]
    [ToolboxData("<{0}:AutoCompleteDropDown runat=server></{0}:AutoCompleteDropDown>")]
    public class AutoCompleteDropDown : TextBox
    {
        public AutoCompleteDropDown()
        {
 
        }
        protected override void OnInit(EventArgs e)
        {
            this.ID = ID;
           if (!this.CssClass.ToLower().ToLower().Contains("auto-complete"))
            {
                this.CssClass = "auto-complete " + this.CssClass;
            }

            this.Attributes.Add("onKeyDown", AutoCompleteOnChange + "(this," + AutoCompleteItems.ToString() + ",'" + DropdownColumns  + "','" + ColumnHeaderText  + "','" + DataValueKey + "','" + AutoCompleteWsMethod + "')");
            this.Attributes.Add("onKeyUp", AutoCompleteOnKeyUp + "(this, " + AutoCompleteItems.ToString() + ",'" + DropdownColumns + "','" + ColumnHeaderText + "','" + DataValueKey + "','" + AutoCompleteWsMethod + "')");
            this.Attributes.Add("onClick", AutoCompleteOnKeyUp + "(this, " + AutoCompleteItems.ToString() + ",'" + DropdownColumns + "','" + ColumnHeaderText + "','" + DataValueKey + "','" + AutoCompleteWsMethod + "')");
        }

        public override string Text
        {
            get
            {
                return base.Text;
            }
            set
            {
                base.Text = value;
            }
        }


        [Bindable(true)]
        [Category("Appearance")]
        [DefaultValue("")]
        [Localizable(true)]
        public string AutoCompleteText { get; set; }

        [Bindable(true)]
        [Category("Appearance")]
        [DefaultValue("")]
        [Localizable(true)]
        public string AutoCompleteOnChange { get; set; }

        [Bindable(true)]
        [Category("Appearance")]
        [DefaultValue("")]
        [Localizable(true)]
        public string AutoCompleteOnKeyUp { get; set; }

         [Bindable(true)]
        [Category("Appearance")]
        [DefaultValue("")]
        [Localizable(true)]
        public int AutoCompleteItems{ get; set;}

        [Bindable(true)]
        [Category("Appearance")]
        [DefaultValue("")]
        [Localizable(true)]
        public string AutoCompleteWsMethod { get; set; }

        [Bindable(true)]
        [Category("Appearance")]
        [DefaultValue("")]
        [Localizable(true)]
        public string DropdownColumns { get; set; }

        [Bindable(true)]
        [Category("Appearance")]
        [DefaultValue("")]
        [Localizable(true)]
        public string DataValueKey { get; set; }

        [Bindable(true)]
        [Category("Appearance")]
        [DefaultValue("")]
        [Localizable(true)]
        public string ColumnHeaderText { get; set; }
        


        protected override void Render(HtmlTextWriter writer)
        {
            writer.Write("<div class=\"auto-complete-wrapper\">"); 
            base.Render(writer);
             string onclick = "onClick=\"" + AutoCompleteOnKeyUp + "($('#" + this.ID + "'), " + AutoCompleteItems.ToString() + ", '" + DropdownColumns + "', '" + ColumnHeaderText + "', '" + DataValueKey + "', '" + AutoCompleteWsMethod + "')\"";

            if (this.CssClass.Trim() == "auto-complete")
            {
                writer.Write("<span class=\"auto-complete-span\" " + onclick  + "> &nbsp;</span>");
                writer.Write("<div id=\"" + this.ID.ToString() + "_DdList\" class=\"auto-complete-div\" style=\"visibility: visible; position: absolute; top: 30px; \"></div>");
            }
            else
            {
                writer.Write("<span class=\"auto-complete-span " + this.CssClass.Replace("auto-complete ", "") + "-span\"" + onclick + ">&nbsp;</span>");
                writer.Write("<div id=\"" + this.ID.ToString() + "_DdList\" class=\"auto-complete-div " + this.CssClass.Replace("auto-complete ", "") + "-div\" style=\"visibility: visible; position: absolute; top: 30px; \"></div>");
            }
           writer.Write("</div>");

        }

        protected override void RenderContents(HtmlTextWriter output)
        {
          
        }


    }

}
