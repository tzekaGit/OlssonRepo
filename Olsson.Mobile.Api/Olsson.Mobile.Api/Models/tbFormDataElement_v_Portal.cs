using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Olsson.Mobile.Api.Models
{
    public class tbFormDataElement_v_Portal
    {
        [Required]
        [Key]
        public string ContainerID { get; set; }
        public int? SectionID { get; set; }
        public string ContainerName { get; set; }
        public string DocumentId { get; set; }
        public Guid ParentRowId { get; set; }

    }
}