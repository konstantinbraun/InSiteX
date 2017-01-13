using System;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Web.UI;

namespace InSite.App.ViewStatePersister
{
    public class CompressedStateFormatter : IStateFormatter
    {
        private readonly IStateFormatter actualFormatter;

        public CompressedStateFormatter(IStateFormatter actualFormatter)
        {
            this.actualFormatter = actualFormatter;
        }

        public string Serialize(object state)
        {
            string decompressedState = actualFormatter.Serialize(state);
            using (MemoryStream memoryStream = new MemoryStream())
            {
                using (Stream zipStream = new GZipStream(memoryStream, CompressionMode.Compress))
                    using (StreamWriter writer = new StreamWriter(zipStream))
                    {
                        writer.Write(decompressedState);
                    }
                return Convert.ToBase64String(memoryStream.ToArray());
            }
        }

        public object Deserialize(string serializedState)
        {
            byte[] data = Convert.FromBase64String(serializedState);
            using (MemoryStream memoryStream = new MemoryStream(data))
                using (Stream zippedStream = new GZipStream(memoryStream, CompressionMode.Decompress))
                    using (StreamReader reader = new StreamReader(zippedStream))
                    {
                        return actualFormatter.Deserialize(reader.ReadToEnd());
                    }
        }
    }
}