<%@ Page Title="<%$ Resources:Resource, lblJobManagement %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="JobManagement.aspx.cs" Inherits="InSite.App.Views.Main.JobManagement" %>

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

    <telerik:RadGrid ID="RadGrid1" DataSourceID="SqlDataSource_Jobs" runat="server" CssClass="MainGrid" GroupPanelPosition="BeforeHeader"
        AllowPaging="true" AllowSorting="true" EnableHeaderContextFilterMenu="True" EnableHeaderContextMenu="True" AllowFilteringByColumn="true"
        AllowAutomaticDeletes="true" AllowAutomaticUpdates="true"
        OnItemCommand="RadGrid1_ItemCommand" OnPreRender="RadGrid1_PreRender" OnItemDataBound="RadGrid1_ItemDataBound" OnItemUpdated="RadGrid1_ItemUpdated"
        OnItemCreated="RadGrid1_ItemCreated" OnItemDeleted="RadGrid1_ItemDeleted"
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

        <MasterTableView EnableHierarchyExpandAll="true" AutoGenerateColumns="False" DataKeyNames="SystemID,JobID" DataSourceID="SqlDataSource_Jobs"
                         CommandItemDisplay="Top" HierarchyLoadMode="ServerOnDemand" AllowMultiColumnSorting="true" EditMode="PopUp" PageSize="10" CssClass="MasterClass"
                         ItemStyle-VerticalAlign="Middle" AlternatingItemStyle-VerticalAlign="Middle">

            <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="false" ShowExportToCsvButton="false" ShowExportToExcelButton="false" ShowExportToPdfButton="false"
                                 AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" PageSizes="10,20,50" />

            <SortExpressions>
                <telerik:GridSortExpression FieldName="NextStart" SortOrder="Descending"></telerik:GridSortExpression>
                <telerik:GridSortExpression FieldName="StatusID" SortOrder="Ascending"></telerik:GridSortExpression>
            </SortExpressions>

            <Columns>
                <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                               UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                    <ItemStyle BackColor="Control" Width="30px" />
                    <HeaderStyle Width="30px" />
                </telerik:GridEditCommandColumn>

                <telerik:GridTemplateColumn DataField="StatusID" HeaderText="<%$ Resources:Resource, lblStatus %>" SortExpression="StatusID" UniqueName="StatusID" ItemStyle-HorizontalAlign="Center"
                                            GroupByExpression="StatusID StatusID GROUP BY StatusID" Visible="true" ItemStyle-Width="70px" HeaderStyle-Width="70px">
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
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statDeactivated %>" Value="-5" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statCreated %>" Value="0" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statWaitExecute %>" Value="9" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statExecuting %>" Value="49" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statDone %>" Value="50" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock11" runat="server">
                            <script type="text/javascript">
                                function StatusIDIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    tableView.filter("StatusID", args.get_item().get_value(), "EqualTo");
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="JobID" DataType="System.Int32" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter JobID column"
                                            HeaderText="<%$ Resources:Resource, lblID %>" SortExpression="JobID" UniqueName="JobID" Visible="false">
                    <ItemTemplate>
                        <asp:Label ID="JobID" runat="server" Text='<%# Eval("JobID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="NameVisible" FilterControlAltText="Filter NameVisible column" FilterControlWidth="80px" 
                                            HeaderText="<%$ Resources:Resource, lblNameVisible %>" SortExpression="NameVisible" UniqueName="NameVisible" Visible="true" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label ID="NameVisible" runat="server" Text='<%# Eval("NameVisible") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Description" FilterControlAltText="Filter Description column" FilterControlWidth="80px" 
                                            HeaderText="<%$ Resources:Resource, lblDescriptionShort %>" SortExpression="Description" UniqueName="Description" Visible="true" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" >
                    <ItemTemplate>
                        <asp:Label ID="Description" runat="server" Text='<%# Tail(Eval("Description").ToString(), 100).Replace("<br/>", " ") %>' ></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="TemplateName" FilterControlAltText="Filter TemplateName column" FilterControlWidth="80px" 
                                            HeaderText="<%$ Resources:Resource, lblFileName %>" SortExpression="TemplateName" UniqueName="TemplateName" Visible="true" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label ID="TemplateName" runat="server" Text='<%# Eval("TemplateName") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Frequency" HeaderText="<%$ Resources:Resource, lblExecutionInterval %>" SortExpression="Frequency" UniqueName="Frequency" 
                                            GroupByExpression="Frequency Frequency GROUP BY Frequency" Visible="true" ItemStyle-Width="130px" HeaderStyle-Width="130px">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Frequency" Text='<%# GetFrequencyName(Convert.ToInt32(Eval("Frequency"))) %>'></asp:Label>
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="Frequency" DataValueField="Frequency" Height="200px" AppendDataBoundItems="true" 
                                             SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("Frequency").CurrentFilterValue %>'
                                             runat="server" OnClientSelectedIndexChanged="FrequencyIndexChanged" DropDownAutoWidth="Enabled" Width="100px">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" Selected="true" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblOnceOnly %>" Value="0" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblDaily %>" Value="1" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblWeekly %>" Value="2" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblMonthly %>" Value="3" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock10" runat="server">
                            <script type="text/javascript">
                                function FrequencyIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    tableView.filter("StatusID", args.get_item().get_value(), "EqualTo");
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="NextStart" FilterControlAltText="Filter NextStart column" HeaderText="<%$ Resources:Resource, lblNextExecution %>" 
                                            SortExpression="NextStart" UniqueName="NextStart" Visible="true" FilterControlWidth="80px" ItemStyle-Width="130px" HeaderStyle-Width="130px">
                    <ItemTemplate>
                        <asp:Label ID="NextStart" runat="server" Text='<%# Eval("NextStart", "{0:G}") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="CreatedOn" FilterControlAltText="Filter CreatedOn column" HeaderText="<%$ Resources:Resource, lblCreatedOn %>" 
                                            SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="true" FilterControlWidth="80px" ItemStyle-Width="130px" HeaderStyle-Width="130px">
                    <ItemTemplate>
                        <asp:Label ID="CreatedOn" runat="server" Text='<%# Eval("CreatedOn", "{0:G}") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="CreatedFrom" FilterControlAltText="Filter CreatedFrom column" HeaderText="<%$ Resources:Resource, lblCreatedFrom %>" 
                                            SortExpression="CreatedFrom" UniqueName="CreatedFrom" Visible="true" FilterControlWidth="80px" ItemStyle-Width="120px" HeaderStyle-Width="120px">
                    <ItemTemplate>
                        <asp:Label ID="CreatedFrom" runat="server" Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

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
                    <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                        <table id="Table1" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                            <tr>
                                <td style="vertical-align: top;">
                                    <table id="Table2" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelJobID" Text='<%# String.Concat(Resources.Resource.lblID, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="JobID" Text='<%# Eval("JobID") %>'></asp:Label>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelStatus" Text='<%# String.Concat(Resources.Resource.lblStatus, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="Status" Text='<%# InSite.App.Constants.Status.GetStatusString(Convert.ToInt32(Eval("StatusID"))) %>' Width="300px"></asp:Label>&nbsp;
                                                <asp:HiddenField runat="server" ID="StatusID" Value='<%# Bind("StatusID") %>' />
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
                                                <asp:Label runat="server" ID="LabelDescription" Text='<%# String.Concat(Resources.Resource.lblDescriptionShort, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <telerik:RadTextBox runat="server" ID="Description" Text='<%# Bind("Description") %>' Width="300px" Height="150px" 
                                                                    TextMode="MultiLine"></telerik:RadTextBox>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap" style="vertical-align: top;">
                                                <asp:Label runat="server" ID="LabelFrequency" Text='<%$ Resources:Resource, lblExecutionInterval %>'></asp:Label>
                                            </td>
                                            <td colspan="2">
                                                <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px;">
                                                    <telerik:RadComboBox runat="server" ID="Frequency" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                                                         OnClientKeyPressing="OnClientKeyPressing" OnSelectedIndexChanged="Frequency_SelectedIndexChanged"
                                                                         AppendDataBoundItems="true" Filter="Contains" DropDownAutoWidth="Enabled" AutoPostBack="true"
                                                                         SelectedValue='<%# Bind("Frequency") %>'>
                                                        <Items>
                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblOnceOnly %>" Value="0" Selected="true" />
                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblDaily %>" Value="1" />
                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblWeekly %>" Value="2" />
                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblMonthly %>" Value="3" />
                                                        </Items>
                                                    </telerik:RadComboBox>
                                                    <br />
                                                    <br />
                                                    <asp:Panel runat="server" ID="PanelWeekly" Visible="false">
                                                        <asp:Label runat="server" ID="LabelWeekly" Text='<%$ Resources:Resource, lblValidDays %>'></asp:Label>
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <telerik:RadAjaxPanel runat="server">
                                                                        <telerik:RadTextBox runat="server" ID="ValidDays" Text='<%# Bind("ValidDays") %>' Visible="false"></telerik:RadTextBox>
                                                                        <table>
                                                                            <tr>
                                                                                <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                                    <asp:Label runat="server" Text="<%$ Resources:Resource, dayMo %>"></asp:Label>
                                                                                </td>
                                                                                <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                                    <asp:Label runat="server" Text="<%$ Resources:Resource, dayTu %>"></asp:Label>
                                                                                </td>
                                                                                <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                                    <asp:Label runat="server" Text="<%$ Resources:Resource, dayWe %>"></asp:Label>
                                                                                </td>
                                                                                <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                                    <asp:Label runat="server" Text="<%$ Resources:Resource, dayTh %>"></asp:Label>
                                                                                </td>
                                                                                <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                                    <asp:Label runat="server" Text="<%$ Resources:Resource, dayFr %>"></asp:Label>
                                                                                </td>
                                                                                <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                                    <asp:Label runat="server" Text="<%$ Resources:Resource, daySa %>" ForeColor="Red"></asp:Label>
                                                                                </td>
                                                                                <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                                    <asp:Label runat="server" Text="<%$ Resources:Resource, daySu %>" ForeColor="Red"></asp:Label>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                                    <asp:CheckBox runat="server" ID="DayMo" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 0) %>' OnCheckedChanged="DayMo_CheckedChanged" 
                                                                                                  AutoPostBack="true" CausesValidation="false" />
                                                                                </td>
                                                                                <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                                    <asp:CheckBox runat="server" ID="DayTu" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 1) %>' OnCheckedChanged="DayTu_CheckedChanged" 
                                                                                                  AutoPostBack="true" CausesValidation="false" />
                                                                                </td>
                                                                                <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                                    <asp:CheckBox runat="server" ID="DayWe" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 2) %>' OnCheckedChanged="DayWe_CheckedChanged" 
                                                                                                  AutoPostBack="true" CausesValidation="false" />
                                                                                </td>
                                                                                <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                                    <asp:CheckBox runat="server" ID="DayTh" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 3) %>' OnCheckedChanged="DayTh_CheckedChanged" 
                                                                                                  AutoPostBack="true" CausesValidation="false" />
                                                                                </td>
                                                                                <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                                    <asp:CheckBox runat="server" ID="DayFr" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 4) %>' OnCheckedChanged="DayFr_CheckedChanged" 
                                                                                                  AutoPostBack="true" CausesValidation="false" />
                                                                                </td>
                                                                                <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                                    <asp:CheckBox runat="server" ID="DaySa" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 5) %>' OnCheckedChanged="DaySa_CheckedChanged" 
                                                                                                  AutoPostBack="true" CausesValidation="false" />
                                                                                </td>
                                                                                <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                                    <asp:CheckBox runat="server" ID="DaySu" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 6) %>' OnCheckedChanged="DaySu_CheckedChanged" 
                                                                                                  AutoPostBack="true" CausesValidation="false" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </telerik:RadAjaxPanel>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>

                                                    <asp:Panel runat="server" ID="PanelMonthly" Visible="false">
                                                        <asp:Label runat="server" ID="Label3" Text='<%$ Resources:Resource, lblDOM %>'></asp:Label>
                                                        <br />
                                                        <telerik:RadComboBox runat="server" ID="DayOfMonth" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                                                             OnClientKeyPressing="OnClientKeyPressing" SelectedValue='<%# Bind("DayOfMonth") %>'
                                                                             AppendDataBoundItems="true" Filter="Contains" DropDownAutoWidth="Enabled">
                                                            <Items>
                                                                <telerik:RadComboBoxItem Text="-" Value="0" Visible="false" />
                                                                <telerik:RadComboBoxItem Text="1." Value="1" Selected="true" />
                                                                <telerik:RadComboBoxItem Text="2." Value="2" />
                                                                <telerik:RadComboBoxItem Text="3." Value="3" />
                                                                <telerik:RadComboBoxItem Text="4." Value="4" />
                                                                <telerik:RadComboBoxItem Text="5." Value="5" />
                                                                <telerik:RadComboBoxItem Text="6." Value="6" />
                                                                <telerik:RadComboBoxItem Text="7." Value="7" />
                                                                <telerik:RadComboBoxItem Text="8." Value="8" />
                                                                <telerik:RadComboBoxItem Text="9." Value="9" />
                                                                <telerik:RadComboBoxItem Text="10." Value="10" />
                                                                <telerik:RadComboBoxItem Text="11." Value="11" />
                                                                <telerik:RadComboBoxItem Text="12." Value="12" />
                                                                <telerik:RadComboBoxItem Text="13." Value="13" />
                                                                <telerik:RadComboBoxItem Text="14." Value="14" />
                                                                <telerik:RadComboBoxItem Text="15." Value="15" />
                                                                <telerik:RadComboBoxItem Text="16." Value="16" />
                                                                <telerik:RadComboBoxItem Text="17." Value="17" />
                                                                <telerik:RadComboBoxItem Text="18." Value="18" />
                                                                <telerik:RadComboBoxItem Text="19." Value="19" />
                                                                <telerik:RadComboBoxItem Text="20." Value="20" />
                                                                <telerik:RadComboBoxItem Text="21." Value="21" />
                                                                <telerik:RadComboBoxItem Text="22." Value="22" />
                                                                <telerik:RadComboBoxItem Text="23." Value="23" />
                                                                <telerik:RadComboBoxItem Text="24." Value="24" />
                                                                <telerik:RadComboBoxItem Text="25." Value="25" />
                                                                <telerik:RadComboBoxItem Text="26." Value="26" />
                                                                <telerik:RadComboBoxItem Text="27." Value="27" />
                                                                <telerik:RadComboBoxItem Text="28." Value="28" />
                                                                <telerik:RadComboBoxItem Text="29." Value="29" />
                                                                <telerik:RadComboBoxItem Text="30." Value="30" />
                                                                <telerik:RadComboBoxItem Text="31." Value="31" />
                                                            </Items>
                                                        </telerik:RadComboBox>
                                                    </asp:Panel>

                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelExecutionTime" Text='<%$ Resources:Resource, lblExecutionTime %>' Font-Bold="true"></asp:Label>
                                            </td>
                                            <td colspan="2" nowrap="nowrap">
                                                <telerik:RadTimePicker ID="ExecutionTime" runat="server"  EnableShadows="true" DateInput-DisplayDateFormat="T" 
                                                                       DateInput-DateFormat="T" ShowPopupOnFocus="true" DbSelectedDate='<%# Bind("StartTime") %>'>
                                                    <TimeView runat="server" ShowHeader="true" HeaderText="<%$ Resources:Resource, lblExecutionTime %>" StartTime="00:00:00" Interval="01:00:00" EndTime="23:59:59" 
                                                              Columns="4" TimeFormat="T">
                                                    </TimeView>
                                                </telerik:RadTimePicker>
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="ExecutionTime" Text="*" SetFocusOnError="true" ForeColor="Red" ValidationGroup="Select" 
                                                                            ErrorMessage="<%$ Resources:Resource, errExecutionTimeRequired %>">
                                                </asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="LabelStartDate" runat="server" Text="<%$ Resources:Resource, lblStartDate %>"></asp:Label>
                                            </td>
                                            <td colspan="2" style="text-align: left; vertical-align: bottom">
                                                <telerik:RadDatePicker ID="StartDate" runat="server" EnableShadows="true" DbSelectedDate='<%# Bind("DateBegin") %>'
                                                                       ShowPopupOnFocus="true">
                                                    <Calendar runat="server">
                                                        <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                                                TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                                        </FastNavigationSettings>
                                                    </Calendar>
                                                </telerik:RadDatePicker>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="LabelEndDate" runat="server" Text="<%$ Resources:Resource, lblEndDate %>"></asp:Label>
                                            </td>
                                            <td colspan="2" style="text-align: left; vertical-align: bottom" nowrap="nowrap">
                                                <telerik:RadDatePicker ID="EndDate" runat="server" EnableShadows="true" DbSelectedDate='<%# Bind("DateEnd") %>' MaxDate="12-31-2100"
                                                                       ShowPopupOnFocus="true">
                                                    <Calendar runat="server">
                                                        <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                                                TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                                        </FastNavigationSettings>
                                                    </Calendar>
                                                </telerik:RadDatePicker>
                                                <asp:CompareValidator runat="server" ControlToValidate="EndDate" ControlToCompare="StartDate" ValueToCompare="SelectedDate" Operator="GreaterThanEqual"
                                                                      Text="*" SetFocusOnError="true" ForeColor="Red" ErrorMessage="<%$ Resources:Resource, msgDateFromLargerDateUntil %>" ValidationGroup="Select">
                                                </asp:CompareValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" Text="<%$ Resources:Resource, lblReceiver %>" Font-Bold="true"></asp:Label>
                                            </td>
                                            <td colspan="2" nowrap="nowrap">
                                                <asp:HiddenField runat="server" ID="ReceiverValue" Value='<%# Bind("Receiver") %>' />
                                                <telerik:RadAutoCompleteBox runat="server" ID="Receiver" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataValueField="UserID"
                                                                            DataSourceID="SqlDataSource_Users" DataTextField="UserName" InputType="Token" Width="500px" ShowLoadingIcon="true" Filter="Contains" 
                                                                            HighlightFirstMatch="true" AllowCustomEntry="true" DropDownHeight="300px" Delimiter=";" OnEntryAdded="Receiver_EntryAdded" 
                                                                            OnEntryRemoved="Receiver_EntryRemoved">
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
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="Receiver" Text="*" SetFocusOnError="true" ForeColor="Red" ValidationGroup="Select" 
                                                                            ErrorMessage="<%$ Resources:Resource, errReceiverRequired %>">
                                                </asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelTerminationMessage" Text='<%# String.Concat(Resources.Resource.lblMessage, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="TerminationMessage" Text='<%# Eval("TerminationMessage") %>'></asp:Label>&nbsp;
                                            </td>
                                        </tr>

                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
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
                    </div>
                </FormTemplate>
            </EditFormSettings>

            <%--#################################################################################### View Template ########################################################################################################--%>
            <NestedViewTemplate>
                <asp:Panel runat="server" ID="InnerContainer" Visible="false">
                    <fieldset style="padding: 10px; width: 500px; margin-left: 10px; margin-bottom: 10px;">
                        <legend style="padding: 5px; background-color: transparent;">
                            <b><%= Resources.Resource.lblDetailsFor %> <%# Eval("NameVisible") %></b>
                        </legend>
                        <table id="Table1" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                            <tr>
                                <td>
                                    <asp:Label runat="server" ID="LabelJobID" Text='<%# String.Concat(Resources.Resource.lblID, ":") %>'></asp:Label>
                                </td>
                                <td nowrap="nowrap">
                                    <asp:Label runat="server" ID="JobID" Text='<%# Eval("JobID") %>'></asp:Label>&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label runat="server" ID="LabelStatus" Text='<%# String.Concat(Resources.Resource.lblStatus, ":") %>'></asp:Label>
                                </td>
                                <td nowrap="nowrap">
                                    <asp:Label runat="server" ID="Status" Text='<%# InSite.App.Constants.Status.GetStatusString(Convert.ToInt32(Eval("StatusID"))) %>'></asp:Label>&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label runat="server" ID="LabelNameVisible" Text='<%# String.Concat(Resources.Resource.lblNameVisible, ":") %>'></asp:Label>
                                </td>
                                <td nowrap="nowrap">
                                    <asp:Label runat="server" ID="NameVisible" Text='<%# Eval("NameVisible") %>'></asp:Label>&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label runat="server" ID="LabelDescription" Text='<%# String.Concat(Resources.Resource.lblDescriptionShort, ":") %>'></asp:Label>
                                </td>
                                <td nowrap="nowrap">
                                    <asp:Label runat="server" ID="Description" Text='<%# Eval("Description") %>'></asp:Label>&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap" style="vertical-align: top;">
                                    <asp:Label runat="server" ID="LabelFrequency" Text='<%$ Resources:Resource, lblExecutionInterval %>'></asp:Label>
                                </td>
                                <td colspan="2">
                                    <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px;">
                                        <asp:HiddenField runat="server" ID="FrequencyValue" Value='<%# Eval("Frequency") %>'></asp:HiddenField>
                                        <asp:Label runat="server" ID="Frequency" Text='<%# GetFrequencyName(Convert.ToInt32(Eval("Frequency"))) %>'></asp:Label>&nbsp;
                                        <br />
                                        <br />
                                        <asp:Panel runat="server" ID="PanelWeekly" Visible="false">
                                            <asp:Label runat="server" ID="LabelWeekly" Text='<%$ Resources:Resource, lblValidDays %>'></asp:Label>
                                            <table>
                                                <tr>
                                                    <td>
                                                        <telerik:RadAjaxPanel runat="server">
                                                            <telerik:RadTextBox runat="server" ID="ValidDays" Text='<%# Eval("ValidDays") %>' Visible="false"></telerik:RadTextBox>
                                                            <table>
                                                                <tr>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:Label runat="server" Text="<%$ Resources:Resource, dayMo %>"></asp:Label>
                                                                    </td>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:Label runat="server" Text="<%$ Resources:Resource, dayTu %>"></asp:Label>
                                                                    </td>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:Label runat="server" Text="<%$ Resources:Resource, dayWe %>"></asp:Label>
                                                                    </td>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:Label runat="server" Text="<%$ Resources:Resource, dayTh %>"></asp:Label>
                                                                    </td>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:Label runat="server" Text="<%$ Resources:Resource, dayFr %>"></asp:Label>
                                                                    </td>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:Label runat="server" Text="<%$ Resources:Resource, daySa %>" ForeColor="Red"></asp:Label>
                                                                    </td>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:Label runat="server" Text="<%$ Resources:Resource, daySu %>" ForeColor="Red"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:CheckBox runat="server" ID="DayMo" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 0) %>' Enabled="false" 
                                                                                      Width="20px" Height="15px"/>
                                                                    </td>
                                                                    <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:CheckBox runat="server" ID="DayTu" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 1) %>' Enabled="false" 
                                                                                      Width="20px" Height="15px"/>
                                                                    </td>
                                                                    <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:CheckBox runat="server" ID="DayWe" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 2) %>' Enabled="false" 
                                                                                      Width="20px" Height="15px"/>
                                                                    </td>
                                                                    <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:CheckBox runat="server" ID="DayTh" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 3) %>' Enabled="false" 
                                                                                      Width="20px" Height="15px"/>
                                                                    </td>
                                                                    <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:CheckBox runat="server" ID="DayFr" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 4) %>' Enabled="false" 
                                                                                      Width="20px" Height="15px"/>
                                                                    </td>
                                                                    <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:CheckBox runat="server" ID="DaySa" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 5) %>' Enabled="false" 
                                                                                      Width="20px" Height="15px"/>
                                                                    </td>
                                                                    <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:CheckBox runat="server" ID="DaySu" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 6) %>' Enabled="false" 
                                                                                      Width="20px" Height="15px"/>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </telerik:RadAjaxPanel>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>

                                        <asp:Panel runat="server" ID="PanelMonthly" Visible="false">
                                            <asp:Label runat="server" ID="Label3" Text='<%$ Resources:Resource, lblDOM %>'></asp:Label>
                                            <br />
                                            <asp:Label runat="server" ID="DayOfMonth" Text='<%# Eval("DayOfMonth") %>'></asp:Label>&nbsp;
                                        </asp:Panel>

                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label runat="server" ID="LabelStartTime" Text='<%$ Resources:Resource, lblExecutionTime %>' Font-Bold="true"></asp:Label>
                                </td>
                                <td colspan="2" nowrap="nowrap">
                                    <asp:Label runat="server" ID="StartTime" Text='<%# Eval("StartTime") %>'></asp:Label>&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="LabelStartDate" runat="server" Text="<%$ Resources:Resource, lblStartDate %>"></asp:Label>
                                </td>
                                <td colspan="2" style="text-align: left; vertical-align: bottom">
                                    <asp:Label runat="server" ID="DateBegin" Text='<%# Eval("DateBegin") %>'></asp:Label>&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="LabelEndDate" runat="server" Text="<%$ Resources:Resource, lblEndDate %>"></asp:Label>
                                </td>
                                <td colspan="2" style="text-align: left; vertical-align: bottom" nowrap="nowrap">
                                    <asp:Label runat="server" ID="DateEnd" Text='<%# Eval("DateEnd") %>'></asp:Label>&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblNextExecution %>"></asp:Label>
                                </td>
                                <td colspan="2" nowrap="nowrap">
                                    <asp:Label ID="NextStart" runat="server" Text='<%# Eval("NextStart", "{0:G}") %>'></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblReceiver %>" Font-Bold="true"></asp:Label>
                                </td>
                                <td colspan="2" nowrap="nowrap">
                                    <asp:Label runat="server" ID="Receiver" Text='<%# Eval("Receiver") %>'></asp:Label>&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label runat="server" ID="LabelTerminationMessage" Text='<%# String.Concat(Resources.Resource.lblMessage, ":") %>'></asp:Label>
                                </td>
                                <td>
                                    <asp:Label runat="server" ID="TerminationMessage" Text='<%# Eval("TerminationMessage") %>'></asp:Label>&nbsp;
                                </td>
                            </tr>

                            <tr>
                                <td>&nbsp; </td>
                                <td>&nbsp; </td>
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
                    </fieldset>
                </asp:Panel>
            </NestedViewTemplate>
        </MasterTableView>

    </telerik:RadGrid>

    <asp:SqlDataSource ID="SqlDataSource_Jobs" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
        OldValuesParameterFormatString="original_{0}"
        SelectCommand="SELECT s_j.SystemID, s_j.JobID, s_j.NameVisible, s_j.Description, s_j.JobType, s_j.BpID, s_j.UserID, s_j.Frequency, s_j.RepeatEvery, s_j.ValidDays, s_j.DayOfMonth, s_j.DateBegin, s_j.DateEnd, s_j.StartTime, s_j.NextStart, s_j.Started, s_j.Terminated, s_j.StatusID, s_j.TerminationMessage, s_j.JobUrl, s_j.JobParameter, s_j.JobLanguage, s_j.Receiver, s_j.CreatedFrom, s_j.CreatedOn, s_j.EditFrom, s_j.EditOn, m_u.FirstName, m_u.LastName, m_u.LoginName, m_u.LanguageID, dbo.GetTemplateNameFromParams(s_j.JobParameter) AS TemplateName FROM System_Jobs AS s_j INNER JOIN Master_Users AS m_u ON s_j.SystemID = m_u.SystemID AND s_j.UserID = m_u.UserID WHERE (s_j.SystemID = @SystemID) AND (s_j.BpID = @BpID) AND (s_j.UserID = (CASE WHEN @UserType >= 50 THEN s_j.UserID ELSE @UserID END))"
        DeleteCommand="DELETE FROM System_Jobs WHERE (SystemID = @original_SystemID) AND (JobID = @original_JobID)"
        UpdateCommand="UPDATE System_Jobs SET NameVisible = @NameVisible, Description = @Description, Frequency = @Frequency, RepeatEvery = @RepeatEvery, ValidDays = @ValidDays, DayOfMonth = @DayOfMonth, DateBegin = @DateBegin, DateEnd = @DateEnd, StartTime = @StartTime, NextStart = @NextStart, StatusID = @StatusID, TerminationMessage = @TerminationMessage, Receiver = @Receiver, EditFrom = @UserName, EditOn = SYSDATETIME() WHERE (SystemID = @original_SystemID) AND (JobID = @original_JobID)">
        <DeleteParameters>
            <asp:Parameter Name="original_SystemID"></asp:Parameter>
            <asp:Parameter Name="original_JobID"></asp:Parameter>
        </DeleteParameters>
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="UserType" DefaultValue="0" Name="UserType"></asp:SessionParameter>
            <asp:SessionParameter SessionField="UserID" DefaultValue="0" Name="UserID"></asp:SessionParameter>
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="NameVisible"></asp:Parameter>
            <asp:Parameter Name="Description"></asp:Parameter>
            <asp:Parameter Name="Frequency"></asp:Parameter>
            <asp:Parameter Name="RepeatEvery" DefaultValue="1"></asp:Parameter>
            <asp:Parameter Name="ValidDays"></asp:Parameter>
            <asp:Parameter Name="DayOfMonth" DefaultValue="0"></asp:Parameter>
            <asp:Parameter Name="DateBegin"></asp:Parameter>
            <asp:Parameter Name="DateEnd"></asp:Parameter>
            <asp:Parameter Name="StartTime"></asp:Parameter>
            <asp:Parameter Name="NextStart"></asp:Parameter>
            <asp:Parameter Name="StatusID"></asp:Parameter>
            <asp:Parameter Name="TerminationMessage"></asp:Parameter>
            <asp:Parameter Name="Receiver"></asp:Parameter>
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
            <asp:Parameter Name="original_SystemID"></asp:Parameter>
            <asp:Parameter Name="original_JobID"></asp:Parameter>
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Users" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT m_u.SystemID, m_u.UserID, m_u.FirstName, m_u.LastName, m_u.LoginName, m_u.Email, s_c.NameVisible AS Company, s_c.NameAdditional, m_u.LoginName COLLATE Latin1_General_CI_AS + ': ' + m_u.LastName + ', ' + m_u.FirstName + (CASE WHEN s_c.NameVisible IS NULL THEN '' ELSE (' (' + s_c.NameVisible + ')') END) AS UserName FROM Master_Users AS m_u LEFT OUTER JOIN System_Companies AS s_c ON m_u.SystemID = s_c.SystemID AND m_u.CompanyID = s_c.CompanyID WHERE (m_u.SystemID = @SystemID) AND (m_u.LockedOn IS NULL) AND (m_u.ReleaseOn IS NOT NULL) ORDER BY m_u.LastName, m_u.FirstName, Company">
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
