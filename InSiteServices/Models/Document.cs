using System;
using System.Linq;

namespace InsiteServices.Models
{
    public class Document
    {
        public int SystemID { get; set; }

        public int DocumentID { get; set; }

        public string Comment { get; set; }

        public string FileName { get; set; }

        public string FileType { get; set; }

        public string FileExtension { get; set; }

        public byte[] FileData { get; set; }

        public Document()
        {
            SystemID = 0;
            DocumentID = 0;
            Comment = string.Empty;
            FileName = string.Empty;
            FileType = string.Empty;
            FileExtension = string.Empty;
            FileData = null;
        }
    }
}