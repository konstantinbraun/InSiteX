<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PassActions.aspx.cs" Inherits="InSite.App.Views.Main.PassActions" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

    <head runat="server" id="Header">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link href="/InSiteApp/Styles/DefaultStyleSheet.css" rel="stylesheet" type="text/css" />
        <link rel="shortcut icon" href="/InSiteApp/Resources/Images/favicon.ico" />

        <title></title>

        <telerik:RadCodeBlock runat="server">
            <script type="text/javascript">

                function OnClientKeyPressing(sender, args) {
                    sender.showDropDown();
                }

                function cancelAndClose() {
                    var employeeID = document.getElementById("EmployeeID").getValue;
                    parent.cardReader.unregister(passActions);
                    GetRadWindow().close(employeeID);
                }

                function GetRadWindow() {
                    var oWindow = null;
                    if (window.radWindow)
                        oWindow = window.radWindow;
                    else if (window.frameElement.radWindow)
                        oWindow = window.frameElement.radWindow;
                    return oWindow;
                }

                function getValueFromApplet(myParam, myParam2) {
                    var theForm = document.getElementById("myform");
                    var myID = document.getElementById("IDInternal");
                    myID.value = myParam;
                    myID = document.getElementById("TAGID");
                    myID.value = myParam;
                    if (myParam2 = "submit") {
                        // theForm.submit();
                    }
                }
            
                function showAlert() {
                    var myVersion = document.myApplet.GetVersion();
                    var versionTag = document.getElementById("idFromCard");
                    versionTag.innerHTML = myVersion;
                }

                var passActions = {
                    name: "PassActions",
                    uuid: "AF4F47C0-CECA-4FBA-BB8B-D3ECCF31E571",
                    onmessage: function (cardState) {
                        if (cardState.online == true) {
                            if (typeof cardState.cardId !== "undefined") {
                                var theForm = document.getElementById("myform");
                                var myID = document.getElementById("IDInternal");
                                myID.value = cardState.cardId;
                                myID = document.getElementById("TAGID");
                                myID.value = cardState.cardId;
                            }
                        }
                    }
                }

                document.addEventListener("DOMContentLoaded", function (event) {
                    parent.cardStateColors.setStyleElement(document.getElementById("cardState"));
                    parent.cardReader.register(passActions);
                });

            </script>
        </telerik:RadCodeBlock>
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
                        <td>
                            <asp:Label runat="server" Text='<%$ Resources:Resource, lblID %>'></asp:Label>
                        </td>
                        <td>
                            <asp:Label runat="server" ID="EmployeeID">
                            </asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label runat="server" Text='<%$ Resources:Resource, lblAddrLastName %>'></asp:Label>
                        </td>
                        <td>
                            <asp:label runat="server" ID="LastName"></asp:label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label runat="server" Text='<%$ Resources:Resource, lblAddrFirstName %>'></asp:Label>
                        </td>
                        <td>
                            <asp:label runat="server" ID="FirstName"></asp:label>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp; </td>
                        <td>&nbsp; </td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap">
                            <asp:Label runat="server" ID="LabelReplacementPassCaseID" Text='<%$ Resources:Resource, lblPrintPassDueTo %>'></asp:Label>
                        </td>
                        <td nowrap="nowrap">
                            <telerik:RadComboBox runat="server" ID="ReplacementPassCaseID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                 DataSourceID="SqlDataSource_ReplacementPassCases" DataValueField="ReplacementPassCaseID" DataTextField="NameVisible" Width="300" 
                                                 AppendDataBoundItems="true" Filter="Contains" OnItemDataBound="ReplacementPassCaseID_ItemDataBound">
                            </telerik:RadComboBox>
                            <asp:RequiredFieldValidator runat="server" ID="ValidatorReplacementPassCaseID" ControlToValidate="ReplacementPassCaseID" 
                                                        ErrorMessage='<%$ Resources:Resource, msgReplacementPassCaseObligate %>' Text="*" SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                            </asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="LabelReason" runat="server" Text="<%$ Resources:Resource, lblReason %>"></asp:Label>
                        </td>
                        <td style="text-align: left; vertical-align: bottom" nowrap="nowrap">
                            <telerik:RadTextBox runat="server" ID="Reason" Width="300px"></telerik:RadTextBox>
                            <asp:RequiredFieldValidator runat="server" ID="ValidatorReason" ControlToValidate="Reason" ErrorMessage='<%$ Resources:Resource, msgReasonObligate %>' 
                                                        Text="*" SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                            </asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label runat="server" ID="LabelAccessRightValidUntil" Text="<%$ Resources:Resource, lblAccessRightValidUntil %>" Visible="false"></asp:Label>
                        </td>
                        <td>
                            <telerik:RadDatePicker ID="AccessRightValidUntil" runat="server" MinDate="1900/1/1" MaxDate="2100/1/1" Visible="false" 
                                                   EnableShadows="true" ShowPopupOnFocus="true">
                                <Calendar runat="server">
                                    <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                            TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                    </FastNavigationSettings>
                                </Calendar>
                            </telerik:RadDatePicker>
                            <asp:RequiredFieldValidator runat="server" ID="ValidatorAccessRightValidUntil" ControlToValidate="AccessRightValidUntil" Visible="false" Enabled="false"
                                                        ErrorMessage='<%$ Resources:Resource, msgAccessRightValidUntilObligate %>' Text="*" SetFocusOnError="true" ForeColor="Red" 
                                                        ValidationGroup="Submit">
                            </asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="LabelIDInternal" runat="server" Text="<%$ Resources:Resource, lblChipID %>"></asp:Label>
                        </td>
                        <td style="text-align: left; vertical-align: bottom" nowrap="nowrap">
                            <telerik:RadTextBox runat="server" ID="IDInternal"></telerik:RadTextBox>
                            <asp:RequiredFieldValidator runat="server" ID="ValidatorIDInternal" ControlToValidate="IDInternal" ErrorMessage='<%$ Resources:Resource, msgInternalIDObligate %>' 
                                                        Text="*" SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                            </asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:ValidationSummary runat="server" DisplayMode="BulletList" ShowMessageBox="true" ShowSummary="true" BorderStyle="None"  
                                                   ValidationGroup="Submit" ForeColor="Red" />
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp; </td>
                        <td>&nbsp; </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="LabelReaderState" runat="server" Text="<%$ Resources:Resource, lblReaderState %>"></asp:Label>
                        </td>
                        <td>
                            <asp:Panel runat="server" id="ReaderStatePanel">
                                <applet id="ReaderState" width="160" height="20" archive="/InSiteApp/Controls/InSite3Reader.jar" name="myApplet" code="ChipReader.ChipReaderApp.class">
                                    <%-- <param name="logger" value='<%= String.Concat(ConfigurationManager.AppSettings["LogRoot"].ToString(), "RFIDReader.log") %>' />--%>
                                    <param name="logger" value="off" />
                                    <param name="scripting" value="enabled" />
                                    <param name="scriptName" value="getValueFromApplet" />
                                    <param name="doSubmit" value= "false" />
                                    <param name="ReaderName" value='<%= ConfigurationManager.AppSettings["ReaderName"].ToString() %>' />
                                    <div id="cardState" style="width:160px; height:20px;">
                                    </div>
                                </applet>
                                <div id="idFromCard"></div>
                                <label id="TAGID"></label>
                            </asp:Panel>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp; </td>
                        <td>&nbsp; </td>
                    </tr>
                    <tr>
                        <td>&nbsp; </td>
                        <td style="text-align: right;" nowrap="nowrap">
                            <telerik:RadButton ID="BtnOK" Text="<%$ Resources:Resource, lblActionChange %>" OnClick="BtnOK_Click" ValidationGroup="Submit" 
                                               runat="server"  Icon-PrimaryIconCssClass="rbOk">
                            </telerik:RadButton>
                            <telerik:RadButton ID="BtnCancel" Text='<%$ Resources:Resource, lblActionCancel %>' runat="server" CausesValidation="False"
                                               OnClick="BtnCancel_Click" Icon-PrimaryIconCssClass="rbCancel">
                            </telerik:RadButton>
                        </td>
                    </tr>
                </table>
            </fieldset>

            <asp:SqlDataSource ID="SqlDataSource_ReplacementPassCases" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                               SelectCommand="SELECT SystemID, BpID, ReplacementPassCaseID, NameVisible, DescriptionShort, WillBeCharged, Cost, Currency, InvoiceTo, OldPassInvalid, CreditForOldPass, IsInitialIssue, CreatedFrom, CreatedOn, EditFrom, EditOn FROM Master_ReplacementPassCases WHERE (SystemID = @SystemID) AND (BpID = @BpID) ORDER BY IsInitialIssue DESC, NameVisible">
                <SelectParameters>
                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                </SelectParameters>
            </asp:SqlDataSource>
        </form>
    </body>
</html>
