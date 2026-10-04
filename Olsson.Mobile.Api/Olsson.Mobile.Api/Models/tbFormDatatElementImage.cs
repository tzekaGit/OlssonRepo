using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace Olsson.Mobile.Api.Models
{
    [Table("tbFormDataElementImage")]
    public class tbFormDataElementImage
    {
        [Key]
        public Guid ID { get; set; }
        public Guid RowID { get; set; }
        public string ImageName { get; set; }
        public string ImageFileName { get; set; }
        public byte[] ImageSource { get; set; }
        public DateTime? DateUpdated { get; set; }

    }
}