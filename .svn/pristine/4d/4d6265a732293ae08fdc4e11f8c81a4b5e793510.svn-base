using log4net;
using System;
using System.Configuration;
using System.Data.Entity.Core.Objects;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Runtime.Serialization.Json;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Xml;
using System.Xml.Serialization;

namespace InsiteServices
{
    public static class Helpers
    {
        private static readonly log4net.ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private const int PBKDF2IterCount = 1000; // default for Rfc2898DeriveBytes
        private const int PBKDF2SubkeyLength = 256 / 8; // 256 bits
        private const int SaltSize = 128 / 8; // 128 bits

        public static string HashPassword(string password)
        {
            byte[] salt;
            byte[] subkey;
            using (var deriveBytes = new Rfc2898DeriveBytes(password, SaltSize, PBKDF2IterCount))
            {
                salt = deriveBytes.Salt;
                subkey = deriveBytes.GetBytes(PBKDF2SubkeyLength);
            }

            byte[] outputBytes = new byte[1 + SaltSize + PBKDF2SubkeyLength];
            Buffer.BlockCopy(salt, 0, outputBytes, 1, SaltSize);
            Buffer.BlockCopy(subkey, 0, outputBytes, 1 + SaltSize, PBKDF2SubkeyLength);
            return Convert.ToBase64String(outputBytes);
        }

        public static bool VerifyUnHashedPassword(string hashedPassword, string password)
        {
            byte[] hashedPasswordBytes = Convert.FromBase64String(hashedPassword);

            // Wrong length or version header.
            if (hashedPasswordBytes.Length != (1 + SaltSize + PBKDF2SubkeyLength) || hashedPasswordBytes[0] != 0x00)
                return false;

            byte[] salt = new byte[SaltSize];
            Buffer.BlockCopy(hashedPasswordBytes, 1, salt, 0, SaltSize);
            byte[] storedSubkey = new byte[PBKDF2SubkeyLength];
            Buffer.BlockCopy(hashedPasswordBytes, 1 + SaltSize, storedSubkey, 0, PBKDF2SubkeyLength);

            byte[] generatedSubkey;
            using (var deriveBytes = new Rfc2898DeriveBytes(password, salt, PBKDF2IterCount))
            {
                generatedSubkey = deriveBytes.GetBytes(PBKDF2SubkeyLength);
            }
            return storedSubkey.SequenceEqual(generatedSubkey);
        }

        public static bool VerifyHashedPassword(string hashedPassword, string password)
        {
            byte[] hashedPasswordBytes = Convert.FromBase64String(hashedPassword);

            // Wrong length or version header.
            if (hashedPasswordBytes.Length != (1 + SaltSize + PBKDF2SubkeyLength) || hashedPasswordBytes[0] != 0x00)
                return false;

            byte[] salt = new byte[SaltSize];
            Buffer.BlockCopy(hashedPasswordBytes, 1, salt, 0, SaltSize);
            byte[] storedSubkey = new byte[PBKDF2SubkeyLength];
            Buffer.BlockCopy(hashedPasswordBytes, 1 + SaltSize, storedSubkey, 0, PBKDF2SubkeyLength);

            byte[] generatedPasswordBytes = Convert.FromBase64String(password);
            Buffer.BlockCopy(generatedPasswordBytes, 1, salt, 0, SaltSize);
            byte[] generatedSubkey = new byte[PBKDF2SubkeyLength];
            Buffer.BlockCopy(generatedPasswordBytes, 1 + SaltSize, generatedSubkey, 0, PBKDF2SubkeyLength);

            return storedSubkey.SequenceEqual(generatedSubkey);
        }

        /// <summary>
        /// Create thumbnail from image data in byte array and return as byte array
        /// </summary>
        /// <param name="imageData"></param>
        /// <param name="thumbnailSize"></param>
        /// <returns></returns>
        public static byte[] CreateThumbnail(byte[] imageData, int thumbnailSize)
        {
            byte[] thumbnail = null;

            System.Drawing.Image imageIn = ByteArrayToImage(imageData);
            System.Drawing.Image imageOut = ScaleImage(imageIn, thumbnailSize, thumbnailSize);

            if (imageOut != null)
            {
                thumbnail = ImageToByteArray(imageOut, ImageFormat.Jpeg);
            }

            return thumbnail;
        }

