using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Xml.Linq;
using System.Linq;
using System.Web.UI.HtmlControls;

using Olsson.DataAccess;
using System.Web;
using AjaxControlToolkit;

namespace Olsson.WebLibrary
{
    public abstract class GridViewBase : Page
    {
        public DataFactory dbFactory;
  
        public GridViewRow HeaderRow;
        public TableCell HeaderCell;

        public bool IsFiltered;
        public SelectedGridViewRow SelectedGridviewRow, row;

        public GridViewRow selectedRow ;      //Get the row that contains this button
        public int index ;                               //Get row index
        public int id ;     //Get row promary key
        public GridView HeaderGrid;
        public string DataviewSort;

        protected LinkButton ExtendBtn;
        protected HtmlGenericControl lb1, lbWrapper1;
        protected ModalPopupExtender popup;
        protected GridView MainDataGrid;
        
        protected Label MessageLbl;
        protected ModalPopupExtender popupErrDetails;
        protected Label TrxIDlbl;
        protected Label BatchIDvalueLbl;
        protected Label RowIDLbl;
        protected SqlDataSource MainDataGridSrc, DetailDataGridSrc;
        protected DropDownList PagerDdLst;
        private  HttpCookie httpcookie;

        #region Constructor
        public GridViewBase()
        {
            SelectedGridviewRow = null;
            selectedRow = null;
            index = -1;
            id = -1;

            HeaderGrid = null;
            dbFactory = new DataFactory();
            HeaderRow = null;
            IsFiltered = false;
          
        }
        #endregion

        #region protected void Page_Init(object sender, EventArgs e)
        protected virtual void Page_Init(object sender, EventArgs e)
        {

            httpcookie = Request.Cookies["PageSize"];

            if (!Page.IsPostBack)
            {
                DataviewSort = "";
                //Apply default sorting to the grid
                MainDataGrid.Sort("ID", SortDirection.Descending); // + ",  Card " + GetSortDirection(SortDirection.Ascending.ToString());

                //put the sorting into a session                                
                DataviewSort = MainDataGrid.SortExpression + " " + GetSortDirection(MainDataGrid.SortDirection.ToString());
                //bind the datarid
               

                int[] PagerList = new int[] { 15, 25, 50, 100, 250, 500 };

                PagerDdLst.DataSource = PagerList;
                PagerDdLst.DataBind();
                PagerDdLst.SelectedValue = "15";

                

                if (httpcookie!=null && httpcookie["PageSize"] != null)
                {
                    int selSize = 0;

                    if(int.TryParse(httpcookie["PageSize"].ToString(),  out selSize)){
                        PagerDdLst.SelectedValue = httpcookie["PageSize"];
                    }
                }
                else
                {
                    httpcookie = new HttpCookie(AppSettings.Configuration.AppPath);
                    httpcookie["PageSize"] = PagerDdLst.SelectedValue;
                    httpcookie.Path = AppSettings.Configuration.AppPath;
                    Response.Cookies.Add(httpcookie);


                }
                MainDataGrid.PageSize = int.Parse(PagerDdLst.SelectedValue);

                MainDataGrid.DataBind();
            }

        }
        #endregion

        #region virtual protected void Page_Load(object sender, EventArgs e)
        protected virtual  void Page_Load(object sender, EventArgs e)
        {
            Page.MaintainScrollPositionOnPostBack = true;
            MessageLbl.Text = "";

            if (!Page.IsPostBack)
            {

                DataviewSort = "";
                //put the sorting into a session                                
                DataviewSort = MainDataGrid.SortExpression + " " + GetSortDirection(MainDataGrid.SortDirection.ToString());
                //bind the datarid
                MainDataGrid.DataBind();

            }

        }
        #endregion  

        #region  protected virtual  void Page_PreRender(object sender, EventArgs e)
        protected virtual void Page_PreRender(object sender, EventArgs e)
        {
            if (Page.IsPostBack && IsFiltered == false)
            {
                FilterDataSource(MainDataGrid.PageIndex);
            }

        }
        #endregion

