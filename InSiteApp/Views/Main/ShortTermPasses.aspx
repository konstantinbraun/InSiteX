<%@ Page Title="<%$ Resources:Resource, lblShortTermPasses %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ShortTermPasses.aspx.cs" Inherits="InSite.App.Views.Main.ShortTermPasses" %>

<%@ Register src="../../CustomControls/wcShortTermPassAccess.ascx" tagname="wcShortTermPassAccess" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <telerik:RadCodeBlock runat="server">
        <script type="text/javascript">
            function openRadWindow(Action) {
                var masterTable = $find("<%= RadGrid1.ClientID %>").get_masterTableView();
                masterTable.fireCommand("HideScanner", true);
                //console.log("fireCommand HideScanner(true)");

                cardReader.unregister(findPassByCard);

                var oWnd = radopen("ShortTermPassActions.aspx?Action=" + Action, "RadWindow1");
                oWnd.add_close(OnClientCloseRadWindow);
                oWnd.center();
            }

            function openRadWindowWithID(Action, ID) {
                var masterTable = $find("<%= RadGrid1.ClientID %>").get_masterTableView();
                masterTable.fireCommand("HideScanner", true);
                cardReader.unregister(findPassByCard);

                var oWnd = radopen("ShortTermPassActions.aspx?Action=" + Action + "&InternalID=" + ID, "RadWindow1");
                oWnd.add_close(OnClientCloseRadWindow);
                oWnd.center();
            }

            function OnClientCloseRadWindow(oWnd, eventArgs) {
                var masterTable = $find("<%= RadGrid1.ClientID %>").get_masterTableView();
                masterTable.fireCommand("HideScanner", false);
                //console.log("fireCommand HideScanner(false)");

                var manager = $find('<%= RadAjaxManager.GetCurrent(Page).ClientID %>');
                document.body.style.cursor = "default";
                //manager.set_enableAJAX(true);
                //$find("<%= BtnEditPass.ClientID %>").click(oWnd, eventArgs);
                masterTable.fireCommand("EditPass");

                oWnd.remove_close(OnClientCloseRadWindow);
            }

            function showAlert() {
                var myVersion = document.myApplet.GetVersion();
                var versionTag = document.getElementById("idFromCard");
                versionTag.innerHTML = myVersion;
            }

            function getValueFromApplet(myParam, myParam2) {
                openRadWindowWithID(14, myParam);
                <%--                var masterTable = $find("<%= RadGrid1.ClientID %>").get_masterTableView();
                masterTable.fireCommand("FindPass", myParam);--%>
            }

            var findPassByCard = {
                name: "findPassByCard",
                uuid: "73D3B90B-6B63-481C-84B8-7CF994086CAD",
                onmessage: function (cardState) {
                    if (cardState.online == true) {
                        if (typeof cardState.cardId !== "undefined" && cardState.reason == "trigger") {
                            openRadWindowWithID(14, cardState.cardId);
                        }
                    }
                }
            }

            //cardReader.register(findPassByCard);
            function OnGridCreated(sender, args) {
                //console.group("OnGridCreated");
                var editItems = sender.get_masterTableView().get_editItems();
                if (editItems.length > 0) {
                    cardReader.unregister(findPassByCard);
                } else {
                    cardReader.register(findPassByCard);
                }
                //console.groupEnd();
            }
        </script>
    </telerik:RadCodeBlock>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <asp:Panel ID="RadScriptBlockReader" runat="server">
        <div style="right: 6px; top: 6px; position: fixed; z-index: 1000; height: 20px; width: 20px;">
            <applet id="ReaderState" width="20" height="20" archive="/InSiteApp/Controls/InSite3Reader.jar" name="myApplet" code="ChipReader.ChipReaderApp.class" 
                    alt="n.a.">
                <%--  <param name="logger" value='<%= String.Concat(ConfigurationManager.AppSettings["LogRoot"].ToString(), "RFIDReader.log") %>' />--%>
                <param name="logger" value="off" />
                <param name="scripting" value="enabled" />
                <param name="scriptName" value="getValueFromApplet" />
                <param name="doSubmit" value= "false" />
                <param name="ReaderName" value='<%= ConfigurationManager.AppSettings["ReaderName"].ToString() %>' />
                <div id="cardState" style="height:100%; width:100%;"></div>
            </applet>
            <div id="idFromCard"></div>
            <label id="TAGID"></label>
        </div>
    </asp:Panel>

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
            <telerik:AjaxSetting AjaxControlID="RadScriptBlockReader">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadScriptBlockReader" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <telerik:RadGrid ID="RadGrid1" runat="server" CssClass="MainGrid"
                     AllowPaging="true" AllowSorting="true" EnableHeaderContextFilterMenu="True" EnableHeaderContextMenu="True" ShowGroupPanel="True" AllowFilteringByColumn="true"
                     GroupPanelPosition="BeforeHeader"
                     OnItemCommand="RadGrid1_ItemCommand" OnPreRender="RadGrid1_PreRender" OnItemDataBound="RadGrid1_ItemDataBound" OnInsertCommand="RadGrid1_InsertCommand"
                     OnUpdateCommand="RadGrid1_UpdateCommand" OnItemUpdated="RadGrid1_ItemUpdated" OnItemCreated="RadGrid1_ItemCreated" OnExcelMLWorkBookCreated="RadGrid1_ExcelMLWorkBookCreated"
                     OnExcelMLExportRowCreated="RadGrid1_ExcelMLExportRowCreated" OnExportCellFormatting="RadGrid1_ExportCellFormatting" OnExcelMLExportStylesCreated="RadGrid1_ExcelMLExportStylesCreated"
                     OnNeedDataSource="RadGrid1_NeedDataSource" OnGroupsChanging="RadGrid1_GroupsChanging">

        <GroupPanel Text="<%$ Resources:Resource, msgGroupPanel %>">
        </GroupPanel>

        <GroupingSettings ShowUnGroupButton="True" CaseSensitive="false" />

        <ExportSettings ExportOnlyData="true" IgnorePaging="true" FileName="ShortTermPasses" HideStructureColumns="true" OpenInNewWindow="true">
            <Pdf PaperSize="A4">
            </Pdf>
            <Excel Format="Xlsx" AutoFitImages="true" DefaultCellAlignment="Left" FileExtension="xlsx" />
        </ExportSettings>

        <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false" AllowGroupExpandCollapse="true" AllowExpandCollapse="true">
            <Resizing AllowColumnResize="true" AllowResizeToFit="true" EnableRealTimeResize="true"></Resizing>
            <Selecting AllowRowSelect="True" />
            <ClientEvents OnRowClick="OnRowClick" OnKeyPress="GridKeyPress" OnGridCreated="OnGridCreated" />
        </ClientSettings>

        <SortingSettings SortedBackColor="Transparent" />

        <MasterTableView EnableHierarchyExpandAll="true" AutoGenerateColumns="False" DataKeyNames="SystemID,BpID,ShortTermVisitorID"
                         CommandItemDisplay="Top" HierarchyLoadMode="ServerOnDemand" AllowMultiColumnSorting="true" EditMode="PopUp" PageSize="15">