        /// <summary>
        /// Resize image proportionally with MaxHeight and MaxWidth constraints
        /// Will only shrink and not enlarge image
        /// </summary>
        /// <param name="image">The unscaled image</param>
        /// <param name="maxWidth">Max width for scaled image</param>
        /// <param name="maxHeight">Max height scaled image</param>
        /// <returns>The scaled image</returns>
        public static System.Drawing.Image ScaleImage(System.Drawing.Image image, int maxWidth, int maxHeight)
        {
            Bitmap newImage = null;
            if (maxWidth == 0 && maxHeight == 0)
            {
                newImage = new Bitmap(image);
            }
            else
            {
                if (maxWidth == 0)
                {
                    maxWidth = (int)((double)maxHeight * ((double)image.Width / image.Height));
                }
                else if (maxHeight == 0)
                {
                    maxHeight = (int)((double)maxWidth * ((double)image.Height / image.Width));
                }
                if (image.Width <= maxWidth && image.Height <= maxHeight)
                {
                    newImage = new Bitmap(image);
                }
                else
                {
                    double ratioX = (double)maxWidth / image.Width;
                    double ratioY = (double)maxHeight / image.Height;
                    double ratio = Math.Min(ratioX, ratioY);

                    int newWidth = (int)(image.Width * ratio);
                    int newHeight = (int)(image.Height * ratio);
                    Size newSize = new Size(newWidth, newHeight);

                    newImage = new Bitmap(newWidth, newHeight, PixelFormat.Format32bppArgb);
                    newImage.SetResolution(72, 72);

                    newImage = new Bitmap(newWidth, newHeight);
                    ImageAttributes attribute = new ImageAttributes();
                    attribute.SetWrapMode(WrapMode.TileFlipXY);

                    Graphics graphics = Graphics.FromImage(newImage);
                    graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    graphics.SmoothingMode = SmoothingMode.AntiAlias;
                    graphics.CompositingQuality = CompositingQuality.HighQuality;
                    graphics.PixelOffsetMode = PixelOffsetMode.HighQuality;

                    graphics.DrawImage(image, new Rectangle(new Point(0, 0), newSize), 0, 0, image.Width, image.Height, GraphicsUnit.Pixel, attribute);
                }
            }
            return newImage;
        }

        /// <summary>
        /// Converts image to byte array
        /// </summary>
        /// <param name="imageIn">Image to convert</param>
        /// <returns>Image as byte array</returns>
        public static byte[] ImageToByteArray(System.Drawing.Image imageIn, ImageFormat format)
        {
            MemoryStream ms = new MemoryStream();
            imageIn.Save(ms, format);
            return ms.ToArray();
        }

        /// <summary>
        /// Converts byte array to image
        /// </summary>
        /// <param name="byteArrayIn">Image to convert</param>
        /// <returns>Byte array as image</returns>
        public static System.Drawing.Image ByteArrayToImage(byte[] byteArrayIn)
        {
            MemoryStream ms = new MemoryStream(byteArrayIn);
            System.Drawing.Image returnImage = System.Drawing.Image.FromStream(ms);
            return returnImage;
        }

        public static ImageFormat ParseImageFormat(string type)
        {
            switch (type.ToLower())
            {
                case "jpg":
                    return ImageFormat.Jpeg;

                case "jpeg":
                    return ImageFormat.Jpeg;

                case "bmp":
                    return ImageFormat.Bmp;

                case "gif":
                    return ImageFormat.Gif;

                case "png":
                    return ImageFormat.Png;

                case "tiff":
                    return ImageFormat.Tiff;

                case "wmf":
                    return ImageFormat.Wmf;

                case "emf":
                    return ImageFormat.Emf;

                case "icon":
                    return ImageFormat.Icon;

                case "ico":
                    return ImageFormat.Icon;

                case "exif":
                    return ImageFormat.Exif;

                default:
                    return ImageFormat.Jpeg;
            }
        }