        #region protected virtual  void SaveBtn_Click(object sender, CommandEventArgs e)
        protected virtual void SaveBtn_Click(object sender, CommandEventArgs e)
        {

            SelectedGridviewRow = dbFactory.GetSelectedRow(sender, MainDataGrid);

            selectedRow = SelectedGridviewRow.selectedRow;      //Get the row that contains this button
            index = SelectedGridviewRow.index;                               //Get row index
            id = SelectedGridviewRow.id;     //Get row promary key

            ////TextBox TranCodeTxtBox = (TextBox)selectedRow.FindControl("TranCodeTxtBox");
            //AutoCompleteDropDown TranCodeDdLst = (AutoCompleteDropDown)selectedRow.FindControl("TranCodeDdLst");
            //TextBox DateTxtBox = (TextBox)selectedRow.FindControl("DateTxtBox");
            //TextBox AmountTxtBox = (TextBox)selectedRow.FindControl("AmountTxtBox");
            //TextBox lastDigitsTxtBox = (TextBox)selectedRow.FindControl("lastDigitsTxtBox");
            //TextBox DescriptionTxtBox = (TextBox)selectedRow.FindControl("DescriptionTxtBox");

            //DropDownList ddlDebit = (DropDownList)selectedRow.FindControl("ddlDebit");
            ////DropDownList ddlCardType = (DropDownList)selectedRow.FindControl("ddlCardType");

            //lastFourDigits = lastDigitsTxtBox.Text.Trim();


            //if (lastFourDigits.Length != 4)
            //{
            //    MessageLbl.ForeColor = System.Drawing.Color.Red;
            //    MessageLbl.Text = "Card \"" + lastFourDigits + "\" must be exactly four digits. ";

            //    return;
            //}

            ////Try to Parse date value
            //if (!(DateTime.TryParse(DateTxtBox.Text, out dateValue)))
            //{
            //    MessageLbl.ForeColor = System.Drawing.Color.Red;
            //    MessageLbl.Text = "Unable to insert Date \"" + DateTxtBox.Text + "\". Please check format (Recommended: MM/DD/YYYY)";
            //    return;
            //}

            ////Try to Parse Amount value (to decimal)
            //if (!(Decimal.TryParse(AmountTxtBox.Text, out AmountValue)))
            //{
            //    MessageLbl.ForeColor = System.Drawing.Color.Red;
            //    MessageLbl.Text = "Unable to insert Amount \"" + AmountTxtBox.Text + "\". Please make sure the value is numeric in #.## format.";
            //    return;
            //}

            ////Convert Amount to 2 digits. 
            //AmountValue = Decimal.Round(AmountValue, 2);


            //TranCode = TranCodeDdLst.Text.Trim();
            //if (ddlDebit.SelectedValue == "1")
            //{
            //    Debit = true;
            //}
            //else
            //{
            //    Debit = false;
            //}

            ////CardTypeID = ddlCardType.SelectedValue.ToString();
            //Description = DescriptionTxtBox.Text.Trim();

            //using (dbEntities db = new dbEntities())
            //{
            //    //CC_MASTER card = db.CC_MASTER.Find(Convert.ToInt32(CardTypeID));
            //    //if (card == null)
            //    //{
            //    //    CardType = "";
            //    //}
            //    //else
            //    //{
            //    //    CardType = card.CardType.ToString();
            //    //}

            //    CC_TRX transaction = db.CC_TRX.Find(id);
            //    transaction.Amount = AmountValue;
            //    //transaction.CardType = CardType;
            //    transaction.CardType = transaction.CardType;
            //    transaction.Debit = Debit;
            //    transaction.Description = Description;
            //    transaction.lastDigits = lastFourDigits;
            //    transaction.TrxDate = dateValue;
            //    transaction.TranCode = TranCode;
            //    TrxID = transaction.TrxID;

            //    //2. update selected  item
            //    db.Entry(transaction).State = EntityState.Modified;
            //    db.SaveChanges();

            //    db.INTGR_sp_TRX_TRANSFORM_POST_VALIDATION(TrxID);
            //}



            //MainDataGrid.EditIndex = -1;
            ////3. refresh the grid
            //// MainDataGrid.DataBind();


        }
        #endregion

