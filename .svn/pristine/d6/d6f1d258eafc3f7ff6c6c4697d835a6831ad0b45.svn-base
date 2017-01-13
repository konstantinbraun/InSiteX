<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DialogsToolTip.ascx.cs" Inherits="InSite.App.Controls.DialogsToolTip" %>
<asp:FormView ID="DialogToolTip" DataSourceID="SqlDataSource_Details" DataKeyNames="DialogID" runat="server" BackColor="Transparent" BorderColor="Transparent">
    <ItemTemplate>
        <fieldset style="padding: 10px; margin-left: 10px; margin-bottom: 10px;">
            <legend style="padding: 5px; background-color: transparent;"><b><%= Resources.Resource.lblDetailsFor %> <%#Eval("NameVisible") %></b>
            </legend>
            <table style="width: 100%;">
                <tr>
                    <td><%= Resources.Resource.lblID %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("DialogID") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblNameVisible %>:
                    </td>
                    <td>
                        <asp:HiddenField runat="server" ID="ResourceID" Value='<%#Eval("ResourceID") %>' />
                        <asp:Label ID="NameVisible" Text="" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblDescriptionShort %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("DescriptionShort") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblActive %>:
                    </td>
                    <td>
                        <asp:CheckBox Checked='<%#Eval("IsActive") %>' runat="server" />
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
    SelectCommand="SELECT Master_Roles_Dialogs.DialogID, Master_Roles_Dialogs.IsActive, Master_Roles_Dialogs.CreatedFrom, Master_Roles_Dialogs.CreatedOn, Master_Roles_Dialogs.EditFrom, Master_Roles_Dialogs.EditOn, System_Dialogs.NameVisible, System_Dialogs.DescriptionShort, System_Dialogs.ResourceID FROM Master_Roles_Dialogs INNER JOIN System_Dialogs ON Master_Roles_Dialogs.SystemID = System_Dialogs.SystemID AND Master_Roles_Dialogs.DialogID = System_Dialogs.DialogID WHERE (Master_Roles_Dialogs.SystemID = @SystemID) AND (Master_Roles_Dialogs.BpID = @BpID) AND (Master_Roles_Dialogs.DialogID = @DetailID)">
    <SelectParameters>
        <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
        <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
        <asp:Parameter Name="DetailID" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
