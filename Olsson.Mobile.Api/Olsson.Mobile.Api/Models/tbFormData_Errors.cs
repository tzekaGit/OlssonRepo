using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Olsson.Mobile.Api.Models
{
    [Table("tbFormData_Errors")]
    public class tbFormData_Errors
    {
        [Required]
        [Key]
        public Guid RowID { get; set; }

        public Guid TrxID { get; set; }
        public string ValidationType { get; set; }
        public string FieldName { get; set; }
        public string ErrorMsg { get; set; }
        public int? MinLength { get; set; }
        public int? MaxLength { get; set; }

    }
}
