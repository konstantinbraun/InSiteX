<%@ Page Title="<%$ Resources:Resource, lblReportTrades %>" Language="C#" AutoEventWireup="true" CodeBehind="TradesReport.aspx.cs" Inherits="InSite.App.Views.Reports.TradesReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
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
                        oWindow = window.radWindow;
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

            <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
                <AjaxSettings>
                    <telerik:AjaxSetting AjaxControlID="DateTimeFrom">
                        <UpdatedControls>
                            <telerik:AjaxUpdatedControl ControlID="DateTimeUntil" />
                        </UpdatedControls>
                    </telerik:AjaxSetting>
                </AjaxSettings>
            </telerik:RadAjaxManager>

            <telerik:RadNotification ID="Notification1" runat="server" TitleIcon="~/Resources/Icons/TitleIcon.png" Animation="Slide" 
                                     AutoCloseDelay="2000" EnableRoundedCorners="True" EnableShadow="True" Position="Center" VisibleOnPageLoad="False"
                                     CloseButtonToolTip="<%$ Resources:Resource, lblActionClose %>" ContentIcon="info" KeepOnMouseOver="true">
            </telerik:RadNotification>

            <table cellpadding="3px" style="padding: 5px; margin-right: 10px;">
                <tr>
                    <td>
                        <asp:Label ID="LabelAccess" runat="server" Text="<%$ Resources:Resource, lblAccess %>" Font-Bold="true"></asp:Label>
                    </td>
                    <td style="text-align: left; vertical-align: bottom" nowrap="nowrap">
                        <table>
                            <tr>
                                <td>
                                    <asp:Label ID="Label1" runat="server" Text="<%$ Resources:Resource, lblBetweenToLower %>" Font-Bold="true"></asp:Label>
                                </td>
                                <td>
                                    <telerik:RadDatePicker ID="DateTimeFrom" runat="server" MinDate="1900/1/1" EnableShadows="true" OnSelectedDateChanged="DateTimeFrom_SelectedDateChanged"
                                                           ShowPopupOnFocus="true" AutoPostBack="true" Width="120px">
                                        <ClientEvents OnPopupOpening="AdjustRadWindow" OnPopupClosing="AdjustRadWindow" />
                                        <Calendar runat="server">
                                            <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                                    TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                            </FastNavigationSettings>
                                        </Calendar>
                                    </telerik:RadDatePicker>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="DateTimeFrom" ErrorMessage="<%$ Resources:Resource, msgDateFromRequired %>" Text="*" 
                                                                SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                    </asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources:Resource, lblAndToLower %>" Font-Bold="true"></asp:Label>
                                </td>
                                <td>
                                    <telerik:RadDatePicker ID="DateTimeUntil" runat="server" MinDate="1900/1/1" EnableShadows="true"
                                                           ShowPopupOnFocus="true" Width="120px" >
                                        <ClientEvents OnPopupOpening="AdjustRadWindow" OnPopupClosing="AdjustRadWindow" />
                                        <Calendar runat="server">
                                            <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                                    TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                            </FastNavigationSettings>
                                        </Calendar>
                                    </telerik:RadDatePicker>
                                </td>
                                <td>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="DateTimeUntil" ErrorMessage="<%$ Resources:Resource, msgDateUntilRequired %>" Text="*" 
                                                                SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                    </asp:RequiredFieldValidator>
                                    <asp:CompareValidator runat="server" ControlToValidate="DateTimeUntil" ControlToCompare="DateTimeFrom" ValueToCompare="SelectedDate" Operator="GreaterThan"
                                                          Text="*" SetFocusOnError="true" ForeColor="Red" ErrorMessage="<%$ Resources:Resource, msgDateFromLargerDateUntil %>" ValidationGroup="Submit">
                                    </asp:CompareValidator>
                                </td>
                            </tr>
                        </table>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td nowrap="nowrap">
                        <asp:Label runat="server" ID="LabelTemplate" Text='<%$ Resources:Resource, lblTemplate %>'></asp:Label>
                    </td>
                    <td colspan="2">
                        <telerik:RadComboBox runat="server" ID="TemplateID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                             Width="300" OnClientKeyPressing="OnClientKeyPressing"
                                             AppendDataBoundItems="true" Filter="Contains" DropDownAutoWidth="Enabled" OnClientDropDownOpening="AdjustRadWindow"
                                             OnClientDropDownClosing="AdjustRadWindow">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblDefault %>" Value="0" Selected="true" />
                            </Items>
                        </telerik:RadComboBox>
                    </td>
                </tr>
                <tr>
                    <td nowrap="nowrap">
                        <asp:Label runat="server" ID="LabelRemark" Text='<%$ Resources:Resource, lblRemarks %>'></asp:Label>
                    </td>
                    <td colspan="2">
                        <telerik:RadTextBox runat="server" ID="Remarks" Width="300px" TextMode="MultiLine"></telerik:RadTextBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <asp:ValidationSummary runat="server" DisplayMode="BulletList" ShowMessageBox="true" ShowSummary="true" BorderStyle="None"  
                                               ValidationGroup="Submit" ForeColor="Red" />
                    </td>
                </tr>
                <tr>
                    <td>&nbsp; </td>
                    <td>&nbsp; </td>
                    <td>&nbsp; </td>
                </tr>
                <tr>
                    <td style="text-align: right;" nowrap="nowrap" colspan="3">
                        <telerik:RadButton runat="server" Text="<%$ Resources:Resource, lblCancel %>" ID="BtnCancel" OnClick="BtnCancel_Click" />
                        <telerik:RadButton ID="btnExportExcel" runat="server" Text="<%$ Resources:Resource, lblExportToExcel %>" ToolTip="<%$ Resources:Resource, lblExportToExcel %>" 
                                           OnClick="BtnOK_Click" ButtonType="StandardButton" CommandArgument="Excel" ValidationGroup="Submit">
                            <Icon PrimaryIconUrl="/InSiteApp/Resources/Icons/export_xlsx_16.png" />
                        </telerik:RadButton>
                        <telerik:RadButton ID="btnExportPdf" runat="server" Text="<%$ Resources:Resource, lblExportToPdf %>" ToolTip="<%$ Resources:Resource, lblExportToPdf %>" 
                                           OnClick="BtnOK_Click" ButtonType="StandardButton" CommandArgument="Pdf" ValidationGroup="Submit">
                            <Icon PrimaryIconUrl="/InSiteApp/Resources/Icons/export_pdf_16.png" />
                        </telerik:RadButton>
                    </td>
                </tr>
            </table>

            <asp:SqlDataSource ID="SqlDataSource_AccessAreas" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                               SelectCommand="SELECT DISTINCT * FROM Master_AccessAreas aa WHERE aa.SystemID = @SystemID AND aa.BpID = @BpID">
                <SelectParameters>
                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="SqlDataSource_Companies" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                               SelectCommand="SELECT c.SystemID, c.BpID, c.CompanyID, (CASE WHEN @CompanyID > 0 THEN NULL ELSE (CASE WHEN c.ParentID = 0 THEN NULL ELSE c.ParentID END) END) AS ParentID, c.NameVisible, c.NameAdditional, c.Description, c.AddressID, c.IsVisible, c.IsValid, c.TradeAssociation, c.BlnSOKA, c.CreatedFrom, c.CreatedOn, c.EditFrom, c.EditOn, a.Address1, a.Address2, a.Zip, a.City, a.State, a.CountryID, a.Phone, a.Email, a.WWW, c.NameVisible + (CASE WHEN c.NameAdditional IS NULL THEN '' ELSE ', ' + c.NameAdditional END) + (CASE WHEN a.City IS NULL THEN '' ELSE ', ' + a.City END) AS CompanyName FROM Master_Companies AS c LEFT OUTER JOIN System_Addresses AS a ON c.SystemID = a.SystemID AND c.AddressID = a.AddressID WHERE (c.SystemID = @SystemID) AND (c.BpID = @BpID) AND (c.ReleaseOn IS NOT NULL) AND (c.LockedOn IS NULL) AND (c.CompanyCentralID = (CASE WHEN @CompanyID = 0 THEN c.CompanyCentralID ELSE @CompanyID END)) ORDER BY c.NameVisible">
                <SelectParameters>
                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                    <asp:SessionParameter SessionField="CompanyID" DefaultValue="0" Name="CompanyID"></asp:SessionParameter>
                </SelectParameters>
            </asp:SqlDataSource>
        </form>
    </body>
</html>
