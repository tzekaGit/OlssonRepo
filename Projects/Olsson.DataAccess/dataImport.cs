using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;

namespace Olsson.DataAccess
{
    public  class DataImport :IDisposable
    {

        public string ExcelToSQL(string strFilePath,  string strLoadDirectory, string strDelim, string strSQLTable)
        {
            DataFactory dbFactory = new DataFactory();

            // Get datatable structure
            string SQLQuery = string.Format("Select * from {0} where 1=2", strSQLTable);
            SqlCommand objComm = new SqlCommand();
            objComm.CommandText = SQLQuery;

            DataTable dataTbl = dbFactory.SelectDataTbl(objComm);
            //assign the primary key
            DataColumn[] keys = new DataColumn[2];

            // dataTbl.Columns["ID"].AutoIncrement = true;

            keys[0] = dataTbl.Columns["ID"];//
            dataTbl.PrimaryKey = keys;
            // dataTbl.Columns[ "ID"].Unique = true;

            //populate the data table
            string ExcelFolderLocation = AppSettings.Configuration.ExcelFolderLocation;

            string FilePath = ExcelFolderLocation + strLoadDirectory + @"\working\" +  strFilePath;
            string[] lines = File.ReadAllLines(FilePath);
            if (lines.Count() == 0) {
                return "Success";
            }

                string CellStr = "";
            //populate the data table
            DataRow objRow;
            string[] line;
            int startLine = 1;
            string strMessage = "Success";
            try
            {
            //read the heade fields;
                 string[] header = lines[0].Split(strDelim.ToCharArray());

                for (int i = startLine; i <= lines.Count() - 1; i++)
                {
                    //create new row
                    objRow = dataTbl.NewRow();
                    //assing a datakey value, required by the datatable
                    objRow["ID"] = i;
                    objRow["FilePath"] = FilePath;

                    //split the first line and put column name into an array           
                    line = lines[i].Split(strDelim.ToCharArray());
                    //loop through the columns, using the header fieds

                    for (int cell = 0; cell < header.Count(); cell++)
                    {
                        //get the cell value
                        CellStr = line[cell].Equals("null", StringComparison.InvariantCultureIgnoreCase) ? string.Empty : line[cell];
                        //fill the table row
                        objRow[header[cell]] = CellStr;
                    }
                    dataTbl.Rows.Add(objRow);
                }
                lines = null;

                //update/insert database items
                dbFactory.UpdateDataTbl(objComm, dataTbl);

                //Post changes here //////
                //Post changes here //////

                //Move files to archive //////
                string ArchivePath = ExcelFolderLocation + strLoadDirectory + @"\Archive\" + strFilePath + DateTime.Now.ToString("yyyyMMddHHmmss") + ".csv";
                File.Move(FilePath, ArchivePath);

            }
            catch (Exception ex)
            {
                strMessage = "Unexpected Error: " + ex.Message;
                string ErrorPath = ExcelFolderLocation + strLoadDirectory + @"\Error\" + strFilePath + DateTime.Now.ToString("yyyyMMddHHmmss") + ".csv"; 
                File.Move(FilePath, ErrorPath);
            }

            return strMessage;

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


        // This code added to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code. Put cleanup code in Dispose(bool disposing) above.
            Dispose(true);
            // TODO: uncomment the following line if the finalizer is overridden above.
            // GC.SuppressFinalize(this);
        }
        #endregion



    }
}