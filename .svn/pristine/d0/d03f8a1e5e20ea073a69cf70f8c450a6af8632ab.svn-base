using InSite.App.UserServices;
using log4net;
using System;
using System.Drawing;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using Telerik.Web.UI;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.IO;
using System.Collections.Generic;
using System.Net.Mail;
using System.Configuration;
using System.Text;
using System.Reflection;
using System.Diagnostics;
using InSite.App.ViewStatePersister;
using System.Web.UI.WebControls;
using System.IO.Compression;
using System.Globalization;
using OfficeOpenXml;
using System.Text.RegularExpressions;
using System.Web.Services.Protocols;
using System.Resources;
using InSite.App.Constants;
using InSite.App;

namespace InSite.App
{
    public static class Helpers
    {
        private static readonly log4net.ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        /// <summary>
        /// Aktuellen Benutzer abmelden
        /// </summary>
        public static void Logout()
        {
            if (HttpContext.Current.Session["LoginName"] != null)
            {
                logger.DebugFormat("User {0} will be logged out", HttpContext.Current.Session["LoginName"].ToString());
                Helpers.UpdateUser("SessionID", string.Empty);
            }
            
            SessionLogger(HttpContext.Current.Session.SessionID, SessionState.SessionEnd, null, null);

            SessionData.SomeData["User"] = null;
            HttpContext.Current.Session["SystemID"] = null;
            HttpContext.Current.Session["BpID"] = null;
            HttpContext.Current.Session["UserID"] = null;
            HttpContext.Current.Session["CompanyID"] = null;
            HttpContext.Current.Session["LoginName"] = null;
            HttpContext.Current.Session["LanguageID"] = null;
            HttpContext.Current.Session["IsLoggedIn"] = false;
            HttpContext.Current.Session["UserType"] = null;
            HttpContext.Current.Session["RoleID"] = null;
            HttpContext.Current.Session["BpName"] = null;
            HttpContext.Current.Session["TreeViewNodeID"] = null;
            DeleteViewStateData();
            // HttpContext.Current.Session.Clear();
            // HttpContext.Current.Session.Abandon();
            // HttpContext.Current.Server.TransferRequest("~/Views/Login.aspx?Msg=Timeout", false);
        }

        /// <summary>
        /// Session Variablen für aktuellen Benutzer setzen
        /// </summary>
        /// <param name="user"></param>
        public static void SetUserSession(UserAssignments user)
        {
            HttpContext.Current.Session["SystemID"] = user.SystemID;
            HttpContext.Current.Session["BpID"] = user.BpID;
            HttpContext.Current.Session["UserID"] = user.UserID;
            HttpContext.Current.Session["CompanyID"] = user.CompanyID;
            HttpContext.Current.Session["LoginName"] = user.LoginName;
            HttpContext.Current.Session["LanguageID"] = user.LanguageID;
            HttpContext.Current.Session["IsLoggedIn"] = true;
            HttpContext.Current.Session["UserType"] = user.TypeID;
            HttpContext.Current.Session["RoleID"] = user.RoleID;
            HttpContext.Current.Session["Skin"] = user.SkinName;
            Helpers.UpdateUser("SessionID", HttpContext.Current.Session.SessionID);

            // Logger
            GlobalContext.Properties["SystemID"] = user.SystemID;
            GlobalContext.Properties["UserID"] = user.UserID;
            HttpContext.Current.Session["expandedNodes"] = user.TreeStatus;
        }

