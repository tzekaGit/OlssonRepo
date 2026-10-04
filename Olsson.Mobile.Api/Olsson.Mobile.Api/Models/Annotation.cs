using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Olsson.Mobile.Api.Models
{
    [Table("tbFormDataElementImageAnnotation")]
    public class tbFormDataElementImageAnnotation
    {
        public tbFormDataElementImageAnnotation()
        {

        }

        [Required]
        [Key]
        public Guid id { get; set; }
        public Guid rowID { get; set; }
        public int sequenceID { get; set; }
        public double? xPos { get; set; }
        public double? yPos { get; set; }
        public string title { get; set; }
        public string description { get; set; }
        public string shape { get; set; }
        public string color { get; set; }
        public string size { get; set; }
        public string imageName { get; set; }
        public byte[] source { get; set; }
    }
}

