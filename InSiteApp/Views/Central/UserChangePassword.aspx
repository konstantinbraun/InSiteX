<%@ Page Title="<%$ Resources:Resource, lblChangePwd %>" Language="C#" AutoEventWireup="true" CodeBehind="UserChangePassword.aspx.cs" Inherits="InSite.App.Views.Central.UserChangePassword" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

    <head runat="server" id="Header">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link href="/InSiteApp/Styles/DefaultStyleSheet.css" rel="stylesheet" type="text/css" />
        <link rel="shortcut icon" href="/InSiteApp/Resources/Images/favicon.ico" />

        <title></title>

    </head>

    <body>
        <form id="form1" runat="server">
            <telerik:RadScriptManager ID="RadScriptManager2" runat="server">
            </telerik:RadScriptManager>

            <script type="text/javascript">
                function cancelAndClose() {
                    GetRadWindow().close();
                }

                function GetRadWindow() {
                    var oWindow = null;
                    if (window.radWindow)
                        oWindow = window.radWindow;
                    else if (window.frameElement.radWindow)
                        oWindow = window.frameElement.radWindow;
                    return oWindow;
                }
            </script>

            <telerik:RadNotification ID="Notification1" runat="server" TitleIcon="/InSiteApp/Resources/Icons/TitleIcon.png" Animation="Slide"
                                     AutoCloseDelay="7000" EnableRoundedCorners="True" EnableShadow="True" Position="Center" VisibleOnPageLoad="False"
                                     CloseButtonToolTip="<%$ Resources:Resource, lblActionClose %>" ContentIcon="info" KeepOnMouseOver="true" >
            </telerik:RadNotification>

            <div style="width: 320px; padding-right: 5px;">
                <fieldset runat="server" style="border-radius: 10px; border-style: solid; border-width: 1px; border-color: ActiveBorder; padding: 5px; ">

                    <legend runat="server" id="Legend" title="Willi">
                    </legend>

                    <table cellpadding="3px" width="300px">
                        <tr>
                            <td>
                                <asp:Label runat="server" Text="<%$ Resources:Resource, lblNewPwd %>"></asp:Label>
                            </td>
                            <td style="text-align: right; vertical-align: bottom">
                                <telerik:RadTextBox runat="server" ID="NewPwd" TextMode="Password" AutoCompleteType="Disabled" Width="150px">
                                    <PasswordStrengthSettings ShowIndicator="true" PreferredPasswordLength="6" 
                                                              RequiresUpperAndLowerCaseCharacters="false" TextStrengthDescriptions="<%$ Resources:Resource, lblTextStrengthDescriptions %>" 
                                                              IndicatorElementID="PwdStrength" IndicatorWidth="0" />
                                </telerik:RadTextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" Text="<%$ Resources:Resource, lblPwdStrength %>"></asp:Label>
                            </td>
                            <td>
                                <asp:Label runat="server" ID="PwdStrength" Width="150px"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" Text="<%$ Resources:Resource, lblNewPwdRepeat %>"></asp:Label>
                            </td>
                            <td style="text-align: right; vertical-align: bottom">
                                <telerik:RadTextBox runat="server" ID="NewPwdRepeat" TextMode="Password" AutoCompleteType="Disabled" Width="150px"></telerik:RadTextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp; </td>
                            <td>&nbsp; </td>
                        </tr>
                        <tr>
                            <td>&nbsp; </td>
                            <td style="text-align: right;" nowrap="nowrap">
                                <asp:Button runat="server" Text="<%$ Resources:Resource, lblCancel %>" ID="btnCancel" OnClick="btnCancel_Click" />
                                <asp:Button runat="server" Text="<%$ Resources:Resource, lblActionChange %>" ID="btnOK" OnClick="btnOK_Click" />
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </div>
        </form>
    </body>
</html>