        #region protected void DeleteBtn_Click(object sender, CommandEventArgs e)
        protected virtual void DeleteBtn_Click(object sender, CommandEventArgs e)
        {
 

        }
        #endregion

        #region   protected void AddBtn_Click(object sender, EventArgs e)
        protected virtual void AddBtn_Click(object sender, EventArgs e)
        {
            popup.Show();
        }
        #endregion

        //#region  protected void ReadyImportBtn_Click(object sender, CommandEventArgs e)
        //protected virtual void ReadyImportBtn_Click(object sender, CommandEventArgs e)
        //{

        //    using (dbEntities db = new dbEntities())
        //    {
        //        CC_TRX trx = db.CC_TRX.Find(Convert.ToInt32(e.CommandArgument));

        //        TrxID = trx.TrxID;
        //        string ReadyImport = trx.ReadyForImport.ToString();
        //        db.INTGR_sp_TRX_TRANSFORM_POST_VALIDATION(TrxID);

        //        CC_TRX trxValidated = db.CC_TRX.Find(Convert.ToInt32(e.CommandArgument));

        //        string batchIDvalid = trxValidated.BatchID;
        //        string rowIDvalid = trxValidated.RowID;

        //        if (ReadyImport.Equals(null))
        //        {
        //            ReadyImport = "False";
        //        }


        //        if ((db.INTGR_tb_DocumentErrorLog.Count(row => row.BatchId == batchIDvalid && row.RowID == rowIDvalid) > 0) && ReadyImport == "False")
        //        {
        //            //Show error.
        //            MessageLbl.ForeColor = System.Drawing.Color.Red;
        //            MessageLbl.Text = "Unable to set transaction as ready for import. Please see errors for more details. ";
        //            return;
        //        }
        //        else
        //        {
        //            //update ReadyToImport 
        //            if (ReadyImport == "False")
        //            {
        //                //update ReadyToImport to 1/true (ready)
        //                trxValidated.ReadyForImport = true;
        //            }
        //            else
        //            {
        //                //update ReadyToImport to 0/false (not ready)
        //                trxValidated.ReadyForImport = false;
        //            }

        //            db.Entry(trxValidated).State = EntityState.Modified;
        //            db.SaveChanges();
        //        }

        //    }


        //    //3. refresh the grid
        //    //  MainDataGrid.DataBind();
        //}
        //#endregion



        //#region protected void ErrorDtlBtn_Click(object sender, CommandEventArgs e)
        //protected virtual void ErrorDtlBtn_Click(object sender, CommandEventArgs e)
        //{
        //    using (dbEntities db = new dbEntities())
        //    {

        //        row = dbFactory.GetSelectedRow(sender, MainDataGrid);
        //        CC_TRX trx = db.CC_TRX.Find(Convert.ToInt32(row.id));

        //        TrxIDlbl.Text = trx.TrxID.ToString();
        //        BatchIDvalueLbl.Text = trx.BatchID.ToString();
        //        RowIDLbl.Text = trx.RowID.ToString();

        //        string DtlSlcCmd = DetailDataGridSrc.SelectCommand + " where BatchID ='" + trx.BatchID.ToString() + "' and RowID = '" + trx.RowID.ToString() + "'";

        //        DetailDataGridSrc.SelectCommand = DtlSlcCmd;
        //    }

        //    BindOnPrerender = true;
        //    popupErrDetails.Show();
        //}
        //#endregion

        #region protected void hidepopup()
        protected virtual void hidepopup()
        {
            popupErrDetails.Hide();
        }
        #endregion

        #region   protected void MainDataGrid_Init(object sender, EventArgs e)
        protected virtual void MainDataGrid_Init(object sender, EventArgs e)
        {
   
        }
        #endregion

        #region  protected void MainDataGrid_RowEditing(object sender, GridViewEditEventArgs e)
        protected virtual void MainDataGrid_RowEditing(object sender, GridViewEditEventArgs e)
        {
            MainDataGrid.EditIndex = e.NewEditIndex;
            MainDataGrid.DataBind();
        }
        #endregion  

