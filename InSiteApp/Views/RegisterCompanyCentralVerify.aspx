<%@ Page Title="<%$ Resources:Resource, lblRegisterCompany %>" Language="C#" AutoEventWireup="true" CodeBehind="RegisterCompanyCentralVerify.aspx.cs" Inherits="InSite.App.Views.RegisterCompanyCentralVerify" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link href="~/Styles/DefaultStyleSheet.css" rel="stylesheet" type="text/css" />
        <link rel="shortcut icon" href="~/Resources/Images/favicon.ico" />

        <title></title>
    </head>

    <body style="background-color: transparent;" >
        <form id="form1" runat="server">

            <div style="margin: 0 auto; _margin: auto; margin-top: 20px; text-align: center; width: 960px; _width: 100%;" class="PanelShadow">
                <div style="border: 0px solid #ff0000; width: 960px; padding: 8px 0 0 0px; border-radius: 5px;">
                    <div style="text-align: left; border-radius: 5px;">
                        <div style="width: 960px; margin-top: -10px; padding-bottom: 5px; height: 56px; border-top-left-radius: 5px; border-top-right-radius: 5px;" class="Gradient">
                            <table style="width: 100%;">
                                <tr>
                                    <td>
                                        <img alt="Logo" src="/InSiteApp/Resources/Images/zeppelin_logo_transparent_150x56.png" />
                                    </td>
                                    <td style="vertical-align: middle; text-align: center;">
                                        <asp:Label runat="server" ID="PageTitle" Style="font-size: 16px; font-weight: bold;">
                                        </asp:Label>
                                    </td>
                                    <td style="text-align: right; padding-right: 15px;">
                                        <asp:Label runat="server" Text="<%$ Resources:Resource, appName %>" Font-Bold="true" ForeColor="#5D686D" style="font-size: large">
                                        </asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </div>

                            <asp:Panel runat="server" ID="VerifyOK" Visible="false">
                                <table cellpadding="5px">
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" Text="<%$ Resources:Resource, msgVerifyOK %>" Font-Bold="true"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Button runat="server" PostBackUrl="~/Views/Login.aspx" Text="<%$ Resources:Resource, lblOK %>" />
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <asp:Panel runat="server" ID="VerifyFailed">
                                <table cellpadding="5px">
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" Text="<%$ Resources:Resource, msgVerifyFailed %>" Font-Bold="true"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Button runat="server" PostBackUrl="~/Views/Login.aspx" Text="<%$ Resources:Resource, lblOK %>" />
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                    </div>
                </div>
            </div>
        </form>
    </body>
</html>
