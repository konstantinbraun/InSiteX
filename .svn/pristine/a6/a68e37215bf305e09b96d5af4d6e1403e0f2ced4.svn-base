<%@ Page Title="<%$ Resources:Resource, lblRelevantDocuments %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RelevantDocuments.aspx.cs" Inherits="InSite.App.Views.Configuration.RelevantDocuments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
        <script type="text/javascript">
            var uploadedFilesCount = 0;
            var isEditMode;
            function validateRadUpload(source, e) {
                // When the RadGrid is in Edit mode the user is not obliged to upload file.
                if (isEditMode === null || isEditMode === undefined) {
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
        </script>
    </telerik:RadCodeBlock>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">

    <telerik:RadPersistenceManagerProxy ID="RadPersistenceManagerProxy1" runat="server" >
        <PersistenceSettings>
            <telerik:PersistenceSetting ControlID="RadGrid1" />
        </PersistenceSettings>
    </telerik:RadPersistenceManagerProxy>

    <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGrid1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                    <telerik:AjaxUpdatedControl ControlID="RadToolTipManager1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadTabStrip1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadTabStrip1" />
                    <telerik:AjaxUpdatedControl ControlID="RadMultiPage1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadMultiPage1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadMultiPage1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadGrid2">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid2" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadGrid3">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid3" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <telerik:RadGrid ID="RadGrid1" runat="server" OnItemInserted="RadGrid1_ItemInserted" AllowSorting="true"
                     AllowAutomaticDeletes="True" EnableHierarchyExpandAll="true" GroupPanelPosition="BeforeHeader"
                     AllowPaging="true" ShowGroupPanel="True" CssClass="MainGrid" DataSourceID="SqlDataSource_RelevantDocuments"
                     OnItemCommand="RadGrid1_ItemCommand" OnInsertCommand="RadGrid1_InsertCommand" OnPreRender="RadGrid1_PreRender"
                     OnItemDeleted="RadGrid1_ItemDeleted" OnDeleteCommand="RadGrid1_DeleteCommand" OnUpdateCommand="RadGrid1_UpdateCommand"
                     OnItemDataBound="RadGrid1_ItemDataBound" OnItemUpdated="RadGrid1_ItemUpdated" OnItemCreated="RadGrid1_ItemCreated"
                     OnGroupsChanging="RadGrid1_GroupsChanging" OnPageIndexChanged="RadGrid1_PageIndexChanged" OnPageSizeChanged="RadGrid1_PageSizeChanged">

        <ExportSettings ExportOnlyData="True" IgnorePaging="True">
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

        <MasterTableView AutoGenerateColumns="False" DataKeyNames="SystemID,BpID,RelevantDocumentID" CommandItemDisplay="Top" EditMode="PopUp" DataSourceID="SqlDataSource_RelevantDocuments"
                         HierarchyLoadMode="ServerOnDemand" GroupLoadMode="Server" Name="RelevantDocuments" AllowPaging="true" PageSize="7" CssClass="MasterClass">

            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" PageSizes="7,15,30" />

            <SortExpressions>
                <telerik:GridSortExpression FieldName="NameVisible" SortOrder="Ascending"></telerik:GridSortExpression>
            </SortExpressions>

            <GroupByExpressions>
                <telerik:GridGroupByExpression>
                    <SelectFields>
                        <telerik:GridGroupByField FieldAlias="RelevantFor" FieldName="RelevantFor" HeaderText="<%$ Resources:Resource, lblRelevantFor %>"></telerik:GridGroupByField>
                    </SelectFields>
                    <GroupByFields>
                        <telerik:GridGroupByField FieldName="RelevantFor" HeaderText="<%$ Resources:Resource, lblRelevantFor %>"></telerik:GridGroupByField>
                    </GroupByFields>
                </telerik:GridGroupByExpression>
            </GroupByExpressions>

            <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="False" ShowExportToExcelButton="True" ShowExportToPdfButton="False"
                                 AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

            <Columns>
                <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                               UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                    <ItemStyle BackColor="Control" Width="30px" />
                    <HeaderStyle Width="30px" />
                </telerik:GridEditCommandColumn>

                <telerik:GridTemplateColumn DataField="SampleData" HeaderText="<%$ Resources:Resource, lblSample %>" UniqueName="SampleData" HeaderStyle-Width="80px" ItemStyle-Width="80px">
                    <ItemTemplate>
                        <telerik:RadBinaryImage runat="server" ID="SampleData" ToolTip='<%#Eval("NameVisible", "Beispiel für {0}")%>' CssClass="RoundedCorners ThinBorder Shadow"
                                                AlternateText='<%#Eval("SampleFileName", "Image of {0}")%>' ResizeMode="Fit" VisibleWithoutSource="false" CropPosition="Left"
                                                AutoAdjustImageControlSize="true" Height="60px" Width="60px"></telerik:RadBinaryImage>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="RelevantDocumentID" Visible="false" DataType="System.Int32" FilterControlAltText="Filter RelevantDocumentID column" HeaderText="<%$ Resources:Resource, lblID %>"
                                            SortExpression="RelevantDocumentID" UniqueName="RelevantDocumentID" GroupByExpression="RelevantDocumentID RelevantDocumentID GROUP BY RelevantDocumentID">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="LabelRelevantDocumentID" Text='<%# Eval("RelevantDocumentID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="NameVisible" HeaderText="<%$ Resources:Resource, lblNameVisible %>" SortExpression="NameVisible" UniqueName="NameVisible"
                                            GroupByExpression="NameVisible NameVisible GROUP BY NameVisible">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="NameVisible" Text='<%# Eval("NameVisible") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="DescriptionShort" FilterControlAltText="Filter DescriptionShort column" HeaderText="<%$ Resources:Resource, lblDescriptionShort %>"
                                            SortExpression="DescriptionShort" UniqueName="DescriptionShort" GroupByExpression="DescriptionShort DescriptionShort GROUP BY DescriptionShort">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="LabelDescriptionShort" Text='<%# Eval("DescriptionShort") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="RelevantFor" DataType="System.Int16" FilterControlAltText="Filter RelevantFor column"
                                            HeaderText="<%$ Resources:Resource, lblRelevantFor %>" SortExpression="RelevantFor" UniqueName="RelevantFor"
                                            GroupByExpression="RelevantFor RelevantFor GROUP BY RelevantFor">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="LabelRelevantFor" Text='<%# GetRelevantFor(Convert.ToInt16(Eval("RelevantFor"))) %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridCheckBoxColumn DataField="IsAccessRelevant" DataType="System.Boolean" Visible="false" FilterControlAltText="Filter IsAccessRelevant column" DefaultInsertValue="true"
                                            HeaderText="<%$ Resources:Resource, lblExpirationDateIsAccessRelevant %>" SortExpression="IsAccessRelevant" UniqueName="IsAccessRelevant" ForceExtractValue="Always">
                </telerik:GridCheckBoxColumn>

                <telerik:GridCheckBoxColumn DataField="RecExpirationDate" DataType="System.Boolean" Visible="false" FilterControlAltText="Filter RecExpirationDate column" DefaultInsertValue="true"
                                            HeaderText="<%$ Resources:Resource, lblRecExpirationDate %>" SortExpression="RecExpirationDate" UniqueName="RecExpirationDate" ForceExtractValue="Always">
                </telerik:GridCheckBoxColumn>

                <telerik:GridCheckBoxColumn DataField="RecIDNumber" DataType="System.Boolean" Visible="false" FilterControlAltText="Filter RecIDNumber column" DefaultInsertValue="true"
                                            HeaderText="<%$ Resources:Resource, lblRecIDNumber %>" SortExpression="RecIDNumber" UniqueName="RecIDNumber" ForceExtractValue="Always">
                </telerik:GridCheckBoxColumn>

                <telerik:GridTemplateColumn DataField="SampleFileName" Visible="false" FilterControlAltText="Filter SampleFileName column" HeaderText="<%$ Resources:Resource, lblFileName %>"
                                            SortExpression="SampleFileName" UniqueName="SampleFileName" GroupByExpression="SampleFileName SampleFileName GROUP BY SampleFileName">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="LabelSampleFileName" Text='<%# Eval("SampleFileName") %>'></asp:Label>
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

            <NestedViewTemplate>
                <fieldset style="padding: 10px; width: 500px; margin-left: 10px; margin-bottom: 10px;">
                    <legend style="padding: 5px; background-color: transparent;">
                        <b><%= Resources.Resource.lblDetailsFor %> <%#Eval("NameVisible") %></b>
                    </legend>
                    <table style="width: 100%;">
                        <tr>
                            <td><%= Resources.Resource.lblID %>: </td>
                            <td>
                                <asp:Label ID="RelevantDocumentID" Text='<%#Eval("RelevantDocumentID") %>' runat="server"></asp:Label>
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
                            <td><%= Resources.Resource.lblExpirationDateIsAccessRelevant %>: </td>
                            <td>
                                <asp:CheckBox Checked='<%#Eval("IsAccessRelevant") %>' runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td><%= Resources.Resource.lblRecExpirationDate %>: </td>
                            <td>
                                <asp:CheckBox Checked='<%#Eval("RecExpirationDate") %>' runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td><%= Resources.Resource.lblRecIDNumber %>: </td>
                            <td>
                                <asp:CheckBox Checked='<%#Eval("RecIDNumber") %>' runat="server" />
                            </td>
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

            <EditFormSettings EditFormType="Template" CaptionDataField="NameVisible" CaptionFormatString="<%$ Resources:Resource, lblRelevantDocuments %>">
                <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                <FormTemplate>
                    <telerik:RadTabStrip ID="RadTabStrip1" runat="server" MultiPageID="RadMultiPage1" Align="Left" AutoPostBack="true" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'>
                        <Tabs>
                            <telerik:RadTab PageViewID="RadPageView1" Text="<%# Resources.Resource.lblDetails %>" Selected="true" Font-Bold="true" Value="1" />
                            <telerik:RadTab PageViewID="RadPageView2" Text="<%# Resources.Resource.lblExpirationDateHints %>" Font-Bold="true" Value="2" />
                            <telerik:RadTab PageViewID="RadPageView3" Text="<%# Resources.Resource.lblIDNumberHint %>" Font-Bold="true" Value="3" />
                        </Tabs>
                    </telerik:RadTabStrip>
                    <telerik:RadMultiPage ID="RadMultiPage1" runat="server" RenderSelectedPageOnly="true">
                        <telerik:RadPageView ID="RadPageView1" runat="server" Selected="true">
                            <table id="Table2" cellspacing="5" cellpadding="5" border="0" rules="none" class="EditFormTable">
                                <tr>
                                    <td style="vertical-align: top;">
                                        <table id="Table3" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label1" Text='<%# String.Concat(Resources.Resource.lblID, ":") %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelRelevantDocumentID" Text='<%# Eval("RelevantDocumentID") %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <%# Resources.Resource.lblRelevantFor %>:
                                                </td>
                                                <td>
                                                    <telerik:RadDropDownList ID="RadDropDownList_RelevantFor" runat="server" SelectedValue='<%# Bind("RelevantFor") %>'>
                                                        <Items>
                                                            <telerik:DropDownListItem runat="server" Selected="True" Text="<%$ Resources:Resource, selRDNone %>" Value="0" />
                                                            <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selRDLaborRight %>" Value="1" />
                                                            <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selRDResidenceRight %>" Value="2" />
                                                            <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selRDLegitimation %>" Value="3" />
                                                            <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selRDInsurance %>" Value="4" />
                                                            <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selRDInsuranceAdditional %>" Value="5" />
                                                        </Items>
                                                    </telerik:RadDropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <%# Resources.Resource.lblNameVisible %>:
                                                </td>
                                                <td>
                                                    <telerik:RadTextBox runat="server" ID="NameVisible" Text='<%# Bind("NameVisible") %>'></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <%# Resources.Resource.lblDescriptionShort %>:
                                                </td>
                                                <td>
                                                    <telerik:RadTextBox runat="server" ID="DescriptionShort" Text='<%# Bind("DescriptionShort") %>' Width="300px"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <%# Resources.Resource.lblExpirationDateIsAccessRelevant %>:
                                                </td>
                                                <td>
                                                    <asp:CheckBox runat="server" ID="IsAccessRelevant" Checked='<%# Bind("IsAccessRelevant") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <%# Resources.Resource.lblRecExpirationDate %>:
                                                </td>
                                                <td>
                                                    <asp:CheckBox runat="server" ID="RecExpirationDate" Checked='<%# Bind("RecExpirationDate") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <%# Resources.Resource.lblRecIDNumber %>:
                                                </td>
                                                <td>
                                                    <asp:CheckBox runat="server" ID="RecIDNumber" Checked='<%# Bind("RecIDNumber") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp; </td>
                                                <td>&nbsp; </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblCreatedFrom, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblCreatedOn, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("CreatedOn") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblEditFrom, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("EditFrom")%>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblEditOn, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("EditOn")%>'></asp:Label>
                                                </td>
                                            </tr>

                                        </table>
                                    </td>
                                    <td style="vertical-align: top;">
                                        <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px;">
                                            <table id="Table1" cellspacing="2" cellpadding="2" border="0" class="module">
                                                <tr>
                                                    <td>
                                                        <%# Resources.Resource.lblSampleDocImage%>:
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp; </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <telerik:RadBinaryImage Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' runat="server" ID="SampleData"
                                                                                AutoAdjustImageControlSize="false" Height="200px" ToolTip='<%#Eval("NameVisible", "Beispiel für {0}")%>'
                                                                                AlternateText='<%#Eval("SampleFileName", "Image of {0}")%>'></telerik:RadBinaryImage>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' runat="server" ID="SampleFileName"
                                                                   Text='<%# Eval("SampleFileName")%>'></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <telerik:RadAsyncUpload runat="server" ID="AsyncUpload1" OnClientFileUploaded="OnClientFileUploaded"
                                                                                AllowedFileExtensions="jpg,jpeg,png,gif" MaxFileSize="2097152" MultipleFileSelection="Disabled">
                                                            <Localization Select="<%$ Resources:Resource, lblActionSelect %>" Cancel="<%$ Resources:Resource, lblActionCancel %>"
                                                                          Remove="<%$ Resources:Resource, lblActionDelete %>" />
                                                        </telerik:RadAsyncUpload>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="2">
                                        <telerik:RadButton ID="btnUpdate" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionUpdate%>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update"%>' Icon-PrimaryIconCssClass="rbOk"></telerik:RadButton>
                                        <telerik:RadButton ID="btnCancel" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                           CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel"></telerik:RadButton>
                                    </td>
                                </tr>
                            </table>
                        </telerik:RadPageView>

                        <telerik:RadPageView ID="RadPageView2" runat="server">
                            <div>
                                <telerik:RadGrid runat="server" ID="RadGrid2" AutoGenerateColumns="false" OnItemUpdated="RadGrid2_ItemUpdated" OnPreRender="RadGrid2_PreRender"
                                                 AllowAutomaticUpdates="True" OnItemCreated="RadGrid2_ItemCreated">
        <SortingSettings SortedBackColor="Transparent" />

                                    <MasterTableView runat="server" DataSourceID="SqlDataSource_Translations1" EditMode="InPlace" ShowFooter="true"
                                                     DataKeyNames="SystemID,BpID,DialogID,FieldID,ForeignID,LanguageID">

                                        <EditFormSettings CaptionDataField="LanguageName" CaptionFormatString="{0}">
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

                                            <telerik:GridBoundColumn DataField="ForeignID" UniqueName="ForeignID" Visible="false" ReadOnly="true">
                                            </telerik:GridBoundColumn>

                                            <telerik:GridImageColumn DataImageUrlFields="FlagName" DataImageUrlFormatString="~/Resources/Icons/Flags/{0}" HeaderStyle-Width="50px"></telerik:GridImageColumn>

                                            <telerik:GridTemplateColumn DataField="LanguageName" HeaderText="<%$ Resources:Resource, lblLanguage %>" SortExpression="LanguageName" UniqueName="LanguageName"
                                                                        GroupByExpression="LanguageName LanguageName GROUP BY LanguageName">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="LanguageName" Text='<%# Eval("LanguageName") %>'></asp:Label>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>

                                            <telerik:GridTemplateColumn DataField="DescriptionTranslated" HeaderText="<%$ Resources:Resource, lblDescriptionShort %>" SortExpression="DescriptionTranslated" UniqueName="DescriptionTranslated"
                                                                        GroupByExpression="DescriptionTranslated DescriptionTranslated GROUP BY DescriptionTranslated">
                                                <EditItemTemplate>
                                                    <telerik:RadTextBox runat="server" ID="DescriptionTranslated" Text='<%# Bind("DescriptionTranslated") %>' Width="500px"></telerik:RadTextBox>
                                                </EditItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="DescriptionTranslated" Text='<%# Eval("DescriptionTranslated") %>' Width="500px"></asp:Label>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                        </Columns>
                                    </MasterTableView>
                                </telerik:RadGrid>
                            </div>
                        </telerik:RadPageView>

                        <telerik:RadPageView ID="RadPageView3" runat="server">
                            <div>
                                <telerik:RadGrid runat="server" ID="RadGrid3" AutoGenerateColumns="false" OnItemUpdated="RadGrid3_ItemUpdated" OnPreRender="RadGrid3_PreRender"
                                                 AllowAutomaticUpdates="True" OnItemCommand="RadGrid3_ItemCommand" OnItemCreated="RadGrid3_ItemCreated">
        <SortingSettings SortedBackColor="Transparent" />

                                    <MasterTableView runat="server" DataSourceID="SqlDataSource_Translations2" EditMode="InPlace" ShowFooter="true"
                                                     DataKeyNames="SystemID,BpID,DialogID,FieldID,ForeignID,LanguageID">

                                        <EditFormSettings CaptionDataField="LanguageName" CaptionFormatString="{0}">
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

                                            <telerik:GridBoundColumn DataField="ForeignID" UniqueName="ForeignID" Visible="false" ReadOnly="true">
                                            </telerik:GridBoundColumn>

                                            <telerik:GridImageColumn DataImageUrlFields="FlagName" DataImageUrlFormatString="~/Resources/Icons/Flags/{0}" HeaderStyle-Width="50px"></telerik:GridImageColumn>

                                            <telerik:GridTemplateColumn DataField="LanguageName" HeaderText="<%$ Resources:Resource, lblLanguage %>" SortExpression="LanguageName" UniqueName="LanguageName"
                                                                        GroupByExpression="LanguageName LanguageName GROUP BY LanguageName">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="LanguageName" Text='<%# Eval("LanguageName") %>'></asp:Label>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>

                                            <telerik:GridTemplateColumn DataField="DescriptionTranslated" HeaderText="<%$ Resources:Resource, lblDescriptionShort %>" SortExpression="DescriptionTranslated" UniqueName="DescriptionTranslated"
                                                                        GroupByExpression="DescriptionTranslated DescriptionTranslated GROUP BY DescriptionTranslated">
                                                <EditItemTemplate>
                                                    <telerik:RadTextBox runat="server" ID="DescriptionTranslated" Text='<%# Bind("DescriptionTranslated") %>' Width="500px"></telerik:RadTextBox>
                                                </EditItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="DescriptionTranslated" Text='<%# Eval("DescriptionTranslated") %>' Width="500px"></asp:Label>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                        </Columns>
                                    </MasterTableView>
                                </telerik:RadGrid>
                            </div>
                        </telerik:RadPageView>

                    </telerik:RadMultiPage>
                </FormTemplate>
            </EditFormSettings>
        </MasterTableView>

    </telerik:RadGrid>

    <telerik:RadToolTipManager ID="RadToolTipManager1" OffsetY="-1" HideEvent="LeaveToolTip" runat="server" OnAjaxUpdate="OnAjaxUpdate" EnableEmbeddedSkins="true"
                               RelativeTo="Element" Position="MiddleRight" EnableRoundedCorners="true" AutoTooltipify="false" EnableShadow="true" ShowCallout="true">
    </telerik:RadToolTipManager>

    <asp:SqlDataSource ID="SqlDataSource_RelevantDocuments" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT SystemID, BpID, RelevantDocumentID, RelevantFor, NameVisible, DescriptionShort, IsAccessRelevant, RecExpirationDate, RecIDNumber, SampleFileName, CreatedFrom, CreatedOn, EditFrom, EditOn FROM Master_RelevantDocuments WHERE (SystemID = @SystemID) AND (BpID = @BpID) ORDER BY NameVisible">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Translations1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       OldValuesParameterFormatString="original_{0}"
                       SelectCommand="SELECT Master_Translations.SystemID, Master_Translations.BpID, Master_Translations.DialogID, Master_Translations.FieldID,  Master_Translations.ForeignID, Master_Translations.LanguageID, Master_Translations.NameTranslated, Master_Translations.DescriptionTranslated, Master_Translations.CreatedFrom, Master_Translations.CreatedOn, Master_Translations.EditFrom, Master_Translations.EditOn, View_Languages.LanguageName, View_Languages.FlagName FROM Master_Translations INNER JOIN Master_AllowedLanguages ON Master_Translations.SystemID = Master_AllowedLanguages.SystemID AND Master_Translations.BpID = Master_AllowedLanguages.BpID AND Master_Translations.LanguageID = Master_AllowedLanguages.LanguageID INNER JOIN View_Languages ON Master_AllowedLanguages.LanguageID = View_Languages.LanguageID WHERE (Master_Translations.SystemID = @SystemID) AND (Master_Translations.BpID = @BpID) AND (Master_Translations.DialogID = @DialogID) AND (Master_Translations.FieldID = @FieldID) AND (Master_Translations.ForeignID = @ForeignID) ORDER BY Master_Translations.LanguageID"
                       UpdateCommand="UPDATE Master_Translations SET DescriptionTranslated = @DescriptionTranslated, EditFrom = @UserName, EditOn = SYSDATETIME() WHERE (SystemID = @original_SystemID) AND (BpID = @original_BpID) AND (DialogID = @original_DialogID) AND (FieldID = @original_FieldID) AND (ForeignID = @original_ForeignID) AND (LanguageID = @original_LanguageID)">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
            <asp:Parameter Name="DialogID" DefaultValue="6" Type="Int32" />
            <asp:Parameter Name="FieldID" DefaultValue="13" Type="Int32" />
            <asp:Parameter Name="ForeignID" DefaultValue="1" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="DescriptionTranslated" Type="String" />
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
            <asp:Parameter Name="original_SystemID" Type="Int32" />
            <asp:Parameter Name="original_BpID" Type="Int32" />
            <asp:Parameter Name="original_DialogID" Type="Int32" />
            <asp:Parameter Name="original_FieldID" Type="Int32" />
            <asp:Parameter Name="original_ForeignID" Type="Int32" />
            <asp:Parameter Name="original_LanguageID" Type="String" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Translations2" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       OldValuesParameterFormatString="original_{0}"
                       SelectCommand="SELECT Master_Translations.SystemID, Master_Translations.BpID, Master_Translations.DialogID, Master_Translations.FieldID, Master_Translations.ForeignID, Master_Translations.LanguageID, Master_Translations.NameTranslated, Master_Translations.DescriptionTranslated, Master_Translations.CreatedFrom, Master_Translations.CreatedOn, Master_Translations.EditFrom, Master_Translations.EditOn, View_Languages.LanguageName, View_Languages.FlagName FROM Master_Translations INNER JOIN Master_AllowedLanguages ON Master_Translations.SystemID = Master_AllowedLanguages.SystemID AND Master_Translations.BpID = Master_AllowedLanguages.BpID AND Master_Translations.LanguageID = Master_AllowedLanguages.LanguageID INNER JOIN View_Languages ON Master_AllowedLanguages.LanguageID = View_Languages.LanguageID WHERE (Master_Translations.SystemID = @SystemID) AND (Master_Translations.BpID = @BpID) AND (Master_Translations.DialogID = @DialogID) AND (Master_Translations.FieldID = @FieldID) AND (Master_Translations.ForeignID = @ForeignID) ORDER BY Master_Translations.LanguageID"
                       UpdateCommand="UPDATE Master_Translations SET DescriptionTranslated = @DescriptionTranslated, EditFrom = @UserName, EditOn = SYSDATETIME() WHERE (SystemID = @original_SystemID) AND (BpID = @original_BpID) AND (DialogID = @original_DialogID) AND (FieldID = @original_FieldID) AND (ForeignID = @original_ForeignID) AND (LanguageID = @original_LanguageID)">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
            <asp:Parameter Name="DialogID" DefaultValue="6" Type="Int32" />
            <asp:Parameter Name="FieldID" DefaultValue="14" Type="Int32" />
            <asp:Parameter Name="ForeignID" DefaultValue="1" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="DescriptionTranslated" Type="String" />
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
            <asp:Parameter Name="original_SystemID" Type="Int32" />
            <asp:Parameter Name="original_BpID" Type="Int32" />
            <asp:Parameter Name="original_DialogID" Type="Int32" />
            <asp:Parameter Name="original_FieldID" Type="Int32" />
            <asp:Parameter Name="original_ForeignID" Type="Int32" />
            <asp:Parameter Name="original_LanguageID" Type="String" />
        </UpdateParameters>
    </asp:SqlDataSource>

</asp:Content>
