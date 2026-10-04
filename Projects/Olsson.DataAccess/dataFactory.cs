using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Olsson.DataAccess
{
    public class DataFactory
    {

        public SqlDataReader SelectSqlReader(SqlCommand sqlComm)
        {
            using (SqlConnection sqlConn = new SqlConnection(AppSettings.Configuration.dbConnection))
            {
                sqlConn.Open();
                sqlComm.Connection = sqlConn;
                SqlDataReader sqlReader = sqlComm.ExecuteReader();
                return sqlReader;
            }

        }

        public DataTable SelectDataTbl(SqlCommand sqlCmd)
        {
            DataTable dataTbl = new DataTable();
            using (SqlConnection sqlConn = new SqlConnection(AppSettings.Configuration.dbConnection))
            {
                sqlConn.Open();
                sqlCmd.Connection = sqlConn;
                using (var adapter = new SqlDataAdapter(sqlCmd))
                {
                    adapter.Fill(dataTbl);
                }
            }

            return dataTbl;

        }

        public DataRow UpdateDataTbl(SqlCommand sqlCmd, DataTable dataTbl)
        {

            using (SqlConnection sqlConn = new SqlConnection(AppSettings.Configuration.dbConnection))
            {
                sqlConn.Open();
                sqlCmd.Connection = sqlConn;
                using (var adapter = new SqlDataAdapter(sqlCmd))
                using (new SqlCommandBuilder(adapter))
                {
                    //insert/update  the data table into the SQL database.
                    adapter.Update(dataTbl);

                    //adapter.FillSchema(dataTbl, System.Data.SchemaType.Source);
                    adapter.Fill(dataTbl);

                }
            }

            return dataTbl.Rows[0];

        }


        public SelectedGridViewRow GetSelectedRow(object sender,  GridView MainDataGrid)
        {

            GridViewRow selectedRow = null;
            if (sender is CustomValidator)
            {
                CustomValidator custVal = (CustomValidator)sender; //get the sender
                selectedRow = (GridViewRow)custVal.NamingContainer;//get the row
            }
            else if (sender is ImageButton)
            {
                ImageButton imgBtn = (ImageButton)sender;                           //Get the object that raised the event
                selectedRow = (GridViewRow)imgBtn.NamingContainer;
            }
            else if (sender is CheckBox)
            {
                CheckBox checkBox = (CheckBox)sender;                           //Get the object that raised the event
                selectedRow = (GridViewRow)checkBox.NamingContainer;
            }
            else {
                LinkButton LnkBtn = (LinkButton)sender;                           //Get the object that raised the event
                selectedRow = (GridViewRow)LnkBtn.NamingContainer;
            }

                
                int index = selectedRow.RowIndex;                                   //Get row index
                int id = int.Parse(MainDataGrid.DataKeys[index][0].ToString());     //Get row promary key

                SelectedGridViewRow selGridViewRow = new SelectedGridViewRow();
                selGridViewRow.selectedRow = selectedRow;
                selGridViewRow.index = index;
                selGridViewRow.id = id;
                return selGridViewRow;
        }
    }

            public class SelectedGridViewRow
            { 
                public GridViewRow selectedRow { get; set; }
                public int index { get; set; }
                public int id { get; set; }
            }

}
