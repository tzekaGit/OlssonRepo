using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Olsson.Mobile.Api.Models
{
    [Table("tbFormDataElement")]
    public class tbFormDataElement
    {
        public tbFormDataElement()
        {

        }

        [Required]
        [Key]
        public Guid RowID { get; set; }
        public Guid ParentRowID { get; set; }
        public string DocumentId { get; set; }
        public string ListId { get; set; }
        public int? FieldId { get; set; }
        public string FieldName { get; set; }
        public string FieldValue { get; set; }
        public int? SectionId { get; set; }
        public DateTime? DateUpdated { get; set; }

       

}
}