        public static bool IsValidEmail(string strIn)
        {
            // Return true if strIn is in valid e-mail format.
            return Regex.IsMatch(strIn,
                                       @"^(?("")("".+?""@)|(([0-9a-zA-Z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-zA-Z])@))" +
                                       @"(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,6}))$");
        }

        public static MailMessage CreateMail(string mailFrom, string mailTo, string subject, string body, bool isBodyHtml)
        {
            if (!mailFrom.Equals(string.Empty) && IsValidEmail(mailFrom) && !mailTo.Equals(string.Empty) && IsValidEmail(mailTo))
            {
                MailMessage mail = new MailMessage();

                mail.From = new MailAddress(mailFrom);
                string[] arrayMailTo = mailTo.Split(';');
                for (int i = 0; i < arrayMailTo.Length; i++)
                {
                    mail.To.Add(new MailAddress(arrayMailTo[i]));
                }
                mail.Subject = subject;
                mail.Body = body;
                mail.BodyEncoding = UTF8Encoding.UTF8;
                mail.IsBodyHtml = isBodyHtml;
                mail.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

                return mail;
            }
            else
            {
                return null;
            }
        }

        public static void SendMail(MailMessage mail)
        {
            if (mail != null)
            {
                SmtpClient client = new SmtpClient();
                client.Port = Convert.ToInt32(ConfigurationManager.AppSettings["SMTPPort"]);
                client.DeliveryMethod = SmtpDeliveryMethod.Network;
                client.UseDefaultCredentials = false;
                client.Credentials = new System.Net.NetworkCredential(ConfigurationManager.AppSettings["SMTPUser"].ToString(), ConfigurationManager.AppSettings["SMTPPwd"].ToString());
                client.Host = ConfigurationManager.AppSettings["MailServer"].ToString();

                try
                {
                    client.Send(mail);
                }
                catch (Exception ex)
                {
                    logger.Error("Exception: ", ex);
                }
            }
        }

        public static string ToJson<T>(this T obj) where T : class
        {
            DataContractJsonSerializer serializer = new DataContractJsonSerializer(typeof(T));
            using (MemoryStream stream = new MemoryStream())
            {
                serializer.WriteObject(stream, obj);
                return Encoding.UTF8.GetString(stream.ToArray());
            }
        }

        public static T FromJson<T>(this T obj, string json) where T : class
        {
            using (MemoryStream stream = new MemoryStream(Encoding.Unicode.GetBytes(json)))
            {
                DataContractJsonSerializer serializer = new DataContractJsonSerializer(typeof(T));
                return serializer.ReadObject(stream) as T;
            }
        }

        public static GetPhoto_Result GetPhoto(int systemID, int bpID, int employeeID)
        {
            Insite_DevEntities entities = new Insite_DevEntities();
            ObjectResult<GetPhoto_Result> photoResult = entities.GetPhoto(systemID, bpID, employeeID);
            GetPhoto_Result[] photos = photoResult.ToArray();
            GetPhoto_Result photo = null;
            if (photos.Count() > 0)
            {
                photo = photos[0];
            }
            return photo;
        }

        public static string Tail(string stringToTail, int maxLength, string tail)
        {
            string ret = stringToTail;
            if (stringToTail.Length > maxLength)
            {
                ret = string.Concat(stringToTail.Substring(0, maxLength - tail.Length), tail);
            }
            return ret;
        }

        /// <summary>
        /// Serialisiert ein Objekt
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="value"></param>
        /// <returns></returns>
        public static string Serialize<T>(T value)
        {
            if (value == null)
            {
                return null;
            }

            string result = string.Empty;

            try
            {
                XmlSerializer serializer = new XmlSerializer(typeof(T));

                XmlWriterSettings settings = new XmlWriterSettings();
                settings.Encoding = new UnicodeEncoding(false, false);
                settings.Indent = false;
                settings.OmitXmlDeclaration = false;

                using (StringWriter textWriter = new StringWriter())
                {
                    using (XmlWriter xmlWriter = XmlWriter.Create(textWriter, settings))
                    {
                        serializer.Serialize(xmlWriter, value);
                    }
                    result = textWriter.ToString();
                }
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
            }

            return result;
        }

