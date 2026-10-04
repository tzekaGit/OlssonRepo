using System;
using System.ComponentModel.DataAnnotations;

namespace Olsson.Mobile.Api.Models
{
    public class View_FormData
    {
        private object adminMessage;
        //SEM_tbForm
        [Required]
        [Key]
        public Guid RowID { get; set; }
        public Guid? UserID { get; set; }
        public int FormID { get; set; }
        public string FormName { get; set; }
        public string FormStatus { get; set; }
        //tbFormData


        public string DocumentId { get; set; }
        public string DocumentType { get; set; }
        public string DocumentTitle { get; set; }
        public string DocumentStatus { get; set; }

        public DateTime? Audit_AddDate { get; set; }
        public string Audit_AddBy { get; set; }
        public DateTime? Audit_UpdateDate { get; set; }
        public string Audit_UpdateBy { get; set; }

        public string AdminMessage
        {
            get
            {
                if (adminMessage == null)
                {
                    return "";
                }
                else
                {
                    return adminMessage.ToString();
                };
            }

            set
            {
                adminMessage = value;
            }
        }
    }
}