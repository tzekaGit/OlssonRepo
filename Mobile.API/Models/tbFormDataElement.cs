using System;
using System.ComponentModel.DataAnnotations;

namespace Mobile.Api.Models
{
    public class tbFormDataElement
    {

        
        [Required]
        [Key]

        public Guid RowID { get; set; } 
        public string DocumentId { get; set; }
        public string ListId { get; set; }
        public string FieldId { get; set; }
        public string FieldName { get; set; }
        public string FieldValue { get; set; }
        public string SectionId { get; set; }

    }
}