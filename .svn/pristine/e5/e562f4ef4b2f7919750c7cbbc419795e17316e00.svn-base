<%@ Page Title="<%$ Resources:Resource, lblAttributeForPrintPass %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Attributes.aspx.cs" Inherits="InSite.App.Views.Configuration.Attributes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <telerik:RadPersistenceManagerProxy ID="RadPersistenceManagerProxy1" runat="server">
        <PersistenceSettings>
            <telerik:PersistenceSetting ControlID="RadGrid1" />
        </PersistenceSettings>
    </telerik:RadPersistenceManagerProxy>

    <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGrid1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <telerik:RadGrid ID="RadGrid1" runat="server" DataSourceID="SqlDataSource_AttributesBuildingProject" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" 
                     AllowPaging="true" AllowSorting="true" CssClass="MainGrid" 
                     OnPreRender="RadGrid1_PreRender" OnItemDeleted="RadGrid1_ItemDeleted" OnItemCommand="RadGrid1_ItemCommand" OnItemDataBound="RadGrid1_ItemDataBound" 
                     OnItemUpdated="RadGrid1_ItemUpdated" OnItemInserted="RadGrid1_ItemInserted" OnItemCreated="RadGrid1_ItemCreated" OnGroupsChanging="RadGrid1_GroupsChanging">

        <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false">
            <Resizing AllowColumnResize="true"></Resizing>
            <Selecting AllowRowSelect="True" />
            <ClientEvents OnRowClick="OnRowClick" OnGridCreated="OnGridCreated" OnKeyPress="GridKeyPress" />
        </ClientSettings>

        <ExportSettings ExportOnlyData="True" IgnorePaging="True">
            <Pdf PaperSize="A4">
            </Pdf>
            <Excel Format="ExcelML" />
        </ExportSettings>

        <SortingSettings SortedBackColor="Transparent" />

        <MasterTableView AutoGenerateColumns="False" DataKeyNames="SystemID,BpID,AttributeID" CommandItemDisplay="Top" EditMode="PopUp" DataSourceID="SqlDataSource_AttributesBuildingProject"
                         HierarchyLoadMode="ServerOnDemand" Name="Attributes" ShowHeader="true" AllowPaging="true" PageSize="20" CssClass="MasterClass">

            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

            <SortExpressions>
                <telerik:GridSortExpression FieldName="NameVisible" SortOrder="Ascending"></telerik:GridSortExpression>
            </SortExpressions>

            <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="False" ShowExportToExcelButton="True" ShowExportToPdfButton="False"
                                 AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

            <EditFormSettings CaptionDataField="NameVisible" CaptionFormatString="{0}">
                <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                <EditColumn ButtonType="ImageButton" UniqueName="EditCommandColumn1" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                            UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                <FormTableStyle CellPadding="3" CellSpacing="3" />
            </EditFormSettings>

            <NestedViewTemplate>
                <fieldset style="padding: 10px; width: 500px; margin-left: 10px; margin-bottom: 10px;">
                    <legend style="padding: 5px; background-color: transparent;">
                        <b><%# String.Concat(Resources.Resource.lblDetailsFor, " ", Eval("NameVisible"))%></b>
                    </legend>
                    <table style="width: 100%;">
                        <tr>
                            <td><%= Resources.Resource.lblID%>: </td>
                            <td>
                                <asp:Label Text='<%#Eval("AttributeID")%>' runat="server"></asp:Label>
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
                            <td><%= Resources.Resource.lblPassColor%>: </td>
                            <td>
                                <div style='width: 50px; height: 16px; background-color: <%# Eval("PassColor") %>'></div>
                            </td>
                        </tr>
                        <tr>
                            <td><%= Resources.Resource.lblTemplate%>: </td>
                            <td>
                                <telerik:RadComboBox ID="RadComboBoxTemplateID" DataSourceID="SqlDataSource_Templates" DataTextField="NameVisible"
                                                     DataValueField="TemplateID" Height="200px" AppendDataBoundItems="true" SelectedValue='<%# Eval("TemplateID") %>'
                                                     runat="server" Enabled="false" >
                                    <Items>
                                        <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" />
                                    </Items>
                                </telerik:RadComboBox>
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

                <telerik:GridTemplateColumn DataField="AttributeID" Visible="false" DataType="System.Int32" FilterControlAltText="Filter AttributeID column" HeaderText="<%$ Resources:Resource, lblID %>"
                                            SortExpression="AttributeID" UniqueName="AttributeID" GroupByExpression="AttributeID AttributeID GROUP BY AttributeID">
                    <EditItemTemplate>
                        <asp:Label runat="server" ID="AttributeID" Text='<%# Eval("AttributeID") %>'></asp:Label>
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
                        <telerik:RadTextBox runat="server" ID="DescriptionShort" Text='<%# Bind("DescriptionShort") %>' Width="400px"></telerik:RadTextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" ID="LabelDescriptionShort" Text='<%# Eval("DescriptionShort") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="PassColor" FilterControlAltText="Filter PassColor column" HeaderText="<%$ Resources:Resource, lblPassColor %>"
                                            SortExpression="PassColor" UniqueName="PassColor" GroupByExpression="PassColor PassColor GROUP BY PassColor">
                    <EditItemTemplate>
                        <telerik:RadColorPicker ID="RadColorPicker1" runat="server" EnableTheming="true" ShowRecentColors="true" ShowIcon="true" EnableEmbeddedSkins="true" KeepInScreenBounds="true"
                                                SelectedColor='<%# InSite.App.Helpers.Html2Color(InSite.App.Helpers.CStr(Eval("PassColor"))) %>' PaletteModes="All" ShowEmptyColor="true" Width="295px"
                                                style="margin-left: 5px; margin-right: 5px; width: 295px !important;" EnableEmbeddedScripts="true" EnableAjaxSkinRendering="true" EnableEmbeddedBaseStylesheet="true">
                        </telerik:RadColorPicker>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <div style='width: 50px; height: 16px; background-color: <%# Eval("PassColor") %>'></div>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridDropDownColumn DataField="TemplateID" DataSourceID="SqlDataSource_Templates" HeaderText="<%$ Resources:Resource, lblTemplate %>" ListTextField="NameVisible"
                                            ListValueField="TemplateID" UniqueName="TemplateID" DropDownControlType="RadComboBox" AllowFiltering="true" ShowFilterIcon="true"
                                            ItemStyle-Width="300px">
                    <FilterTemplate>
                        <telerik:RadComboBox ID="RadComboBoxTemplateID" DataSourceID="SqlDataSource_Templates" DataTextField="NameVisible"
                                             DataValueField="TemplateID" Height="200px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("TemplateID").CurrentFilterValue %>'
                                             runat="server" OnClientSelectedIndexChanged="TemplateIDIndexChanged">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock3" runat="server">
                            <script type="text/javascript">
                                function TemplateIDIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    tableView.filter("TemplateID", args.get_item().get_value(), "EqualTo");
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridDropDownColumn>

                <telerik:GridTemplateColumn DataField="CreatedFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedFrom column" HeaderText="<%$ Resources:Resource, lblCreatedFrom %>" SortExpression="CreatedFrom" UniqueName="CreatedFrom" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="CreatedFromLabel" runat="server" Text='<%# Eval("CreatedFrom")%>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="CreatedOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedOn column" HeaderText="<%$ Resources:Resource, lblCreatedOn %>" SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="CreatedOnLabel" runat="server" Text='<%# Eval("CreatedOn")%>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="EditFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditFrom column" HeaderText="<%$ Resources:Resource, lblEditFrom %>" SortExpression="EditFrom" UniqueName="EditFrom" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="EditFromLabel" runat="server" Text='<%# Eval("EditFrom")%>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="EditOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditOn column" HeaderText="<%$ Resources:Resource, lblEditOn %>" 
                    SortExpression="EditOn" UniqueName="EditOn" Visible="False">
                    <HeaderStyle VerticalAlign="Top" />
                    <ItemStyle VerticalAlign="Top" />
                    <ItemTemplate>
                        <asp:Label ID="EditOnLabel" runat="server" Text='<%# Eval("EditOn") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="AttributeID" Visible="false">
                    <EditItemTemplate>
                        <br />
                        <br />
                        <br />
                        <br />
                        <br />
                        <br />
                        <br />
                        <br />
                        <br />
                        <br />
                    </EditItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridButtonColumn UniqueName="deleteColumn" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                          ConfirmDialogType="RadWindow"
                                          ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                    <ItemStyle BackColor="Control" />
                </telerik:GridButtonColumn>
            </Columns>

        </MasterTableView>

    </telerik:RadGrid>

    <asp:SqlDataSource ID="SqlDataSource_AttributesBuildingProject" runat="server" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>' 
                       OldValuesParameterFormatString="original_{0}" 
                       DeleteCommand="DELETE FROM [Master_AttributesBuildingProject] WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [AttributeID] = @original_AttributeID" 
                       InsertCommand="INSERT INTO [Master_AttributesBuildingProject] ([SystemID], [BpID], [NameVisible], [DescriptionShort], [PassColor], [TemplateID], [CreatedFrom], [CreatedOn], [EditFrom], [EditOn]) VALUES (@SystemID, @BpID, @NameVisible, @DescriptionShort, @PassColor, @TemplateID, @UserName, SYSDATETIME(), @UserName, SYSDATETIME())" 
                       SelectCommand="SELECT * FROM [Master_AttributesBuildingProject] WHERE (([SystemID] = @SystemID) AND ([BpID] = @BpID))" 
                       UpdateCommand="UPDATE [Master_AttributesBuildingProject] SET [NameVisible] = @NameVisible, [DescriptionShort] = @DescriptionShort, [PassColor] = @PassColor, [TemplateID] = @TemplateID, [EditFrom] = @UserName, [EditOn] = SYSDATETIME() WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [AttributeID] = @original_AttributeID">

        <DeleteParameters>
            <asp:Parameter Name="original_SystemID" Type="Int32"></asp:Parameter>
            <asp:Parameter Name="original_BpID" Type="Int32"></asp:Parameter>
            <asp:Parameter Name="original_AttributeID" Type="Int32"></asp:Parameter>
        </DeleteParameters>
        <InsertParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
            <asp:Parameter Name="NameVisible" Type="String"></asp:Parameter>
            <asp:Parameter Name="DescriptionShort" Type="String"></asp:Parameter>
            <asp:Parameter Name="PassColor" />
            <asp:Parameter Name="TemplateID" Type="Int32"></asp:Parameter>
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
        </InsertParameters>
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="NameVisible" Type="String"></asp:Parameter>
            <asp:Parameter Name="DescriptionShort" Type="String"></asp:Parameter>
            <asp:Parameter Name="PassColor" />
            <asp:Parameter Name="TemplateID" Type="Int32"></asp:Parameter>
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
            <asp:Parameter Name="original_SystemID" Type="Int32"></asp:Parameter>
            <asp:Parameter Name="original_BpID" Type="Int32"></asp:Parameter>
            <asp:Parameter Name="original_AttributeID" Type="Int32"></asp:Parameter>
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Templates" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT SystemID, BpID, TemplateID, NameVisible, DescriptionShort, FileName, CreatedFrom, CreatedOn, EditFrom, EditOn FROM Master_Templates WHERE (SystemID = @SystemID) AND (BpID = @BpID) ORDER BY NameVisible">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
