<%@ Page Title="<%$ Resources:Resource, lblChangeLayout %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Layout.aspx.cs" Inherits="InSite.App.Views.Costumization.Layout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <telerik:RadAjaxPanel runat="server" ID="LayoutPanel">
        <div style="border-radius: 10px; border-style: solid; border-width: 1px; border-color: ActiveBorder; padding: 5px; margin-top: 15px;">
            <table>
                <tr>
                    <td>
                        <asp:Label runat="server" Font-Bold="true" Text="<%$ Resources:Resource, msgChooseLayout %>"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <telerik:RadDropDownList ID="RadDropDownListLayout" runat="server" Width="250px" OnSelectedIndexChanged="RadDropDownListLayout_SelectedIndexChanged" AutoPostBack="true" 
                            LoadingPanelID="RadAjaxLoadingPanelMaster">
                            <Items>
<%--                                <telerik:DropDownListItem runat="server" Text="Black" Value="Black" />
                                <telerik:DropDownListItem runat="server" Text="BlackMetroTouch" Value="BlackMetroTouch" />--%>
                                <telerik:DropDownListItem runat="server" Text="Default" Value="Default" />
<%--                                <telerik:DropDownListItem runat="server" Text="Glow" Value="Glow" />--%>
                                <telerik:DropDownListItem runat="server" Text="Metro" Value="Metro" />
<%--                                <telerik:DropDownListItem runat="server" Text="MetroTouch" Value="MetroTouch" />--%>
                                <telerik:DropDownListItem runat="server" Text="Office2007" Value="Office2007" />
<%--                                <telerik:DropDownListItem runat="server" Text="Office2010Black" Value="Office2010Black" />--%>
                                <telerik:DropDownListItem runat="server" Text="Office2010Blue" Value="Office2010Blue" />
                                <telerik:DropDownListItem runat="server" Text="Office2010Silver" Value="Office2010Silver" Selected="true" />
                                <telerik:DropDownListItem runat="server" Text="Outlook" Value="Outlook" />
                                <telerik:DropDownListItem runat="server" Text="Silk" Value="Silk" />
                                <telerik:DropDownListItem runat="server" Text="Simple" Value="Simple" />
                                <telerik:DropDownListItem runat="server" Text="Sunset" Value="Sunset" />
                                <telerik:DropDownListItem runat="server" Text="Telerik" Value="Telerik" />
                                <telerik:DropDownListItem runat="server" Text="Vista" Value="Vista" />
                                <telerik:DropDownListItem runat="server" Text="Web20" Value="Web20" />
                                <telerik:DropDownListItem runat="server" Text="WebBlue" Value="WebBlue" />
                                <telerik:DropDownListItem runat="server" Text="Windows7" Value="Windows7" />
                            </Items>
                        </telerik:RadDropDownList>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label runat="server" Font-Bold="true" Text="<%$ Resources:Resource, lblSample %>"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div style="border-width: 1px; border-color: lightgray; border-style: solid; margin-top: 5px; width: 180px;">
                            <table cellpadding="3px">
                                <tr>
                                    <td>
                                        <label title="Label">Label</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <input type="text" title="Textbox" value="Textbox" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <input type="button" title="Button" value="Button" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <input type="checkbox" title="Checkbox" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <telerik:RadListBox runat="server" Height="70px" Width="160px">
                                            <Items>
                                                <telerik:RadListBoxItem Text="Streif Baulogistik 1" Value="1" Selected="True"></telerik:RadListBoxItem>
                                                <telerik:RadListBoxItem Text="Streif Baulogistik 2" Value="2"></telerik:RadListBoxItem>
                                                <telerik:RadListBoxItem Text="Streif Baulogistik 3" Value="3"></telerik:RadListBoxItem>
                                                <telerik:RadListBoxItem Text="Streif Baulogistik 4" Value="4"></telerik:RadListBoxItem>
                                                <telerik:RadListBoxItem Text="Streif Baulogistik 5" Value="5"></telerik:RadListBoxItem>
                                                <telerik:RadListBoxItem Text="Streif Baulogistik 6" Value="6"></telerik:RadListBoxItem>
                                            </Items>
                                        </telerik:RadListBox>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right;">
                        <asp:Button runat="server" Text="<%$ Resources:Resource, lblCancel %>" ID="btnCancel" OnClick="btnCancel_Click" />
                        <asp:Button runat="server" Text="<%$ Resources:Resource, lblOK %>" ID="btnOK" OnClick="btnOK_Click" />
                    </td>
                </tr>
            </table>
        </div>

    </telerik:RadAjaxPanel>

    <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadDropDownListLayout">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadDropDownListLayout" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                    <telerik:AjaxUpdatedControl ControlID="LayoutPanel" />
                    <telerik:AjaxUpdatedControl ControlID="RadSkinManager1" />
                    <telerik:AjaxUpdatedControl ControlID="treeView1" />
                    <telerik:AjaxUpdatedControl ControlID="contentView1" />
                    <telerik:AjaxUpdatedControl ControlID="RadMenu1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

</asp:Content>
