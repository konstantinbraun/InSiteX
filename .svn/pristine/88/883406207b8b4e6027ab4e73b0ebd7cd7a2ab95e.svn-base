<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UsersToolTip.ascx.cs" Inherits="InSite.App.Controls.UsersToolTip" %>
<asp:FormView ID="UsersView" DataSourceID="SqlDataSource_User_Detail" DataKeyNames="UserID" runat="server" BackColor="Transparent" BorderColor="Transparent">
    <ItemTemplate>
        <fieldset style="padding: 10px; width: 500px; margin-left: 10px; margin-bottom: 10px; ">
            <legend style="padding: 5px; background-color: transparent;"><b><%= Resources.Resource.lblDetailsFor %> <%#Eval("FirstName") %> <%#Eval("LastName") %></b>
            </legend>
            <table style="width: 100%;">
                <tr>
                    <td><%= Resources.Resource.lblUserID %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("UserID") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblFirstName %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("FirstName") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblLastName %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("LastName") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblCompany %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("Company") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblUserName %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("LoginName") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblUserType %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("TypeID") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblLanguage %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("LanguageID") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblSkin %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("SkinName") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblEmail %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("Email") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblVisible %>:
                    </td>
                    <td>
                        <asp:CheckBox Checked='<%#Eval("IsVisible") %>' runat="server" />
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblCreatedFrom %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("CreatedFrom") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblCreatedOn %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("CreatedOn") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblEditFrom %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("EditFrom") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblEditOn %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("EditOn") %>' runat="server"></asp:Label>
                    </td>
                </tr>
            </table>
        </fieldset>
    </ItemTemplate>
</asp:FormView>

<asp:SqlDataSource ID="SqlDataSource_User_Detail" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
    SelectCommand="SELECT * FROM [Master_Users] WHERE SystemID = @SystemID AND BpID = (CASE WHEN @UserType > 2 THEN BpID ELSE @BpID END) AND UserID = @UserID">
    <SelectParameters>
        <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
        <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
        <asp:SessionParameter DefaultValue="0" Name="UserType" SessionField="UserType" Type="Int32" />
        <asp:Parameter Name="UserID" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
