using InSite.App.BLL;
using InSite.App.Models;
using InSite.App.Models.Interfaces;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.CustomControls
{
    public partial class wcBpSwitcher : System.Web.UI.UserControl
    {
        public void Initalize(ISwitcher switcher)
        {
            RadListBoxAll.DataSource = switcher.GetDataSource(_masterId, false);
            RadListBoxAll.DataBind();
            RadListBoxSelected.DataSource = switcher.GetDataSource(_masterId, true);
            RadListBoxSelected.DataBind();
            lblCaption.Text = switcher.GetCaption();

            Session.Add(this.ID + "_Switcher", switcher);
        }

        public wcBpSwitcher()
        {
            int a = 2;
        }

        private int _masterId;
        public int MasterId {
            get
            {
                return _masterId;
            }
            set
            {
                RadListBoxAll.Attributes.Add( "MasterId",  value.ToString());
                _masterId = value;
            }
        }

        protected void RadListBoxAll_Transferring(object sender, RadListBoxTransferringEventArgs e)
        {
            string _masterId;

            ISwitcher _switcher = (ISwitcher)Session[this.ID + "_Switcher"];

            bool _select = false;
            if (e.SourceListBox.ID == "RadListBoxAll")
            {
                _masterId = e.SourceListBox.Attributes["MasterId"];
                _select = true;
            }
            else
            {
                _masterId = e.DestinationListBox.Attributes["MasterId"];
            }

            foreach (var s in e.Items)
                e.Cancel =  !_switcher.TransferItem(Convert.ToInt32(_masterId), Convert.ToInt32(s.Value), _select);
        }
    }
}