        #region  MainDataGrid_RowCreated(object sender, GridViewRowEventArgs e)
        protected virtual void MainDataGrid_RowCreated(object sender, GridViewRowEventArgs e)
        {

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                //Add the headerRow after the header links
                if (e.Row.RowIndex == 0 && HeaderRow != null)
                {
                    MainDataGrid.Controls[0].Controls.AddAt(2, HeaderRow);

                }        
                    
            }
            else if (e.Row.RowType == DataControlRowType.Header || e.Row.RowType == DataControlRowType.EmptyDataRow)
            {
                HeaderRow = CreateHeaderRowFilter(sender);
            }


            if (e.Row.RowType == DataControlRowType.EmptyDataRow)
            {
                //add header row, generated on the header row type
                if (HeaderRow != null)
                {
                    //MainDataGrid.Controls[0].Controls.AddAt(1, HeaderRow);
                    //HeaderRow = null;
                }
            }
        }
        #endregion

        #region  protected void MainDataGrid_RowDataBound(object sender, GridViewRowEventArgs e)
        protected virtual void MainDataGrid_RowDataBound(object sender, GridViewRowEventArgs e)
        {

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                //Reset the filter text on the dynamic creted header after the postback
                if (e.Row.RowIndex == 0 && Page.IsPostBack)
                {
                    SetHeaderFilterText();
                }
              

            }


        }
        #endregion

        #region protected void  HeaderFilter_TextChanged(object sender, EventArgs e) 
        protected virtual void HeaderFilter_TextChanged(object sender, EventArgs e)
        {
            var objTextBox = (TextBox)sender;

            if (objTextBox != null)
            {
                string srcColumn = objTextBox.ID.Replace("_FilterTxtBox", ""); //get the column from the textbox id
                string filterStr = objTextBox.Text;

                //set/update filter parameters 
                if (MainDataGridSrc.SelectParameters[srcColumn] == null)
                {
                    // add filter paramterer;
                    Parameter filterPar = new Parameter(srcColumn, DbType.String, filterStr);
                    filterPar.ConvertEmptyStringToNull = false;
                    MainDataGridSrc.SelectParameters.Add(filterPar);
                }
                else
                {
                    //update parameter default values;
                    MainDataGridSrc.SelectParameters[srcColumn].DefaultValue = filterStr;
                }
                MainDataGrid.PageIndex = 0;
                //filter the data 
                FilterDataSource(0);
            }
        }

        #endregion

        #region protected void  HeaderFilter_TextChanged(object sender, EventArgs e) 
        protected virtual void PagerSize_Changed(object sender, EventArgs e)
        {
            if (httpcookie != null) { 
            httpcookie["PageSize"] = PagerDdLst.SelectedValue;
            Response.Cookies.Add(httpcookie);
                MainDataGrid.PageSize = int.Parse(PagerDdLst.SelectedValue);
                MainDataGrid.DataBind();
            }
          
        }
        #endregion

        #region protected void MainDataGrid_Sorting(object sender, GridViewSortEventArgs e)
        protected virtual void MainDataGrid_Sorting(object sender, GridViewSortEventArgs e)
        {
            //Apply sorting from header columns only
            if (e.SortExpression != "" && Page.IsPostBack)
            {

                //filter the data before sorting
                FilterDataSource(MainDataGrid.PageIndex);

                DataviewSort = e.SortExpression + " " + GetSortDirection(e.SortDirection.ToString());

                //DON'T USE DATABIND HERE!
            }



        }
        #endregion

        #region protected void MainDataGrid_PageIndexChanging(object sender, GridViewPageEventArgs e)
        protected virtual void MainDataGrid_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
    
        }
        #endregion  


        #region protected void ExtendBtn_Click(object sender,  EventArgs e)
        protected virtual void ExtendBtn_Click(object sender, EventArgs e)
        {
               if (ExtendBtn.Text == "Close")
            {
                lb1.Attributes.Remove("class");
                lbWrapper1.Attributes.Remove("class");
                ExtendBtn.Text = "Extend";
                ExtendBtn.CssClass = "full-screen";
                return;
            }


            Page.ClientScript.RegisterStartupScript(this.GetType(), "anchor", "location.hash = '#ld1';", true);
            lb1.Attributes.Add("class", "lb");
            lbWrapper1.Attributes.Add("class", "popup");
            ExtendBtn.Text = "Close";
            ExtendBtn.CssClass = "normal-screen";
        }
        #endregion

        #region  protected void btnExcel_Click(object sender, EventArgs e)
        protected virtual void btnExcel_Click(object sender, EventArgs e, string fileName)
        {
            FilterDataSource(MainDataGrid.PageIndex);
            MainDataGrid.DataBind();
            using (DataExpoprt dbExport = new DataExpoprt())
            {
                dbExport.ExportToExcel(MainDataGridSrc, fileName);
            }
        }
        #endregion

        #region  private GridViewRow CreateHeaderRowFilter(object sender)
        public virtual GridViewRow CreateHeaderRowFilter(object sender)
        {

            HeaderGrid = (GridView)sender;
            HeaderRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Normal);

            return HeaderRow;

        }
        #endregion

        #region GetSortDirection(string sSortDirCmd)
        public virtual string GetSortDirection(string sSortDirCmd)
        {
            string sSortDir = ""; ;
            if ((SortDirection.Ascending.ToString() == sSortDirCmd))
            {
                sSortDir = "ASC";
            }

            if ((SortDirection.Descending.ToString() == sSortDirCmd))
            {
                sSortDir = "DESC";
            }
            return sSortDir;
        }
        #endregion

        #region private void SetHeaderFilterText()
        public virtual void SetHeaderFilterText()
        {
            //the filter row is after the pager row.
            int row = 2;

            GridViewRow headRow = (GridViewRow)MainDataGrid.Controls[0].Controls[row];
            TextBox filterTxtBox;

            if (headRow != null)
            {
                foreach (TableCell tblCell in headRow.Cells)
                {
                    if (tblCell.Controls.Count > 0 && (tblCell.Controls[0] is TextBox))
                    {
                        filterTxtBox = (TextBox)tblCell.Controls[0];
                        string UniqueID = filterTxtBox.UniqueID;

                        filterTxtBox.Text = Request.Form[UniqueID];
                    }

                }
            }
        }
        #endregion

        #region private void FilterDataSource()
        public virtual void FilterDataSource(int pageIndex)
        {

            if (MainDataGridSrc.SelectParameters.Count == 0)
            {
                return;
            }
            string SlcCommand = MainDataGridSrc.SelectCommand;
            Parameter param;
            if (!SlcCommand.ToLower().Contains(" where "))
            {
                //add the where clause
                SlcCommand += " where ";
            }

            for (int i = 0; i < MainDataGridSrc.SelectParameters.Count; i++)
            {
                param = MainDataGridSrc.SelectParameters[i];
                if (i > 0)
                {
                    SlcCommand += " and ";
                }
                SlcCommand += string.Format("( @{0}='' or {0} like  @{0} + '%') ", param.Name);
            }
            MainDataGridSrc.SelectCommand = SlcCommand;
            //get the new grid data
   



            IsFiltered = true;
        }
        #endregion

        #region private DataView CurrentDtView(int pageIndex)
        public virtual DataView CurrentDtView(int pageIndex)
        {
            DataView AllMainSrcData = (DataView)MainDataGridSrc.Select(DataSourceSelectArguments.Empty) as DataView;

            if (DataviewSort != null)
            {
                AllMainSrcData.Sort = DataviewSort.ToString();
            }
            int pageNum = pageIndex;
            int pageSize = MainDataGrid.PageSize;
            int AllMainSrcCount = AllMainSrcData.Count;
            int startIndex = pageNum * pageSize;
            int endIndex = AllMainSrcCount >= startIndex + pageSize ? startIndex + pageSize : AllMainSrcCount - startIndex;
            if (startIndex == endIndex)
            {
                return null;
            }
            DataTable dt = AllMainSrcData.ToTable();
            DataTable dtPage = dt.Rows.Cast<System.Data.DataRow>().Skip(startIndex).Take(endIndex).CopyToDataTable();
            DataView MainGridDt = new DataView(dtPage);
            AllMainSrcData = null;
            return MainGridDt;

        }
        #endregion

    }
}
