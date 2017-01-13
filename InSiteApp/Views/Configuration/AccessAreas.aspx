<%@ Page Title="<%$ Resources:Resource, lblAccessAreas %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AccessAreas.aspx.cs" Inherits="InSite.App.Views.Configuration.AccessAreas" %>

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
            <telerik:AjaxSetting AjaxControlID="PresentTimeHours">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="PresentTimeHours" />
                    <telerik:AjaxUpdatedControl ControlID="SliderPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="PresentTimeMinutes">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="PresentTimeMinutes" />
                    <telerik:AjaxUpdatedControl ControlID="SliderPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <div>
        <telerik:RadGrid ID="RadGrid1" runat="server" DataSourceID="SqlDataSource_AccessAreas" AllowPaging="True" AllowSorting="True" CellSpacing="0"
                         GridLines="None" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" CssClass="MainGrid" EnableHierarchyExpandAll="true"
                         EnableGroupsExpandAll="true" 
                         OnItemCommand="RadGrid1_ItemCommand" OnItemDeleted="RadGrid1_ItemDeleted" OnItemInserted="RadGrid1_ItemInserted" OnItemUpdated="RadGrid1_ItemUpdated" 
                         OnPreRender="RadGrid1_PreRender" OnItemCreated="RadGrid1_ItemCreated" OnGroupsChanging="RadGrid1_GroupsChanging" OnItemDataBound="RadGrid1_ItemDataBound">

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

            <MasterTableView runat="server" DataSourceID="SqlDataSource_AccessAreas" DataKeyNames="SystemID,BpID,AccessAreaID" AutoGenerateColumns="False" CommandItemDisplay="Top"
                             EditMode="PopUp" Name="StaffRoles" ShowHeader="true" CssClass="MasterClass">

                <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

                <SortExpressions>
                    <telerik:GridSortExpression FieldName="NameVisible" SortOrder="Ascending"></telerik:GridSortExpression>
                </SortExpressions>

                <ColumnGroups>
                    <telerik:GridColumnGroup Name="MaxPresentTime" HeaderText="<%$ Resources:Resource, lblMaxPresentTime %>"
                                             HeaderStyle-HorizontalAlign="Center" />
                </ColumnGroups>

                <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="False" ShowExportToExcelButton="True" ShowExportToPdfButton="False"
                                     AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                <EditFormSettings EditFormType="AutoGenerated" CaptionDataField="NameVisible" CaptionFormatString="{0}">
                    <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                    <EditColumn ButtonType="ImageButton" UniqueName="EditColumn1" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                                EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                    <FormTableStyle CellPadding="3" CellSpacing="3" />
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
                                    <asp:Label Text='<%#Eval("AccessAreaID") %>' runat="server"></asp:Label>
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
                                <td><%= Resources.Resource.lblAccessTimeRelevant %>: </td>
                                <td>
                                    <asp:CheckBox Checked='<%#Eval("AccessTimeRelevant") %>' runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td><%= Resources.Resource.lblCheckInCompelling %>: </td>
                                <td>
                                    <asp:CheckBox Checked='<%#Eval("CheckInCompelling") %>' runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td><%= Resources.Resource.lblUniqueAccess %>: </td>
                                <td>
                                    <asp:CheckBox Checked='<%#Eval("UniqueAccess") %>' runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td><%= Resources.Resource.lblCheckOutCompelling %>: </td>
                                <td>
                                    <asp:CheckBox Checked='<%#Eval("CheckOutCompelling") %>' runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td><%= Resources.Resource.lblCompleteAccessTimes %>: </td>
                                <td>
                                    <asp:CheckBox Checked='<%#Eval("CompleteAccessTimes") %>' runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp; </td>
                                <td>&nbsp; </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                <table style="table-layout: fixed;">
                                    <tr>
                                        <td colspan="3"><%= Resources.Resource.lblMaxPresentTime %></td>
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td><%= Resources.Resource.lblHourShort %>: </td>
                                        <td>
                                            <asp:Label Text='<%#Eval("PresentTimeHours") %>' runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td><%= Resources.Resource.lblMinuteShort %>: </td>
                                        <td>
                                            <asp:Label Text='<%#Eval("PresentTimeMinutes") %>' runat="server"></asp:Label>
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

                    <telerik:GridTemplateColumn DataField="AccessAreaID" Visible="false" InsertVisiblityMode="AlwaysHidden" DataType="System.Int32"
                                                FilterControlAltText="Filter AccessAreaID column" HeaderText="<%$ Resources:Resource, lblID %>"
                                                SortExpression="AccessAreaID" UniqueName="AccessAreaID" GroupByExpression="AccessAreaID AccessAreaID GROUP BY AccessAreaID">
                        <EditItemTemplate>
                            <asp:Label runat="server" ID="LabelAccessAreaID" Text='<%# Eval("AccessAreaID") %>'></asp:Label>
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
                            <asp:Label runat="server" ID="NameVisible" Text='<%# Eval("NameVisible") %>' ></asp:Label>
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

                    <telerik:GridCheckBoxColumn DataField="AccessTimeRelevant" DataType="System.Boolean" FilterControlAltText="Filter AccessTimeRelevant column" HeaderText="<%$ Resources:Resource, lblAccessTimeRelevant %>"
                                                SortExpression="AccessTimeRelevant" UniqueName="AccessTimeRelevant">
                    </telerik:GridCheckBoxColumn>

                    <telerik:GridCheckBoxColumn DataField="CheckInCompelling" DataType="System.Boolean" FilterControlAltText="Filter CheckInCompelling column" HeaderText="<%$ Resources:Resource, lblCheckInCompelling %>"
                                                SortExpression="CheckInCompelling" UniqueName="CheckInCompelling">
                    </telerik:GridCheckBoxColumn>

                    <telerik:GridCheckBoxColumn DataField="UniqueAccess" DataType="System.Boolean" FilterControlAltText="Filter UniqueAccess column" HeaderText="<%$ Resources:Resource, lblUniqueAccess %>"
                                                SortExpression="UniqueAccess" UniqueName="UniqueAccess">
                    </telerik:GridCheckBoxColumn>

                    <telerik:GridCheckBoxColumn DataField="CheckOutCompelling" DataType="System.Boolean" FilterControlAltText="Filter CheckOutCompelling column" HeaderText="<%$ Resources:Resource, lblCheckOutCompelling %>"
                                                SortExpression="CheckOutCompelling" UniqueName="CheckOutCompelling" DefaultInsertValue="true">
                    </telerik:GridCheckBoxColumn>

                    <telerik:GridCheckBoxColumn DataField="CompleteAccessTimes" DataType="System.Boolean" FilterControlAltText="Filter CompleteAccessTimes column" HeaderText="<%$ Resources:Resource, lblCompleteAccessTimes %>"
                                                SortExpression="CompleteAccessTimes" UniqueName="CompleteAccessTimes">
                    </telerik:GridCheckBoxColumn>

                    <telerik:GridTemplateColumn DataField="PresentTimeHours" FilterControlAltText="Filter PresentTimeHours column" HeaderText="<%$ Resources:Resource, lblHourShort %>"
                                                SortExpression="PresentTimeHours" UniqueName="PresentTimeHours" GroupByExpression="PresentTimeHours PresentTimeHours GROUP BY PresentTimeHours"
                                                ColumnGroupName="MaxPresentTime" ItemStyle-HorizontalAlign="Right" DefaultInsertValue="0">
                        <EditItemTemplate>
                            <telerik:RadAjaxPanel runat="server" ID="SliderPanel1" Width="570px">
                                <table>
                                    <tr>
                                        <td valign="top">
                                            <telerik:RadNumericTextBox runat="server" ID="PresentTimeHours" Text='<%# Bind("PresentTimeHours") %>' Width="50" OnTextChanged="PresentTimeHours_TextChanged" 
                                                                       AutoPostBack="true" Type="Number" ShowSpinButtons="true" ButtonsPosition="Right" MinValue="0">
                                                <IncrementSettings Step="1" />
                                                <NumberFormat DecimalDigits="0" />
                                            </telerik:RadNumericTextBox>
                                        </td>
                                        <td style="padding-left: 10px;">
                                            <telerik:RadSlider ID="RadSlider1" runat="server" MinimumValue="0" MaximumValue="23" ItemType="Tick" SmallChange="1" LargeChange="3"
                                                               TrackPosition="TopLeft" Width="500" Height="40" OnValueChanged="RadSlider1_ValueChanged" AutoPostBack="true"
                                                               Value='<%# Convert.ToDecimal(Eval("PresentTimeHours")) %>' EnableServerSideRendering="true" EnableEmbeddedBaseStylesheet="false">
                                            </telerik:RadSlider>
                                        </td>
                                    </tr>
                                </table>
                            </telerik:RadAjaxPanel>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" ID="LabelPresentTimeHours" Text='<%# Eval("PresentTimeHours") %>'></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle VerticalAlign="Top" HorizontalAlign="Right" />
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn DataField="PresentTimeMinutes" FilterControlAltText="Filter PresentTimeMinutes column" HeaderText="<%$ Resources:Resource, lblMinuteShort %>"
                                                SortExpression="PresentTimeMinutes" UniqueName="PresentTimeMinutes" GroupByExpression="PresentTimeMinutes PresentTimeMinutes GROUP BY PresentTimeMinutes"
                                                ColumnGroupName="MaxPresentTime" ItemStyle-HorizontalAlign="Right" DefaultInsertValue="0">
                        <EditItemTemplate>
                            <telerik:RadAjaxPanel runat="server" ID="SliderPanel2" Width="570px">
                                <table>
                                    <tr>
                                        <td valign="top">
                                            <telerik:RadNumericTextBox runat="server" ID="PresentTimeMinutes" Text='<%# Bind("PresentTimeMinutes") %>' Width="50" OnTextChanged="PresentTimeMinutes_TextChanged" 
                                                                       AutoPostBack="true" Type="Number" ShowSpinButtons="true" ButtonsPosition="Right" MinValue="0">
                                                <IncrementSettings Step="1" />
                                                <NumberFormat DecimalDigits="0" />
                                            </telerik:RadNumericTextBox>
                                        </td>
                                        <td style="padding-left: 10px;">
                                            <telerik:RadSlider ID="RadSlider2" runat="server" MinimumValue="0" MaximumValue="60" ItemType="Tick" SmallChange="10"
                                                               LargeChange="30" TrackPosition="TopLeft" Width="500" Height="40" OnValueChanged="RadSlider2_ValueChanged" AutoPostBack="true"
                                                               Value='<%# Convert.ToDecimal(Eval("PresentTimeMinutes")) %>' EnableServerSideRendering="true" EnableEmbeddedBaseStylesheet="false">
                                            </telerik:RadSlider>
                                        </td>
                                    </tr>
                                </table>
                            </telerik:RadAjaxPanel>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" ID="LabelPresentTimeMinutes" Text='<%# Eval("PresentTimeMinutes") %>'></asp:Label>
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

                <telerik:GridButtonColumn UniqueName="deleteColumn" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                          ConfirmDialogType="RadWindow"
                                          ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                    <ItemStyle BackColor="Control" />
                </telerik:GridButtonColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
    </div>

    <asp:SqlDataSource ID="SqlDataSource_AccessAreas" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>" OnInserted="SqlDataSource_Inserted"
                       OldValuesParameterFormatString="original_{0}"
                       DeleteCommand="INSERT INTO History_AccessAreas SELECT * FROM Master_AccessAreas WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [AccessAreaID] = @original_AccessAreaID; 
                       DELETE FROM [Master_AccessAreas] WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [AccessAreaID] = @original_AccessAreaID"
                       InsertCommand="INSERT INTO [Master_AccessAreas] ([SystemID], [BpID], [NameVisible], [DescriptionShort], [AccessTimeRelevant], [CheckInCompelling], [UniqueAccess], [CheckOutCompelling], [CompleteAccessTimes], [PresentTimeHours], [PresentTimeMinutes], [CreatedFrom], [CreatedOn], [EditFrom], [EditOn]) VALUES (@SystemID, @BpID, @NameVisible, @DescriptionShort, @AccessTimeRelevant, @CheckInCompelling, @UniqueAccess, @CheckOutCompelling, @CompleteAccessTimes, @PresentTimeHours, @PresentTimeMinutes, @UserName, SYSDATETIME(), @UserName, SYSDATETIME()) 
                       SELECT @ReturnValue = SCOPE_IDENTITY()"
                       SelectCommand="SELECT * FROM [Master_AccessAreas] WHERE (([SystemID] = @SystemID) AND ([BpID] = @BpID)) ORDER BY [NameVisible]"
                       UpdateCommand="INSERT INTO History_AccessAreas SELECT * FROM Master_AccessAreas WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [AccessAreaID] = @original_AccessAreaID; 
                       UPDATE [Master_AccessAreas] SET [NameVisible] = @NameVisible, [DescriptionShort] = @DescriptionShort, [AccessTimeRelevant] = @AccessTimeRelevant, [CheckInCompelling] = @CheckInCompelling, [UniqueAccess] = @UniqueAccess, [CheckOutCompelling] = @CheckOutCompelling, [CompleteAccessTimes] = @CompleteAccessTimes, [PresentTimeHours] = @PresentTimeHours, [PresentTimeMinutes] = @PresentTimeMinutes, [EditFrom] = @UserName, [EditOn] = SYSDATETIME() WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [AccessAreaID] = @original_AccessAreaID">
        <DeleteParameters>
            <asp:Parameter Name="original_SystemID" Type="Int32" />
            <asp:Parameter Name="original_BpID" Type="Int32" />
            <asp:Parameter Name="original_AccessAreaID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
            <asp:Parameter Name="NameVisible" Type="String" />
            <asp:Parameter Name="DescriptionShort" Type="String" />
            <asp:Parameter Name="AccessTimeRelevant" Type="Boolean" />
            <asp:Parameter Name="CheckInCompelling" Type="Boolean" />
            <asp:Parameter Name="UniqueAccess" Type="Boolean" />
            <asp:Parameter Name="CheckOutCompelling" Type="Boolean" />
            <asp:Parameter Name="CompleteAccessTimes" Type="Boolean" />
            <asp:Parameter Name="PresentTimeHours" Type="Int32" />
            <asp:Parameter Name="PresentTimeMinutes" Type="Int32" />
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
            <asp:Parameter Name="AccessTimeRelevant" Type="Boolean" />
            <asp:Parameter Name="CheckInCompelling" Type="Boolean" />
            <asp:Parameter Name="UniqueAccess" Type="Boolean" />
            <asp:Parameter Name="CheckOutCompelling" Type="Boolean" />
            <asp:Parameter Name="CompleteAccessTimes" Type="Boolean" />
            <asp:Parameter Name="PresentTimeHours" Type="Int32" />
            <asp:Parameter Name="PresentTimeMinutes" Type="Int32" />
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
            <asp:Parameter Name="original_SystemID" Type="Int32" />
            <asp:Parameter Name="original_BpID" Type="Int32" />
            <asp:Parameter Name="original_AccessAreaID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
</asp:Content>
