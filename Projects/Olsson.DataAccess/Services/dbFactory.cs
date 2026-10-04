using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Scientel.CCPortal.DataAccess.Services
{
    public struct result
    {
        public bool IsSuccessfull;
        public string Message;
        public string StackTrace;
       
        public result(bool isSuccessfull, string message, string stackTrace)
        {
            IsSuccessfull = isSuccessfull;
            Message = message;
            StackTrace = stackTrace;
        }
    }

    public abstract class dbFactory
    {
        public result Result;
        public ServiceErrors serviceErrors;


        public dbFactory()
        {
            serviceErrors = new ServiceErrors();
            Result = new result();

            Result.IsSuccessfull = true;
            Result.Message = "Successfull";
            Result.StackTrace = "";
        }
    }
    public class ServiceErrors
    {
        public result GetServiceErrors(Exception ex)
        {
            result Result = new result();
            Result.IsSuccessfull = false;
            Result.Message = ex.Message;
            Result.StackTrace = ex.StackTrace;

            return Result;
        }
    }



}
