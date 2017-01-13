<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="StaffRolesToolTip.ascx.cs" Inherits="InSite.App.Controls.StaffRolesToolTip" %>

<asp:FormView ID="StaffRoleToolTip" DataSourceID="SqlDataSource_Details" DataKeyNames="StaffRoleID" runat="server" BackColor="Transparent" BorderColor="Transparent">
    <ItemTemplate>
        <fieldset style="padding: 10px; width: 500px; margin-left: 10px; margin-bottom: 10px;">
            <legend style="padding: 5px; background-color: transparent;"><b><%= Resources.Resource.lblDetailsFor %> <%#Eval("NameVisible") %></b>
            </legend>
            <table style="width: 100%;">
                <tr>
                    <td><%= Resources.Resource.lblID %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("StaffRoleID") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblNameVisible %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("NameVisible") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblDescriptionShort %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("DescriptionShort") %>' runat="server" Width="300px"></asp:Label>
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

    <asp:SqlDataSource ID="SqlDataSource_Details" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>" 
        SelectCommand="SELECT * FROM [Master_StaffRoles] WHERE (([SystemID] = @SystemID) AND ([BpID] = @BpID) AND StaffRoleID = @DetailID)"> 
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
            <asp:Parameter Name="DetailID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
