<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ImagePopUp.ascx.cs" Inherits="InSite.App.Controls.ImagePopUp" %>

<asp:FormView ID="ImageView" DataKeyNames="EmployeeID" runat="server" OnDataBound="ImageView_DataBound" BorderStyle="None" BackColor="Transparent">
    <ItemTemplate>
        <table style="text-align: center;">
            <tr>
                <td>
                    <telerik:RadBinaryImage runat="server" ID="PhotoData"
                                            DataValue='<%# (Eval("PhotoData") == DBNull.Value) ? null : Eval("PhotoData") %>'
                                            AutoAdjustImageControlSize="false" Height="266px" ToolTip='<%# Eval("EmployeeName", Resources.Resource.lblImageFor) %>'
                                            AlternateText='<%# Eval("EmployeeName", Resources.Resource.lblImageFor) %>'>
                    </telerik:RadBinaryImage>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="EmployeeName" runat="server" Text='<%# Eval("EmployeeName") %>' Font-Bold="true"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="NameVisible" runat="server" Text='<%# Eval("NameVisible") %>'></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="TradeName" runat="server" Text='<%# Eval("TradeName") %>'></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="ExternalID" runat="server" Text='<%# (Eval("ExternalID") == null) ? "" : Eval("ExternalID").ToString() %>' Font-Bold="true" 
                               BackColor='<%# InSite.App.Helpers.Html2Color(Eval("PassColor").ToString()) %>' CssClass="PaddingSmall MarginSmall RoundedCorners"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label runat="server" Text="<%# Resources.Resource.lblAccessAllowed %>"></asp:Label>:
                    <asp:Label ID="AccessAllowed" Font-Bold="true" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="AccessDenialReason" runat="server" Text='<%# Eval("AccessDenialReason").ToString().Replace(Environment.NewLine, "<br/>") %>'></asp:Label>
                </td>
            </tr>
        </table>
    </ItemTemplate>
</asp:FormView>
