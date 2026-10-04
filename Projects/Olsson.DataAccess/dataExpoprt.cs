using System;
using System.Web.UI.WebControls;
using System.Web;
using System.IO;
using System.Web.UI;
using System.Globalization;
using System.Threading;

namespace Olsson.DataAccess
{
    public class DataExpoprt:IDisposable
    {
        public void ExportToExcel(SqlDataSource MainDataGridSrc, string fileName)
        {

            GridView GrVew = new GridView();
            GrVew.DataSource = MainDataGridSrc;
            HttpContext.Current.Response.Write("<style> TD  mso-number-format:@;} </style>");
            HttpContext.Current.Response.ClearContent();
            HttpContext.Current.Response.Buffer = true;
            HttpContext.Current.Response.AddHeader("content-disposition", string.Format("attachment; filename={0}", fileName));
            HttpContext.Current.Response.ContentType = "application/vnd.xls";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            GrVew.AllowPaging = false;
            GrVew.DataBind();
            CultureInfo CurrentCI = Thread.CurrentThread.CurrentCulture;
            Thread.CurrentThread.CurrentCulture = new CultureInfo("en-US");

            //Change the Header Row back to white color
            GrVew.HeaderRow.Style.Add("background-color", "#FFFFFF");
            GrVew.HeaderRow.Style.Add("color", "#FFFFFF");
            //Applying stlye to gridview header cells
            for (int i = 0; i < GrVew.HeaderRow.Cells.Count; i++)
            {
                GrVew.HeaderRow.Cells[i].Style.Add("background-color", "#507CD1");
                GrVew.HeaderRow.Cells[i].Style.Add("color", "#FFFFFF");

            }
            int j = 1;
            //This loop is used to apply stlye to cells based on particular row
            foreach (GridViewRow gvrow in GrVew.Rows)
            {
          
                // gvrow.BackColor = Color.White;
                if (j <= GrVew.Rows.Count)
                {
                    if (j % 2 != 0)
                    {
                        for (int k = 0; k < gvrow.Cells.Count; k++)
                        {
                            gvrow.Cells[k].Text += "&nbsp;";
                            gvrow.Cells[k].Style.Add("background-color", "#EFF3FB");
                        }
                    }
                    else
                    {
                        for (int k = 0; k < gvrow.Cells.Count; k++)
                        {
                            gvrow.Cells[k].Text += "&nbsp;";
                        }
                    }

                }
                j++;
            }
            GrVew.RenderControl(htw);
            HttpContext.Current.Response.Write(sw.ToString());
            HttpContext.Current.Response.End();
        }

        #region IDisposable Support
        private bool disposedValue = false; // To detect redundant calls

        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects).
                }

                // TODO: free unmanaged resources (unmanaged objects) and override a finalizer below.
                // TODO: set large fields to null.

                disposedValue = true;
            }
        }

        // TODO: override a finalizer only if Dispose(bool disposing) above has code to free unmanaged resources.
        // ~DataExpoprt() {
        //   // Do not change this code. Put cleanup code in Dispose(bool disposing) above.
        //   Dispose(false);
        // }

        // This code added to correctly implement the disposable pattern.
        void IDisposable.Dispose()
        {
            // Do not change this code. Put cleanup code in Dispose(bool disposing) above.
            Dispose(true);
            // TODO: uncomment the following line if the finalizer is overridden above.
            // GC.SuppressFinalize(this);
        }
        #endregion
    }
}
