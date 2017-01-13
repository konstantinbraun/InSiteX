<%@ Page Title="<%$ Resources:Resource, lblChangePwd %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Password.aspx.cs" Inherits="InSite.App.Views.Costumization.Password" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <div style="border-radius: 10px; border-style: solid; border-width: 1px; border-color: ActiveBorder; padding: 5px; ">
        <table cellpadding="3px">
            <tr>
                <td>
                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblOldPwd %>"></asp:Label>
                </td>
                <td>
                    <telerik:RadTextBox runat="server" ID="OldPwd" TextMode="Password" Width="150px"></telerik:RadTextBox>
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
                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblNewPwd %>"></asp:Label>
                </td>
                <td style="text-align: left; vertical-align: bottom">
                    <telerik:RadTextBox runat="server" ID="NewPwd" TextMode="Password" AutoCompleteType="Disabled" Width="250px">
                        <PasswordStrengthSettings ShowIndicator="true" PreferredPasswordLength="6" 
                                                  RequiresUpperAndLowerCaseCharacters="false" TextStrengthDescriptions="<%$ Resources:Resource, lblTextStrengthDescriptions %>" 
                                                  IndicatorWidth="100px" />
                    </telerik:RadTextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblNewPwdRepeat %>"></asp:Label>
                </td>
                <td style="text-align: left; vertical-align: bottom">
                    <telerik:RadTextBox runat="server" ID="NewPwdRepeat" TextMode="Password" AutoCompleteType="Disabled" Width="150px"></telerik:RadTextBox>
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
                <td style="text-align:right; padding-right:100px;">
                    <asp:Button runat="server" Text="<%$ Resources:Resource, lblCancel %>" ID="btnCancel" OnClick="btnCancel_Click" />
                    <asp:Button runat="server" Text="<%$ Resources:Resource, lblOK %>" ID="btnOK" OnClick="btnOK_Click" />
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
