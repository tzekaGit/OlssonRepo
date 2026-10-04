using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Olsson.Mobile.Api.Models
{
    [Table("tbFormData")]
    public class tbFormData
    {
        object adminMessage;
        public tbFormData()
        {

        }
        [Required]
        [Key]
        public Guid RowID { get; set; }
        public int FormID { get; set; }
        public Guid UserID { get; set; }
        public string DocumentId { get; set; }
        public string DocumentType { get; set; }
        public string DocumentTitle { get; set; }
        public string DocumentStatus { get; set; }

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