        /// <summary>
        /// Deserialisiert ein Objekt
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="xml"></param>
        /// <returns></returns>
        public static T Deserialize<T>(string xml)
        {
            if (string.IsNullOrEmpty(xml))
            {
                return default(T);
            }

            T serialized = default(T);

            try
            {
                XmlSerializer serializer = new XmlSerializer(typeof(T));

                XmlReaderSettings settings = new XmlReaderSettings();

                using (StringReader textReader = new StringReader(xml))
                {
                    using (XmlReader xmlReader = XmlReader.Create(textReader, settings))
                    {
                        serialized = (T)serializer.Deserialize(xmlReader);
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }

            return serialized;
        }

        /// <summary>
        /// Parse and save xml string to timestamped file
        /// </summary>
        /// <param name="xml"></param>
        /// <param name="fileNameFixedPart"></param>
        /// <returns></returns>
        public static int WriteXmlFile(string xml, string fileNameFixedPart, int minLengthForSave)
        {

            int size = xml.Length;

            if (ConfigurationManager.AppSettings["UseSerialization"] != null && ConfigurationManager.AppSettings["UseSerialization"].ToString().Equals("true"))
            {

                if (size > 0)
                {
                    string pathName = HttpContext.Current.Server.MapPath(ConfigurationManager.AppSettings["Serialize"].ToString());
                    if (!Directory.Exists(pathName))
                    {
                        Directory.CreateDirectory(pathName);
                    }
                    pathName += "\\" + fileNameFixedPart;
                    if (!Directory.Exists(pathName))
                    {
                        Directory.CreateDirectory(pathName);
                    }

                    string fileName = CleanFilename(DateTime.Now.ToString("yyyyMMddHHmmssf") + "_" + fileNameFixedPart + ".xml");
                    string filePath = pathName + "//" + fileName;
                    XmlDocument xmlDocument = new XmlDocument();

                    // Try to parse xml string
                    try
                    {
                        xmlDocument.LoadXml(xml);
                    }
                    catch (Exception ex)
                    {
                        logger.Error("Exception: ", ex);
                        size = -1;
                    }

                    if (size > minLengthForSave)
                    {
                        // Try to save xml file
                        try
                        {
                            xmlDocument.Save(filePath);
                        }
                        catch (Exception ex)
                        {
                            logger.Error("Exception: ", ex);
                            size = -2;
                        }
                    }
                }
            }

            return size;
        }

        /// <summary>
        /// Sonderzeichen und Umlaute aus Dateinamen entfernen
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public static string CleanFilename(string fileName)
        {
            // "Clean" filename
            // fileName = fileName.ToLower();
            fileName = fileName.Replace("ä", "ae");
            fileName = fileName.Replace("ö", "oe");
            fileName = fileName.Replace("ü", "ue");
            fileName = fileName.Replace("Ä", "Ae");
            fileName = fileName.Replace("Ö", "Oe");
            fileName = fileName.Replace("Ü", "Ue");
            fileName = fileName.Replace("ß", "ss");
            fileName = fileName.Replace(" ", "_");
            fileName = fileName.Replace("&", "-");
            fileName = fileName.Replace("/", ".");
            fileName = fileName.Replace("\\", "_");
            fileName = fileName.Replace("%", "_");
            fileName = fileName.Replace("<", "_");
            fileName = fileName.Replace(">", "_");
            fileName = fileName.Replace(",", "_");
            fileName = fileName.Replace("#", "_");
            fileName = fileName.Replace("+", "_");
            fileName = fileName.Replace("~", "_");
            fileName = fileName.Replace("'", "_");
            fileName = fileName.Replace("?", "_");
            fileName = fileName.Replace("$", "_");
            fileName = fileName.Replace("(", "_");
            fileName = fileName.Replace(")", "_");

            return fileName;
        }
    }
}