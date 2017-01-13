<%@ Page Title="<%$ Resources:Resource, lblDocumentRules %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DocumentRules.aspx.cs" Inherits="InSite.App.Views.Configuration.DocumentRules" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
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

            var popUp;
            function PopUpShowing(sender, eventArgs) {
                var myWidth = 0, myHeight = 0;
                if (typeof (window.innerWidth) == 'number') {
                    //Non-IE
                    myWidth = window.innerWidth;
                    myHeight = window.innerHeight;
                } else if (document.documentElement && (document.documentElement.clientWidth || document.documentElement.clientHeight)) {
                    //IE 6+ in 'standards compliant mode'
                    myWidth = document.documentElement.clientWidth;
                    myHeight = document.documentElement.clientHeight;
                } else if (document.body && (document.body.clientWidth || document.body.clientHeight)) {
                    //IE 4 compatible
                    myWidth = document.body.clientWidth;
                    myHeight = document.body.clientHeight;
                }

                popUp = eventArgs.get_popUp();
                var gridWidth = myWidth;
                var gridHeight = myHeight;
                var popUpWidth = popUp.style.width.substr(0, popUp.style.width.indexOf("px"));
                var popUpHeight = popUp.style.height.substr(0, popUp.style.height.indexOf("px"));
                if (popUpHeight === "") {
                    popUpHeight = 200;
                }
                popUp.style.left = ((gridWidth - popUpWidth) / 2) + "px";
                popUp.style.top = ((gridHeight - popUpHeight) / 2) + "px";
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
                     OnDetailTableDataBind="RadGrid1_DetailTableDataBind" OnGroupsChanging="RadGrid1_GroupsChanging">

        <ExportSettings ExportOnlyData="True" IgnorePaging="True">
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
            <ClientEvents OnRowClick="OnSingleRowClick" OnGridCreated="OnGridCreated" OnPopUpShowing="PopUpShowing" OnKeyPress="GridKeyPress" />
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

            <DetailTables>
                <%-- Employee country group --%>
                <telerik:GridTableView EnableHierarchyExpandAll="true" DataKeyNames="SystemID,BpID,CountryGroupIDEmployer,CountryGroupIDEmployee" DataSourceID="SqlDataSource_EmployeeCountryGroup" Width="100%"
                                       runat="server" CommandItemDisplay="None" Name="EmployeeCountryGroup" AutoGenerateColumns="false" ShowHeader="true" Caption="<%$ Resources:Resource, lblEmployeeCountryGroup %>"
                                       AllowPaging="true" EditMode="EditForms" HierarchyLoadMode="ServerOnDemand">

                    <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="False" ShowExportToExcelButton="True" ShowExportToPdfButton="False"
                                         AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

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
                        <%-- Employment status --%>
                        <telerik:GridTableView EnableHierarchyExpandAll="true" DataKeyNames="SystemID,BpID,CountryGroupIDEmployer,CountryGroupIDEmployee,EmploymentStatusID" DataSourceID="SqlDataSource_EmploymentStatus"
                                               Width="100%" runat="server" CommandItemDisplay="None" Name="EmploymentStatus" AutoGenerateColumns="false" ShowHeader="true" Caption="<%$ Resources:Resource, lblEmploymentStatus %>"
                                               AllowPaging="true" EditMode="EditForms" AllowFilteringByColumn="false" HierarchyLoadMode="ServerOnDemand">

                            <ParentTableRelation>
                                <telerik:GridRelationFields DetailKeyField="SystemID" MasterKeyField="SystemID"></telerik:GridRelationFields>
                                <telerik:GridRelationFields DetailKeyField="BpID" MasterKeyField="BpID"></telerik:GridRelationFields>
                                <telerik:GridRelationFields DetailKeyField="CountryGroupIDEmployer" MasterKeyField="CountryGroupIDEmployer"></telerik:GridRelationFields>
                                <telerik:GridRelationFields DetailKeyField="CountryGroupIDEmployee" MasterKeyField="CountryGroupIDEmployee"></telerik:GridRelationFields>
                            </ParentTableRelation>

                            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

                            <SortExpressions>
                                <telerik:GridSortExpression FieldName="NameVisible" SortOrder="Ascending"></telerik:GridSortExpression>
                            </SortExpressions>

                            <DetailTables>
                                <%-- Relevant for --%>
                                <telerik:GridTableView EnableHierarchyExpandAll="true" DataKeyNames="SystemID,BpID,CountryGroupIDEmployer,CountryGroupIDEmployee,EmploymentStatusID,RelevantFor"
                                                       DataSourceID="SqlDataSource_RelevantFor"
                                                       Width="100%" runat="server" CommandItemDisplay="None" Name="RelevantFor" AutoGenerateColumns="false" ShowHeader="true" Caption="<%$ Resources:Resource, lblRelevantFor %>"
                                                       AllowPaging="true" EditMode="EditForms" ShowFooter="false" HierarchyLoadMode="ServerOnDemand">

                                    <ParentTableRelation>
                                        <telerik:GridRelationFields DetailKeyField="SystemID" MasterKeyField="SystemID"></telerik:GridRelationFields>
                                        <telerik:GridRelationFields DetailKeyField="BpID" MasterKeyField="BpID"></telerik:GridRelationFields>
                                        <telerik:GridRelationFields DetailKeyField="CountryGroupIDEmployer" MasterKeyField="CountryGroupIDEmployer"></telerik:GridRelationFields>
                                        <telerik:GridRelationFields DetailKeyField="CountryGroupIDEmployee" MasterKeyField="CountryGroupIDEmployee"></telerik:GridRelationFields>
                                        <telerik:GridRelationFields DetailKeyField="EmploymentStatusID" MasterKeyField="EmploymentStatusID"></telerik:GridRelationFields>
                                    </ParentTableRelation>

                                    <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

                                    <SortExpressions>
                                        <telerik:GridSortExpression FieldName="RelevantFor" SortOrder="Ascending"></telerik:GridSortExpression>
                                    </SortExpressions>

                                    <EditFormSettings CaptionDataField="NameVisible" CaptionFormatString="{0}">
                                        <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                                        <EditColumn ButtonType="ImageButton" UniqueName="EditColumn2" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                                                    EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                                        <FormTableStyle CellPadding="3" CellSpacing="3" />
                                    </EditFormSettings>

                                    <DetailTables>
                                        <%-- Relevant documents --%>
                                        <telerik:GridTableView EnableHierarchyExpandAll="true"
                                                               DataKeyNames="SystemID,BpID,CountryGroupIDEmployer,CountryGroupIDEmployee,EmploymentStatusID,RelevantFor,RelevantDocumentID"
                                                               DataSourceID="SqlDataSource_DocumentRules"
                                                               Width="100%" runat="server" CommandItemDisplay="top" Name="DocumentRules" AutoGenerateColumns="false" ShowHeader="true" Caption="<%$ Resources:Resource, lblRelevantDocuments %>"
                                                               AllowPaging="true" EditMode="PopUp" ShowFooter="false" HierarchyLoadMode="ServerOnDemand">

                                            <ParentTableRelation>
                                                <telerik:GridRelationFields DetailKeyField="SystemID" MasterKeyField="SystemID"></telerik:GridRelationFields>
                                                <telerik:GridRelationFields DetailKeyField="BpID" MasterKeyField="BpID"></telerik:GridRelationFields>
                                                <telerik:GridRelationFields DetailKeyField="CountryGroupIDEmployer" MasterKeyField="CountryGroupIDEmployer"></telerik:GridRelationFields>
                                                <telerik:GridRelationFields DetailKeyField="CountryGroupIDEmployee" MasterKeyField="CountryGroupIDEmployee"></telerik:GridRelationFields>
                                                <telerik:GridRelationFields DetailKeyField="EmploymentStatusID" MasterKeyField="EmploymentStatusID"></telerik:GridRelationFields>
                                                <telerik:GridRelationFields DetailKeyField="RelevantFor" MasterKeyField="RelevantFor"></telerik:GridRelationFields>
                                            </ParentTableRelation>

                                            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

                                            <SortExpressions>
                                                <telerik:GridSortExpression FieldName="NameVisible" SortOrder="Ascending"></telerik:GridSortExpression>
                                            </SortExpressions>

                                            <EditFormSettings EditFormType="AutoGenerated" CaptionFormatString="<%$ Resources:Resource, lblActionCreate %>">
                                                <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                                                <EditColumn ButtonType="ImageButton" UniqueName="EditColumn4" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                                                            EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                                                <FormTableStyle CellPadding="3" CellSpacing="3" />
                                            </EditFormSettings>

                                            <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true"
                                                                 AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                                            <Columns>
                                                <%-- Relevant documents --%>

                                                <telerik:GridTemplateColumn DataField="RelevantDocumentID" HeaderText="<%$ Resources:Resource, lblRelevantDocument %>" SortExpression="RelevantDocumentID"
                                                                            UniqueName="RelevantDocumentID" GroupByExpression="RelevantDocumentID RelevantDocumentID GROUP BY RelevantDocumentID" Visible="false">
                                                    <InsertItemTemplate>
                                                        <asp:HiddenField runat="server" ID="CountryGroupIDEmployer" Value='<%# Bind("CountryGroupIDEmployer") %>'></asp:HiddenField>
                                                        <asp:HiddenField runat="server" ID="CountryGroupIDEmployee" Value='<%# Bind("CountryGroupIDEmployee") %>'></asp:HiddenField>
                                                        <asp:HiddenField runat="server" ID="EmploymentStatusID" Value='<%# Bind("EmploymentStatusID") %>'></asp:HiddenField>
                                                        <asp:HiddenField runat="server" ID="RelevantFor" Value='<%# Bind("RelevantFor") %>'></asp:HiddenField>

                                                        <telerik:RadDropDownList ID="RadDropDownList1" runat="server" DataSourceID="SqlDataSource_RelevantDocuments" DataTextField="NameVisible"
                                                                                 DataValueField="RelevantDocumentID" DropDownHeight="400px" DropDownWidth="300px" Width="300px" OnItemDataBound="RadDropDownList1_ItemDataBound"
                                                                                 SelectedValue='<%# Bind("RelevantDocumentID") %>'>
                                                            <ItemTemplate>
                                                                <table cellpadding="5px" style="text-align: left;">
                                                                    <tr>
                                                                        <td style="text-align: left;">
                                                                            <asp:Label ID="ItemName" Text='<%# Eval("NameVisible") %>' runat="server">
                                                                            </asp:Label>
                                                                        </td>
                                                                        <td style="text-align: left;">
                                                                            <asp:Label ID="ItemDescr" Text='<%# Eval("DescriptionShort") %>' runat="server">
                                                                            </asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ItemTemplate>
                                                        </telerik:RadDropDownList>
                                                    </InsertItemTemplate>

                                                    <ItemTemplate>
                                                        <asp:Label runat="server" Visible="false" ID="LanguageID" Text='<%# Eval("RelevantDocumentID") %>'></asp:Label>
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

                <telerik:GridButtonColumn UniqueName="deleteColumn" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                          ConfirmDialogType="RadWindow"
                                          ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                    <ItemStyle BackColor="Control" />
                </telerik:GridButtonColumn>
                                            </Columns>
                                        </telerik:GridTableView>
                                    </DetailTables>

                                    <Columns>
                                        <%-- Relevant for --%>
                                        <telerik:GridTemplateColumn DataField="RelevantFor" Visible="false" HeaderText="<%$ Resources:Resource, lblID %>" SortExpression="RelevantFor" UniqueName="RelevantFor"
                                                                    GroupByExpression="RelevantFor RelevantFor GROUP BY RelevantFor">
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="RelevantFor" Text='<%# Eval("RelevantFor") %>'></asp:Label>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridTemplateColumn DataField="ResourceID" HeaderText="<%$ Resources:Resource, lblNameVisible %>" SortExpression="ResourceID" UniqueName="ResourceID"
                                                                    GroupByExpression="ResourceID ResourceID GROUP BY ResourceID">
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="NameVisible" Text=""></asp:Label>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>

                                    </Columns>
                                </telerik:GridTableView>
                            </DetailTables>

                            <Columns>
                                <%-- Employment status --%>
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
                        <%-- Employee country group --%>
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
                       SelectCommand="SELECT Master_EmploymentStatus.SystemID, Master_EmploymentStatus.BpID, CountryGroupsEmployer.CountryGroupID AS CountryGroupIDEmployer, CountryGroupsEmployee.CountryGroupID AS CountryGroupIDEmployee, Master_EmploymentStatus.EmploymentStatusID, Master_EmploymentStatus.NameVisible, Master_EmploymentStatus.DescriptionShort FROM Master_CountryGroups AS CountryGroupsEmployer INNER JOIN Master_CountryGroups AS CountryGroupsEmployee ON CountryGroupsEmployer.SystemID = CountryGroupsEmployee.SystemID AND CountryGroupsEmployer.BpID = CountryGroupsEmployee.BpID INNER JOIN Master_EmploymentStatus ON CountryGroupsEmployee.SystemID = Master_EmploymentStatus.SystemID AND CountryGroupsEmployee.BpID = Master_EmploymentStatus.BpID WHERE (Master_EmploymentStatus.SystemID = @SystemID) AND (Master_EmploymentStatus.BpID = @BpID) AND (CountryGroupsEmployer.CountryGroupID = @CountryGroupIDEmployer) AND (CountryGroupsEmployee.CountryGroupID = @CountryGroupIDEmployee) ORDER BY Master_EmploymentStatus.NameVisible">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" />
            <asp:Parameter Name="CountryGroupIDEmployer" />
            <asp:Parameter Name="CountryGroupIDEmployee" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_RelevantFor" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT System_RelevantFor.SystemID, Master_EmploymentStatus.BpID, CountryGroupsEmployer.CountryGroupID AS CountryGroupIDEmployer, CountryGroupsEmployee.CountryGroupID AS CountryGroupIDEmployee, Master_EmploymentStatus.EmploymentStatusID, System_RelevantFor.RelevantFor, System_RelevantFor.ResourceID FROM Master_CountryGroups AS CountryGroupsEmployer INNER JOIN Master_CountryGroups AS CountryGroupsEmployee ON CountryGroupsEmployer.SystemID = CountryGroupsEmployee.SystemID AND CountryGroupsEmployer.BpID = CountryGroupsEmployee.BpID INNER JOIN System_RelevantFor INNER JOIN Master_EmploymentStatus ON System_RelevantFor.SystemID = Master_EmploymentStatus.SystemID ON CountryGroupsEmployee.SystemID = Master_EmploymentStatus.SystemID AND CountryGroupsEmployee.BpID = Master_EmploymentStatus.BpID WHERE (System_RelevantFor.SystemID = @SystemID) AND (Master_EmploymentStatus.BpID = @BpID) AND (CountryGroupsEmployer.CountryGroupID = @CountryGroupIDEmployer) AND (CountryGroupsEmployee.CountryGroupID = @CountryGroupIDEmployee) AND (Master_EmploymentStatus.EmploymentStatusID = @EmploymentStatusID) ORDER BY System_RelevantFor.RelevantFor">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" />
            <asp:Parameter Name="CountryGroupIDEmployer" />
            <asp:Parameter Name="CountryGroupIDEmployee" />
            <asp:Parameter Name="EmploymentStatusID" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_DocumentRules" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       OldValuesParameterFormatString="original_{0}" 
                       OnDeleting="SqlDataSource_DocumentRules_Deleting" OnInserting="SqlDataSource_DocumentRules_Inserting"
                       DeleteCommand="INSERT INTO History_DocumentRules SELECT * FROM Master_DocumentRules WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [CountryGroupIDEmployer] = @original_CountryGroupIDEmployer AND [CountryGroupIDEmployee] = @original_CountryGroupIDEmployee AND [EmploymentStatusID] = @original_EmploymentStatusID AND [RelevantFor] = @original_RelevantFor AND [RelevantDocumentID] = @original_RelevantDocumentID; 
                       DELETE FROM [Master_DocumentRules] WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [CountryGroupIDEmployer] = @original_CountryGroupIDEmployer AND [CountryGroupIDEmployee] = @original_CountryGroupIDEmployee AND [EmploymentStatusID] = @original_EmploymentStatusID AND [RelevantFor] = @original_RelevantFor AND [RelevantDocumentID] = @original_RelevantDocumentID"
                       InsertCommand="INSERT INTO [Master_DocumentRules] ([SystemID], [BpID], [CountryGroupIDEmployer], [CountryGroupIDEmployee], [EmploymentStatusID], [RelevantFor], [RelevantDocumentID], [CreatedFrom], [CreatedOn], [EditFrom], [EditOn]) VALUES (@SystemID, @BpID, @CountryGroupIDEmployer, @CountryGroupIDEmployee, @EmploymentStatusID, @RelevantFor, @RelevantDocumentID, @UserName, SYSDATETIME(), @UserName, SYSDATETIME())"
                       SelectCommand="SELECT Master_DocumentRules.SystemID, Master_DocumentRules.BpID, Master_DocumentRules.CountryGroupIDEmployer, Master_DocumentRules.CountryGroupIDEmployee, Master_DocumentRules.EmploymentStatusID, Master_DocumentRules.RelevantFor, Master_DocumentRules.RelevantDocumentID, Master_DocumentRules.CreatedFrom, Master_DocumentRules.CreatedOn, Master_DocumentRules.EditFrom, Master_DocumentRules.EditOn, CountryGroupsEmployer.NameVisible AS CountryGroupsEmployerNameVisible, CountryGroupsEmployer.DescriptionShort AS CountryGroupsEmployerDescriptionShort, CountryGroupsEmployee.NameVisible AS CountryGroupsEmployeeNameVisible, CountryGroupsEmployee.DescriptionShort AS CountryGroupsEmployeeDescriptionShort, Master_EmploymentStatus.NameVisible AS EmploymentStatusNameVisible, Master_EmploymentStatus.DescriptionShort AS EmploymentStatusDescriptionShort, System_RelevantFor.ResourceID, Master_RelevantDocuments.NameVisible, Master_RelevantDocuments.DescriptionShort FROM Master_DocumentRules INNER JOIN Master_CountryGroups AS CountryGroupsEmployer ON Master_DocumentRules.SystemID = CountryGroupsEmployer.SystemID AND Master_DocumentRules.BpID = CountryGroupsEmployer.BpID AND Master_DocumentRules.CountryGroupIDEmployer = CountryGroupsEmployer.CountryGroupID INNER JOIN Master_CountryGroups AS CountryGroupsEmployee ON Master_DocumentRules.SystemID = CountryGroupsEmployee.SystemID AND Master_DocumentRules.BpID = CountryGroupsEmployee.BpID AND Master_DocumentRules.CountryGroupIDEmployee = CountryGroupsEmployee.CountryGroupID INNER JOIN Master_EmploymentStatus ON Master_DocumentRules.SystemID = Master_EmploymentStatus.SystemID AND Master_DocumentRules.BpID = Master_EmploymentStatus.BpID AND Master_DocumentRules.EmploymentStatusID = Master_EmploymentStatus.EmploymentStatusID INNER JOIN System_RelevantFor ON Master_DocumentRules.SystemID = System_RelevantFor.SystemID AND Master_DocumentRules.RelevantFor = System_RelevantFor.RelevantFor INNER JOIN Master_RelevantDocuments ON Master_DocumentRules.SystemID = Master_RelevantDocuments.SystemID AND Master_DocumentRules.BpID = Master_RelevantDocuments.BpID AND Master_DocumentRules.RelevantDocumentID = Master_RelevantDocuments.RelevantDocumentID WHERE (Master_DocumentRules.SystemID = @SystemID) AND (Master_DocumentRules.BpID = @BpID) AND (Master_DocumentRules.CountryGroupIDEmployer = @CountryGroupIDEmployer) AND (Master_DocumentRules.CountryGroupIDEmployee = @CountryGroupIDEmployee) AND (Master_DocumentRules.EmploymentStatusID = @EmploymentStatusID) AND (Master_DocumentRules.RelevantFor = @RelevantFor) ORDER BY Master_RelevantDocuments.NameVisible">
        <DeleteParameters>
            <asp:Parameter Name="original_SystemID" Type="Int32" />
            <asp:Parameter Name="original_BpID" Type="Int32" />
            <asp:Parameter Name="original_CountryGroupIDEmployer" Type="Int32" />
            <asp:Parameter Name="original_CountryGroupIDEmployee" Type="Int32" />
            <asp:Parameter Name="original_EmploymentStatusID" Type="Int32" />
            <asp:Parameter Name="original_RelevantFor" Type="Int16" />
            <asp:Parameter Name="original_RelevantDocumentID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
            <asp:Parameter Name="CountryGroupIDEmployer" Type="Int32" />
            <asp:Parameter Name="CountryGroupIDEmployee" Type="Int32" />
            <asp:Parameter Name="EmploymentStatusID" Type="Int32" />
            <asp:Parameter Name="RelevantFor" Type="Int16" />
            <asp:Parameter Name="RelevantDocumentID" Type="Int32" />
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
        </InsertParameters>
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
            <asp:Parameter Name="CountryGroupIDEmployer" Type="Int32" />
            <asp:Parameter Name="CountryGroupIDEmployee" Type="Int32" />
            <asp:Parameter Name="EmploymentStatusID" Type="Int32" />
            <asp:Parameter Name="RelevantFor" Type="Int16" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_RelevantDocuments" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT * FROM Master_RelevantDocuments WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (RelevantFor = (CASE WHEN @RelevantFor = 0 THEN RelevantFor ELSE @RelevantFor END)) ORDER BY NameVisible">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
            <asp:Parameter Name="RelevantFor" DefaultValue="0" Type="Int16" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
