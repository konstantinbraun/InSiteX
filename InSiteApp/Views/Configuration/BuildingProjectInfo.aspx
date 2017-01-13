<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BuildingProjectInfo.aspx.cs" Inherits="InSite.App.Views.Configuration.BuildingProjectInfo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <telerik:RadAjaxPanel runat="server" ID="RadAjaxPanel1">
        <asp:FormView ID="BuildingProjectView" DataSourceID="SqlDataSource_BPDetails" DataKeyNames="BpID" runat="server" BackColor="Transparent" BorderColor="Transparent">
            <ItemTemplate>
                <fieldset style="padding: 10px; width: 600px;">
                    <legend style="padding: 5px; background-color: transparent;">
                        <b><%= Resources.Resource.lblDetailsFor %> <%#Eval("NameVisible") %></b>
                    </legend>
                    <table style="width: 100%;" cellpadding="3px">
                        <tr>
                            <td align="right"><%= Resources.Resource.lblBpID %>: </td>
                            <td>
                                <asp:Label Text='<%#Eval("BpID") %>' runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><%= Resources.Resource.lblNameVisible %>: </td>
                            <td>
                                <asp:Label Text='<%#Eval("NameVisible") %>' runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><%= Resources.Resource.lblDescriptionShort %>: </td>
                            <td>
                                <asp:Label Text='<%#Eval("DescriptionShort") %>' runat="server" Width="300px"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td align="right"><%= Resources.Resource.lblType %>: </td>
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
                            <td align="right">
                                <%= Resources.Resource.lblBasedOn %>:
                            </td>
                            <td>
                                <telerik:RadDropDownList Enabled="false" ID="RadDropDownList2" runat="server" SelectedValue='<%# Eval("BasedOn") %>' DataSourceID="SqlDataSource_BasedOn" DataTextField="NameVisible" DataValueField="BpID">
                                </telerik:RadDropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                <%= Resources.Resource.lblCountry %>:
                            </td>
                            <td>
                                <telerik:RadDropDownList Enabled="false" ID="RadDropDownList3" runat="server" SelectedValue='<%# Eval("CountryID") %>' DataSourceID="SqlDataSource_Countries" DataTextField="CountryName" DataValueField="CountryID" DropDownHeight="400px" EnableVirtualScrolling="True" DropDownWidth="300px" OnItemDataBound="RadDropDownList3_ItemDataBound">
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
                            <td align="right">
                                <%= Resources.Resource.lblBuilderName %>:
                            </td>
                            <td>
                                <asp:Label Text='<%#Eval("BuilderName") %>' runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><%= Resources.Resource.lblAddress %>: </td>
                            <td>
                                <telerik:RadTextBox ReadOnly="true" runat="server" Text='<%# Eval("Address") %>' Width="300px" Height="100px" TextMode="MultiLine"></telerik:RadTextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td align="right"><%= Resources.Resource.lblPresentType %>: </td>
                            <td>
                                <telerik:RadDropDownList Enabled="false" ID="RadDropDownList_PresentType" runat="server" SelectedValue='<%# Eval("PresentType") %>' Width="300px">
                                    <Items>
                                        <telerik:DropDownListItem runat="server" Selected="True" Text="<%$ Resources:Resource, selPresence1 %>" Value="1" />
                                        <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selPresence2 %>" Value="2" />
                                        <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selPresence3 %>" Value="2" />
                                    </Items>
                                </telerik:RadDropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><%= Resources.Resource.lblMWCheck %>: </td>
                            <td>
                                <asp:CheckBox Checked='<%#Eval("MWCheck") %>' runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><%= Resources.Resource.lblMinWageAccessRelevance %>: </td>
                            <td>
                                <asp:CheckBox Checked='<%#Eval("MinWageAccessRelevance") %>' runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><%= Resources.Resource.lblMWHours %>: </td>
                            <td>
                                <asp:Label ID="Label5" runat="server" Text='<%# Eval("MWHours") %>'></asp:Label>
                                <asp:Label ID="Label6" runat="server" Text="<%$ Resources:Resource, lblHourShort %>"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><%= Resources.Resource.lblMWDeadline %>: </td>
                            <td>
                                <asp:Label ID="Label7" runat="server" Text='<%# Eval("MWDeadline") %>'></asp:Label>
                                <asp:Label ID="Label8" runat="server" Text="<%$ Resources:Resource, lblSuffixOfMonth %>"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><%= Resources.Resource.lblDefaultRole %>: </td>
                            <td>
                                <asp:Label Text='<%#Eval("NameRole") %>' runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><%= Resources.Resource.lblDefaultAccessArea %>: </td>
                            <td>
                                <asp:Label Text='<%#Eval("NameAccessArea") %>' runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><%= Resources.Resource.lblDefaultTimeSlotGroup %>: </td>
                            <td>
                                <asp:Label Text='<%#Eval("NameTimeSlotGroup") %>' runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><%= Resources.Resource.lblPrintPassOnCompleteDocs %>: </td>
                            <td>
                                <asp:CheckBox Checked='<%#Eval("PrintPassOnCompleteDocs") %>' runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><%= Resources.Resource.lblVisible %>: </td>
                            <td>
                                <asp:CheckBox Checked='<%#Eval("IsVisible") %>' runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td align="right"><%= Resources.Resource.lblCreatedFrom %>: </td>
                            <td>
                                <asp:Label Text='<%#Eval("CreatedFrom") %>' runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><%= Resources.Resource.lblCreatedOn %>: </td>
                            <td>
                                <asp:Label Text='<%#Eval("CreatedOn") %>' runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><%= Resources.Resource.lblEditFrom %>: </td>
                            <td>
                                <asp:Label Text='<%#Eval("EditFrom") %>' runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><%= Resources.Resource.lblEditOn %>: </td>
                            <td>
                                <asp:Label Text='<%#Eval("EditOn") %>' runat="server"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </ItemTemplate>
        </asp:FormView>
    </telerik:RadAjaxPanel>

    <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="BuildingProjectView">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="BuildingProjectView" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <asp:SqlDataSource ID="SqlDataSource_BPDetails" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT m_bp.SystemID, m_bp.BpID, m_bp.NameVisible, m_bp.DescriptionShort, m_bp.TypeID, m_bp.BasedOn, m_bp.IsVisible, m_bp.CountryID, m_bp.BuilderName, m_bp.PresentType, m_bp.MWCheck, m_bp.MWHours, m_bp.MWDeadline, m_bp.Address, m_bp.CreatedFrom, m_bp.CreatedOn, m_bp.EditFrom, m_bp.EditOn, m_bp.MinWageAccessRelevance, m_bp.DefaultRoleID, m_r.NameVisible AS NameRole, m_bp.DefaultAccessAreaID, m_bp.DefaultTimeSlotGroupID, m_bp.PrintPassOnCompleteDocs, m_aa.NameVisible AS NameAccessArea, m_tsg.NameVisible AS NameTimeSlotGroup FROM Master_BuildingProjects AS m_bp LEFT OUTER JOIN Master_TimeSlotGroups AS m_tsg ON m_bp.SystemID = m_tsg.SystemID AND m_bp.BpID = m_tsg.BpID AND m_bp.DefaultTimeSlotGroupID = m_tsg.TimeSlotGroupID LEFT OUTER JOIN Master_AccessAreas AS m_aa ON m_bp.SystemID = m_aa.SystemID AND m_bp.BpID = m_aa.BpID AND m_bp.DefaultAccessAreaID = m_aa.AccessAreaID LEFT OUTER JOIN Master_Roles AS m_r ON m_bp.SystemID = m_r.SystemID AND m_bp.BpID = m_r.BpID AND m_bp.DefaultRoleID = m_r.RoleID WHERE (m_bp.SystemID = @SystemID) AND (m_bp.BpID = @BpID) ORDER BY m_bp.TypeID, m_bp.NameVisible">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
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
</asp:Content>
