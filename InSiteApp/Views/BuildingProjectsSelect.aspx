<%@ Page Title="<%$ Resources:Resource, lblBpSelect%>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BuildingProjectsSelect.aspx.cs" Inherits="InSite.App.Views.BuildingProjectsSelect" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <telerik:RadScriptBlock runat="server">
        <script type="text/javascript">
            function OnClientItemDoubleClicked(sender, args) {
                var bpID = args.get_item().get_value();
                var bpName = args.get_item().get_text();
                document.getElementById('BtnSelect').click(sender, args);
            }
        </script>
    </telerik:RadScriptBlock>

    <div style="border-radius: 10px; border-style: solid; border-width: 1px; border-color: ActiveBorder; padding: 5px;">
        <table>
            <tr>
                <td>
                    <asp:Label runat="server" Text="<%$ Resources:Resource, msgPleaseSelect %>">
                    </asp:Label>
                </td>
            </tr>
            <tr>
                <td>&nbsp; </td>
            </tr>
            <tr>
                <td>
                    <telerik:RadListBox ID="RadListBoxBpSelect" runat="server" DataKeyField="BpID" DataSortField="BpName" DataTextField="BpName" DataValueField="BpID"
                                        OnClientItemDoubleClicked="OnClientItemDoubleClicked" SelectionMode="Single">
                        <HeaderTemplate>
                            <table cellpadding="5px" style="text-align: left;">
                                <tr>
                                    <td style="text-align: left; width: 150px;" nowrap="nowrap">
                                        <asp:Label Text="<%$ Resources:Resource, lblBuildingProject %>" Font-Bold="true" runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="text-align: left; padding-left: 5px; width: 250px;" nowrap="nowrap">
                                        <asp:Label Text="<%$ Resources:Resource, lblDescriptionShort %>" Font-Bold="true" runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="text-align: left; padding-left: 5px; width: 150px;" nowrap="nowrap">
                                        <asp:Label Text="<%$ Resources:Resource, lblBuilderName %>" Font-Bold="true" runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="text-align: left; padding-left: 5px; width: 150px;" nowrap="nowrap">
                                        <asp:Label Text="<%$ Resources:Resource, lblRole %>" Font-Bold="true" runat="server">
                                        </asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <table cellpadding="5px" style="text-align: left;">
                                <tr>
                                    <td style="text-align: left; width: 150px;">
                                        <asp:Label ID="BpName" Text='<%# Eval("BpName") %>' runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="text-align: left; padding-left: 5px; width: 250px;">
                                        <asp:Label ID="BpDescription" Text='<%# Eval("BpDescription") %>' runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="text-align: left; padding-left: 5px; width: 150px;">
                                        <asp:Label ID="Label15" Text='<%# Eval("BuilderName") %>' runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="text-align: left; padding-left: 5px; width: 150px;">
                                        <asp:Label ID="Label14" Text='<%# Eval("RoleName") %>' runat="server">
                                        </asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </ItemTemplate>
                    </telerik:RadListBox>
                </td>
            </tr>
            <tr>
                <td>&nbsp; </td>
            </tr>
            <tr>
                <td style="text-align: right">
                    <telerik:RadButton runat="server" Text="<%$ Resources:Resource, lblCancel %>" ID="BtnCancel2" OnClick="BtnCancel_Click" CausesValidation="false"
                                       Icon-PrimaryIconCssClass="rbCancel" />
                    <telerik:RadButton ID="BtnSelect" runat="server" Text="<%$ Resources:Resource, lblActionSelect %>" OnClick="BtnSelect_Click" Icon-PrimaryIconCssClass="rbOk"></telerik:RadButton>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
