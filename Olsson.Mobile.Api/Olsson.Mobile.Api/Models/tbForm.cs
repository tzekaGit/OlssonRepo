using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Olsson.Mobile.Api.Models
{
    [Table("tbForm")]
    public class tbForm
    {

        [Required]
        [Key]
        public int FormID { get; set; }
        public int RoleID { get; set; }
        public string FormName { get; set; }
        public string UserName { get; set; }
        public string FormStatus { get; set; }
    }
}
