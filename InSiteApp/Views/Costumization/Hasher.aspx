<%@ Page Title="Hasher" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Hasher.aspx.cs" Inherits="InSite.App.Views.Costumization.Hasher" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <div style="border-radius: 10px; border-style: solid; border-width: 1px; border-color: ActiveBorder; padding: 5px; ">
        <table cellpadding="3px">
            <tr>
                <td>
                    <asp:Label runat="server" Text="Password to hash:"></asp:Label>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="Pwd"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label runat="server" Text="Hashed password:"></asp:Label>
                </td>
                <td>
                    <asp:Label runat="server" ID="Hash" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    &nbsp;
                </td>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td>
                    &nbsp;
                </td>
                <td style="text-align:right; ">
                    <asp:Button runat="server" Text="Hash it!" ID="BtnOK" OnClick="BtnOK_Click" />
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