<%--                         FilterExpression="(StatusID = 25)">--%>

            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" PageSizes="15,30,60" />

            <SortExpressions>
                <telerik:GridSortExpression FieldName="StatusID" SortOrder="Descending"></telerik:GridSortExpression>
                <telerik:GridSortExpression FieldName="AccessAllowedUntil" SortOrder="Descending"></telerik:GridSortExpression>
                <telerik:GridSortExpression FieldName="ActivatedOn" SortOrder="Descending"></telerik:GridSortExpression>
            </SortExpressions>

            <CommandItemTemplate>
                <div style="margin: 3px; height: 20px;">
                    <telerik:RadButton ID="btnPrintPasses" runat="server" CommandName="PrintPasses" Visible='<%# !RadGrid1.MasterTableView.IsItemInserted %>' Text='<%# Resources.Resource.lblPrintShortTermPasses %>' 
                                       Icon-PrimaryIconCssClass="rbPrint" ButtonType="SkinnedButton" BorderStyle="None" BackColor="Transparent"></telerik:RadButton>

                    <telerik:RadButton ID="btnAssignPasses" runat="server" CommandName="AssignPasses" Visible='<%# !RadGrid1.MasterTableView.IsItemInserted %>' Text='<%# Resources.Resource.lblAssignNewPasses %>' 
                                       Icon-PrimaryIconCssClass="rbAttach" ButtonType="SkinnedButton" BorderStyle="None" BackColor="Transparent"></telerik:RadButton>

                    <telerik:RadButton ID="btnInitInsert" runat="server" CommandName="InitInsert" Visible="false" Text='<%# Resources.Resource.lblShortTermPassForVisitor %>' 
                                       Icon-PrimaryIconCssClass="rbAdd" ButtonType="LinkButton" BorderStyle="None" BackColor="Transparent"></telerik:RadButton>

                    <telerik:RadButton ID="btnExportCsv" runat="server" Text="" ToolTip='<%# Resources.Resource.lblExportToCsv %>' CssClass="rgExpCSV FloatRight" CommandName="ExportToCSV" 
                                       ButtonType="LinkButton" Visible="false" BackColor="Transparent"></telerik:RadButton>&nbsp;&nbsp;

                    <telerik:RadButton ID="btnExportExcel" runat="server" Text="" ToolTip='<%# Resources.Resource.lblExportToExcel %>' CssClass="rgExpXLS FloatRight" CommandName="ExportToExcel"
                                       ButtonType="SkinnedButton" Visible="true" BorderStyle="None" BackColor="Transparent" Width="25px" Height="20px">
                        <Icon PrimaryIconUrl="../../Resources/Icons/export_xlsx_16.png" />
                    </telerik:RadButton>

                    <telerik:RadButton ID="btnExportPdf" runat="server" Text="" ToolTip='<%# Resources.Resource.lblExportToPdf %>' CssClass="rgExpPDF FloatRight" CommandName="ExportToPdf" 
                                       ButtonType="LinkButton" Visible="false" BackColor="Transparent"></telerik:RadButton>

                    <div class="vertical-line"></div>

                    <telerik:RadButton ID="btnRefresh" runat="server" CommandName="RebindGrid" Text='<%# Resources.Resource.lblActionRefresh %>' 
                                       Icon-PrimaryIconCssClass="rbRefresh" ButtonType="SkinnedButton" BorderStyle="None" CssClass="FloatRight" BackColor="Transparent"></telerik:RadButton>
                </div>
            </CommandItemTemplate>

            <Columns>
                <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                               UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                    <ItemStyle BackColor="Control" Width="30px" />
                    <HeaderStyle Width="30px" />
                </telerik:GridEditCommandColumn>

                <telerik:GridTemplateColumn DataField="StatusID" HeaderText="<%$ Resources:Resource, lblStatus %>" SortExpression="StatusID" UniqueName="StatusID" ItemStyle-HorizontalAlign="Center"
                                            GroupByExpression="StatusID StatusID GROUP BY StatusID" Visible="true" ItemStyle-Width="70px" HeaderStyle-Width="70px" CurrentFilterFunction="Contains" >
<%--                                            CurrentFilterValue="25">--%>
                    <ItemTemplate>
                        <asp:HiddenField runat="server" ID="StatusID" Value='<%# Eval("StatusID") %>' />
                        <asp:ImageButton runat="server" ID="ReleaseButton" />
                    </ItemTemplate>

                    <FilterTemplate>
                        <telerik:RadComboBox ID="StatusID" DataValueField="StatusID" Height="200px" AppendDataBoundItems="true" 
                                             SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("StatusID").CurrentFilterValue %>'
                                             runat="server" OnClientSelectedIndexChanged="StatusIDIndexChanged" DropDownAutoWidth="Enabled" Width="50px">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statActivated %>" Value="25" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statExpired %>" Value="-2" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statDeactivated %>" Value="-5" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statLocked %>" Value="-10" />
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

<HeaderStyle Width="70px"></HeaderStyle>

<ItemStyle HorizontalAlign="Center" Width="70px"></ItemStyle>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Present" HeaderText="<%$ Resources:Resource, lblPresent %>" SortExpression="Present" UniqueName="Present"
                                            GroupByExpression="Present Present GROUP BY Present" Visible="true" ForceExtractValue="Always" CurrentFilterFunction="EqualTo" 
                                            ItemStyle-Width="70px" HeaderStyle-Width="70px" AutoPostBackOnFilter="true" ItemStyle-HorizontalAlign="Center" DataType="System.Boolean"
                                            HeaderStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <div style="margin-left: -2px; margin-top: 2px;">
                            <asp:Image ImageUrl='<%# (Convert.ToInt32(Eval("Present")) == 1) ? "/InSiteApp/Resources/Icons/enter-24.png" : ((Convert.ToInt32(Eval("Present")) == 0) ? "/InSiteApp/Resources/Icons/exit-24.png" : ((Convert.ToInt32(Eval("Present")) == 2) ? "/InSiteApp/Resources/Icons/undefined-24.png" : "/InSiteApp/Resources/Icons/never-24.png"))  %>'
                                       runat="server" Width="22px" Height="22px" ToolTip='<%# String.Format("{0} {1}: {2:G}", Convert.ToInt32(Eval("Present")) == 1 ? Resources.Resource.lblAccessStatePresent : Convert.ToInt32(Eval("Present")) == 0 ? Resources.Resource.lblAccessStateAbsent : Convert.ToInt32(Eval("Present")) == 2 ? Resources.Resource.lblAccessStateUndefined : Resources.Resource.lblAccessStateNoAccess, Resources.Resource.lblSince.ToLower(), Eval("AccessTime")) %>' />
                        </div>
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="PresentFilter" runat="server" OnClientSelectedIndexChanged="PresentFilterSelectedIndexChanged"
                                             SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("Present").CurrentFilterValue %>'
                                             AppendDataBoundItems="true" DropDownAutoWidth="Enabled" Width="50px">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" Value="" Selected="true" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAccessStatePresent %>" Value="1" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAccessStateAbsent %>" Value="0" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAccessStateUndefined %>" Value="2" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAccessStateNoAccess %>" Value="3" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock22" runat="server">
                            <script type="text/javascript">
                                function PresentFilterSelectedIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    var filterVal = args.get_item().get_value();
                                    if (filterVal === "") {
                                        tableView.filter("Present", filterVal, "NoFilter");
                                    } else {
                                        tableView.filter("Present", filterVal, "EqualTo");
                                    }
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>

<HeaderStyle HorizontalAlign="Center" Width="70px"></HeaderStyle>

<ItemStyle HorizontalAlign="Center" Width="70px"></ItemStyle>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="ShortTermVisitorID" DataType="System.Int32" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter ShortTermVisitorID column"
                                            HeaderText="<%$ Resources:Resource, lblVisitorID %>" SortExpression="ShortTermVisitorID" UniqueName="ShortTermVisitorID" Visible="false">
                    <ItemTemplate>
                        <asp:Label ID="ShortTermVisitorID" runat="server" Text='<%# Eval("ShortTermVisitorID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="ShortTermPassID" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter ShortTermPassID column" FilterControlWidth="40px"
                                            HeaderText="<%$ Resources:Resource, lblPassID %>" SortExpression="ShortTermPassID" UniqueName="ShortTermPassID" Visible="true" 
                                            CurrentFilterFunction="EqualTo" AutoPostBackOnFilter="true" HeaderStyle-Width="80px" ItemStyle-Width="80px">
                    <ItemTemplate>
                        <asp:Label ID="ShortTermPassID" runat="server" Text='<%# Eval("ShortTermPassID") %>'></asp:Label>
                    </ItemTemplate>

<HeaderStyle Width="80px"></HeaderStyle>

