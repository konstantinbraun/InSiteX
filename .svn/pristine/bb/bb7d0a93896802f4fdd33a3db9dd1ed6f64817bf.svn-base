<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FieldsToolTip.ascx.cs" Inherits="InSite.App.Controls.FieldsToolTip" %>
<asp:FormView ID="FieldToolTip" DataSourceID="SqlDataSource_Details" DataKeyNames="FieldID" runat="server" BackColor="Transparent" BorderColor="Transparent">
    <ItemTemplate>
        <fieldset style="padding: 10px; margin-left: 10px; margin-bottom: 10px;">
            <legend style="padding: 5px; background-color: transparent;"><b><%= Resources.Resource.lblDetailsFor %> <%#Eval("InternalName") %></b>
            </legend>
            <table style="width: 100%;">
                <tr>
                    <td><%= Resources.Resource.lblID %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("FieldID") %>' runat="server"></asp:Label>
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
                    <td><%= Resources.Resource.lblInternalName %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("InternalName") %>' runat="server"></asp:Label>
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
                    <td><%= Resources.Resource.lblEditable %>:
                    </td>
                    <td>
                        <asp:CheckBox Checked='<%#Eval("IsEditable") %>' runat="server" />
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblMandatory %>:
                    </td>
                    <td>
                        <asp:CheckBox Checked='<%#Eval("IsMandatory") %>' runat="server" />
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblDefault %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("DefaultValue") %>' runat="server"></asp:Label>
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
    SelectCommand="SELECT Master_Actions_Fields.FieldID, Master_Actions_Fields.IsVisible, Master_Actions_Fields.IsEditable, Master_Actions_Fields.IsMandatory, Master_Actions_Fields.DefaultValue, Master_Actions_Fields.CreatedFrom, Master_Actions_Fields.CreatedOn, Master_Actions_Fields.EditFrom, Master_Actions_Fields.EditOn, System_Fields.InternalName, System_Fields.ResourceID FROM Master_Actions_Fields INNER JOIN System_Fields ON Master_Actions_Fields.SystemID = System_Fields.SystemID AND Master_Actions_Fields.FieldID = System_Fields.FieldID WHERE (Master_Actions_Fields.SystemID = @SystemID) AND (Master_Actions_Fields.BpID = @BpID) AND (Master_Actions_Fields.FieldID = @DetailID)">
    <SelectParameters>
        <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
        <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
        <asp:Parameter Name="DetailID" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
