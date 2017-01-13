<%@ Page Title="<%$ Resources:Resource, lblDocumentCheckingRules %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DocumentCheckingRules.aspx.cs" Inherits="InSite.App.Views.Configuration.DocumentCheckingRules" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <telerik:RadScriptBlock ID="RadCodeBlock1" runat="server">
        <script type="text/javascript">
            function OnSingleRowClick(sender, args) {
                if (editedRow !== null && hasChanges) {
                    if (confirm('<%= Resources.Resource.qstSaveChanges %>')) {
                        hasChanges = false;
                        sender.get_masterTableView().updateItem(editedRow);
                    } else {
                        hasChanges = false;
                        sender.get_masterTableView().cancelUpdate(editedRow);
                    }
                } else {
                    var _args = "Expand|" + args.get_tableView().get_id() + "|" + args.get_itemIndexHierarchical();
                    sender.get_masterTableView().fireCommand("RowClick", _args);
                }
            }
        </script>
    </telerik:RadScriptBlock>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <telerik:RadPersistenceManagerProxy ID="RadPersistenceManagerProxy1" runat="server">
        <PersistenceSettings>
            <telerik:PersistenceSetting ControlID="RadGrid1" />
        </PersistenceSettings>
    </telerik:RadPersistenceManagerProxy>

    <telerik:RadGrid ID="RadGrid1" runat="server" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowSorting="true"
                     CellSpacing="0" GridLines="None" CssClass="MainGrid"
                     EnableAjaxSkinRendering="true" AllowPaging="true"
                     OnItemInserted="RadGrid1_ItemInserted" OnPreRender="RadGrid1_PreRender" OnItemDataBound="RadGrid1_ItemDataBound" OnItemCreated="RadGrid1_ItemCreated"
                     OnItemDeleted="RadGrid1_ItemDeleted" OnItemUpdated="RadGrid1_ItemUpdated" DataSourceID="SqlDataSource_EmployerCountryGroup" OnItemCommand="RadGrid1_ItemCommand"
                     OnDetailTableDataBind="RadGrid1_DetailTableDataBind" OnInsertCommand="RadGrid1_InsertCommand" OnGroupsChanging="RadGrid1_GroupsChanging">

        <ExportSettings ExportOnlyData="true" IgnorePaging="true">
            <Pdf PaperSize="A4">
            </Pdf>
            <Excel Format="ExcelML" />
        </ExportSettings>

        <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false" AllowKeyboardNavigation="true">
            <Resizing AllowColumnResize="true"></Resizing>
            <Selecting AllowRowSelect="true"></Selecting>
            <KeyboardNavigationSettings EnableKeyboardShortcuts="true" AllowSubmitOnEnter="true"
                                        AllowActiveRowCycle="true" CollapseDetailTableKey="LeftArrow" ExpandDetailTableKey="RightArrow">
            </KeyboardNavigationSettings>
            <ClientEvents OnRowClick="OnSingleRowClick" OnGridCreated="OnGridCreated" OnKeyPress="GridKeyPress" />
        </ClientSettings>

        <%-- Employer country group --%>
        <SortingSettings SortedBackColor="Transparent" />

        <MasterTableView Name="EmployerCountryGroup" EnableHierarchyExpandAll="true" CssClass="MasterClass" EditMode="EditForms" AutoGenerateColumns="False" DataKeyNames="SystemID,BpID,CountryGroupIDEmployer"
                         DataSourceID="SqlDataSource_EmployerCountryGroup" EnableHeaderContextMenu="true" ShowHeader="true" Caption="<%$ Resources:Resource, lblEmployerCountryGroup %>"
                         HierarchyLoadMode="ServerOnDemand" CommandItemDisplay="Top">

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

            <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="False" ShowExportToExcelButton="True" ShowExportToPdfButton="False"
                                 AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

            <DetailTables>
                <%-- Employee country group --%>
                <telerik:GridTableView EnableHierarchyExpandAll="true" DataKeyNames="SystemID,BpID,CountryGroupIDEmployer,CountryGroupIDEmployee" DataSourceID="SqlDataSource_EmployeeCountryGroup" Width="100%"
                                       runat="server" CommandItemDisplay="None" Name="EmployeeCountryGroup" AutoGenerateColumns="false" ShowHeader="true" Caption="<%$ Resources:Resource, lblEmployeeCountryGroup %>"
                                       AllowPaging="true" EditMode="EditForms" HierarchyLoadMode="ServerOnDemand">

                    <ParentTableRelation>
                        <telerik:GridRelationFields DetailKeyField="SystemID" MasterKeyField="SystemID"></telerik:GridRelationFields>
                        <telerik:GridRelationFields DetailKeyField="BpID" MasterKeyField="BpID"></telerik:GridRelationFields>
                        <telerik:GridRelationFields DetailKeyField="CountryGroupIDEmployer" MasterKeyField="CountryGroupIDEmployer"></telerik:GridRelationFields>
                    </ParentTableRelation>

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

                    <DetailTables>
                        <%-- Document checking rules --%>
                        <telerik:GridTableView EnableHierarchyExpandAll="true" DataKeyNames="SystemID,BpID,CountryGroupIDEmployer,CountryGroupIDEmployee,EmploymentStatusID" DataSourceID="SqlDataSource_DocumentCheckingRules"
                                               Width="100%" runat="server" CommandItemDisplay="Top" Name="DocumentCheckingRules" AutoGenerateColumns="false" ShowHeader="true" Caption="<%$ Resources:Resource, lblDocumentCheckingRules %>"
                                               AllowPaging="true" EditMode="PopUp" AllowFilteringByColumn="false" HierarchyLoadMode="ServerOnDemand" AllowAutomaticInserts="false" AllowAutomaticDeletes="true" 
                                               AllowAutomaticUpdates="true">

                            <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="false" ShowExportToExcelButton="false" ShowExportToPdfButton="false"
                                                 AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                            <ParentTableRelation>
                                <telerik:GridRelationFields DetailKeyField="SystemID" MasterKeyField="SystemID"></telerik:GridRelationFields>
                                <telerik:GridRelationFields DetailKeyField="BpID" MasterKeyField="BpID"></telerik:GridRelationFields>
                                <telerik:GridRelationFields DetailKeyField="CountryGroupIDEmployer" MasterKeyField="CountryGroupIDEmployer"></telerik:GridRelationFields>
                                <telerik:GridRelationFields DetailKeyField="CountryGroupIDEmployee" MasterKeyField="CountryGroupIDEmployee"></telerik:GridRelationFields>
                            </ParentTableRelation>

                            <EditFormSettings CaptionDataField="EmploymentStatusName" CaptionFormatString="{0}">
                                <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                                <EditColumn ButtonType="ImageButton" UniqueName="EditColumn1" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                                            EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                                <FormTableStyle CellPadding="3" CellSpacing="3" />
                            </EditFormSettings>

                            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

                            <SortExpressions>
                                <telerik:GridSortExpression FieldName="EmploymentStatusName" SortOrder="Ascending"></telerik:GridSortExpression>
                            </SortExpressions>

                            <Columns>
                                <%-- Document checking rule --%>
                <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                               UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                    <ItemStyle BackColor="Control" Width="30px" />
                    <HeaderStyle Width="30px" />
                </telerik:GridEditCommandColumn>

                                <telerik:GridTemplateColumn DataField="EmploymentStatusID" HeaderText="<%$ Resources:Resource, lblEmploymentStatus %>" SortExpression="EmploymentStatusID" UniqueName="EmploymentStatusID"
                                                            GroupByExpression="EmploymentStatusID EmploymentStatusID GROUP BY EmploymentStatusID" DefaultInsertValue="0" ForceExtractValue="Always">
                                    <EditItemTemplate>
                                        <asp:Label runat="server" ID="EmploymentStatusID" Text='<%# Eval("EmploymentStatusID") %>' Visible="false"></asp:Label>
                                        <asp:Label runat="server" ID="EmploymentStatusName" Text='<%# Eval("EmploymentStatusName") %>'></asp:Label>
                                    </EditItemTemplate>
                                    <InsertItemTemplate>
                                        <asp:HiddenField runat="server" ID="CountryGroupIDEmployer" Value='<%# DataBinder.Eval(Container.DataItem, "CountryGroupIDEmployer") %>'></asp:HiddenField>
                                        <asp:HiddenField runat="server" ID="CountryGroupIDEmployee" Value='<%# DataBinder.Eval(Container.DataItem, "CountryGroupIDEmployee") %>'></asp:HiddenField>
                                        <telerik:RadComboBox runat="server" ID="EmploymentStatusID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataSourceID="SqlDataSource_EmploymentStatus" 
                                                             AppendDataBoundItems="true"
                                                             DataValueField="EmploymentStatusID" DataTextField="NameVisible" Width="300" Filter="Contains" 
                                                             DropDownAutoWidth="Enabled">
                                        </telerik:RadComboBox>
                                    </InsertItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label runat="server" ID="EmploymentStatusID" Text='<%# Eval("EmploymentStatusID") %>' Visible="false"></asp:Label>
                                        <asp:Label runat="server" ID="EmploymentStatusName" Text='<%# Eval("EmploymentStatusName") %>'></asp:Label>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>

                                <telerik:GridTemplateColumn DataField="CheckingRuleID" DataType="System.Int32" FilterControlAltText="Filter CheckingRuleID column"
                                                            HeaderText="<%$ Resources:Resource, lblDocumentCheckingRule %>" SortExpression="CheckingRuleID" UniqueName="CheckingRuleID"
                                                            GroupByExpression="CheckingRuleID CheckingRuleID GROUP BY CheckingRuleID">
                                    <EditItemTemplate>
                                        <telerik:RadDropDownList ID="CheckingRuleID" runat="server" SelectedValue='<%# Bind("CheckingRuleID") %>' Width="500px" DropDownWidth="500px">
                                            <Items>
                                                <telerik:DropDownListItem runat="server" Selected="True" Text="<%$ Resources:Resource, selRDRuleNone %>" Value="0" />
                                                <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selRDRule8 %>" Value="8" />
                                                <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selRDRule1 %>" Value="1" />
                                                <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selRDRule5 %>" Value="5" />
                                                <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selRDRule6 %>" Value="6" />
                                                <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selRDRule7 %>" Value="7" />
                                                <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selRDRule3 %>" Value="3" />
                                                <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selRDRule9 %>" Value="9" />
                                                <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selRDRule2 %>" Value="2" />
                                                <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selRDRule4 %>" Value="4" />
                                                <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, selRDRule10 %>" Value="10" />
                                            </Items>
                                        </telerik:RadDropDownList>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label runat="server" ID="CheckingRuleID" Text='<%# GetCheckingRule(Convert.ToInt32(Eval("CheckingRuleID"))) %>'></asp:Label>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>

                <telerik:GridButtonColumn UniqueName="deleteColumn" Visible="false" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                          ConfirmDialogType="RadWindow"
                                          ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                    <ItemStyle BackColor="Control" />
                </telerik:GridButtonColumn>
                            </Columns>
                        </telerik:GridTableView>
                    </DetailTables>

                    <Columns>
                        <%-- Employee country group --%>
                        <telerik:GridBoundColumn DataField="CountryGroupIDEmployer" UniqueName="CountryGroupIDEmployer" Visible="false" ForceExtractValue="Always">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="CountryGroupIDEmployee" UniqueName="CountryGroupIDEmployee" Visible="false" ForceExtractValue="Always">
                        </telerik:GridBoundColumn>

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
                    </Columns>
                </telerik:GridTableView>
            </DetailTables>

            <Columns>
                <%-- Employer country group --%>
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
            </Columns>
        </MasterTableView>
    </telerik:RadGrid>

    <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGrid1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <asp:SqlDataSource ID="SqlDataSource_EmployerCountryGroup" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT SystemID, BpID, CountryGroupID CountryGroupIDEmployer, NameVisible, DescriptionShort FROM Master_CountryGroups WHERE (SystemID = @SystemID) AND (BpID = @BpID) ORDER BY NameVisible">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_EmployeeCountryGroup" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT CountryGroupsEmployee.SystemID, CountryGroupsEmployee.BpID, CountryGroupsEmployer.CountryGroupID AS CountryGroupIDEmployer, CountryGroupsEmployee.CountryGroupID AS CountryGroupIDEmployee, CountryGroupsEmployee.NameVisible, CountryGroupsEmployee.DescriptionShort FROM Master_CountryGroups AS CountryGroupsEmployer INNER JOIN Master_CountryGroups AS CountryGroupsEmployee ON CountryGroupsEmployer.SystemID = CountryGroupsEmployee.SystemID AND CountryGroupsEmployer.BpID = CountryGroupsEmployee.BpID WHERE (CountryGroupsEmployee.SystemID = @SystemID) AND (CountryGroupsEmployee.BpID = @BpID) AND (CountryGroupsEmployer.CountryGroupID = @CountryGroupIDEmployer) ORDER BY CountryGroupsEmployee.NameVisible">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" />
            <asp:Parameter Name="CountryGroupIDEmployer" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_EmploymentStatus" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT DISTINCT Master_EmploymentStatus.SystemID, Master_EmploymentStatus.BpID, CountryGroupsEmployer.CountryGroupID AS CountryGroupIDEmployer, CountryGroupsEmployee.CountryGroupID AS CountryGroupIDEmployee, Master_EmploymentStatus.EmploymentStatusID, Master_EmploymentStatus.NameVisible, Master_EmploymentStatus.DescriptionShort FROM Master_CountryGroups AS CountryGroupsEmployer INNER JOIN Master_CountryGroups AS CountryGroupsEmployee ON CountryGroupsEmployer.SystemID = CountryGroupsEmployee.SystemID AND CountryGroupsEmployer.BpID = CountryGroupsEmployee.BpID INNER JOIN Master_EmploymentStatus ON CountryGroupsEmployee.SystemID = Master_EmploymentStatus.SystemID AND CountryGroupsEmployee.BpID = Master_EmploymentStatus.BpID WHERE (Master_EmploymentStatus.SystemID = @SystemID) AND (Master_EmploymentStatus.BpID = @BpID) AND (CountryGroupsEmployer.CountryGroupID = @CountryGroupIDEmployer) AND (CountryGroupsEmployee.CountryGroupID = @CountryGroupIDEmployee) AND (NOT EXISTS (SELECT 1 AS Expr1 FROM Master_DocumentCheckingRules WHERE (SystemID = CountryGroupsEmployer.SystemID) AND (BpID = CountryGroupsEmployer.BpID) AND (CountryGroupIDEmployer = CountryGroupsEmployer.CountryGroupID) AND (CountryGroupIDEmployee = CountryGroupsEmployee.CountryGroupID) AND (EmploymentStatusID = Master_EmploymentStatus.EmploymentStatusID))) ORDER BY Master_EmploymentStatus.NameVisible">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" />
            <asp:Parameter Name="CountryGroupIDEmployer" />
            <asp:Parameter Name="CountryGroupIDEmployee" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_DocumentCheckingRules" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       OldValuesParameterFormatString="original_{0}" 
                       OnDeleting="SqlDataSource_DocumentCheckingRules_Deleting" OnUpdating="SqlDataSource_DocumentCheckingRules_Updating"
                       DeleteCommand="INSERT INTO History_DocumentCheckingRules SELECT * FROM Master_DocumentCheckingRules WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [CountryGroupIDEmployer] = @original_CountryGroupIDEmployer AND [CountryGroupIDEmployee] = @original_CountryGroupIDEmployee AND [EmploymentStatusID] = @original_EmploymentStatusID; 
                       DELETE FROM [Master_DocumentCheckingRules] WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [CountryGroupIDEmployer] = @original_CountryGroupIDEmployer AND [CountryGroupIDEmployee] = @original_CountryGroupIDEmployee AND [EmploymentStatusID] = @original_EmploymentStatusID"
                       SelectCommand="SELECT Master_DocumentCheckingRules.SystemID, Master_DocumentCheckingRules.BpID, Master_DocumentCheckingRules.CountryGroupIDEmployer, Master_DocumentCheckingRules.CountryGroupIDEmployee, Master_DocumentCheckingRules.EmploymentStatusID, Master_EmploymentStatus.NameVisible AS EmploymentStatusName, Master_DocumentCheckingRules.CheckingRuleID, Master_DocumentCheckingRules.CreatedFrom, Master_DocumentCheckingRules.CreatedOn, Master_DocumentCheckingRules.EditFrom, Master_DocumentCheckingRules.EditOn FROM Master_DocumentCheckingRules INNER JOIN Master_EmploymentStatus ON Master_DocumentCheckingRules.SystemID = Master_EmploymentStatus.SystemID AND Master_DocumentCheckingRules.BpID = Master_EmploymentStatus.BpID AND Master_DocumentCheckingRules.EmploymentStatusID = Master_EmploymentStatus.EmploymentStatusID WHERE (Master_DocumentCheckingRules.SystemID = @SystemID) AND (Master_DocumentCheckingRules.BpID = @BpID) AND (Master_DocumentCheckingRules.CountryGroupIDEmployer = @CountryGroupIDEmployer) AND (Master_DocumentCheckingRules.CountryGroupIDEmployee = @CountryGroupIDEmployee)" 
                       UpdateCommand="INSERT INTO History_DocumentCheckingRules SELECT * FROM Master_DocumentCheckingRules WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [CountryGroupIDEmployer] = @original_CountryGroupIDEmployer AND [CountryGroupIDEmployee] = @original_CountryGroupIDEmployee AND [EmploymentStatusID] = @original_EmploymentStatusID; 
                       UPDATE Master_DocumentCheckingRules SET CheckingRuleID = @CheckingRuleID, EditFrom = @UserName, EditOn = SYSDATETIME() WHERE (SystemID = @original_SystemID) AND (BpID = @original_BpID) AND (CountryGroupIDEmployer = @original_CountryGroupIDEmployer) AND (CountryGroupIDEmployee = @original_CountryGroupIDEmployee) AND (EmploymentStatusID = @original_EmploymentStatusID)">
        <DeleteParameters>
            <asp:Parameter Name="original_SystemID" Type="Int32" />
            <asp:Parameter Name="original_BpID" Type="Int32" />
            <asp:Parameter Name="original_CountryGroupIDEmployer" Type="Int32" />
            <asp:Parameter Name="original_CountryGroupIDEmployee" Type="Int32" />
            <asp:Parameter Name="original_EmploymentStatusID" Type="Int32" />
        </DeleteParameters>
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
            <asp:Parameter Name="CountryGroupIDEmployer" Type="Int32" />
            <asp:Parameter Name="CountryGroupIDEmployee" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="CheckingRuleID"></asp:Parameter>
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
            <asp:Parameter Name="original_SystemID"></asp:Parameter>
            <asp:Parameter Name="original_BpID"></asp:Parameter>
            <asp:Parameter Name="original_CountryGroupIDEmployer"></asp:Parameter>
            <asp:Parameter Name="original_CountryGroupIDEmployee"></asp:Parameter>
            <asp:Parameter Name="original_EmploymentStatusID"></asp:Parameter>
        </UpdateParameters>
    </asp:SqlDataSource>
</asp:Content>
