using InSite.App.UserServices;
using System;
using System.Collections.Generic;
using System.Net;
using System.Text;

namespace InSite.App.Views
{
    public partial class HtmlViewer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int systemID = 1;
            if (Session["SystemID"] != null)
            {
                systemID = Convert.ToInt32(Session["SystemID"]);
            }

            int bpID = 1;
            if (Session["BpID"] != null)
            {
                bpID = Convert.ToInt32(Session["BpID"]);
            }

            string languageID = "de";
            if (Session["LanguageID"] != null)
            {
                languageID = Session["LanguageID"].ToString();
            }

            List<Tuple<string, string>> values = new List<Tuple<string, string>>();
            Master_Translations translation = Helpers.GetTranslation("PrivacyPolicy", languageID, values.ToArray());
            if (translation != null && translation.HtmlTranslated != null && !translation.HtmlTranslated.Equals(string.Empty))
            {
                RadEditor1.Content = translation.HtmlTranslated;
            }
        }
    }
}