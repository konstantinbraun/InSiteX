<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeeAccessRightInfo.aspx.cs" Inherits="InSite.App.Views.Main.EmployeeAccessRightInfo" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server" id="Header">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link href="/InSiteApp/Styles/DefaultStyleSheet.css" rel="stylesheet" type="text/css" />
        <link rel="shortcut icon" href="/InSiteApp/Resources/Images/favicon.ico" />

        <title></title>

        <telerik:RadScriptBlock ID="ScriptBlock3" runat="server">
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
        </telerik:RadScriptBlock>
    </head>

    <body>
        <form id="form1" runat="server">
            <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>

            <fieldset runat="server" style="border-style: none;">

                <table cellpadding="3px" align="left" >
                    <tr>
                        <td>
                            <asp:Label runat="server" ID="Label1" Text='<%$ Resources:Resource, lblID %>'></asp:Label>
                        </td>
                        <td>
                            <asp:Label runat="server" ID="EmployeeID1">
                            </asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label runat="server" ID="Label2" Text='<%$ Resources:Resource, lblAddrLastName %>'></asp:Label>
                        </td>
                        <td>
                            <asp:label runat="server" ID="LastName"></asp:label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label runat="server" ID="Label3" Text='<%$ Resources:Resource, lblAddrFirstName %>'></asp:Label>
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
                            <asp:Label runat="server" ID="Label4" Text='<%$ Resources:Resource, lblPrintedPassID %>'></asp:Label>
                        </td>
                        <td>
                            <asp:label runat="server" ID="ExternalPassID"></asp:label>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap">
                            <asp:Label runat="server" ID="Label5" Text='<%$ Resources:Resource, lblInternalPassID %>'></asp:Label>
                        </td>
                        <td>
                            <asp:label runat="server" ID="InternalPassID"></asp:label>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap">
                            <asp:Label runat="server" ID="Label6" Text='<%$ Resources:Resource, lblPassActive %>'></asp:Label>
                        </td>
                        <td>
                            <asp:CheckBox runat="server" ID="IsActive" Enabled="false"></asp:CheckBox>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap">
                            <asp:Label runat="server" ID="Label7" Text='<%$ Resources:Resource, lblValidTo %>'></asp:Label>
                        </td>
                        <td>
                            <asp:label runat="server" ID="ValidUntil"></asp:label>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap">
                            <asp:Label runat="server" ID="Label8" Text='<%$ Resources:Resource, lblAccessAllowed %>'></asp:Label>
                        </td>
                        <td>
                            <asp:CheckBox runat="server" ID="AccessAllowed" Enabled="false"></asp:CheckBox>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap">
                            <asp:Label runat="server" ID="Label9" Text='<%$ Resources:Resource, lblDenialReasons %>'></asp:Label>
                        </td>
                        <td>
                            <asp:label runat="server" ID="DenialReasons"></asp:label>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap">
                            <asp:Label runat="server" ID="Label10" Text='<%$ Resources:Resource, lblMessage %>'></asp:Label>
                        </td>
                        <td>
                            <asp:label runat="server" ID="Message"></asp:label>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap">
                            <asp:Label runat="server" ID="Label15" Text='<%$ Resources:Resource, lblFrom %>'></asp:Label> -
                            <asp:Label runat="server" ID="Label16" Text='<%$ Resources:Resource, lblUntil %>'></asp:Label>
                        </td>
                        <td>
                            <asp:label runat="server" ID="MessageFrom"></asp:label> -
                            <asp:label runat="server" ID="MessageUntil"></asp:label>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap">
                            <asp:Label runat="server" ID="Label11" Text='<%$ Resources:Resource, lblDeliveredToAccessControl %>'></asp:Label>
                        </td>
                        <td>
                            <asp:label runat="server" ID="DeliveredAt"></asp:label>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap">
                            <asp:Label runat="server" ID="Label12" Text='<%$ Resources:Resource, lblDeliveryMessage %>'></asp:Label>
                        </td>
                        <td>
                            <asp:label runat="server" ID="DeliveryMessage"></asp:label>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp; </td>
                        <td>&nbsp; </td>
                    </tr>
                </table>
                <table cellpadding="3px" align="left" >
                    <tr>
                        <td nowrap="nowrap" colspan="2">
                            <asp:Label runat="server" ID="Label17" Text='<%$ Resources:Resource, lblAssignedAreas %>'></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap" colspan="2">
                            <telerik:RadGrid runat="server" ID="AssignedAreasInfo" AutoGenerateColumns="false">
                                <MasterTableView>
                                    <Columns>
                                        <telerik:GridBoundColumn DataField="AccessAreaName" HeaderText="<%$ Resources:Resource, lblAccessArea %>"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="TimeSlotName" HeaderText="<%$ Resources:Resource, lblTimeSlot %>"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ValidFrom" DataFormatString="{0:g}" HeaderText="<%$ Resources:Resource, lblValidFrom %>"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ValidUntil" DataFormatString="{0:g}" HeaderText="<%$ Resources:Resource, lblValidTo %>"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="ValidDays" HeaderText="<%$ Resources:Resource, lblValidDays %>"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="TimeFrom" DataFormatString="{0:t}" HeaderText="<%$ Resources:Resource, lblTimeFrom %>"></telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn DataField="TimeUntil" DataFormatString="{0:t}" HeaderText="<%$ Resources:Resource, lblTimeUntil %>"></telerik:GridBoundColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:RadGrid>
                            <asp:label runat="server" ID="Label14"></asp:label>
                        </td>
                    </tr>

                    <tr>
                        <td>&nbsp; </td>
                        <td>&nbsp; </td>
                    </tr>
                    <tr>
                        <td>&nbsp; </td>
                        <td style="text-align: right;" nowrap="nowrap">
                            <telerik:RadButton ID="BtnCancel" Text='<%$ Resources:Resource, lblActionClose %>' runat="server" CausesValidation="False"
                                               CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel" OnClick="BtnCancel_Click">
                            </telerik:RadButton>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </form>
    </body>
</html>
