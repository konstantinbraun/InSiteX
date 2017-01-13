<%@ Page Title="<%$ Resources:Resource, lblRequestBp %>" Language="C#" AutoEventWireup="true" CodeBehind="RegisterToBp.aspx.cs" Inherits="InSite.App.Views.Central.RegisterToBp" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

    <head runat="server" id="Header">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link href="/InSiteApp/Styles/DefaultStyleSheet.css" rel="stylesheet" type="text/css" />
        <link rel="shortcut icon" href="/InSiteApp/Resources/Images/favicon.ico" />

        <title></title>

        <telerik:RadScriptBlock runat="server">
            <script type="text/javascript">
                function cancelAndClose() {
                    GetRadWindow().close();
                }

                function GetRadWindow() {
                    var oWindow = null;
                    if (window.radWindow)
                        oWindow = window.frameElement.radWindow;
                    else if (window.frameElement.radWindow)
                        oWindow = window.frameElement.radWindow;
                    return oWindow;
                }

                function OnClientKeyPressing(sender, args) {
                    sender.showDropDown();
                }

                function AdjustRadWindow() {
                    var oWindow = GetRadWindow();
                    setTimeout(function () {
                        oWindow.autoSize(true);
                    }, 320);
                }
            </script>
        </telerik:RadScriptBlock>
    </head>

    <body>
        <form id="form1" runat="server">
            <telerik:RadScriptManager ID="RadScriptManager2" runat="server">
            </telerik:RadScriptManager>

            <telerik:RadNotification ID="Notification1" runat="server" TitleIcon="/InSiteApp/Resources/Icons/TitleIcon.png" Animation="Slide"
                                     AutoCloseDelay="7000" EnableRoundedCorners="True" EnableShadow="True" Position="Center" VisibleOnPageLoad="False"
                                     CloseButtonToolTip="<%$ Resources:Resource, lblActionClose %>" ContentIcon="info" KeepOnMouseOver="true" >
            </telerik:RadNotification>

            <fieldset runat="server" style="border-radius: 10px; border-style: solid; border-width: 1px; border-color: ActiveBorder; padding: 5px; ">

                <table cellpadding="3px" >
                    <tr>
                        <td nowrap="nowrap">
                            <asp:Label runat="server" ID="LabelBpID" Text="<%$ Resources:Resource, lblBuildingProject %>"></asp:Label>
                        </td>
                        <td>
                            <telerik:RadComboBox runat="server" ID="BpID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"  OnClientKeyPressing="OnClientKeyPressing"
                                                 DataValueField="BpID" DataTextField="NameVisible" Width="400px" OnSelectedIndexChanged="BpID_SelectedIndexChanged"
                                                 AppendDataBoundItems="true" Filter="Contains" AutoPostBack="true" DropDownWidth="400px" >
                            </telerik:RadComboBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label runat="server" ID="LabelCompanyID" Text="<%$ Resources:Resource, lblClient %>"></asp:Label>
                        </td>
                        <td>
                            <telerik:RadDropDownTree runat="server" ID="CompanyID" DataFieldParentID="ParentID" DataFieldID="CompanyID" DataValueField="CompanyID" 
                                                        EnableFiltering="true" EnableEmbeddedScripts="true" OnClientKeyPressing="OnClientKeyPressing" 
                                                        DataTextField="NameVisible" Width="400px" DefaultMessage="<%$ Resources:Resource, msgPleaseSelect %>">
                                <ButtonSettings ShowClear="true" />
                                <FilterSettings Highlight="Matches" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" Filter="Contains" />
                                <DropDownSettings OpenDropDownOnLoad="false" CloseDropDownOnSelection="true" Width="400px" AutoWidth="Enabled" />
                            </telerik:RadDropDownTree>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp; </td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp; </td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp; </td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp; </td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp; </td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp; </td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp; </td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp; </td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp; </td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp; </td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp; </td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp; </td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp; </td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp; </td>
                    </tr>
                    <tr>
                        <td style="text-align: right;" nowrap="nowrap" colspan="2">
                            <asp:Button runat="server" Text="<%$ Resources:Resource, lblCancel %>" ID="BtnCancel" OnClick="BtnCancel_Click" />
                            <asp:Button runat="server" Text="<%$ Resources:Resource, lblRegister %>" ID="BtnOK" OnClick="BtnOK_Click" />
                        </td>
                    </tr>
                </table>
            </fieldset>
        </form>
    </body>
</html>
