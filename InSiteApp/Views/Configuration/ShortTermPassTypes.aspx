<%@ Page Title="<%$ Resources:Resource, lblShortTermPassTypes %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ShortTermPassTypes.aspx.cs" Inherits="InSite.App.Views.Configuration.ShortTermPassTypes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">

    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server">
        <StyleSheets>
            <telerik:StyleSheetReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Skins.Slider.css" />
            <telerik:StyleSheetReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Skins.Default.Slider.Default.css" />
        </StyleSheets>
    </telerik:RadStyleSheetManager>

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
            <telerik:AjaxSetting AjaxControlID="RadSlider1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadSlider1" />
                    <telerik:AjaxUpdatedControl ControlID="SliderPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadSlider2">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadSlider2" />
                    <telerik:AjaxUpdatedControl ControlID="SliderPanel2" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadSlider3">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadSlider3" />
                    <telerik:AjaxUpdatedControl ControlID="SliderPanel3" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="ValidDays">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="ValidDays" />
                    <telerik:AjaxUpdatedControl ControlID="SliderPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="ValidHours">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="ValidHours" />
                    <telerik:AjaxUpdatedControl ControlID="SliderPanel2" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="ValidMinutes">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="ValidMinutes" />
                    <telerik:AjaxUpdatedControl ControlID="SliderPanel3" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <div>
        <telerik:RadGrid ID="RadGrid1" runat="server" DataSourceID="SqlDataSource_ShortTermPassTypes" AllowPaging="True" AllowSorting="True" CellSpacing="0"
                         GridLines="None" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" CssClass="MainGrid" EnableHierarchyExpandAll="true"
                         EnableGroupsExpandAll="true"
                         OnItemCommand="RadGrid1_ItemCommand" OnItemDeleted="RadGrid1_ItemDeleted" OnItemInserted="RadGrid1_ItemInserted" OnItemUpdated="RadGrid1_ItemUpdated"
                         OnPreRender="RadGrid1_PreRender" OnItemDataBound="RadGrid1_ItemDataBound" OnItemCreated="RadGrid1_ItemCreated" OnGroupsChanging="RadGrid1_GroupsChanging">

            <ExportSettings ExportOnlyData="true" IgnorePaging="true">
                <Pdf PaperSize="A4">
                </Pdf>
                <Excel Format="ExcelML" />
            </ExportSettings>

            <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false">
                <Resizing AllowColumnResize="true"></Resizing>
                <Selecting AllowRowSelect="True" />
                <ClientEvents OnRowClick="OnRowClick" OnGridCreated="OnGridCreated" OnKeyPress="GridKeyPress" />
            </ClientSettings>

        <SortingSettings SortedBackColor="Transparent" />

            <MasterTableView runat="server" DataSourceID="SqlDataSource_ShortTermPassTypes" DataKeyNames="SystemID,BpID,ShortTermPassTypeID" AutoGenerateColumns="False"
                             CommandItemDisplay="Top" EditMode="PopUp" Name="ShortTermPassTypes" ShowHeader="true" CssClass="MasterClass" TableLayout="Auto">

                <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

                <SortExpressions>
                    <telerik:GridSortExpression FieldName="NameVisible" SortOrder="Ascending"></telerik:GridSortExpression>
                </SortExpressions>

                <ColumnGroups>
                    <telerik:GridColumnGroup Name="PeriodOfValidity" HeaderText="<%$ Resources:Resource, lblPeriodOfValidity %>"
                                             HeaderStyle-HorizontalAlign="Center" />
                </ColumnGroups>

                <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="False" ShowExportToExcelButton="True" ShowExportToPdfButton="False"
                                     AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                <EditFormSettings EditFormType="AutoGenerated" CaptionDataField="NameVisible" CaptionFormatString="{0}">
                    <EditColumn ButtonType="ImageButton" UniqueName="EditColumn1" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                                EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                    <FormTableStyle CellPadding="3" CellSpacing="3" />
                    <FormTableAlternatingItemStyle Wrap="False"></FormTableAlternatingItemStyle>
                    <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                </EditFormSettings>

                <NestedViewTemplate>
                    <fieldset style="padding: 10px; width: 500px; margin-left: 10px; margin-bottom: 10px;">
                        <legend style="padding: 5px; background-color: transparent;">
                            <b><%= Resources.Resource.lblDetailsFor %> <%#Eval("NameVisible") %></b>
                        </legend>
                        <table style="width: 100%;">
                            <tr>
                                <td><%= Resources.Resource.lblID %>: </td>
                                <td>
                                    <asp:Label Text='<%#Eval("ShortTermPassTypeID") %>' runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td><%= Resources.Resource.lblNameVisible %>: </td>
                                <td>
                                    <asp:Label Text='<%#Eval("NameVisible") %>' runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td><%= Resources.Resource.lblDescriptionShort %>: </td>
                                <td>
                                    <asp:Label Text='<%#Eval("DescriptionShort") %>' runat="server" Width="300px"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td><%= Resources.Resource.lblTemplate %>: </td>
                                <td>
                                    <telerik:RadComboBox ID="RadComboBoxTemplateID" DataSourceID="SqlDataSource_Templates" DataTextField="NameVisible"
                                                         DataValueField="TemplateID" Height="200px" AppendDataBoundItems="true" SelectedValue='<%# Eval("TemplateID") %>'
                                                         runat="server" Enabled="true">
                                        <Items>
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" />
                                        </Items>
                                    </telerik:RadComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td><%= Resources.Resource.lblRole %>: </td>
                                <td>
                                    <telerik:RadComboBox ID="RadComboBoxRoleID" DataSourceID="SqlDataSource_Roles" DataTextField="NameVisible"
                                                         DataValueField="RoleID" Height="200px" AppendDataBoundItems="true" SelectedValue='<%# Eval("RoleID") %>'
                                                         runat="server" Enabled="true">
                                        <Items>
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" />
                                        </Items>
                                    </telerik:RadComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp; </td>
                                <td>&nbsp; </td>
                            </tr>
                            <tr>
                                <td><%= Resources.Resource.lblValidFrom %>: </td>
                                <td>
                                    <asp:Label runat="server" Text='<%# GetValidFrom(Convert.ToInt32(Eval("ValidFrom"))) %>'></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                <table>
                                    <tr>
                                        <td colspan="3"><%= Resources.Resource.lblPeriodOfValidity %></td>
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td><%= Resources.Resource.lblDays %>: </td>
                                        <td>
                                            <asp:Label Text='<%#Eval("ValidDays") %>' runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td><%= Resources.Resource.lblHourShort %>: </td>
                                        <td>
                                            <asp:Label Text='<%#Eval("ValidHours") %>' runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td><%= Resources.Resource.lblMinuteShort %>: </td>
                                        <td>
                                            <asp:Label Text='<%#Eval("ValidMinutes") %>' runat="server"></asp:Label>
                                        </td>
                                    </tr>
                            </tr>
                        </table>
                        </td>
                        </tr>
                        <tr>
                            <td>&nbsp; </td>
                            <td>&nbsp; </td>
                        </tr>
                        <tr>
                            <td><%= Resources.Resource.lblCreatedFrom %>: </td>
                            <td>
                                <asp:Label Text='<%#Eval("CreatedFrom") %>' runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td><%= Resources.Resource.lblCreatedOn %>: </td>
                            <td>
                                <asp:Label Text='<%#Eval("CreatedOn") %>' runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td><%= Resources.Resource.lblEditFrom %>: </td>
                            <td>
                                <asp:Label Text='<%#Eval("EditFrom") %>' runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td><%= Resources.Resource.lblEditOn %>: </td>
                            <td>
                                <asp:Label Text='<%#Eval("EditOn") %>' runat="server"></asp:Label>
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

                    <telerik:GridTemplateColumn DataField="ShortTermPassTypeID" Visible="false" InsertVisiblityMode="AlwaysHidden" DataType="System.Int32"
                                                FilterControlAltText="Filter ShortTermPassTypeID column" HeaderText="<%$ Resources:Resource, lblID %>"
                                                SortExpression="ShortTermPassTypeID" UniqueName="ShortTermPassTypeID" 
                                                GroupByExpression="ShortTermPassTypeID ShortTermPassTypeID GROUP BY ShortTermPassTypeID">
                        <EditItemTemplate>
                            <asp:Label runat="server" ID="LabelShortTermPassTypeID" Text='<%# Eval("ShortTermPassTypeID") %>'></asp:Label>
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
                                                SortExpression="DescriptionShort" UniqueName="DescriptionShort" GroupByExpression="DescriptionShort DescriptionShort GROUP BY DescriptionShort" 
                                                >
                        <EditItemTemplate>
                            <telerik:RadTextBox runat="server" ID="DescriptionShort" Text='<%# Bind("DescriptionShort") %>' Width="300px"></telerik:RadTextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" ID="LabelDescriptionShort" Text='<%# Eval("DescriptionShort") %>'></asp:Label>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridDropDownColumn DataField="TemplateID" DataSourceID="SqlDataSource_Templates" HeaderText="<%$ Resources:Resource, lblTemplate %>" ListTextField="NameVisible"
                                                ListValueField="TemplateID" UniqueName="TemplateID" DropDownControlType="RadComboBox">
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

                    <telerik:GridDropDownColumn DataField="RoleID" DataSourceID="SqlDataSource_Roles" HeaderText="<%$ Resources:Resource, lblRole %>" ListTextField="NameVisible"
                                                ListValueField="RoleID" UniqueName="RoleID" DropDownControlType="RadComboBox" DefaultInsertValue="2">
                        <FilterTemplate>
                            <telerik:RadComboBox ID="RadComboBoxRoleID" DataSourceID="SqlDataSource_Roles" DataTextField="NameVisible"
                                                 DataValueField="RoleID" Height="200px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("RoleID").CurrentFilterValue %>'
                                                 runat="server" OnClientSelectedIndexChanged="RoleIDIndexChanged">
                                <Items>
                                    <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" />
                                </Items>
                            </telerik:RadComboBox>
                            <telerik:RadScriptBlock ID="RadScriptBlock2" runat="server">
                                <script type="text/javascript">
                                    function RoleIDIndexChanged(sender, args) {
                                        var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                        tableView.filter("RoleID", args.get_item().get_value(), "EqualTo");
                                    }
                                </script>
                            </telerik:RadScriptBlock>
                        </FilterTemplate>
                    </telerik:GridDropDownColumn>

                    <telerik:GridTemplateColumn DataField="TypeID" DataType="System.Byte" FilterControlAltText="Filter TypeID column" HeaderText="<%$ Resources:Resource, lblValidFrom %>"
                                                SortExpression="TypeID" UniqueName="TypeID" GroupByExpression="TypeID TypeID GROUP BY TypeID">
                        <EditItemTemplate>
                            <telerik:RadDropDownList ID="RadDropDownList1" runat="server" SelectedValue='<%# Bind("ValidFrom") %>' Width="300">
                                <Items>
                                    <telerik:DropDownListItem runat="server" Selected="True" Text="<%$ Resources:Resource, selSTPIssueDate %>" Value="1" />
                                    <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selSTPVisitorAssign %>" Value="2" />
                                </Items>
                            </telerik:RadDropDownList>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# GetValidFrom(Convert.ToInt32(Eval("ValidFrom"))) %>'></asp:Label>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn DataField="ValidDays" FilterControlAltText="Filter ValidDays column" HeaderText="<%$ Resources:Resource, lblDays %>"
                                                SortExpression="ValidDays" UniqueName="ValidDays" GroupByExpression="ValidDays ValidDays GROUP BY ValidDays" 
                                                ColumnGroupName="PeriodOfValidity" ItemStyle-HorizontalAlign="Right">
                        <EditItemTemplate>
                            <telerik:RadAjaxPanel runat="server" ID="SliderPanel1" Width="570px">
                                <table>
                                    <tr>
                                        <td valign="top">
                                            <telerik:RadNumericTextBox runat="server" ID="ValidDays" Text='<%# Bind("ValidDays") %>' Width="50" OnTextChanged="ValidDays_TextChanged" 
                                                                       AutoPostBack="true" Type="Number" ShowSpinButtons="true" ButtonsPosition="Right" MinValue="0">
                                                <IncrementSettings Step="1" />
                                                <NumberFormat DecimalDigits="0" />
                                            </telerik:RadNumericTextBox>
                                        </td>
                                        <td style="padding-left: 10px;">
                                            <telerik:RadSlider ID="RadSlider1" runat="server" MinimumValue="0" MaximumValue="30" ItemType="Tick" SmallChange="1" LargeChange="5"
                                                               TrackPosition="TopLeft" Width="500" Height="40" EnableServerSideRendering="true" OnValueChanged="RadSlider1_ValueChanged" AutoPostBack="true"
                                                               Value='<%# Convert.ToDecimal(Eval("ValidDays")) %>' EnableEmbeddedBaseStylesheet="false" EnableEmbeddedSkins="true">
                                            </telerik:RadSlider>
                                        </td>
                                    </tr>
                                </table>
                            </telerik:RadAjaxPanel>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <telerik:RadAjaxPanel runat="server" ID="SliderPanel1" Width="570px">
                                <table>
                                    <tr>
                                        <td valign="top">
                                            <telerik:RadNumericTextBox runat="server" ID="ValidDays" Text='<%# Bind("ValidDays") %>' Width="50" OnTextChanged="ValidDays_TextChanged" 
                                                                       AutoPostBack="true" Type="Number" ShowSpinButtons="true" ButtonsPosition="Right" MinValue="0">
                                                <IncrementSettings Step="1" />
                                                <NumberFormat DecimalDigits="0" />
                                            </telerik:RadNumericTextBox>
                                        </td>
                                        <td style="padding-left: 10px;">
                                            <telerik:RadSlider ID="RadSlider1" runat="server" MinimumValue="0" MaximumValue="30" ItemType="Tick" SmallChange="1" LargeChange="5"
                                                               TrackPosition="TopLeft" Width="500" Height="40" EnableServerSideRendering="true" OnValueChanged="RadSlider1_ValueChanged" AutoPostBack="true"
                                                               EnableEmbeddedBaseStylesheet="false" EnableEmbeddedSkins="true">
                                            </telerik:RadSlider>
                                        </td>
                                    </tr>
                                </table>
                            </telerik:RadAjaxPanel>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" ID="LabelValidDays" Text='<%# Eval("ValidDays") %>'></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle VerticalAlign="Top" HorizontalAlign="Right" />
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn DataField="ValidHours" FilterControlAltText="Filter ValidHours column" HeaderText="<%$ Resources:Resource, lblHourShort %>"
                                                SortExpression="ValidHours" UniqueName="ValidHours" GroupByExpression="ValidHours ValidHours GROUP BY ValidHours" 
                                                ColumnGroupName="PeriodOfValidity" ItemStyle-HorizontalAlign="Right">
                        <EditItemTemplate>
                            <telerik:RadAjaxPanel runat="server" ID="SliderPanel2" Width="570px">
                                <table>
                                    <tr>
                                        <td valign="top">
                                            <telerik:RadNumericTextBox runat="server" ID="ValidHours" Text='<%# Bind("ValidHours") %>' Width="50" OnTextChanged="ValidHours_TextChanged" 
                                                                       AutoPostBack="true" Type="Number" ShowSpinButtons="true" ButtonsPosition="Right" MinValue="0">
                                                <IncrementSettings Step="1" />
                                                <NumberFormat DecimalDigits="0" />
                                            </telerik:RadNumericTextBox>
                                        </td>
                                        <td style="padding-left: 10px;">
                                            <telerik:RadSlider ID="RadSlider2" runat="server" MinimumValue="0" MaximumValue="23" ItemType="Tick" SmallChange="1" LargeChange="3"
                                                               TrackPosition="TopLeft" Width="500" Height="40" EnableServerSideRendering="true" OnValueChanged="RadSlider2_ValueChanged" AutoPostBack="true"
                                                               Value='<%# Convert.ToDecimal(Eval("ValidHours")) %>' EnableEmbeddedBaseStylesheet="false" EnableEmbeddedSkins="true">
                                            </telerik:RadSlider>
                                        </td>
                                    </tr>
                                </table>
                            </telerik:RadAjaxPanel>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <telerik:RadAjaxPanel runat="server" ID="SliderPanel2" Width="570px">
                                <table>
                                    <tr>
                                        <td valign="top">
                                            <telerik:RadNumericTextBox runat="server" ID="ValidHours" Text='<%# Bind("ValidHours") %>' Width="50" OnTextChanged="ValidHours_TextChanged" 
                                                                       AutoPostBack="true" Type="Number" ShowSpinButtons="true" ButtonsPosition="Right" MinValue="0">
                                                <IncrementSettings Step="1" />
                                                <NumberFormat DecimalDigits="0" />
                                            </telerik:RadNumericTextBox>
                                        </td>
                                        <td style="padding-left: 10px;">
                                            <telerik:RadSlider ID="RadSlider2" runat="server" MinimumValue="0" MaximumValue="23" ItemType="Tick" SmallChange="1" LargeChange="3"
                                                               TrackPosition="TopLeft" Width="500" Height="40" EnableServerSideRendering="true" OnValueChanged="RadSlider2_ValueChanged" AutoPostBack="true"
                                                               EnableEmbeddedBaseStylesheet="false" EnableEmbeddedSkins="true">
                                            </telerik:RadSlider>
                                        </td>
                                    </tr>
                                </table>
                            </telerik:RadAjaxPanel>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" ID="LabelValidHours" Text='<%# Eval("ValidHours") %>'></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle VerticalAlign="Top" HorizontalAlign="Right" />
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn DataField="ValidMinutes" FilterControlAltText="Filter ValidMinutes column" HeaderText="<%$ Resources:Resource, lblMinuteShort %>"
                                                SortExpression="ValidMinutes" UniqueName="ValidMinutes" GroupByExpression="ValidMinutes ValidMinutes GROUP BY ValidMinutes" 
                                                ColumnGroupName="PeriodOfValidity" ItemStyle-HorizontalAlign="Right">
                        <EditItemTemplate>
                            <telerik:RadAjaxPanel runat="server" ID="SliderPanel3" Width="570px">
                                <table>
                                    <tr>
                                        <td valign="top">
                                            <telerik:RadNumericTextBox runat="server" ID="ValidMinutes" Text='<%# Bind("ValidMinutes") %>' Width="50" OnTextChanged="ValidMinutes_TextChanged" 
                                                                       AutoPostBack="true" Type="Number" ShowSpinButtons="true" ButtonsPosition="Right" MinValue="0">
                                                <IncrementSettings Step="1" />
                                                <NumberFormat DecimalDigits="0" />
                                            </telerik:RadNumericTextBox>
                                        </td>
                                        <td style="padding-left: 10px;">
                                            <telerik:RadSlider ID="RadSlider3" runat="server" MinimumValue="0" MaximumValue="60" ItemType="Tick" SmallChange="10"
                                                               LargeChange="30" TrackPosition="TopLeft" Width="500" Height="40" EnableServerSideRendering="true" OnValueChanged="RadSlider3_ValueChanged" 
                                                               AutoPostBack="true"
                                                               Value='<%# Convert.ToDecimal(Eval("ValidMinutes")) %>' EnableEmbeddedBaseStylesheet="false" EnableEmbeddedSkins="false">
                                            </telerik:RadSlider>
                                        </td>
                                    </tr>
                                </table>
                            </telerik:RadAjaxPanel>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <telerik:RadAjaxPanel runat="server" ID="SliderPanel3" Width="570px">
                                <table>
                                    <tr>
                                        <td valign="top">
                                            <telerik:RadNumericTextBox runat="server" ID="ValidMinutes" Text='<%# Bind("ValidMinutes") %>' Width="50" OnTextChanged="ValidMinutes_TextChanged" 
                                                                       AutoPostBack="true" Type="Number" ShowSpinButtons="true" ButtonsPosition="Right" MinValue="0">
                                                <IncrementSettings Step="1" />
                                                <NumberFormat DecimalDigits="0" />
                                            </telerik:RadNumericTextBox>
                                        </td>
                                        <td style="padding-left: 10px;">
                                            <telerik:RadSlider ID="RadSlider3" runat="server" MinimumValue="0" MaximumValue="60" ItemType="Tick" SmallChange="10"
                                                               LargeChange="30" TrackPosition="TopLeft" Width="500" Height="40" EnableServerSideRendering="true" OnValueChanged="RadSlider3_ValueChanged" 
                                                               AutoPostBack="true"
                                                               EnableEmbeddedBaseStylesheet="false" EnableEmbeddedSkins="false">
                                            </telerik:RadSlider>
                                        </td>
                                    </tr>
                                </table>
                            </telerik:RadAjaxPanel>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" ID="LabelValidMinutes" Text='<%# Eval("ValidMinutes") %>'></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle VerticalAlign="Top" HorizontalAlign="Right" />
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

                <telerik:GridButtonColumn UniqueName="deleteColumn1" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                          ConfirmDialogType="RadWindow"
                                          ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                    <ItemStyle BackColor="Control" />
                </telerik:GridButtonColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
    </div>

    <asp:SqlDataSource ID="SqlDataSource_ShortTermPassTypes" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>" OnInserted="SqlDataSource_Inserted"
                       OldValuesParameterFormatString="original_{0}"
                       DeleteCommand="INSERT INTO History_ShortTermPassTypes SELECT * FROM Master_ShortTermPassTypes WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [ShortTermPassTypeID] = @original_ShortTermPassTypeID; 
                       DELETE FROM [Master_ShortTermPassTypes] WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [ShortTermPassTypeID] = @original_ShortTermPassTypeID"
                       InsertCommand="INSERT INTO [Master_ShortTermPassTypes] ([SystemID], [BpID], [NameVisible], [DescriptionShort], [TemplateID], ValidFrom, [ValidDays], [ValidHours], [ValidMinutes], [RoleID], [CreatedFrom], [CreatedOn], [EditFrom], [EditOn]) VALUES (@SystemID, @BpID, @NameVisible, @DescriptionShort, @TemplateID, @ValidFrom, @ValidDays, @ValidHours, @ValidMinutes, @RoleID, @UserName, SYSDATETIME(), @UserName, SYSDATETIME()) 
                       SELECT @ReturnValue = SCOPE_IDENTITY()"
                       SelectCommand="SELECT * FROM [Master_ShortTermPassTypes] WHERE (([SystemID] = @SystemID) AND ([BpID] = @BpID)) ORDER BY [NameVisible]"
                       UpdateCommand="INSERT INTO History_ShortTermPassTypes SELECT * FROM Master_ShortTermPassTypes WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [ShortTermPassTypeID] = @original_ShortTermPassTypeID; 
                       UPDATE [Master_ShortTermPassTypes] SET [NameVisible] = @NameVisible, [DescriptionShort] = @DescriptionShort, [TemplateID] = @TemplateID, ValidFrom = @ValidFrom, [ValidDays] = @ValidDays, [ValidHours] = @ValidHours, [ValidMinutes] = @ValidMinutes, [RoleID] = @RoleID, [EditFrom] = @UserName, [EditOn] = SYSDATETIME() WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [ShortTermPassTypeID] = @original_ShortTermPassTypeID">
        <DeleteParameters>
            <asp:Parameter Name="original_SystemID" Type="Int32" />
            <asp:Parameter Name="original_BpID" Type="Int32" />
            <asp:Parameter Name="original_ShortTermPassTypeID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
            <asp:Parameter Name="NameVisible" Type="String" />
            <asp:Parameter Name="DescriptionShort" Type="String" />
            <asp:Parameter Name="TemplateID" Type="Int32" />
            <asp:Parameter Name="ValidFrom" Type="Int32" />
            <asp:Parameter Name="ValidDays" Type="Int32" />
            <asp:Parameter Name="ValidHours" Type="Int32" />
            <asp:Parameter Name="ValidMinutes" Type="Int32" />
            <asp:Parameter Name="RoleID" Type="Int32" />
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
            <asp:Parameter Direction="Output" Name="ReturnValue" Type="Int32" />
        </InsertParameters>
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="NameVisible" Type="String" />
            <asp:Parameter Name="DescriptionShort" Type="String" />
            <asp:Parameter Name="TemplateID" Type="Int32" />
            <asp:Parameter Name="ValidFrom" Type="Int32" />
            <asp:Parameter Name="ValidDays" Type="Int32" />
            <asp:Parameter Name="ValidHours" Type="Int32" />
            <asp:Parameter Name="ValidMinutes" Type="Int32" />
            <asp:Parameter Name="RoleID" Type="Int32" />
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
            <asp:Parameter Name="original_SystemID" Type="Int32" />
            <asp:Parameter Name="original_BpID" Type="Int32" />
            <asp:Parameter Name="original_ShortTermPassTypeID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Templates" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT SystemID, BpID, TemplateID, NameVisible, DescriptionShort, [FileName], CreatedFrom, CreatedOn, EditFrom, EditOn FROM Master_Templates WHERE (SystemID = @SystemID) AND (BpID = @BpID) ORDER BY NameVisible">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Roles" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT SystemID, BpID, RoleID, NameVisible, DescriptionShort, TypeID, IsVisible, CreatedFrom, CreatedOn, EditFrom, EditOn FROM Master_Roles WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (IsVisible = 1)  AND (TypeID <= @UserType) ORDER BY NameVisible">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="UserType" SessionField="UserType" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
