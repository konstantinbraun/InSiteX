using InSite.App.UserServices;
using System;
using System.Drawing;
using System.Linq;
using System.Web.UI.WebControls;

namespace InSite.App.Controls
{
    public partial class ImagePopUp : System.Web.UI.UserControl
    {
        GetEmployees_Result[] employees = null;

        public string EmployeeID
        {
            get
            {
                if (ViewState["EmployeeID"] == null)
                {
                    return "";
                }
                return (string)ViewState["EmployeeID"];
            }
            set
            {
                ViewState["EmployeeID"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);

            Webservices webservice = new Webservices();
            employees = webservice.GetEmployees(0, Convert.ToInt32(this.EmployeeID), "", 0, 0);
            if (employees[0].ThumbnailData.Length > 0)
            {
                employees[0].PhotoData = webservice.GetEmployeePhotoData(employees[0].EmployeeID);
            }
            this.ImageView.DataSource = employees;

            this.DataBind();
        }

        protected void ImageView_DataBound(object sender, EventArgs e)
        {
            Label lbl = (sender as FormView).FindControl("AccessAllowed") as Label;
            if (employees.Count() > 0)
            {
                string accessAllowed = "";
                if (employees[0].AccessAllowed)
                {
                    accessAllowed += Resources.Resource.lblYes;
                    lbl.ForeColor = Color.Green;
                }
                else
                {
                    accessAllowed += Resources.Resource.lblNo;
                    lbl.ForeColor = Color.Red;
                }
                lbl.Text = accessAllowed;
            }
            else
            {
                lbl.Text = Resources.Resource.lblNo;
                lbl.ForeColor = Color.Red;
            }
        }
    }
}