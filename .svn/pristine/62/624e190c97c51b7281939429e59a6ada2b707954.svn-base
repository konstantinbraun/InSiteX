using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Preview : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string binaryData = "";
        //Get the bytes from the session.
        //But those are bytes. We need them in string.
        if (Session["capturedImgBinary"] != null)
            binaryData = Convert.ToBase64String((byte[])Session["capturedImgBinary"]);
        //This is important, that's the only way you can show binary data on Asp:Image element.
        imgCaptured.Attributes.Add("src", "data:image/png;base64," + binaryData);

    }
}