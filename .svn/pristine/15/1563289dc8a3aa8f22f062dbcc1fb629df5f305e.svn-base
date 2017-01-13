<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AccessAreasToolTip.ascx.cs" Inherits="InSite.App.Controls.AccessAreasToolTip" %>

<asp:FormView ID="AccessAreaToolTip" DataSourceID="SqlDataSource_Details" DataKeyNames="AccessAreaID" runat="server" BackColor="Transparent" BorderColor="Transparent">
    <ItemTemplate>
        <fieldset style="padding: 10px; width: 500px; margin-left: 10px; margin-bottom: 10px;">
            <legend style="padding: 5px; background-color: transparent;"><b><%= Resources.Resource.lblDetailsFor %> <%#Eval("NameVisible") %></b>
            </legend>
            <table style="width: 100%;">
                <tr>
                    <td><%= Resources.Resource.lblID %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("AccessAreaID") %>' runat="server"></asp:Label>
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
                    <td><%= Resources.Resource.lblAccessTimeRelevant %>:
                    </td>
                    <td>
                        <asp:CheckBox Checked='<%#Eval("AccessTimeRelevant") %>' runat="server" />
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblCheckInCompelling %>:
                    </td>
                    <td>
                        <asp:CheckBox Checked='<%#Eval("CheckInCompelling") %>' runat="server" />
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblUniqueAccess %>:
                    </td>
                    <td>
                        <asp:CheckBox Checked='<%#Eval("UniqueAccess") %>' runat="server" />
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblCheckOutCompelling %>:
                    </td>
                    <td>
                        <asp:CheckBox Checked='<%#Eval("CheckOutCompelling") %>' runat="server" />
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblCompleteAccessTimes %>:
                    </td>
                    <td>
                        <asp:CheckBox Checked='<%#Eval("CompleteAccessTimes") %>' runat="server" />
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblMaxPresentTime %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("PresentTimeHours") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblMinuteShort %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("PresentTimeMinutes") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;
                    </td>
                    <td>&nbsp;
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
        SelectCommand="SELECT * FROM [Master_AccessAreas] WHERE (([SystemID] = @SystemID) AND ([BpID] = @BpID) AND AccessAreaID = @DetailID)">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
            <asp:Parameter Name="DetailID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
