using System;
using System.ComponentModel.DataAnnotations;

namespace Mobile.Api.Models
{
    public class View_FormData
    {

        //SEM_tbForm
        [Required]
        [Key]
        public int FormID { get; set; }
        public string FormName { get; set; }
        public string FormStatus { get; set; }
        //tbFormData

        public Guid RowID { get; set; } 
        public string DocumentId { get; set; }
        public string DocumentType { get; set; }
        public string DocumentTitle { get; set; }
        public string DocumentStatus { get; set; }

    }
}