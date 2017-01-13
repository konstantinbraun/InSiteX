<%@ Page Title="<%$ Resources:Resource, lblTemplates %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Templates.aspx.cs" Inherits="InSite.App.Views.Configuration.Templates" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
        <script type="text/javascript">
            var uploadedFilesCount = 0;
            var isEditMode;
            function validateRadUpload(source, e) {
                // When the RadGrid is in Edit mode the user is not obliged to upload file.
                if (isEditMode == null || isEditMode == undefined) {
                    e.IsValid = true;

                    if (uploadedFilesCount > 0) {
                        e.IsValid = true;
                    }
                }
                isEditMode = null;
            }

            function OnClientFileUploaded(sender, eventArgs) {
                uploadedFilesCount++;
            }

            function OnClientKeyPressing(sender, args) {
                sender.showDropDown();
            }

            function gridCommand(sender, args) {
                if (args.get_commandName() == "EditTemplate" || args.get_commandName() == "EditTemplateRDL") {
                    var manager = $find('<%= RadAjaxManager.GetCurrent(Page).ClientID%>');
                    manager.set_enableAJAX(false);

                    setTimeout(function () {
                        manager.set_enableAJAX(true);
                    }, 0);
                }
            }

            function uploadTemplate(sender, args) {
                var upload = $telerik.findControl(sender.get_parent().get_element(), "AsyncUpload1");
                upload.startUpload();
            }
        </script>
    </telerik:RadScriptBlock>

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

    <telerik:RadGrid ID="RadGrid1" runat="server" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" ShowStatusBar="true" GroupPanelPosition="BeforeHeader"
                     ShowGroupPanel="true" AllowAutomaticDeletes="false" AllowAutomaticInserts="false" AllowAutomaticUpdates="false" CssClass="MainGrid"
                     OnItemDeleted="RadGrid1_ItemDeleted" OnItemInserted="RadGrid1_ItemInserted" OnItemUpdated="RadGrid1_ItemUpdated" OnPreRender="RadGrid1_PreRender"
                     OnItemCreated="RadGrid1_ItemCreated" OnItemCommand="RadGrid1_ItemCommand" OnGroupsChanging="RadGrid1_GroupsChanging" OnNeedDataSource="RadGrid1_NeedDataSource"
                     OnInsertCommand="RadGrid1_InsertCommand" OnUpdateCommand="RadGrid1_UpdateCommand" OnDeleteCommand="RadGrid1_DeleteCommand" OnItemDataBound="RadGrid1_ItemDataBound">

        <ExportSettings ExportOnlyData="True" IgnorePaging="True">
            <Pdf PaperSize="A4">
            </Pdf>
            <Excel Format="ExcelML" />
        </ExportSettings>

        <ClientSettings AllowDragToGroup="True">
            <Selecting AllowRowSelect="True" />
        </ClientSettings>

        <SortingSettings SortedBackColor="Transparent" />

        <MasterTableView AutoGenerateColumns="False" DataKeyNames="SystemID,BpID,TemplateID" CommandItemDisplay="Top" EditMode="PopUp" CssClass="DetailClass">

            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

            <SortExpressions>
                <telerik:GridSortExpression FieldName="NameVisible" SortOrder="Ascending"></telerik:GridSortExpression>
            </SortExpressions>

            <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="false" ShowExportToExcelButton="True" ShowExportToPdfButton="false"
                                 AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

            <EditFormSettings CaptionDataField="NameVisible" CaptionFormatString="{0}">
                <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                <EditColumn ButtonType="ImageButton" UniqueName="EditColumn2" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                            EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                <FormTableStyle CellPadding="3" CellSpacing="3" />
            </EditFormSettings>

            <Columns>
                <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                               UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                    <ItemStyle BackColor="Control" Width="30px" />
                    <HeaderStyle Width="30px" />
                </telerik:GridEditCommandColumn>

                <telerik:GridTemplateColumn DataField="TemplateID" Visible="false" InsertVisiblityMode="AlwaysHidden" DataType="System.Int32" FilterControlAltText="Filter TemplateID column" HeaderText="<%$ Resources:Resource, lblID %>"
                                            SortExpression="TemplateID" UniqueName="TemplateID" GroupByExpression="TemplateID TemplateID GROUP BY TemplateID">
                    <EditItemTemplate>
                        <asp:Label runat="server" ID="LabelRelevantDocumentID" Text='<%# Eval("TemplateID")%>'></asp:Label>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                    </InsertItemTemplate>
                    <ItemTemplate>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="NameVisible" HeaderText="<%$ Resources:Resource, lblNameVisible %>" SortExpression="NameVisible" UniqueName="NameVisible"
                                            GroupByExpression="NameVisible NameVisible GROUP BY NameVisible">
                    <EditItemTemplate>
                        <telerik:RadTextBox runat="server" ID="NameVisible" Text='<%# Bind("NameVisible")%>' Width="300px"></telerik:RadTextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" ID="NameVisible" Text='<%# Eval("NameVisible")%>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="DescriptionShort" FilterControlAltText="Filter DescriptionShort column" HeaderText="<%$ Resources:Resource, lblDescriptionShort %>"
                                            SortExpression="DescriptionShort" UniqueName="DescriptionShort" GroupByExpression="DescriptionShort DescriptionShort GROUP BY DescriptionShort">
                    <EditItemTemplate>
                        <telerik:RadTextBox runat="server" ID="DescriptionShort" Text='<%# Bind("DescriptionShort")%>' Width="300px"></telerik:RadTextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" ID="LabelDescriptionShort" Text='<%# Eval("DescriptionShort")%>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="DialogID" FilterControlAltText="Filter DialogID column" HeaderText="<%$ Resources:Resource, lblDialog %>"
                                            SortExpression="DialogID" UniqueName="DialogID" GroupByExpression="DialogID DialogID GROUP BY DialogID">
                    <EditItemTemplate>
                        <telerik:RadDropDownTree runat="server" ID="DialogID" DataFieldParentID="ParentID" DataFieldID="NodeID" 
                                                 DataValueField="DialogID" EnableFiltering="true" DataTextField="NameVisible" Width="300px" 
                                                 DefaultMessage="<%$ Resources:Resource, msgPleaseSelect %>" DataSourceID="SqlDataSource_Dialogs" SelectedValue='<%# Eval("DialogID")%>' 
                                                 OnClientKeyPressing="OnClientKeyPressing" OnDataBound="DialogID_DataBound" OnEntryAdded="DialogID_EntryAdded" AutoPostBack="true">
                            <ButtonSettings ShowClear="true" />
                            <FilterSettings Highlight="Matches" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" Filter="Contains" />
                            <DropDownSettings OpenDropDownOnLoad="false" CloseDropDownOnSelection="true" AutoWidth="Enabled" Height="500px" />
                            <DropDownNodeTemplate>
                                <table cellpadding="1px" cellspacing="0px" style="text-align: left; height: 22px;">
                                    <tr style="text-align: left; height: 22px;">
                                        <td style="text-align: left; height: 22px;">
                                            <asp:Image ImageUrl='<%# String.Concat("~/Resources/", Eval("ImagePath"), "/", Eval("ImageName"))%>' runat="server" 
                                                       Width="22px" Height="22px"/>
                                        </td>
                                        <td style="text-align: left; padding-left: 5px; height: 22px;">
                                            <asp:Label Text='<%# GetResource(Eval("ResourceID").ToString())%>' runat="server">
                                            </asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </DropDownNodeTemplate>
                        </telerik:RadDropDownTree>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <table cellpadding="0px" cellspacing="0px" style="border: none">
                            <tr>
                                <td style="padding: 0px; margin: 0px; border: none; width:20px;">
                                    <asp:Image runat="server" ID="DialogIcon" ImageUrl='<%# Eval("ImageUrl") %>' Width="16px" Height="16px" />
                                </td>
                                <td style="padding: 0px; margin: 0px; border: none;">
                                    <asp:Label runat="server" ID="DialogID" Text='<%# Eval("DialogName") %>'></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="FilterDialogID" DataSourceID="SqlDataSource_DialogsFilter" DataTextField="NameVisible"
                                             DataValueField="DialogID" AppendDataBoundItems="true" DropDownAutoWidth="Enabled"
                                             SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("DialogID").CurrentFilterValue %>'
                                             runat="server" OnClientSelectedIndexChanged="FilterDialogIDIndexChanged">
                            <ItemTemplate>
                                <table cellpadding="1px" cellspacing="0px" style="text-align: left; height: 16px;">
                                    <tr style="text-align: left; height: 16px;">
                                        <td style="text-align: left; height: 16px; width: 16px;">
                                            <asp:Image ImageUrl='<%# String.Concat("~/Resources/", Eval("ImagePath"), "/", Eval("ImageName"))%>' runat="server" 
                                                       Width="16px" Height="16px" Visible='<%# (Eval("ImageName").ToString().Equals(string.Empty)) ? false : true %>'/>
                                        </td>
                                        <td style="text-align: left; padding-left: 5px; height: 16px;">
                                            <asp:Label Text='<%# GetResource(Eval("ResourceID").ToString())%>' runat="server">
                                            </asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" Value="" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock2" runat="server">
                            <script type="text/javascript">
                                function FilterDialogIDIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    tableView.filter("DialogID", args.get_item().get_value(), "EqualTo");
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="FileType" FilterControlAltText="Filter FileType column" HeaderText="<%$ Resources:Resource, lblTemplateType %>"
                                            SortExpression="FileType" UniqueName="FileType" GroupByExpression="FileType FileType GROUP BY FileType" InsertVisiblityMode="AlwaysHidden">
                    <EditItemTemplate>
                        <table cellpadding="0px" cellspacing="0px" style="border: none">
                            <tr>
                                <td style="padding: 0px; margin: 0px; border: none; width:20px;">
                                    <asp:Image runat="server" ID="TypeIcon" ImageUrl='<%# (Eval("FileType").ToString().Equals("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")) ? "/InSiteApp/Resources/Icons/export_xlsx_16.png" : "/InSiteApp/Resources/Icons/export_pdf_16.png" %>' />
                                </td>
                                <td style="padding: 0px; margin: 0px; border: none;">
                                    <asp:Label runat="server" ID="FileType" Text='<%# (Eval("FileType").ToString().Equals("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")) ? Resources.Resource.lblTemplateTypeXLSX : Resources.Resource.lblTemplateTypeRDL %>'></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <table cellpadding="0px" cellspacing="0px" style="border: none">
                            <tr>
                                <td style="padding: 0px; margin: 0px; border: none; width:20px;">
                                    <asp:Image runat="server" ID="TypeIcon" ImageUrl='<%# (Eval("FileType").ToString().Equals("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")) ? "/InSiteApp/Resources/Icons/export_xlsx_16.png" : "/InSiteApp/Resources/Icons/export_pdf_16.png" %>' />
                                </td>
                                <td style="padding: 0px; margin: 0px; border: none;">
                                    <asp:Label runat="server" ID="FileType" Text='<%# (Eval("FileType").ToString().Equals("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")) ? Resources.Resource.lblTemplateTypeXLSX : Resources.Resource.lblTemplateTypeRDL %>'></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="FileName" FilterControlAltText="Filter FileName column" HeaderText="<%$ Resources:Resource, lblFileName %>" HeaderStyle-VerticalAlign="Top"
                                            SortExpression="FileName" UniqueName="FileName" GroupByExpression="FileName FileName GROUP BY FileName" DefaultInsertValue="" ForceExtractValue="Always">
                    <EditItemTemplate>

                        <asp:Panel runat="server" ID="PanelOfficeReport" Visible="true">
                            <table>
                                <tr>
                                    <td width="22px">
                                        <telerik:RadButton ID="btnEditTemplate" ToolTip='<%# Resources.Resource.lblEditTemplate%>' runat="server" CausesValidation="False"
                                                           CommandName="EditTemplate" OnClientClicked="gridCommand" Icon-PrimaryIconCssClass="rgEdit" ButtonType="ToggleButton" Width="22px">
                                        </telerik:RadButton>
                                    </td>
                                    <td>
                                        <asp:Label runat="server" ID="FileName1" Text='<%# Eval("FileName")%>'></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <%--                                <td width="22px" style="vertical-align: top;">
                                    <telerik:RadButton ID="btnUploadTemplate" ToolTip='<%# Resources.Resource.lblUploadTemplate%>' runat="server" CausesValidation="False" Visible="true" AutoPostBack="false"
                                    CommandName="UploadTemplate" OnClientClicked="uploadTemplate" Icon-PrimaryIconCssClass="rbUpload" ButtonType="ToggleButton" Width="22px">
                                    </telerik:RadButton>
                                    </td>--%>
                                    <td colspan="2">
                                        <telerik:RadAsyncUpload ID="AsyncUploadXLS" runat="server" OnClientFileUploaded="OnClientFileUploaded" MultipleFileSelection="Disabled" AutoAddFileInputs="true"
                                                                AllowedFileExtensions="xls,xlsx" MaxFileSize="2097152" OnFileUploaded="AsyncUpload1_FileUploaded" ManualUpload="false" Width="300px">
                                            <FileFilters>
                                                <telerik:FileFilter Extensions="xls,xlsx" Description="<%$ Resources:Resource, lblExcelFiles %>" />
                                            </FileFilters>
                                        </telerik:RadAsyncUpload>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>

                        <asp:Panel runat="server" ID="PanelServerReport" Visible="false">
                            <table cellpadding="3px">
                                <tr style="background-color:lightgrey">
                                    <td colspan="2">
                                        <asp:Label runat="server" ID="Label2" Text="<%$ Resources:Resource, lblExistingTemplates %>"></asp:Label>
                                    </td>
                                </tr>
                                <tr style="background-color:lightgrey">
                                    <td width="22px">
                                        <telerik:RadButton ID="btnEditTemplateRDL" ToolTip='<%# Resources.Resource.lblEditTemplate%>' runat="server" CausesValidation="False"
                                                           CommandName="EditTemplateRDL" OnClientClicked="gridCommand" Icon-PrimaryIconCssClass="rgEdit" ButtonType="ToggleButton" Width="22px">
                                        </telerik:RadButton>
                                    </td>
                                    <td>
                                        <telerik:RadComboBox runat="server" ID="FileName" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataValueField="FileName" DataTextField="FileName" 
                                                             AppendDataBoundItems="true" Filter="Contains" AllowCustomText="true" Width="270px"
                                                             DropDownAutoWidth="Enabled">
                                        </telerik:RadComboBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr style="background-color:lightgrey">
                                    <td colspan="2">
                                        <asp:Label runat="server" ID="Label1" Text="<%$ Resources:Resource, lblUploadTemplate %>"></asp:Label>
                                    </td>
                                </tr>
                                <tr style="background-color:lightgrey">
                                    <td colspan="2">
                                        <telerik:RadAsyncUpload ID="AsyncUploadRDL" runat="server" OnClientFileUploaded="OnClientFileUploaded" MultipleFileSelection="Disabled" AutoAddFileInputs="true"
                                                                AllowedFileExtensions="rdl" MaxFileSize="2097152" OnFileUploaded="AsyncUpload1_FileUploaded" ManualUpload="false" Width="300px">
                                            <FileFilters>
                                                <telerik:FileFilter Extensions="rdl" Description="<%$ Resources:Resource, lblRDLFiles %>" />
                                            </FileFilters>
                                        </telerik:RadAsyncUpload>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <asp:Panel runat="server" ID="PanelOfficeReport" Visible="true">
                            <telerik:RadAsyncUpload ID="AsyncUploadXLS" runat="server" OnClientFileUploaded="OnClientFileUploaded" MultipleFileSelection="Disabled"
                                                    AllowedFileExtensions="xls,xlsx" MaxFileSize="2097152" OnFileUploaded="AsyncUpload1_FileUploaded">
                                <FileFilters>
                                    <telerik:FileFilter Extensions="xls,xlsx" Description="<%$ Resources:Resource, lblExcelFiles %>" />
                                </FileFilters>
                            </telerik:RadAsyncUpload>
                        </asp:Panel>

                        <asp:Panel runat="server" ID="PanelServerReport" Visible="false">
                            <table>
                                <tr style="background-color:lightgrey">
                                    <td colspan="2">
                                        <asp:Label runat="server" ID="Label2" Text="<%$ Resources:Resource, lblExistingTemplates %>"></asp:Label>
                                    </td>
                                </tr>
                                <tr style="background-color:lightgrey">
                                    <td>
                                        <telerik:RadComboBox runat="server" ID="FileName" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataValueField="FileName" DataTextField="FileName" 
                                                             AppendDataBoundItems="true" Filter="Contains" AllowCustomText="true" Width="300px"
                                                             DropDownAutoWidth="Enabled">
                                        </telerik:RadComboBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr style="background-color:lightgrey">
                                    <td colspan="2">
                                        <asp:Label runat="server" ID="Label1" Text="<%$ Resources:Resource, lblUploadTemplate %>"></asp:Label>
                                    </td>
                                </tr>
                                <tr style="background-color:lightgrey">
                                    <td>
                                        <telerik:RadAsyncUpload ID="AsyncUploadRDL" runat="server" OnClientFileUploaded="OnClientFileUploaded" MultipleFileSelection="Disabled" AutoAddFileInputs="true"
                                                                AllowedFileExtensions="rdl" MaxFileSize="2097152" OnFileUploaded="AsyncUpload1_FileUploaded" ManualUpload="false" Width="300px">
                                            <FileFilters>
                                                <telerik:FileFilter Extensions="rdl" Description="<%$ Resources:Resource, lblRDLFiles %>" />
                                            </FileFilters>
                                        </telerik:RadAsyncUpload>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" ID="FileName" Text='<%# Eval("FileName")%>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="IsDefault" DefaultInsertValue="false" HeaderText="<%$ Resources:Resource, lblIsDefault %>" Visible="true" UniqueName="IsDefault" 
                                            ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:CheckBox runat="server" ID="IsDefault" Checked='<%# Eval("IsDefault")%>' Enabled="false"></asp:CheckBox>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:CheckBox runat="server" ID="IsDefault" Checked='<%# Eval("IsDefault")%>'></asp:CheckBox>
                    </EditItemTemplate>
                </telerik:GridTemplateColumn>

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

                <telerik:GridTemplateColumn DataField="EditOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditOn column" HeaderText="<%$ Resources:Resource, lblEditOn %>" SortExpression="EditOn" UniqueName="EditOn" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="EditOnLabel" runat="server" Text='<%# Eval("EditOn")%>'></asp:Label>
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

    <asp:SqlDataSource ID="SqlDataSource_Dialogs" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="WITH Dialogs AS ( SELECT m_tn1.SystemID, m_tn1.NodeID, NULL AS ParentID, m_tn1.NameVisible, m_tn1.ResourceID, m_tn1.DialogID, s_i.ImageName, s_i.ImagePath, CAST(ROW_NUMBER() OVER(PARTITION BY m_tn1.ParentID ORDER BY m_tn1.[Rank]) AS nvarchar(50)) AS TreeLevel, 1 AS IndentLevel FROM Master_TreeNodes AS m_tn1 INNER JOIN System_Images s_i ON m_tn1.SystemID = s_i.SystemID AND m_tn1.ImageID = s_i.ImageID WHERE m_tn1.SystemID = @SystemID AND m_tn1.ParentID IS NULL AND m_tn1.IsVisible = 1 AND m_tn1.IsValid = 1 UNION ALL SELECT m_tn2.SystemID, m_tn2.NodeID, m_tn2.ParentID, m_tn2.NameVisible, m_tn2.ResourceID, m_tn2.DialogID, s_i.ImageName, s_i.ImagePath, CAST(TreeLevel + ';' + CAST(ROW_NUMBER() OVER(PARTITION BY m_tn2.ParentID ORDER BY m_tn2.[Rank]) AS nvarchar(50)) AS nvarchar(50)) AS TreeLevel, IndentLevel + 1 AS IndentLevel FROM Master_TreeNodes m_tn2 INNER JOIN Dialogs ON Dialogs.SystemID = m_tn2.SystemID AND Dialogs.NodeID = m_tn2.ParentID INNER JOIN System_Images s_i ON m_tn2.SystemID = s_i.SystemID AND m_tn2.ImageID = s_i.ImageID WHERE m_tn2.IsVisible = 1 AND m_tn2.IsValid = 1 ) SELECT DISTINCT SystemID, NodeID, ParentID, NameVisible, ResourceID, DialogID, ImageName, ImagePath, TreeLevel, IndentLevel FROM Dialogs ORDER BY TreeLevel;">

        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_DialogsFilter" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT DISTINCT Master_TreeNodes.DialogID, Master_TreeNodes.NameVisible, Master_TreeNodes.ResourceID, System_Images.ImageName, System_Images.ImagePath
                       FROM Master_Templates INNER JOIN
                       Master_TreeNodes ON Master_Templates.SystemID = Master_TreeNodes.SystemID AND Master_Templates.DialogID = Master_TreeNodes.DialogID INNER JOIN
                       System_Images ON Master_TreeNodes.SystemID = System_Images.SystemID AND Master_TreeNodes.ImageID = System_Images.ImageID
                       WHERE (Master_Templates.SystemID = @SystemID) AND (Master_Templates.BpID = @BpID) 
                       UNION 
                       SELECT NULL AS DialogID, '' AS NameVisible, 'lblAll' AS ResourceID, '' AS ImageName, '' AS ImagePath ORDER BY NameVisible">

        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
