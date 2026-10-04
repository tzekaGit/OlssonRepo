
using System.ComponentModel.DataAnnotations;


namespace Olsson.Mobile.Api.Models
{

    public class SEM_tbForm
    {
        public SEM_tbForm()
        {
        }

        [Required]
        [Key]
        public int FormID { get; set; }
        public string FormName { get; set; }
        public string FormStatus { get; set; }
    }
}
