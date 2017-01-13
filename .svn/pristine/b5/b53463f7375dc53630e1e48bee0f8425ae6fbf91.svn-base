<%@ Page Title="<%$ Resources:Resource, lblMailBox %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MailBox.aspx.cs" Inherits="InSite.App.Views.MailBox.MailBox" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <telerik:RadCodeBlock ID="RadCodeBlock2" runat="server">
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

    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
        <script type="text/javascript">
            function gridCommand(sender, args) {
                if (args.get_commandName() === "DocDownloadCmd") {
                    var manager = $find('<%= RadAjaxManager.GetCurrent(Page).ClientID %>');
                    document.body.style.cursor = "wait";
                    manager.set_enableAJAX(false);
            
                    setTimeout(function () {
                        manager.set_enableAJAX(true);
                        document.body.style.cursor = "default";
                    }, 3000);
                }
            }
        </script>
    </telerik:RadCodeBlock>

    <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGrid1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="PanelDetails">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="PanelDetails" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <telerik:RadGrid ID="RadGrid1" runat="server" DataSourceID="SqlDataSource_Mailbox" AllowAutomaticDeletes="true" AllowFilteringByColumn="true"
                     AllowPaging="true" EnableHeaderContextFilterMenu="True" EnableHeaderContextMenu="True" AllowMultiRowSelection="true" CssClass="MainGrid"
                     OnItemInserted="RadGrid1_ItemInserted" OnItemDeleted="RadGrid1_ItemDeleted" OnPreRender="RadGrid1_PreRender" OnItemUpdated="RadGrid1_ItemUpdated"
                     OnItemCommand="RadGrid1_ItemCommand" OnInsertCommand="RadGrid1_InsertCommand" OnItemDataBound="RadGrid1_ItemDataBound" OnItemCreated="RadGrid1_ItemCreated">

        <ExportSettings ExportOnlyData="true" IgnorePaging="true">
            <Pdf PaperSize="A4">
            </Pdf>
            <Excel Format="ExcelML" />
        </ExportSettings>

        <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false">
            <Resizing AllowColumnResize="true"></Resizing>
            <Selecting AllowRowSelect="True" />
            <ClientEvents OnRowClick="OnRowClick" OnCommand="gridCommand" OnKeyPress="GridKeyPress" />
        </ClientSettings>

        <SortingSettings SortedBackColor="Transparent" />

        <MasterTableView AutoGenerateColumns="False" DataKeyNames="ID" CommandItemDisplay="Top" EditMode="PopUp" DataSourceID="SqlDataSource_Mailbox" 
                         ItemStyle-VerticalAlign="Top" AlternatingItemStyle-VerticalAlign="Top" AllowSorting="true" CssClass="MasterClass" HierarchyLoadMode="ServerOnDemand" 
                         FilterItemStyle-VerticalAlign="Bottom">

            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

            <SortExpressions>
                <telerik:GridSortExpression FieldName="MailCreated" SortOrder="Descending"></telerik:GridSortExpression>
            </SortExpressions>

            <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="false" ShowExportToExcelButton="false" ShowExportToPdfButton="false"
                                 AddNewRecordText="<%$ Resources:Resource, lblEmailNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" 
                                 AddNewRecordImageUrl="../../Resources/Icons/mail-message-new-4.png" />

            <CommandItemTemplate>
                <div style="margin: 3px; height: 20px;">
                    <telerik:RadButton ID="AddNewRecord" runat="server" CommandName="InitInsert" Visible="true" Text='<%# Resources.Resource.lblEmailNew %>' 
                                       ButtonType="SkinnedButton" BorderStyle="None" BackColor="Transparent">
                        <Icon PrimaryIconUrl="../../Resources/Icons/mail-message-new_16.png" PrimaryIconHeight="16px" PrimaryIconWidth="16px" />
                    </telerik:RadButton>

                    <telerik:RadButton ID="MarkReadSelected" runat="server" CommandName="MarkReadSelected" Visible="true" Text='<%# Resources.Resource.lblEmailMarkRead %>' 
                                       ButtonType="SkinnedButton" BorderStyle="None" BackColor="Transparent">
                        <Icon PrimaryIconUrl="../../Resources/Icons/mail-read-2_16.png" PrimaryIconHeight="16px" PrimaryIconWidth="16px" />
                    </telerik:RadButton>

                    <telerik:RadButton ID="MarkUnreadSelected" runat="server" CommandName="MarkUnreadSelected" Visible="true" Text='<%# Resources.Resource.lblEmailMarkUnread %>' 
                                       ButtonType="SkinnedButton" BorderStyle="None" BackColor="Transparent">
                        <Icon PrimaryIconUrl="../../Resources/Icons/mail-unread-new_16.png" PrimaryIconHeight="16px" PrimaryIconWidth="16px" />
                    </telerik:RadButton>

                    <telerik:RadButton ID="DeleteSelected" runat="server" CommandName="DeleteSelected" Visible="true" Text='<%# Resources.Resource.lblActionDelete %>' 
                                       ButtonType="SkinnedButton" BorderStyle="None" BackColor="Transparent">
                        <Icon PrimaryIconCssClass="rbCancel" />
                    </telerik:RadButton>

                    <telerik:RadButton ID="btnRefresh" runat="server" CommandName="RebindGrid" Text='<%# Resources.Resource.lblActionRefresh %>' 
                                       Icon-PrimaryIconCssClass="rbRefresh" ButtonType="SkinnedButton" BorderStyle="None" CssClass="FloatRight" BackColor="Transparent"></telerik:RadButton>

                    <div class="vertical-line"></div>

                    <telerik:RadButton ID="btnExportCsv" runat="server" Text="" ToolTip='<%# Resources.Resource.lblExportToCsv %>' CssClass="rgExpCSV FloatRight" CommandName="ExportToCSV" 
                                       ButtonType="LinkButton" Visible="false" BackColor="Transparent">
                        <Icon PrimaryIconUrl="../../Resources/Icons/export_xlsx_16.png" />
                    </telerik:RadButton>
                    &nbsp;&nbsp;

                    <telerik:RadButton ID="btnExportExcel" runat="server" Text="" ToolTip='<%# Resources.Resource.lblExportToExcel %>' CssClass="rgExpXLS FloatRight" CommandName="ExportToExcel"
                                       ButtonType="SkinnedButton" Visible="true" BorderStyle="None" BackColor="Transparent" Width="25px" Height="20px">
                        <Icon PrimaryIconUrl="../../Resources/Icons/export_xlsx_16.png" />
                    </telerik:RadButton>
                    &nbsp;&nbsp;

                    <telerik:RadButton ID="btnExportPdf" runat="server" Text="" ToolTip='<%# Resources.Resource.lblExportToPdf %>' CssClass="rgExpPDF FloatRight" CommandName="ExportToPdf" 
                                       ButtonType="LinkButton" Visible="false" BackColor="Transparent">
                        <Icon PrimaryIconUrl="../../Resources/Icons/export_pdf_16.png" />
                    </telerik:RadButton>
                </div>
            </CommandItemTemplate>

            <%--#################################################################################### Edit Template ########################################################################################################--%>
            <EditFormSettings EditFormType="Template" CaptionDataField="Subject" CaptionFormatString="{0}">
                <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                <FormTemplate>
                    <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                        <table cellspacing="3px" cellpadding="3px">
                            <tr>
                                <td>
                                    <asp:Label runat="server" Text='<%# Resources.Resource.lblEmailTo + ":" %>'></asp:Label>
                                </td>
                                <td>
                                    <telerik:RadAutoCompleteBox runat="server" ID="UserID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataValueField="UserID"
                                                                DataSourceID="SqlDataSource_Users" DataTextField="UserName" InputType="Token" Width="632px" ShowLoadingIcon="true" Filter="Contains" 
                                                                HighlightFirstMatch="true" AllowCustomEntry="true">
                                        <DropDownItemTemplate>
                                            <table cellpadding="0px" style="text-align: left;">
                                                <tr>
                                                    <td style="text-align: left;">
                                                        <asp:Label Text='<%# String.Concat(DataBinder.Eval(Container.DataItem, "LastName"), ", ") %>' runat="server">
                                                        </asp:Label>
                                                    </td>
                                                    <td style="text-align: left;">
                                                        <asp:Label Text='<%# String.Concat(DataBinder.Eval(Container.DataItem, "FirstName"), ", ") %>' runat="server" ForeColor="Gray">
                                                        </asp:Label>
                                                    </td>
                                                    <td style="text-align: left;">
                                                        <asp:Label Text='<%# String.Concat(DataBinder.Eval(Container.DataItem, "Company"), ", ") %>' runat="server">
                                                        </asp:Label>
                                                    </td>
                                                    <td style="text-align: left;">
                                                        <asp:Label Text='<%# DataBinder.Eval(Container.DataItem, "LoginName") %>' runat="server">
                                                        </asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </DropDownItemTemplate>
                                    </telerik:RadAutoCompleteBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label runat="server" Text='<%# Resources.Resource.lblSubject + ":" %>'></asp:Label>
                                </td>
                                <td>
                                    <telerik:RadTextBox runat="server" ID="Subject" Text='<%# Bind("Subject") %>' Width="632px"></telerik:RadTextBox>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top">
                                    <asp:Label runat="server" Text='<%# Resources.Resource.lblAttachments + ":" %>'></asp:Label>
                                </td>
                                <td>
                                    <telerik:RadAsyncUpload ID="AsyncUploadAttachments" runat="server" OnClientFileUploaded="OnClientFileUploaded" MultipleFileSelection="Automatic" 
                                                            AutoAddFileInputs="true" MaxFileSize="2097152" OnFileUploaded="AsyncUploadAttachments_FileUploaded" 
                                                            ManualUpload="false" HideFileInput="true" AllowedFileExtensions=".jpeg,.jpg,.png,.doc,.docx,.xls,.xlsx,.pdf">
                                    </telerik:RadAsyncUpload>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:Label runat="server" Text='<%# Resources.Resource.lblText + ":" %>'></asp:Label>
                                    <telerik:RadEditor runat="server" ID="Body" Content='<%# Bind("Body") %>'>
                                        <Tools>
                                            <telerik:EditorToolGroup Tag="MainToolbar">
                                                <telerik:EditorTool Name="FindAndReplace"></telerik:EditorTool>
                                                <telerik:EditorSeparator></telerik:EditorSeparator>
                                                <telerik:EditorSplitButton Name="Undo"></telerik:EditorSplitButton>
                                                <telerik:EditorSplitButton Name="Redo"></telerik:EditorSplitButton>
                                                <telerik:EditorTool Name="SelectAll" ShortCut="CTRL+A / CMD+A"></telerik:EditorTool>
                                                <telerik:EditorTool Name="Cut" ShortCut="CTRL+X / CMD+X"></telerik:EditorTool>
                                                <telerik:EditorTool Name="Copy" ShortCut="CTRL+C / CMD+C"></telerik:EditorTool>
                                            </telerik:EditorToolGroup>
                                            <telerik:EditorToolGroup Tag="Formatting">
                                                <telerik:EditorTool Name="Bold"></telerik:EditorTool>
                                                <telerik:EditorTool Name="Italic"></telerik:EditorTool>
                                                <telerik:EditorTool Name="Underline"></telerik:EditorTool>
                                                <telerik:EditorTool Name="StrikeThrough"></telerik:EditorTool>
                                                <telerik:EditorSeparator></telerik:EditorSeparator>
                                                <telerik:EditorSplitButton Name="ForeColor"></telerik:EditorSplitButton>
                                                <telerik:EditorSplitButton Name="BackColor"></telerik:EditorSplitButton>
                                                <telerik:EditorSeparator></telerik:EditorSeparator>
                                                <telerik:EditorDropDown Name="FontName"></telerik:EditorDropDown>
                                                <telerik:EditorDropDown Name="RealFontSize"></telerik:EditorDropDown>
                                                <telerik:EditorSeparator></telerik:EditorSeparator>
                                                <telerik:EditorTool Name="JustifyLeft"></telerik:EditorTool>
                                                <telerik:EditorTool Name="JustifyCenter"></telerik:EditorTool>
                                                <telerik:EditorTool Name="JustifyRight"></telerik:EditorTool>
                                                <telerik:EditorTool Name="JustifyFull"></telerik:EditorTool>
                                                <telerik:EditorTool Name="JustifyNone"></telerik:EditorTool>
                                                <telerik:EditorSeparator></telerik:EditorSeparator>
                                                <telerik:EditorTool Name="Indent"></telerik:EditorTool>
                                                <telerik:EditorTool Name="Outdent"></telerik:EditorTool>
                                                <telerik:EditorSeparator></telerik:EditorSeparator>
                                                <telerik:EditorTool Name="InsertOrderedList"></telerik:EditorTool>
                                                <telerik:EditorTool Name="InsertUnorderedList"></telerik:EditorTool>
                                            </telerik:EditorToolGroup>
                                        </Tools>
                                    </telerik:RadEditor>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp; </td>
                                <td>&nbsp; </td>
                            </tr>
                            <tr>
                                <td colspan="2" style="padding-right: 12px;">
                                    <asp:ValidationSummary ID="ValidationSummary2" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' ShowMessageBox="true" 
                                                           ShowSummary="true" DisplayMode="BulletList" EnableClientScript="false" />
                                </td>
                            </tr>
                            <tr>
                                <td align="left" colspan="2">
                                    <telerik:RadButton ID="btnUpdate" Text='<%# Resources.Resource.lblActionSend %>'
                                                       runat="server" CommandName="PerformInsert" Icon-PrimaryIconCssClass="rbOk">
                                    </telerik:RadButton>
                                    <telerik:RadButton ID="btnCancel" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                       CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                    </telerik:RadButton>
                                </td>
                            </tr>
                        </table>
                    </div>
                </FormTemplate>
            </EditFormSettings>

            <%--#################################################################################### View Template ########################################################################################################--%>
            <NestedViewTemplate>
                <asp:Panel runat="server" ID="PanelDetails" Visible="false">
                    <fieldset style="padding: 5px; margin-left: 10px; margin-bottom: 10px;">
                        <legend style="padding: 5px; background-color: transparent;">
                            <b><%= Resources.Resource.lblDetailsFor %> <%# Eval("Subject") %></b>
                        </legend>
                        <table>
                            <tr>
                                <td valign="top">
                                    <table style="width: 100%;" nowrap="nowrap">
                                        <tr>
                                            <td valign="top">
                                                <asp:Label runat="server" Text='<%# Resources.Resource.lblID + ":" %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="MailID" runat="server" Text='<%# Eval("ID") %>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                <asp:Label runat="server" Text='<%# Resources.Resource.lblFrom + ":" %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="SenderName" Text='<%# Eval("SenderName") %>' Font-Bold='<%# (Eval("MailRead") == DBNull.Value) %>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                <asp:Label runat="server" Text='<%# Resources.Resource.lblDate + ":" %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="MailCreated" runat="server" Text='<%# Convert.ToDateTime(Eval("MailCreated")).ToString("G") %>' ></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                <asp:Label runat="server" Text='<%# Resources.Resource.lblText + ":" %>'></asp:Label>
                                            </td>
                                            <td style="background-color: white; padding: 3px; border-radius: 5px;">
                                                <asp:Label ID="Body" runat="server" Text='<%# Eval("Body") %>' ToolTip='<%# Eval("Body").ToString().Replace("<br/>", "\n") %>'></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td valign="top">
                                    <asp:Label runat="server" Text='<%# Resources.Resource.lblAttachments + ":" %>'></asp:Label>
                                    <telerik:RadGrid runat="server" ID="Attachments" DataSourceID="SqlDataSource_Attachments" CssClass="RadGrid"
                                                     OnItemCommand="Attachments_ItemCommand" GroupPanelPosition="Top" AutoGenerateColumns="False">

                                        <SortingSettings SortedBackColor="Transparent" />

                                        <MasterTableView CommandItemDisplay="None" DataSourceID="SqlDataSource_Attachments" AllowSorting="true"
                                                         CssClass="MasterClass" NoMasterRecordsText="<%$ Resources:Resource, msgNoDataFound %>" DataKeyNames="Id">

                                            <CommandItemSettings ShowAddNewRecordButton="false" ShowRefreshButton="true" />

                                            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="false" />

                                            <Columns>
                                                <telerik:GridTemplateColumn DataField="DocumentName" HeaderText="<%$ Resources:Resource, lblAttachment %>" SortExpression="DocumentName" UniqueName="DocumentName"
                                                                            GroupByExpression="DocumentName DocumentName GROUP BY DocumentName">
                                                    <ItemTemplate>
                                                        <telerik:RadButton runat="server" ID="DocDownloadBtn" Text='<%# Eval("DocumentName") %>' ToolTip="<%$ Resources:Resource, msgClickToDownload %>" 
                                                                           CommandName="DocDownloadCmd" CommandArgument='<%# Eval("DocumentID") %>' AutoPostBack="true" 
                                                                           ButtonType="SkinnedButton" Height="30px" Visible='<%# (Eval("DocumentType").ToString() != "Url") %>'
                                                                           OnClientClicked="gridCommand">
                                                            <Icon PrimaryIconUrl="/InSiteApp/Resources/Icons/go-down.png" PrimaryIconWidth="24px" PrimaryIconHeight="24px" />
                                                        </telerik:RadButton>
                                                        <telerik:RadButton runat="server" ID="ActionBtn" Text="<%$ Resources:Resource, lblActivateProcess %>" ToolTip="<%$ Resources:Resource, lblActivateProcess %>" 
                                                                           ButtonType="LinkButton" NavigateUrl='<%# Eval("DocumentName") %>' Height="24px" Visible="false">
                                                            <Icon PrimaryIconUrl="/InSiteApp/Resources/Icons/view-refresh-3.png" PrimaryIconWidth="22px" PrimaryIconHeight="22px" />
                                                        </telerik:RadButton>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>

                                                <telerik:GridTemplateColumn DataField="ID" HeaderText="<%$ Resources:Resource, lblAttachmentID %>" SortExpression="ID" UniqueName="ID"
                                                                            GroupByExpression="ID ID GROUP BY ID">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="DocumentID" Text='<%# Eval("ID") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                            </Columns>
                                        </MasterTableView>

                                    </telerik:RadGrid>

                                    <asp:SqlDataSource ID="SqlDataSource_Attachments" runat="server" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                                                       SelectCommand="SELECT System_MailAttachment.Id, System_MailAttachment.SystemID, System_MailAttachment.MailID, System_MailAttachment.DocumentID, System_MailAttachment.AttachmentRead, System_Documents.JobId, System_Documents.UserID, System_Documents.DocumentRef, System_Documents.DocCreated, System_Documents.DocumentName, System_Documents.DocumentType FROM System_MailAttachment INNER JOIN System_Documents ON System_MailAttachment.DocumentID = System_Documents.Id WHERE (System_MailAttachment.SystemID = @SystemID) AND (System_MailAttachment.MailID = @MailID)">
                                        <SelectParameters>
                                            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                            <asp:ControlParameter ControlID="MailID" PropertyName="Text" DefaultValue="0" Name="MailID"></asp:ControlParameter>

                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </td>
                            </tr>
                        </table>
                        </fieldset>
                </asp:Panel>
            </NestedViewTemplate>

            <Columns>
                <telerik:GridTemplateColumn UniqueName="CheckBoxTemplateColumn" AllowFiltering="false" AllowSorting="false" HeaderStyle-Width="35px" ItemStyle-Width="35px">
                    <ItemTemplate>
                        <asp:CheckBox ID="CheckBox1" runat="server" OnCheckedChanged="ToggleRowSelection" AutoPostBack="True" />
                    </ItemTemplate>
                    <HeaderTemplate>
                        <asp:CheckBox ID="headerChkbox" runat="server" OnCheckedChanged="ToggleSelectedState" AutoPostBack="True" />
                    </HeaderTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="MailRead" HeaderText="<%$ Resources:Resource, lblStatus %>" SortExpression="MailRead" UniqueName="MailRead"
                                            GroupByExpression="MailRead MailRead GROUP BY MailRead" HeaderStyle-Width="65px" ItemStyle-Width="65px" ItemStyle-HorizontalAlign="Center" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:HiddenField runat="server" ID="MailRead" Value='<%# Eval("MailRead") %>' />

                        <asp:ImageButton runat="server" ID="ToggleReadButton" CommandName="ToggleRead" CommandArgument='<%# Eval("ID") %>' 
                                         ToolTip='<%# (Eval("MailRead") == DBNull.Value) ? Resources.Resource.lblEmailMarkRead : Resources.Resource.lblEmailMarkUnread %>'
                                         ImageUrl='<%# (Eval("MailRead") == DBNull.Value) ? "/InSiteApp/Resources/Icons/mail-unread-new.png" : "/InSiteApp/Resources/Icons/mail-read-2.png" %>' />
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="StatusID" DataValueField="MailRead" Height="200px" AppendDataBoundItems="true" 
                                             SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("MailRead").CurrentFilterValue %>'
                                             runat="server" OnClientSelectedIndexChanged="StatusIDIndexChanged" DropDownAutoWidth="Enabled" Width="50px">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" Selected="true" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblUnread %>" Value="0" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblRead %>" Value="1" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock10" runat="server">
                            <script type="text/javascript">
                                function StatusIDIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    var filterVal = args.get_item().get_value();
                                    if (filterVal === "") {
                                        tableView.filter("MailRead", filterVal, "NoFilter");
                                    } else if (filterVal === "1") {
                                        tableView.filter("MailRead", "1", "NotIsNull");
                                    } else if (filterVal === "0") {
                                        tableView.filter("MailRead", "0", "IsNull");
                                    }
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="ID" HeaderText="<%$ Resources:Resource, lblID %>" SortExpression="MailID" UniqueName="MailID"
                                            GroupByExpression="MailID MailID GROUP BY MailID" HeaderStyle-Width="50px" ItemStyle-Width="50px" AllowFiltering="false">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="ID" Text='<%# Eval("ID") %>' Font-Bold='<%# (Eval("MailRead") == DBNull.Value) %>' Width="40px"></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="SenderID" UniqueName="SenderID" Visible="false" ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="SenderID" Text='<%# Eval("SenderID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="SenderName" HeaderText="<%$ Resources:Resource, lblFrom %>" SortExpression="SenderName" UniqueName="SenderName"
                                            GroupByExpression="SenderName SenderName GROUP BY SenderName" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="SenderName" Text='<%# Eval("SenderName") %>' Font-Bold='<%# (Eval("MailRead") == DBNull.Value) %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Subject" HeaderText="<%$ Resources:Resource, lblSubject %>" SortExpression="Subject" UniqueName="Subject"
                                            GroupByExpression="Subject Subject GROUP BY Subject" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Subject" Text='<%# Eval("Subject") %>' Font-Bold='<%# (Eval("MailRead") == DBNull.Value) %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Body" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter Body column" HeaderText="<%$ Resources:Resource, lblText %>" 
                                            SortExpression="Body" UniqueName="Body" Visible="true" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label ID="Body" runat="server" Text='<%# (Eval("MailRead") == DBNull.Value) ? Eval("Body") : Tail(Eval("Body").ToString(), 100).Replace("<br/>", " ") %>' 
                                   ToolTip='<%# Eval("Body").ToString().Replace("<br/>", "\n") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridDateTimeColumn FilterControlWidth="100px" DataField="MailCreated" HeaderText="<%$ Resources:Resource, lblCreated %>" SortExpression="MailCreated"
                                            UniqueName="MailCreated" PickerType="DatePicker" EnableRangeFiltering="true" HeaderStyle-Width="170px" ItemStyle-Width="170px" CurrentFilterFunction="Between" 
                                            AutoPostBackOnFilter="true" EnableTimeIndependentFiltering="true">
                </telerik:GridDateTimeColumn>

                <telerik:GridTemplateColumn DataField="MailRead" HeaderText="<%$ Resources:Resource, lblActions %>" SortExpression="MailRead" UniqueName="Actions"
                                            HeaderStyle-Width="60px" ItemStyle-Width="60px" ItemStyle-Wrap="false" AllowFiltering="false" AllowSorting="false">
                    <ItemTemplate>
                        <asp:ImageButton runat="server" ID="ReplyButton" CommandName="Reply" CommandArgument='<%# Eval("ID") %>' 
                                         ImageUrl="../../Resources/Icons/mail-reply-sender-2.png" Tooltip="<%$ Resources:Resource, lblEmailReply %>"/>

                        <asp:ImageButton runat="server" ID="ForwardButton" CommandName="Forward" CommandArgument='<%# Eval("ID") %>' 
                                         ImageUrl="../../Resources/Icons/mail-reply.png" Tooltip="<%$ Resources:Resource, lblEmailForward %>"/>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridButtonColumn UniqueName="deleteColumn" Visible="false" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                          ConfirmDialogType="RadWindow"
                                          ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                    <ItemStyle BackColor="Control" />
                </telerik:GridButtonColumn>

            </Columns>
        </MasterTableView>

    </telerik:RadGrid>

    <asp:SqlDataSource ID="SqlDataSource_Users" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT m_u.SystemID, m_u.UserID, m_u.FirstName, m_u.LastName, m_u.LoginName, m_u.Email, s_c.NameVisible AS Company, s_c.NameAdditional, m_u.LoginName COLLATE Latin1_General_CI_AS + ': ' + m_u.LastName + ', ' + m_u.FirstName + (CASE WHEN s_c.NameVisible IS NULL THEN '' ELSE (' (' + s_c.NameVisible + ')') END) AS UserName FROM Master_Users AS m_u LEFT OUTER JOIN System_Companies AS s_c ON m_u.SystemID = s_c.SystemID AND m_u.CompanyID = s_c.CompanyID WHERE (m_u.SystemID = @SystemID) AND (m_u.LockedOn IS NULL) AND (m_u.ReleaseOn IS NOT NULL) ORDER BY m_u.LastName, m_u.FirstName, Company">
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Mailbox" runat="server" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                       OldValuesParameterFormatString="original_{0}"
                       SelectCommand="SELECT System_Mailbox.Id, System_Mailbox.SystemID, System_Mailbox.Subject, System_Mailbox.JobId, System_Mailbox.UserID, System_Mailbox.Body, System_Mailbox.MailCreated, System_Mailbox.MailRead, System_Mailbox.SenderID, (CASE WHEN System_Mailbox.SenderID = 0 THEN 'System' ELSE Master_Users.LastName + ', ' + Master_Users.FirstName + (CASE WHEN System_Companies.CompanyID IS NULL THEN '' ELSE ' (' + System_Companies.NameVisible + ')' END) END) AS SenderName FROM System_Mailbox LEFT OUTER JOIN Master_Users ON System_Mailbox.SenderID = Master_Users.UserID AND System_Mailbox.SystemID = Master_Users.SystemID LEFT OUTER JOIN System_Companies ON Master_Users.CompanyID = System_Companies.CompanyID AND Master_Users.SystemID = System_Companies.SystemID WHERE (System_Mailbox.SystemID = @SystemID) AND (System_Mailbox.UserID = @UserID)"
                       DeleteCommand="DELETE FROM System_MailAttachment WHERE SystemID = @original_SystemID AND MailID = @original_ID; DELETE FROM System_Mailbox WHERE SystemID = @original_SystemID AND Id = @original_ID;">
        <DeleteParameters>
            <asp:Parameter Name="original_SystemID"></asp:Parameter>
            <asp:Parameter Name="original_ID"></asp:Parameter>
        </DeleteParameters>
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="UserID" DefaultValue="0" Name="UserID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
