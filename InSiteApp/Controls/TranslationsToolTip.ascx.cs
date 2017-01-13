using System;
using System.Configuration;
using System.Linq;
using System.Web.UI.WebControls;

namespace InSite.App.Controls
{
    public partial class TranslationsToolTip : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public string DialogID
        {
            get
            {
                if (ViewState["DialogID"] == null)
                {
                    return "";
                }
                return (string)ViewState["DialogID"];
            }
            set
            {
                ViewState["DialogID"] = value;
            }
        }

        public string FieldID
        {
            get
            {
                if (ViewState["FieldID"] == null)
                {
                    return "";
                }
                return (string)ViewState["FieldID"];
            }
            set
            {
                ViewState["FieldID"] = value;
            }
        }

        public string LanguageID
        {
            get
            {
                if (ViewState["LanguageID"] == null)
                {
                    return "";
                }
                return (string)ViewState["LanguageID"];
            }
            set
            {
                ViewState["LanguageID"] = value;
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
            this.SqlDataSource_Details.SelectParameters["DialogID"].DefaultValue = this.DialogID;
            this.SqlDataSource_Details.SelectParameters["FieldID"].DefaultValue = this.FieldID;
            this.SqlDataSource_Details.SelectParameters["LanguageID"].DefaultValue = this.LanguageID;
            this.DataBind();

            string flagHome = ConfigurationManager.AppSettings["FlagFilesHome"];
            HiddenField hf = (HiddenField)TranslationToolTip.FindControl("FlagName");
            if (hf != null)
            {
                string flagName = hf.Value;
                if (!flagName.Equals(string.Empty))
                {
                    Image img = (Image)TranslationToolTip.FindControl("ItemImage");
                    img.ImageUrl = string.Concat(flagHome, flagName);
                }
            }
        }

        protected void DialogToolTip_DataBound(object sender, EventArgs e)
        {
        }
    }
}