using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Olsson.Mobile.Api.Models
{
    public class tbFormDataElementContainer
    {
        [Required]
        [Key]
        public string ID { get; set; }
        public string ContainerName { get; set; }
        public int? ContainerID { get; set; }
        public int? SectionID { get; set; }
       
        public string DocumentId { get; set; }
        public Guid ParentRowId { get; set; }

    }
}