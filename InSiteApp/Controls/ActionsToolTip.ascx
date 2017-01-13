<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ActionsToolTip.ascx.cs" Inherits="InSite.App.Controls.ActionsToolTip" %>
<asp:FormView ID="ActionToolTip" DataSourceID="SqlDataSource_Details" DataKeyNames="ActionID" runat="server" BackColor="Transparent" BorderColor="Transparent">
    <ItemTemplate>
        <fieldset style="padding: 10px; margin-left: 10px; margin-bottom: 10px;">
            <legend style="padding: 5px; background-color: transparent;"><b><%= Resources.Resource.lblDetailsFor %> <%#Eval("NameVisible") %></b>
            </legend>
            <table style="width: 100%;">
                <tr>
                    <td><%= Resources.Resource.lblID %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("ActionID") %>' runat="server"></asp:Label>
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
    SelectCommand="SELECT Master_Dialogs_Actions.ActionID, Master_Dialogs_Actions.IsActive, Master_Dialogs_Actions.CreatedFrom, Master_Dialogs_Actions.CreatedOn, Master_Dialogs_Actions.EditFrom, Master_Dialogs_Actions.EditOn, System_Actions.NameVisible, System_Actions.DescriptionShort FROM Master_Dialogs_Actions INNER JOIN System_Actions ON Master_Dialogs_Actions.SystemID = System_Actions.SystemID AND Master_Dialogs_Actions.ActionID = System_Actions.ActionID WHERE (Master_Dialogs_Actions.SystemID = @SystemID) AND (Master_Dialogs_Actions.BpID = @BpID) AND (Master_Dialogs_Actions.ActionID = @DetailID)">
    <SelectParameters>
        <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
        <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
        <asp:Parameter Name="DetailID" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
