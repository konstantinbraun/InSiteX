<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Preview.aspx.cs" Inherits="Preview" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="Style.css" type="text/css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <h4>
            <b>Does it work?</b></h4>
        <h5>
            You're supposed to see captured image below.<br />
            If you don't, it's time to throw away your old pc fellow from your window :-(<br />
            Just kidding though, seriously, can't you see? Maybe you should try again?<br />
            <br />
            <b>
                <asp:HyperLink ID="lnkBack" runat="server" NavigateUrl="~/Default.aspx">Take me back</asp:HyperLink></b></h5>
        <br />
        <asp:Image ID="imgCaptured" runat="server" />
    </div>
    </form>
</body>
</html>
