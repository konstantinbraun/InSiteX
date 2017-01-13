<%@ Page Title="<%$ Resources:Resource, lblProcessManagement %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProcessEvents.aspx.cs" Inherits="InSite.App.Views.Main.ProcessEvents" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
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
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <telerik:RadGrid ID="RadGrid1" DataSourceID="SqlDataSource_ProcessEvents" runat="server" CssClass="MainGrid" GroupPanelPosition="BeforeHeader"
                     AllowPaging="true" AllowSorting="true" EnableHeaderContextFilterMenu="True" EnableHeaderContextMenu="True" ShowGroupPanel="True" AllowFilteringByColumn="true"
                     AllowAutomaticDeletes="true" AllowAutomaticUpdates="true"
                     OnItemCommand="RadGrid1_ItemCommand" OnPreRender="RadGrid1_PreRender" OnItemDataBound="RadGrid1_ItemDataBound" OnItemUpdated="RadGrid1_ItemUpdated"
                     OnItemCreated="RadGrid1_ItemCreated" OnItemInserted="RadGrid1_ItemInserted" OnInsertCommand="RadGrid1_InsertCommand" OnItemDeleted="RadGrid1_ItemDeleted"
                     OnGroupsChanging="RadGrid1_GroupsChanging">

        <GroupPanel Text="<%$ Resources:Resource, msgGroupPanel %>">
        </GroupPanel>

        <GroupingSettings ShowUnGroupButton="True" CaseSensitive="false" />

        <ExportSettings ExportOnlyData="True" IgnorePaging="True">
            <Pdf PaperSize="A4">
            </Pdf>
            <Excel Format="ExcelML" />
        </ExportSettings>

        <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false" AllowGroupExpandCollapse="true" AllowExpandCollapse="true">
            <Resizing AllowColumnResize="true"></Resizing>
            <Selecting AllowRowSelect="True" />
            <ClientEvents OnRowClick="OnRowClick" OnKeyPress="GridKeyPress" />
        </ClientSettings>

        <SortingSettings SortedBackColor="Transparent" />

        <MasterTableView EnableHierarchyExpandAll="true" AutoGenerateColumns="False" DataKeyNames="SystemID,ProcessEventID" DataSourceID="SqlDataSource_ProcessEvents"
                         CommandItemDisplay="Top" HierarchyLoadMode="ServerOnDemand" AllowMultiColumnSorting="true" EditMode="PopUp" PageSize="10" CssClass="MasterClass"
                         ItemStyle-VerticalAlign="Top" AlternatingItemStyle-VerticalAlign="Top">

            <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="false" ShowExportToExcelButton="True" ShowExportToPdfButton="false"
                                 AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" PageSizes="10,20,50" />

            <SortExpressions>
                <telerik:GridSortExpression FieldName="EditOn" SortOrder="Descending"></telerik:GridSortExpression>
            </SortExpressions>

            <Columns>
                <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                               UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                    <ItemStyle BackColor="Control" Width="30px" />
                    <HeaderStyle Width="30px" />
                </telerik:GridEditCommandColumn>

                <telerik:GridTemplateColumn DataField="StatusID" HeaderText="<%$ Resources:Resource, lblStatus %>" SortExpression="StatusID" UniqueName="StatusID" ItemStyle-HorizontalAlign="Center"
                                            GroupByExpression="StatusID StatusID GROUP BY StatusID" Visible="true" ItemStyle-Width="70px" HeaderStyle-Width="70px" DefaultInsertValue="9">
                    <ItemTemplate>
                        <asp:HiddenField runat="server" ID="StatusID" Value='<%# Eval("StatusID") %>' />
                        <asp:ImageButton runat="server" ID="ReleaseButton" />
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="StatusID" DataValueField="StatusID" Height="200px" AppendDataBoundItems="true" 
                                             SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("StatusID").CurrentFilterValue %>'
                                             runat="server" OnClientSelectedIndexChanged="StatusIDIndexChanged" DropDownAutoWidth="Enabled" Width="50px">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" Selected="true" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statCreated %>" Value="0" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statWaitExecute %>" Value="9" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statDone %>" Value="50" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock10" runat="server">
                            <script type="text/javascript">
                                function StatusIDIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    tableView.filter("StatusID", args.get_item().get_value(), "EqualTo");
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="ProcessEventID" DataType="System.Int32" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter ProcessEventID column"
                                            HeaderText="<%$ Resources:Resource, lblID %>" SortExpression="ProcessEventID" UniqueName="ProcessEventID" Visible="false">
                    <ItemTemplate>
                        <asp:HiddenField ID="ProcessUrl" runat="server" Value='<%# Eval("ProcessUrl") %>'></asp:HiddenField>
                        <asp:Label ID="ProcessEventID" runat="server" Text='<%# Eval("ProcessEventID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="BpName" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter BpName column" FilterControlWidth="80px"
                                            HeaderText="<%$ Resources:Resource, lblBuildingProject %>" SortExpression="BpName" UniqueName="BpName" Visible="false" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label ID="BpName" runat="server" Text='<%# Eval("BpName") %>' Font-Bold='<%# (Convert.ToInt32(Eval("StatusID")) == InSite.App.Constants.Status.WaitExecute) %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="CompanyName" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CompanyName column" FilterControlWidth="80px"
                                            HeaderText="<%$ Resources:Resource, lblCompany %>" SortExpression="CompanyName" UniqueName="CompanyName" Visible="false" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label ID="CompanyName" runat="server" Text='<%# Eval("CompanyName") %>' Font-Bold='<%# (Convert.ToInt32(Eval("StatusID")) == InSite.App.Constants.Status.WaitExecute) %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="NameVisible" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter NameVisible column" FilterControlWidth="80px"
                                            HeaderText="<%$ Resources:Resource, lblProcess %>" SortExpression="NameVisible" UniqueName="NameVisible" Visible="true" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ItemStyle-Width="250px" HeaderStyle-Width="250px">
                    <ItemTemplate>
                        <asp:Label ID="NameVisible" runat="server" Text='<%# Eval("NameVisible") %>' Font-Bold='<%# (Convert.ToInt32(Eval("StatusID")) == InSite.App.Constants.Status.WaitExecute) %>' Width="240px"></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="CreatedOn" FilterControlAltText="Filter CreatedOn column" HeaderText="<%$ Resources:Resource, lblCreatedOn %>" 
                                            SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="true" FilterControlWidth="80px" ItemStyle-Width="120px" HeaderStyle-Width="120px">
                    <ItemTemplate>
                        <asp:Label ID="CreatedOn" runat="server" Text='<%# Eval("CreatedOn", "{0:dd.MM.yyyy HH:mm}") %>' Font-Bold='<%# (Convert.ToInt32(Eval("StatusID")) == InSite.App.Constants.Status.WaitExecute) %>' Width="110px"></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="CreatedFrom" FilterControlAltText="Filter CreatedFrom column" HeaderText="<%$ Resources:Resource, lblCreatedFrom %>" 
                                            SortExpression="CreatedFrom" UniqueName="CreatedFrom" Visible="true" FilterControlWidth="80px" ItemStyle-Width="120px" HeaderStyle-Width="120px">
                    <ItemTemplate>
                        <asp:Label ID="CreatedFrom" runat="server" Text='<%# Eval("CreatedFrom") %>' Font-Bold='<%# (Convert.ToInt32(Eval("StatusID")) == InSite.App.Constants.Status.WaitExecute) %>' Width="110px"></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="DoneOn" FilterControlAltText="Filter DoneOn column" HeaderText="<%$ Resources:Resource, lblDoneOn %>" 
                                            SortExpression="DoneOn" UniqueName="DoneOn" Visible="true" FilterControlWidth="80px" ItemStyle-Width="120px" HeaderStyle-Width="120px">
                    <ItemTemplate>
                        <asp:Label ID="DoneOn" runat="server" Text='<%# Eval("DoneOn", "{0:dd.MM.yyyy HH:mm}") %>' Font-Bold='<%# (Convert.ToInt32(Eval("StatusID")) == InSite.App.Constants.Status.WaitExecute) %>' Width="110px"></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="DoneFrom" FilterControlAltText="Filter DoneFrom column" HeaderText="<%$ Resources:Resource, lblDoneFrom %>" 
                                            SortExpression="DoneFrom" UniqueName="DoneFrom" Visible="true" FilterControlWidth="80px" ItemStyle-Width="120px" HeaderStyle-Width="120px">
                    <ItemTemplate>
                        <asp:Label ID="DoneFrom" runat="server" Text='<%# Eval("DoneFrom") %>' Font-Bold='<%# (Convert.ToInt32(Eval("StatusID")) == InSite.App.Constants.Status.WaitExecute) %>' Width="110px"></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="DescriptionShort" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter DescriptionShort column" FilterControlWidth="80px"
                                            HeaderText="<%$ Resources:Resource, lblHint %>" SortExpression="DescriptionShort" UniqueName="DescriptionShort" Visible="true" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label ID="Body" runat="server" Text='<%# Tail(Eval("DescriptionShort").ToString(), 100).Replace("<br />", " ").Replace("<br/>", " ") %>' 
                                   ToolTip='<%# Eval("DescriptionShort").ToString().Replace("<br />", "\n").Replace("<br/>", "\n") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridBoundColumn DataField="SystemID" UniqueName="SystemID" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="BpID" UniqueName="BpID" ForceExtractValue="Always" Visible="false" DefaultInsertValue="0"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="CompanyCentralID" UniqueName="CompanyCentralID" ForceExtractValue="Always" Visible="false" DefaultInsertValue="0"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="UserIDInitiator" UniqueName="UserIDInitiator" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="UserIDExecutive" UniqueName="UserIDExecutive" ForceExtractValue="Always" Visible="false" DefaultInsertValue="0"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="DialogID" UniqueName="DialogID" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="ActionID" UniqueName="ActionID" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="RefID" UniqueName="RefID" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="TypeID" UniqueName="TypeID" ForceExtractValue="Always" Visible="false" DefaultInsertValue="2"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="ProcessUrl" UniqueName="ProcessUrl" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="EditFrom" UniqueName="EditFrom" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="EditOn" UniqueName="EditOn" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <%--                <telerik:GridBoundColumn DataField="CreatedFrom" UniqueName="CreatedFrom" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="CreatedOn" UniqueName="CreatedOn" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>--%>

                <telerik:GridButtonColumn UniqueName="deleteColumn" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                          ConfirmDialogType="RadWindow"
                                          ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                    <ItemStyle BackColor="Control" />
                </telerik:GridButtonColumn>

            </Columns>

            <%--#################################################################################### Edit Template ########################################################################################################--%>
            <EditFormSettings EditFormType="Template" CaptionDataField="NameVisible" CaptionFormatString="{0}">
                <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                <FormTemplate>
                        <table id="Table1" cellspacing="2" cellpadding="2" border="0" rules="none" class="EditFormTable">
                            <tr>
                                <td style="vertical-align: top;">
                                    <table id="Table2" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelProcessEventID" Text='<%# String.Concat(Resources.Resource.lblID, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="ProcessEventID" Text='<%# Eval("ProcessEventID") %>'></asp:Label>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelStatus" Text='<%# String.Concat(Resources.Resource.lblStatus, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="Status" Text="" Width="300px"></asp:Label>&nbsp;
                                                <asp:HiddenField runat="server" ID="StatusID" Value='<%# Bind("StatusID") %>' />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelBpID" Text='<%# String.Concat(Resources.Resource.lblBuildingProject, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <telerik:RadComboBox runat="server" ID="BpID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                     DataSourceID="SqlDataSource_BuildingProjects" DataValueField="BpID" DataTextField="NameVisible" Width="300" 
                                                                     AppendDataBoundItems="true" Filter="Contains" AllowCustomText="true" OnSelectedIndexChanged="BpID_SelectedIndexChanged"
                                                                     SelectedValue='<%# Bind("BpID") %>' DropDownAutoWidth="Enabled" AutoPostBack="true">
                                                    <Items>
                                                        <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                                                    </Items>
                                                </telerik:RadComboBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelCompanyCentralID" Text='<%# String.Concat(Resources.Resource.lblCompany, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <telerik:RadComboBox runat="server" ID="CompanyCentralID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                     DataSourceID="SqlDataSource_CompaniesCentral" DataValueField="CompanyID" DataTextField="NameVisible" Width="300" 
                                                                     AppendDataBoundItems="true" Filter="Contains" AllowCustomText="true" OnSelectedIndexChanged="CompanyCentralID_SelectedIndexChanged"
                                                                     SelectedValue='<%# Bind("CompanyCentralID") %>' DropDownAutoWidth="Enabled" AutoPostBack="true">
                                                    <Items>
                                                        <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                                                    </Items>
                                                </telerik:RadComboBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelUserIDExecutive" Text='<%# String.Concat(Resources.Resource.lblUser, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:HiddenField runat="server" ID="UserIDExecutive1" Value='<%# Eval("UserIDExecutive") %>' />
                                                <telerik:RadComboBox runat="server" ID="UserIDExecutive" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                     DataValueField="UserID" DataTextField="UserName" Width="300" 
                                                                     AppendDataBoundItems="true" Filter="Contains" AllowCustomText="true" 
                                                                     DropDownAutoWidth="Enabled">
                                                    <Items>
                                                        <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                                                    </Items>
                                                </telerik:RadComboBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelNameVisible" Text='<%# String.Concat(Resources.Resource.lblNameVisible, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <telerik:RadTextBox runat="server" ID="NameVisible" Text='<%# Bind("NameVisible") %>' Width="300px"></telerik:RadTextBox>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelDescriptionShort" Text='<%# String.Concat(Resources.Resource.lblHint, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <telerik:RadTextBox runat="server" ID="DescriptionShort" Text='<%# Bind("DescriptionShort") %>' Width="300px" Height="150px" 
                                                                    TextMode="MultiLine"></telerik:RadTextBox>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="LabelDone" Text='<%# String.Concat(Resources.Resource.lblDone1, ":") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="DoneFrom" Text='<%# Bind("DoneFrom") %>' runat="server"></asp:Label>&nbsp;
                                                <asp:Label ID="DoneOn" Text='<%# Bind("DoneOn") %>' runat="server"></asp:Label>
                                                <telerik:RadButton ID="SetDone" runat="server" ButtonType="StandardButton" Text="<%$ Resources:Resource, statDone %>"
                                                                   CommandName="SetDone" CommandArgument='<%# Eval("ProcessEventID") %>' Visible="false"></telerik:RadButton>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="LabelCreated" Text='<%# String.Concat(Resources.Resource.lblCreated1, ":") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="CreatedFrom" Text='<%# Eval("CreatedFrom") %>' runat="server"></asp:Label>&nbsp;
                                                <asp:Label ID="CreatedOn" Text='<%# Eval("CreatedOn") %>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="LabelEdit" Text='<%# String.Concat(Resources.Resource.lblEdited1, ":") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="EditFrom" Text='<%# Eval("EditFrom") %>' runat="server"></asp:Label>&nbsp;
                                                <asp:Label ID="EditOn" Text='<%# Eval("EditOn") %>' runat="server"></asp:Label>
                                            </td>
                                        </tr>

                                    </table>
                                </td>
                                <td style="vertical-align: top;">
                                    <table id="Table3" cellspacing="2" cellpadding="2" border="0">
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" style="padding-right: 12px;">
                                    <asp:ValidationSummary ID="ValidationSummary2" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' ShowMessageBox="true" 
                                                           ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true" />
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp; </td>
                                <td>&nbsp; </td>
                            </tr>
                            <tr>
                                <td align="left" colspan="2">
                                    <telerik:RadButton ID="btnUpdate" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionUpdate%>'
                                                       runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update"%>' Icon-PrimaryIconCssClass="rbOk"
                                                       CausesValidation="true">
                                    </telerik:RadButton>
                                    <telerik:RadButton ID="btnCancel" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                       CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                    </telerik:RadButton>
                                </td>
                            </tr>
                        </table>
                </FormTemplate>
            </EditFormSettings>

            <%--#################################################################################### View Template ########################################################################################################--%>
            <NestedViewTemplate>
                <asp:Panel runat="server" ID="InnerContainer" Visible="false">
                    <fieldset style="padding: 10px; margin-left: 10px; margin-bottom: 10px;">
                        <legend style="padding: 5px; background-color: transparent;">
                            <b><%= Resources.Resource.lblDetailsFor %> <%# Eval("NameVisible") %></b>
                        </legend>
                        <table id="Table1" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                            <tr>
                                <td style="vertical-align: top;">
                                    <table id="Table2" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelProcessEventID" Text='<%# String.Concat(Resources.Resource.lblID, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="ProcessEventID" Text='<%# Eval("ProcessEventID") %>'></asp:Label>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelStatus" Text='<%# String.Concat(Resources.Resource.lblStatus, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="Status" Text="" Width="300px"></asp:Label>&nbsp;
                                                <asp:HiddenField runat="server" ID="StatusID" Value='<%# Eval("StatusID") %>' />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelBpID" Text='<%# String.Concat(Resources.Resource.lblBuildingProject, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="BpID" Text='<%# Eval("BpName") %>'></asp:Label>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelCompanyCentralID" Text='<%# String.Concat(Resources.Resource.lblCompany, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="CompanyCentralID" Text='<%# Eval("CompanyName") %>'></asp:Label>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelUserIDExecutive" Text='<%# String.Concat(Resources.Resource.lblUser, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="UserIDExecutive" Text='<%# Eval("ExecutiveName") %>'></asp:Label>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelNameVisible" Text='<%# String.Concat(Resources.Resource.lblNameVisible, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="NameVisible" Text='<%# Eval("NameVisible") %>' Width="300px"></asp:Label>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelDescriptionShort" Text='<%# String.Concat(Resources.Resource.lblHint, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="DescriptionShort" Text='<%# Eval("DescriptionShort") %>' Width="300px"></asp:Label>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="LabelDone" Text='<%# String.Concat(Resources.Resource.lblDone1, ":") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="DoneFrom" Text='<%# Eval("DoneFrom") %>' runat="server"></asp:Label>&nbsp;
                                                <asp:Label ID="DoneOn" Text='<%# Eval("DoneOn") %>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="LabelCreated" Text='<%# String.Concat(Resources.Resource.lblCreated1, ":") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="CreatedFrom" Text='<%# Eval("CreatedFrom") %>' runat="server"></asp:Label>&nbsp;
                                                <asp:Label ID="CreatedOn" Text='<%# Eval("CreatedOn") %>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="LabelEdit" Text='<%# String.Concat(Resources.Resource.lblEdited1, ":") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="EditFrom" Text='<%# Eval("EditFrom") %>' runat="server"></asp:Label>&nbsp;
                                                <asp:Label ID="EditOn" Text='<%# Eval("EditOn") %>' runat="server"></asp:Label>
                                            </td>
                                        </tr>

                                    </table>
                                </td>
                                <td style="vertical-align: top;">
                                    <table id="Table3" cellspacing="2" cellpadding="2" border="0">
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </asp:Panel>
            </NestedViewTemplate>
        </MasterTableView>

    </telerik:RadGrid>

    <asp:SqlDataSource ID="SqlDataSource_ProcessEvents" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>" OnSelecting="SqlDataSource_ProcessEvents_Selecting"
        OldValuesParameterFormatString="original_{0}"
        SelectCommand="SELECT d_pe.SystemID, d_pe.ProcessEventID, d_pe.BpID, d_pe.CompanyCentralID, d_pe.NameVisible, d_pe.ResourceID, d_pe.DescriptionShort, d_pe.DialogID, d_pe.ActionID, d_pe.RefID, d_pe.StatusID, d_pe.DoneFrom, d_pe.DoneOn, d_pe.CreatedFrom, d_pe.CreatedOn, d_pe.EditFrom, d_pe.EditOn, d_pe.UserIDInitiator, d_pe.UserIDExecutive, m_bp.NameVisible AS BpName, s_c.NameVisible AS CompanyName, m_u_i.LoginName AS InitiatorName, m_u_e.LoginName AS ExecutiveName, d_pe.TypeID, d_pe.ProcessUrl FROM Data_ProcessEvents AS d_pe LEFT OUTER JOIN Master_Users AS m_u_i ON d_pe.SystemID = m_u_i.SystemID AND d_pe.UserIDInitiator = m_u_i.UserID LEFT OUTER JOIN Master_Users AS m_u_e ON d_pe.SystemID = m_u_e.SystemID AND d_pe.UserIDExecutive = m_u_e.UserID LEFT OUTER JOIN System_Companies AS s_c ON d_pe.CompanyCentralID = s_c.CompanyID AND d_pe.SystemID = s_c.SystemID LEFT OUTER JOIN Master_BuildingProjects AS m_bp ON d_pe.SystemID = m_bp.SystemID AND d_pe.BpID = m_bp.BpID WHERE (d_pe.SystemID = @SystemID) AND (d_pe.UserIDInitiator = @UserID) AND (d_pe.TypeID = 2) AND (d_pe.BpID = @BpID) OR (d_pe.SystemID = @SystemID) AND (d_pe.UserIDExecutive = @UserID) AND (d_pe.BpID = @BpID)"
        DeleteCommand="DELETE FROM Data_ProcessEvents WHERE (SystemID = @original_SystemID) AND (ProcessEventID = @original_ProcessEventID)"
        InsertCommand="INSERT INTO Data_ProcessEvents(SystemID, BpID, CompanyCentralID, UserIDInitiator, UserIDExecutive, NameVisible, DescriptionShort, DialogID, ActionID, RefID, StatusID, TypeID, DoneFrom, DoneOn, CreatedFrom, CreatedOn, EditFrom, EditOn, TypeID) VALUES (@SystemID, @BpID, @CompanyCentralID, @UserIDInitiator, @UserIDExecutive, @NameVisible, @DescriptionShort, @DialogID, @ActionID, @RefID, 9, 2, @DoneFrom, @DoneOn, @UserName, SYSDATETIME(), @UserName, SYSDATETIME(), 2)"
        UpdateCommand="UPDATE Data_ProcessEvents SET NameVisible = @NameVisible, DescriptionShort = @DescriptionShort, StatusID = @StatusID, DoneFrom = @DoneFrom, DoneOn = @DoneOn, UserIDExecutive = @UserIDExecutive WHERE (SystemID = @original_SystemID) AND (ProcessEventID = @original_ProcessEventID)">
        <DeleteParameters>
            <asp:Parameter Name="original_SystemID"></asp:Parameter>
            <asp:Parameter Name="original_ProcessEventID"></asp:Parameter>
        </DeleteParameters>
        <InsertParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
            <asp:Parameter Name="BpID" DefaultValue="0"></asp:Parameter>
            <asp:Parameter Name="CompanyCentralID" DefaultValue="0"></asp:Parameter>
            <asp:SessionParameter SessionField="UserID" DefaultValue="0" Name="UserIDInitiator"></asp:SessionParameter>
            <asp:Parameter Name="UserIDExecutive" DefaultValue="0"></asp:Parameter>
            <asp:Parameter Name="NameVisible"></asp:Parameter>
            <asp:Parameter Name="DescriptionShort"></asp:Parameter>
            <asp:Parameter Name="DialogID" DefaultValue="0"></asp:Parameter>
            <asp:Parameter Name="ActionID" DefaultValue="0"></asp:Parameter>
            <asp:Parameter Name="RefID" DefaultValue="0"></asp:Parameter>
            <asp:Parameter Name="DoneFrom"></asp:Parameter>
            <asp:Parameter Name="DoneOn"></asp:Parameter>
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
        </InsertParameters>
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
            <asp:SessionParameter SessionField="UserID" DefaultValue="0" Name="UserID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="ProcessBpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="NameVisible"></asp:Parameter>
            <asp:Parameter Name="DescriptionShort"></asp:Parameter>
            <asp:Parameter Name="StatusID"></asp:Parameter>
            <asp:Parameter Name="DoneFrom"></asp:Parameter>
            <asp:Parameter Name="DoneOn"></asp:Parameter>
            <asp:Parameter Name="UserIDExecutive"></asp:Parameter>
            <asp:Parameter Name="original_SystemID"></asp:Parameter>
            <asp:Parameter Name="original_ProcessEventID"></asp:Parameter>
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_CompaniesCentral" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT c.SystemID, c.CompanyID, c.NameVisible, c.NameAdditional, c.Description, c.AddressID, c.IsVisible, c.IsValid, c.TradeAssociation, c.BlnSOKA, c.CreatedFrom, c.CreatedOn, c.EditFrom, c.EditOn, a.Address1, a.Address2, a.Zip, a.City, a.State, a.CountryID, a.Phone, a.Email, a.WWW, c.NameVisible + (CASE WHEN c.NameAdditional IS NULL THEN '' ELSE ', ' + c.NameAdditional END) + (CASE WHEN a.City IS NULL THEN '' ELSE ', ' + a.City END) AS CompanyName FROM System_Companies AS c INNER JOIN System_Addresses AS a ON c.SystemID = a.SystemID AND c.AddressID = a.AddressID WHERE (c.SystemID = @SystemID) ORDER BY c.NameVisible">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_BuildingProjects" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT DISTINCT bp.SystemID, bp.BpID, bp.NameVisible, bp.DescriptionShort, bp.TypeID, bp.BasedOn, bp.IsVisible, bp.CountryID, bp.BuilderName, bp.PresentType, bp.MWCheck, bp.MWHours, bp.MWDeadline, bp.Address, bp.CreatedFrom, bp.CreatedOn, bp.EditFrom, bp.EditOn FROM Master_BuildingProjects AS bp INNER JOIN Master_UserBuildingProjects AS ubp1 ON bp.SystemID = ubp1.SystemID AND bp.BpID = ubp1.BpID WHERE (bp.SystemID = @SystemID) AND (ubp1.UserID = @EditingUserID) ORDER BY bp.NameVisible">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="EditingUserID" SessionField="UserID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