        /// <summary>
        /// Session Status protokollieren
        /// </summary>
        /// <param name="sessionID"></param>
        /// <param name="sessionState"></param>
        /// <param name="systemID"></param>
        /// <param name="userID"></param>
        public static void SessionLogger(string sessionID, int sessionState, int? systemID, int? userID)
        {
            UserServiceClient client = new UserServiceClient();
            try
            {
                client.Open();
                client.SessionLogger(sessionID, sessionState, systemID, userID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            finally
            {
                client.Close();
            }
        }

        /// <summary>
        /// Aussehen der Benutzeroberfläche ändern
        /// </summary>
        /// <param name="skin"></param>
        public static void ChangeSkin(string skin)
        {
            UserAssignments user = GetCurrentUserAssignment();
            user.SkinName = skin;
            SetCurrentUserAssignment(user);
            Webservices webservice = new Webservices();
            webservice.UpdateUser("SkinName", skin);
            HttpContext.Current.Session["Skin"] = skin;
            HttpContext.Current.Session["Telerik.Skin"] = skin;
        }

        /// <summary>
        /// Benutzerzuordnungen für ein spezielles Bauvorhaben aus SessionData abfragen
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <returns></returns>
        public static UserAssignments GetUserAssignment(int systemID, int bpID)
        {
            UserAssignments result = new UserAssignments();
            if (SessionData.SomeData["User"] != null)
            {
                UserAssignments[] users = (UserAssignments[])SessionData.SomeData["User"];
                foreach (UserAssignments user in users)
                {
                    if (user.SystemID == systemID && user.BpID == bpID)
                    {
                        result = user;
                    }
                }
            }
            return result;
        }

        /// <summary>
        /// Benutzerzuordnungen für das aktuelle Bauvorhaben aus SessionData abfragen
        /// </summary>
        /// <returns></returns>
        public static UserAssignments GetCurrentUserAssignment()
        {
            UserAssignments userAssignment = new UserAssignments();
            if (HttpContext.Current.Session != null)
            {
                try
                {
                    int systemID = (int)HttpContext.Current.Session["SystemID"];
                    int bpID = (int)HttpContext.Current.Session["BpID"];
                    userAssignment = GetUserAssignment(systemID, bpID);
                }
                catch (Exception ex)
                {
                    logger.Error("Exception: ", ex);
                }
            }
            return userAssignment;
        }

        /// <summary>
        /// Benutzerzuordnungen für ein bestimmtes Bauvorhaben in SessionData speichern
        /// </summary>
        /// <param name="newUser"></param>
        public static void SetCurrentUserAssignment(UserAssignments newUser)
        {
            List<UserAssignments> users = (SessionData.SomeData["User"] as UserAssignments[]).ToList();
            int systemID = (int)HttpContext.Current.Session["SystemID"];
            int bpID = (int)HttpContext.Current.Session["BpID"];
            foreach (UserAssignments user in users)
            {
                if (user.SystemID == systemID && user.BpID == bpID)
                {
                    users.Remove(user);
                    users.Add(newUser);
                    break;
                }
            }
            SessionData.SomeData["User"] = users.ToArray();
        }

        public static Boolean IsSysAdmin()
        {
            bool isRole = false;
            UserAssignments user = GetCurrentUserAssignment();
            if (user != null)
            {
                isRole = (user.TypeID >= 50);
            }
            return isRole;
        }

        public static Boolean IsBpAdmin()
        {
            bool isRole = false;
            UserAssignments user = GetCurrentUserAssignment();
            if (user != null)
            {
                isRole = (user.TypeID >= 20);
            }
            return isRole;
        }

        public static Boolean IsManager()
        {
            bool isRole = false;
            UserAssignments user = GetCurrentUserAssignment();
            if (user != null)
            {
                isRole = (user.TypeID >= 30);
            }
            return isRole;
        }

        public static Boolean IsMaster()
        {
            bool isRole = false;
            UserAssignments user = GetCurrentUserAssignment();
            if (user != null)
            {
                isRole = (user.TypeID >= 100);
            }
            return isRole;
        }

        public static String PageName(Page page)
        {
            return page.ToString().Substring(page.ToString().IndexOf(".") + 1).Replace("_", ".");
        }

        public static Color Html2Color(string hex)
        {
            return ColorTranslator.FromHtml(hex);
        }

        public static string CStr(object dbString)
        {
            if (dbString.Equals(DBNull.Value))
            {
                return ("#ffffff");
            }
            else
            {
                return (dbString.ToString());
            }
        }

        private const int Pbkdf2IterCount = 1000; // default for Rfc2898DeriveBytes
        private const int Pbkdf2SubkeyLength = 256 / 8; // 256 bits
        private const int SaltSize = 128 / 8; // 128 bits

        public static string HashPassword(string password)
        {
            byte[] salt;
            byte[] subkey;
            using (var deriveBytes = new Rfc2898DeriveBytes(password, SaltSize, Pbkdf2IterCount))
            {
                salt = deriveBytes.Salt;
                subkey = deriveBytes.GetBytes(Pbkdf2SubkeyLength);
            }

            byte[] outputBytes = new byte[1 + SaltSize + Pbkdf2SubkeyLength];
            Buffer.BlockCopy(salt, 0, outputBytes, 1, SaltSize);
            Buffer.BlockCopy(subkey, 0, outputBytes, 1 + SaltSize, Pbkdf2SubkeyLength);
            return Convert.ToBase64String(outputBytes);
        }

        public static bool VerifyHashedPassword(string hashedPassword, string password)
        {
            byte[] hashedPasswordBytes = Convert.FromBase64String(hashedPassword);

            // Wrong length or version header.
            if (hashedPasswordBytes.Length != (1 + SaltSize + Pbkdf2SubkeyLength) || hashedPasswordBytes[0] != 0x00)
                return false;

            byte[] salt = new byte[SaltSize];
            Buffer.BlockCopy(hashedPasswordBytes, 1, salt, 0, SaltSize);
            byte[] storedSubkey = new byte[Pbkdf2SubkeyLength];
            Buffer.BlockCopy(hashedPasswordBytes, 1 + SaltSize, storedSubkey, 0, Pbkdf2SubkeyLength);

            byte[] generatedSubkey;
            using (var deriveBytes = new Rfc2898DeriveBytes(password, salt, Pbkdf2IterCount))
            {
                generatedSubkey = deriveBytes.GetBytes(Pbkdf2SubkeyLength);
            }
            return storedSubkey.SequenceEqual(generatedSubkey);
        }

        public static void SetLoggerDialogContext(Int32 actionID, String refID)
        {
            log4net.LogicalThreadContext.Properties["IsDialog"] = true;
            log4net.LogicalThreadContext.Properties["ActionID"] = actionID;
            log4net.LogicalThreadContext.Properties["RefID"] = refID;
        }

        public static void DialogLogger(Type type, Int32 actionID, String refID, string message)
        {
            ILog log = LogManager.GetLogger(type);
            SetLoggerDialogContext(actionID, refID);
            log.Dialog(message);
        }

        /// <summary>
        /// Notification auf MasterPage ansteuern
        /// </summary>
        /// <param name="master"></param>
        /// <param name="command"></param>
        /// <param name="text"></param>
        /// <param name="color"></param>
        public static void ShowMessage(MasterPage master, string command, string text, string color)
        {
            // Statusmeldung als Notification
            string message = string.Format("<span style='color:{0}; padding: 3px;'>{1}</span>", color, text);

            RadNotification notification = (RadNotification)master.FindControl("Notification");
            if (notification != null)
            {
                notification.Title = command;
                notification.Text = message;
                if (color.Equals("red"))
                {
                    notification.Width = 700;
                    notification.AutoCloseDelay = 0;
                    notification.ShowSound = "warning";
                    notification.ContentIcon = "warning";
                }
                else
                {
                    notification.AutoCloseDelay = 3000;
                    notification.ShowSound = "none";
                    notification.ContentIcon = "info";
                }
                notification.Show();

                // Updatepanel aktualisieren
                UpdatePanel panel = master.FindControl("PanelNotification") as UpdatePanel;
                if (panel != null && panel.UpdateMode == UpdatePanelUpdateMode.Conditional)
                {
                    panel.Update();
                }
            }
        }

        /// <summary>
        /// Shows notification popup
        /// AutoCloseDelay = 3000, ShowSound = none, ContentIcon = info
        /// </summary>
        /// <param name="master">The master page of the current page</param>
        /// <param name="title">Title text</param>
        /// <param name="text">Message text</param>
        public static void Notification(MasterPage master, string title, string text)
        {
            Notification(master, title, text, 3000, "none", "info");
        }

        /// <summary>
        /// Shows notification popup
        /// </summary>
        /// <param name="master">The master page of the current page</param>
        /// <param name="title">Title text</param>
        /// <param name="text">Message text</param>
        /// <param name="autoCloseDelay">Milliseconds until popup disappears (0 = no autoClose)</param>
        /// <param name="showSound">Plays sound (none, info, warning, ok)</param>
        /// <param name="contentIcon">Shows icon (none, info, delete, deny, edit, ok, warning)</param>
        public static void Notification(MasterPage master, string title, string text, int? autoCloseDelay, string showSound, string contentIcon)
        {
            RadNotification notification = master.FindControl("Notification") as RadNotification;
            if (notification != null)
            {
                if (showSound.Equals(string.Empty))
                {
                    showSound = "none";
                }

                if (contentIcon.Equals(string.Empty))
                {
                    contentIcon = "info";
                }

                if (autoCloseDelay == null)
                {
                    autoCloseDelay = 3000;
                }

                // Notification konfigurieren
                notification.Title = title;
                notification.Text = text;
                notification.AutoCloseDelay = (int)autoCloseDelay;
                notification.ShowSound = showSound;
                notification.ContentIcon = contentIcon;
                notification.Show();

                // Updatepanel aktualisieren
                UpdatePanel panel = master.FindControl("PanelNotification") as UpdatePanel;
                if (panel != null && panel.UpdateMode == UpdatePanelUpdateMode.Conditional)
                {
                    panel.Update();
                }
            }
        }

        public static void UpdateGridStatus(RadGrid grid, string command, string text, string color)
        {
            // Literal für Statusmeldungen aktualisieren
            string message = string.Format("<span style='color:{0}; padding: 3px;'>{1}</span>", color, text);
            LiteralControl literalStatus = grid.FindControl("Status") as LiteralControl;
            if (literalStatus != null)
            {
                literalStatus.Text = message;
            }
        }

        public static void AddGridStatus(RadGrid grid, Page page)
        {
            // Literal für Statusmeldungen hinzufügen
            LiteralControl literalStatus = new LiteralControl();
            literalStatus.Text = string.Format("<span style='color:{0}; padding: 3px;'>{1}</span>", "Default", Resources.Resource.lblActionReady);
            literalStatus.ID = "Status";
            literalStatus.ApplyStyleSheetSkin(page);
            try
            {
                grid.Controls.Add(literalStatus);
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Status literal not added: {0}", ex.Message);
            }
        }

        public static void UpdateTreeListStatus(RadTreeList treelist, string command, string text, string color)
        {
            // Literal für Statusmeldungen aktualisieren
            string message = string.Format("<span style='color:{0}; padding: 3px;'>{1}</span>", color, text);
            LiteralControl literalStatus = treelist.FindControl("Status") as LiteralControl;
            if (literalStatus != null)
            {
                literalStatus.Text = message;
            }
        }

        public static void AddTreeListStatus(RadTreeList treelist, Page page)
        {
            // Literal für Statusmeldungen hinzufügen
            LiteralControl literalStatus = new LiteralControl();
            literalStatus.Text = string.Format("<span style='color:{0}; padding: 3px;'>{1}</span>", "Default", Resources.Resource.lblActionReady);
            literalStatus.ID = "Status";
            literalStatus.ApplyStyleSheetSkin(page);
            treelist.Controls.Add(literalStatus);
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

        /// <summary>
        /// Zufälligen Anmeldecode generieren
        /// </summary>
        /// <param name="length"></param>
        /// <param name="seed"></param>
        /// <returns></returns>
        public static string GenerateCode(int length, int seed)
        {
            string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            char[] stringChars = new char[length];
            Random random;
            if (seed == 0)
            {
                random = new Random();
            }
            else
            {
                random = new Random(seed);
            }

            for (int i = 0; i < stringChars.Length; i++)
            {
                stringChars[i] = chars[random.Next(chars.Length)];
            }

            return new String(stringChars);
        }

        /// <summary>
        /// Eindeutigkeit von Anmeldenamen prüfen
        /// </summary>
        /// <param name="loginName"></param>
        /// <returns></returns>
        public static bool LoginNameIsUnique(string loginName)
        {
            Webservices webservice = new Webservices();
            return webservice.LoginNameIsUnique(loginName);
        }

        public static void SendMail(string mailTo, string subject, string body)
        {
            SendMail(mailTo, subject, body, false);
        }

        public static void SendMail(string mailTo, string subject, string body, bool isBodyHtml)
        {
            SendMail(mailTo, subject, body, isBodyHtml, string.Empty, string.Empty, null);
        }

        public static void SendMail(MailMessage mail)
        {
            bool useEmail = Convert.ToBoolean(ConfigurationManager.AppSettings["UseEmail"]);
            if (useEmail)
            {
                if (mail != null)
                {
                    SmtpClient client = new SmtpClient();
                    client.Host = ConfigurationManager.AppSettings["MailServer"].ToString();
                    client.Port = Convert.ToInt32(ConfigurationManager.AppSettings["SMTPPort"]);
                    client.DeliveryMethod = SmtpDeliveryMethod.Network;
                    client.UseDefaultCredentials = false;

                    string smtpUser = ConfigurationManager.AppSettings["SMTPUser"].ToString();
                    string smtpPwd = ConfigurationManager.AppSettings["SMTPPwd"].ToString();

                    if (smtpUser != null && !smtpUser.Equals(string.Empty) && smtpPwd != null && !smtpPwd.Equals(string.Empty))
                    {
                        client.Credentials = new System.Net.NetworkCredential(smtpUser, smtpPwd);
                    }

                    try
                    {
                        client.Send(mail);
                    }
                    catch (Exception ex)
                    {
                        logger.Error("Exception: " + ex.Message);
                        if (ex.InnerException != null)
                        {
                            logger.Error("Inner Exception: " + ex.InnerException.Message);
                        }
                        logger.Debug("Exception Details: \n" + ex);
                    }
                }
            }
            else
            {
                logger.Info("Email not configured");
            }
        }

        /// <summary>
        /// Mail mit Anhang versenden
        /// </summary>
        /// <param name="mailTo"></param>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <param name="isBodyHtml"></param>
        /// <param name="fileName"></param>
        /// <param name="fileType"></param>
        /// <param name="fileData"></param>
        public static void SendMail(string mailTo, string subject, string body, bool isBodyHtml, string fileName, string fileType, byte[] fileData)
        {
            bool useEmail = Convert.ToBoolean(ConfigurationManager.AppSettings["UseEmail"]);
            if (useEmail)
            {
                if (!mailTo.Equals(string.Empty) && IsValidEmail(mailTo))
                {
                    SmtpClient client = new SmtpClient();
                    client.Host = ConfigurationManager.AppSettings["MailServer"].ToString();
                    client.Port = Convert.ToInt32(ConfigurationManager.AppSettings["SMTPPort"]);
                    client.DeliveryMethod = SmtpDeliveryMethod.Network;
                    client.UseDefaultCredentials = false;

                    string smtpUser = ConfigurationManager.AppSettings["SMTPUser"].ToString();
                    string smtpPwd = ConfigurationManager.AppSettings["SMTPPwd"].ToString();

                    if (smtpUser != null && !smtpUser.Equals(string.Empty) && smtpPwd != null && !smtpPwd.Equals(string.Empty))
                    {
                        client.Credentials = new System.Net.NetworkCredential(smtpUser, smtpPwd);
                    }

                    MailMessage mail = new MailMessage();

                    if (!fileName.Equals(string.Empty) && fileData != null)
                    {
                        MemoryStream stream = new MemoryStream(fileData);
                        Attachment attachment = new Attachment(stream, fileName, fileType);
                        mail.Attachments.Add(attachment);
                    }

                    mail.From = new MailAddress(ConfigurationManager.AppSettings["SMTPFrom"].ToString());
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

                    try
                    {
                        client.Send(mail);
                        logger.InfoFormat("Email sent to {0}: {1}", mailTo, subject);
                    }
                    catch (Exception ex)
                    {
                        logger.Error("Exception: " + ex.Message);
                        if (ex.InnerException != null)
                        {
                            logger.Error("Inner Exception: " + ex.InnerException.Message);
                        }
                        logger.Debug("Exception Details: \n" + ex);
                    }
                }
            }
            else
            {
                logger.Info("Email not configured");
            }
        }

        /// <summary>
        /// Neues MailMessage Objekt erstellen
        /// </summary>
        /// <param name="mailFrom"></param>
        /// <param name="mailTo"></param>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <param name="isBodyHtml"></param>
        /// <returns></returns>
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

        /// <summary>
        /// Benutzer mit bestimmtem Rollentyp ermitteln
        /// </summary>
        /// <param name="typeID"></param>
        /// <returns></returns>
        public static UserAssignments[] GetUsersWithRole(int typeID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetUsersWithRole(typeID);
        }

        /// <summary>
        /// Mail an Benutzer mit bestimmtem Rollentyp senden
        /// </summary>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <param name="typeID"></param>
        public static void SendMailToUsersWithRole(string subject, string body, int typeID, string fieldName, Tuple<string, string>[] values)
        {
            UserAssignments[] users = GetUsersWithRole(typeID);
            foreach (UserAssignments user in users)
            {
                string email = user.Email;
                if (email != null && !email.Equals(string.Empty) && user.UseEmail)
                {
                    if (!fieldName.Equals(string.Empty))
                    {
                        Master_Translations translation = Helpers.GetTranslation(fieldName, user.LanguageID, values);
                        if (translation != null && translation.NameTranslated != null && !translation.NameTranslated.Equals(string.Empty))
                        {
                            subject = translation.NameTranslated;
                            body = translation.HtmlTranslated;
                        }
                    }
                    SendMail(email, subject, body, true);
                }
            }
        }

        public static string AppVersion()
        {
            Assembly assembly = Assembly.GetExecutingAssembly();
            string version = assembly.GetName().Version.ToString();
            return version;
        }

        public static string AppFileVersion()
        {
            Assembly assembly = Assembly.GetExecutingAssembly();
            FileVersionInfo fvi = FileVersionInfo.GetVersionInfo(assembly.Location);
            string version = fvi.FileVersion;
            return version;
        }

        public static DateTime AppDate()
        {
            Assembly assembly = Assembly.GetExecutingAssembly();
            System.IO.FileInfo fileInfo = new System.IO.FileInfo(assembly.Location);
            DateTime lastModified = fileInfo.LastWriteTime;
            return lastModified;
        }

        /// <summary>
        /// Zum Mitarbeiter zugeordnete Dokumentenregel ermitteln
        /// </summary>
        /// <param name="employeeID"></param>
        /// <returns></returns>
        public static int GetAppliedRule(int employeeID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetAppliedRule(employeeID);
        }

        /// <summary>
        /// Zum Mitarbeiter zugeordnete Dokumentenregel als Text ermitteln
        /// </summary>
        /// <param name="employeeID"></param>
        /// <returns></returns>
        public static string GetAppliedRuleString(int employeeID)
        {
            int ruleID = GetAppliedRule(employeeID);
            ResourceManager rm = Resources.Resource.ResourceManager;
            string ruleString = "";

            if (ruleID == 0)
            {
                ruleString = Resources.Resource.selRDRuleNone;
            }
            else
            {
                ruleString = rm.GetString("selRDRule" + ruleID.ToString());
            }

            return ruleString;
        }

        public static string CurrentCulture()
        {
            if (HttpContext.Current.Session["currentCulture"] != null && !HttpContext.Current.Session["currentCulture"].ToString().Equals(string.Empty))
            {
                return HttpContext.Current.Session["currentCulture"].ToString();
            }
            else
            {
                return "en-GB";
            }
        }

        public static string CurrentLanguage()
        {
            string[] culture = CurrentCulture().Split('-');
            return culture[0];
        }

        public static string CurrentCountry()
        {
            string[] culture = CurrentCulture().Split('-');
            return culture[1];
        }

        public static UserAssignments GetUserWithLoginName(string loginName)
        {
            Webservices webservice = new Webservices();
            return webservice.GetUserWithLoginName(loginName);
        }

        public static string GetAppName()
        {
            return Resources.Resource.appName;
        }

        private static HttpCookie GetCookie()
        {
            string cookieName = String.Concat("selVal", "_", GetAppName());
            HttpCookie selVal = HttpContext.Current.Request.Cookies[cookieName];
            if (selVal == null)
            {
                selVal = new HttpCookie(cookieName);
                selVal.Expires = DateTime.Now.AddDays(60);
                HttpContext.Current.Response.Cookies.Add(selVal);
            }
            return selVal;
        }

        public static void RemoveCookie()
        {
            HttpCookie selVal = new HttpCookie(String.Concat("selVal", "_", GetAppName()));
            selVal.Expires = DateTime.Now.AddDays(-1d);
            HttpContext.Current.Response.Cookies.Add(selVal);
        }

        public static void InitFromCookie()
        {
            HttpCookie selVal = GetCookie();

            if (selVal.HasKeys)
            {
                try
                {
                    foreach (KeyValuePair<string, string> item in selVal.Values)
                    {
                        HttpContext.Current.Session[item.Key] = item.Value;
                    }
                }
                catch (Exception ex)
                {
                    RemoveCookie();
                }
            }
        }

        public static string GetValueFromCookie(string varName, string defaultValue)
        {
            string varValue = defaultValue;
            HttpCookie selVal = GetCookie();
            if (selVal.Values[varName] != null)
            {
                try
                {
                    varValue = selVal.Values[varName].ToString();
                }
                catch (Exception ex)
                {
                    RemoveCookie();
                }
            }

            return varValue;
        }

        public static void SetValueToCookie(string varName, string varValue)
        {
            HttpCookie selVal = GetCookie();
            if (selVal.Values[varName] == null)
            {
                selVal.Values.Add(varName, varValue);
            }
            else
            {
                selVal.Values[varName] = varValue;
            }
            HttpContext.Current.Response.Cookies.Set(selVal);
        }

        public static bool CookieExists()
        {
            string cookieName = String.Concat("selVal", "_", GetAppName());
            HttpCookie selVal = HttpContext.Current.Request.Cookies[cookieName];
            return (selVal != null);
        }

        public static void DeleteViewStateData()
        {
            CustomPageStatePersister.DeleteViewStateData();
        }

        public static void ChangeDefaultEditButtons(GridItemEventArgs e)
        {
            if (e.Item is Telerik.Web.UI.GridEditFormItem && e.Item.IsInEditMode)
            {
                RadButton button;

                ImageButton cancel = e.Item.FindControl("CancelButton") as ImageButton;
                if (cancel != null)
                {
                    cancel.Visible = false;

                    // Insert / Update Button
                    button = new RadButton();
                    ImageButton ok;
                    if (e.Item is GridEditFormInsertItem)
                    {
                        button.Text = Resources.Resource.lblActionInsert;
                        button.CommandName = "PerformInsert";
                        ok = e.Item.FindControl("PerformInsertButton") as ImageButton;
                    }
                    else
                    {
                        button.Text = Resources.Resource.lblActionUpdate;
                        button.CommandName = "Update";
                        ok = e.Item.FindControl("UpdateButton") as ImageButton;
                    }
                    ok.Visible = false;
                    button.Icon.PrimaryIconCssClass = "rbOk";
                    button.CausesValidation = true;
                    cancel.Parent.Controls.Add(new LiteralControl(" "));
                    cancel.Parent.Controls.Add(button);

                    // Cancel Button
                    button = new RadButton();
                    button.Text = Resources.Resource.lblActionCancel;
                    button.CommandName = "Cancel";
                    button.Icon.PrimaryIconCssClass = "rbCancel";
                    button.CausesValidation = false;
                    cancel.Parent.Controls.Add(new LiteralControl(" "));
                    cancel.Parent.Controls.Add(button);
                }
            }
        }

        public static void ChangeEditFormCaption(GridCommandEventArgs e)
        {
            if (e.CommandName == RadGrid.EditCommandName)
            {
                ChangeEditFormCaption(e, false, string.Empty);
            }
            else if (e.CommandName == RadGrid.InitInsertCommandName)
            {
                ChangeEditFormCaption(e, true, string.Empty);
            }
        }

        public static void ChangeEditFormCaption(GridCommandEventArgs e, string formName)
        {
            if (e.CommandName == RadGrid.EditCommandName)
            {
                ChangeEditFormCaption(e, false, formName);
            }
            else if (e.CommandName == RadGrid.InitInsertCommandName)
            {
                ChangeEditFormCaption(e, true, formName);
            }
        }

        public static void ChangeEditFormCaption(GridCommandEventArgs e, bool blnInsert, string formName)
        {
            GridTableView tv = e.Item.OwnerTableView;
            string captionFormatString = "<b>";
            if (!formName.Equals(string.Empty))
            {
                captionFormatString += string.Concat(formName, ": ").Replace(string.Concat(Resources.Resource.appName, " - "), string.Empty);
            }
            if (!blnInsert)
            {
                captionFormatString += string.Concat(Resources.Resource.lblActionEdit, ": ", "{0}", "</b>");
                tv.EditFormSettings.CaptionFormatString = captionFormatString;
            }
            else if (blnInsert)
            {
                tv.EditFormSettings.CaptionDataField = null;
                captionFormatString += string.Concat(Resources.Resource.lblActionCreate, "</b>");
                tv.EditFormSettings.CaptionFormatString = captionFormatString;
                tv.Rebind();
            }
        }

        public static void ChangeEditFormCaptionTV(TreeListCommandEventArgs e, bool blnInsert, string formName)
        {
            RadTreeList tv = e.Item.OwnerTreeList;
            string captionFormatString = "<b>";
            if (!formName.Equals(string.Empty))
            {
                captionFormatString += string.Concat(formName, ": ").Replace(string.Concat(Resources.Resource.appName, " - "), string.Empty);
            }
            if (!blnInsert)
            {
                captionFormatString += string.Concat(Resources.Resource.lblActionEdit, ": ", "{0}", "</b>");
                tv.EditFormSettings.CaptionFormatString = captionFormatString;
            }
            else if (blnInsert)
            {
                tv.EditFormSettings.CaptionDataField = null;
                captionFormatString += string.Concat(Resources.Resource.lblActionCreate, "</b>");
                tv.EditFormSettings.CaptionFormatString = captionFormatString;
                tv.Rebind();
            }
        }

        public static int UpdateUser(string columnName, string columnValue)
        {
            Webservices webservice = new Webservices();
            return webservice.UpdateUser(columnName, columnValue);
        }

        public static int GetNextID(string idName)
        {
            Webservices webservice = new Webservices();
            return webservice.GetNextID(idName);
        }

        public static int GetTreeNodeID(string dialogName)
        {
            // Key für ControlStorageProvider merken
            HttpContext.Current.Session["StorageProviderKey"] = dialogName;

            Webservices webservice = new Webservices();
            int treeNodeID = webservice.GetTreeNodeID(dialogName);
            HttpContext.Current.Session["TreeViewNodeID"] = treeNodeID;
            int dialogID = webservice.GetDialogID(dialogName);
            HttpContext.Current.Session["DialogID"] = dialogID;

            return treeNodeID;
        }

        public static int GetDialogID(string dialogName)
        {
            Webservices webservice = new Webservices();
            return webservice.GetDialogID(dialogName);
        }

        public static string GetDialogResID(int dialogID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetDialogResID(dialogID);
        }

        public static string GetDialogResID(string dialogTypeName)
        {
            Webservices webservice = new Webservices();
            return webservice.GetDialogResID(GetDialogID(dialogTypeName));
        }

        public static void GotoLastEdited(RadGrid rg, int lastID, string idName)
        {
            GotoLastEdited(rg, lastID, idName, false);
        }

        public static void GotoLastEdited(RadGrid rg, int lastID, string idName, bool edit)
        {
            // Auf zuletzt bearbeiteten Satz positionieren
            if (lastID != 0)
            {
                if (lastID == -1)
                {
                    // Letzte Aktion abgebrochen
                    rg.CurrentPageIndex = 0;
                    rg.Rebind();
                }
                else
                {
                    // Satz suchen, Pager setzen und Satz markieren
                    int flag = 0;
                    for (int i = 0; i < rg.PageCount; i++)
                    {
                        rg.CurrentPageIndex = i;
                        rg.Rebind();

                        foreach (GridDataItem dataItem in rg.Items)
                        {
                            if ((dataItem[idName].Controls[1] as Label) != null && (dataItem[idName].Controls[1] as Label).Text.Equals(lastID.ToString()))
                            {
                                dataItem.Selected = true;
                                if (edit)
                                {
                                    dataItem.Edit = edit;
                                    rg.Rebind();
                                }
                                flag = 1;
                                break;
                            }
                        }
                        if (flag == 1)
                        {
                            break;
                        }
                        else
                        {
                            // Satz nicht gefunden
                            rg.CurrentPageIndex = 0;
                            rg.Rebind();
                        }
                    }
                }
            }

            HttpContext.Current.Session["LastEdited"] = false;
        }

        public static void GotoLastEditedTL(RadTreeList tl, int lastID, string idName, bool edit)
        {
            // Auf zuletzt bearbeiteten Satz positionieren
            if (lastID != 0)
            {
                if (lastID == -1)
                {
                    // Letzte Aktion abgebrochen
                    tl.CurrentPageIndex = 0;
                    tl.Rebind();
                }
                else
                {
                    // Satz suchen, Pager setzen und Satz markieren
                    if (edit)
                    {
                        tl.EditIndexes.Clear();
                        tl.InsertIndexes.Clear();
                        tl.Rebind();
                    }
                    int flag = 0;
                    for (int i = 0; i < tl.PageCount; i++)
                    {
                        tl.CurrentPageIndex = i;
                        tl.Rebind();

                        foreach (TreeListDataItem dataItem in tl.Items)
                        {
                            if (dataItem[idName].Text != null && dataItem[idName].Text.Equals(lastID.ToString()))
                            {
                                dataItem.Selected = true;
                                if (edit)
                                {
                                    dataItem.Edit = edit;
                                    tl.Rebind();
                                }
                                flag = 1;
                                break;
                            }
                        }
                        if (flag == 1)
                        {
                            break;
                        }
                        else
                        {
                            // Satz nicht gefunden
                            tl.CurrentPageIndex = 0;
                            tl.Rebind();
                        }
                    }
                }
            }

            HttpContext.Current.Session["LastEdited"] = false;
        }

        public static byte[] Compress(byte[] b)
        {
            MemoryStream ms = new MemoryStream();
            GZipStream zs = new GZipStream(ms, CompressionMode.Compress, true);
            zs.Write(b, 0, b.Length);
            zs.Close();
            return ms.ToArray();
        }

        public static byte[] Decompress(byte[] b)
        {
            MemoryStream ms = new MemoryStream();
            GZipStream zs = new GZipStream(new MemoryStream(b), CompressionMode.Decompress, true);
            byte[] buffer = new byte[4096];
            int size;
            while (true)
            {
                size = zs.Read(buffer, 0, buffer.Length);
                if (size > 0)
                    ms.Write(buffer, 0, size);
                else
                    break;
            }
            zs.Close();
            return ms.ToArray();
        }

        public static byte[] GetBytes(string str)
        {
            byte[] bytes = new byte[str.Length * sizeof(char)];
            System.Buffer.BlockCopy(str.ToCharArray(), 0, bytes, 0, bytes.Length);
            return bytes;
        }

        public static string GetString(byte[] bytes)
        {
            char[] chars = new char[bytes.Length / sizeof(char)];
            System.Buffer.BlockCopy(bytes, 0, chars, 0, bytes.Length);
            return new string(chars);
        }

        public static void EmployeeChanged(int employeeID)
        {
            AccessControl accessControl = new AccessControl();
            accessControl.EmployeeChanged(employeeID);
            accessControl.Dispose();
        }

        public static void CompanyChanged(int companyID, bool withSubcontractors)
        {
            AccessControl accessControl = new AccessControl();
            accessControl.CompanyChanged(companyID, withSubcontractors);
            accessControl.Dispose();
        }

        public static bool IsFirstPass(int employeeID)
        {
            Webservices webservice = new Webservices();
            return webservice.IsFirstPass(employeeID);
        }

        public static GetRelevantDocuments_Result[] GetRelevantDocuments(int relevantDocumentID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetRelevantDocuments(relevantDocumentID);
        }

        public static GetEmployeeRelevantDocuments_Result[] GetEmployeeRelevantDocuments(int employeeID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetEmployeeRelevantDocuments(employeeID);
        }

        public static void TimeSlotChanged(int timeSlotID)
        {
            AccessControl accessControl = new AccessControl();
            accessControl.TimeSlotChanged(timeSlotID);
            accessControl.Dispose();
        }

        public static void RelevantDocumentChanged(int relevantDocumentID)
        {
            AccessControl accessControl = new AccessControl();
            accessControl.RelevantDocumentChanged(relevantDocumentID);
            accessControl.Dispose();
        }

        public static void CountryChanged(string countryID)
        {
            AccessControl accessControl = new AccessControl();
            accessControl.CountryChanged(countryID);
            accessControl.Dispose();
        }

        public static void DocumentCheckingRuleChanged(int countryGroupIDEmployer, int countryGroupIDEmployee, int employmentStatusID)
        {
            AccessControl accessControl = new AccessControl();
            accessControl.DocumentCheckingRuleChanged(countryGroupIDEmployer, countryGroupIDEmployee, employmentStatusID);
            accessControl.Dispose();
        }

        public static void ShortTermPassChanged(int shortTermPassID)
        {
            AccessControl accessControl = new AccessControl();
            accessControl.ShortTermPassChanged(shortTermPassID);
            accessControl.Dispose();
        }

        public static void SetAction(int action)
        {
            HttpContext.Current.Session["CurrentAction"] = action;
        }

        public static int GetAction()
        {
            int action;
            if (HttpContext.Current.Session["CurrentAction"] != null)
            {
                action = Convert.ToInt32(HttpContext.Current.Session["CurrentAction"]);
            }
            else
            {
                action = Actions.View;
            }
            return action;
        }

        public static GetEmployeeRelevantDocumentsToAdd_Result[] GetEmployeeRelevantDocumentsToAdd(int employeeID, int relevantFor)
        {
            Webservices webservice = new Webservices();
            return webservice.GetEmployeeRelevantDocumentsToAdd(employeeID, relevantFor);
        }

        public static GetCompanyAdminUser_Result[] GetCompanyAdminUser(int companyCentralID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetCompanyAdminUser(companyCentralID);
        }

        public static GetCompanyAdminUserWithBP_Result[] GetCompanyAdminUserWithBP(int companyID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetCompanyAdminUserWithBP(companyID);
        }

        public static bool HasState(string key)
        {
            int systemID = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            int userID = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
            ControlStateDBStorageProvider provider = new ControlStateDBStorageProvider(systemID, userID);
            return provider.HasState(key);
        }

        public static void DeleteStateFromStorage(string key)
        {
            int systemID = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            int userID = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
            ControlStateDBStorageProvider provider = new ControlStateDBStorageProvider(systemID, userID);
            provider.DeleteStateFromStorage(key);
        }

        public static void PanelControlStateVisibility(SiteMaster master, bool visible)
        {
            // Control Panel Sichtbarkeit schalten
            Panel panel = master.FindControl("PanelControlState") as Panel;
            if (panel != null)
            {
                panel.Visible = visible;
            }

            // Aktueller Formularstatus vorhanden? 
            bool hasState = HasState(HttpContext.Current.Session["StorageProviderKey"].ToString());
            RadButton rb = master.FindControl("ControlStateLoad") as RadButton;
            if (rb != null)
            {
                // "Formularstatus laden" Button aktivieren
                rb.Enabled = hasState;
                rb.ToolTip = Resources.Resource.ttControlStateLoad;
                if (hasState)
                {
                    ControlStateDBItem item = GetStateFromStorage(HttpContext.Current.Session["StorageProviderKey"].ToString());
                    rb.ToolTip += " (" + Resources.Resource.lblLastSaved + ": " + item.LastUpdate.ToString() + ")";

                    // Formularstatus wiederherstellen
                    RadPersistenceManager manager = master.FindControl("RadPersistenceManager1") as RadPersistenceManager;
                    manager.StorageProviderKey = HttpContext.Current.Session["StorageProviderKey"].ToString();
                    try
                    {
                        manager.LoadState();
                    }
                    catch (System.Exception ex)
                    {
                        logger.Error("Exception: " + ex.Message);
                        if (ex.InnerException != null)
                        {
                            logger.Error("Inner Exception: " + ex.InnerException.Message);
                        }
                        logger.Debug("Exception Details: \n" + ex);
                        throw;
                    }
                    ContentPlaceHolder placeholder = master.FindControl("BodyContent") as ContentPlaceHolder;
                    if (placeholder != null)
                    {
                        RadPersistenceManagerProxy proxy = placeholder.FindControl("RadPersistenceManagerProxy1") as RadPersistenceManagerProxy;
                        if (proxy != null)
                        {
                            foreach (PersistenceSetting setting in proxy.PersistenceSettings)
                            {
                                if (setting.SettingType == PersistenceSettingType.ControlID)
                                {
                                    Object ctl = placeholder.FindControl(setting.ControlID);
                                    if (ctl != null)
                                    {
                                        if (ctl.GetType() == typeof(RadGrid))
                                        {
                                            (ctl as RadGrid).Rebind();
                                        }
                                        else if (ctl.GetType() == typeof(RadTreeList))
                                        {
                                            (ctl as RadTreeList).Rebind();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            rb = master.FindControl("ControlStateReset") as RadButton;
            if (rb != null)
            {
                rb.Enabled = hasState;
            }

            RadSplitBar rsb = master.FindControl("RadSplitBar2") as RadSplitBar;
            if (rsb != null)
            {
                rsb.Visible = visible;
            }
        }

        public static ControlStateDBItem GetStateFromStorage(string key)
        {
            int systemID = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            int userID = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
            ControlStateDBStorageProvider provider = new ControlStateDBStorageProvider(systemID, userID);
            return provider.GetStateFromStorage(key);
        }

        public static int GetEmployeePassStatus(int employeeID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetEmployeePassStatus(employeeID);
        }

        public static string Tail(string stringToTail, int length)
        {
            string ret = stringToTail;
            if (stringToTail.Length > length)
            {
                string tail = " ...";
                ret = string.Concat(stringToTail.Substring(0, length), tail);
            }
            return ret;
        }

        public static int SetProcessEvent(Data_ProcessEvents eventData, string fieldName, Tuple<string, string>[] values)
        {
            Webservices webservice = new Webservices();
            return webservice.SetProcessEvent(eventData, fieldName, values);
        }

        public static int ProcessEventDone(Data_ProcessEvents eventData)
        {
            Webservices webservice = new Webservices();
            return webservice.ProcessEventDone(eventData);
        }

        public static string GetBpName(int bpID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetBpName(bpID);
        }

        public static string GetCompanyName(int companyID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetCompanyName(companyID);
        }

        public static void CreateProcessEvent(
            string dialogTypeName, 
            string dialogName, 
            string companyName, 
            int actionID, 
            int refID, 
            string refName, 
            string actionHint, 
            string fieldName, 
            Tuple<string, string>[] values)
        {
            CreateProcessEvent(dialogTypeName, dialogName, companyName, actionID, refID, refName, actionHint, 0, fieldName, values);
        }
        
        public static void CreateProcessEvent(
            string dialogTypeName, 
            string dialogName, 
            string companyName, 
            int actionID, 
            int refID, 
            string refName, 
            string actionHint, 
            int companyCentralID, 
            string fieldName, 
            Tuple<string, string>[] values)
        {
            // Eintrag in Vorgangsverwaltung
            Data_ProcessEvents eventData = new Data_ProcessEvents();
            eventData.DialogID = GetDialogID(dialogTypeName);
            eventData.ActionID = actionID;
            eventData.RefID = refID;
            string actionName = Actions.GetActionString(actionID);
            eventData.NameVisible = string.Concat(Resources.Resource.lblNewProcess, " ", dialogName, ": " + actionName);
            eventData.CompanyCentralID = companyCentralID;

            StringBuilder msg = new StringBuilder();
            if (HttpContext.Current.Session["BpID"] != null)
            {
                msg.AppendFormat("{0}: {1}<br/>", Resources.Resource.lblBuildingProject, GetBpName(Convert.ToInt32(HttpContext.Current.Session["BpID"])));
            }
            msg.AppendFormat("{0}: {1}<br/>", Resources.Resource.lblCompany, companyName);
            msg.AppendFormat("{0}: {1}<br/>", Resources.Resource.lblDialog, dialogName);
            msg.AppendFormat("{0}: {1}<br/>", Resources.Resource.lblAction, actionName);
            msg.AppendFormat("{0}: {1}({2})<br/><br/>", Resources.Resource.lblRecord, refID.ToString(), refName);
            msg.AppendFormat("{0}: {1}<br/>", Resources.Resource.lblHint, actionHint);

            eventData.DescriptionShort = msg.ToString();

            SetProcessEvent(eventData, fieldName, values);
        }

        public static int GetUnreadMailCount()
        {
            Webservices webservice = new Webservices();
            return webservice.GetUnreadMailCount();
        }

        public static int GetOpenProcessCount()
        {
            Webservices webservice = new Webservices();
            return webservice.GetOpenProcessCount();
        }

        public static int GetOpenProcessCount(int bpIDProcess)
        {
            Webservices webservice = new Webservices();
            return webservice.GetOpenProcessCount(bpIDProcess);
        }

        public static Master_Roles[] GetRoles(int bpID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetRoles(bpID);
        }

        public static int GetDefaultRoleID(int bpID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetDefaultRoleID(bpID);
        }

        public static Master_AccessAreas[] GetAccessAreas(int bpID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetAccessAreas(bpID);
        }

        public static int GetDefaultAccessAreaID(int bpID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetDefaultAccessAreaID(bpID);
        }

        public static Master_TimeSlotGroups[] GetTimeSlotGroups(int bpID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetTimeSlotGroups(bpID);
        }

        public static int GetDefaultTimeSlotGroupID(int bpID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetDefaultTimeSlotGroupID(bpID);
        }

        public static int GetDefaultSTAccessAreaID(int bpID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetDefaultSTAccessAreaID(bpID);
        }

        public static int GetDefaultSTTimeSlotGroupID(int bpID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetDefaultSTTimeSlotGroupID(bpID);
        }

        public static int SetDefaultAccessAreaForUser(int employeeID, int accessAreaID, int timeSlotGroupID)
        {
            Webservices webservice = new Webservices();
            return webservice.SetDefaultAccessAreaForUser(employeeID, accessAreaID, timeSlotGroupID);
        }

        public static int SetDefaultAccessAreaForVisitor(int employeeID, int accessAreaID, int timeSlotGroupID)
        {
            Webservices webservice = new Webservices();
            return webservice.SetDefaultAccessAreaForVisitor(employeeID, accessAreaID, timeSlotGroupID);
        }

        public static Master_Passes GetPassData(string chipID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetPassData(chipID);
        }

        public static CultureInfo[] GetCultures(CultureTypes type)
        {
            CultureInfo[] cultures = CultureInfo.GetCultures(type);
            Array.Sort<CultureInfo>(cultures, new NamePropertyComparer<CultureInfo>());
            return cultures;
        }

        public static RegionInfo[] GetRegions(CultureInfo[] cultures)
        {
            List<RegionInfo> regions = new List<RegionInfo>();
            foreach (CultureInfo culture in cultures)
            {
                RegionInfo region = null;
                try
                {
                    region = new RegionInfo(culture.LCID);
                }
                catch
                {
                }
                if (region != null && !regions.Contains(region))
                {
                    regions.Add(region);
                }
            }

            RegionInfo[] regionsArray = regions.ToArray();
            Array.Sort<RegionInfo>(regionsArray, new NamePropertyComparer<RegionInfo>());
            return regionsArray;
        }

        public class NamePropertyComparer<T> : IComparer<T>
        {
            public int Compare(T x, T y)
            {
                if (x == null)
                    if (y == null)
                        return 0;
                    else
                        return -1;

                PropertyInfo pX = x.GetType().GetProperty("Name");
                PropertyInfo pY = y.GetType().GetProperty("Name");
                return String.Compare((string)pX.GetValue(x, null), (string)pY.GetValue(y, null));
            }
        }

        public static System_Variables[] GetVariables(int fieldID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetVariables(fieldID);
        }

        public static System_Variables[] GetVariablesByFieldName(string fieldName)
        {
            Webservices webservice = new Webservices();
            return webservice.GetVariablesByFieldName(fieldName);
        }

        public static Master_Translations GetTranslation(string fieldName, string languageID, Tuple<string, string>[] values)
        {
            Webservices webservice = new Webservices();
            return webservice.GetTranslation(fieldName, languageID, values);
        }

        public static GetShortTermVisitors_Result[] GetShortTermVisitors()
        {
            Webservices webservice = new Webservices();
            return webservice.GetShortTermVisitors();
        }

        public static System_Tables[] GetHistoryTables()
        {
            Webservices webservice = new Webservices();
            return webservice.GetHistoryTables();
        }

        public static Master_Users[] GetUsers()
        {
            Webservices webservice = new Webservices();
            return webservice.GetUsers();
        }

        public static Master_Users GetUser(int userID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetUser(userID);
        }

        public static GetPresentPersonsCount_Result GetPresentPersonsCount()
        {
            Webservices webservice = new Webservices();
            return webservice.GetPresentPersonsCount();
        }

        public static GetTemplates_Result[] GetTemplates(
            string dialogName,
            bool withFileData)
        {
            Webservices webservice = new Webservices();
            return webservice.GetTemplates(
                dialogName,
                withFileData,
                Convert.ToInt32(HttpContext.Current.Session["BpID"]));
        }

        public static GetTemplates_Result[] GetTemplates(
            string dialogName,
            bool withFileData,
            int bpID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetTemplates(
                dialogName,
                withFileData,
                bpID);
        }

        public static Master_Templates GetTemplate(int templateID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetTemplate(templateID);
        }

        public static DateTime FirstDayOfWeek(DateTime date)
        {
            DayOfWeek fdow = CultureInfo.CurrentCulture.DateTimeFormat.FirstDayOfWeek;
            int offset = fdow - date.DayOfWeek;
            DateTime fdowDate = date.AddDays(offset);
            return fdowDate;
        }

        public static DateTime LastDayOfWeek(DateTime date)
        {
            DateTime ldowDate = FirstDayOfWeek(date).AddDays(6);
            return ldowDate;
        }

        public static void ProtectWorksheet(ref ExcelWorksheet ws)
        {
            ws.Protection.AllowAutoFilter = true;
            ws.Protection.AllowDeleteColumns = false;
            ws.Protection.AllowDeleteRows = false;
            ws.Protection.AllowEditObject = true;
            ws.Protection.AllowEditScenarios = true;
            ws.Protection.AllowFormatCells = true;
            ws.Protection.AllowFormatColumns = true;
            ws.Protection.AllowFormatRows = true;
            ws.Protection.AllowInsertColumns = false;
            ws.Protection.AllowInsertHyperlinks = false;
            ws.Protection.AllowInsertRows = false;
            ws.Protection.AllowPivotTables = true;
            ws.Protection.AllowSelectLockedCells = true;
            ws.Protection.AllowSelectUnlockedCells = true;
            ws.Protection.AllowSort = true;

            ws.Protection.IsProtected = true;
            ws.Protection.SetPassword(Guid.NewGuid().ToString());
        }

        public static int SendMessage(int jobID, int receiverID, string subject, string body)
        {
            Webservices webservice = new Webservices();
            return webservice.SendMessage(jobID, receiverID, subject, body);
        }

        public static int SendMessageToUsersWithRight(int bpID, int jobID, int dialogID, int actionID, string subject, string body)
        {
            Webservices webservice = new Webservices();
            return webservice.SendMessageToUsersWithRight(bpID, jobID, dialogID, actionID, subject, body);
        }

        public static GetCompanyTariff_Result GetCompanyTariff(int companyID, int tariffScopeID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetCompanyTariff(companyID, tariffScopeID);
        }

        public static GetCompanyInfo_Result[] GetCompanyInfo(int companyID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetCompanyInfo(companyID);
        }

        public static Pass GetPass(int employeeID, bool withFileData)
        {
            Webservices webservice = new Webservices();
            return webservice.GetPass(employeeID, withFileData);
        }

        public static ShortTermPassPrint GetShortTermPassPrint(int printID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetShortTermPassPrint(printID);
        }

        public static GetPresentPersonsPerAccessArea_Result[] GetPresentPersonsPerAccessArea()
        {
            Webservices webservice = new Webservices();
            return webservice.GetPresentPersonsPerAccessArea();
        }

        public static void StartMasterTimer(MasterPage master)
        {
            SetMasterTimer(master, true);
        }

        public static void StopMasterTimer(MasterPage master)
        {
            SetMasterTimer(master, false);
        }

        public static void SetMasterTimer(MasterPage master, bool enabled)
        {
            int interval = 0;
            if (enabled)
            {
                interval = Convert.ToInt32(ConfigurationManager.AppSettings["MasterTimerInterval"]) * 1000;
            }
            SetMasterTimer(master, enabled, interval);
        }

        public static void SetMasterTimer(MasterPage master, bool enabled, int interval)
        {
            Timer timer = master.FindControl("TimerMaster") as Timer;
            if (timer != null)
            {
                timer.Enabled = enabled;
                if (enabled)
                {
                    if (interval == 0)
                    {
                        interval = Convert.ToInt32(ConfigurationManager.AppSettings["MasterTimerInterval"]) * 1000;
                    }
                    timer.Interval = interval;
                }
            }
        }

        public static GetPassInfo_Result[] GetPassInfo(string internalID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetPassInfo(internalID);
        }

        public static Master_CompanyContacts GetCompanyMWContact(int companyID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetCompanyMWContact(companyID);
        }

        public static Master_Users GetCompanyAdmin(int companyID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetCompanyAdmin(companyID);
        }

        public static bool HasRightForDialog(int dialogID, int roleID)
        {
            Webservices webservice = new Webservices();
            return webservice.HasRightForDialog(dialogID, roleID);
        }
        
        public static bool HasRightForDialog(string dialogName)
        {
            int dialogID = GetDialogID(dialogName);
            bool hasRight = false;
            if (HttpContext.Current.Session["RoleID"] != null)
            {
                int roleID = Convert.ToInt32(HttpContext.Current.Session["RoleID"]);
                hasRight = HasRightForDialog(dialogID, roleID);
            }

            return hasRight;
        }

        public static byte[] GetRelevantDocumentImage(int relevantDocumentID, int maxWidth, int maxHeight)
        {
            Webservices webservice = new Webservices();
            return webservice.GetRelevantDocumentImage(relevantDocumentID, maxWidth, maxHeight);
        }

        public static bool IsValidEmail(string strIn)
        {
            // Return true if strIn is in valid e-mail format.
            return Regex.IsMatch(strIn,
                                       @"^(?("")("".+?""@)|(([0-9a-zA-Z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-zA-Z])@))" +
                                       @"(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,6}))$");
        }

        public static Document RenderReport(string reportParameter)
        {
            Webservices webservice = new Webservices();
            return webservice.RenderReport(reportParameter);
        }

        public static bool IsPassCaseFirstIssue(int replacementPassCaseID)
        {
            Webservices webservice = new Webservices();
            return webservice.IsPassCaseFirstIssue(replacementPassCaseID);
        }

        public static string HtmlToPlainText(string html)
        {
            const string TagWhiteSpace = @"(>|$)(\W|\n|\r)+<";//matches one or more (white space or line breaks) between '>' and '<'
            const string StripFormatting = @"<[^>]*(>|$)";//match any character between '<' and '>', even when end tag is missing
            const string LineBreak = @"<(br|BR)\s{0,1}\/{0,1}>";//matches: <br>,<br/>,<br />,<BR>,<BR/>,<BR />
            var lineBreakRegex = new Regex(LineBreak, RegexOptions.Multiline);
            var stripFormattingRegex = new Regex(StripFormatting, RegexOptions.Multiline);
            var tagWhiteSpaceRegex = new Regex(TagWhiteSpace, RegexOptions.Multiline);

            var text = html;
            //Decode html specific characters
            text = System.Net.WebUtility.HtmlDecode(text);
            //Remove tag whitespace/line breaks
            text = tagWhiteSpaceRegex.Replace(text, "><");
            //Replace <br /> with line breaks
            text = lineBreakRegex.Replace(text, Environment.NewLine);
            //Strip formatting
            text = stripFormattingRegex.Replace(text, string.Empty);

            return text;
        }

        public static GetEmployeeDuplicates_Result[] GetEmployeeDuplicates(int employeeID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetEmployeeDuplicates(employeeID);
        }

        public static GetCompanyCentralDuplicates_Result[] GetCompanyCentralDuplicates(int companyID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetCompanyCentralDuplicates(companyID);
        }

        public static GetUserDuplicates_Result[] GetUserDuplicates(int userID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetUserDuplicates(userID);
        }

        public static int GetMainContractorStatus(int companyID)
        {
            Webservices webservice = new Webservices();
            return webservice.GetMainContractorStatus(companyID);
        }

        public static bool EmploymentStatusMWObligate(int employmentStatusID)
        {
            Webservices webservice = new Webservices();
            return webservice.EmploymentStatusMWObligate(employmentStatusID);
        }

        public static DateTime BeginOfMonth(DateTime monthDate)
        {
            DateTime beginOfMonth = new DateTime(monthDate.Year, monthDate.Month, 1, 0, 0, 0);
            return beginOfMonth;
        }

        public static DateTime EndOfMonth(DateTime monthDate)
        {
            DateTime endOfMonth = BeginOfMonth(monthDate).AddMonths(1).AddSeconds(-1);
            return endOfMonth;
        }
    }
}