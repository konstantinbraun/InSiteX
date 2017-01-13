using System;
using System.Configuration;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using Telerik.Web.UI;
using Telerik.Web.UI.ImageEditor;

namespace InSite.App.Views.Main
{
    public partial class WebCamTest : BasePagePopUp
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);

        String msg = "";
        int addressID = 0;
        string fileName = "";

        const int MaxTotalMBytes = 2; // 2 MB
        const int MaxTotalBytes = MaxTotalMBytes * 1024 * 1024;
        long totalBytes;

        protected void Page_Load(object sender, EventArgs e)
        {
            this.Title = Resources.Resource.lblTakePicture;

            msg = Request.QueryString["AddressID"];
            if (msg != null)
            {
                addressID = Convert.ToInt32(msg);
            }

            fileName = addressID + "_" + DateTime.Now.ToString("yyyyMMddHHmm") + ".jpg";

        }

        public bool? IsRadAsyncValid
        {
            get
            {
                if (Session["IsRadAsyncValid"] == null)
                {
                    Session["IsRadAsyncValid"] = true;
                }

                return Convert.ToBoolean(Session["IsRadAsyncValid"].ToString());
            }
            set
            {
                Session["IsRadAsyncValid"] = value;
            }
        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            IsRadAsyncValid = null;
        }

        protected void EditImage_Click(object sender, EventArgs e)
        {
            LoadImage();
        }

        private void LoadImage()
        {
            if (!txtImgBinary.Text.Equals(string.Empty))
            {
                RadImageEditor1.ResetChanges();

                byte[] bytes = Convert.FromBase64String(txtImgBinary.Text);

                string fullPath = Server.MapPath(String.Concat("..\\..\\UserFiles\\Images\\", fileName));
                // Datei löschen, falls vorhanden
                if (File.Exists(fullPath))
                {
                    File.Delete(fullPath);
                }

                // Stream als Datei speichern 
                MemoryStream ms = new MemoryStream(bytes);
                Image image = Image.FromStream(ms);
                image.Save(fullPath, ImageFormat.Jpeg);

                Session["ImageData"] = txtImgBinary.Text;
                RadImageEditor1.ImageUrl = "/InSiteApp/UserFiles/Images/" + fileName;
            }
        }

        protected void UnloadMe()
        {
            string script = "<script language='javascript' type='text/javascript'>Sys.Application.add_load(cancelAndClose);</script>";
            RadScriptManager.RegisterStartupScript(this, this.GetType(), "cancelAndClose", script, false);
        }

        protected void Cancel_Click(object sender, EventArgs e)
        {
            Session["ImageData"] = null;
            UnloadMe();
        }

        public static string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString;
            }
        }

        protected void OK_Click(object sender, EventArgs e)
        {
            if (IsRadAsyncValid.Value)
            {
                MemoryStream ms = new MemoryStream();
                EditableImage ei = RadImageEditor1.GetEditableImage();

                if (ei != null)
                {
                    ei.CopyToStream(ms);

                    if (ms != null && ms.Length > 0)
                    {
                        byte[] bytes = ms.ToArray();

                        string imageData = Convert.ToBase64String(bytes);
                        Session["ImageData"] = imageData;
                        Session["ImageFileName"] = fileName;

                        UnloadMe();
                    }
                }
            }
        }

        protected void RadImageEditor1_ImageLoading(object sender, ImageEditorLoadingEventArgs e)
        {
            //Handle Uploaded images
            if (!Object.Equals(Context.Cache.Get(Session.SessionID + "UploadedFile"), null))
            {
                using (EditableImage image = new EditableImage((MemoryStream)Context.Cache.Remove(Session.SessionID + "UploadedFile")))
                {
                    e.Image = image.Clone();
                    e.Cancel = true;
                }
            }
        }

        protected void ButtonDummy_Click(object sender, EventArgs e)
        {
            RadImageEditor1.ResetChanges();
            Context.Cache.Remove(Session.SessionID + "UploadedFile");

            if (AsyncUpload1.UploadedFiles.Count > 0)
            {
                UploadedFile file = AsyncUpload1.UploadedFiles[0];

                using (Stream stream = file.InputStream)
                {
                    byte[] imgData = new byte[stream.Length];
                    stream.Read(imgData, 0, imgData.Length);
                    txtImgBinary.Text = Convert.ToBase64String(imgData);
                    Session["ImageData"] = txtImgBinary.Text;
                    MemoryStream ms = new MemoryStream();
                    ms.Write(imgData, 0, imgData.Length);

                    Context.Cache.Insert(Session.SessionID + "UploadedFile", ms, null, DateTime.Now.AddMinutes(20), TimeSpan.Zero);
                }
                ButtonOK.Enabled = true;
            }
        }
    }
}