<ItemStyle Width="80px"></ItemStyle>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="InternalID" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter InternalID column" FilterControlWidth="80px"
                                            HeaderText="<%$ Resources:Resource, lblChipID %>" SortExpression="InternalID" UniqueName="InternalID" Visible="false" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label ID="InternalID" runat="server" Text='<%# Eval("InternalID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="TypeName" HeaderText="<%$ Resources:Resource, lblShortTermPassType %>" SortExpression="TypeName" UniqueName="TypeName"
                                            GroupByExpression="TypeName TypeName GROUP BY TypeName" ForceExtractValue="Always" FilterControlWidth="80px" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="TypeName" Text='<%# Eval("TypeName") %>'></asp:Label>
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="TypeNameFilter" DataSourceID="SqlDataSource_ShortTermPassTypes" DataTextField="TypeName"
                                             DataValueField="TypeName" Height="200px" AppendDataBoundItems="true" Width="110px"
                                             SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("TypeName").CurrentFilterValue %>'
                                             runat="server" OnClientSelectedIndexChanged="TypeNameIndexChanged" DropDownAutoWidth="Enabled">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock2" runat="server">
                            <script type="text/javascript">
                                function TypeNameIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    tableView.filter("TypeName", args.get_item().get_value(), "EqualTo");
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="VisitorName" HeaderText="<%$ Resources:Resource, lblVisitorName %>" SortExpression="VisitorName" UniqueName="VisitorName"
                                            GroupByExpression="VisitorName VisitorName GROUP BY VisitorName" ForceExtractValue="Always" FilterControlWidth="80px" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="VisitorName" Text='<%# Eval("VisitorName") %>' ToolTip='<%# Eval("VisitorName") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Company" HeaderText="<%$ Resources:Resource, lblEmployer %>" SortExpression="Company" UniqueName="Company"
                                            GroupByExpression="Company Company GROUP BY Company" ForceExtractValue="Always" FilterControlWidth="80px" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Company" Text='<%# Eval("Company") %>' ToolTip='<%# Eval("Company") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridBoundColumn DataField="NationalityID" UniqueName="NationalityID" Visible="false" ForceExtractValue="Always"></telerik:GridBoundColumn>

                <telerik:GridTemplateColumn DataField="CompanyName" HeaderText="<%$ Resources:Resource, lblCompany %>" SortExpression="CompanyName" UniqueName="CompanyName"
                                            GroupByExpression="CompanyName CompanyName GROUP BY CompanyName" ForceExtractValue="Always" FilterControlWidth="80px" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="CompanyName" Text='<%# Eval("CompanyName") %>' ToolTip='<%# Eval("CompanyName") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="EmployeeName" HeaderText="<%$ Resources:Resource, lblEmployee %>" SortExpression="EmployeeName" UniqueName="EmployeeName"
                                            GroupByExpression="EmployeeName EmployeeName GROUP BY EmployeeName" ForceExtractValue="Always" FilterControlWidth="80px" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" >
                    <ItemTemplate>
                        <asp:Label runat="server" ID="EmployeeName" Text='<%# Eval("EmployeeName") %>' ToolTip='<%# Eval("EmployeeName") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridDateTimeColumn FilterControlWidth="100px" DataField="ActivatedOn" HeaderText="<%$ Resources:Resource, lblActivatedOn %>" SortExpression="ActivatedOn"
                                            UniqueName="ActivatedOn" PickerType="DatePicker" EnableRangeFiltering="true" HeaderStyle-Width="170px" ItemStyle-Width="170px" CurrentFilterFunction="Between" 
                                            AutoPostBackOnFilter="true" EnableTimeIndependentFiltering="true">
<HeaderStyle Width="170px"></HeaderStyle>

<ItemStyle Width="170px"></ItemStyle>
                </telerik:GridDateTimeColumn>

                <telerik:GridDateTimeColumn FilterControlWidth="100px" DataField="AccessAllowedUntil" HeaderText="<%$ Resources:Resource, lblAccessUntil %>" SortExpression="AccessAllowedUntil"
                                            UniqueName="AccessAllowedUntil" PickerType="DatePicker" EnableRangeFiltering="true" HeaderStyle-Width="170px" ItemStyle-Width="170px" CurrentFilterFunction="Between" 
                                            AutoPostBackOnFilter="true" EnableTimeIndependentFiltering="true">
<HeaderStyle Width="170px"></HeaderStyle>

<ItemStyle Width="170px"></ItemStyle>
                </telerik:GridDateTimeColumn>

                <telerik:GridDateTimeColumn FilterControlWidth="100px" DataField="DeactivatedOn" HeaderText="<%$ Resources:Resource, lblDeactivatedOn %>" SortExpression="DeactivatedOn"
                                            UniqueName="DeactivatedOn" PickerType="DatePicker" EnableRangeFiltering="true" HeaderStyle-Width="170px" ItemStyle-Width="170px" CurrentFilterFunction="Between" 
                                            AutoPostBackOnFilter="true" EnableTimeIndependentFiltering="true">
<HeaderStyle Width="170px"></HeaderStyle>

<ItemStyle Width="170px"></ItemStyle>
                </telerik:GridDateTimeColumn>

                <telerik:GridBoundColumn DataField="SystemID" UniqueName="SystemID" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="BpID" UniqueName="BpID" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="Salutation" UniqueName="Salutation" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="IdentifiedWith" UniqueName="IdentifiedWith" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="DocumentID" UniqueName="DocumentID" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="AssignedCompanyID" UniqueName="AssignedCompanyID" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="AssignedEmployeeID" UniqueName="AssignedEmployeeID" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="LastAccess" UniqueName="LastAccess" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="LastExit" UniqueName="LastExit" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="ActivatedFrom" UniqueName="ActivatedFrom" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <%--                <telerik:GridBoundColumn DataField="ActivatedOn" UniqueName="ActivatedOn" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>--%>

                <telerik:GridBoundColumn DataField="DeactivatedFrom" UniqueName="DeactivatedFrom" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <%--                <telerik:GridBoundColumn DataField="DeactivatedOn" UniqueName="DeactivatedOn" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>--%>

                <telerik:GridBoundColumn DataField="CreatedFrom" UniqueName="CreatedFrom" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="CreatedOn" UniqueName="CreatedOn" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="EditFrom" UniqueName="EditFrom" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="EditOn" UniqueName="EditOn" ForceExtractValue="Always" Visible="false"></telerik:GridBoundColumn>

            </Columns>

            <%--#################################################################################### Edit Template ########################################################################################################--%>
            <EditFormSettings EditFormType="Template" CaptionDataField="VisitorName" CaptionFormatString="{0}">
                <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
