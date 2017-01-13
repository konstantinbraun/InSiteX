<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="BuildingProjectsToolTip.ascx.cs" Inherits="InSite.App.Controls.BuildingProjectsToolTip" %>
<asp:FormView ID="BuildingProjectView" DataSourceID="SqlDataSource_BPDetails" DataKeyNames="BpID" runat="server" BackColor="Transparent" BorderColor="Transparent">
    <ItemTemplate>
        <fieldset style="padding: 5px; background-color:transparent; ">
            <legend style="padding: 5px; background-color: transparent;"><b><%= Resources.Resource.lblDetailsFor %> <%#Eval("NameVisible") %></b>
            </legend>
            <table style="width: 100%;">
                <tr>
                    <td><%= Resources.Resource.lblBpID %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("BpID") %>' runat="server"></asp:Label>
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
                    <td><%= Resources.Resource.lblType %>:
                    </td>
                    <td>
                        <telerik:RadDropDownList Enabled="false" ID="RadDropDownList1" runat="server" SelectedText="Bauprojekt" SelectedValue='<%# Eval("TypeID") %>'>
                            <Items>
                                <telerik:DropDownListItem runat="server" Selected="True" Text="<%$ Resources:Resource, lblBuildingProject %>" Value="1" />
                                <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, lblTemplate %>" Value="2" />
                            </Items>
                        </telerik:RadDropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%= Resources.Resource.lblBasedOn %>:
                    </td>
                    <td>
                        <telerik:RadDropDownList Enabled="false" ID="RadDropDownList2" runat="server" SelectedValue='<%# Bind("BasedOn") %>' DataSourceID="SqlDataSource_BasedOn" DataTextField="NameVisible" DataValueField="BpID">
                        </telerik:RadDropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%= Resources.Resource.lblCountry %>:
                    </td>
                    <td>
                        <telerik:RadDropDownList Enabled="false" ID="RadDropDownList3" runat="server" SelectedValue='<%# Bind("CountryID") %>' DataSourceID="SqlDataSource_Countries" DataTextField="CountryName" DataValueField="CountryID" DropDownHeight="400px" EnableVirtualScrolling="True" DropDownWidth="300px" OnItemDataBound="RadDropDownList3_ItemDataBound">
                            <ItemTemplate>
                                <table>
                                    <tr>
                                        <td>
                                            <asp:Image ID="ItemImage" runat="server" />
                                        </td>
                                        <td>
                                            <asp:Label ID="ItemText" runat="server">
                                            </asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                        </telerik:RadDropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%= Resources.Resource.lblBuilderName %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("BuilderName") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblAddress %>:
                    </td>
                    <td>
                        <telerik:RadTextBox ReadOnly="true" runat="server" Text='<%# Eval("Address") %>' Width="300px" Height="100px" TextMode="MultiLine"></telerik:RadTextBox>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblPresentType %>:
                    </td>
                    <td>
                        <telerik:RadDropDownList Enabled="false" ID="RadDropDownList_PresentType" runat="server" SelectedValue='<%# Bind("PresentType") %>' Width="300px">
                            <Items>
                                <telerik:DropDownListItem runat="server" Selected="True" Text="<%$ Resources:Resource, selPresence1 %>" Value="1" />
                                <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selPresence2 %>" Value="2" />
                                <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selPresence3 %>" Value="2" />
                            </Items>
                        </telerik:RadDropDownList>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblMWCheck %>:
                    </td>
                    <td>
                        <asp:CheckBox Checked='<%#Eval("MWCheck") %>' runat="server" />
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblMinWageAccessRelevance %>: </td>
                    <td>
                        <asp:CheckBox Checked='<%#Eval("MinWageAccessRelevance") %>' runat="server" />
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblMWHours %>:
                    </td>
                    <td>
                        <asp:Label ID="Label5" runat="server" Text='<%# Eval("MWHours") %>'></asp:Label>
                        <asp:Label ID="Label6" runat="server" Text="<%$ Resources:Resource, lblHourShort %>"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblMWDeadline %>:
                    </td>
                    <td>
                        <asp:Label ID="Label7" runat="server" Text='<%# Eval("MWDeadline") %>'></asp:Label>
                        <asp:Label ID="Label8" runat="server" Text="<%$ Resources:Resource, lblSuffixOfMonth %>"></asp:Label>
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

<asp:SqlDataSource ID="SqlDataSource_BPDetails" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
    SelectCommand="SELECT * FROM [Master_BuildingProjects] WHERE SystemID = @SystemID AND BpID = @BpID">
    <SelectParameters>
        <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
        <asp:Parameter Name="BpID" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>

<asp:SqlDataSource ID="SqlDataSource_BasedOn" runat="server"
    ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
    SelectCommand="SELECT * FROM [Master_BuildingProjects] WHERE SystemID = @SystemID">
    <SelectParameters>
        <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>

<asp:SqlDataSource ID="SqlDataSource_Countries" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
    SelectCommand="SELECT DISTINCT CountryID, CountryName, FlagName FROM View_Countries ORDER BY View_Countries.CountryName"></asp:SqlDataSource>

