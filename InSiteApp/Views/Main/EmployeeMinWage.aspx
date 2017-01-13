<%@ Page Title="<%$ Resources:Resource, lblMinWageDataEntry %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EmployeeMinWage.aspx.cs" Inherits="InSite.App.Views.Main.EmployeeMinWage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">

    <telerik:RadCodeBlock runat="server">
        <script type="text/javascript">
            var batchEdit, masterBatch

            function KeyPress(sender, args) {
                var keyCode = args.get_keyCode();
                if (keyCode === 13 || keyCode === 38 || keyCode === 40 || keyCode === 9) {
                    // Enter, Up, Down, Tab
                    args.set_cancel(true);
                    args.get_domEvent().stopPropagation();
                    args.get_domEvent().preventDefault();

                    batchEdit = sender.get_batchEditingManager();
                    var row = batchEdit.get_currentlyEditedRow();
                    masterBatch = sender.get_masterTableView();

                    var nextRow = null;
                    if (keyCode === 38) {
                        // Up
                        nextRow = row.previousSibling;
                    } else {
                        nextRow = row.nextSibling;
                    }

                    if (nextRow.className !== "rgNoRecords") {
                        masterBatch.selectItem(nextRow);
                        batchEdit.openRowForEdit(nextRow);
                    } else if (keyCode === 13 && batchEdit.hasChanges(masterBatch)) {
                        // Enter
                        batchEdit.saveChanges(masterBatch);
                        var currentPageIndex = masterBatch.get_currentPageIndex();
                        if (currentPageIndex < masterBatch.get_pageCount() - 1) {
                            // masterBatch.page("Next");
                            // var nextIndex = (currentPageIndex) * masterBatch.get_pageSize();
                            // var rows = masterBatch.get_dataItems();
                            // nextRow = rows[nextIndex];
                            // masterBatch.selectItem(nextRow);
                            // batchEdit.openRowForEdit(nextRow);
                        }
                    }
                } else if (keyCode === 27) {
                    // Escape
                    batchEdit = sender.get_batchEditingManager();
                    masterBatch = sender.get_masterTableView();

                    if (batchEdit.hasChanges(masterBatch)) {
                        args.set_cancel(true);
                        args.get_domEvent().stopPropagation();
                        args.get_domEvent().preventDefault();

                        radconfirm("<%= Resources.Resource.qstLooseChanges %>", confirmCallBackBatchEscape, 330, 180, null, "<%= Resources.Resource.lblMinWageDataEntry %>");
                    }
                }
            }

            function confirmCallBackBatchEscape(arg) {
                if (arg) {
                    batchEdit.cancelChanges(masterBatch);
                }
            }

            function CellValueChanged(sender, args) {
                var amount = args.get_editorValue().replace(",", ".");
                var row = args.get_row();
                var columnName = args.get_columnUniqueName();
                if (columnName === "Amount") {
                    var wage_C = $telerik.findElement(row, "Wage_C").innerHTML.replace(",", ".");
                    var wage_E = $telerik.findElement(row, "Wage_E").innerHTML.replace(",", ".");
                    var status = $telerik.findElement(row, "StatusCode").innerHTML;
                    if (wage_C !== null && wage_E !== null && amount !== null && status !== null) {
                        if (parseFloat(amount) >= parseFloat(wage_C) && parseFloat(amount) >= parseFloat(wage_E)) {
                            // Alles ok (2)
                            $telerik.findElement(row, "StatusCode").innerHTML = "<%= Resources.Resource.selStatusCode2 %>";
                        } else if (parseFloat(amount) === 0) {
                            // Offen (1)
                            $telerik.findElement(row, "StatusCode").innerHTML = "<%= Resources.Resource.selStatusCode1 %>";
                        } else if (parseFloat(amount) < 0) {
                            // Falsch (5)
                            $telerik.findElement(row, "StatusCode").innerHTML = "<%= Resources.Resource.selStatusCode5 %>";
                        } else if (parseFloat(amount) >= parseFloat(wage_C) && parseFloat(amount) < parseFloat(wage_E)) {
                            // Zu niedrig (4)
                            $telerik.findElement(row, "StatusCode").innerHTML = "<%= Resources.Resource.selStatusCode4 %>";
                        } else if (parseFloat(amount) < parseFloat(wage_C)) {
                            // Fehlerhaft (3)
                            $telerik.findElement(row, "StatusCode").innerHTML = "<%= Resources.Resource.selStatusCode3 %>";
                        } else {
                            // Initialisiert (0)
                            $telerik.findElement(row, "StatusCode").innerHTML = "";
                        }
                        var nextRow = row.nextSibling;
                        if (nextRow.className !== "rgNoRecords") {
                            var batch = sender.get_batchEditingManager();
                            var master = sender.get_masterTableView();
                            master.selectItem(nextRow);
                            batch.openRowForEdit(nextRow);
                        }
                    }
                }
            }
            
            function UserAction(sender, args) {
                if (sender.get_batchEditingManager().hasChanges(sender.get_masterTableView()) && !confirm("<%= Resources.Resource.qstLooseChanges %>")) {
                    args.set_cancel(true);
                }
            }

            function EditEmployee(sender, args) {
                var grid = $find("<%= RadGrid1.ClientID %>");
                if (grid.get_batchEditingManager().hasChanges(grid.get_masterTableView()) && !confirm("<%= Resources.Resource.qstLooseChanges %>")) {
                    args.set_cancel(true);
                } else {
                    grid.get_masterTableView().fireCommand("EditEmployee", args);
                }
            }
        </script>
    </telerik:RadCodeBlock>
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
            <telerik:AjaxSetting AjaxControlID="CompanyID">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                    <telerik:AjaxUpdatedControl ControlID="CompanyID" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <div style="background-color: InactiveBorder;">
        <table>
            <tr>
                <td style="padding: 5px; vertical-align: top; width: 200px;">
                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblCompany %>" Font-Bold="true"></asp:Label>
                    <br />
                    <asp:Label runat="server" Text="<%$ Resources:Resource, msgSelectCompany %>"></asp:Label>
                </td>
                <td style="padding: 5px; vertical-align: top;">
                    <telerik:RadComboBox runat="server" ID="CompanyID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                         DataSourceID="SqlDataSource_Companies" DataValueField="CompanyID" DataTextField="CompanyName" Width="700" 
                                         AppendDataBoundItems="true" Filter="Contains" DropDownAutoWidth="Enabled" OnClientKeyPressing="OnClientKeyPressing"
                                         OnSelectedIndexChanged="CompanyID_SelectedIndexChanged" AutoPostBack="true" CausesValidation="false">
                    </telerik:RadComboBox>
                </td>
                <td style="border-right-color: ActiveBorder; border-right-style: solid; border-right-width: 1px;">&nbsp;</td>
                <td>&nbsp;</td>
                <td>
                    <telerik:RadButton ID="UpdateStatus" runat="server" Text="" ToolTip='<%$ Resources:Resource, lblUpdateStatus %>' 
                                       ButtonType="SkinnedButton" Visible="true" BorderStyle="None" BackColor="Transparent" Height="30px" Width="30px" AutoPostBack="true"
                                       OnClick="UpdateStatus_Click">
                        <Icon PrimaryIconUrl="../../Resources/Icons/undefined-24.png" PrimaryIconHeight="24px" PrimaryIconWidth="24px" />
                    </telerik:RadButton>
                </td>
            </tr>
        </table>
    </div>

    <telerik:RadGrid ID="RadGrid1" runat="server" AutoGenerateColumns="False" GroupPanelPosition="Top" DataSourceID="SqlDataSource_EmployeeMinWage"
        AllowAutomaticUpdates="True" CssClass="MainGrid" PageSize="20" AllowPaging="true"
        OnItemUpdated="RadGrid1_ItemUpdated" OnPreRender="RadGrid1_PreRender" OnItemDataBound="RadGrid1_ItemDataBound" OnItemCommand="RadGrid1_ItemCommand"
        OnItemCreated="RadGrid1_ItemCreated" Culture="de-DE">

        <GroupPanel Text="<%$ Resources:Resource, msgGroupPanel %>">
        </GroupPanel>

        <GroupingSettings ShowUnGroupButton="True" CaseSensitive="false" />

        <ExportSettings FileName="EmployeeMinWage" ExportOnlyData="True">
            <Pdf PaperSize="A4" PageWidth="" PageHeight=""></Pdf>

            <Excel Format="Xlsx" FileExtension="xlsx"></Excel>

            <Csv ColumnDelimiter="Semicolon"></Csv>
        </ExportSettings>

        <ClientSettings AllowKeyboardNavigation="false" AllowColumnsReorder="true" AllowDragToGroup="True" >
            <Resizing AllowColumnResize="true"></Resizing>
            <Selecting AllowRowSelect="true"></Selecting>
            <ClientEvents OnKeyPress="KeyPress" OnUserAction="UserAction" OnBatchEditCellValueChanged ="CellValueChanged" />
        </ClientSettings>

        <SortingSettings SortedBackColor="Transparent" />

        <MasterTableView DataKeyNames="SystemID,BpID,EmployeeID,MWMonth" DataSourceID="SqlDataSource_EmployeeMinWage" EditMode="Batch" CssClass="MasterClass"
                         CommandItemDisplay="TopAndBottom" AllowMultiColumnSorting="true" NoMasterRecordsText="<%$ Resources:Resource, msgNoDataFound %>"
                         AllowSorting="true" AllowFilteringByColumn="true" AllowPaging="true" ShowHeader="true" Caption="<%$ Resources:Resource, lblMWAttestations %>"
                         AutoGenerateColumns="false">

            <PagerStyle PageSizes="10,20,50,100" AlwaysVisible="true" />

            <SortExpressions>
                <telerik:GridSortExpression FieldName="LastName" SortOrder="Ascending"></telerik:GridSortExpression>
                <telerik:GridSortExpression FieldName="FirstName" SortOrder="Ascending"></telerik:GridSortExpression>
                <telerik:GridSortExpression FieldName="MWMonth" SortOrder="Ascending"></telerik:GridSortExpression>
            </SortExpressions>

            <CommandItemSettings ShowAddNewRecordButton="false" ShowRefreshButton="true" />

            <BatchEditingSettings EditType="Row" OpenEditingEvent="Click" />

            <Columns>

                <telerik:GridTemplateColumn DataField="EmployeeID" Visible="false" InsertVisiblityMode="AlwaysHidden" DataType="System.Int32"
                                            FilterControlAltText="Filter EmployeeID column" HeaderText="<%$ Resources:Resource, lblID %>"
                                            SortExpression="EmployeeID" UniqueName="EmployeeID" 
                                            GroupByExpression="EmployeeID EmployeeID GROUP BY EmployeeID">
                    <EditItemTemplate>
                        <asp:Label runat="server" ID="EmployeeID" Text='<%# Eval("EmployeeID") %>'></asp:Label>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" ID="EmployeeID" Text='<%# Eval("EmployeeID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="LastName" HeaderText="<%$ Resources:Resource, lblAddrLastName %>" SortExpression="LastName" UniqueName="LastName"
                                            GroupByExpression="LastName LastName GROUP BY LastName" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px"
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="LastName" Text='<%# Eval("LastName") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="FirstName" HeaderText="<%$ Resources:Resource, lblAddrFirstName %>" SortExpression="FirstName" UniqueName="FirstName"
                                            GroupByExpression="FirstName FirstName GROUP BY FirstName" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px"
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="FirstName" Text='<%# Eval("FirstName") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Amount" HeaderText="<%$ Resources:Resource, lblAmount %>" SortExpression="Amount" UniqueName="Amount" 
                                            GroupByExpression="Amount Amount GROUP BY Amount" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right"
                                            HeaderStyle-Width="120px" ItemStyle-Width="120px">
                    <EditItemTemplate>
                        <telerik:RadTextBox runat="server" ID="Amount" Text='<%# Bind("Amount", "{0:#,##0.00}") %>' SelectionOnFocus="SelectAll" EnabledStyle-HorizontalAlign="Right" 
                                            AutoCompleteType="Disabled" Width="100px">
                        </telerik:RadTextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Amount" Text='<%# Eval("Amount", "{0:#,##0.00}") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Wage_C" HeaderText="" UniqueName="Wage_C" AllowFiltering="false" Resizable="true" ItemStyle-ForeColor="Transparent"  
                                            Visible="true" ForceExtractValue="Always" FilterControlWidth="0px" AllowSorting="false" HeaderStyle-Width="0px" ItemStyle-Width="0px">
                    <EditItemTemplate>
                        <asp:Label runat="server" ID="Wage_C" Text='<%# Eval("Wage_C", "{0:#,##0.00}") %>' Width="0px"></asp:Label>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Wage_C" Text='<%# Eval("Wage_C", "{0:#,##0.00}") %>' Width="0px"></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Wage_E" HeaderText="" UniqueName="Wage_E" AllowFiltering="false" Resizable="true" ItemStyle-ForeColor="Transparent" 
                                            Visible="true" ForceExtractValue="Always" FilterControlWidth="0px" AllowSorting="false" HeaderStyle-Width="0px" ItemStyle-Width="0px">
                    <EditItemTemplate>
                        <asp:Label runat="server" ID="Wage_E" Text='<%# Eval("Wage_E", "{0:#,##0.00}") %>' Width="0px"></asp:Label>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Wage_E" Text='<%# Eval("Wage_E", "{0:#,##0.00}") %>' Width="0px"></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="StatusCode" DataType="System.Byte" FilterControlAltText="Filter PresentType column" HeaderText="<%$ Resources:Resource, lblStatus %>" 
                                            SortExpression="StatusCode" UniqueName="StatusCode" Visible="true" ItemStyle-Wrap="false" DefaultInsertValue="0" FilterControlWidth="80px"
                                            AutoPostBackOnFilter="true" HeaderStyle-Width="120px" ItemStyle-Width="120px" >
                    <ItemTemplate>
                        <asp:Label runat="server" ID="StatusCode" Text='<%# GetMWStatus(Convert.ToInt32(Eval("StatusCode"))) %>'></asp:Label>
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="StatusCode" DataValueField="StatusCode" Height="200px" AppendDataBoundItems="true"
                                             SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("StatusCode").CurrentFilterValue %>'
                                             runat="server" OnClientSelectedIndexChanged="StatusCodeIndexChanged" DropDownAutoWidth="Enabled" Width="80px">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" Selected="true" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selStatusCode0 %>" Value="0" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selStatusCode1 %>" Value="1" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selStatusCode2 %>" Value="2" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selStatusCode3 %>" Value="3" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selStatusCode4 %>" Value="4" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selStatusCode5 %>" Value="5" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock10" runat="server">
                            <script type="text/javascript">
                                function StatusCodeIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    tableView.filter("StatusCode", args.get_item().get_value(), "EqualTo");
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridDateTimeColumn FilterControlWidth="100px" DataField="MWMonth" HeaderText="<%$ Resources:Resource, lblMonth %>" SortExpression="MWMonth"
                                            UniqueName="MWMonth" PickerType="DatePicker" EnableRangeFiltering="true" HeaderStyle-Width="170px" ItemStyle-Width="170px" CurrentFilterFunction="Between" 
                                            AutoPostBackOnFilter="true" DataFormatString="{0:MMM yyyy}" ReadOnly="true" EnableTimeIndependentFiltering="true">
                </telerik:GridDateTimeColumn>

                <telerik:GridDateTimeColumn FilterControlWidth="100px" DataField="BirthDate" HeaderText="<%$ Resources:Resource, lblAddrBirthDate %>" SortExpression="BirthDate"
                                            UniqueName="BirthDate" PickerType="DatePicker" EnableRangeFiltering="true" HeaderStyle-Width="170px" ItemStyle-Width="170px" CurrentFilterFunction="Between" 
                                            AutoPostBackOnFilter="true" DataFormatString="{0:d}" ReadOnly="true" EnableTimeIndependentFiltering="true">
                </telerik:GridDateTimeColumn>

                <telerik:GridTemplateColumn UniqueName="ImageButton" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="30px"  HeaderStyle-Width="30px" AllowFiltering="false" AllowSorting="false">
                    <EditItemTemplate>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <telerik:RadButton ID="EditEmployee" runat="server" ButtonType="ToggleButton" CausesValidation="false" AutoPostBack="false"
                                           ToolTip="<%$ Resources:Resource, msgShowDetails %>" Width="16px" Height="16px">
                            <Image ImageUrl="/InSiteApp/Resources/Icons/Staff_16.png" />
                        </telerik:RadButton>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
            </Columns>
        </MasterTableView>
    </telerik:RadGrid>

    <asp:SqlDataSource runat="server" ID="SqlDataSource_EmployeeMinWage" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
        OldValuesParameterFormatString="original_{0}"
        SelectCommand="SELECT DISTINCT d_emw.SystemID, d_emw.BpID, d_emw.EmployeeID, d_emw.MWMonth, d_emw.PresenceSeconds, d_emw.StatusCode, d_emw.Amount, d_emw.RequestListID, d_emw.CreatedFrom, d_emw.CreatedOn, d_emw.EditFrom, d_emw.EditOn, m_a.FirstName, m_a.LastName, m_a.BirthDate, m_e.CompanyID, d_emw.RequestedFrom, d_emw.RequestedOn, d_emw.ReceivedFrom, d_emw.ReceivedOn, MIN(ISNULL(s_tw_c.Wage, 0)) AS Wage_C, MIN(ISNULL(s_tw_e.Wage, 0)) AS Wage_E, MAX(m_ewga.ValidFrom) AS ValidFrom_E, MAX(s_tw_c.ValidFrom) AS ValidFrom_C FROM Master_CompanyTariffs AS m_ct LEFT OUTER JOIN System_TariffWageGroups AS s_twg_c LEFT OUTER JOIN System_TariffWages AS s_tw_c ON s_twg_c.SystemID = s_tw_c.SystemID AND s_twg_c.TariffID = s_tw_c.TariffID AND s_twg_c.TariffContractID = s_tw_c.TariffContractID AND s_twg_c.TariffScopeID = s_tw_c.TariffScopeID AND s_twg_c.TariffWageGroupID = s_tw_c.TariffWageGroupID ON m_ct.SystemID = s_twg_c.SystemID AND m_ct.TariffScopeID = s_twg_c.TariffScopeID RIGHT OUTER JOIN Data_EmployeeMinWage AS d_emw INNER JOIN Master_Employees AS m_e ON d_emw.SystemID = m_e.SystemID AND d_emw.BpID = m_e.BpID AND d_emw.EmployeeID = m_e.EmployeeID INNER JOIN Master_Addresses AS m_a ON m_e.SystemID = m_a.SystemID AND m_e.BpID = m_a.BpID AND m_e.AddressID = m_a.AddressID ON m_ct.SystemID = m_e.SystemID AND m_ct.BpID = m_e.BpID AND m_ct.CompanyID = m_e.CompanyID LEFT OUTER JOIN System_TariffWages AS s_tw_e RIGHT OUTER JOIN Master_EmployeeWageGroupAssignment AS m_ewga ON s_tw_e.SystemID = m_ewga.SystemID AND s_tw_e.TariffWageGroupID = m_ewga.TariffWageGroupID ON d_emw.SystemID = m_ewga.SystemID AND d_emw.BpID = m_ewga.BpID AND d_emw.EmployeeID = m_ewga.EmployeeID GROUP BY d_emw.SystemID, d_emw.EmployeeID, d_emw.MWMonth, d_emw.PresenceSeconds, d_emw.StatusCode, d_emw.Amount, d_emw.RequestListID, d_emw.CreatedFrom, d_emw.CreatedOn, d_emw.EditFrom, d_emw.EditOn, m_a.FirstName, m_a.LastName, m_a.BirthDate, d_emw.RequestedFrom, d_emw.RequestedOn, d_emw.ReceivedFrom, d_emw.ReceivedOn, d_emw.BpID, m_e.CompanyID HAVING (MAX(m_ewga.ValidFrom) <= CAST(d_emw.MWMonth AS datetime) OR MAX(m_ewga.ValidFrom) IS NULL) AND (d_emw.SystemID = @SystemID) AND (d_emw.BpID = @BpID) AND (m_e.CompanyID = @CompanyID) OR (d_emw.SystemID = @SystemID) AND (d_emw.BpID = @BpID) AND (m_e.CompanyID = @CompanyID) AND (MAX(s_tw_c.ValidFrom) <= CAST(d_emw.MWMonth AS datetime) OR MAX(s_tw_c.ValidFrom) IS NULL)"
        UpdateCommand="UPDATE [Data_EmployeeMinWage] SET [Amount] = @Amount, StatusCode = (CASE WHEN @Amount >= @Wage_C AND @Amount >= @Wage_E THEN 2 WHEN @Amount = 0 THEN 1 WHEN @Amount < 0 THEN 5 WHEN @Amount >= @Wage_C AND @Amount < @Wage_E THEN 4 WHEN @Amount < @Wage_C THEN 3 ELSE 0 END), [EditFrom] = @UserName, [EditOn] = SYSDATETIME(), [ReceivedFrom] = @UserName, [ReceivedOn] = SYSDATETIME() WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [EmployeeID] = @original_EmployeeID AND [MWMonth] = @original_MWMonth">
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
            <asp:Parameter DefaultValue="0" Name="CompanyID"></asp:Parameter>
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="Amount" Type="Decimal"></asp:Parameter>
            <asp:Parameter Name="Wage_C" Type="Decimal"></asp:Parameter>
            <asp:Parameter Name="Wage_E" Type="Decimal"></asp:Parameter>
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
            <asp:Parameter Name="original_SystemID" Type="Int32" />
            <asp:Parameter Name="original_BpID" Type="Int32" />
            <asp:Parameter Name="original_EmployeeID" Type="Int32" />
            <asp:Parameter Name="original_MWMonth" Type="DateTime" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Companies" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
        SelectCommand="SELECT c.SystemID, c.BpID, c.CompanyID, (CASE WHEN @CompanyID > 0 THEN NULL ELSE (CASE WHEN c.ParentID = 0 THEN NULL ELSE c.ParentID END) END) AS ParentID, s_c.NameVisible, s_c.NameAdditional, c.Description, c.AddressID, c.IsVisible, c.IsValid, c.TradeAssociation, c.BlnSOKA, c.CreatedFrom, c.CreatedOn, c.EditFrom, c.EditOn, a.Address1, a.Address2, a.Zip, a.City, a.State, a.CountryID, a.Phone, a.Email, a.WWW, s_c.NameVisible + (CASE WHEN s_c.NameAdditional IS NULL THEN '' ELSE ', ' + s_c.NameAdditional END) + (CASE WHEN a.Address1 IS NULL THEN '' ELSE ', ' + a.Address1 END) + (CASE WHEN a.Zip IS NULL THEN '' ELSE ', ' + a.Zip END) + (CASE WHEN a.City IS NULL THEN '' ELSE ' ' + a.City END) AS CompanyName FROM Master_Companies AS c INNER JOIN System_Companies AS s_c ON c.SystemID = s_c.SystemID AND c.CompanyCentralID = s_c.CompanyID LEFT OUTER JOIN System_Addresses AS a ON c.SystemID = a.SystemID AND c.AddressID = a.AddressID WHERE (c.SystemID = @SystemID) AND (c.BpID = @BpID) AND (c.ReleaseOn IS NOT NULL) AND (c.LockedOn IS NULL) AND (c.CompanyCentralID = (CASE WHEN @CompanyID = 0 THEN c.CompanyCentralID ELSE @CompanyID END)) AND (c.MinWageAttestation = 1) ORDER BY s_c.NameVisible">
        <SelectParameters>
            <asp:SessionParameter SessionField="CompanyID" DefaultValue="0" Name="CompanyID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
