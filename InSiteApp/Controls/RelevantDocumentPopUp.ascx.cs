using InSite.App.UserServices;
using System;
using System.Linq;

namespace InSite.App.Controls
{
    public partial class RelevantDocumentPopUp : System.Web.UI.UserControl
    {
        GetEmployees_Result[] employees = null;

        public int RelevantDocumentID
        {
            get
            {
                if (ViewState["RelevantDocumentID"] == null)
                {
                    return 0;
                }
                return Convert.ToInt32(ViewState["RelevantDocumentID"]);
            }
            set
            {
                ViewState["RelevantDocumentID"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);

            SampleData.DataValue = Helpers.GetRelevantDocumentImage(RelevantDocumentID, 0, 0);
        }
    }
}