<EditColumn UniqueName="EditCommandColumn1" FilterControlAltText="Filter EditCommandColumn1 column"></EditColumn>
                <FormTemplate>
                    <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                        <table>
                            <tr>
                                <td>
                                    <table id="Table1" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                                        <tr>
                                            <td style="vertical-align: top;">
                                                <table id="Table2" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelInternalID" Text='<%# String.Concat(Resources.Resource.lblChipID, ":") %>'></asp:Label>
                                                        </td>
                                                        <td nowrap="nowrap">
                                                            <asp:Label runat="server" ID="InternalID" Text='<%# Eval("InternalID") %>'></asp:Label>&nbsp;
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelTypeName" Text='<%# String.Concat(Resources.Resource.lblShortTermPassType, ":") %>'></asp:Label>
                                                        </td>
                                                        <td nowrap="nowrap">
                                                            <asp:Label runat="server" ID="TypeName" Text='<%# Eval("TypeName") %>' Width="300px"></asp:Label>&nbsp;
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
                                                            <asp:Label runat="server" ID="LabelShortTermPassID" Text='<%# String.Concat(Resources.Resource.lblPassID, ":") %>'></asp:Label>
                                                        </td>
                                                        <td nowrap="nowrap">
                                                            <asp:Label runat="server" ID="ShortTermPassID" Text='<%# Eval("ShortTermPassID") %>' Width="300px"></asp:Label>&nbsp;
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="LabelActivatedFrom" Text='<%# String.Concat(Resources.Resource.lblPassActivated, ":") %>' runat="server">
                                                            </asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="ActivatedFrom" Text='<%# Eval("ActivatedFrom") %>' runat="server"></asp:Label>&nbsp;
                                                            <asp:Label ID="ActivatedOn" Text='<%# Eval("ActivatedOn") %>' runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="LabelDeactivatedFrom" Text='<%# String.Concat(Resources.Resource.lblPassDeactivated, ":") %>' runat="server">
                                                            </asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="DeactivatedFrom" Text='<%# Eval("DeactivatedFrom") %>' runat="server"></asp:Label>&nbsp;
                                                            <asp:Label ID="DeactivatedOn" Text='<%# Eval("DeactivatedOn") %>' runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="LabelLocked" Text='<%# String.Concat(Resources.Resource.lblPassLocked, ":") %>' runat="server">
                                                            </asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="LockedFrom" Text='<%# Eval("LockedFrom") %>' runat="server"></asp:Label>&nbsp;
                                                            <asp:Label ID="LockedOn" Text='<%# Eval("LockedOn") %>' runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp; </td>
                                                        <td>&nbsp; </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelShortTermVisitorID" Text='<%# String.Concat(Resources.Resource.lblID, ":") %>'></asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:Label runat="server" ID="ShortTermVisitorID" Text='<%# Eval("ShortTermVisitorID") %>'></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelSalutation" Text='<%# String.Concat(Resources.Resource.lblAddrSalutation, ":") %>'></asp:Label>
                                                        </td>
                                                        <td nowrap="nowrap">
                                                            <telerik:RadComboBox runat="server" ID="Salutation" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                                 DataSourceID="SqlDataSource_Salutations" DataValueField="Salutation" DataTextField="Salutation" Width="300" 
                                                                                 AppendDataBoundItems="true" Filter="Contains" AllowCustomText="false"
                                                                                 SelectedValue='<%# Bind("Salutation") %>' DropDownAutoWidth="Enabled">
                                                            </telerik:RadComboBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelFirstName" Text='<%# String.Concat(Resources.Resource.lblAddrFirstName, ":") %>'></asp:Label>
                                                        </td>
                                                        <td nowrap="nowrap">
                                                            <telerik:RadTextBox runat="server" ID="FirstName" Text='<%# Bind("FirstName") %>' Width="300px"></telerik:RadTextBox>&nbsp;
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelLastName" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ":") %>'></asp:Label>
                                                        </td>
                                                        <td nowrap="nowrap">
                                                            <telerik:RadTextBox runat="server" ID="LastName" Text='<%# Bind("LastName") %>' Width="300px"></telerik:RadTextBox>&nbsp;
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelCompany" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'></asp:Label>
                                                        </td>
                                                        <td nowrap="nowrap">
                                                            <telerik:RadTextBox runat="server" ID="Company" Text='<%# Bind("Company") %>' Width="300px"></telerik:RadTextBox>&nbsp;
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelNationalityID" Text='<%# String.Concat(Resources.Resource.lblNationality, ":") %>'></asp:Label>
                                                        </td>
                                                        <td>
                                                            <telerik:RadComboBox runat="server" ID="NationalityID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataSourceID="SqlDataSource_Countries"
                                                                                 DataValueField="CountryID" DataTextField="CountryName" Width="300" Filter="Contains" SelectedValue='<%# Bind("NationalityID") %>'
                                                                                 AppendDataBoundItems="true" DropDownAutoWidth="Enabled">
                                                                <ItemTemplate>
                                                                    <table cellpadding="5px" style="text-align: left;">
                                                                        <tr>
                                                                            <td style="background-color: #EFEFEF; text-align: left;">
                                                                                <asp:Image ID="ItemImage" ImageUrl='<%# String.Format("~/Resources/Icons/Flags/{0}", Eval("FlagName"))%>' runat="server" />
                                                                            </td>
                                                                            <td style="text-align: left;">
                                                                                <asp:Label ID="ItemName" Text='<%# Eval("CountryID") %>' runat="server">
                                                                                </asp:Label>
                                                                            </td>
                                                                            <td style="text-align: left;">
                                                                                <asp:Label ID="ItemDescr" Text='<%# Eval("CountryName") %>' runat="server">
                                                                                </asp:Label>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </ItemTemplate>
                                                                <Items>
                                                                    <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                                                                </Items>
                                                            </telerik:RadComboBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelIdentifiedWith" Text='<%# String.Concat(Resources.Resource.lblIdentifiedWith, ":") %>'></asp:Label>
                                                        </td>
                                                        <td nowrap="nowrap">
                                                            <telerik:RadTextBox runat="server" ID="IdentifiedWith" Text='<%# Bind("IdentifiedWith") %>' Width="300px"></telerik:RadTextBox>&nbsp;
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelDocumentID" Text='<%# String.Concat(Resources.Resource.lblDocumentID, ":") %>'></asp:Label>
                                                        </td>
                                                        <td nowrap="nowrap">
                                                            <telerik:RadTextBox runat="server" ID="DocumentID" Text='<%# Bind("DocumentID") %>' Width="300px"></telerik:RadTextBox>&nbsp;
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelAssignedCompanyID1" Text='<%# String.Concat(Resources.Resource.lblWorksAtCompany, ":") %>'></asp:Label>
                                                        </td>
                                                        <td>
                                                            <telerik:RadComboBox runat="server" ID="AssignedCompanyID1" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                                 DataSourceID="SqlDataSource_Companies" DataValueField="CompanyID" DataTextField="CompanyName" Width="300" 
                                                                                 AppendDataBoundItems="true" Filter="Contains" SelectedValue='<%# Bind("AssignedCompanyID") %>' DropDownAutoWidth="Enabled"
                                                                                 OnSelectedIndexChanged="AssignedCompanyID1_SelectedIndexChanged" AutoPostBack="true" CausesValidation="false">
                                                                <Items>
                                                                    <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                                                                </Items>
                                                            </telerik:RadComboBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelAssignedEmployeeID1" Text='<%# String.Concat(Resources.Resource.lblAssignedToEmployee, ":") %>'></asp:Label>
                                                        </td>
                                                        <td>
                                                            <telerik:RadComboBox runat="server" ID="AssignedEmployeeID1" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                                 DataValueField="EmployeeID" DataTextField="EmployeeName" Width="300" EnableLoadOnDemand="true" 
                                                                                 AppendDataBoundItems="true" Filter="Contains" DropDownAutoWidth="Enabled" OnItemsRequested="AssignedEmployeeID1_ItemsRequested">
                                                                <Items>
                                                                    <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                                                                </Items>
                                                            </telerik:RadComboBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelAssignedCompanyID2" Text='<%# String.Concat(Resources.Resource.lblVisitsCompany, ":") %>'></asp:Label>
                                                        </td>
                                                        <td>
                                                            <telerik:RadComboBox runat="server" ID="AssignedCompanyID2" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                                 DataSourceID="SqlDataSource_Companies" DataValueField="CompanyID" DataTextField="CompanyName" Width="300" 
                                                                                 AppendDataBoundItems="true" Filter="Contains" SelectedValue='<%# Bind("AssignedCompanyID") %>' DropDownAutoWidth="Enabled"
                                                                                 OnSelectedIndexChanged="AssignedCompanyID2_SelectedIndexChanged" AutoPostBack="true" CausesValidation="false">
                                                                <Items>
                                                                    <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                                                                </Items>
                                                            </telerik:RadComboBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelAssignedEmployeeID2" Text='<%# String.Concat(Resources.Resource.lblVisitsEmployee, ":") %>'></asp:Label>
                                                        </td>
                                                        <td>
                                                            <telerik:RadComboBox runat="server" ID="AssignedEmployeeID2" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                                 DataValueField="EmployeeID" DataTextField="EmployeeName" Width="300" EnableLoadOnDemand="true" 
                                                                                 AppendDataBoundItems="true" Filter="Contains" DropDownAutoWidth="Enabled" OnItemsRequested="AssignedEmployeeID2_ItemsRequested">
                                                                <Items>
                                                                    <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                                                                </Items>
                                                            </telerik:RadComboBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelAccessAllowedUntil" Text='<%# String.Concat(Resources.Resource.lblAccessAllowedUntil, ":") %>'></asp:Label>
                                                        </td>
                                                        <td>
                                                            <telerik:RadDateTimePicker ID="AccessAllowedUntil" runat="server" DbSelectedDate='<%# Bind("AccessAllowedUntil") %>' 
                                                                                       MinDate="<%# DateTime.Now %>" MaxDate="2100/1/1" EnableShadows="true"
                                                                                       ShowPopupOnFocus="true" >
                                                                <Calendar runat="server">
                                                                    <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                                                            TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                                                    </FastNavigationSettings>
                                                                </Calendar>
                                                            </telerik:RadDateTimePicker>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="LabelLastAccess" Text='<%# String.Concat(Resources.Resource.lblLastAccess, ":") %>' runat="server">
                                                            </asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="LastAccess" Text='<%# Eval("LastAccess") %>' runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="LabelLastExit" Text='<%# String.Concat(Resources.Resource.lblLastExit, ":") %>' runat="server">
                                                            </asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="LastExit" Text='<%# Eval("LastExit") %>' runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp; </td>
                                                        <td>&nbsp; </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="LabelCreatedFrom" Text='<%# String.Concat(Resources.Resource.lblVisitorCreated, ":") %>' runat="server">
                                                            </asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="CreatedFrom" Text='<%# Eval("CreatedFrom") %>' runat="server"></asp:Label>&nbsp;
                                                            <asp:Label ID="CreatedOn" Text='<%# Eval("CreatedOn") %>' runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="LabelEditFrom" Text='<%# String.Concat(Resources.Resource.lblVisitorEdited, ":") %>' runat="server">
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
                                                <telerik:RadButton ID="btnUpdateShortTermPass" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionUpdate%>'
                                                                   runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' Icon-PrimaryIconCssClass="rbOk">
                                                </telerik:RadButton>
                                                <telerik:RadButton ID="btnCancel" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                                   CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                                </telerik:RadButton>
                                                <telerik:RadButton ID="btnDeactivate" runat="server" ButtonType="StandardButton" Text="<%$ Resources:Resource, lblPassDeactivate %>"
                                                                   CommandName="Update" CommandArgument="DeactivateIt" Visible="false">
                                                    <Icon PrimaryIconUrl="/InSiteApp/Resources/Icons/locked_16.png" PrimaryIconHeight="16px" PrimaryIconWidth="16px" />
                                                </telerik:RadButton>
                                                <telerik:RadButton ID="btnActivate" runat="server" ButtonType="StandardButton" Text="<%$ Resources:Resource, lblPassActivate %>"
                                                                   CommandName="ActivateIt" CommandArgument='<%# Eval("ShortTermPassID") %>' Visible="false">
                                                </telerik:RadButton>
                                                <telerik:RadButton ID="btnLock" runat="server" ButtonType="StandardButton" Text="<%$ Resources:Resource, lblPassLock %>"
                                                                   CommandName="LockIt" CommandArgument='<%# Eval("ShortTermPassID") %>' Visible="false">
                                                </telerik:RadButton>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td valign="top">
                                    <table>
                                        <tr>
                                            <td colspan="2">
                                                <telerik:RadAjaxPanel runat="server" ID="AccessAreasPanel">
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="LabelAssignedAreas" Text='<%# String.Concat(Resources.Resource.lblAssignedAreas, ":") %>'></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <telerik:RadGrid runat="server" ID="AssignedAreas" DataSourceID="SqlDataSource_ShortTermAccessAreas" CssClass="RadGrid"
                                                                                 AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowAutomaticUpdates="true"
                                                                                 OnItemCommand="AssignedAreas_ItemCommand" OnItemDeleted="AssignedAreas_ItemDeleted" OnItemCreated="AssignedAreas_ItemCreated"
                                                                                 OnItemInserted="AssignedAreas_ItemInserted" OnItemUpdated="AssignedAreas_ItemUpdated">

                                                                    <ValidationSettings ValidationGroup="AssignedAreas" EnableValidation="false" />

                                                                    <MasterTableView DataSourceID="SqlDataSource_ShortTermAccessAreas" AutoGenerateColumns="false" AllowPaging="true" PageSize="5"
                                                                                     CommandItemDisplay="Top" CssClass="MasterClass" EditMode="EditForms" DataKeyNames="SystemID,BpID,ShortTermVisitorID,AccessAreaID,TimeSlotGroupID">

                                                                        <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="false"
                                                                                             ShowExportToExcelButton="false" ShowExportToPdfButton="false"
                                                                                             AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                                                                        <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="false" />

                                                                        <Columns>
                                                                            <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn1" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                                                                                           UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                                                                                <ItemStyle BackColor="Control" Width="30px" />
                                                                                <HeaderStyle Width="30px" />
                                                                            </telerik:GridEditCommandColumn>

                                                                            <telerik:GridBoundColumn DataField="AccessAreaID" UniqueName="AccessAreaID" ForceExtractValue="Always" Visible="false">
                                                                            </telerik:GridBoundColumn>

                                                                            <telerik:GridBoundColumn DataField="TimeSlotGroupID" UniqueName="TimeSlotGroupID" ForceExtractValue="Always" Visible="false">
                                                                            </telerik:GridBoundColumn>

                                                                            <telerik:GridBoundColumn DataField="AccessAreaName" HeaderText="<%$ Resources:Resource, lblAccessArea %>">
                                                                            </telerik:GridBoundColumn>

                                                                            <telerik:GridBoundColumn DataField="TimeSlotGroupName" HeaderText="<%$ Resources:Resource, lblTimeSlotGroup %>">
                                                                            </telerik:GridBoundColumn>

                                                                            <telerik:GridTemplateColumn DataField="AdditionalRights" HeaderText="<%$ Resources:Resource, lblAdditionalRight %>">
                                                                                <ItemTemplate>
                                                                                    <asp:Label runat="server" Text='<%# (Convert.ToInt32(((System.Data.DataRowView)Container.DataItem)["AdditionalRights"]) == 1) ? Resources.Resource.selAdditionalRightCar : Resources.Resource.selAdditionalRightNone  %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridBoundColumn DataField="CreatedFrom" UniqueName="CreatedFrom" ForceExtractValue="Always" Visible="false">
                                                                            </telerik:GridBoundColumn>

                                                                            <telerik:GridBoundColumn DataField="CreatedOn" UniqueName="CreatedOn" ForceExtractValue="Always" Visible="false">
                                                                            </telerik:GridBoundColumn>

                                                                            <telerik:GridBoundColumn DataField="EditFrom" UniqueName="EditFrom" ForceExtractValue="Always" Visible="false">
                                                                            </telerik:GridBoundColumn>

                                                                            <telerik:GridBoundColumn DataField="EditOn" UniqueName="EditOn" ForceExtractValue="Always" Visible="false">
                                                                            </telerik:GridBoundColumn>

                                                                            <telerik:GridTemplateColumn DataField="AccessState" HeaderText="<%$ Resources:Resource, lblActualStatus %>">
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="AccessState" runat="server" Text='<%# GetAccessState(Convert.ToInt32(((System.Data.DataRowView)Container.DataItem)["AccessState"])) %>'>
                                                                                    </asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridButtonColumn UniqueName="deleteColumn2" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                                                                                      ConfirmDialogType="RadWindow"
                                                                                                      ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                                                                                <ItemStyle BackColor="Control" />
                                                                            </telerik:GridButtonColumn>
                                                                        </Columns>

                                                                        <EditFormSettings CaptionDataField="AccessAreaName" CaptionFormatString="{0}" EditFormType="Template">
                                                                            <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                                                                            <EditColumn ButtonType="ImageButton" UniqueName="EditColumn2" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                                                                                        EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                                                                            <FormTableStyle CellPadding="3" CellSpacing="3" />
                                                                            <FormTemplate>
                                                                                <table>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAccessArea, ":") %>' Font-Bold="true"></asp:Label>
                                                                                        </td>
                                                                                        <td nowrap="nowrap">
                                                                                            <telerik:RadComboBox runat="server" ID="AccessAreaID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                                                                 DataSourceID='<%# (Container is GridEditFormInsertItem) ? "SqlDataSource_AccessAreas" : "SqlDataSource_AccessAreas1" %>' AppendDataBoundItems="true"
                                                                                                                 DataValueField="AccessAreaID" DataTextField="NameVisible" Width="300" Filter="Contains" 
                                                                                                                 DropDownAutoWidth="Enabled" Enabled='<%# (Container is GridEditFormInsertItem) ? true : false %>'
                                                                                                                 SelectedValue='<%# Bind("AccessAreaID") %>'>
                                                                                            </telerik:RadComboBox>
                                                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="AccessAreaID" Text="*" SetFocusOnError="true" ForeColor="Red"
                                                                                                                        ErrorMessage='<%# String.Concat(Resources.Resource.lblAccessArea, " ", Resources.Resource.lblRequired) %>'
                                                                                                                        ValidationGroup="AccessArea">
                                                                                            </asp:RequiredFieldValidator>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblTimeSlotGroup, ":") %>' Font-Bold="true"></asp:Label>
                                                                                        </td>
                                                                                        <td nowrap="nowrap">
                                                                                            <telerik:RadComboBox runat="server" ID="TimeSlotGroupID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                                                                 DataSourceID="SqlDataSource_TimeSlotGroups" AppendDataBoundItems="true"
                                                                                                                 DataValueField="TimeSlotGroupID" DataTextField="NameVisible" Width="300" Filter="Contains" 
                                                                                                                 SelectedValue='<%# Bind("TimeSlotGroupID") %>' DropDownAutoWidth="Enabled">
                                                                                            </telerik:RadComboBox>
                                                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="TimeSlotGroupID" Text="*" SetFocusOnError="true" ForeColor="Red"
                                                                                                                        ErrorMessage='<%# String.Concat(Resources.Resource.lblTimeSlotGroup, " ", Resources.Resource.lblRequired) %>'
                                                                                                                        ValidationGroup="AccessArea">
                                                                                            </asp:RequiredFieldValidator>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAdditionalRight, ":") %>' Font-Bold="true"></asp:Label>
                                                                                        </td>
                                                                                        <td nowrap="nowrap">
                                                                                            <telerik:RadComboBox runat="server" ID="AdditionalRights" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                                                                 AppendDataBoundItems="true" Width="300" Filter="Contains" 
                                                                                                                 SelectedValue='<%# Bind("AdditionalRights") %>' DropDownAutoWidth="Enabled">
                                                                                                <Items>
                                                                                                    <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selAdditionalRightNone %>" Selected="true" Value="0" />
                                                                                                    <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selAdditionalRightCar %>" Value="1" />
                                                                                                </Items>
                                                                                            </telerik:RadComboBox>
                                                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="AdditionalRights" Text="*" SetFocusOnError="true" ForeColor="Red"
                                                                                                                        ErrorMessage='<%# String.Concat(Resources.Resource.lblTimeSlotGroup, " ", Resources.Resource.lblRequired) %>'
                                                                                                                        ValidationGroup="AccessArea">
                                                                                            </asp:RequiredFieldValidator>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>&nbsp;</td>
                                                                                        <td>&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblCreatedFrom, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblCreatedOn, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("CreatedOn") %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblEditFrom, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("EditFrom") %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblEditOn, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("EditOn") %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td colspan="2">
                                                                                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' 
                                                                                                                   ShowMessageBox="true" ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true"
                                                                                                                   ValidationGroup="AccessArea" />
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>&nbsp; </td>
                                                                                        <td>&nbsp; </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td align="left" colspan="2">
                                                                                            <telerik:RadButton ID="btnUpdate1" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionUpdate%>'
                                                                                                               runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update"%>' Icon-PrimaryIconCssClass="rbOk"
                                                                                                               ValidationGroup="AccessArea">
                                                                                            </telerik:RadButton>
                                                                                            <telerik:RadButton ID="btnCancel1" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                                                                               CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                                                                            </telerik:RadButton>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </FormTemplate>
                                                                        </EditFormSettings>
                                                                    </MasterTableView>
                                                                </telerik:RadGrid>

                                                                <asp:SqlDataSource ID="SqlDataSource_ShortTermAccessAreas" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                                                                   OldValuesParameterFormatString="original_{0}"
                                                                                   SelectCommand="SELECT DISTINCT d_staa.AccessAreaID, m_aa.NameVisible AS AccessAreaName, m_aa.DescriptionShort, d_staa.BpID, m_tsg.NameVisible AS TimeSlotGroupName, d_staa.TimeSlotGroupID, d_staa.CreatedFrom, d_staa.CreatedOn, d_staa.EditFrom, d_staa.EditOn, d_staa.ShortTermVisitorID, d_staa.SystemID, dbo.ShortTermAccessAreaPresentState(d_staa.SystemID, d_staa.BpID, d_staa.ShortTermVisitorID, d_staa.AccessAreaID) AS AccessState, d_staa.AdditionalRights FROM Master_AccessAreas AS m_aa INNER JOIN Data_ShortTermAccessAreas AS d_staa ON m_aa.SystemID = d_staa.SystemID AND m_aa.BpID = d_staa.BpID AND m_aa.AccessAreaID = d_staa.AccessAreaID LEFT OUTER JOIN Master_TimeSlotGroups AS m_tsg ON d_staa.TimeSlotGroupID = m_tsg.TimeSlotGroupID AND d_staa.BpID = m_tsg.BpID AND d_staa.SystemID = m_tsg.SystemID WHERE (d_staa.BpID = @BpID) AND (d_staa.ShortTermVisitorID = @ShortTermVisitorID) AND (d_staa.SystemID = @SystemID)"
                                                                                   DeleteCommand="DELETE Data_ShortTermAccessAreas WHERE (SystemID = @original_SystemID) AND (BpID = @original_BpID) AND (ShortTermVisitorID = @original_ShortTermVisitorID) AND (AccessAreaID = @original_AccessAreaID) AND (TimeSlotGroupID = @original_TimeSlotGroupID)"
                                                                                   InsertCommand="INSERT INTO Data_ShortTermAccessAreas(SystemID, BpID, ShortTermVisitorID, AccessAreaID, TimeSlotGroupID, CreatedFrom, CreatedOn, EditFrom, EditOn, AdditionalRights) VALUES (@SystemID, @BpID, @ShortTermVisitorID, @AccessAreaID, @TimeSlotGroupID, @UserName, SYSDATETIME(), @UserName, SYSDATETIME(), @AdditionalRights)"
                                                                                   UpdateCommand="UPDATE Data_ShortTermAccessAreas SET TimeSlotGroupID = @TimeSlotGroupID, EditFrom = @UserName, EditOn = SYSDATETIME(), AdditionalRights = @AdditionalRights WHERE (SystemID = @original_SystemID) AND (BpID = @original_BpID) AND (ShortTermVisitorID = @original_ShortTermVisitorID) AND (AccessAreaID = @original_AccessAreaID) AND (TimeSlotGroupID = @original_TimeSlotGroupID)">
                                                                    <DeleteParameters>
                                                                        <asp:Parameter Name="original_SystemID"></asp:Parameter>
                                                                        <asp:Parameter Name="original_BpID"></asp:Parameter>
                                                                        <asp:Parameter Name="original_ShortTermVisitorID"></asp:Parameter>
                                                                        <asp:Parameter Name="original_AccessAreaID"></asp:Parameter>
                                                                        <asp:Parameter Name="original_TimeSlotGroupID"></asp:Parameter>
                                                                    </DeleteParameters>
                                                                    <InsertParameters>
                                                                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                                                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                                                        <asp:ControlParameter ControlID="ShortTermVisitorID" PropertyName="Text" DefaultValue="0" Name="ShortTermVisitorID"></asp:ControlParameter>
                                                                        <asp:Parameter Name="AccessAreaID"></asp:Parameter>
                                                                        <asp:Parameter Name="TimeSlotGroupID"></asp:Parameter>
                                                                        <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
                                                                        <asp:Parameter Name="AdditionalRights"></asp:Parameter>
                                                                    </InsertParameters>
                                                                    <SelectParameters>
                                                                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                                                        <asp:ControlParameter ControlID="ShortTermVisitorID" PropertyName="Text" DefaultValue="0" Name="ShortTermVisitorID"></asp:ControlParameter>
                                                                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                                                    </SelectParameters>
                                                                    <UpdateParameters>
                                                                        <asp:Parameter Name="TimeSlotGroupID"></asp:Parameter>
                                                                        <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
                                                                        <asp:Parameter Name="AdditionalRights"></asp:Parameter>
                                                                        <asp:Parameter Name="original_SystemID"></asp:Parameter>
                                                                        <asp:Parameter Name="original_BpID"></asp:Parameter>
                                                                        <asp:Parameter Name="original_ShortTermVisitorID"></asp:Parameter>
                                                                        <asp:Parameter Name="original_AccessAreaID"></asp:Parameter>
                                                                        <asp:Parameter Name="original_TimeSlotGroupID"></asp:Parameter>
                                                                    </UpdateParameters>
                                                                </asp:SqlDataSource>

                                                                <asp:SqlDataSource runat="server" ID="SqlDataSource_TimeSlotGroups" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                                                                                   SelectCommand="SELECT * FROM [Master_TimeSlotGroups] WHERE (([SystemID] = @SystemID) AND ([BpID] = @BpID)) ORDER BY [NameVisible]">
                                                                    <SelectParameters>
                                                                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
                                                                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
                                                                    </SelectParameters>
                                                                </asp:SqlDataSource>

                                                                <asp:SqlDataSource ID="SqlDataSource_AccessAreas" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                                                                   SelectCommand="SELECT DISTINCT SystemID, BpID, AccessAreaID, NameVisible, DescriptionShort, AccessTimeRelevant, CheckInCompelling, UniqueAccess, CheckOutCompelling, CompleteAccessTimes, PresentTimeHours, PresentTimeMinutes, CreatedFrom, CreatedOn, EditFrom, EditOn FROM Master_AccessAreas AS aa WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (NOT EXISTS (SELECT 1 AS Expr1 FROM Data_ShortTermAccessAreas AS eaa WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (ShortTermVisitorID = @ShortTermVisitorID) AND (AccessAreaID = aa.AccessAreaID)))">
                                                                    <SelectParameters>
                                                                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                                                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                                                        <asp:ControlParameter ControlID="ShortTermVisitorID" PropertyName="Text" DefaultValue="0" Name="ShortTermVisitorID"></asp:ControlParameter>
                                                                    </SelectParameters>
                                                                </asp:SqlDataSource>

                                                                <asp:SqlDataSource ID="SqlDataSource_AccessAreas1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                                                                   SelectCommand="SELECT DISTINCT * FROM Master_AccessAreas aa WHERE aa.SystemID = @SystemID AND aa.BpID = @BpID">
                                                                    <SelectParameters>
                                                                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                                                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                                                    </SelectParameters>
                                                                </asp:SqlDataSource>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </telerik:RadAjaxPanel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <uc1:wcShortTermPassAccess ID="wcShortTermPassAccess1" runat="server" InternalId='<%#Eval("InternalID") %>' />
                                            </td>
                                            <td>&nbsp; </td>
                                        </tr>

                                    </table>
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
                            <b><%= Resources.Resource.lblDetailsFor %> <%# Eval("VisitorName") %></b>
                        </legend>
                        <table>
                            <tr>
                                <td>
                                    <table style="width: 100%;" nowrap="nowrap">
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelInternalID" Text='<%# String.Concat(Resources.Resource.lblChipID, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="InternalID" Text='<%# Eval("InternalID") %>' Width="300px"></asp:Label>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelTypeName" Text='<%# String.Concat(Resources.Resource.lblShortTermPassType, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="TypeName" Text='<%# Eval("TypeName") %>' Width="300px"></asp:Label>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelShortTermPassID" Text='<%# String.Concat(Resources.Resource.lblPassID, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="ShortTermPassID" Text='<%# Eval("ShortTermPassID") %>' Width="300px"></asp:Label>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label ID="LabelActivatedFrom" Text='<%# String.Concat(Resources.Resource.lblPassActivated, ":") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="ActivatedFrom" Text='<%# Eval("ActivatedFrom") %>' runat="server"></asp:Label>&nbsp;
                                                <asp:Label ID="ActivatedOn" Text='<%# Eval("ActivatedOn") %>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label ID="LabelDeactivatedFrom" Text='<%# String.Concat(Resources.Resource.lblPassDeactivated, ":") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="DeactivatedFrom" Text='<%# Eval("DeactivatedFrom") %>' runat="server"></asp:Label>&nbsp;
                                                <asp:Label ID="DeactivatedOn" Text='<%# Eval("DeactivatedOn") %>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label ID="LabelLockedFrom" Text='<%# String.Concat(Resources.Resource.lblPassLocked, ":") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="LockedFrom" Text='<%# Eval("LockedFrom") %>' runat="server"></asp:Label>&nbsp;
                                                <asp:Label ID="LockedOn" Text='<%# Eval("LockedOn") %>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelShortTermVisitorID" Text='<%# String.Concat(Resources.Resource.lblID, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="ShortTermVisitorID" Text='<%# Eval("ShortTermVisitorID") %>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelSalutation" Text='<%# String.Concat(Resources.Resource.lblAddrSalutation, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="Salutation" Text='<%# Eval("Salutation") %>' Width="300px"></asp:Label>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelFirstName" Text='<%# String.Concat(Resources.Resource.lblAddrFirstName, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="FirstName" Text='<%# Eval("FirstName") %>' Width="300px"></asp:Label>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelLastName" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LastName" Text='<%# Eval("LastName") %>' Width="300px"></asp:Label>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelCompany" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="Company" Text='<%# Eval("Company") %>' Width="300px"></asp:Label>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelIdentifiedWith" Text='<%# String.Concat(Resources.Resource.lblIdentifiedWith, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="IdentifiedWith" Text='<%# Eval("IdentifiedWith") %>' Width="300px"></asp:Label>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelDocumentID" Text='<%# String.Concat(Resources.Resource.lblDocumentID, ":") %>'></asp:Label>
                                            </td>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="DocumentID" Text='<%# Eval("DocumentID") %>' Width="300px"></asp:Label>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelAssignedCompanyID1" Text='<%# String.Concat(Resources.Resource.lblWorksAtCompany, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="AssignedCompanyID1" Text='<%# Eval("CompanyName") %>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelAssignedEmployeeID1" Text='<%# String.Concat(Resources.Resource.lblAssignedToEmployee, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="AssignedEmployeeID1" Text='<%# Eval("EmployeeName") %>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelAssignedCompanyID2" Text='<%# String.Concat(Resources.Resource.lblVisitsCompany, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="AssignedCompanyID2" Text='<%# Eval("CompanyName") %>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelAssignedEmployeeID2" Text='<%# String.Concat(Resources.Resource.lblVisitsEmployee, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="AssignedEmployeeID2" Text='<%# Eval("EmployeeName") %>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelAccessAllowedUntil" Text='<%# String.Concat(Resources.Resource.lblAccessAllowedUntil, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="AccessAllowedUntil" Text='<%# Eval("AccessAllowedUntil") %>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label ID="LabelLastAccess" Text='<%# String.Concat(Resources.Resource.lblLastAccess, ":") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="LastAccess" Text='<%# Eval("LastAccess") %>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label ID="LabelLastExit" Text='<%# String.Concat(Resources.Resource.lblLastExit, ":") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="LastExit" Text='<%# Eval("LastExit") %>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label ID="LabelCreatedFrom" Text='<%# String.Concat(Resources.Resource.lblVisitorCreated, ":") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="CreatedFrom" Text='<%# Eval("CreatedFrom") %>' runat="server"></asp:Label>&nbsp;
                                                <asp:Label ID="LabelCreatedOn" Text='<%# Eval("CreatedOn") %>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label ID="LabelEditFrom" Text='<%# String.Concat(Resources.Resource.lblVisitorEdited, ":") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="EditFrom" Text='<%# Eval("EditFrom") %>' runat="server"></asp:Label>&nbsp;
                                                <asp:Label ID="Label3" Text='<%# Eval("EditOn") %>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td valign="top">
                                    <table>
                                        <tr>
                                            <td colspan="2">
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelAvailableAreas" Text='<%# String.Concat(Resources.Resource.lblAvailableAreas, ":") %>'></asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelAssignedAreas" Text='<%# String.Concat(Resources.Resource.lblAssignedAreas, ":") %>'></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <telerik:RadListBox ID="AvailableAreas" runat="server" DataValueField="AccessAreaID" DataSourceID="SqlDataSource_AccessAreas" DataKeyField="AccessAreaID"
                                                                                DataTextField="NameVisible" Width="211px" Height="100px"
                                                                                AllowTransfer="true" TransferToID="AssignedAreas" Enabled="false">
                                                            </telerik:RadListBox>
                                                        </td>
                                                        <td>
                                                            <telerik:RadListBox ID="AssignedAreas" runat="server" DataSourceID="SqlDataSource_ShortTermAccessAreas1" DataValueField="AccessAreaID"
                                                                                DataKeyField="AccessAreaID" DataTextField="NameVisible" Width="211px" Height="100px" Enabled="false">
                                                            </telerik:RadListBox>
                                                        </td>
                                                    </tr>
                                                </table>

                                                <asp:SqlDataSource ID="SqlDataSource_AccessAreas" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                                                   SelectCommand="SELECT SystemID, BpID, AccessAreaID, NameVisible, DescriptionShort, AccessTimeRelevant, CheckInCompelling, UniqueAccess, CheckOutCompelling, CompleteAccessTimes, PresentTimeHours, PresentTimeMinutes, CreatedFrom, CreatedOn, EditFrom, EditOn FROM Master_AccessAreas AS aa WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (NOT EXISTS (SELECT 1 AS Expr1 FROM Data_ShortTermAccessAreas AS eaa WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (ShortTermVisitorID = @ShortTermVisitorID) AND (AccessAreaID = aa.AccessAreaID)))">
                                                    <SelectParameters>
                                                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                                        <asp:ControlParameter ControlID="ShortTermVisitorID" PropertyName="Text" DefaultValue="0" Name="ShortTermVisitorID"></asp:ControlParameter>

                                                    </SelectParameters>
                                                </asp:SqlDataSource>

                                                <asp:SqlDataSource ID="SqlDataSource_ShortTermAccessAreas1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                                                   SelectCommand="SELECT Data_ShortTermAccessAreas.AccessAreaID, Master_AccessAreas.NameVisible, Master_AccessAreas.DescriptionShort FROM Master_AccessAreas INNER JOIN Data_ShortTermAccessAreas ON Master_AccessAreas.SystemID = Data_ShortTermAccessAreas.SystemID AND Master_AccessAreas.BpID = Data_ShortTermAccessAreas.BpID AND Master_AccessAreas.AccessAreaID = Data_ShortTermAccessAreas.AccessAreaID WHERE (Data_ShortTermAccessAreas.SystemID = @SystemID) AND (Data_ShortTermAccessAreas.BpID = @BpID) AND (Data_ShortTermAccessAreas.ShortTermVisitorID = @ShortTermVisitorID)">
                                                    <SelectParameters>
                                                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                                        <asp:ControlParameter ControlID="ShortTermVisitorID" PropertyName="Text" DefaultValue="0" Name="ShortTermVisitorID"></asp:ControlParameter>
                                                    </SelectParameters>
                                                </asp:SqlDataSource>
                                            </td>
                                        </tr>
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

    <telerik:RadButton ID="BtnEditPass" runat="server" Visible="true" OnClick="BtnEditPass_Click" AutoPostBack="false" Width="0px" Height="0px" ButtonType="ToggleButton" 
                       BackColor="Transparent" BorderWidth="0px" BorderStyle="None"></telerik:RadButton>

    <asp:SqlDataSource ID="SqlDataSource_ShortTermVisitors" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT d_stv.ShortTermVisitorID, m_stpt.NameVisible AS TypeName, d_stv.PassInternalID AS InternalID, d_stv.PassStatusID AS StatusID, d_stv.FirstName, d_stv.LastName, d_stv.Company, m_c.NameVisible AS CompanyName, m_a.FirstName + ' ' + m_a.LastName AS EmployeeName, d_stv.AccessAllowedUntil, d_stv.EditOn, d_stv.PassActivatedFrom AS ActivatedFrom, d_stv.PassActivatedOn AS ActivatedOn, d_stv.PassDeactivatedFrom AS DeactivatedFrom, d_stv.PassDeactivatedOn AS DeactivatedOn, d_stv.LastAccess, d_stv.LastExit, d_stv.CreatedFrom, d_stv.CreatedOn, d_stv.EditFrom, d_stv.Salutation, d_stv.ShortTermPassID, d_stv.IdentifiedWith, d_stv.AssignedCompanyID, d_stv.AssignedEmployeeID, d_stv.SystemID, d_stv.BpID, d_stv.DocumentID, d_stv.FirstName + ' ' + d_stv.LastName AS VisitorName, d_stv.PassLockedFrom AS LockedFrom, d_stv.PassLockedOn AS LockedOn, d_stv.NationalityID FROM Master_Addresses AS m_a INNER JOIN Master_Employees AS m_e ON m_a.SystemID = m_e.SystemID AND m_a.BpID = m_e.BpID AND m_a.AddressID = m_e.AddressID RIGHT OUTER JOIN Data_ShortTermVisitors AS d_stv INNER JOIN Master_ShortTermPassTypes AS m_stpt ON d_stv.SystemID = m_stpt.SystemID AND d_stv.BpID = m_stpt.BpID AND d_stv.ShortTermPassTypeID = m_stpt.ShortTermPassTypeID ON m_e.SystemID = d_stv.SystemID AND m_e.BpID = d_stv.BpID AND m_e.EmployeeID = d_stv.AssignedEmployeeID LEFT OUTER JOIN Master_Companies AS m_c ON d_stv.SystemID = m_c.SystemID AND d_stv.BpID = m_c.BpID AND d_stv.AssignedCompanyID = m_c.CompanyID WHERE (d_stv.SystemID = @SystemID) AND (d_stv.BpID = @BpID) ORDER BY d_stv.EditOn DESC">
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Companies" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT c.SystemID, c.BpID, c.CompanyID, c.NameVisible, c.NameAdditional, c.Description, c.AddressID, c.IsVisible, c.IsValid, c.TradeAssociation, c.BlnSOKA, c.CreatedFrom, c.CreatedOn, c.EditFrom, c.EditOn, a.Address1, a.Address2, a.Zip, a.City, a.State, a.CountryID, a.Phone, a.Email, a.WWW, c.NameVisible + (CASE WHEN c.NameAdditional IS NULL THEN '' ELSE ', ' + c.NameAdditional END) + (CASE WHEN a.City IS NULL THEN '' ELSE ', ' + a.City END) AS CompanyName FROM Master_Companies AS c LEFT OUTER JOIN System_Addresses AS a ON c.SystemID = a.SystemID AND c.AddressID = a.AddressID WHERE (c.SystemID = @SystemID) AND (c.BpID = @BpID) AND c.ReleaseOn IS NOT NULL AND c.LockedOn IS NULL AND (c.CompanyCentralID = (CASE WHEN @CompanyID = 0 THEN c.CompanyCentralID ELSE @CompanyID END)) ORDER BY c.NameVisible">
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="CompanyID" DefaultValue="0" Name="CompanyID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_ShortTermPassTypes" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT *, NameVisible TypeName FROM [Master_ShortTermPassTypes] WHERE (([SystemID] = @SystemID) AND ([BpID] = @BpID)) ORDER BY [NameVisible]">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Countries" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT Master_Countries.CountryID, Master_Countries.NameVisible AS CountryName, View_Countries.FlagName FROM Master_Countries INNER JOIN View_Countries ON Master_Countries.CountryID = View_Countries.CountryID WHERE (Master_Countries.SystemID = @SystemID) AND (Master_Countries.BpID = @BpID) order by Master_Countries.NameVisible">
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Salutations" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT * FROM System_Salutations ">
    </asp:SqlDataSource>
</asp:Content>
