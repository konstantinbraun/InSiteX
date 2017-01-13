<%@ Page Title="<%$ Resources:Resource, lblCountryGroupsAndCountries %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Countries.aspx.cs" Inherits="InSite.App.Views.Configuration.Countries" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <telerik:RadPersistenceManagerProxy ID="RadPersistenceManagerProxy1" runat="server">
        <PersistenceSettings>
            <telerik:PersistenceSetting ControlID="RadGrid1" />
            <telerik:PersistenceSetting ControlID="RadGridCountries" />
        </PersistenceSettings>
    </telerik:RadPersistenceManagerProxy>

    <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGrid1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadGridCountries">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridCountries" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <%-- CountryGroups Grid --%>
    <telerik:RadGrid ID="RadGrid1" runat="server" DataSourceID="SqlDataSource_CountryGroups" AllowPaging="True" AllowSorting="True" CellSpacing="0"
                     GridLines="None" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" CssClass="MainGrid" EnableAjaxSkinRendering="true"
                     EnableLinqExpressions="false" EnableHierarchyExpandAll="true"
                     OnItemCommand="RadGrid1_ItemCommand" OnItemDeleted="RadGrid1_ItemDeleted" OnItemInserted="RadGrid1_ItemInserted" OnItemUpdated="RadGrid1_ItemUpdated"
                     OnPreRender="RadGrid1_PreRender" OnDetailTableDataBind="RadGrid1_DetailTableDataBind" OnItemCreated="RadGrid1_ItemCreated" OnGroupsChanging="RadGrid1_GroupsChanging">

        <ExportSettings ExportOnlyData="True" IgnorePaging="True">
            <Pdf PaperSize="A4">
            </Pdf>
            <Excel Format="ExcelML" />
        </ExportSettings>

        <%-- CountryGroups Master --%>
        <SortingSettings SortedBackColor="Transparent" />

        <MasterTableView Name="CountryGroups" runat="server" DataSourceID="SqlDataSource_CountryGroups" DataKeyNames="SystemID,BpID,CountryGroupID" AutoGenerateColumns="False"
                         CommandItemDisplay="Top" EnableHeaderContextMenu="true" EditMode="PopUp" HierarchyLoadMode="ServerBind" ShowHeader="true" Caption="<%$ Resources:Resource, lblCountryGroups %>" 
                         CssClass="MasterClass" EnableHierarchyExpandAll="true">

            <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="False" ShowExportToExcelButton="True" ShowExportToPdfButton="False"
                                 AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

            <SortExpressions>
                <telerik:GridSortExpression FieldName="NameVisible" SortOrder="Ascending"></telerik:GridSortExpression>
            </SortExpressions>

            <EditFormSettings CaptionDataField="NameVisible" CaptionFormatString="{0}">
                <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                <EditColumn ButtonType="ImageButton" UniqueName="EditColumn1" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                            EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                <FormTableStyle CellPadding="3" CellSpacing="3" />
            </EditFormSettings>

            <%-- CountryGroup Nested View --%>
            <NestedViewTemplate>
                <asp:Panel runat="server" ID="InnerContainer1" Visible="true">
                    <telerik:RadTabStrip runat="server" ID="TabStrip1" MultiPageID="Multipage1" SelectedIndex="0">
                        <Tabs>
                            <telerik:RadTab runat="server" Text='<%$ Resources:Resource, lblDialogs %>' Font-Bold="true" PageViewID="PageView1_1">
                            </telerik:RadTab>
                            <telerik:RadTab runat="server" Text="<%$ Resources:Resource, lblDetails %>" Font-Bold="true" PageViewID="PageView1_2">
                            </telerik:RadTab>
                        </Tabs>
                    </telerik:RadTabStrip>

                    <telerik:RadMultiPage runat="server" ID="Multipage1" SelectedIndex="0" RenderSelectedPageOnly="false">

                        <%-- CountryGroup Countries --%>
                        <telerik:RadPageView runat="server" ID="PageView1_1">
                            <asp:HiddenField runat="server" ID="CountryGroupID" Value='<%# Eval("CountryGroupID") %>' />

                            <%-- Countries Grid --%>
                            <telerik:RadGrid ID="RadGridCountries" EnableHierarchyExpandAll="true" DataSourceID="SqlDataSource_Countries" Width="100%" AllowSorting="true"
                                             runat="server" AllowPaging="true" ShowFooter="false" EnableLinqExpressions="false" AllowAutomaticInserts="true" AllowAutomaticDeletes="true"
                                             AllowAutomaticUpdates="true" OnPreRender="RadGrid1_PreRender" OnItemCreated="RadGridCountries_ItemCreated" OnItemCommand="RadGridCountries_ItemCommand">

                                <ExportSettings ExportOnlyData="True" IgnorePaging="True">
                                    <Pdf PaperSize="A4">
                                    </Pdf>
                                    <Excel Format="ExcelML" />
                                </ExportSettings>

                                <%-- Countries Master --%>
                                <SortingSettings SortedBackColor="Transparent" />

                                <MasterTableView Name="Dialogs" DataSourceID="SqlDataSource_Countries" HierarchyLoadMode="ServerOnDemand" EnableHierarchyExpandAll="true"
                                                 CssClass="MasterClass" EditMode="PopUp" AutoGenerateColumns="False"
                                                 DataKeyNames="SystemID,BpID,CountryID,CountryGroupID"
                                                 CommandItemDisplay="Top">

                                    <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="False" ShowExportToExcelButton="True" ShowExportToPdfButton="False"
                                                         AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                                    <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

                                    <SortExpressions>
                                        <telerik:GridSortExpression FieldName="NameVisible" SortOrder="Ascending"></telerik:GridSortExpression>
                                    </SortExpressions>

                                    <EditFormSettings CaptionDataField="NameVisible" CaptionFormatString="{0}">
                                        <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                                        <EditColumn ButtonType="ImageButton" UniqueName="EditColumn2" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                                                    EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                                        <FormTableStyle CellPadding="3" CellSpacing="3" />
                                    </EditFormSettings>

                                    <%-- Country Details --%>
                                    <NestedViewTemplate>
                                        <fieldset style="padding: 10px; width: 500px; margin-left: 10px; margin-bottom: 10px;">
                                            <legend style="padding: 5px; background-color: transparent;">
                                                <b><%= Resources.Resource.lblDetailsFor%> <%# Eval("NameVisible") %></b>
                                            </legend>
                                            <table style="width: 100%;">
                                                <tr>
                                                    <td>
                                                        <asp:Image ID="ItemImage" ImageUrl='<%# String.Concat("~/Resources/Icons/Flags/", Eval("FlagName"))%>' runat="server" />
                                                    </td>
                                                    <td>&nbsp; </td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblID%>: </td>
                                                    <td>
                                                        <asp:Label Text='<%#Eval("CountryID")%>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblNameVisible%>: </td>
                                                    <td>
                                                        <asp:Label Text='<%#Eval("NameVisible")%>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblDescriptionShort%>: </td>
                                                    <td>
                                                        <asp:Label Text='<%#Eval("DescriptionShort")%>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblCreatedFrom%>: </td>
                                                    <td>
                                                        <asp:Label Text='<%#Eval("CreatedFrom")%>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblCreatedOn%>: </td>
                                                    <td>
                                                        <asp:Label Text='<%#Eval("CreatedOn")%>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblEditFrom%>: </td>
                                                    <td>
                                                        <asp:Label Text='<%#Eval("EditFrom")%>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblEditOn%>: </td>
                                                    <td>
                                                        <asp:Label Text='<%#Eval("EditOn")%>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </fieldset>
                                    </NestedViewTemplate>

                                    <Columns>
                                        <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                                                       UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                                            <ItemStyle BackColor="Control" Width="30px" />
                                            <HeaderStyle Width="30px" />
                                        </telerik:GridEditCommandColumn>

                                        <telerik:GridImageColumn DataImageUrlFields="FlagName" DataImageUrlFormatString="~/Resources/Icons/Flags/{0}">
                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle"  />
                                            <HeaderStyle Width="40px" />
                                        </telerik:GridImageColumn>

                                        <telerik:GridTemplateColumn DataField="CountryID" Visible="false" HeaderText="<%$ Resources:Resource, lblCountry %>" SortExpression="CountryID" UniqueName="CountryID"
                                                                    GroupByExpression="CountryID CountryID GROUP BY CountryID">
                                            <InsertItemTemplate>
                                                <telerik:RadComboBox runat="server" ID="CountryID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataSourceID="SqlDataSource_CountriesSelect"
                                                                     DataValueField="CountryID" DataTextField="CountryName" Width="300" Filter="Contains" SelectedValue='<%# Bind("CountryID") %>'
                                                                     AppendDataBoundItems="true">
                                                    <ItemTemplate>
                                                        <table cellpadding="3px" style="text-align: left;">
                                                            <tr style="height: 24px;">
                                                                <td style="text-align: left;">
                                                                    <asp:Image ID="Image1" ImageUrl='<%# String.Format("~/Resources/Icons/Flags/{0}", Eval("FlagName"))%>' runat="server"
                                                                               Width="24px" Height="24px" />
                                                                </td>
                                                                <td style="text-align: left;">
                                                                    <asp:Label ID="Label1" Text='<%# Eval("CountryID") %>' runat="server">
                                                                    </asp:Label>
                                                                </td>
                                                                <td style="text-align: left;">
                                                                    <asp:Label ID="Label2" Text='<%# Eval("CountryName") %>' runat="server">
                                                                    </asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </ItemTemplate>
                                                    <Items>
                                                        <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                                                    </Items>
                                                </telerik:RadComboBox>
                                            </InsertItemTemplate>
                                            <EditItemTemplate>
                                                <asp:Label ID="ItemName" Text='<%# Eval("CountryID") %>' runat="server">
                                                </asp:Label>
                                            </EditItemTemplate>
                                            <ItemTemplate>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridTemplateColumn DataField="NameVisible" HeaderText="<%$ Resources:Resource, lblNameVisible %>" SortExpression="NameVisible" UniqueName="NameVisible"
                                                                    GroupByExpression="NameVisible NameVisible GROUP BY NameVisible">
                                            <EditItemTemplate>
                                                <telerik:RadTextBox runat="server" ID="NameVisible" Text='<%# Bind("NameVisible") %>'></telerik:RadTextBox>
                                            </EditItemTemplate>
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="NameVisible" Text='<%# Eval("NameVisible") %>'></asp:Label>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridTemplateColumn DataField="DescriptionShort" FilterControlAltText="Filter DescriptionShort column" HeaderText="<%$ Resources:Resource, lblDescriptionShort %>"
                                                                    SortExpression="DescriptionShort" UniqueName="DescriptionShort" GroupByExpression="DescriptionShort DescriptionShort GROUP BY DescriptionShort">
                                            <EditItemTemplate>
                                                <telerik:RadTextBox runat="server" ID="DescriptionShort" Text='<%# Bind("DescriptionShort") %>' Width="300px"></telerik:RadTextBox>
                                            </EditItemTemplate>
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="LabelDescriptionShort" Text='<%# Eval("DescriptionShort") %>'></asp:Label>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridTemplateColumn DataField="CreatedFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedFrom column" HeaderText="<%$ Resources:Resource, lblCreatedFrom %>" SortExpression="CreatedFrom" UniqueName="CreatedFrom" Visible="False">
                                            <ItemTemplate>
                                                <asp:Label ID="CreatedFromLabel" runat="server" Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridTemplateColumn DataField="CreatedOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedOn column" HeaderText="<%$ Resources:Resource, lblCreatedOn %>" SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="False">
                                            <ItemTemplate>
                                                <asp:Label ID="CreatedOnLabel" runat="server" Text='<%# Eval("CreatedOn") %>'></asp:Label>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridTemplateColumn DataField="EditFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditFrom column" HeaderText="<%$ Resources:Resource, lblEditFrom %>" SortExpression="EditFrom" UniqueName="EditFrom" Visible="False">
                                            <ItemTemplate>
                                                <asp:Label ID="EditFromLabel" runat="server" Text='<%# Eval("EditFrom") %>'></asp:Label>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridTemplateColumn DataField="EditOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditOn column" HeaderText="<%$ Resources:Resource, lblEditOn %>" SortExpression="EditOn" UniqueName="EditOn" Visible="False">
                                            <ItemTemplate>
                                                <asp:Label ID="EditOnLabel" runat="server" Text='<%# Eval("EditOn") %>'></asp:Label>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridButtonColumn UniqueName="deleteColumn" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                                                  ConfirmDialogType="RadWindow"
                                                                  ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                                            <ItemStyle BackColor="Control" />
                                        </telerik:GridButtonColumn>
                                    </Columns>

                                </MasterTableView>

                                <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false">
                                    <Resizing AllowColumnResize="true"></Resizing>
                                    <Selecting AllowRowSelect="True" />
                                    <ClientEvents OnRowClick="OnRowClick" OnGridCreated="OnGridCreated" OnKeyPress="GridKeyPress" />
                                </ClientSettings>
                            </telerik:RadGrid>

                            <asp:SqlDataSource ID="SqlDataSource_Countries" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               OldValuesParameterFormatString="original_{0}" OnDeleting="SqlDataSource_Countries_Deleting" OnInserting="SqlDataSource_Countries_Inserting" OnUpdating="SqlDataSource_Countries_Updating"
                                               SelectCommand="SELECT DISTINCT Master_Countries.SystemID, Master_Countries.BpID, Master_Countries.CountryID, Master_Countries.CountryGroupID, Master_Countries.NameVisible, Master_Countries.DescriptionShort, Master_Countries.CreatedFrom, Master_Countries.CreatedOn, Master_Countries.EditFrom, Master_Countries.EditOn, View_Countries.FlagName FROM Master_Countries INNER JOIN View_Countries ON Master_Countries.CountryID = View_Countries.CountryID WHERE (Master_Countries.SystemID = @SystemID) AND (Master_Countries.BpID = @BpID) AND (Master_Countries.CountryGroupID = @CountryGroupID) ORDER BY Master_Countries.NameVisible"
                                               InsertCommand="INSERT INTO Master_Countries (SystemID, BpID, CountryID, CountryGroupID, NameVisible, DescriptionShort, CreatedFrom, CreatedOn, EditFrom, EditOn) VALUES (@SystemID, @BpID, @CountryID, @CountryGroupID, @NameVisible, @DescriptionShort, @UserName, SYSDATETIME(), @UserName, SYSDATETIME())"
                                               UpdateCommand="INSERT INTO History_Countries SELECT * FROM Master_Countries WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND CountryID = @original_CountryID; 
                                               UPDATE Master_Countries SET NameVisible = @NameVisible, DescriptionShort = @DescriptionShort, EditFrom = @UserName, EditOn = SYSDATETIME() WHERE SystemID = @original_SystemID AND BpID = @original_BpID AND CountryID = @original_CountryID"
                                               DeleteCommand="INSERT INTO History_Countries SELECT * FROM Master_Countries WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND CountryID = @original_CountryID; 
                                               DELETE FROM Master_Countries WHERE SystemID = @original_SystemID AND BpID = @original_BpID AND CountryID = @original_CountryID">
                                <SelectParameters>
                                    <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
                                    <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
                                    <asp:ControlParameter ControlID="CountryGroupID" PropertyName="Value" Type="Int32" Name="CountryGroupID"></asp:ControlParameter>
                                </SelectParameters>
                                <InsertParameters>
                                    <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
                                    <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
                                    <asp:Parameter Name="CountryID" />
                                    <asp:ControlParameter ControlID="CountryGroupID" PropertyName="Value" Type="Int32" Name="CountryGroupID"></asp:ControlParameter>
                                    <asp:Parameter Name="NameVisible" />
                                    <asp:Parameter Name="DescriptionShort" />
                                    <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
                                </InsertParameters>
                                <UpdateParameters>
                                    <asp:Parameter Name="NameVisible" />
                                    <asp:Parameter Name="DescriptionShort" />
                                    <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
                                    <asp:Parameter Name="original_SystemID" Type="Int32" />
                                    <asp:Parameter Name="original_BpID" Type="Int32" />
                                    <asp:Parameter Name="original_CountryID" />
                                </UpdateParameters>
                                <DeleteParameters>
                                    <asp:Parameter Name="original_SystemID" Type="Int32" />
                                    <asp:Parameter Name="original_BpID" Type="Int32" />
                                    <asp:Parameter Name="original_CountryID" />
                                </DeleteParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource ID="SqlDataSource_CountryDetails" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT DISTINCT Master_Countries.SystemID, Master_Countries.BpID, Master_Countries.CountryID, Master_Countries.CountryGroupID, Master_Countries.NameVisible, Master_Countries.DescriptionShort, Master_Countries.CreatedFrom, Master_Countries.CreatedOn, Master_Countries.EditFrom, Master_Countries.EditOn, View_Countries.FlagName FROM Master_Countries INNER JOIN View_Countries ON Master_Countries.CountryID = View_Countries.CountryID WHERE (Master_Countries.SystemID = @SystemID) AND (Master_Countries.BpID = @BpID) AND (Master_Countries.CountryGroupID = @CountryGroupID) AND (Master_Countries.CountryID = @CountryID)">
                                <SelectParameters>
                                    <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
                                    <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
                                    <asp:ControlParameter ControlID="CountryGroupID" PropertyName="Value" Type="Int32" Name="CountryGroupID"></asp:ControlParameter>
                                    <asp:Parameter Name="CountryID" />
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource ID="SqlDataSource_CountriesSelect" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT DISTINCT l1.CountryID, l1.CountryName, l1.FlagName FROM View_Countries AS l1 WHERE (NOT EXISTS (SELECT 1 FROM Master_Countries AS l2 WHERE (l2.SystemID = @SystemID) AND (l2.BpID = @BpID) AND (l2.CountryID = l1.CountryID))) ORDER BY l1.CountryName">
                                <SelectParameters>
                                    <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
                                    <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </telerik:RadPageView>

                        <%-- CountryGroup Details --%>
                        <telerik:RadPageView runat="server" ID="RadPageView1_2">
                            <fieldset style="padding: 10px; width: 500px; margin-left: 10px; margin-bottom: 10px;">
                                <legend style="padding: 5px; background-color: transparent;">
                                    <b><%# String.Concat(Resources.Resource.lblDetailsFor, " ", Eval("NameVisible"))%></b>
                                </legend>
                                <table style="width: 100%;">
                                    <tr>
                                        <td><%= Resources.Resource.lblID%>: </td>
                                        <td>
                                            <asp:Label Text='<%#Eval("CountryGroupID")%>' runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><%= Resources.Resource.lblNameVisible%>: </td>
                                        <td>
                                            <asp:Label Text='<%#Eval("NameVisible")%>' runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><%= Resources.Resource.lblDescriptionShort%>: </td>
                                        <td>
                                            <asp:Label Text='<%#Eval("DescriptionShort")%>' runat="server" Width="300px"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><%= Resources.Resource.lblCreatedFrom%>: </td>
                                        <td>
                                            <asp:Label Text='<%#Eval("CreatedFrom")%>' runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><%= Resources.Resource.lblCreatedOn%>: </td>
                                        <td>
                                            <asp:Label Text='<%#Eval("CreatedOn")%>' runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><%= Resources.Resource.lblEditFrom%>: </td>
                                        <td>
                                            <asp:Label Text='<%#Eval("EditFrom")%>' runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><%= Resources.Resource.lblEditOn%>: </td>
                                        <td>
                                            <asp:Label Text='<%#Eval("EditOn")%>' runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                        </telerik:RadPageView>

                    </telerik:RadMultiPage>
                </asp:Panel>
            </NestedViewTemplate>

            <Columns>
                <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                               UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                    <ItemStyle BackColor="Control" Width="30px" />
                    <HeaderStyle Width="30px" />
                </telerik:GridEditCommandColumn>

                <telerik:GridTemplateColumn DataField="CountryGroupID" Visible="false" InsertVisiblityMode="AlwaysHidden" DataType="System.Int32" FilterControlAltText="Filter CountryGroupID column" HeaderText="<%$ Resources:Resource, lblID %>"
                                            SortExpression="CountryGroupID" UniqueName="CountryGroupID" GroupByExpression="CountryGroupID CountryGroupID GROUP BY CountryGroupID">
                    <EditItemTemplate>
                        <asp:Label runat="server" ID="LabelCountryGroupID" Text='<%# Eval("CountryGroupID") %>'></asp:Label>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                    </InsertItemTemplate>
                    <ItemTemplate>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="NameVisible" HeaderText="<%$ Resources:Resource, lblNameVisible %>" SortExpression="NameVisible" UniqueName="NameVisible"
                                            GroupByExpression="NameVisible NameVisible GROUP BY NameVisible">
                    <EditItemTemplate>
                        <telerik:RadTextBox runat="server" ID="NameVisible" Text='<%# Bind("NameVisible") %>'></telerik:RadTextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" ID="NameVisible" Text='<%# Eval("NameVisible") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="DescriptionShort" FilterControlAltText="Filter DescriptionShort column" HeaderText="<%$ Resources:Resource, lblDescriptionShort %>"
                                            SortExpression="DescriptionShort" UniqueName="DescriptionShort" GroupByExpression="DescriptionShort DescriptionShort GROUP BY DescriptionShort">
                    <EditItemTemplate>
                        <telerik:RadTextBox runat="server" ID="DescriptionShort" Text='<%# Bind("DescriptionShort") %>' Width="300px"></telerik:RadTextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" ID="LabelDescriptionShort" Text='<%# Eval("DescriptionShort") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="CreatedFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedFrom column" HeaderText="<%$ Resources:Resource, lblCreatedFrom %>" SortExpression="CreatedFrom" UniqueName="CreatedFrom" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="CreatedFromLabel" runat="server" Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="CreatedOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedOn column" HeaderText="<%$ Resources:Resource, lblCreatedOn %>" SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="CreatedOnLabel" runat="server" Text='<%# Eval("CreatedOn") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="EditFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditFrom column" HeaderText="<%$ Resources:Resource, lblEditFrom %>" SortExpression="EditFrom" UniqueName="EditFrom" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="EditFromLabel" runat="server" Text='<%# Eval("EditFrom") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="EditOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditOn column" HeaderText="<%$ Resources:Resource, lblEditOn %>" SortExpression="EditOn" UniqueName="EditOn" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="EditOnLabel" runat="server" Text='<%# Eval("EditOn") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridButtonColumn UniqueName="deleteColumn" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                          ConfirmDialogType="RadWindow"
                                          ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                    <ItemStyle BackColor="Control" />
                </telerik:GridButtonColumn>
            </Columns>
        </MasterTableView>

        <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false">
            <Resizing AllowColumnResize="true"></Resizing>
            <Selecting AllowRowSelect="True" />
            <ClientEvents OnRowClick="OnRowClick" OnGridCreated="OnGridCreated" OnKeyPress="GridKeyPress" />
        </ClientSettings>

    </telerik:RadGrid>

    <asp:SqlDataSource ID="SqlDataSource_CountryGroups" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       OldValuesParameterFormatString="original_{0}"
                       SelectCommand="SELECT * FROM [Master_CountryGroups] WHERE (([SystemID] = @SystemID) AND ([BpID] = @BpID)) ORDER BY [NameVisible]"
                       InsertCommand="INSERT INTO Master_CountryGroups (SystemID, BpID, NameVisible, DescriptionShort, CreatedFrom, CreatedOn, EditFrom, EditOn) VALUES (@SystemID, @BpID, @NameVisible, @DescriptionShort, @UserName, SYSDATETIME(), @UserName, SYSDATETIME())"
                       UpdateCommand="INSERT INTO History_CountryGroups SELECT * FROM Master_CountryGroups WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND CountryGroupID = @original_CountryGroupID; 
                       UPDATE Master_CountryGroups SET NameVisible = @NameVisible, DescriptionShort = @DescriptionShort, EditFrom = @UserName, EditOn = SYSDATETIME() WHERE SystemID = @original_SystemID AND BpID = @original_BpID AND CountryGroupID = @original_CountryGroupID"
                       DeleteCommand="INSERT INTO History_CountryGroups SELECT * FROM Master_CountryGroups WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND CountryGroupID = @original_CountryGroupID; 
                       DELETE FROM Master_CountryGroups WHERE SystemID = @original_SystemID AND BpID = @original_BpID AND CountryGroupID = @original_CountryGroupID">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
        </SelectParameters>
        <InsertParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
            <asp:Parameter Name="NameVisible" />
            <asp:Parameter Name="DescriptionShort" />
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="original_SystemID" Type="Int32" />
            <asp:Parameter Name="original_BpID" Type="Int32" />
            <asp:Parameter Name="original_CountryGroupID" Type="Int32" />
            <asp:Parameter Name="NameVisible" />
            <asp:Parameter Name="DescriptionShort" />
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
        </UpdateParameters>
        <DeleteParameters>
            <asp:Parameter Name="original_SystemID" Type="Int32" />
            <asp:Parameter Name="original_BpID" Type="Int32" />
            <asp:Parameter Name="original_CountryGroupID" Type="Int32" />
        </DeleteParameters>
    </asp:SqlDataSource>
</asp:Content>
