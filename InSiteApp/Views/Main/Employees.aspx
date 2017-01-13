<%@ Page Title="<%$ Resources:Resource, lblEmployeesMaster %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Employees.aspx.cs"
Inherits="InSite.App.Views.Main.Employees" %>

<%--<%@ Register Src="~/Controls/EmployeeDetails.ascx" TagPrefix="UserControls" TagName="EmployeeDetails" %>--%>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
        <script type="text/javascript">
            function openRadWindow(EmployeeID, LastName, FirstName, Action) {
                var masterTable = $find("<%= RadGrid1.ClientID %>").get_masterTableView();
                masterTable.fireCommand("HideScanner", true);

                var oWnd = radopen("PassActions.aspx?EmployeeID=" + EmployeeID + "&LastName=" + LastName + "&FirstName=" + FirstName + "&Action=" + Action, "RadWindow1");
                oWnd.add_close(OnClientCloseRadWindow);
                oWnd.center();
                oWnd.add_pageLoad(OnClientPageLoad);
            }

            function OnClientPageLoad(sender, eventArgs) {
                //console.group("Employees#OnClientPageLoad");
                //console.log("document.URL=%s\nsender: %s\nargs: %s", document.URL, sender, eventArgs);

                var iframe = sender.get_contentFrame();
                var doc = iframe.contentWindow.document;
                passActions.doc = doc;
                var elem = doc.getElementById("cardState");
                //console.log("elem: %s", elem);
                cardStateColors.setStyleElement(elem);
                sender.remove_pageLoad(OnClientPageLoad);

                cardReader.register(passActions);
                //console.groupEnd();
            }

            function openEmployeeAccessRight(EmployeeID) {
                var oWnd = radopen("EmployeeAccessRightInfo.aspx?EmployeeID=" + EmployeeID, "RadWindow2");
                oWnd.center();
            }

            function OnClientCloseRadWindow(oWnd, eventArgs) {
                var masterTable = $find("<%= RadGrid1.ClientID %>").get_masterTableView();
                masterTable.fireCommand("HideScanner", false);
                masterTable.fireCommand("PassAction", eventArgs);
                cardReader.unregister(passActions);
                cardStateColors.setStyleElement(document.getElementById("cardState"));

                oWnd.remove_close(OnClientCloseRadWindow);
            }

            function openWebCamWindow(AddressID) {
                var oWnd = radopen("WebCamTest.aspx?AddressID=" + AddressID, "RadWindow1");
                oWnd.add_close(OnWebCamClose);
                oWnd.center();
            }

            function OnWebCamClose(oWnd, eventArgs) {
                var masterTable = $find("<%= RadGrid1.ClientID %>").get_masterTableView();
                // masterTable.rebind();

                if (eventArgs.get_argument() !== null) {
                    masterTable.fireCommand("WebCamClosed", "");
                }

                oWnd.remove_close(OnWebCamClose);
            }

            function ClientSelectedIndexChanged(sender, eventArgs) {
                alert('<%= Resources.Resource.msgPleaseSave %>');
                return false;
            }

            function getValueFromApplet(myParam, myParam2) {
                var masterTable = $find("<%= RadGrid1.ClientID %>").get_masterTableView();
                masterTable.fireCommand("FindEmployee", myParam);
            }

            var findEmployee = {
                name : "FindEmployee",
                onmessage: function (cardState) {
                    if (cardState.online == true) {
                        if (typeof cardState.cardId !== "undefined") {
                            var masterTable = $find("<%= RadGrid1.ClientID %>").get_masterTableView();
                            masterTable.fireCommand("FindEmployee", cardState.cardId);
                        }
                    }
                }
            };

            var passActions = {
                name: "PassActions",
                doc: null,
                onmessage: function (cardState) {
                    if (cardState.online == true) {
                        if (typeof cardState.cardId !== "undefined") {
                            var theForm = this.doc.getElementById("myform");
                            var myID = this.doc.getElementById("IDInternal");
                            myID.value = cardState.cardId;
                            myID = this.doc.getElementById("TAGID");
                            myID.value = cardState.cardId;
                        }
                    }
                }
            };

            function OnGridCreated(sender, args) {
                //console.group("OnGridCreated");
                var editItems = sender.get_masterTableView().get_editItems();
                if (editItems.length > 0) {
                    cardReader.unregister(findEmployee);
                } else {
                    cardReader.register(findEmployee);
                }
                //console.groupEnd();
            }
        </script>

    </telerik:RadCodeBlock>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <telerik:RadCodeBlock ID="RadCodeBlock2" runat="server">
        <script type="text/javascript">
            function gridCommand(sender, args) {
                if (args.get_commandName() === "ReprintPass") {
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
                    <telerik:AjaxUpdatedControl ControlID="RadToolTipManager1"></telerik:AjaxUpdatedControl>
                    <telerik:AjaxUpdatedControl ControlID="RadToolTipManager2"></telerik:AjaxUpdatedControl>
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadGridMinWage2">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridMinWage2"/>
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RelevantDocumentID">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RelevantDocumentID"/>
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadTabStrip1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadTabStrip1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="PanelPhoto">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="PanelPhoto" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        <%--            <telerik:AjaxSetting AjaxControlID="RadMultiPage1">
        <UpdatedControls>
        <telerik:AjaxUpdatedControl ControlID="RadMultiPage1" />
        </UpdatedControls>
        </telerik:AjaxSetting>--%>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <telerik:RadGrid ID="RadGrid1" runat="server" AutoGenerateColumns="false" EnableLinqExpressions="false" GroupPanelPosition="BeforeHeader" CssClass="MainGrid"
                     AllowPaging="true" AllowSorting="true" EnableHeaderContextFilterMenu="True" EnableHeaderContextMenu="True" ShowGroupPanel="True" PageSize="10"
                     AllowFilteringByColumn="true" AllowAutomaticDeletes="false" AllowAutomaticInserts="false" AllowAutomaticUpdates="false" ShowStatusBar="false"
                     OnItemCommand="RadGrid1_ItemCommand" OnItemInserted="RadGrid1_ItemInserted" OnDeleteCommand="RadGrid1_DeleteCommand"
                     OnPreRender="RadGrid1_PreRender" OnItemDataBound="RadGrid1_ItemDataBound" OnItemCreated="RadGrid1_ItemCreated" OnGroupsChanging="RadGrid1_GroupsChanging"
                     OnNeedDataSource="RadGrid1_NeedDataSource" OnInsertCommand="RadGrid1_InsertCommand" OnUpdateCommand="RadGrid1_UpdateCommand" OnPageIndexChanged="RadGrid1_PageIndexChanged"
                     OnPageSizeChanged="RadGrid1_PageSizeChanged">

        <GroupPanel Text="<%$ Resources:Resource, msgGroupPanel %>">
        </GroupPanel>

        <GroupingSettings ShowUnGroupButton="True" CaseSensitive="false" />

        <ExportSettings ExportOnlyData="True" IgnorePaging="True">
            <Pdf PaperSize="A4">
            </Pdf>
            <Excel Format="ExcelML" />
        </ExportSettings>

        <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false" AllowGroupExpandCollapse="true" AllowExpandCollapse="true">
            <Selecting AllowRowSelect="True" />
            <ClientEvents OnRowClick="OnRowClick" OnKeyPress="GridKeyPress" OnGridCreated="OnGridCreated"/>
        </ClientSettings>

        <SortingSettings SortedBackColor="Transparent" />

        <MasterTableView AutoGenerateColumns="False" DataKeyNames="SystemID,BpID,EmployeeID" CommandItemDisplay="Top" EditMode="PopUp" EnableHierarchyExpandAll="true"
                         HierarchyLoadMode="ServerBind" AllowSorting="true" AllowMultiColumnSorting="true" CssClass="MasterClass">

            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

            <GroupByExpressions>
                <telerik:GridGroupByExpression>
                    <SelectFields>
                        <telerik:GridGroupByField FieldAlias="FirstChar" FieldName="FirstChar" HeaderText=" " FormatString="<b>{0}</b>" HeaderValueSeparator=""></telerik:GridGroupByField>
                    </SelectFields>
                    <GroupByFields>
                        <telerik:GridGroupByField FieldName="FirstChar" FormatString="{0}"></telerik:GridGroupByField>
                    </GroupByFields>
                </telerik:GridGroupByExpression>
            </GroupByExpressions>

            <SortExpressions>
                <telerik:GridSortExpression FieldName="LastName" SortOrder="Ascending"></telerik:GridSortExpression>
                <telerik:GridSortExpression FieldName="FirstName" SortOrder="Ascending"></telerik:GridSortExpression>
                <telerik:GridSortExpression FieldName="NameVisible" SortOrder="Ascending"></telerik:GridSortExpression>
            </SortExpressions>

            <CommandItemTemplate>
                <div style="margin: 3px; height: 20px;">
                    <telerik:RadButton ID="btnInitInsert" runat="server" CommandName="InitInsert" Visible="true" Text='<%# Resources.Resource.lblActionNew %>'
                                       Icon-PrimaryIconCssClass="rbAdd" ButtonType="SkinnedButton" BorderStyle="None" BackColor="Transparent">
                    </telerik:RadButton>

                    <asp:PlaceHolder runat="server" ID="AlphaFilter"></asp:PlaceHolder>

                    <telerik:RadButton ID="btnExportCsv" runat="server" Text="" ToolTip='<%# Resources.Resource.lblExportToCsv %>' CssClass="rgExpCSV FloatRight" CommandName="ExportToCSV"
                                       ButtonType="SkinnedButton" Visible="false" BorderStyle="None" BackColor="Transparent" Width="30px" Height="20px">
                        <Icon PrimaryIconUrl="../../Resources/Icons/export_xlsx_16.png" />
                    </telerik:RadButton>
                    <%--                    &nbsp;&nbsp;--%>

                    <telerik:RadButton ID="btnExportExcel" runat="server" Text="" ToolTip='<%# Resources.Resource.lblExportToExcel %>' CssClass="rgExpXLS FloatRight" CommandName="ExportToExcel"
                                       ButtonType="SkinnedButton" Visible="true" BorderStyle="None" BackColor="Transparent" Width="30px" Height="20px">
                        <Icon PrimaryIconUrl="../../Resources/Icons/export_xlsx_16.png" />
                    </telerik:RadButton>

                    <telerik:RadButton ID="btnExportPdf" runat="server" Text="" ToolTip='<%# Resources.Resource.lblExportToPdf %>' CssClass="rgExpPDF FloatRight" CommandName="ExportToPdf"
                                       ButtonType="SkinnedButton" Visible="false" BorderStyle="None" BackColor="Transparent" Width="30px" Height="20px">
                        <Icon PrimaryIconUrl="../../Resources/Icons/export_pdf_16.png" />
                    </telerik:RadButton>

                    <div class="vertical-line"></div>

                    <telerik:RadButton ID="btnRefresh" runat="server" CommandName="RebindGrid" Text='<%# Resources.Resource.lblActionRefresh %>'
                                       Icon-PrimaryIconCssClass="rbRefresh" ButtonType="SkinnedButton" BorderStyle="None" CssClass="FloatRight" BackColor="Transparent">
                    </telerik:RadButton>

                    <telerik:RadButton ID="UpdateThumbnails" runat="server" CommandName="UpdateThumbnails" Text='<%# Resources.Resource.lblUpdateThumbnails %>'
                                       Icon-PrimaryIconUrl="~/Resources/Icons/camera_16.png" ButtonType="SkinnedButton" BorderStyle="None" CssClass="FloatRight" BackColor="Transparent">
                    </telerik:RadButton>
                </div>
            </CommandItemTemplate>

            <%--#################################################################################### Edit Template ########################################################################################################--%>

            <EditFormSettings EditFormType="Template" CaptionDataField="EmployeeName" CaptionFormatString="<%$ Resources:Resource, lblEmployeesMaster %>">
                <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
<EditColumn UniqueName="EditCommandColumn1" FilterControlAltText="Filter EditCommandColumn1 column"></EditColumn>
                <FormTemplate>

                    <telerik:RadTabStrip ID="RadTabStrip1" runat="server" MultiPageID="RadMultiPage1" CausesValidation="False" SelectedIndex="5">
                        <Tabs>
                            <telerik:RadTab PageViewID="RadPageView1" ImageUrl="~/Resources/Icons/factory.png" Text="<%# Resources.Resource.lblGenerally %>" Font-Bold="true" Value="1" />
                            <telerik:RadTab PageViewID="RadPageView2" ImageUrl="~/Resources/Icons/list-add-5.png" Text="<%# Resources.Resource.lblAdvanced %>" Font-Bold="true" Value="2" />
                            <telerik:RadTab PageViewID="RadPageView3" ImageUrl="~/Resources/Icons/info.png" Text="<%# Resources.Resource.lblInfo %>" Font-Bold="true" Value="3" />
                            <telerik:RadTab PageViewID="RadPageView4" ImageUrl="~/Resources/Icons/Money.png" Text="<%# Resources.Resource.lblMinimumWage %>" Font-Bold="true" Value="4" />
                            <telerik:RadTab PageViewID="RadPageView5" ImageUrl="~/Resources/Icons/emblem-paragraph.png" Text="<%# Resources.Resource.lblDocumentsRules %>" Font-Bold="true" Value="5" />
                            <telerik:RadTab PageViewID="RadPageView6" ImageUrl="~/Resources/Icons/Access.png" Text="<%# Resources.Resource.lblAccessControl %>" Font-Bold="true" Value="6" Selected="True" />
                            <telerik:RadTab PageViewID="RadPageView7" ImageUrl="~/Resources/Icons/criteria.png" Text="<%# Resources.Resource.lblOtherCriterias %>" Font-Bold="true" Value="7" />
                        </Tabs>
                    </telerik:RadTabStrip>

                    <telerik:RadMultiPage ID="RadMultiPage1" runat="server" RenderSelectedPageOnly="false" SelectedIndex="5">

                        <%-- Generally --%>
                        <telerik:RadPageView ID="RadPageView1" runat="server" Selected="true">
                            <table id="Table1" cellspacing="2" cellpadding="2" border="0" rules="none" class="EditFormTable">
                                <tr>
                                    <td style="vertical-align: top;">
                                        <table id="Table2" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                            <tr>
                                                <td>
                                                    <asp:HiddenField ID="StatusID" runat="server" Value='<%# Eval("StatusID") %>'></asp:HiddenField>
                                                    <asp:Label runat="server" ID="LabelEmployeeID" Text='<%# String.Concat(Resources.Resource.lblID, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" ID="EmployeeID" Text='<%# Eval("EmployeeID") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelCompanyID" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadDropDownTree runat="server" ID="CompanyID" DataFieldParentID="ParentID" DataFieldID="CompanyID" 
                                                                             DataValueField="CompanyID" EnableFiltering="true" DataTextField="NameVisible" Width="300px" 
                                                                             DefaultMessage="<%$ Resources:Resource, msgPleaseSelect %>"
                                                                             DropDownSettings-AutoWidth="Enabled" SelectedValue='<%# Eval("CompanyID") %>' AutoPostBack="true" 
                                                                             DataSourceID="SqlDataSource_Companies" OnEntryAdded="CompanyID_EntryAdded"
                                                                             Enabled="<%# (Container is GridEditFormInsertItem) ? true : false %>">
                                                        <ButtonSettings ShowClear="true" />
                                                        <FilterSettings Highlight="Matches" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" Filter="Contains" />
                                                        <DropDownSettings OpenDropDownOnLoad="false" CloseDropDownOnSelection="true" />
                                                    </telerik:RadDropDownTree>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelSalutation" Text='<%# String.Concat(Resources.Resource.lblAddrSalutation, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:HiddenField ID="AddressID" runat="server" Value='<%# Eval("AddressID") %>'></asp:HiddenField>
                                                    <telerik:RadComboBox runat="server" ID="Salutation" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                                                         DataSourceID="SqlDataSource_Salutations" DataValueField="Salutation" DataTextField="Salutation" Width="300"
                                                                         AppendDataBoundItems="true" Filter="Contains" AllowCustomText="false"
                                                                         SelectedValue='<%# Bind("Salutation") %>' DropDownAutoWidth="Enabled">
                                                    </telerik:RadComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelLastName" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadTextBox runat="server" ID="LastName" Text='<%# Bind("LastName") %>' Width="300px"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelFirstName" Text='<%# String.Concat(Resources.Resource.lblAddrFirstName, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadTextBox runat="server" ID="FirstName" Text='<%# Bind("FirstName") %>' Width="300px"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelAddress1" Text='<%# String.Concat(Resources.Resource.lblAddress1, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadTextBox runat="server" ID="Address1" Text='<%# Bind("Address1") %>' Width="300px"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelAddress2" Text='<%# String.Concat(Resources.Resource.lblAddress2, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadTextBox runat="server" ID="Address2" Text='<%# Bind("Address2") %>' Width="300px"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelZip" Text='<%# String.Concat(Resources.Resource.lblAddrZip, ", ", Resources.Resource.lblAddrCity, ":") %>'>
                                                    </asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadTextBox runat="server" ID="Zip" Text='<%# Bind("Zip") %>' Width="60px"></telerik:RadTextBox>
                                                    <telerik:RadTextBox runat="server" ID="City" Text='<%# Bind("City") %>' Width="224px"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelState" Text='<%# String.Concat(Resources.Resource.lblAddrState, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadTextBox runat="server" ID="State" Text='<%# Bind("State") %>' Width="300px"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelCountryID" Text='<%# String.Concat(Resources.Resource.lblCountry, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadComboBox runat="server" ID="CountryID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataSourceID="SqlDataSource_Countries"
                                                                         DataValueField="CountryID" DataTextField="CountryName" Width="300" Filter="Contains" SelectedValue='<%# Bind("CountryID") %>'
                                                                         AppendDataBoundItems="true" DropDownAutoWidth="Enabled" AllowCustomText="false">
                                                        <ItemTemplate>
                                                            <table cellpadding="3px" style="text-align: left;">
                                                                <tr style="height: 24px;">
                                                                    <td style="text-align: left;">
                                                                        <asp:Image ID="Image1" ImageUrl='<%# String.Format("~/Resources/Icons/Flags/{0}", Eval("FlagName"))%>' runat="server"
                                                                                   Width="24px" Height="24px" />
                                                                    </td>
                                                                    <td style="text-align: left;">
                                                                        <asp:Label ID="Label1" Text='<%# Eval("CountryID") %>' runat="server">
                                                                        </asp:Label>
                                                                    </td>
                                                                    <td style="text-align: left;">
                                                                        <asp:Label ID="Label2" Text='<%# Eval("CountryName") %>' runat="server">
                                                                        </asp:Label>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </ItemTemplate>
                                                        <Items>
                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="" />
                                                        </Items>
                                                    </telerik:RadComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelPhone" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadTextBox runat="server" ID="Phone" Text='<%# Bind("Phone") %>' Width="300px"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelEmail" Text='<%# String.Concat(Resources.Resource.lblAddrEmail, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadTextBox runat="server" ID="Email" Text='<%# Bind("Email") %>' Width="300px"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelBirthDate" Text='<%# String.Concat(Resources.Resource.lblAddrBirthDate, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadDatePicker ID="BirthDate" runat="server" DbSelectedDate='<%# Bind("BirthDate") %>' MinDate="1900/1/1" MaxDate="2100/1/1" EnableShadows="true"
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
                                                    <asp:Label runat="server" ID="LabelNationalityID" Text='<%# String.Concat(Resources.Resource.lblNationality, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadComboBox runat="server" ID="NationalityID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataSourceID="SqlDataSource_Countries"
                                                                         DataValueField="CountryID" DataTextField="CountryName" Width="300" Filter="Contains" SelectedValue='<%# Bind("NationalityID") %>'
                                                                         AppendDataBoundItems="true" DropDownAutoWidth="Enabled" OnClientSelectedIndexChanged="ClientSelectedIndexChanged"
                                                                         AllowCustomText="false">
                                                        <ItemTemplate>
                                                            <table cellpadding="3px" style="text-align: left;">
                                                                <tr style="height: 24px;">
                                                                    <td style="text-align: left;">
                                                                        <asp:Image ID="Image1" ImageUrl='<%# String.Format("~/Resources/Icons/Flags/{0}", Eval("FlagName"))%>' runat="server"
                                                                                   Width="24px" Height="24px" />
                                                                    </td>
                                                                    <td style="text-align: left;">
                                                                        <asp:Label ID="Label1" Text='<%# Eval("CountryID") %>' runat="server">
                                                                        </asp:Label>
                                                                    </td>
                                                                    <td style="text-align: left;">
                                                                        <asp:Label ID="Label2" Text='<%# Eval("CountryName") %>' runat="server">
                                                                        </asp:Label>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </ItemTemplate>
                                                        <Items>
                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="" />
                                                        </Items>
                                                    </telerik:RadComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelLanguageID" Text='<%# String.Concat(Resources.Resource.lblLanguage, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadComboBox runat="server" ID="LanguageID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataSourceID="SqlDataSource_Languages"
                                                                         DataValueField="LanguageID" DataTextField="LanguageName" Width="300" Filter="Contains" SelectedValue='<%# Bind("LanguageID") %>'
                                                                         AppendDataBoundItems="true" DropDownAutoWidth="Enabled" AllowCustomText="false">
                                                        <ItemTemplate>
                                                            <table cellpadding="3px" style="text-align: left;">
                                                                <tr style="height: 24px;">
                                                                    <td style="text-align: left;">
                                                                        <asp:Label ID="Label1" Text='<%# Eval("LanguageID") %>' runat="server">
                                                                        </asp:Label>
                                                                    </td>
                                                                    <td style="text-align: left;">
                                                                        <asp:Label ID="Label2" Text='<%# Eval("LanguageName") %>' runat="server">
                                                                        </asp:Label>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </ItemTemplate>
                                                        <Items>
                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="" />
                                                        </Items>
                                                    </telerik:RadComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" style="padding-right: 12px;">
                                                    <asp:ValidationSummary ID="ValidationSummary2" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' ShowMessageBox="true"
                                                                           ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true" />
                                                </td>
                                            </tr>

                                        </table>
                                    </td>
                                    <td style="vertical-align: top;">
                                        <asp:Panel runat="server" ID="PanelPhoto">
                                            <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin-top: 6px; margin-left: 10px;">
                                                <table id="Table3" cellspacing="2" cellpadding="2" border="0">
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelPhotoData" Text='<%# String.Concat(Resources.Resource.lblPhoto, ":") %>'></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp; </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <telerik:RadBinaryImage runat="server" ID="PhotoData"
                                                                                    AutoAdjustImageControlSize="false" Height="266px" ToolTip='<%#Eval("LastName", Resources.Resource.lblImageFor) %>'
                                                                                    AlternateText='<%# Eval("LastName", Resources.Resource.lblImageFor) %>' ></telerik:RadBinaryImage>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="PhotoFileName" Text='<%# Eval("PhotoFileName") %>'></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="PhotoFileSize" ></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <telerik:RadButton ID="TakePicture" runat="server" CommandName="TakePicture" Text='<%# Resources.Resource.lblTakePicture %>'
                                                                               ButtonType="StandardButton" Icon-PrimaryIconCssClass="rbAdd" BorderStyle="None" CausesValidation="false"
                                                                               AutoPostBack="false" CommandArgument='<%# Eval("EmployeeID") %>'>
                                                            </telerik:RadButton>

                                                        <%--                                                                <input type="button" value="<%# Resources.Resource.lblTakePicture %>" 
                                                        onclick='openWebCamWindow("<%# Eval("AddressID") %>");return false;' />--%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="PhotoHint" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.msgAfterEditPhoto : "" %>' 
                                                                       Visible='<%# (Container is GridEditFormInsertItem) ? true : false %>' Width="170px"></asp:Label>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </asp:Panel>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp; </td>
                                    <td>&nbsp; </td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="2">
                                        <telerik:RadButton ID="EmployeeSave1" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionSave %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' CommandArgument="NoExit" 
                                                           Icon-PrimaryIconCssClass="rbSave">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="EmployeeUpdateAndClose1" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblInsertAndClose : Resources.Resource.lblUpdateAndClose %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' Icon-PrimaryIconCssClass="rbOk">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="RadButton18" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                           CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                        </telerik:RadButton>
                                    </td>
                                </tr>
                            </table>
                        </telerik:RadPageView>

                        <%-- Advanced --%>
                        <telerik:RadPageView ID="RadPageView2" runat="server">
                            <table id="Table4" cellspacing="2" cellpadding="2" border="0" rules="none" class="EditFormTable">
                                <tr>
                                    <td style="vertical-align: top;">
                                        <table id="Table5" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ", ", Resources.Resource.lblAddrFirstName, ":") %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Eval("LastName"), ", ", Eval("FirstName")) %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ", ", Resources.Resource.lblAddrEmail, ":") %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Eval("Phone"), ", ", Eval("Email")) %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Eval("NameVisible"), ", ", Eval("NameAdditional")) %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelTradeID" Text='<%# String.Concat(Resources.Resource.lblTrade, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadComboBox runat="server" ID="TradeID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                                                         OnItemsRequested="TradeID_ItemsRequested" DataValueField="TradeID" DataTextField="TradeName" Width="300"
                                                                         Filter="Contains" AppendDataBoundItems="true" EnableLoadOnDemand="true" DropDownAutoWidth="Enabled">
                                                        <Items>
                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0" />
                                                        </Items>
                                                    </telerik:RadComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelStaffFunction" Text='<%# String.Concat(Resources.Resource.lblFunction, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadTextBox runat="server" ID="StaffFunction" Text='<%# Bind("StaffFunction") %>' Width="300px"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelEmploymentStatusID" Text='<%# String.Concat(Resources.Resource.lblEmploymentStatus, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadComboBox runat="server" ID="EmploymentStatusID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataSourceID="SqlDataSource_EmploymentStatus" AppendDataBoundItems="true"
                                                                         DataValueField="EmploymentStatusID" DataTextField="NameVisible" Width="300" Filter="Contains" OnClientSelectedIndexChanged="ClientSelectedIndexChanged"
                                                                         SelectedValue='<%# Eval("EmploymentStatusID") %>' DropDownAutoWidth="Enabled">
                                                        <Items>
                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0" />
                                                        </Items>
                                                    </telerik:RadComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelDescription" Text='<%# String.Concat(Resources.Resource.lblRemarks, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadTextBox runat="server" ID="Description" Text='<%# Bind("Description") %>' Width="300px" TextMode="MultiLine" Rows="3" Wrap="true"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp; </td>
                                                <td>&nbsp; </td>
                                            </tr>

                                            <tr>
                                                <td colspan="2">
                                                    <telerik:RadAjaxPanel runat="server" ID="QualificationPanel">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label runat="server" ID="LabelAvailableQualifications" Text='<%# String.Concat(Resources.Resource.lblAvailableQualifications, ":") %>'></asp:Label>
                                                                </td>
                                                                <td>
                                                                    <asp:Label runat="server" ID="LabelAssignedQualifications" Text='<%# String.Concat(Resources.Resource.lblAssignedQualifications, ":") %>'></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <telerik:RadListBox ID="AvailableQualifications" runat="server" DataValueField="StaffRoleID" DataSourceID="SqlDataSource_StaffRoles" DataKeyField="StaffRoleID"
                                                                                        DataTextField="NameVisible" Width="211px" Height="150px" OnTransferred="AvailableQualifications_Transferred" SelectionMode="Multiple"
                                                                                        AllowTransfer="true" TransferToID="AssignedQualifications" AutoPostBackOnTransfer="true"
                                                                                        EnableDragAndDrop="true">
                                                                    </telerik:RadListBox>
                                                                </td>
                                                                <td>
                                                                    <telerik:RadListBox ID="AssignedQualifications" runat="server" DataSourceID="SqlDataSource_EmployeeQualification" DataValueField="StaffRoleID"
                                                                                        DataKeyField="StaffRoleID" DataTextField="NameVisible" Width="211px" Height="150px" SelectionMode="Multiple"
                                                                                        EnableDragAndDrop="true">
                                                                    </telerik:RadListBox>
                                                                    <asp:CustomValidator runat="server" ID="ValidatorAssignedQualifications" Enabled="false" Visible="false"
                                                                                         OnServerValidate="ValidatorAssignedQualifications_ServerValidate"></asp:CustomValidator>

                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </telerik:RadAjaxPanel>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td>&nbsp; </td>
                                                <td>&nbsp; </td>
                                            </tr>

                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="padding-right: 12px;">
                                        <asp:ValidationSummary ID="ValidationSummary1" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' ShowMessageBox="true"
                                                               ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="2">
                                        <telerik:RadButton ID="RadButton1" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionSave %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' CommandArgument="NoExit" Icon-PrimaryIconCssClass="rbSave">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="RadButton2" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblInsertAndClose : Resources.Resource.lblUpdateAndClose %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' Icon-PrimaryIconCssClass="rbOk">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="RadButton19" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                           CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                        </telerik:RadButton>
                                    </td>
                                </tr>
                            </table>

                            <asp:SqlDataSource ID="SqlDataSource_StaffRoles" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT SystemID, BpID, StaffRoleID, NameVisible, DescriptionShort, IsVisible, CreatedFrom, CreatedOn, EditFrom, EditOn FROM Master_StaffRoles AS sr WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (NOT EXISTS (SELECT 1 AS Expr1 FROM Master_EmployeeQualification AS eq WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (EmployeeID = @EmployeeID) AND (StaffRoleID = sr.StaffRoleID))) AND (IsVisible = 1)">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource ID="SqlDataSource_EmployeeQualification" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT Master_EmployeeQualification.StaffRoleID, Master_StaffRoles.NameVisible, Master_StaffRoles.DescriptionShort FROM Master_EmployeeQualification INNER JOIN Master_StaffRoles ON Master_EmployeeQualification.SystemID = Master_StaffRoles.SystemID AND Master_EmployeeQualification.BpID = Master_StaffRoles.BpID AND Master_EmployeeQualification.StaffRoleID = Master_StaffRoles.StaffRoleID WHERE (Master_EmployeeQualification.SystemID = @SystemID) AND (Master_EmployeeQualification.BpID = @BpID) AND (Master_EmployeeQualification.EmployeeID = @EmployeeID)">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </telerik:RadPageView>

                        <%-- Info --%>
                        <telerik:RadPageView ID="RadPageView3" runat="server">
                            <table id="Table7" cellspacing="2" cellpadding="2" border="0" rules="none" class="EditFormTable">
                                <tr>
                                    <td style="vertical-align: top;">
                                        <table id="Table8" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ", ", Resources.Resource.lblAddrFirstName, ":") %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Eval("LastName"), ", ", Eval("FirstName")) %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ", ", Resources.Resource.lblAddrEmail, ":") %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Eval("Phone"), ", ", Eval("Email")) %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Eval("NameVisible"), ", ", Eval("NameAdditional")) %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp; </td>
                                                <td>&nbsp; </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="LabelReleaseCFrom" Text='<%# String.Concat(Resources.Resource.lblReleaseC, " ", Resources.Resource.lblFrom, ":") %>' runat="server">
                                                    </asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label ID="ReleaseCFrom" Text='<%# Eval("ReleaseCFrom") %>' runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="LabelReleaseCOn" Text='<%# String.Concat(Resources.Resource.lblReleaseC, " ", Resources.Resource.lblOn, ":") %>' runat="server">
                                                    </asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label ID="ReleaseCOn" Text='<%# Eval("ReleaseCOn") %>' runat="server"></asp:Label>
                                                    <telerik:RadButton ID="ReleaseItC" runat="server" ButtonType="StandardButton" Text="<%$ Resources:Resource, lblActionRelease %>"
                                                                       CommandName="ReleaseItC" CommandArgument='<%# Eval("EmployeeID") %>' CausesValidation="false">
                                                    </telerik:RadButton>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="LabelReleaseBFrom" Text='<%# String.Concat(Resources.Resource.lblReleaseB, " ", Resources.Resource.lblFrom, ":") %>' runat="server">
                                                    </asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label ID="ReleaseBFrom" Text='<%# Eval("ReleaseBFrom") %>' runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="LabelReleaseBOn" Text='<%# String.Concat(Resources.Resource.lblReleaseB, " ", Resources.Resource.lblOn, ":") %>' runat="server">
                                                    </asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label ID="ReleaseBOn" Text='<%# Eval("ReleaseBOn") %>' runat="server"></asp:Label>
                                                    <telerik:RadButton ID="ReleaseItB" runat="server" ButtonType="StandardButton" Text="<%$ Resources:Resource, lblActionRelease %>"
                                                                       CommandName="ReleaseItB" CommandArgument='<%# Eval("EmployeeID") %>' CausesValidation="false">
                                                    </telerik:RadButton>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="LabelLockedFrom" Text='<%# String.Concat(Resources.Resource.lblLockedFrom, ":") %>' runat="server">
                                                    </asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label ID="LockedFrom" Text='<%# Eval("LockedFrom") %>' runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="LabelLockedOn" Text='<%# String.Concat(Resources.Resource.lblLockedOn, ":") %>' runat="server"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label ID="LockedOn" Text='<%# Eval("LockedOn") %>' runat="server"></asp:Label>
                                                    <telerik:RadButton ID="LockIt" runat="server" ButtonType="StandardButton" Text="<%$ Resources:Resource, lblActionLock %>"
                                                                       CommandName="LockIt" CommandArgument='<%# Eval("CompanyID") %>' CausesValidation="false">
                                                    </telerik:RadButton>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
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
                                                    <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("EditFrom") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblEditOn, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("EditOn") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" style="padding-right: 12px;">
                                                    <asp:ValidationSummary ID="ValidationSummary7" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' ShowMessageBox="true"
                                                                           ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp; </td>
                                                <td>&nbsp; </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="2">
                                        <telerik:RadButton ID="RadButton7" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionSave %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' CommandArgument="NoExit" Icon-PrimaryIconCssClass="rbSave">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="RadButton3" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblInsertAndClose : Resources.Resource.lblUpdateAndClose %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' Icon-PrimaryIconCssClass="rbOk">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="RadButton4" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                           CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                        </telerik:RadButton>
                                    </td>
                                </tr>
                            </table>
                        </telerik:RadPageView>

                        <%-- Minimum wage --%>
                        <telerik:RadPageView ID="RadPageView4" runat="server">
                            <table id="Table11" cellspacing="2" cellpadding="2" border="0" rules="none" class="EditFormTable">
                                <tr>
                                    <td style="vertical-align: top;">
                                        <table id="Table12" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                            <tr>
                                                <td>
                                                    <asp:HiddenField ID="CompanyID1" runat="server" Value='<%# Eval("CompanyID") %>'></asp:HiddenField>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ", ", Resources.Resource.lblAddrFirstName, ":") %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Eval("LastName"), ", ", Eval("FirstName")) %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ", ", Resources.Resource.lblAddrEmail, ":") %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Eval("Phone"), ", ", Eval("Email")) %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Eval("NameVisible"), ", ", Eval("NameAdditional")) %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp; </td>
                                                <td>&nbsp; </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="LabelRadGridMinWage1" Text='<%# String.Concat(Resources.Resource.lblEmplMinWage1, ":") %>' runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <telerik:RadGrid runat="server" ID="RadGridMinWage1" DataSourceID="SqlDataSource_CompanyTariffs">
                                                                    <MasterTableView DataSourceID="SqlDataSource_CompanyTariffs" AutoGenerateColumns="false" AllowPaging="true" PageSize="5">
                                                                        <Columns>
                                                                            <telerik:GridBoundColumn DataField="ValidFrom" HeaderText="<%$ Resources:Resource, lblValidFrom %>" DataFormatString="{0:d}">
                                                                            </telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="TariffName" HeaderText="<%$ Resources:Resource, lblTariff %>"></telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="ScopeName" HeaderText="<%$ Resources:Resource, lblTariffScope %>"></telerik:GridBoundColumn>
                                                                        </Columns>
                                                                    </MasterTableView>
                                                                </telerik:RadGrid>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>&nbsp; </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="LabelRadGridMinWage2" Text='<%# String.Concat(Resources.Resource.lblEmplMinWage2, ":") %>' runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <telerik:RadGrid runat="server" ID="RadGridMinWage2"
                                                                                 ValidateRequestMode="Disabled" GroupPanelPosition="Top" 
                                                                                 OnNeedDataSource="RadGridMinWage2_NeedDataSource" OnDeleteCommand="RadGridMinWage2_DeleteCommand"
                                                                                 OnItemCreated="RadGridMinWage2_ItemCreated" OnItemCommand="RadGridMinWage2_ItemCommand"
                                                                                 OnInsertCommand="RadGridMinWage2_InsertCommand" OnUpdateCommand="RadGridMinWage2_UpdateCommand" 
                                                                                 OnItemDataBound="RadGridMinWage2_ItemDataBound">

                                                                    <ValidationSettings ValidationGroup="MinWage2" EnableValidation="false" />

                                                                    <MasterTableView AutoGenerateColumns="false" AllowPaging="true" PageSize="5" AllowAutomaticDeletes="false" 
                                                                                     AllowAutomaticInserts="false" AllowAutomaticUpdates="false" CommandItemDisplay="Top" EditMode="EditForms" 
                                                                                     DataKeyNames="SystemID,BpID,EmployeeID,TariffWageGroupID">

                                                                        <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="false" PageSizes="5,10,50" />

                                                                        <EditFormSettings CaptionDataField="NameVisible" EditFormType="Template">
                                                                            <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                                                                            <EditColumn ButtonType="ImageButton" UniqueName="EditColumn2" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                                                                                        EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                                                                            <FormTableStyle CellPadding="3" CellSpacing="3" />
                                                                            <FormTemplate>
                                                                                <%--                                                                                    <telerik:RadWindow runat="server" Modal="true" Visible="true" VisibleOnPageLoad="true" VisibleStatusbar="false" 
                                                                                AutoSize="true" IconUrl="~/Resources/Icons/TitleIcon.png" EnableShadow="true" Behaviors="Resize,Move" 
                                                                                Title="<%$ Resources:Resource, lblEmplMinWage2 %>" >--%>
                                                                                <table>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text="<%$ Resources:Resource, lblValidFrom %>"></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <telerik:RadDatePicker ID="ValidFrom" runat="server" DbSelectedDate='<%# Bind("ValidFrom") %>' MinDate="1900/1/1"
                                                                                                                   MaxDate="2100/1/1" EnableShadows="true" ShowPopupOnFocus="true" AutoPostBack="true" 
                                                                                                                   OnSelectedDateChanged="ValidFrom_SelectedDateChanged">
                                                                                                <Calendar runat="server">
                                                                                                    <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                                                                                            TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                                                                                    </FastNavigationSettings>
                                                                                                </Calendar>
                                                                                            </telerik:RadDatePicker>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text="<%$ Resources:Resource, lblTariffWageGroup %>"></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <telerik:RadComboBox runat="server" ID="TariffWageGroupID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                                                                 AppendDataBoundItems="true"
                                                                                                                 DataValueField="TariffWageGroupID" DataTextField="DescriptionShort" Width="300" Filter="Contains" 
                                                                                                                 DropDownAutoWidth="Enabled">
                                                                                                <Items>
                                                                                                    <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                                                                                                </Items>
                                                                                            </telerik:RadComboBox>
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
                                                                                        <td>&nbsp; </td>
                                                                                        <td>&nbsp; </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td align="left" colspan="2">
                                                                                            <telerik:RadButton ID="RadButton10" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionUpdate%>'
                                                                                                               runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update"%>' Icon-PrimaryIconCssClass="rbOk"
                                                                                                               CausesValidation="false">
                                                                                            </telerik:RadButton>
                                                                                            <telerik:RadButton ID="RadButton11" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                                                                               CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                                                                            </telerik:RadButton>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            <%--                                                                                    </telerik:RadWindow>--%>
                                                                            </FormTemplate>
                                                                        </EditFormSettings>

                                                                        <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" AddNewRecordText="<%$ Resources:Resource, lblActionNew %>"
                                                                                             RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                                                                        <Columns>
                                                                            <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn2" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                                                                                           UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                                                                                <ItemStyle BackColor="Control" Width="30px" />
                                                                                <HeaderStyle Width="30px" />
                                                                            </telerik:GridEditCommandColumn>

                                                                            <telerik:GridTemplateColumn DataField="ValidFrom" FilterControlAltText="Filter ValidFrom column"
                                                                                                        HeaderText="<%$ Resources:Resource, lblValidFrom %>" SortExpression="ValidFrom" UniqueName="ValidFrom" Visible="true">
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="ValidFrom" runat="server" Text='<%# Eval("ValidFrom", "{0:d}") %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridDropDownColumn DataField="TariffWageGroupID" DataSourceID="SqlDataSource_TariffWageGroups"
                                                                                                        HeaderText="<%$ Resources:Resource, lblTariffWageGroup %>" ListTextField="NameVisible"
                                                                                                        ListValueField="TariffWageGroupID" UniqueName="TariffWageGroupID" DropDownControlType="RadComboBox"
                                                                                                        CurrentFilterFunction="Contains" AllowFiltering="true" DefaultInsertValue="0" ForceExtractValue="Always">
                                                                                <ItemStyle Width="300px" />
                                                                            </telerik:GridDropDownColumn>

                                                                            <telerik:GridTemplateColumn DataField="WageName" FilterControlAltText="Filter WageName column"
                                                                                                        HeaderText="<%$ Resources:Resource, lblTariffWage %>" SortExpression="WageName" UniqueName="WageName" 
                                                                                                        Visible="true">
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="WageName" runat="server" Text='<%# Eval("WageName") %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="Wage" FilterControlAltText="Filter Wage column"
                                                                                                        HeaderText="<%$ Resources:Resource, lblAmount %>" SortExpression="Wage" UniqueName="Wage" 
                                                                                                        Visible="true" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="Wage" runat="server" Text='<%# Eval("Wage", "{0:#,##0.00}") %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="CreatedFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedFrom column"
                                                                                                        HeaderText="<%$ Resources:Resource, lblCreatedFrom %>" SortExpression="CreatedFrom" UniqueName="CreatedFrom" Visible="False">
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="CreatedFromLabel" runat="server" Text='<%# ((System.Data.DataRowView)Container.DataItem)["CreatedFrom"] %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="CreatedOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedOn column"
                                                                                                        HeaderText="<%$ Resources:Resource, lblCreatedOn %>" SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="False">
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="CreatedOnLabel" runat="server" Text='<%# ((System.Data.DataRowView)Container.DataItem)["CreatedOn"] %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="EditFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditFrom column"
                                                                                                        HeaderText="<%$ Resources:Resource, lblEditFrom %>" SortExpression="EditFrom" UniqueName="EditFrom" Visible="False">
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="EditFromLabel" runat="server" Text='<%# ((System.Data.DataRowView)Container.DataItem)["EditFrom"] %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="EditOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditOn column"
                                                                                                        HeaderText="<%$ Resources:Resource, lblEditOn %>" SortExpression="EditOn" UniqueName="EditOn" Visible="False">
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="EditOnLabel" runat="server" Text='<%# ((System.Data.DataRowView)Container.DataItem)["EditOn"] %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridButtonColumn UniqueName="deleteColumn1" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                                                                                      ConfirmDialogType="RadWindow"
                                                                                                      ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                                                                                <ItemStyle BackColor="Control" />
                                                                            </telerik:GridButtonColumn>
                                                                        </Columns>
                                                                    </MasterTableView>
                                                                </telerik:RadGrid>
                                                                <asp:CustomValidator runat="server" ID="ValidatorRadGridMinWage2" Enabled="false" Visible="false"
                                                                                     OnServerValidate="ValidatorRadGridMinWage2_ServerValidate"></asp:CustomValidator>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>&nbsp; </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="LabelRadGridMinWage3" Text='<%# String.Concat(Resources.Resource.lblEmplMinWage3, ":") %>' runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <telerik:RadGrid runat="server" ID="RadGridMinWage3" DataSourceID="SqlDataSource_TariffHistorie" GroupPanelPosition="Top">
                                                                    <MasterTableView DataSourceID="SqlDataSource_TariffHistorie" AutoGenerateColumns="false" AllowPaging="true" PageSize="5">
                                                                        <Columns>
                                                                            <telerik:GridBoundColumn DataField="ValidFrom" HeaderText="<%$ Resources:Resource, lblValidFrom %>" DataFormatString="{0:d}">
                                                                            </telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="TariffName" HeaderText="<%$ Resources:Resource, lblTariff %>"></telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="ScopeName" HeaderText="<%$ Resources:Resource, lblTariffScope %>"></telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="WageGroupName" HeaderText="<%$ Resources:Resource, lblTariffWageGroup %>"></telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="WageName" HeaderText="<%$ Resources:Resource, lblTariffWage %>"></telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="Wage" DataFormatString="{0:#,##0.00}" HeaderText="<%$ Resources:Resource, lblAmount %>"
                                                                                                     ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right"></telerik:GridBoundColumn>
                                                                        </Columns>
                                                                    </MasterTableView>
                                                                </telerik:RadGrid>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>&nbsp; </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="LabelRadGridMinWage4" Text='<%# String.Concat(Resources.Resource.lblEmplMinWage4, ":") %>' runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <telerik:RadGrid runat="server" ID="RadGridMinWage4" DataSourceID="SqlDataSource_EmployeeMinWage" GroupPanelPosition="Top" AllowAutomaticUpdates="false"
                                                                                 OnItemCreated="RadGridMinWage4_ItemCreated" OnItemCommand="RadGridMinWage4_ItemCommand" OnUpdateCommand="RadGridMinWage4_UpdateCommand"
                                                                                 OnItemUpdated="RadGridMinWage4_ItemUpdated">

                                                                    <ValidationSettings ValidationGroup="MinWage4" EnableValidation="false" />

                                                                    <SortingSettings SortedBackColor="Transparent" />

                                                                    <MasterTableView DataSourceID="SqlDataSource_EmployeeMinWage" AutoGenerateColumns="false" AllowPaging="true" PageSize="5"
                                                                                     AllowAutomaticUpdates="true" EditMode="EditForms" DataKeyNames="SystemID,BpID,EmployeeID,MWMonth" 
                                                                                     AllowSorting="false" CommandItemDisplay="Top">

                                                                        <SortExpressions>
                                                                            <telerik:GridSortExpression FieldName="MWMonth" SortOrder="Descending"></telerik:GridSortExpression>
                                                                        </SortExpressions>

                                                                        <EditFormSettings EditFormType="AutoGenerated" CaptionDataField="MWMonth" CaptionFormatString="{0:MMMM yyyy}">
                                                                            <EditColumn ButtonType="ImageButton" UniqueName="EditColumn2" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                                                                                        EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                                                                            <FormTableStyle CellPadding="3" CellSpacing="3" />
                                                                        </EditFormSettings>

                                                                        <CommandItemSettings ShowAddNewRecordButton="false" ShowRefreshButton="true" />

                                                                        <Columns>
                                                                            <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn3" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                                                                                           UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                                                                                <ItemStyle BackColor="Control" Width="30px" />
                                                                                <HeaderStyle Width="30px" />
                                                                            </telerik:GridEditCommandColumn>

                                                                            <telerik:GridTemplateColumn DataField="MWMonth" HeaderText="<%$ Resources:Resource, lblMonth %>" SortExpression="MWMonth" UniqueName="MWMonth" 
                                                                                                        GroupByExpression="MWMonth MWMonth GROUP BY MWMonth" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px" 
                                                                                                        CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                                                                                <EditItemTemplate>
                                                                                    <asp:HiddenField runat="server" ID="MWMonthDate" Value='<%# Eval("MWMonth") %>' />
                                                                                    <asp:Label runat="server" ID="MWMonth" Text='<%# Eval("MWMonth", "{0:MMM yyyy}") %>'></asp:Label>
                                                                                </EditItemTemplate>
                                                                                <ItemTemplate>
                                                                                    <asp:Label runat="server" ID="MWMonth" Text='<%# Eval("MWMonth", "{0:MMM yyyy}") %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="Amount" HeaderText="<%$ Resources:Resource, lblAmount %>" SortExpression="Amount" UniqueName="Amount" DataType="System.Decimal" 
                                                                                                        GroupByExpression="Amount Amount GROUP BY Amount" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px" 
                                                                                                        CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right">
                                                                                <EditItemTemplate>
                                                                                    <asp:HiddenField runat="server" ID="Wage_C" Value='<%# Eval("Wage_C", "{0:#,##0.00}") %>' />
                                                                                    <asp:HiddenField runat="server" ID="Wage_E" Value='<%# Eval("Wage_E", "{0:#,##0.00}") %>' />
                                                                                    <telerik:RadTextBox runat="server" ID="Amount" Text='<%# Bind("Amount", "{0:#,##0.00}") %>' SelectionOnFocus="SelectAll" 
                                                                                                        OnTextChanged="Amount_TextChanged" AutoPostBack="true">
                                                                                    </telerik:RadTextBox>
                                                                                </EditItemTemplate>
                                                                                <ItemTemplate>
                                                                                    <asp:Label runat="server" ID="Amount" Text='<%# Eval("Amount", "{0:#,##0.00}") %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="StatusCode" HeaderText="<%$ Resources:Resource, lblStatus %>" 
                                                                                                        SortExpression="StatusCode" UniqueName="StatusCode" Visible="true" ItemStyle-Wrap="false" DefaultInsertValue="0" ForceExtractValue="Always">
                                                                                <EditItemTemplate>
                                                                                    <telerik:RadComboBox ID="StatusCode" runat="server" SelectedValue='<%# Bind("StatusCode") %>' Enabled="false"
                                                                                                         EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" Filter="Contains" DropDownAutoWidth="Enabled">
                                                                                        <Items>
                                                                                            <telerik:RadComboBoxItem runat="server" Text="<%$ Resources:Resource, selStatusCode0 %>" Value="0" Selected="true" />
                                                                                            <telerik:RadComboBoxItem runat="server" Text="<%$ Resources:Resource, selStatusCode1 %>" Value="1" />
                                                                                            <telerik:RadComboBoxItem runat="server" Text="<%$ Resources:Resource, selStatusCode2 %>" Value="2" />
                                                                                            <telerik:RadComboBoxItem runat="server" Text="<%$ Resources:Resource, selStatusCode3 %>" Value="3" />
                                                                                            <telerik:RadComboBoxItem runat="server" Text="<%$ Resources:Resource, selStatusCode4 %>" Value="4" />
                                                                                            <telerik:RadComboBoxItem runat="server" Text="<%$ Resources:Resource, selStatusCode5 %>" Value="5" />
                                                                                        </Items>
                                                                                    </telerik:RadComboBox>
                                                                                </EditItemTemplate>
                                                                                <ItemTemplate>
                                                                                    <asp:HiddenField runat="server" ID="StatusCode" Value='<%# Eval("StatusCode") %>' />
                                                                                    <asp:Label runat="server" ID="StatusCode1" Text='<%# GetMWStatus(Convert.ToInt32(Eval("StatusCode"))) %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="ReceivedFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter ReceivedFrom column"
                                                                                                        HeaderText="<%$ Resources:Resource, lblReceivedFrom %>" SortExpression="ReceivedFrom" UniqueName="ReceivedFrom">
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="ReceivedFrom" runat="server" Text='<%# Eval("ReceivedFrom") %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="ReceivedOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter ReceivedOn column"
                                                                                                        HeaderText="<%$ Resources:Resource, lblReceivedOn %>" SortExpression="ReceivedOn" UniqueName="ReceivedOn">
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="ReceivedOn" runat="server" Text='<%# Eval("ReceivedOn") %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="RequestedFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter RequestedFrom column"
                                                                                                        HeaderText="<%$ Resources:Resource, lblRequestFrom %>" SortExpression="RequestedFrom" UniqueName="RequestedFrom">
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="RequestedFrom" runat="server" Text='<%# Eval("RequestedFrom") %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="RequestedOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter RequestedOn column"
                                                                                                        HeaderText="<%$ Resources:Resource, lblRequestOn %>" SortExpression="RequestedOn" UniqueName="RequestedOn">
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="RequestedOn" runat="server" Text='<%# Eval("RequestedOn") %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="RequestListID" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter RequestListID column"
                                                                                                        HeaderText="<%$ Resources:Resource, lblDocumentID %>" SortExpression="RequestListID" UniqueName="RequestListID">
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="RequestListID" runat="server" Text='<%# Eval("RequestListID") %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="CreatedFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedFrom column"
                                                                                                        HeaderText="<%$ Resources:Resource, lblCreatedFrom %>" SortExpression="CreatedFrom" UniqueName="CreatedFrom" Visible="False">
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="CreatedFrom" runat="server" Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="CreatedOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedOn column"
                                                                                                        HeaderText="<%$ Resources:Resource, lblCreatedOn %>" SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="False">
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="CreatedOn" runat="server" Text='<%# Eval("CreatedOn") %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="EditFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditFrom column"
                                                                                                        HeaderText="<%$ Resources:Resource, lblEditFrom %>" SortExpression="EditFrom" UniqueName="EditFrom" Visible="False">
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="EditFrom" runat="server" Text='<%# Eval("EditFrom") %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="EditOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditOn column"
                                                                                                        HeaderText="<%$ Resources:Resource, lblEditOn %>" SortExpression="EditOn" UniqueName="EditOn" Visible="False">
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="EditOn" runat="server" Text='<%# Eval("EditOn") %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>
                                                                        </Columns>
                                                                    </MasterTableView>
                                                                </telerik:RadGrid>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" style="padding-right: 12px;">
                                                    <asp:ValidationSummary ID="ValidationSummary3" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' ShowMessageBox="true"
                                                                           ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp; </td>
                                                <td>&nbsp; </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="2">
                                        <telerik:RadButton ID="btnSaveTariffs" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionSave %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' CommandArgument="NoExit" Icon-PrimaryIconCssClass="rbSave">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="btnUpdateTariffs" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblInsertAndClose : Resources.Resource.lblUpdateAndClose %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' Icon-PrimaryIconCssClass="rbOk">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="btnCancelTariffs" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                           CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                        </telerik:RadButton>
                                    </td>
                                </tr>
                            </table>

                            <asp:SqlDataSource ID="SqlDataSource_CompanyTariffs" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT System_Tariffs.TariffID, System_TariffScopes.TariffContractID, Master_CompanyTariffs.TariffScopeID, Master_CompanyTariffs.ValidFrom, System_Tariffs.NameVisible AS TariffName, System_TariffScopes.NameVisible AS ScopeName FROM Master_CompanyTariffs INNER JOIN System_TariffScopes ON Master_CompanyTariffs.SystemID = System_TariffScopes.SystemID AND Master_CompanyTariffs.TariffScopeID = System_TariffScopes.TariffScopeID INNER JOIN System_Tariffs ON System_TariffScopes.SystemID = System_Tariffs.SystemID AND System_TariffScopes.TariffID = System_Tariffs.TariffID WHERE (Master_CompanyTariffs.SystemID = @SystemID) AND (Master_CompanyTariffs.BpID = @BpID) AND (Master_CompanyTariffs.CompanyID = @CompanyID)">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="CompanyID1" PropertyName="Value" DefaultValue="0" Name="CompanyID" Type="Int32"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource ID="SqlDataSource_WageGroupAssignment" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               OldValuesParameterFormatString="original_{0}"
                                               SelectCommand="SELECT m_ewga.SystemID, m_ewga.BpID, m_ewga.EmployeeID, m_ewga.TariffWageGroupID, s_twg.NameVisible, m_ewga.ValidFrom, m_ewga.CreatedFrom, m_ewga.CreatedOn, m_ewga.EditFrom, m_ewga.EditOn, System_TariffWages.NameVisible AS WageName, System_TariffWages.Wage FROM Master_EmployeeWageGroupAssignment AS m_ewga INNER JOIN System_TariffWageGroups AS s_twg ON m_ewga.SystemID = s_twg.SystemID AND m_ewga.TariffWageGroupID = s_twg.TariffWageGroupID INNER JOIN System_TariffWages ON s_twg.TariffID = System_TariffWages.TariffID AND s_twg.TariffContractID = System_TariffWages.TariffContractID AND s_twg.TariffScopeID = System_TariffWages.TariffScopeID AND s_twg.TariffWageGroupID = System_TariffWages.TariffWageGroupID AND s_twg.SystemID = System_TariffWages.SystemID WHERE (m_ewga.SystemID = @SystemID) AND (m_ewga.BpID = @BpID) AND (m_ewga.EmployeeID = @EmployeeID)"
                                               DeleteCommand="DELETE FROM Master_EmployeeWageGroupAssignment WHERE (SystemID = @original_SystemID) AND (BpID = @original_BpID) AND (EmployeeID = @original_EmployeeID) AND (TariffWageGroupID = @original_TariffWageGroupID)">
                                <DeleteParameters>
                                    <asp:Parameter Name="original_SystemID"></asp:Parameter>
                                    <asp:Parameter Name="original_BpID"></asp:Parameter>
                                    <asp:Parameter Name="original_EmployeeID"></asp:Parameter>
                                    <asp:Parameter Name="original_TariffWageGroupID"></asp:Parameter>
                                </DeleteParameters>
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID" Type="Int32"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource ID="SqlDataSource_TariffWageGroups" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT DISTINCT s_twg.TariffWageGroupID, s_twg.NameVisible, s_twg.DescriptionShort FROM Master_CompanyTariffs AS m_ct INNER JOIN System_TariffWageGroups AS s_twg ON m_ct.SystemID = s_twg.SystemID AND m_ct.TariffScopeID = s_twg.TariffScopeID WHERE (m_ct.SystemID = @SystemID) AND (m_ct.BpID = @BpID) AND (m_ct.CompanyID = @CompanyID) ORDER BY s_twg.NameVisible">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="CompanyID1" PropertyName="Value" DefaultValue="0" Name="CompanyID" Type="Int32"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource ID="SqlDataSource_TariffHistorie" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT System_Tariffs.TariffID, System_TariffScopes.TariffContractID, Master_CompanyTariffs.TariffScopeID, Master_CompanyTariffs.ValidFrom, System_Tariffs.NameVisible AS TariffName, System_TariffScopes.NameVisible AS ScopeName, System_TariffWages.Wage, System_TariffWageGroups.NameVisible AS WageGroupName, System_TariffWages.NameVisible AS WageName FROM Master_CompanyTariffs INNER JOIN System_TariffScopes ON Master_CompanyTariffs.SystemID = System_TariffScopes.SystemID AND Master_CompanyTariffs.TariffScopeID = System_TariffScopes.TariffScopeID INNER JOIN System_Tariffs ON System_TariffScopes.SystemID = System_Tariffs.SystemID AND System_TariffScopes.TariffID = System_Tariffs.TariffID INNER JOIN System_TariffWageGroups ON System_TariffScopes.SystemID = System_TariffWageGroups.SystemID AND System_TariffScopes.TariffID = System_TariffWageGroups.TariffID AND System_TariffScopes.TariffContractID = System_TariffWageGroups.TariffContractID AND System_TariffScopes.TariffScopeID = System_TariffWageGroups.TariffScopeID INNER JOIN System_TariffWages ON System_TariffWageGroups.SystemID = System_TariffWages.SystemID AND System_TariffWageGroups.TariffID = System_TariffWages.TariffID AND System_TariffWageGroups.TariffContractID = System_TariffWages.TariffContractID AND System_TariffWageGroups.TariffScopeID = System_TariffWages.TariffScopeID AND System_TariffWageGroups.TariffWageGroupID = System_TariffWages.TariffWageGroupID WHERE (Master_CompanyTariffs.SystemID = @SystemID) AND (Master_CompanyTariffs.BpID = @BpID) AND (Master_CompanyTariffs.CompanyID = @CompanyID)">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="CompanyID1" PropertyName="Value" DefaultValue="0" Name="CompanyID" Type="Int32"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource runat="server" ID="SqlDataSource_EmployeeMinWage" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                                               SelectCommand="SELECT DISTINCT d_emw.SystemID, d_emw.BpID, d_emw.EmployeeID, d_emw.MWMonth, d_emw.PresenceSeconds, d_emw.StatusCode, d_emw.Amount, d_emw.RequestListID, d_emw.CreatedFrom, d_emw.CreatedOn, d_emw.EditFrom, d_emw.EditOn, m_a.FirstName, m_a.LastName, m_a.BirthDate, m_e.CompanyID, d_emw.RequestedFrom, d_emw.RequestedOn, d_emw.ReceivedFrom, d_emw.ReceivedOn, MIN(ISNULL(s_tw_c.Wage, 0)) AS Wage_C, ISNULL(s_tw_e.Wage, 0) AS Wage_E, MAX(m_ewga.ValidFrom) AS ValidFrom_E, MAX(s_tw_c.ValidFrom) AS ValidFrom_C FROM System_TariffWages AS s_tw_e RIGHT OUTER JOIN Master_EmployeeWageGroupAssignment AS m_ewga RIGHT OUTER JOIN Data_EmployeeMinWage AS d_emw INNER JOIN Master_Employees AS m_e ON d_emw.SystemID = m_e.SystemID AND d_emw.BpID = m_e.BpID AND d_emw.EmployeeID = m_e.EmployeeID INNER JOIN Master_Addresses AS m_a ON m_e.SystemID = m_a.SystemID AND m_e.BpID = m_a.BpID AND m_e.AddressID = m_a.AddressID ON m_ewga.TariffWageGroupID = d_emw.WageGroupID AND m_ewga.SystemID = d_emw.SystemID AND m_ewga.BpID = d_emw.BpID AND m_ewga.EmployeeID = d_emw.EmployeeID LEFT OUTER JOIN Master_CompanyTariffs AS m_ct LEFT OUTER JOIN System_TariffWageGroups AS s_twg_c LEFT OUTER JOIN System_TariffWages AS s_tw_c ON s_twg_c.SystemID = s_tw_c.SystemID AND s_twg_c.TariffID = s_tw_c.TariffID AND s_twg_c.TariffContractID = s_tw_c.TariffContractID AND s_twg_c.TariffScopeID = s_tw_c.TariffScopeID AND s_twg_c.TariffWageGroupID = s_tw_c.TariffWageGroupID ON m_ct.SystemID = s_twg_c.SystemID AND m_ct.TariffScopeID = s_twg_c.TariffScopeID ON m_e.SystemID = m_ct.SystemID AND m_e.BpID = m_ct.BpID AND m_e.CompanyID = m_ct.CompanyID ON s_tw_e.SystemID = m_ewga.SystemID AND s_tw_e.TariffWageGroupID = m_ewga.TariffWageGroupID GROUP BY d_emw.SystemID, d_emw.EmployeeID, d_emw.MWMonth, d_emw.PresenceSeconds, d_emw.StatusCode, d_emw.Amount, d_emw.RequestListID, d_emw.CreatedFrom, d_emw.CreatedOn, d_emw.EditFrom, d_emw.EditOn, m_a.FirstName, m_a.LastName, m_a.BirthDate, d_emw.RequestedFrom, d_emw.RequestedOn, d_emw.ReceivedFrom, d_emw.ReceivedOn, ISNULL(s_tw_e.Wage, 0), d_emw.BpID, m_e.CompanyID HAVING (MAX(m_ewga.ValidFrom) <= CAST(d_emw.MWMonth AS datetime) OR MAX(m_ewga.ValidFrom) IS NULL) AND (d_emw.SystemID = @SystemID) AND (d_emw.BpID = @BpID) AND (m_e.CompanyID = @CompanyID) AND (d_emw.EmployeeID = @EmployeeID) OR (d_emw.SystemID = @SystemID) AND (d_emw.BpID = @BpID) AND (m_e.CompanyID = @CompanyID) AND (d_emw.EmployeeID = @EmployeeID) AND (MAX(s_tw_c.ValidFrom) <= CAST(d_emw.MWMonth AS datetime) OR MAX(s_tw_c.ValidFrom) IS NULL)">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="CompanyID1" PropertyName="Value" DefaultValue="0" Name="CompanyID" Type="Int32"></asp:ControlParameter>
                                    <asp:ControlParameter ControlID="EmployeeID1" PropertyName="Value" DefaultValue="0" Name="EmployeeID" Type="Int32"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>

                        </telerik:RadPageView>

                        <%-- Document rules --%>
                        <telerik:RadPageView ID="RadPageView5" runat="server">
                            <table id="Table13" cellspacing="2" cellpadding="2" border="0" rules="none" class="EditFormTable">
                                <tr>
                                    <td style="vertical-align: top;">
                                        <table id="Table14" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ", ", Resources.Resource.lblAddrFirstName, ":") %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Eval("LastName"), ", ", Eval("FirstName")) %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ", ", Resources.Resource.lblAddrEmail, ":") %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Eval("Phone"), ", ", Eval("Email")) %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Eval("NameVisible"), ", ", Eval("NameAdditional")) %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp; </td>
                                                <td>&nbsp; </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelMaxHrsPerMonth" Text='<%# String.Concat(Resources.Resource.lblMaxHrsPerMonth, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadTextBox runat="server" ID="MaxHrsPerMonth" Text='<%# Bind("MaxHrsPerMonth") %>'></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelAppliedRule" Text='<%# String.Concat(Resources.Resource.lblAppliedRule, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" ID="AppliedRule"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="LabelRadGridDocumentRules" Text='<%# String.Concat(Resources.Resource.lblDocumentRules, ":") %>' runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <telerik:RadGrid runat="server" ID="RadGridDocumentRules" DataSourceID="SqlDataSource_DocumentRules"
                                                                                 OnItemDataBound="RadGridDocumentRules_ItemDataBound"
                                                                                 OnItemUpdated="RadGridDocumentRules_ItemUpdated" OnUpdateCommand="RadGridDocumentRules_UpdateCommand"
                                                                                 OnItemCommand="RadGridDocumentRules_ItemCommand" OnItemCreated="RadGridDocumentRules_ItemCreated">

                                                                    <ValidationSettings ValidationGroup="DocumentRules" EnableValidation="false" />

                                                                    <MasterTableView DataSourceID="SqlDataSource_DocumentRules" AutoGenerateColumns="false" AllowPaging="true" PageSize="5"
                                                                                     EditMode="EditForms" DataKeyNames="SystemID,BpID,EmployeeID,RelevantFor" CommandItemDisplay="Top">

                                                                        <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="false" PageSizes="5,10,50" />

                                                                        <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="false" ShowExportToCsvButton="false"
                                                                                             ShowExportToExcelButton="false" ShowExportToPdfButton="false"
                                                                                             AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                                                                        <EditFormSettings EditFormType="Template">
                                                                            <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                                                                            <EditColumn ButtonType="ImageButton" UniqueName="EditColumn2" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                                                                                        EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                                                                            <FormTableStyle CellPadding="3" CellSpacing="3" />
                                                                            <FormTemplate>
                                                                                <table>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text="<%$ Resources:Resource, lblRelevantFor %>"></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:HiddenField runat="server" ID="EmployeeID" Value='<%# ((System.Data.DataRowView)Container.DataItem)["EmployeeID"] %>' />
                                                                                            <asp:HiddenField runat="server" ID="RelevantFor" Value='<%# ((System.Data.DataRowView)Container.DataItem)["RelevantFor"] %>' />
                                                                                            <asp:Label runat="server" ID="RelevantForText" Text='<%# GetRelevantFor(Convert.ToInt16(((System.Data.DataRowView)Container.DataItem)["RelevantFor"])) %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text="<%$ Resources:Resource, lblDocument %>" Font-Bold="true"></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <telerik:RadComboBox runat="server" ID="RelevantDocumentID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                                                                                                 DataValueField="RelevantDocumentID" DataTextField="NameVisible" Width="300" Filter="Contains" DropDownAutoWidth="Enabled"
                                                                                                                 AppendDataBoundItems="true" OnSelectedIndexChanged="RelevantDocumentID_SelectedIndexChanged" AutoPostBack="true">
                                                                                                <ItemTemplate>
                                                                                                    <table cellpadding="5px" style="text-align: left;">
                                                                                                        <tr>
                                                                                                            <td style="text-align: left;">
                                                                                                                <asp:Label ID="ItemName" Text='<%# Eval("RelevantDocumentID") %>' runat="server" Visible="false">
                                                                                                                </asp:Label>
                                                                                                            </td>
                                                                                                            <td style="text-align: left;">
                                                                                                                <asp:Label ID="ItemDescr" Text='<%# Eval("NameVisible") %>' runat="server">
                                                                                                                </asp:Label>
                                                                                                            </td>
                                                                                                            <td style="background-color: #EFEFEF; text-align: left;">
                                                                                                                <telerik:RadBinaryImage runat="server" ID="SampleData" DataValue='<%# (Eval("SampleData") == DBNull.Value) ? new Byte[0] : Eval("SampleData") %>'
                                                                                                                                        AutoAdjustImageControlSize="false" Height="60px" ToolTip='<%# Eval("NameVisible", "Beispiel für {0}") %>'></telerik:RadBinaryImage>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </ItemTemplate>
                                                                                            <%--                                                                                                    <Items>
                                                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0" />
                                                                                            </Items>--%>
                                                                                            </telerik:RadComboBox>
                                                                                            <asp:RequiredFieldValidator runat="server" ID="ValidatorRelevantDocumentID" ControlToValidate="RelevantDocumentID" Text="*"
                                                                                                                        ErrorMessage='<%# String.Concat(Resources.Resource.lblDocument, " ", Resources.Resource.lblRequired) %>' ValidationGroup="DocumentRules" ForeColor="Red">
                                                                                            </asp:RequiredFieldValidator>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text="<%$ Resources:Resource, lblSampleDocImage %>"></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <telerik:RadBinaryImage runat="server" ID="SampleData" CssClass="RoundedCorners ThinBorder Shadow"
                                                                                                                    AutoAdjustImageControlSize="true"></telerik:RadBinaryImage>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text="<%$ Resources:Resource, lblIsPresent %>"></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:CheckBox runat="server" ID="DocumentReceived" CssClass="cb" Checked='<%# Bind("DocumentReceived") %>' />
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" ID="LabelExpirationDate" Text="<%$ Resources:Resource, lblExpirationDate %>" Font-Bold='<%# ((System.Data.DataRowView)Container.DataItem)["RecExpirationDate"] %>'></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <telerik:RadDatePicker ID="ExpirationDate" runat="server" DbSelectedDate='<%# Bind("ExpirationDate") %>' MinDate="1900/1/1" MaxDate="2100/1/1" EnableShadows="true"
                                                                                                                   ShowPopupOnFocus="true" 
                                                                                                                   ToolTip='<%# ((System.Data.DataRowView)Container.DataItem)["ToolTipExpiration"] %>'>
                                                                                                <Calendar runat="server">
                                                                                                    <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                                                                                            TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                                                                                    </FastNavigationSettings>
                                                                                                </Calendar>
                                                                                            </telerik:RadDatePicker>
                                                                                            <asp:RequiredFieldValidator runat="server" ID="ValidatorExpirationDate" ControlToValidate="ExpirationDate" Enabled='<%# ((System.Data.DataRowView)Container.DataItem)["RecExpirationDate"] %>' Text="*"
                                                                                                                        ErrorMessage='<%# ((System.Data.DataRowView)Container.DataItem)["ToolTipExpiration"] %>' ValidationGroup="DocumentRules" ForeColor="Red">
                                                                                            </asp:RequiredFieldValidator>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text="<%$ Resources:Resource, lblExpirationDateIsAccessRelevant %>"></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:CheckBox runat="server" ID="IsAccessRelevant" CssClass="cb" Checked='<%# ((System.Data.DataRowView)Container.DataItem)["IsAccessRelevant"] %>' Enabled="false" />
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" ID="LabelIDNumber" Text="<%$ Resources:Resource, lblDocumentID %>" Font-Bold='<%# ((System.Data.DataRowView)Container.DataItem)["RecIDNumber"] %>'></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <telerik:RadTextBox runat="server" ID="IDNumber" Text='<%# Bind("IDNumber") %>' ToolTip='<%# ((System.Data.DataRowView)Container.DataItem)["ToolTipDocumentID"] %>'>
                                                                                            </telerik:RadTextBox>
                                                                                            <asp:RequiredFieldValidator runat="server" ID="ValidatorIDNumber" ControlToValidate="IDNumber" Enabled='<%# ((System.Data.DataRowView)Container.DataItem)["RecIDNumber"] %>' Text="*"
                                                                                                                        ErrorMessage='<%# ((System.Data.DataRowView)Container.DataItem)["ToolTipDocumentID"] %>' ValidationGroup="DocumentRules" ForeColor="Red">
                                                                                            </asp:RequiredFieldValidator>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>&nbsp; </td>
                                                                                        <td>
                                                                                            <asp:ValidationSummary runat="server" DisplayMode="BulletList" ShowMessageBox="true" ShowSummary="true" BorderStyle="None"
                                                                                                                   ValidationGroup="DocumentRules" />
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
                                                                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# ((System.Data.DataRowView)Container.DataItem)["CreatedFrom"] %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblCreatedOn, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# ((System.Data.DataRowView)Container.DataItem)["CreatedOn"] %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblEditFrom, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# ((System.Data.DataRowView)Container.DataItem)["EditFrom"] %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblEditOn, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# ((System.Data.DataRowView)Container.DataItem)["EditOn"] %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>&nbsp; </td>
                                                                                        <td>&nbsp; </td>
                                                                                    </tr>
                                                                                </table>
                                                                                <table>
                                                                                    <tr>
                                                                                        <td align="left" colspan="2">
                                                                                            <telerik:RadButton ID="RadButton20" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionUpdate%>'
                                                                                                               runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update"%>' Icon-PrimaryIconCssClass="rbOk"
                                                                                                               ValidationGroup="DocumentRules">
                                                                                            </telerik:RadButton>
                                                                                            <telerik:RadButton ID="RadButton21" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                                                                               CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                                                                            </telerik:RadButton>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </FormTemplate>
                                                                        </EditFormSettings>

                                                                        <Columns>
                                                                            <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn4" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                                                                                           UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                                                                                <ItemStyle BackColor="Control" Width="30px" />
                                                                                <HeaderStyle Width="30px" />
                                                                            </telerik:GridEditCommandColumn>

                                                                            <telerik:GridTemplateColumn DataField="RelevantFor" DataType="System.Int16"
                                                                                                        HeaderText="<%$ Resources:Resource, lblRelevantFor %>" SortExpression="RelevantFor" UniqueName="RelevantFor">
                                                                                <ItemTemplate>
                                                                                    <asp:Label runat="server" ID="RelevantFor" Text='<%# GetRelevantFor(Convert.ToInt16(((System.Data.DataRowView)Container.DataItem)["RelevantFor"])) %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridBoundColumn DataField="EmployeeID" UniqueName="EmployeeID" Visible="false" ForceExtractValue="Always"></telerik:GridBoundColumn>

                                                                            <telerik:GridBoundColumn DataField="RelevantDocumentID" UniqueName="RelevantDocumentID" Visible="false" ForceExtractValue="Always"></telerik:GridBoundColumn>

                                                                            <telerik:GridTemplateColumn DataField="NameVisible" DataType="System.Int32"
                                                                                                        HeaderText="<%$ Resources:Resource, lblDocument %>" SortExpression="NameVisible" UniqueName="NameVisible">
                                                                                <ItemTemplate>
                                                                                    <asp:Label runat="server" ID="NameVisible" Text='<%# ((System.Data.DataRowView)Container.DataItem)["NameVisible"] %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridCheckBoxColumn DataField="DocumentReceived" HeaderText="<%$ Resources:Resource, lblIsPresent %>"
                                                                                                        SortExpression="DocumentReceived" UniqueName="DocumentReceived" DataType="System.Boolean"
                                                                                                        FilterControlAltText="Filter DocumentReceived column" DefaultInsertValue="False" ForceExtractValue="Always">
                                                                            </telerik:GridCheckBoxColumn>

                                                                            <telerik:GridTemplateColumn DataField="ExpirationDate" DataType="System.DateTime" FilterControlAltText="Filter ExpirationDate column"
                                                                                                        HeaderText="<%$ Resources:Resource, lblExpirationDate %>" SortExpression="ExpirationDate" UniqueName="ExpirationDate">
                                                                                <ItemTemplate>
                                                                                    <asp:Label runat="server" ID="ExpirationDate" Text='<%# Eval("ExpirationDate", "{0:d}") %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridCheckBoxColumn DataField="IsAccessRelevant" HeaderText="<%$ Resources:Resource, lblAccessRelevant %>"
                                                                                                        SortExpression="IsAccessRelevant" UniqueName="IsAccessRelevant" DataType="System.Boolean"
                                                                                                        FilterControlAltText="Filter IsAccessRelevant column" DefaultInsertValue="False" ForceExtractValue="Always">
                                                                            </telerik:GridCheckBoxColumn>

                                                                            <telerik:GridTemplateColumn DataField="IDNumber" DataType="System.String" FilterControlAltText="Filter IDNumber column"
                                                                                                        HeaderText="<%$ Resources:Resource, lblDocumentID %>" SortExpression="IDNumber" UniqueName="IDNumber">
                                                                                <ItemTemplate>
                                                                                    <asp:Label runat="server" ID="IDNumber" Text='<%# ((System.Data.DataRowView)Container.DataItem)["IDNumber"] %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>
                                                                        </Columns>
                                                                    </MasterTableView>
                                                                </telerik:RadGrid>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" style="padding-right: 12px;">
                                                    <asp:ValidationSummary ID="ValidationSummary4" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' ShowMessageBox="true"
                                                                           ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp; </td>
                                                <td>&nbsp; </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="2">
                                        <telerik:RadButton ID="btnSaveDocumentRules" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionSave %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' CommandArgument="NoExit" Icon-PrimaryIconCssClass="rbSave">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="btnUpdateDocumentRules" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblInsertAndClose : Resources.Resource.lblUpdateAndClose %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' Icon-PrimaryIconCssClass="rbOk">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="btnCancelDocumentRules" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                           CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                        </telerik:RadButton>
                                    </td>
                                </tr>
                            </table>

                            <asp:SqlDataSource ID="SqlDataSource_DocumentRules" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT erd.SystemID, erd.BpID, erd.EmployeeID, erd.RelevantFor, erd.RelevantDocumentID, rd.NameVisible, erd.DocumentReceived, erd.ExpirationDate, erd.IDNumber, tr1.DescriptionTranslated AS ToolTipExpiration, tr2.DescriptionTranslated AS ToolTipDocumentID, ISNULL(rd.IsAccessRelevant, 0) AS IsAccessRelevant, ISNULL(rd.RecExpirationDate, 0) AS RecExpirationDate, ISNULL(rd.RecIDNumber, 0) AS RecIDNumber, erd.CreatedFrom, erd.CreatedOn, erd.EditFrom, erd.EditOn FROM Master_EmployeeRelevantDocuments AS erd LEFT OUTER JOIN Master_RelevantDocuments AS rd ON erd.RelevantFor = rd.RelevantFor AND erd.SystemID = rd.SystemID AND erd.BpID = rd.BpID AND erd.RelevantDocumentID = rd.RelevantDocumentID LEFT OUTER JOIN Master_Translations AS tr2 ON rd.SystemID = tr2.SystemID AND rd.BpID = tr2.BpID AND rd.RelevantDocumentID = tr2.ForeignID LEFT OUTER JOIN Master_Translations AS tr1 ON rd.SystemID = tr1.SystemID AND rd.BpID = tr1.BpID AND rd.RelevantDocumentID = tr1.ForeignID WHERE (tr1.DialogID = 6) AND (tr1.FieldID = 13) AND (tr2.DialogID = 6) AND (tr2.FieldID = 14) AND (tr1.LanguageID = @LanguageID) AND (tr2.LanguageID = @LanguageID) AND (erd.SystemID = @SystemID) AND (erd.BpID = @BpID) AND (erd.EmployeeID = @EmployeeID) OR (tr1.DialogID IS NULL) AND (tr1.FieldID IS NULL) AND (tr2.DialogID IS NULL) AND (tr2.FieldID IS NULL) AND (tr1.LanguageID IS NULL) AND (tr2.LanguageID IS NULL) AND (erd.SystemID = @SystemID) AND (erd.BpID = @BpID) AND (erd.EmployeeID = @EmployeeID)">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="LanguageID" DefaultValue="en" Name="LanguageID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </telerik:RadPageView>

                        <%-- Access control --%>
                        <telerik:RadPageView ID="RadPageView6" runat="server">
                            <table id="Table15" cellspacing="2" cellpadding="2" border="0" rules="none" class="EditFormTable">
                                <tr>
                                    <td style="vertical-align: top;">
                                        <table id="Table17" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top; width: 100%;">
                                            <tr>
                                                <td>
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ", ", Resources.Resource.lblAddrFirstName, ":") %>'
                                                                           Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:Label runat="server" Text='<%# String.Concat(Eval("LastName"), ", ", Eval("FirstName")) %>'
                                                                           Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ", ", Resources.Resource.lblAddrEmail, ":") %>'
                                                                           Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:Label runat="server" Text='<%# String.Concat(Eval("Phone"), ", ", Eval("Email")) %>'
                                                                           Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'
                                                                           Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:Label runat="server" Text='<%# String.Concat(Eval("NameVisible"), ", ", Eval("NameAdditional")) %>'
                                                                           Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>&nbsp; </td>
                                                            <td>&nbsp; </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="LabelAttributeID" Text='<%# String.Concat(Resources.Resource.lblAttributeForPrintPass, ":") %>'></asp:Label>
                                                            </td>
                                                            <td>
                                                                <telerik:RadComboBox runat="server" ID="AttributeID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                                                                     DataValueField="AttributeID" DataTextField="NameVisible" Width="300" DataSourceID="SqlDataSource_AssignedAttributes"
                                                                                     Filter="Contains" AppendDataBoundItems="true" DropDownAutoWidth="Enabled" SelectedValue='<%# (Container is GridEditFormInsertItem) ? 0 : Eval("AttributeID") %>'>
                                                                    <Items>
                                                                        <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0" />
                                                                    </Items>
                                                                </telerik:RadComboBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="LabelExternalPassID" Text='<%# String.Concat(Resources.Resource.lblExternalPassID, ":") %>'></asp:Label>
                                                            </td>
                                                            <td>
                                                                <telerik:RadTextBox runat="server" ID="ExternalPassID" Text='<%# Bind("ExternalPassID") %>' Width="300px"></telerik:RadTextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="LabelAccessRightValidUntil" Text='<%# String.Concat(Resources.Resource.lblAccessRightValidUntil, ":") %>'></asp:Label>
                                                            </td>
                                                            <td>
                                                                <telerik:RadDatePicker ID="AccessRightValidUntil" runat="server" DbSelectedDate='<%# Bind("AccessRightValidUntil") %>' MinDate="1900/1/1" MaxDate="2100/1/1" EnableShadows="true"
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
                                                            <td>&nbsp; </td>
                                                            <td>&nbsp; </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="vertical-align: top; text-align: left; float: right;">
                                                    <fieldset style="margin-left: 10px; border-radius: 5px; border-style: solid; border-color: ActiveBorder; background-color: transparent; background: none;">
                                                        <legend style="background-color: transparent;">
                                                        <%= Resources.Resource.lblPass %>
                                                        </legend>
                                                        <table>
                                                            <%--                                                            <tr>
                                                            <td>
                                                            <telerik:RadButton runat="server" ID="PassReprint" Text="<%$ Resources:Resource, lblActionPrint %>" AutoPostBack="true" Width="300px"
                                                            Icon-PrimaryIconCssClass="rbPrint" ButtonType="StandardButton" BorderStyle="None" CausesValidation="false"
                                                            Enabled="true" CommandName="ReprintPass" CommandArgument='<%# Eval("EmployeeID") %>' OnClientClicked = "gridCommand">
                                                            </telerik:RadButton>
                                                            </td>
                                                            </tr>--%>
                                                            <tr>
                                                                <td>
                                                                    <telerik:RadButton runat="server" ID="PassPrint" Text="<%$ Resources:Resource, lblActionPrint %>" AutoPostBack="false" Width="300px"
                                                                                       Icon-PrimaryIconCssClass="rbPrint" ButtonType="StandardButton" BorderStyle="None" CausesValidation="false"
                                                                                       Enabled="false">
                                                                    </telerik:RadButton>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <telerik:RadButton runat="server" ID="PassActivate" Text="<%$ Resources:Resource, lblActionActivate %>" AutoPostBack="false" Width="300px"
                                                                                       Icon-PrimaryIconCssClass="rbOk" ButtonType="StandardButton" BorderStyle="None" CausesValidation="false"
                                                                                       Enabled="false">
                                                                    </telerik:RadButton>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <telerik:RadButton runat="server" ID="PassDeactivate" Text="<%$ Resources:Resource, lblActionDeactivate %>" AutoPostBack="false" Width="300px"
                                                                                       Icon-PrimaryIconCssClass="rbCancel" ButtonType="StandardButton" BorderStyle="None" CausesValidation="false"
                                                                                       Enabled="false">
                                                                    </telerik:RadButton>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <telerik:RadButton runat="server" ID="PassLock" Text="<%$ Resources:Resource, lblActionLock %>" AutoPostBack="false" Width="300px"
                                                                                       ButtonType="StandardButton" BorderStyle="None" CausesValidation="false"
                                                                                       Enabled="false">
                                                                        <Icon PrimaryIconUrl="../../Resources/Icons/locked_16.png" PrimaryIconHeight="16px" PrimaryIconWidth="16px" />
                                                                    </telerik:RadButton>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>&nbsp; </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <telerik:RadButton runat="server" ID="AccessRightInfo" Text='<%# Resources.Resource.lblAccessRightsInfo %>' AutoPostBack="false"
                                                                                       ButtonType="StandardButton" BorderStyle="None" CausesValidation="false" Width="300px"
                                                                                       Enabled="false">
                                                                        <Icon PrimaryIconUrl="../../Resources/Icons/info_16.png" PrimaryIconHeight="16px" PrimaryIconWidth="16px" />
                                                                    </telerik:RadButton>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label runat="server" ID="AccessDenialReason"></asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </fieldset>
                                                </td>
                                            </tr>
                                        </table>

                                        <table id="Table16" cellspacing="2" cellpadding="4" border="0" class="module" style="vertical-align: top;">
                                            <tr style="vertical-align: top;">
                                                <td style="vertical-align: top;">
                                                    <table style="vertical-align: top;">
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="LabelAssignedAreas" Text='<%# String.Concat(Resources.Resource.lblAssignedAreas, ":") %>'></asp:Label>
                                                                <asp:HiddenField runat="server" ID="EmployeeID1" Value='<%# Eval("EmployeeID") %>' />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <telerik:RadGrid runat="server" ID="AssignedAreas" DataSourceID="SqlDataSource_EmployeeAccessAreas" CssClass="RadGrid"
                                                                                 AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowAutomaticUpdates="true"
                                                                                 OnItemCommand="AssignedAreas_ItemCommand" OnItemDeleted="AssignedAreas_ItemDeleted" OnItemCreated="AssignedAreas_ItemCreated"
                                                                                 OnItemInserted="AssignedAreas_ItemInserted" OnItemUpdated="AssignedAreas_ItemUpdated">

                                                                    <ValidationSettings ValidationGroup="AssignedAreas" EnableValidation="false" />

                                                                    <MasterTableView DataSourceID="SqlDataSource_EmployeeAccessAreas" AutoGenerateColumns="false" AllowPaging="true" PageSize="5"
                                                                                     CommandItemDisplay="Top" CssClass="MasterClass" EditMode="EditForms" DataKeyNames="SystemID,BpID,EmployeeID,AccessAreaID,TimeSlotGroupID">

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
                                                                                            <telerik:RadButton ID="RadButton22" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionUpdate%>'
                                                                                                               runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update"%>' Icon-PrimaryIconCssClass="rbOk"
                                                                                                               ValidationGroup="AccessArea">
                                                                                            </telerik:RadButton>
                                                                                            <telerik:RadButton ID="RadButton23" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                                                                               CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                                                                            </telerik:RadButton>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </FormTemplate>
                                                                        </EditFormSettings>
                                                                    </MasterTableView>
                                                                </telerik:RadGrid>

                                                                <asp:SqlDataSource ID="SqlDataSource_EmployeeAccessAreas" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                                                                   OldValuesParameterFormatString="original_{0}"
                                                                                   SelectCommand="SELECT DISTINCT m_eaa.AccessAreaID, m_aa.NameVisible AS AccessAreaName, m_aa.DescriptionShort, m_eaa.BpID, m_tsg.NameVisible AS TimeSlotGroupName, m_eaa.TimeSlotGroupID, m_eaa.CreatedFrom, m_eaa.CreatedOn, m_eaa.EditFrom, m_eaa.EditOn, m_eaa.EmployeeID, m_eaa.SystemID, dbo.EmployeeAccessAreaPresentState(m_eaa.SystemID, m_eaa.BpID, m_eaa.EmployeeID, m_eaa.AccessAreaID) AS AccessState, m_eaa.AdditionalRights FROM Master_EmployeeAccessAreas AS m_eaa INNER JOIN Master_AccessAreas AS m_aa ON m_eaa.SystemID = m_aa.SystemID AND m_eaa.BpID = m_aa.BpID AND m_eaa.AccessAreaID = m_aa.AccessAreaID LEFT OUTER JOIN Master_TimeSlotGroups AS m_tsg ON m_eaa.SystemID = m_tsg.SystemID AND m_eaa.BpID = m_tsg.BpID AND m_eaa.TimeSlotGroupID = m_tsg.TimeSlotGroupID WHERE (m_eaa.SystemID = @SystemID) AND (m_eaa.BpID = @BpID) AND (m_eaa.EmployeeID = @EmployeeID)"
                                                                                   DeleteCommand="DELETE Master_EmployeeAccessAreas WHERE (SystemID = @original_SystemID) AND (BpID = @original_BpID) AND (EmployeeID = @original_EmployeeID) AND (AccessAreaID = @original_AccessAreaID) AND (TimeSlotGroupID = @original_TimeSlotGroupID)"
                                                                                   InsertCommand="INSERT INTO Master_EmployeeAccessAreas(SystemID, BpID, EmployeeID, AccessAreaID, TimeSlotGroupID, CreatedFrom, CreatedOn, EditFrom, EditOn, AdditionalRights) VALUES (@SystemID, @BpID, @EmployeeID, @AccessAreaID, @TimeSlotGroupID, @UserName, SYSDATETIME(), @UserName, SYSDATETIME(), @AdditionalRights)"
                                                                                   UpdateCommand="UPDATE Master_EmployeeAccessAreas SET TimeSlotGroupID = @TimeSlotGroupID, EditFrom = @UserName, EditOn = SYSDATETIME(), AdditionalRights = @AdditionalRights WHERE (SystemID = @original_SystemID) AND (BpID = @original_BpID) AND (EmployeeID = @original_EmployeeID) AND (AccessAreaID = @original_AccessAreaID) AND (TimeSlotGroupID = @original_TimeSlotGroupID)">
                                                                    <DeleteParameters>
                                                                        <asp:Parameter Name="original_SystemID"></asp:Parameter>
                                                                        <asp:Parameter Name="original_BpID"></asp:Parameter>
                                                                        <asp:Parameter Name="original_EmployeeID"></asp:Parameter>
                                                                        <asp:Parameter Name="original_AccessAreaID"></asp:Parameter>
                                                                        <asp:Parameter Name="original_TimeSlotGroupID"></asp:Parameter>
                                                                    </DeleteParameters>
                                                                    <InsertParameters>
                                                                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                                                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                                                        <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                                                        <asp:Parameter Name="AccessAreaID"></asp:Parameter>
                                                                        <asp:Parameter Name="TimeSlotGroupID"></asp:Parameter>
                                                                        <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
                                                                        <asp:Parameter Name="AdditionalRights"></asp:Parameter>
                                                                    </InsertParameters>
                                                                    <SelectParameters>
                                                                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                                                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                                                        <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                                                    </SelectParameters>
                                                                    <UpdateParameters>
                                                                        <asp:Parameter Name="TimeSlotGroupID"></asp:Parameter>
                                                                        <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
                                                                        <asp:Parameter Name="AdditionalRights"></asp:Parameter>
                                                                        <asp:Parameter Name="original_SystemID"></asp:Parameter>
                                                                        <asp:Parameter Name="original_BpID"></asp:Parameter>
                                                                        <asp:Parameter Name="original_EmployeeID"></asp:Parameter>
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
                                                                                   SelectCommand="SELECT DISTINCT * FROM Master_AccessAreas aa WHERE aa.SystemID = @SystemID AND aa.BpID = @BpID AND NOT EXISTS (SELECT 1 FROM Master_EmployeeAccessAreas eaa WHERE  eaa.SystemID = @SystemID AND eaa.BpID = @BpID AND eaa.EmployeeID = @EmployeeID AND eaa.AccessAreaID = aa.AccessAreaID)">
                                                                    <SelectParameters>
                                                                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                                                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                                                        <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
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
                                                        <tr>
                                                            <td>&nbsp; </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="LabelRadGridEmplAccess3" Text='<%# String.Concat(Resources.Resource.lblEmplAccess3, ":") %>'></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <telerik:RadGrid runat="server" ID="RadGridEmplAccess3" DataSourceID="SqlDataSource_StatusID">
                                                                    <MasterTableView DataSourceID="SqlDataSource_StatusID" AutoGenerateColumns="false" AllowPaging="true" PageSize="5">
                                                                        <Columns>
                                                                            <telerik:GridTemplateColumn DataField="ResourceID" HeaderText="<%$ Resources:Resource, lblAction %>">
                                                                                <ItemTemplate>
                                                                                    <asp:Label runat="server" ID="ResourceID" Text='<%# GetResource(((System.Data.DataRowView)Container.DataItem)["ResourceID"].ToString()) %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>
                                                                            <telerik:GridBoundColumn DataField="InternalID" HeaderText="<%$ Resources:Resource, lblIDInternal %>"></telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="ExternalID" HeaderText="<%$ Resources:Resource, lblIDExternal %>"></telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="Timestamp" HeaderText="<%$ Resources:Resource, lblTimeStamp %>"></telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="Reason" HeaderText="<%$ Resources:Resource, lblReason %>"></telerik:GridBoundColumn>
                                                                        </Columns>
                                                                    </MasterTableView>
                                                                </telerik:RadGrid>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td>
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="LabelRadGridEmplAccess2" Text='<%# String.Concat(Resources.Resource.lblEmplAccess2, ":") %>'></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <%-- Zutrittsereignisse --%>
                                                                <telerik:RadGrid runat="server" ID="RadGridEmplAccess2" DataSourceID="SqlDataSource_AccessLog2" AllowAutomaticDeletes="true"
                                                                                 OnItemDataBound="RadGridEmplAccess2_ItemDataBound" OnInsertCommand="RadGridEmplAccess2_InsertCommand"
                                                                                 OnUpdateCommand="RadGridEmplAccess2_UpdateCommand" OnItemCommand="RadGridEmplAccess2_ItemCommand"
                                                                                 OnItemCreated="RadGridEmplAccess2_ItemCreated" OnItemDeleted="RadGridEmplAccess2_ItemDeleted"
                                                                                 OnPreRender="RadGridEmplAccess2_PreRender" GroupPanelPosition="Top">

                                                                    <ExportSettings ExportOnlyData="True" IgnorePaging="True">
                                                                        <Pdf PaperSize="A4">
                                                                        </Pdf>
                                                                        <Excel Format="ExcelML" />
                                                                    </ExportSettings>

                                                                    <ClientSettings AllowColumnsReorder="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false" AllowExpandCollapse="true">
                                                                        <Selecting AllowRowSelect="True" />
                                                                        <ClientEvents OnRowClick="OnRowClick" OnKeyPress="GridKeyPress" />
                                                                    </ClientSettings>

                                                                    <SortingSettings SortedBackColor="Transparent" />

                                                                    <MasterTableView DataSourceID="SqlDataSource_AccessLog2" AutoGenerateColumns="false" AllowPaging="true" PageSize="10"
                                                                                     CommandItemDisplay="Top" DataKeyNames="AccessEventID, SystemID, BpID" AllowFilteringByColumn="true" FilterItemStyle-VerticalAlign="Bottom">

                                                                        <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="false"
                                                                                             ShowExportToExcelButton="true" ShowExportToPdfButton="false"
                                                                                             AddNewRecordText="<%$ Resources:Resource, lblActionNew %>"
                                                                                             RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                                                                        <SortExpressions>
                                                                            <telerik:GridSortExpression FieldName="Timestamp" SortOrder="Descending"></telerik:GridSortExpression>
                                                                        </SortExpressions>

                                                                        <EditFormSettings CaptionDataField="NameVisible" CaptionFormatString="{0}" EditFormType="Template">

                                                                            <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />

                                                                            <EditColumn ButtonType="ImageButton" UniqueName="EditColumn2" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                                                                                        EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />

                                                                            <FormTableStyle CellPadding="3" CellSpacing="3" />

                                                                            <FormTemplate>
                                                                                <table>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Font-Bold="true" Text='<%# String.Concat(Resources.Resource.lblTimeStamp, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td nowrap="nowrap">
                                                                                            <telerik:RadDateTimePicker ID="AccessOn" runat="server" MinDate='<%# (Container is GridEditFormInsertItem) ? DateTime.Now.Date : DateTime.MinValue %>' MaxDate="<%# DateTime.Now %>" EnableShadows="true"
                                                                                                                       ShowPopupOnFocus="true"  
                                                                                                                       OnSelectedDateChanged="AccessOn_SelectedDateChanged" AutoPostBackControl="Both">
                                                                                                <Calendar runat="server">
                                                                                                    <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                                                                                            TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                                                                                    </FastNavigationSettings>
                                                                                                </Calendar>
                                                                                                <TimeView runat="server" ShowHeader="true" HeaderText="<%$ Resources:Resource, lblFrom %>" StartTime="00:00:00" Interval="01:00:00" EndTime="23:59:59" 
                                                                                                          Columns="4">
                                                                                                </TimeView>
                                                                                            </telerik:RadDateTimePicker>
                                                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="AccessOn" Text="*" SetFocusOnError="true" ForeColor="Red"
                                                                                                                        ErrorMessage='<%# String.Concat(Resources.Resource.lblTimeStamp, " ", Resources.Resource.lblRequired) %>'
                                                                                                                        ValidationGroup="AccessArea">
                                                                                            </asp:RequiredFieldValidator>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblDirection, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td nowrap="nowrap">
                                                                                            <table>
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <telerik:RadButton runat="server" ID="Access" ButtonType="ToggleButton" ToggleType="Radio" GroupName="AccessType" Checked="true" 
                                                                                                                           Text="<%$ Resources:Resource, lblAccessTypeComing %>" OnToggleStateChanged="Access_ToggleStateChanged"></telerik:RadButton>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        &nbsp;
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <asp:Image runat="server" ImageUrl="~/Resources/Icons/enter-16.png" Width="16px" Height="16px" />
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        &nbsp;
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        &nbsp;
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <telerik:RadButton runat="server" ID="Exit" ButtonType="ToggleButton" ToggleType="Radio" GroupName="AccessType" 
                                                                                                                           Text="<%$ Resources:Resource, lblAccessTypeLeaving %>" OnToggleStateChanged="Exit_ToggleStateChanged"></telerik:RadButton>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        &nbsp;
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <asp:Image runat="server" ImageUrl="~/Resources/Icons/exit-16.png" Width="16px" Height="16px" />
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>

                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Font-Bold="true" Text='<%# String.Concat(Resources.Resource.lblAccessArea, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td nowrap="nowrap">
                                                                                            <telerik:RadComboBox runat="server" ID="AccessAreaID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                                                                 AppendDataBoundItems="true"
                                                                                                                 DataValueField="AccessAreaID" DataTextField="NameVisible" Width="300" Filter="Contains" 
                                                                                                                 DropDownAutoWidth="Enabled" Enabled="true">
                                                                                            </telerik:RadComboBox>
                                                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="AccessAreaID" Text="*" SetFocusOnError="true" ForeColor="Red"
                                                                                                                        ErrorMessage='<%# String.Concat(Resources.Resource.lblAccessArea, " ", Resources.Resource.lblRequired) %>'
                                                                                                                        ValidationGroup="AccessArea">
                                                                                            </asp:RequiredFieldValidator>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblStatus, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Convert.ToBoolean((Eval("IsOnlineAccessEvent") != DBNull.Value) ? Eval("IsOnlineAccessEvent") : "true") ? Resources.Resource.lblOnline : Resources.Resource.lblOffline %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Font-Bold="true" Text='<%# String.Concat(Resources.Resource.lblRemark, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <telerik:RadTextBox runat="server" ID="Remark" ></telerik:RadTextBox>
                                                                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="Remark" Text="*" SetFocusOnError="true" ForeColor="Red"
                                                                                                                        ErrorMessage='<%# String.Concat(Resources.Resource.lblRemark, " ", Resources.Resource.lblRequired) %>'
                                                                                                                        ValidationGroup="AccessArea">
                                                                                            </asp:RequiredFieldValidator>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblDenialReason, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:Label runat="server" Text='<%# Eval("OriginalMessage") %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>&nbsp;</td>
                                                                                        <td>&nbsp;</td>
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
                                                                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("EditFrom") %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>
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
                                                                                            <telerik:RadButton ID="RadButton22" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionUpdate%>'
                                                                                                               runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update"%>' Icon-PrimaryIconCssClass="rbOk"
                                                                                                               ValidationGroup="AccessArea">
                                                                                            </telerik:RadButton>
                                                                                            <telerik:RadButton ID="RadButton23" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                                                                               CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                                                                            </telerik:RadButton>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </FormTemplate>
                                                                        </EditFormSettings>

                                                                        <NestedViewTemplate>
                                                                            <fieldset style="padding: 10px; width: 500px; margin-left: 10px; margin-bottom: 10px;">
                                                                                <legend style="padding: 5px; background-color: transparent;">
                                                                                    <b><%= Resources.Resource.lblDetailsFor %> <%# Convert.ToDateTime(Eval("Timestamp")).ToString("G") %></b>
                                                                                </legend>
                                                                                <table>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblTimeStamp, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text='<%# Convert.ToDateTime(Eval("Timestamp")).ToString("G") %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblDirection, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td nowrap="nowrap">
                                                                                            <table>
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <telerik:RadButton runat="server" ID="Access" ButtonType="ToggleButton" ToggleType="Radio" GroupName="AccessType" Checked='<%# (Convert.ToInt32(Eval("AccessTypeID")) == 1) %>' 
                                                                                                                           Text="<%$ Resources:Resource, lblAccessTypeComing %>" Enabled="false"></telerik:RadButton>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        &nbsp;
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <asp:Image runat="server" ImageUrl="~/Resources/Icons/enter-16.png" Width="16px" Height="16px" />
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        &nbsp;
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        &nbsp;
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <telerik:RadButton runat="server" ID="Exit" ButtonType="ToggleButton" ToggleType="Radio" GroupName="AccessType" Checked='<%# (Convert.ToInt32(Eval("AccessTypeID")) == 0) %>' 
                                                                                                                           Text="<%$ Resources:Resource, lblAccessTypeLeaving %>" Enabled="false"></telerik:RadButton>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        &nbsp;
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <asp:Image runat="server" ImageUrl="~/Resources/Icons/exit-16.png" Width="16px" Height="16px" />
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAccessArea, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text='<%# Eval("NameVisible") %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblStatus, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text='<%# Convert.ToBoolean(Eval("IsOnlineAccessEvent")) ? Resources.Resource.lblOnline : Resources.Resource.lblOffline %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblResult, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text='<%# Eval("Result").ToString().Equals("1") ? Resources.Resource.lblOK : Resources.Resource.lblFault %>' 
                                                                                                       ForeColor='<%# Eval("Result").ToString().Equals("1") ? System.Drawing.Color.DarkGreen : System.Drawing.Color.Red %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblManual, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text='<%# Convert.ToBoolean(Eval("IsManualEntry")) ? Resources.Resource.lblYes : Resources.Resource.lblNo %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblRemark, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:Label runat="server" Text='<%# Eval("Remark") %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td nowrap="nowrap">
                                                                                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblDenialReason, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:Label runat="server" Text='<%# Eval("OriginalMessage") %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>&nbsp;</td>
                                                                                        <td>&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblCreatedFrom, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:Label runat="server" Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblCreatedOn, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:Label runat="server" Text='<%# Eval("CreatedOn") %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEditFrom, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:Label runat="server" Text='<%# Eval("EditFrom") %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEditOn, ":") %>'></asp:Label>
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:Label runat="server" Text='<%# Eval("EditOn") %>'></asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </fieldset>
                                                                        </NestedViewTemplate>

                                                                        <Columns>
                                                                            <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn5" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                                                                                           UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                                                                                <ItemStyle BackColor="Control" Width="30px" />
                                                                                <HeaderStyle Width="30px" />
                                                                            </telerik:GridEditCommandColumn>

                                                                            <telerik:GridDateTimeColumn FilterControlWidth="100px" DataField="Timestamp" HeaderText="<%$ Resources:Resource, lblTimestamp %>" 
                                                                                                        SortExpression="Timestamp" UniqueName="Timestamp" PickerType="DatePicker" EnableRangeFiltering="true" 
                                                                                                        HeaderStyle-Width="170px" ItemStyle-Width="170px" CurrentFilterFunction="Between" 
                                                                                                        AutoPostBackOnFilter="true" EnableTimeIndependentFiltering="true">
                                                                            </telerik:GridDateTimeColumn>

                                                                            <telerik:GridBoundColumn DataField="AccessEventID" UniqueName="AccessEventID" Visible="false" ForceExtractValue="Always"></telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="SystemID" UniqueName="SystemID" Visible="false" ForceExtractValue="Always"></telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="BpID" UniqueName="BpID" Visible="false" ForceExtractValue="Always"></telerik:GridBoundColumn>
                                                                            <telerik:GridBoundColumn DataField="AccessAreaID" Visible="false"></telerik:GridBoundColumn>

                                                                            <telerik:GridBoundColumn DataField="EmployeeID" UniqueName="EmployeeID2" Visible="false"></telerik:GridBoundColumn>

                                                                            <telerik:GridTemplateColumn DataField="NameVisible" HeaderText="<%$ Resources:Resource, lblAccessArea %>" ForceExtractValue="Always"
                                                                                                        UniqueName="NameVisible" AutoPostBackOnFilter="true">
                                                                                <ItemTemplate>
                                                                                    <asp:Label runat="server" ID="NameVisible" Text='<%# Eval("NameVisible") %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                                <ItemStyle Width="300px" />
                                                                                <FilterTemplate>
                                                                                    <telerik:RadComboBox ID="NameVisibleFilter" DataSourceID="SqlDataSource_EmployeeAccessAreas" DataTextField="AccessAreaName"
                                                                                                         DataValueField="AccessAreaName" Height="200px" AppendDataBoundItems="true"
                                                                                                         SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("NameVisible").CurrentFilterValue %>'
                                                                                                         runat="server" OnClientSelectedIndexChanged="AccessAreaIDIndexChanged" DropDownAutoWidth="Enabled">
                                                                                        <Items>
                                                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" />
                                                                                        </Items>
                                                                                    </telerik:RadComboBox>
                                                                                    <telerik:RadScriptBlock ID="RadScriptBlock26" runat="server">
                                                                                        <script type="text/javascript">
                                                                                            function AccessAreaIDIndexChanged(sender, args) {
                                                                                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                                                                tableView.filter("NameVisible", args.get_item().get_value(), "EqualTo");
                                                                                            }
                                                                                        </script>
                                                                                    </telerik:RadScriptBlock>
                                                                                </FilterTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="AccessTypeID" HeaderText="<%$ Resources:Resource, lblDirection %>" 
                                                                                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" UniqueName="AccessTypeID">
                                                                                <ItemTemplate>
                                                                                    <asp:Image runat="server" ImageUrl='<%# (Convert.ToInt32(Eval("AccessTypeID")) == 1) ? "~/Resources/Icons/enter-16.png" : "~/Resources/Icons/exit-16.png" %>' 
                                                                                               Width="16px" Height="16px" ToolTip='<%# GetAccessType(Convert.ToInt32(((System.Data.DataRowView)Container.DataItem)["AccessTypeID"])) %>' />
                                                                                </ItemTemplate>
                                                                                <FilterTemplate>
                                                                                    <telerik:RadComboBox ID="AccessTypeIDFilter" DataValueField="AccessTypeID" Height="200px" AppendDataBoundItems="true" 
                                                                                                         SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("AccessTypeID").CurrentFilterValue %>'
                                                                                                         runat="server" OnClientSelectedIndexChanged="AccessTypeIDFilterIndexChanged" DropDownAutoWidth="Enabled" Width="50px">
                                                                                        <Items>
                                                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" Selected="true" />
                                                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAccessTypeLeaving %>" Value="0" />
                                                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAccessTypeComing %>" Value="1" />
                                                                                        </Items>
                                                                                    </telerik:RadComboBox>
                                                                                    <telerik:RadScriptBlock ID="RadScriptBlock30" runat="server">
                                                                                        <script type="text/javascript">
                                                                                            function AccessTypeIDFilterIndexChanged(sender, args) {
                                                                                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                                                                var filterVal = args.get_item().get_value();
                                                                                                if (filterVal === "") {
                                                                                                    tableView.filter("AccessTypeID", filterVal, "NoFilter");
                                                                                                } else if (filterVal === "1") {
                                                                                                    tableView.filter("AccessTypeID", "1", "EqualTo");
                                                                                                } else if (filterVal === "0") {
                                                                                                    tableView.filter("AccessTypeID", "0", "EqualTo");
                                                                                                }
                                                                                            }
                                                                                        </script>
                                                                                    </telerik:RadScriptBlock>
                                                                                </FilterTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="Result" HeaderText="<%$ Resources:Resource, lblResult %>" UniqueName="Result" CurrentFilterFunction="EqualTo">
                                                                                <ItemTemplate>
                                                                                    <asp:Label runat="server" Text='<%# Eval("Result").ToString().Equals("1") ? Resources.Resource.lblOK : Resources.Resource.lblFault %>' 
                                                                                               ForeColor='<%# Eval("Result").ToString().Equals("1") ? System.Drawing.Color.DarkGreen : System.Drawing.Color.Red %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                                <FilterTemplate>
                                                                                    <telerik:RadComboBox ID="ResultFilter" DataValueField="Result" Height="200px" AppendDataBoundItems="true" 
                                                                                                         SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("Result").CurrentFilterValue %>'
                                                                                                         runat="server" OnClientSelectedIndexChanged="ResultFilterIndexChanged" DropDownAutoWidth="Enabled" Width="50px">
                                                                                        <Items>
                                                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" Selected="true" />
                                                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblFault %>" Value="0" />
                                                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblOK %>" Value="1" />
                                                                                        </Items>
                                                                                    </telerik:RadComboBox>
                                                                                    <telerik:RadScriptBlock ID="RadScriptBlock31" runat="server">
                                                                                        <script type="text/javascript">
                                                                                            function ResultFilterIndexChanged(sender, args) {
                                                                                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                                                                var filterVal = args.get_item().get_value();
                                                                                                if (filterVal === "") {
                                                                                                    tableView.filter("Result", filterVal, "NoFilter");
                                                                                                } else if (filterVal === "1") {
                                                                                                    tableView.filter("Result", "1", "EqualTo");
                                                                                                } else if (filterVal === "0") {
                                                                                                    tableView.filter("Result", "0", "EqualTo");
                                                                                                }
                                                                                            }
                                                                                        </script>
                                                                                    </telerik:RadScriptBlock>
                                                                                </FilterTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="IsOnlineAccessEvent" HeaderText="<%$ Resources:Resource, lblStatus %>" 
                                                                                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" UniqueName="IsOnlineAccessEvent" 
                                                                                                        AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                                                                <ItemTemplate>
                                                                                    <asp:Image runat="server" ImageUrl='<%# Convert.ToBoolean(Eval("IsOnlineAccessEvent")) ? "~/Resources/Icons/Online_16.png" : "~/Resources/Icons/Offline_16.png" %>' 
                                                                                               Width="16px" Height="16px" ToolTip='<%# Convert.ToBoolean(Eval("IsOnlineAccessEvent")) ? Resources.Resource.lblOnline : Resources.Resource.lblOffline %>' />
                                                                                </ItemTemplate>
                                                                                <FilterTemplate>
                                                                                    <telerik:RadComboBox ID="IsOnlineAccessEventFilter" DataValueField="Result" Height="200px" AppendDataBoundItems="true" 
                                                                                                         SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("IsOnlineAccessEvent").CurrentFilterValue %>'
                                                                                                         runat="server" OnClientSelectedIndexChanged="IsOnlineAccessEventFilterIndexChanged" DropDownAutoWidth="Enabled" Width="50px">
                                                                                        <Items>
                                                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" Selected="true" />
                                                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblOffline %>" Value="false" />
                                                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblOnline %>" Value="true" />
                                                                                        </Items>
                                                                                    </telerik:RadComboBox>
                                                                                    <telerik:RadScriptBlock ID="RadScriptBlock32" runat="server">
                                                                                        <script type="text/javascript">
                                                                                            function IsOnlineAccessEventFilterIndexChanged(sender, args) {
                                                                                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                                                                var filterVal = args.get_item().get_value();
                                                                                                if (filterVal === "") {
                                                                                                    tableView.filter("IsOnlineAccessEvent", filterVal, "NoFilter");
                                                                                                } else {
                                                                                                    tableView.filter("IsOnlineAccessEvent", filterVal, "EqualTo");
                                                                                                }
                                                                                            }
                                                                                        </script>
                                                                                    </telerik:RadScriptBlock>
                                                                                </FilterTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="IsManualEntry" HeaderText="<%$ Resources:Resource, lblManual %>"
                                                                                                        UniqueName="IsManualEntry" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                                                                                <ItemTemplate>
                                                                                    <asp:Label runat="server" Text='<%# Convert.ToBoolean(Eval("IsManualEntry")) ? Resources.Resource.lblYes : Resources.Resource.lblNo %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                                <FilterTemplate>
                                                                                    <telerik:RadComboBox ID="IsManualEntryFilter" DataValueField="Result" Height="200px" AppendDataBoundItems="true" 
                                                                                                         SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("IsManualEntry").CurrentFilterValue %>'
                                                                                                         runat="server" OnClientSelectedIndexChanged="IsManualEntryFilterIndexChanged" DropDownAutoWidth="Enabled" Width="50px">
                                                                                        <Items>
                                                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" Selected="true" />
                                                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblNo %>" Value="false" />
                                                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblYes %>" Value="true" />
                                                                                        </Items>
                                                                                    </telerik:RadComboBox>
                                                                                    <telerik:RadScriptBlock ID="RadScriptBlock33" runat="server">
                                                                                        <script type="text/javascript">
                                                                                            function IsManualEntryFilterIndexChanged(sender, args) {
                                                                                                var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                                                                                var filterVal = args.get_item().get_value();
                                                                                                if (filterVal === "") {
                                                                                                    tableView.filter("IsManualEntry", filterVal, "NoFilter");
                                                                                                } else {
                                                                                                    tableView.filter("IsManualEntry", filterVal, "EqualTo");
                                                                                                }
                                                                                            }
                                                                                        </script>
                                                                                    </telerik:RadScriptBlock>
                                                                                </FilterTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridTemplateColumn DataField="OriginalMessage" HeaderText="<%$ Resources:Resource, lblDenialReason %>" ForceExtractValue="Always" SortExpression="OriginalMessage" 
                                                                                                        UniqueName="OriginalMessage" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="80px" GroupByExpression="OriginalMessage Group By OriginalMessage">
                                                                                <ItemTemplate>
                                                                                    <asp:Label runat="server" ID="OriginalMessage" Text='<%# Eval("OriginalMessage") %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                            </telerik:GridTemplateColumn>

                                                                            <telerik:GridButtonColumn UniqueName="deleteColumn4" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                                                                                      ConfirmDialogType="RadWindow"
                                                                                                      ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                                                                                <ItemStyle BackColor="Control" />
                                                                            </telerik:GridButtonColumn>
                                                                        </Columns>
                                                                    </MasterTableView>
                                                                </telerik:RadGrid>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="padding-right: 12px;">
                                        <asp:ValidationSummary ID="ValidationSummary5" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' ShowMessageBox="true"
                                                               ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp; </td>
                                    <td>&nbsp; </td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="2">
                                        <telerik:RadButton ID="btnSaveAssignedAreas" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionSave %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' CommandArgument="NoExit" Icon-PrimaryIconCssClass="rbSave">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="btnUpdateAssignedAreas" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblInsertAndClose : Resources.Resource.lblUpdateAndClose %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' Icon-PrimaryIconCssClass="rbOk">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="btnCancelAssignedAreas" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                           CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                        </telerik:RadButton>
                                    </td>
                                </tr>
                            </table>

                            <asp:SqlDataSource ID="SqlDataSource_AssignedAttributes" runat="server" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                                               SelectCommand="SELECT ac.SystemID, ac.BpID, ac.AttributeID, ab.NameVisible, ab.DescriptionShort, ac.CreatedFrom, ac.CreatedOn, ac.EditFrom, ac.EditOn, ac.CompanyID FROM Master_AttributesCompany AS ac INNER JOIN Master_AttributesBuildingProject AS ab ON ac.SystemID = ab.SystemID AND ac.BpID = ab.BpID AND ac.AttributeID = ab.AttributeID WHERE (ac.SystemID = @SystemID) AND (ac.BpID = @BpID) AND (ac.CompanyID = @CompanyID)">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="CompanyID" PropertyName="SelectedValue" DefaultValue="0" Name="CompanyID"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource ID="SqlDataSource_AccessLog2" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               OldValuesParameterFormatString="original_{0}" SelectCommandType="StoredProcedure"
                                               SelectCommand="GetAccessHistoryEmployee"
                                               DeleteCommand="DELETE FROM Data_AccessEvents WHERE (AccessEventID = @original_AccessEventID) AND (SystemID = @original_SystemID) AND (BpID = @original_BpID)">
                                <DeleteParameters>
                                    <asp:Parameter Name="original_AccessEventID"></asp:Parameter>
                                    <asp:Parameter Name="original_SystemID"></asp:Parameter>
                                    <asp:Parameter Name="original_BpID"></asp:Parameter>
                                </DeleteParameters>
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource ID="SqlDataSource_StatusID" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT Data_PassHistory.ActionID, Master_Passes.InternalID, Master_Passes.ExternalID, Data_PassHistory.Timestamp, Data_PassHistory.Reason, System_Actions.NameVisible, System_Actions.ResourceID FROM Data_PassHistory INNER JOIN Master_Passes ON Data_PassHistory.SystemID = Master_Passes.SystemID AND Data_PassHistory.BpID = Master_Passes.BpID AND Data_PassHistory.PassID = Master_Passes.PassID INNER JOIN System_Actions ON Data_PassHistory.SystemID = System_Actions.SystemID AND Data_PassHistory.ActionID = System_Actions.ActionID WHERE (Data_PassHistory.SystemID = @SystemID) AND (Data_PassHistory.BpID = @BpID) AND (Data_PassHistory.EmployeeID = @EmployeeID) ORDER BY Data_PassHistory.Timestamp DESC">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource ID="SqlDataSource_DenyReasons" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT AccessDenialReason AS Reason, CreatedOn AS TimeStamp FROM Data_AccessRightEvents WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (OwnerID = @EmployeeID) AND (PassType = 1) AND (AccessAllowed = 0) AND (IsNewest = 1) AND (HasSubstitute = 0)">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource ID="SqlDataSource_AssignedAccessAreas" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT DISTINCT m_aa.SystemID, m_aa.BpID, m_aa.AccessAreaID, m_aa.NameVisible, m_aa.DescriptionShort, m_aa.AccessTimeRelevant, m_aa.CheckInCompelling, m_aa.UniqueAccess, m_aa.CheckOutCompelling, m_aa.CompleteAccessTimes, m_aa.PresentTimeHours, m_aa.PresentTimeMinutes, m_aa.CreatedFrom, m_aa.CreatedOn, m_aa.EditFrom, m_aa.EditOn FROM Master_AccessAreas AS m_aa INNER JOIN Master_EmployeeAccessAreas AS m_eaa ON m_aa.SystemID = m_eaa.SystemID AND m_aa.BpID = m_eaa.BpID AND m_aa.AccessAreaID = m_eaa.AccessAreaID INNER JOIN Master_TimeSlots AS m_ts ON m_eaa.SystemID = m_ts.SystemID AND m_eaa.BpID = m_ts.BpID AND m_eaa.TimeSlotGroupID = m_ts.TimeSlotGroupID WHERE (m_aa.SystemID = @SystemID) AND (m_aa.BpID = @BpID) AND (DATETIMEFROMPARTS(YEAR(m_ts.ValidFrom), MONTH(m_ts.ValidFrom), DAY(m_ts.ValidFrom), DATEPART(hh, m_ts.TimeFrom), DATEPART(n, m_ts.TimeFrom), DATEPART(s, m_ts.TimeFrom), 0) <= @AccessTime) AND (DATETIMEFROMPARTS(YEAR(m_ts.ValidUntil), MONTH(m_ts.ValidUntil), DAY(m_ts.ValidUntil), DATEPART(hh, m_ts.TimeUntil), DATEPART(n, m_ts.TimeUntil), DATEPART(s, m_ts.TimeUntil), 0) >= @AccessTime) AND (m_eaa.EmployeeID = @EmployeeID)">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                    <asp:Parameter Name="AccessTime"></asp:Parameter>
                                    <asp:Parameter Name="EmployeeID"></asp:Parameter>
                                </SelectParameters>
                            </asp:SqlDataSource>

                        </telerik:RadPageView>

                        <%-- Other criterias --%>
                        <telerik:RadPageView ID="RadPageView7" runat="server">
                            <table id="Table9" cellspacing="2" cellpadding="2" border="0" rules="none" class="EditFormTable">
                                <tr>
                                    <td style="vertical-align: top;">
                                        <table id="Table10" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ", ", Resources.Resource.lblAddrFirstName, ":") %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Eval("LastName"), ", ", Eval("FirstName")) %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ", ", Resources.Resource.lblAddrEmail, ":") %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Eval("Phone"), ", ", Eval("Email")) %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" Text='<%# String.Concat(Eval("NameVisible"), ", ", Eval("NameAdditional")) %>'
                                                               Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp; </td>
                                                <td>&nbsp; </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelUserString1" Text='<%# String.Concat(Resources.Resource.lblUserDefinedString, " 1:") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadTextBox runat="server" ID="UserString1" Text='<%# Bind("UserString1") %>' Width="300px"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelUserString2" Text='<%# String.Concat(Resources.Resource.lblUserDefinedString, " 2:") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadTextBox runat="server" ID="UserString2" Text='<%# Bind("UserString2") %>' Width="300px"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelUserString3" Text='<%# String.Concat(Resources.Resource.lblUserDefinedString, " 3:") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadTextBox runat="server" ID="UserString3" Text='<%# Bind("UserString3") %>' Width="300px"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelUserString4" Text='<%# String.Concat(Resources.Resource.lblUserDefinedString, " 4:") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <telerik:RadTextBox runat="server" ID="UserString4" Text='<%# Bind("UserString4") %>' Width="300px"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelUserBit1" Text='<%# String.Concat(Resources.Resource.lblUserDefinedBit, " 1:") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:CheckBox runat="server" CssClass="cb" ID="UserBit1" Checked='<%# Bind("UserBit1") %>'></asp:CheckBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelUserBit2" Text='<%# String.Concat(Resources.Resource.lblUserDefinedBit, " 2:") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:CheckBox runat="server" CssClass="cb" ID="UserBit2" Checked='<%# Bind("UserBit2") %>'></asp:CheckBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelUserBit3" Text='<%# String.Concat(Resources.Resource.lblUserDefinedBit, " 3:") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:CheckBox runat="server" CssClass="cb" ID="UserBit3" Checked='<%# Bind("UserBit3") %>'></asp:CheckBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="LabelUserBit4" Text='<%# String.Concat(Resources.Resource.lblUserDefinedBit, " 4:") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:CheckBox runat="server" CssClass="cb" ID="UserBit4" Checked='<%# Bind("UserBit4") %>'></asp:CheckBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" style="padding-right: 12px;">
                                                    <asp:ValidationSummary ID="ValidationSummary6" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' ShowMessageBox="true"
                                                                           ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp; </td>
                                                <td>&nbsp; </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="2">
                                        <telerik:RadButton ID="RadButton5" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionSave %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' CommandArgument="NoExit" Icon-PrimaryIconCssClass="rbSave">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="RadButton6" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblInsertAndClose : Resources.Resource.lblUpdateAndClose %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' Icon-PrimaryIconCssClass="rbOk">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="RadButton33" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                           CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                        </telerik:RadButton>
                                    </td>
                                </tr>
                            </table>

                        </telerik:RadPageView>

                    </telerik:RadMultiPage>
                </FormTemplate>
            </EditFormSettings>

            <%--#################################################################################### View Template ########################################################################################################--%>
            <NestedViewTemplate>
                <asp:Panel runat="server" ID="PanelDetails" Visible="false">
                    <telerik:RadTabStrip ID="RadTabStrip1" runat="server" MultiPageID="RadMultiPage1" Align="Left" AutoPostBack="false" CausesValidation="false">
                        <Tabs>
                            <telerik:RadTab PageViewID="RadPageView1" ImageUrl="~/Resources/Icons/factory.png" Text="<%# Resources.Resource.lblGenerally %>" Selected="true" Font-Bold="true" Value="1" />
                            <telerik:RadTab PageViewID="RadPageView2" ImageUrl="~/Resources/Icons/list-add-5.png" Text="<%# Resources.Resource.lblAdvanced %>" Font-Bold="true" Value="2" />
                            <telerik:RadTab PageViewID="RadPageView3" ImageUrl="~/Resources/Icons/info.png" Text="<%# Resources.Resource.lblInfo %>" Font-Bold="true" Value="3" />
                            <telerik:RadTab PageViewID="RadPageView4" ImageUrl="~/Resources/Icons/Money.png" Text="<%# Resources.Resource.lblMinimumWage %>" Font-Bold="true" Value="4" />
                            <telerik:RadTab PageViewID="RadPageView5" ImageUrl="~/Resources/Icons/emblem-paragraph.png" Text="<%# Resources.Resource.lblDocumentsRules %>" Font-Bold="true" Value="5" />
                            <telerik:RadTab PageViewID="RadPageView6" ImageUrl="~/Resources/Icons/Access.png" Text="<%# Resources.Resource.lblAccessControl %>" Font-Bold="true" Value="6" />
                            <telerik:RadTab PageViewID="RadPageView7" ImageUrl="~/Resources/Icons/criteria.png" Text="<%# Resources.Resource.lblOtherCriterias %>" Font-Bold="true" Value="7" />
                        </Tabs>
                    </telerik:RadTabStrip>

                    <telerik:RadMultiPage ID="RadMultiPage1" runat="server" RenderSelectedPageOnly="false">

                        <%-- Generally --%>
                        <telerik:RadPageView ID="RadPageView1" runat="server" Selected="true">
                            <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                                <table id="Table1" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                                    <tr>
                                        <td style="vertical-align: top;">
                                            <table id="Table2" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="Label1" Text='<%# String.Concat(Resources.Resource.lblID, ":") %>'
                                                                   >
                                                        </asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="EmployeeID" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).EmployeeID %>'
                                                                   >
                                                        </asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelCompanyName" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:HiddenField ID="CompanyID" runat="server" Value='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).CompanyID %>'></asp:HiddenField>
                                                        <asp:Label runat="server" ID="CompanyName" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameVisible %>' Width="300px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelSalutation" Text='<%# String.Concat(Resources.Resource.lblAddrSalutation, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:HiddenField ID="AddressID" runat="server" Value='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).AddressID %>'></asp:HiddenField>
                                                        <asp:Label runat="server" ID="Salutation" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Salutation %>' Width="300px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelLastName" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="LastName" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LastName %>' Width="300px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelFirstName" Text='<%# String.Concat(Resources.Resource.lblAddrFirstName, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="FirstName" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).FirstName %>' Width="300px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelAddress1" Text='<%# String.Concat(Resources.Resource.lblAddress1, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="Address1" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Address1 %>' Width="300px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelAddress2" Text='<%# String.Concat(Resources.Resource.lblAddress2, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="Address2" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Address2 %>' Width="300px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelZip" Text='<%# String.Concat(Resources.Resource.lblAddrZip, ", ", Resources.Resource.lblAddrCity, ":") %>'>
                                                        </asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="Zip" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Zip %>' Width="60px"></asp:Label>
                                                        <asp:Label runat="server" ID="City" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).City %>' Width="224px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelState" Text='<%# String.Concat(Resources.Resource.lblAddrState, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="State" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).State %>' Width="300px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelCountryName" Text='<%# String.Concat(Resources.Resource.lblCountry, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="CountryName" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).CountryID %>' Width="300px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelPhone" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="Phone" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Phone %>' Width="300px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelEmail" Text='<%# String.Concat(Resources.Resource.lblAddrEmail, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="Email" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Email %>' Width="300px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelBirthDate" Text='<%# String.Concat(Resources.Resource.lblAddrBirthDate, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="BirthDate" Text='<%# Eval("BirthDate", "{0:d}") %>'></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelNationalityID" Text='<%# String.Concat(Resources.Resource.lblNationality, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="NationalityName" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NationalityName %>'></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelLanguageID" Text='<%# String.Concat(Resources.Resource.lblLanguage, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="LanguageID" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LanguageID %>'></asp:Label>
                                                    </td>
                                                </tr>

                                            </table>
                                        </td>
                                        <td style="vertical-align: top;">
                                            <asp:Panel runat="server" ID="PanelPhoto">
                                                <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin-top: 6px; margin-left: 10px; width: 300px;">
                                                    <table id="Table3" cellspacing="2" cellpadding="2" border="0">
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="LabelPhotoData" Text='<%# String.Concat(Resources.Resource.lblPhoto, ":") %>'></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>&nbsp; </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <telerik:RadBinaryImage runat="server" ID="PhotoData"
                                                                                        DataValue='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).ThumbnailData %>'
                                                                                        AutoAdjustImageControlSize="false" Height="45px" ToolTip='<%#Eval("LastName", Resources.Resource.lblImageFor) %>'
                                                                                        AlternateText='<%#Eval("LastName", Resources.Resource.lblImageFor) %>'>
                                                                </telerik:RadBinaryImage>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="PhotoFileName" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).PhotoFileName %>'></asp:Label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </telerik:RadPageView>

                        <%-- Advanced --%>
                        <telerik:RadPageView ID="RadPageView2" runat="server">
                            <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                                <table id="Table4" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                                    <tr>
                                        <td style="vertical-align: top;">
                                            <table id="Table5" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ", ", Resources.Resource.lblAddrFirstName, ":") %>'
                                                                   ></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LastName, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).FirstName) %>'
                                                                   ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ", ", Resources.Resource.lblAddrEmail, ":") %>'
                                                                   ></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Phone, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Email) %>'
                                                                   ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'
                                                                   ></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameVisible, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameAdditional) %>'
                                                                   ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelTradeID" Text='<%# String.Concat(Resources.Resource.lblTrade, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <telerik:RadComboBox runat="server" ID="TradeID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                                                             DataValueField="TradeID" DataTextField="NameVisible" Width="300"
                                                                             Filter="Contains" AppendDataBoundItems="true" EnableLoadOnDemand="true" DropDownAutoWidth="Enabled" Enabled="false">
                                                            <ItemTemplate>
                                                                <table cellpadding="5px" style="text-align: left;">
                                                                    <tr>
                                                                        <td style="text-align: left;">
                                                                            <asp:Label ID="ItemID" Text='<%# Eval("TradeNumber") %>' runat="server">
                                                                            </asp:Label>
                                                                        </td>
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
                                                            <Items>
                                                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0" />
                                                            </Items>
                                                        </telerik:RadComboBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelStaffFunction" Text='<%# String.Concat(Resources.Resource.lblFunction, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="StaffFunction" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).StaffFunction %>' Width="300px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelEmploymentStatusID" Text='<%# String.Concat(Resources.Resource.lblEmploymentStatus, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <telerik:RadComboBox runat="server" ID="EmploymentStatusID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataSourceID="SqlDataSource_EmploymentStatus" AppendDataBoundItems="true"
                                                                             DataValueField="EmploymentStatusID" DataTextField="NameVisible" Width="300" Filter="Contains"
                                                                             SelectedValue='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).EmploymentStatusID %>' DropDownAutoWidth="Enabled" Enabled="false">
                                                            <Items>
                                                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0" />
                                                            </Items>
                                                        </telerik:RadComboBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelDescription" Text='<%# String.Concat(Resources.Resource.lblRemarks, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="Description" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Description %>' Width="300px" TextMode="MultiLine" Rows="3" Wrap="true"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp; </td>
                                                    <td>&nbsp; </td>
                                                </tr>

                                                <tr>
                                                    <td colspan="2">
                                                        <telerik:RadAjaxPanel runat="server" ID="QualificationPanel">
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label runat="server" ID="LabelAvailableQualifications" Text='<%# String.Concat(Resources.Resource.lblAvailableQualifications, ":") %>'></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <telerik:RadListBox ID="AssignedQualifications" runat="server" DataSourceID="SqlDataSource_EmployeeQualification1" DataValueField="StaffRoleID"
                                                                                            DataKeyField="StaffRoleID" DataTextField="NameVisible" Width="211px" Height="150px" SelectionMode="Multiple"
                                                                                            Enabled="false">
                                                                        </telerik:RadListBox>

                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </telerik:RadAjaxPanel>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>

                            <asp:SqlDataSource ID="SqlDataSource_StaffRoles1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT * FROM Master_StaffRoles sr WHERE sr.SystemID = @SystemID AND sr.BpID = @BpID AND NOT EXISTS (SELECT 1 FROM Master_EmployeeQualification eq WHERE eq.SystemID = @SystemID AND eq.BpID = @BpID AND eq.EmployeeID = @EmployeeID AND eq.StaffRoleID = sr.StaffRoleID)">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource ID="SqlDataSource_EmployeeQualification1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT Master_EmployeeQualification.StaffRoleID, Master_StaffRoles.NameVisible, Master_StaffRoles.DescriptionShort FROM Master_EmployeeQualification INNER JOIN Master_StaffRoles ON Master_EmployeeQualification.SystemID = Master_StaffRoles.SystemID AND Master_EmployeeQualification.BpID = Master_StaffRoles.BpID AND Master_EmployeeQualification.StaffRoleID = Master_StaffRoles.StaffRoleID WHERE (Master_EmployeeQualification.SystemID = @SystemID) AND (Master_EmployeeQualification.BpID = @BpID) AND (Master_EmployeeQualification.EmployeeID = @EmployeeID)">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </telerik:RadPageView>

                        <%-- Info --%>
                        <telerik:RadPageView ID="RadPageView3" runat="server">
                            <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                                <table id="Table7" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                                    <tr>
                                        <td style="vertical-align: top;">
                                            <table id="Table8" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ", ", Resources.Resource.lblAddrFirstName, ":") %>'
                                                                   ></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LastName, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).FirstName) %>'
                                                                   ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ", ", Resources.Resource.lblAddrEmail, ":") %>'
                                                                   ></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Phone, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Email) %>'
                                                                   ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'
                                                                   ></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameVisible, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameAdditional) %>'
                                                                   ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp; </td>
                                                    <td>&nbsp; </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="LabelReleaseCFrom" Text='<%# String.Concat(Resources.Resource.lblReleaseC, " ", Resources.Resource.lblFrom, ":") %>' runat="server">
                                                        </asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="ReleaseCFrom" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).ReleaseCFrom %>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="LabelReleaseCOn" Text='<%# String.Concat(Resources.Resource.lblReleaseC, " ", Resources.Resource.lblOn, ":") %>' runat="server">
                                                        </asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="ReleaseCOn" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).ReleaseCOn %>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="LabelReleaseBFrom" Text='<%# String.Concat(Resources.Resource.lblReleaseB, " ", Resources.Resource.lblFrom, ":") %>' runat="server">
                                                        </asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="ReleaseBFrom" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).ReleaseBFrom %>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="LabelReleaseBOn" Text='<%# String.Concat(Resources.Resource.lblReleaseB, " ", Resources.Resource.lblOn, ":") %>' runat="server">
                                                        </asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="ReleaseBOn" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).ReleaseBOn %>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="LabelLockedFrom" Text='<%# String.Concat(Resources.Resource.lblLockedFrom, ":") %>' runat="server">
                                                        </asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="LockedFrom" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LockedFrom %>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="LabelLockedOn" Text='<%# String.Concat(Resources.Resource.lblLockedOn, ":") %>' runat="server"></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="LockedOn" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LockedOn %>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp;</td>
                                                    <td>&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server"  Text='<%# String.Concat(Resources.Resource.lblCreatedFrom, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server"  Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).CreatedFrom %>'></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server"  Text='<%# String.Concat(Resources.Resource.lblCreatedOn, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server"  Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).CreatedOn %>'></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server"  Text='<%# String.Concat(Resources.Resource.lblEditFrom, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server"  Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).EditFrom %>'></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server"  Text='<%# String.Concat(Resources.Resource.lblEditOn, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server"  Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).EditOn %>'></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>

                        </telerik:RadPageView>

                        <%-- Minimum wage --%>
                        <telerik:RadPageView ID="RadPageView4" runat="server">
                            <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                                <table id="Table11" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                                    <tr>
                                        <td style="vertical-align: top;">
                                            <table id="Table12" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                                <tr>
                                                    <td>
                                                        <asp:HiddenField ID="CompanyID1" runat="server" Value='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).CompanyID %>'></asp:HiddenField>
                                                        <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ", ", Resources.Resource.lblAddrFirstName, ":") %>'
                                                                   ></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LastName, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).FirstName) %>'
                                                                   ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ", ", Resources.Resource.lblAddrEmail, ":") %>'
                                                                   ></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Phone, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Email) %>'
                                                                   ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'
                                                                   ></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameVisible, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameAdditional) %>'
                                                                   ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp; </td>
                                                    <td>&nbsp; </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="LabelRadGridMinWage1" Text='<%# String.Concat(Resources.Resource.lblEmplMinWage1, ":") %>' runat="server"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <telerik:RadGrid runat="server" ID="RadGridMinWage1" DataSourceID="SqlDataSource_CompanyTariffs1" Enabled="false">
                                                                        <MasterTableView DataSourceID="SqlDataSource_CompanyTariffs1" AutoGenerateColumns="false" AllowPaging="true" PageSize="5">
                                                                            <Columns>
                                                                                <telerik:GridBoundColumn DataField="ValidFrom" HeaderText="<%$ Resources:Resource, lblValidFrom %>" DataFormatString="{0:d}">
                                                                                </telerik:GridBoundColumn>
                                                                                <telerik:GridBoundColumn DataField="TariffName" HeaderText="<%$ Resources:Resource, lblTariff %>"></telerik:GridBoundColumn>
                                                                                <telerik:GridBoundColumn DataField="ScopeName" HeaderText="<%$ Resources:Resource, lblTariffScope %>"></telerik:GridBoundColumn>
                                                                            </Columns>
                                                                        </MasterTableView>
                                                                    </telerik:RadGrid>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>&nbsp; </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="LabelRadGridMinWage2" Text='<%# String.Concat(Resources.Resource.lblEmplMinWage2, ":") %>' runat="server"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <telerik:RadGrid runat="server" ID="RadGridMinWage2" DataSourceID="SqlDataSource_WageGroupAssignment1" ValidateRequestMode="Disabled" Enabled="false">
                                                                        <MasterTableView DataSourceID="SqlDataSource_WageGroupAssignment1" AutoGenerateColumns="false" AllowPaging="true" PageSize="5"
                                                                                         AllowAutomaticDeletes="false" AllowAutomaticInserts="false" CommandItemDisplay="None">

                                                                            <Columns>

                                                                                <telerik:GridTemplateColumn DataField="ValidFrom" FilterControlAltText="Filter ValidFrom column"
                                                                                                            HeaderText="<%$ Resources:Resource, lblValidFrom %>" SortExpression="ValidFrom" UniqueName="ValidFrom" Visible="true">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label ID="ValidFrom" runat="server" Text='<%# Eval("ValidFrom", "{0:d}") %>'></asp:Label>
                                                                                    </ItemTemplate>
                                                                                </telerik:GridTemplateColumn>

                                                                                <telerik:GridDropDownColumn DataField="TariffWageGroupID" DataSourceID="SqlDataSource_TariffWageGroups1"
                                                                                                            HeaderText="<%$ Resources:Resource, lblTariffWageGroup %>" ListTextField="NameVisible"
                                                                                                            ListValueField="TariffWageGroupID" UniqueName="TariffWageGroupID" DropDownControlType="RadComboBox"
                                                                                                            CurrentFilterFunction="Contains" AllowFiltering="true">
                                                                                    <ItemStyle Width="300px" />
                                                                                </telerik:GridDropDownColumn>

                                                                                <telerik:GridTemplateColumn DataField="CreatedFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedFrom column"
                                                                                                            HeaderText="<%$ Resources:Resource, lblCreatedFrom %>" SortExpression="CreatedFrom" UniqueName="CreatedFrom" Visible="False">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label ID="CreatedFromLabel" runat="server" Text='<%# ((System.Data.DataRowView)Container.DataItem)["CreatedFrom"] %>'></asp:Label>
                                                                                    </ItemTemplate>
                                                                                </telerik:GridTemplateColumn>

                                                                                <telerik:GridTemplateColumn DataField="CreatedOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedOn column"
                                                                                                            HeaderText="<%$ Resources:Resource, lblCreatedOn %>" SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="False">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label ID="CreatedOnLabel" runat="server" Text='<%# ((System.Data.DataRowView)Container.DataItem)["CreatedOn"] %>'></asp:Label>
                                                                                    </ItemTemplate>
                                                                                </telerik:GridTemplateColumn>

                                                                                <telerik:GridTemplateColumn DataField="EditFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditFrom column"
                                                                                                            HeaderText="<%$ Resources:Resource, lblEditFrom %>" SortExpression="EditFrom" UniqueName="EditFrom" Visible="False">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label ID="EditFromLabel" runat="server" Text='<%# ((System.Data.DataRowView)Container.DataItem)["EditFrom"] %>'></asp:Label>
                                                                                    </ItemTemplate>
                                                                                </telerik:GridTemplateColumn>

                                                                                <telerik:GridTemplateColumn DataField="EditOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditOn column"
                                                                                                            HeaderText="<%$ Resources:Resource, lblEditOn %>" SortExpression="EditOn" UniqueName="EditOn" Visible="False">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label ID="EditOnLabel" runat="server" Text='<%# ((System.Data.DataRowView)Container.DataItem)["EditOn"] %>'></asp:Label>
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
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>&nbsp; </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="LabelRadGridMinWage3" Text='<%# String.Concat(Resources.Resource.lblEmplMinWage3, ":") %>' runat="server"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <telerik:RadGrid runat="server" ID="RadGridMinWage3" DataSourceID="SqlDataSource_TariffHistorie1" Enabled="false">
                                                                        <MasterTableView DataSourceID="SqlDataSource_TariffHistorie1" AutoGenerateColumns="false" AllowPaging="true" PageSize="5">
                                                                            <Columns>
                                                                                <telerik:GridBoundColumn DataField="ValidFrom" HeaderText="<%$ Resources:Resource, lblValidFrom %>" DataFormatString="{0:d}">
                                                                                </telerik:GridBoundColumn>
                                                                                <telerik:GridBoundColumn DataField="TariffName" HeaderText="<%$ Resources:Resource, lblTariff %>"></telerik:GridBoundColumn>
                                                                                <telerik:GridBoundColumn DataField="ScopeName" HeaderText="<%$ Resources:Resource, lblTariffScope %>"></telerik:GridBoundColumn>
                                                                                <telerik:GridBoundColumn DataField="WageGroupName" HeaderText="<%$ Resources:Resource, lblTariffWageGroup %>"></telerik:GridBoundColumn>
                                                                                <telerik:GridBoundColumn DataField="MinWage" HeaderText="<%$ Resources:Resource, lblTariffWage %>"></telerik:GridBoundColumn>
                                                                            </Columns>
                                                                        </MasterTableView>
                                                                    </telerik:RadGrid>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>&nbsp; </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="LabelRadGridMinWage4" Text='<%# String.Concat(Resources.Resource.lblEmplMinWage4, ":") %>' runat="server"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <telerik:RadGrid runat="server" ID="RadGridMinWage4" DataSourceID="SqlDataSource_MinWageAttestation1" Enabled="false">
                                                                        <MasterTableView DataSourceID="SqlDataSource_MinWageAttestation1" AutoGenerateColumns="false" AllowPaging="true" PageSize="5"
                                                                                         AllowAutomaticUpdates="true">

                                                                            <Columns>
                                                                                <telerik:GridBoundColumn DataField="ForMonth" HeaderText="<%$ Resources:Resource, lblForMonth %>" DataType="System.DateTime"
                                                                                                         FilterControlAltText="Filter ForMonth column" SortExpression="ForMonth" UniqueName="ForMonth">
                                                                                </telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="Amount" HeaderText="<%$ Resources:Resource, lblTariffWage %>" DataType="System.Decimal"
                                                                                                         FilterControlAltText="Filter Amount column" SortExpression="Amount" UniqueName="Amount">
                                                                                </telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="WageGroupName" HeaderText="<%$ Resources:Resource, lblTariffWageGroup %>" DataType="System.Int32"
                                                                                                         FilterControlAltText="Filter WageGroupID column" SortExpression="WageGroupName" UniqueName="WageGroupName">
                                                                                </telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="Status" HeaderText="<%$ Resources:Resource, lblStatus %>" SortExpression="Status" UniqueName="Status"
                                                                                                         DataType="System.Int32" FilterControlAltText="Filter Status column">
                                                                                </telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="ReceivedBy" HeaderText="<%$ Resources:Resource, lblReceivedFrom %>" SortExpression="ReceivedBy"
                                                                                                         UniqueName="ReceivedBy" FilterControlAltText="Filter ReceivedBy column">
                                                                                </telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="ReceivedOn" HeaderText="<%$ Resources:Resource, lblReceivedOn %>" SortExpression="ReceivedOn"
                                                                                                         UniqueName="ReceivedOn" DataType="System.DateTime" FilterControlAltText="Filter ReceivedOn column">
                                                                                </telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="RequestBy" HeaderText="<%$ Resources:Resource, lblRequestFrom %>" SortExpression="RequestBy"
                                                                                                         UniqueName="RequestBy" FilterControlAltText="Filter RequestBy column">
                                                                                </telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="RequestOn" HeaderText="<%$ Resources:Resource, lblRequestOn %>" SortExpression="RequestOn"
                                                                                                         UniqueName="RequestOn" DataType="System.DateTime" FilterControlAltText="Filter RequestOn column">
                                                                                </telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="DocumentID" HeaderText="<%$ Resources:Resource, lblDocumentID %>" SortExpression="DocumentID"
                                                                                                         UniqueName="DocumentID" FilterControlAltText="Filter DocumentID column">
                                                                                </telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="CreatedFrom" HeaderText="CreatedFrom" SortExpression="CreatedFrom" UniqueName="CreatedFrom"
                                                                                                         FilterControlAltText="Filter CreatedFrom column" Visible="false" InsertVisiblityMode="AlwaysHidden">
                                                                                </telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="CreatedOn" HeaderText="CreatedOn" SortExpression="CreatedOn" UniqueName="CreatedOn" DataType="System.DateTime"
                                                                                                         FilterControlAltText="Filter CreatedOn column" Visible="false" InsertVisiblityMode="AlwaysHidden">
                                                                                </telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="EditFrom" HeaderText="EditFrom" SortExpression="EditFrom" UniqueName="EditFrom"
                                                                                                         FilterControlAltText="Filter EditFrom column" Visible="false" InsertVisiblityMode="AlwaysHidden">
                                                                                </telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="EditOn" HeaderText="EditOn" SortExpression="EditOn" UniqueName="EditOn" DataType="System.DateTime"
                                                                                                         FilterControlAltText="Filter EditOn column" Visible="false" InsertVisiblityMode="AlwaysHidden">
                                                                                </telerik:GridBoundColumn>
                                                                            </Columns>
                                                                        </MasterTableView>
                                                                    </telerik:RadGrid>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>

                            <asp:SqlDataSource ID="SqlDataSource_CompanyTariffs1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT System_Tariffs.TariffID, System_TariffScopes.TariffContractID, Master_CompanyTariffs.TariffScopeID, Master_CompanyTariffs.ValidFrom, System_Tariffs.NameVisible AS TariffName, System_TariffScopes.NameVisible AS ScopeName FROM Master_CompanyTariffs INNER JOIN System_TariffScopes ON Master_CompanyTariffs.SystemID = System_TariffScopes.SystemID AND Master_CompanyTariffs.TariffScopeID = System_TariffScopes.TariffScopeID INNER JOIN System_Tariffs ON System_TariffScopes.SystemID = System_Tariffs.SystemID AND System_TariffScopes.TariffID = System_Tariffs.TariffID WHERE (Master_CompanyTariffs.SystemID = @SystemID) AND (Master_CompanyTariffs.BpID = @BpID) AND (Master_CompanyTariffs.CompanyID = @CompanyID)">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="CompanyID1" PropertyName="Value" DefaultValue="0" Name="CompanyID" Type="Int32"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource ID="SqlDataSource_WageGroupAssignment1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT ewga.SystemID, ewga.BpID, ewga.EmployeeID, ewga.TariffWageGroupID, twg.NameVisible, ewga.ValidFrom, ewga.CreatedFrom, ewga.CreatedOn, ewga.EditFrom, ewga.EditOn FROM Master_EmployeeWageGroupAssignment AS ewga INNER JOIN System_TariffWageGroups AS twg ON ewga.SystemID = twg.SystemID AND ewga.TariffWageGroupID = twg.TariffWageGroupID WHERE (ewga.SystemID = @SystemID) AND (ewga.BpID = @BpID) AND (ewga.EmployeeID = @EmployeeID)">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID" Type="Int32"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource ID="SqlDataSource_TariffWageGroups1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT twg.TariffWageGroupID, twg.NameVisible, twg.DescriptionShort FROM System_TariffWageGroups AS twg INNER JOIN Master_CompanyTariffs AS ct ON twg.SystemID = ct.SystemID AND twg.TariffScopeID = ct.TariffScopeID WHERE (ct.SystemID = @SystemID) AND (ct.BpID = @BpID) AND (ct.CompanyID = @CompanyID) ORDER BY twg.NameVisible">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="CompanyID1" PropertyName="Value" DefaultValue="0" Name="CompanyID" Type="Int32"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource ID="SqlDataSource_TariffHistorie1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT System_Tariffs.TariffID, System_TariffScopes.TariffContractID, Master_CompanyTariffs.TariffScopeID, Master_CompanyTariffs.ValidFrom, System_Tariffs.NameVisible AS TariffName, System_TariffScopes.NameVisible AS ScopeName, MIN(System_TariffWages.Wage), System_TariffWageGroups.NameVisible AS WageGroupName FROM Master_CompanyTariffs INNER JOIN System_TariffScopes ON Master_CompanyTariffs.SystemID = System_TariffScopes.SystemID AND Master_CompanyTariffs.TariffScopeID = System_TariffScopes.TariffScopeID INNER JOIN System_Tariffs ON System_TariffScopes.SystemID = System_Tariffs.SystemID AND System_TariffScopes.TariffID = System_Tariffs.TariffID INNER JOIN System_TariffWageGroups ON System_TariffScopes.SystemID = System_TariffWageGroups.SystemID AND System_TariffScopes.TariffID = System_TariffWageGroups.TariffID AND System_TariffScopes.TariffContractID = System_TariffWageGroups.TariffContractID AND System_TariffScopes.TariffScopeID = System_TariffWageGroups.TariffScopeID INNER JOIN System_TariffWages ON System_TariffWageGroups.SystemID = System_TariffWages.SystemID AND System_TariffWageGroups.TariffID = System_TariffWages.TariffID AND System_TariffWageGroups.TariffContractID = System_TariffWages.TariffContractID AND System_TariffWageGroups.TariffScopeID = System_TariffWages.TariffScopeID AND System_TariffWageGroups.TariffWageGroupID = System_TariffWages.TariffWageGroupID WHERE (Master_CompanyTariffs.SystemID = @SystemID) AND (Master_CompanyTariffs.BpID = @BpID) AND (Master_CompanyTariffs.CompanyID = @CompanyID) GROUP BY System_Tariffs.TariffID, System_TariffScopes.TariffContractID, Master_CompanyTariffs.TariffScopeID, Master_CompanyTariffs.ValidFrom, System_Tariffs.NameVisible, System_TariffScopes.NameVisible, System_TariffWageGroups.NameVisible">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="CompanyID1" PropertyName="Value" DefaultValue="0" Name="CompanyID" Type="Int32"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource ID="SqlDataSource_MinWageAttestation1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT Master_EmployeeMinWageAttestation.ForMonth, Master_EmployeeMinWageAttestation.Amount, Master_EmployeeMinWageAttestation.WageGroupID, Master_EmployeeMinWageAttestation.Status, Master_EmployeeMinWageAttestation.ReceivedBy, Master_EmployeeMinWageAttestation.ReceivedOn, Master_EmployeeMinWageAttestation.RequestBy, Master_EmployeeMinWageAttestation.RequestOn, Master_EmployeeMinWageAttestation.DocumentID, Master_EmployeeMinWageAttestation.CreatedFrom, Master_EmployeeMinWageAttestation.CreatedOn, Master_EmployeeMinWageAttestation.EditFrom, Master_EmployeeMinWageAttestation.EditOn, System_TariffWageGroups.NameVisible AS WageGroupName FROM Master_EmployeeMinWageAttestation INNER JOIN System_TariffWageGroups ON Master_EmployeeMinWageAttestation.SystemID = System_TariffWageGroups.SystemID AND Master_EmployeeMinWageAttestation.WageGroupID = System_TariffWageGroups.TariffWageGroupID WHERE (Master_EmployeeMinWageAttestation.SystemID = @SystemID) AND (Master_EmployeeMinWageAttestation.BpID = @BpID) AND (Master_EmployeeMinWageAttestation.EmployeeID = @EmployeeID)" UpdateCommand="UPDATE Master_EmployeeMinWageAttestation SET ForMonth = @ForMonth, Amount = @Amount, WageGroupID = @WageGroupID, Status = @Status, ReceivedBy = @ReceivedBy, ReceivedOn = @ReceivedOn, RequestBy = @RequestBy, RequestOn = @RequestOn, DocumentID = @DocumentID, CreatedFrom = @UserName, CreatedOn = SYSDATETIME(), EditFrom = @UserName, EditOn = SYSDATETIME() WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (EmployeeID = @EmployeeID)">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>

                        </telerik:RadPageView>

                        <%-- Document rules --%>
                        <telerik:RadPageView ID="RadPageView5" runat="server">
                            <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                                <table id="Table13" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                                    <tr>
                                        <td style="vertical-align: top;">
                                            <table id="Table14" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ", ", Resources.Resource.lblAddrFirstName, ":") %>'
                                                                   ></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LastName, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).FirstName) %>'
                                                                   ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ", ", Resources.Resource.lblAddrEmail, ":") %>'
                                                                   ></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Phone, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Email) %>'
                                                                   ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'
                                                                   ></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameVisible, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameAdditional) %>'
                                                                   ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp; </td>
                                                    <td>&nbsp; </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelMaxHrsPerMonth" Text='<%# String.Concat(Resources.Resource.lblMaxHrsPerMonth, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="MaxHrsPerMonth" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).MaxHrsPerMonth %>'></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelAppliedRule" Text='<%# String.Concat(Resources.Resource.lblAppliedRule, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="AppliedRule"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="LabelRadGridDocumentRules" Text='<%# String.Concat(Resources.Resource.lblDocumentRules, ":") %>' runat="server"></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <telerik:RadGrid runat="server" ID="RadGridDocumentRules" DataSourceID="SqlDataSource_DocumentRules1" Enabled="false"
                                                                                     AllowAutomaticUpdates="false">
                                                                        <MasterTableView DataSourceID="SqlDataSource_DocumentRules1" AutoGenerateColumns="false" AllowPaging="true" PageSize="5">

                                                                            <Columns>
                                                                                <telerik:GridTemplateColumn DataField="RelevantFor" DataType="System.Int16"
                                                                                                            HeaderText="<%$ Resources:Resource, lblRelevantFor %>" SortExpression="RelevantFor" UniqueName="RelevantFor">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label runat="server" ID="RelevantFor" Text='<%# GetRelevantFor(Convert.ToInt16(((System.Data.DataRowView)Container.DataItem)["RelevantFor"])) %>'></asp:Label>
                                                                                    </ItemTemplate>
                                                                                </telerik:GridTemplateColumn>

                                                                                <telerik:GridTemplateColumn DataField="RelevantDocumentID" DataType="System.Int32"
                                                                                                            HeaderText="<%$ Resources:Resource, lblDocument %>" SortExpression="RelevantDocumentID" UniqueName="RelevantDocumentID">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label runat="server" ID="RelevantDocumentID1" Text='<%# ((System.Data.DataRowView)Container.DataItem)["NameVisible"] %>'></asp:Label>
                                                                                    </ItemTemplate>
                                                                                </telerik:GridTemplateColumn>

                                                                                <telerik:GridCheckBoxColumn DataField="IsAccessRelevant" HeaderText="<%$ Resources:Resource, lblAccessRelevant %>" SortExpression="IsAccessRelevant" UniqueName="IsAccessRelevant" DataType="System.Boolean" FilterControlAltText="Filter IsAccessRelevant column"></telerik:GridCheckBoxColumn>

                                                                                <telerik:GridCheckBoxColumn DataField="DocumentReceived" HeaderText="<%$ Resources:Resource, lblIsPresent %>" SortExpression="DocumentReceived" UniqueName="DocumentReceived" DataType="System.Boolean" FilterControlAltText="Filter DocumentReceived column"></telerik:GridCheckBoxColumn>

                                                                                <telerik:GridTemplateColumn DataField="ExpirationDate" DataType="System.DateTime" FilterControlAltText="Filter ExpirationDate column"
                                                                                                            HeaderText="<%$ Resources:Resource, lblExpirationDate %>" SortExpression="ExpirationDate" UniqueName="ExpirationDate">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label runat="server" ID="ExpirationDate" Text='<%# ((System.Data.DataRowView)Container.DataItem)["ExpirationDate"] %>'></asp:Label>
                                                                                    </ItemTemplate>
                                                                                </telerik:GridTemplateColumn>

                                                                                <telerik:GridTemplateColumn DataField="IDNumber" DataType="System.String" FilterControlAltText="Filter IDNumber column"
                                                                                                            HeaderText="<%$ Resources:Resource, lblDocumentID %>" SortExpression="IDNumber" UniqueName="IDNumber">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label runat="server" ID="IDNumber" Text='<%# ((System.Data.DataRowView)Container.DataItem)["IDNumber"] %>'></asp:Label>
                                                                                    </ItemTemplate>
                                                                                </telerik:GridTemplateColumn>
                                                                            </Columns>
                                                                        </MasterTableView>
                                                                    </telerik:RadGrid>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>

                            <asp:SqlDataSource ID="SqlDataSource_DocumentRules1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT erd.SystemID, erd.BpID, erd.EmployeeID, erd.RelevantFor, erd.RelevantDocumentID, rd.NameVisible, erd.DocumentReceived, erd.ExpirationDate, erd.IDNumber, tr1.DescriptionTranslated AS ToolTipExpiration, tr2.DescriptionTranslated AS ToolTipDocumentID, rd.IsAccessRelevant FROM Master_Translations AS tr2 RIGHT OUTER JOIN Master_RelevantDocuments AS rd ON tr2.SystemID = rd.SystemID AND tr2.BpID = rd.BpID AND tr2.ForeignID = rd.RelevantDocumentID LEFT OUTER JOIN Master_Translations AS tr1 ON rd.SystemID = tr1.SystemID AND rd.BpID = tr1.BpID AND rd.RelevantDocumentID = tr1.ForeignID RIGHT OUTER JOIN Master_EmployeeRelevantDocuments AS erd ON rd.SystemID = erd.SystemID AND rd.BpID = erd.BpID AND rd.RelevantDocumentID = erd.RelevantDocumentID WHERE (tr1.DialogID = 6) AND (tr1.FieldID = 13) AND (tr2.DialogID = 6) AND (tr2.FieldID = 14) AND (tr1.LanguageID = @LanguageID) AND (tr2.LanguageID = @LanguageID) AND (erd.SystemID = @SystemID) AND (erd.BpID = @BpID) AND (erd.EmployeeID = @EmployeeID) OR (tr1.DialogID IS NULL) AND (tr1.FieldID IS NULL) AND (tr2.DialogID IS NULL) AND (tr2.FieldID IS NULL) AND (tr1.LanguageID IS NULL) AND (tr2.LanguageID IS NULL) AND (erd.SystemID = @SystemID) AND (erd.BpID = @BpID) AND (erd.EmployeeID = @EmployeeID)">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="LanguageID" DefaultValue="en" Name="LanguageID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </telerik:RadPageView>

                        <%-- Access control --%>
                        <telerik:RadPageView ID="RadPageView6" runat="server">
                            <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                                <table id="Table15" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                                    <tr>
                                        <td style="vertical-align: top;">
                                            <table id="Table16" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ", ", Resources.Resource.lblAddrFirstName, ":") %>'
                                                                   ></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LastName, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).FirstName) %>'
                                                                   ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ", ", Resources.Resource.lblAddrEmail, ":") %>'
                                                                   ></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Phone, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Email) %>'
                                                                   ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'
                                                                   ></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameVisible, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameAdditional) %>'
                                                                   ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp; </td>
                                                    <td>&nbsp; </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelAttributeID" Text='<%# String.Concat(Resources.Resource.lblAttributeForPrintPass, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <telerik:RadComboBox runat="server" ID="AttributeID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                                                             DataValueField="AttributeID" DataTextField="NameVisible" Width="300" DataSourceID="SqlDataSource_AssignedAttributes1"
                                                                             Filter="Contains" AppendDataBoundItems="true" DropDownAutoWidth="Enabled" SelectedValue='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).AttributeID %>' Enabled="false">
                                                            <Items>
                                                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0" />
                                                            </Items>
                                                        </telerik:RadComboBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelExternalPassID" Text='<%# String.Concat(Resources.Resource.lblExternalPassID, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="ExternalPassID" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).ExternalPassID %>' Width="300px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelAccessRightValidUntil" Text='<%# String.Concat(Resources.Resource.lblAccessRightValidUntil, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="AccessRightValidUntil" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).AccessRightValidUntil %>'></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp; </td>
                                                    <td>&nbsp; </td>
                                                </tr>
                                                <tr>
                                                    <td style="vertical-align: top;">
                                                        <asp:Label runat="server" ID="LabelAccessDenialTimeStamp" Text='<%# String.Concat(Resources.Resource.lblAccessRightTimeStamp, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="AccessDenialTimeStamp" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).AccessDenialTimeStamp %>'></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="vertical-align: top;">
                                                        <asp:Label runat="server" ID="LabelAccessDenialReason" Text='<%# String.Concat(Resources.Resource.lblEmplAccess4, ":") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="AccessDenialReason"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp; </td>
                                                    <td>&nbsp; </td>
                                                </tr>

                                                <tr>
                                                    <td>
                                                        <table style="vertical-align: top;">
                                                            <tr>
                                                                <td>
                                                                    <asp:Label runat="server" ID="LabelAssignedAreas" Text='<%# String.Concat(Resources.Resource.lblAssignedAreas, ":") %>'></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <telerik:RadGrid runat="server" ID="AssignedAreas" DataSourceID="SqlDataSource_EmployeeAccessAreas2" CssClass="RadGrid"
                                                                                     AllowAutomaticDeletes="false" AllowAutomaticInserts="false" AllowAutomaticUpdates="false">
                                                                        <MasterTableView DataSourceID="SqlDataSource_EmployeeAccessAreas2" AutoGenerateColumns="false" AllowPaging="true" PageSize="5"
                                                                                         CommandItemDisplay="None" CssClass="MasterClass" DataKeyNames="SystemID,BpID,EmployeeID,AccessAreaID,TimeSlotGroupID">

                                                                            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="false" />

                                                                            <Columns>
                                                                                <telerik:GridBoundColumn DataField="AccessAreaID" UniqueName="AccessAreaID" ForceExtractValue="Always" Visible="false">
                                                                                </telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="TimeSlotGroupID" UniqueName="TimeSlotGroupID" ForceExtractValue="Always" Visible="false">
                                                                                </telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="AccessAreaName" HeaderText="<%$ Resources:Resource, lblAccessArea %>">
                                                                                </telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="TimeSlotGroupName" HeaderText="<%$ Resources:Resource, lblTimeSlotGroup %>">
                                                                                </telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="CreatedFrom" UniqueName="CreatedFrom" ForceExtractValue="Always" Visible="false">
                                                                                </telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="CreatedOn" UniqueName="CreatedOn" ForceExtractValue="Always" Visible="false">
                                                                                </telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="EditFrom" UniqueName="EditFrom" ForceExtractValue="Always" Visible="false">
                                                                                </telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="EditOn" UniqueName="EditOn" ForceExtractValue="Always" Visible="false">
                                                                                </telerik:GridBoundColumn>
                                                                            </Columns>
                                                                        </MasterTableView>
                                                                    </telerik:RadGrid>
                                                                    <asp:SqlDataSource ID="SqlDataSource_EmployeeAccessAreas2" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                                                                       SelectCommand="SELECT Master_EmployeeAccessAreas.AccessAreaID, Master_AccessAreas.NameVisible AS AccessAreaName, Master_AccessAreas.DescriptionShort, Master_EmployeeAccessAreas.BpID, Master_TimeSlotGroups.NameVisible AS TimeSlotGroupName, Master_EmployeeAccessAreas.TimeSlotGroupID, Master_EmployeeAccessAreas.CreatedFrom, Master_EmployeeAccessAreas.CreatedOn, Master_EmployeeAccessAreas.EditFrom, Master_EmployeeAccessAreas.EditOn, Master_EmployeeAccessAreas.EmployeeID, Master_EmployeeAccessAreas.SystemID FROM Master_EmployeeAccessAreas INNER JOIN Master_AccessAreas ON Master_EmployeeAccessAreas.SystemID = Master_AccessAreas.SystemID AND Master_EmployeeAccessAreas.BpID = Master_AccessAreas.BpID AND Master_EmployeeAccessAreas.AccessAreaID = Master_AccessAreas.AccessAreaID LEFT OUTER JOIN Master_TimeSlotGroups ON Master_EmployeeAccessAreas.SystemID = Master_TimeSlotGroups.SystemID AND Master_EmployeeAccessAreas.BpID = Master_TimeSlotGroups.BpID AND Master_EmployeeAccessAreas.TimeSlotGroupID = Master_TimeSlotGroups.TimeSlotGroupID WHERE (Master_EmployeeAccessAreas.SystemID = @SystemID) AND (Master_EmployeeAccessAreas.BpID = @BpID) AND (Master_EmployeeAccessAreas.EmployeeID = @EmployeeID)">
                                                                        <SelectParameters>
                                                                            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                                                            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                                                            <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                                                        </SelectParameters>
                                                                    </asp:SqlDataSource>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>&nbsp; </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label runat="server" ID="LabelRadGridEmplAccess3" Text='<%# String.Concat(Resources.Resource.lblEmplAccess3, ":") %>'></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <telerik:RadGrid runat="server" ID="RadGridEmplAccess3" DataSourceID="SqlDataSource_StatusID1">
                                                                        <MasterTableView DataSourceID="SqlDataSource_StatusID1" AutoGenerateColumns="false" AllowPaging="true" PageSize="5">
                                                                            <Columns>
                                                                                <telerik:GridTemplateColumn DataField="ResourceID" HeaderText="<%$ Resources:Resource, lblAction %>">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label runat="server" ID="ResourceID" Text='<%# GetResource(((System.Data.DataRowView)Container.DataItem)["ResourceID"].ToString()) %>'></asp:Label>
                                                                                    </ItemTemplate>
                                                                                </telerik:GridTemplateColumn>
                                                                                <telerik:GridBoundColumn DataField="InternalID" HeaderText="<%$ Resources:Resource, lblIDInternal %>"></telerik:GridBoundColumn>
                                                                                <telerik:GridBoundColumn DataField="ExternalID" HeaderText="<%$ Resources:Resource, lblIDExternal %>"></telerik:GridBoundColumn>
                                                                                <telerik:GridBoundColumn DataField="Timestamp" HeaderText="<%$ Resources:Resource, lblTimeStamp %>"></telerik:GridBoundColumn>
                                                                                <telerik:GridBoundColumn DataField="Reason" HeaderText="<%$ Resources:Resource, lblReason %>"></telerik:GridBoundColumn>
                                                                            </Columns>
                                                                        </MasterTableView>
                                                                    </telerik:RadGrid>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>&nbsp; </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label runat="server" ID="LabelRadGridEmplAccess1" Text='<%# String.Concat(Resources.Resource.lblEmplAccess1, ":") %>'></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <telerik:RadGrid runat="server" ID="RadGridEmplAccess1" DataSourceID="SqlDataSource_AccessLog3">
                                                                        <MasterTableView DataSourceID="SqlDataSource_AccessLog3" AutoGenerateColumns="false" AllowPaging="true" PageSize="5"
                                                                                         CommandItemDisplay="Top">

                                                                            <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="false" ShowExportToCsvButton="false"
                                                                                                 ShowExportToExcelButton="false" ShowExportToPdfButton="false"
                                                                                                 AddNewRecordText="<%$ Resources:Resource, lblActionNew %>"
                                                                                                 RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                                                                            <Columns>
                                                                                <telerik:GridBoundColumn DataField="NameVisible" HeaderText="<%$ Resources:Resource, lblAccessArea %>"></telerik:GridBoundColumn>
                                                                                <telerik:GridTemplateColumn DataField="AccessState" HeaderText="<%$ Resources:Resource, lblStatus %>">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label ID="AccessState" runat="server" Text='<%# GetAccessState(Convert.ToInt32(((System.Data.DataRowView)Container.DataItem)["AccessState"])) %>'>
                                                                                        </asp:Label>
                                                                                    </ItemTemplate>
                                                                                </telerik:GridTemplateColumn>
                                                                            </Columns>
                                                                        </MasterTableView>
                                                                    </telerik:RadGrid>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>&nbsp; </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label runat="server" ID="LabelRadGridEmplAccess2" Text='<%# String.Concat(Resources.Resource.lblEmplAccess2, ":") %>'></asp:Label>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <telerik:RadGrid runat="server" ID="RadGridEmplAccess2" DataSourceID="SqlDataSource_AccessLog4">
                                                                        <MasterTableView DataSourceID="SqlDataSource_AccessLog4" AutoGenerateColumns="false" AllowPaging="true" PageSize="5"
                                                                                         CommandItemDisplay="Top">

                                                                            <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="false" ShowExportToCsvButton="false"
                                                                                                 ShowExportToExcelButton="false" ShowExportToPdfButton="false"
                                                                                                 AddNewRecordText="<%$ Resources:Resource, lblActionNew %>"
                                                                                                 RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                                                                            <Columns>
                                                                                <telerik:GridBoundColumn DataField="Timestamp" HeaderText="<%$ Resources:Resource, lblTimeStamp %>"></telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="AccessAreaID" Visible="false"></telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="EmployeeID" UniqueName="EmployeeID2" Visible="false"></telerik:GridBoundColumn>

                                                                                <telerik:GridBoundColumn DataField="NameVisible" HeaderText="<%$ Resources:Resource, lblAccessArea %>"></telerik:GridBoundColumn>

                                                                                <telerik:GridTemplateColumn DataField="AccessTypeID" HeaderText="<%$ Resources:Resource, lblAction %>" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                                                    <ItemTemplate>
                                                                                        <asp:Image runat="server" ImageUrl='<%# (Convert.ToInt32(Eval("AccessTypeID")) == 1) ? "~/Resources/Icons/enter-16.png" : "~/Resources/Icons/exit-16.png" %>' 
                                                                                                   Width="16px" Height="16px" ToolTip='<%# GetAccessType(Convert.ToInt32(((System.Data.DataRowView)Container.DataItem)["AccessTypeID"])) %>' />
                                                                                    </ItemTemplate>
                                                                                </telerik:GridTemplateColumn>

                                                                                <telerik:GridTemplateColumn DataField="Result" HeaderText="<%$ Resources:Resource, lblResult %>">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label runat="server" Text='<%# Eval("Result").ToString().Equals("1") ? Resources.Resource.lblOK : Resources.Resource.lblFault %>' 
                                                                                                   ForeColor='<%# Eval("Result").ToString().Equals("1") ? System.Drawing.Color.DarkGreen : System.Drawing.Color.Red %>'></asp:Label>
                                                                                    </ItemTemplate>
                                                                                </telerik:GridTemplateColumn>

                                                                                <telerik:GridTemplateColumn DataField="IsOnlineAccessEvent" HeaderText="<%$ Resources:Resource, lblStatus %>" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                                                    <ItemTemplate>
                                                                                        <asp:Image runat="server" ImageUrl='<%# Convert.ToBoolean(Eval("IsOnlineAccessEvent")) ? "~/Resources/Icons/Online_16.png" : "~/Resources/Icons/Offline_16.png" %>' 
                                                                                                   Width="16px" Height="16px" ToolTip='<%# Convert.ToBoolean(Eval("IsOnlineAccessEvent")) ? Resources.Resource.lblOnline : Resources.Resource.lblOffline %>' />
                                                                                    </ItemTemplate>
                                                                                </telerik:GridTemplateColumn>

                                                                                <telerik:GridTemplateColumn DataField="IsManualEntry" HeaderText="<%$ Resources:Resource, lblManual %>">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label runat="server" Text='<%# Convert.ToBoolean(Eval("IsManualEntry")) ? Resources.Resource.lblYes : Resources.Resource.lblNo %>'></asp:Label>
                                                                                    </ItemTemplate>
                                                                                </telerik:GridTemplateColumn>

                                                                                <telerik:GridTemplateColumn DataField="OriginalMessage" HeaderText="<%$ Resources:Resource, lblDenialReason %>" ForceExtractValue="Always" SortExpression="OriginalMessage" 
                                                                                                            UniqueName="OriginalMessage" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="80px" GroupByExpression="OriginalMessage Group By OriginalMessage">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label runat="server" ID="OriginalMessage" Text='<%# Eval("OriginalMessage") %>'></asp:Label>
                                                                                    </ItemTemplate>
                                                                                </telerik:GridTemplateColumn>
                                                                            </Columns>
                                                                        </MasterTableView>
                                                                    </telerik:RadGrid>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>&nbsp; </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td>&nbsp; </td>
                                    </tr>
                                    <tr>
                                        <td align="left" colspan="2">
                                            <telerik:RadButton runat="server" ID="AccessRightInfo" Text="<%# Resources.Resource.lblAccessRightsInfo %>" AutoPostBack="false"
                                                               ButtonType="StandardButton" BorderStyle="None" CausesValidation="false">
                                                <Icon PrimaryIconUrl="../../Resources/Icons/info_16.png" PrimaryIconHeight="16px" PrimaryIconWidth="16px" />
                                            </telerik:RadButton>
                                        </td>
                                    </tr>
                                </table>

                                <asp:SqlDataSource ID="SqlDataSource_AssignedAttributes1" runat="server" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                                                   SelectCommand="SELECT ac.SystemID, ac.BpID, ac.AttributeID, ab.NameVisible, ab.DescriptionShort, ac.CreatedFrom, ac.CreatedOn, ac.EditFrom, ac.EditOn, ac.CompanyID FROM Master_AttributesCompany AS ac INNER JOIN Master_AttributesBuildingProject AS ab ON ac.SystemID = ab.SystemID AND ac.BpID = ab.BpID AND ac.AttributeID = ab.AttributeID WHERE (ac.SystemID = @SystemID) AND (ac.BpID = @BpID) AND (ac.CompanyID = @CompanyID)">
                                    <SelectParameters>
                                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
                                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
                                        <asp:ControlParameter ControlID="CompanyID" PropertyName="Value" DefaultValue="0" Name="CompanyID"></asp:ControlParameter>
                                    </SelectParameters>
                                </asp:SqlDataSource>

                                <asp:SqlDataSource ID="SqlDataSource_AccessAreas1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                                   SelectCommand="SELECT * FROM Master_AccessAreas aa WHERE aa.SystemID = @SystemID AND aa.BpID = @BpID AND NOT EXISTS (SELECT 1 FROM Master_EmployeeAccessAreas eaa WHERE  eaa.SystemID = @SystemID AND eaa.BpID = @BpID AND eaa.EmployeeID = @EmployeeID AND eaa.AccessAreaID = aa.AccessAreaID)">
                                    <SelectParameters>
                                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                        <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                    </SelectParameters>
                                </asp:SqlDataSource>

                                <asp:SqlDataSource ID="SqlDataSource_EmployeeAccessAreas1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                                   SelectCommand="SELECT Master_EmployeeAccessAreas.AccessAreaID, Master_AccessAreas.NameVisible, Master_AccessAreas.DescriptionShort FROM Master_EmployeeAccessAreas INNER JOIN Master_AccessAreas ON Master_EmployeeAccessAreas.SystemID = Master_AccessAreas.SystemID AND Master_EmployeeAccessAreas.BpID = Master_AccessAreas.BpID AND Master_EmployeeAccessAreas.AccessAreaID = Master_AccessAreas.AccessAreaID WHERE (Master_EmployeeAccessAreas.SystemID = @SystemID) AND (Master_EmployeeAccessAreas.BpID = @BpID) AND (Master_EmployeeAccessAreas.EmployeeID = @EmployeeID)">
                                    <SelectParameters>
                                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                        <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                    </SelectParameters>
                                </asp:SqlDataSource>

                                <asp:SqlDataSource ID="SqlDataSource_AccessLog3" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                                   SelectCommand="SELECT Master_AccessAreas.NameVisible, SUM(ISNULL(Data_AccessEvents.AccessType, 0)) AS AccessState FROM Master_AccessAreas INNER JOIN Master_EmployeeAccessAreas ON Master_AccessAreas.SystemID = Master_EmployeeAccessAreas.SystemID AND Master_AccessAreas.BpID = Master_EmployeeAccessAreas.BpID AND Master_AccessAreas.AccessAreaID = Master_EmployeeAccessAreas.AccessAreaID LEFT OUTER JOIN Data_AccessEvents ON Master_EmployeeAccessAreas.EmployeeID = Data_AccessEvents.OwnerID AND Master_EmployeeAccessAreas.AccessAreaID = Data_AccessEvents.AccessAreaID AND Master_EmployeeAccessAreas.SystemID = Data_AccessEvents.SystemID AND Master_EmployeeAccessAreas.BpID = Data_AccessEvents.BpID WHERE (Master_EmployeeAccessAreas.SystemID = @SystemID) AND (Master_EmployeeAccessAreas.BpID = @BpID) AND (Master_EmployeeAccessAreas.EmployeeID = @EmployeeID) GROUP BY Master_AccessAreas.NameVisible">
                                    <SelectParameters>
                                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                        <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                    </SelectParameters>
                                </asp:SqlDataSource>

                                <asp:SqlDataSource ID="SqlDataSource_AccessLog4" runat="server" 
                                                    ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                                    SelectCommandType="StoredProcedure"
                                                    SelectCommand="GetAccessHistoryEmployee">
                                    <SelectParameters>
                                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                        <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                    </SelectParameters>
                                </asp:SqlDataSource>

                                <asp:SqlDataSource ID="SqlDataSource_StatusID1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                                   SelectCommand="SELECT Data_PassHistory.ActionID, Master_Passes.InternalID, Master_Passes.ExternalID, Data_PassHistory.Timestamp, Data_PassHistory.Reason, System_Actions.NameVisible, System_Actions.ResourceID FROM Data_PassHistory INNER JOIN Master_Passes ON Data_PassHistory.SystemID = Master_Passes.SystemID AND Data_PassHistory.BpID = Master_Passes.BpID AND Data_PassHistory.PassID = Master_Passes.PassID INNER JOIN System_Actions ON Data_PassHistory.SystemID = System_Actions.SystemID AND Data_PassHistory.ActionID = System_Actions.ActionID WHERE (Data_PassHistory.SystemID = @SystemID) AND (Data_PassHistory.BpID = @BpID) AND (Data_PassHistory.EmployeeID = @EmployeeID) ORDER BY Data_PassHistory.Timestamp DESC">
                                    <SelectParameters>
                                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                        <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                    </SelectParameters>
                                </asp:SqlDataSource>

                                <asp:SqlDataSource ID="SqlDataSource_DenyReasons1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                                   SelectCommand="SELECT AccessDenialReason AS Reason, CreatedOn AS TimeStamp FROM Data_AccessRightEvents WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (OwnerID = @EmployeeID) AND (PassType = 1) AND (AccessAllowed = 0) AND (IsNewest = 1) AND (HasSubstitute = 0)">
                                    <SelectParameters>
                                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                        <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </div>

                        </telerik:RadPageView>

                        <%-- Other criterias --%>
                        <telerik:RadPageView ID="RadPageView7" runat="server">
                            <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                                <table id="Table9" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                                    <tr>
                                        <td style="vertical-align: top;">
                                            <table id="Table10" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ", ", Resources.Resource.lblAddrFirstName, ":") %>'
                                                                   ></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LastName, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).FirstName) %>'
                                                                   ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ", ", Resources.Resource.lblAddrEmail, ":") %>'
                                                                   ></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Phone, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Email) %>'
                                                                   ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'
                                                                   ></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameVisible, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameAdditional) %>'
                                                                   ></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp; </td>
                                                    <td>&nbsp; </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelUserString1" Text='<%# String.Concat(Resources.Resource.lblUserDefinedString, " 1:") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="UserString1" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).UserString1 %>' Width="300px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelUserString2" Text='<%# String.Concat(Resources.Resource.lblUserDefinedString, " 2:") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="UserString2" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).UserString2 %>' Width="300px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelUserString3" Text='<%# String.Concat(Resources.Resource.lblUserDefinedString, " 3:") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="UserString3" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).UserString3 %>' Width="300px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelUserString4" Text='<%# String.Concat(Resources.Resource.lblUserDefinedString, " 4:") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:Label runat="server" ID="UserString4" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).UserString4 %>' Width="300px"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelUserBit1" Text='<%# String.Concat(Resources.Resource.lblUserDefinedBit, " 1:") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:CheckBox runat="server" CssClass="cb" ID="UserBit1" Checked='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).UserBit1 %>'></asp:CheckBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelUserBit2" Text='<%# String.Concat(Resources.Resource.lblUserDefinedBit, " 2:") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:CheckBox runat="server" CssClass="cb" ID="UserBit2" Checked='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).UserBit2 %>'></asp:CheckBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelUserBit3" Text='<%# String.Concat(Resources.Resource.lblUserDefinedBit, " 3:") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:CheckBox runat="server" CssClass="cb" ID="UserBit3" Checked='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).UserBit3 %>'></asp:CheckBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelUserBit4" Text='<%# String.Concat(Resources.Resource.lblUserDefinedBit, " 4:") %>'></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:CheckBox runat="server" CssClass="cb" ID="UserBit4" Checked='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).UserBit4 %>'></asp:CheckBox>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>

                        </telerik:RadPageView>

                    </telerik:RadMultiPage>
                </asp:Panel>
            </NestedViewTemplate>

            <Columns>

                <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                               UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                    <ItemStyle BackColor="Control" />
                </telerik:GridEditCommandColumn>

                <telerik:GridTemplateColumn DataField="FirstChar" HeaderText="<%$ Resources:Resource, lblInitial %>" SortExpression="FirstChar" UniqueName="FirstChar"
                                            GroupByExpression="FirstChar FirstChar GROUP BY FirstChar" ForceExtractValue="Always" ItemStyle-Width="50px" HeaderStyle-Width="50px" 
                                            AllowFiltering="false" Display="false">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="FirstChar" Text='<%# Eval("FirstChar") %>'></asp:Label>
                    </ItemTemplate>

<HeaderStyle Width="50px"></HeaderStyle>

<ItemStyle Width="50px"></ItemStyle>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="StatusID" HeaderText="<%$ Resources:Resource, lblStatus %>" SortExpression="StatusID" UniqueName="StatusID" ItemStyle-HorizontalAlign="Center"
                                            GroupByExpression="StatusID StatusID GROUP BY StatusID" Visible="true" ForceExtractValue="Always" ItemStyle-Width="65px" HeaderStyle-Width="65px"
                                            HeaderStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:ImageButton runat="server" ID="ReleaseButton" Enabled="false" />
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="StatusID" DataValueField="StatusID" Height="200px" AppendDataBoundItems="true"
                                             SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("StatusID").CurrentFilterValue %>'
                                             runat="server" OnClientSelectedIndexChanged="StatusIDIndexChanged" DropDownAutoWidth="Enabled" Width="50px">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" Selected="true" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statCreated %>" Value="0" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statCreatedNotConfirmed %>" Value="5" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statWaitReleaseForCo %>" Value="15" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statWaitReleaseForBp %>" Value="35" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statReleased %>" Value="20" />
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

<HeaderStyle HorizontalAlign="Center" Width="65px"></HeaderStyle>

<ItemStyle HorizontalAlign="Center" Width="65px"></ItemStyle>
                </telerik:GridTemplateColumn>

                <telerik:GridBoundColumn DataField="CompanyID" UniqueName="CompanyID" Visible="false" ForceExtractValue="Always"></telerik:GridBoundColumn>

                <telerik:GridTemplateColumn DataField="AccessAllowed" HeaderText="<%$ Resources:Resource, lblAccess %>" SortExpression="AccessAllowed" UniqueName="AccessAllowed"
                                            GroupByExpression="AccessAllowed AccessAllowed GROUP BY AccessAllowed" Visible="true" ForceExtractValue="Always" CurrentFilterFunction="EqualTo" 
                                            ItemStyle-Width="65px" HeaderStyle-Width="65px" AutoPostBackOnFilter="true" ItemStyle-HorizontalAlign="Center" DataType="System.Boolean"
                                            HeaderStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <div style="margin-left: -2px; margin-top: 2px;">
                            <asp:Image ImageUrl='<%# Convert.ToBoolean(Eval("AccessAllowed")) ? "/InSiteApp/Resources/Images/signal_green_60.png" : "/InSiteApp/Resources/Images/signal_red_60.png"  %>'
                                       runat="server" Width="40px" ToolTip='<%# Convert.ToBoolean(Eval("AccessAllowed")) ? Resources.Resource.lblAccessAllowed : ((Eval("AccessDenialReason") == "") ? Resources.Resource.lblNoPassAssigned : (Eval("AccessDenialReason"))) %>' />
                        </div>
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="AccessAllowedFilter" runat="server" OnClientSelectedIndexChanged="AccessAllowedFilterSelectedIndexChanged"
                                             SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("AccessAllowed").CurrentFilterValue %>'
                                             AppendDataBoundItems="true" DropDownAutoWidth="Enabled" Width="50px">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" Value="" Selected="true" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblYes %>" Value="1" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblNo %>" Value="0" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock12" runat="server">
                            <script type="text/javascript">
                                function AccessAllowedFilterSelectedIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    var filterVal = args.get_item().get_value();
                                    if (filterVal === "") {
                                        tableView.filter("AccessAllowed", filterVal, "NoFilter");
                                    } else if (filterVal === "1" || filterVal === "0") {
                                        tableView.filter("AccessAllowed", filterVal, "EqualTo");
                                    }
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>

<HeaderStyle HorizontalAlign="Center" Width="65px"></HeaderStyle>

<ItemStyle HorizontalAlign="Center" Width="65px"></ItemStyle>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Present" HeaderText="<%$ Resources:Resource, lblPresent %>" SortExpression="Present" UniqueName="Present"
                                            GroupByExpression="Present Present GROUP BY Present" Visible="true" ForceExtractValue="Always" CurrentFilterFunction="EqualTo" 
                                            ItemStyle-Width="70px" HeaderStyle-Width="70px" AutoPostBackOnFilter="true" ItemStyle-HorizontalAlign="Center" DataType="System.Boolean"
                                            HeaderStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <div style="margin-left: -2px; margin-top: 2px;">
                            <asp:Image ImageUrl='<%# (Convert.ToInt32(Eval("Present")) == 1) ? "/InSiteApp/Resources/Icons/enter-24.png" : ((Convert.ToInt32(Eval("Present")) == 0) ? "/InSiteApp/Resources/Icons/exit-24.png" : ((Convert.ToInt32(Eval("Present")) == 2) ? "/InSiteApp/Resources/Icons/undefined-24.png" : "/InSiteApp/Resources/Icons/never-24.png"))  %>'
                                       runat="server" Width="22px" Height="22px" ToolTip='<%# ((Convert.ToInt32(Eval("Present")) == 1) ? Resources.Resource.lblAccessStatePresent : ((Convert.ToInt32(Eval("Present")) == 0) ? Resources.Resource.lblAccessStateAbsent : ((Convert.ToInt32(Eval("Present")) == 2) ? Resources.Resource.lblAccessStateUndefined : Resources.Resource.lblAccessStateNoAccess))) + " " + Resources.Resource.lblSince.ToLower() + ": " + ((DateTime)Eval("AccessTime")).ToString("G") %>' />
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

                <telerik:GridTemplateColumn DataField="PhotoData" HeaderText="<%$ Resources:Resource, lblPhoto %>" UniqueName="PhotoData" Visible="true" ForceExtractValue="Always"
                                            HeaderStyle-Width="45px" ItemStyle-Width="45px" FilterControlWidth="0px" ShowFilterIcon="false" AllowSorting="false" AllowFiltering="false" Groupable="false" 
                                            ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <telerik:RadBinaryImage runat="server" ID="PhotoData" CssClass="RoundedCorners ThinBorder Shadow" ImageAlign="Middle" CropPosition="Left" VisibleWithoutSource="false"
                                                DataValue='<%# (Eval("ThumbnailData") == null) ? null : Eval("ThumbnailData") %>' Width="45px" 
                                                AutoAdjustImageControlSize="true" ResizeMode="Fit" FilterControlWidth="0px" ShowFilterIcon="false"></telerik:RadBinaryImage>
                    </ItemTemplate>

<HeaderStyle HorizontalAlign="Center" Width="45px"></HeaderStyle>

<ItemStyle HorizontalAlign="Center" Width="45px"></ItemStyle>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="LastName" HeaderText="<%$ Resources:Resource, lblAddrLastName %>" SortExpression="LastName" UniqueName="LastName"
                                            GroupByExpression="LastName LastName GROUP BY LastName" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px"
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="LastName" Text='<%# Eval("LastName") %>' ToolTip='<%# Eval("LastName") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="FirstName" HeaderText="<%$ Resources:Resource, lblAddrFirstName %>" SortExpression="FirstName" UniqueName="FirstName"
                                            GroupByExpression="FirstName FirstName GROUP BY FirstName" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px"
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="FirstName" Text='<%# Eval("FirstName") %>' ToolTip='<%# Eval("FirstName") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="EmployeeID" HeaderText="<%$ Resources:Resource, lblID %>" SortExpression="EmployeeID" UniqueName="EmployeeID"
                                            GroupByExpression="EmployeeID EmployeeID GROUP BY EmployeeID" InsertVisiblityMode="AlwaysHidden" ForceExtractValue="Always" Visible="false">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="EmployeeID" Text='<%# Eval("EmployeeID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="AddressID" HeaderText="AddressID" SortExpression="AddressID" UniqueName="AddressID"
                                            GroupByExpression="AddressID AddressID GROUP BY AddressID" Visible="false" ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="AddressID" Text='<%# Eval("AddressID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="NameVisible" HeaderText="<%$ Resources:Resource, lblEmployer %>" SortExpression="NameVisible" UniqueName="NameVisible"
                                            GroupByExpression="NameVisible NameVisible GROUP BY NameVisible" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="NameVisible" Text='<%# Eval("NameVisible") %>' ToolTip='<%# Eval("NameVisible") %>'></asp:Label>
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="NameVisibleFilter" DataSourceID="SqlDataSource_Companies" DataTextField="NameVisible"
                                             DataValueField="NameVisible" Height="200px" AppendDataBoundItems="true" Width="80px"
                                             SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("NameVisible").CurrentFilterValue %>'
                                             runat="server" OnClientSelectedIndexChanged="CompanyIDIndexChanged" DropDownAutoWidth="Enabled">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock2" runat="server">
                            <script type="text/javascript">
                                function CompanyIDIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    tableView.filter("NameVisible", args.get_item().get_value(), "EqualTo");
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="EmploymentStatus" HeaderText="<%$ Resources:Resource, lblEmploymentStatus %>" SortExpression="EmploymentStatus" UniqueName="EmploymentStatus"
                                            ForceExtractValue="Always" AllowFiltering="true" FilterControlWidth="80px">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="EmploymentStatus" Text='<%# Eval("EmploymentStatus") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="StaffFunction" HeaderText="<%$ Resources:Resource, lblFunction %>" SortExpression="StaffFunction" UniqueName="StaffFunction"
                                            GroupByExpression="StaffFunction StaffFunction GROUP BY StaffFunction" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px"
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" Display="false">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="StaffFunction" Text='<%# Eval("StaffFunction") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridBoundColumn DataField="NationalityID" UniqueName="NationalityID" Visible="false" ForceExtractValue="Always"></telerik:GridBoundColumn>

                <telerik:GridTemplateColumn DataField="NationalityName" HeaderText="<%$ Resources:Resource, lblNationality %>" SortExpression="NationalityName" UniqueName="NationalityName"
                                            GroupByExpression="NationalityName NationalityName GROUP BY NationalityName" FilterControlWidth="80px" Visible="true" ForceExtractValue="Always">
                    <ItemTemplate>
                        <table cellspacing="0" cellpadding="0" border="0" rules="none" style="border-style: none; height: 24px; margin-bottom: -8px; margin-top: -5px">
                            <tr style="border-style: none; height: 24px;">
                                <td style="border-style: none; height: 24px;">
                                    <asp:Image ID="ItemImage" ImageUrl='<%# String.Format("~/Resources/Icons/Flags/{0}", Eval("FlagName")) %>' Visible='<%# Eval("FlagName") != null %>'
                                               Height="24px" Width="24px" runat="server" />
                                </td>
                                <td style="border-style: none; height: 24px; padding-left: 5px;">
                                    <asp:Label runat="server" ID="NationalityName" Text='<%# Eval("NationalityName") %>'></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="CountryName" DataSourceID="SqlDataSource_Countries" DataTextField="CountryName"
                                             DataValueField="CountryName" Height="200px" AppendDataBoundItems="true" Width="80px"
                                             SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("NationalityName").CurrentFilterValue %>'
                                             runat="server" OnClientSelectedIndexChanged="NationalityNameIndexChanged" DropDownAutoWidth="Enabled">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock6" runat="server">
                            <script type="text/javascript">
                                function NationalityNameIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    tableView.filter("NationalityName", args.get_item().get_value(), "EqualTo");
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="FullAddress" HeaderText="<%$ Resources:Resource, lblAddress %>" SortExpression="FullAddress" UniqueName="FullAddress"
                                            GroupByExpression="FullAddress FullAddress GROUP BY FullAddress" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px"
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="FullAddress" Font-Size="Small" Text='<%# Eval("FullAddress") %>' ToolTip='<%# Eval("FullAddress") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Phone" HeaderText="<%$ Resources:Resource, lblAddrPhone %>" SortExpression="Phone" UniqueName="Phone"
                                            GroupByExpression="Phone Phone GROUP BY Phone" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px"
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" Display="false">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Phone" Text='<%# Eval("Phone") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Email" HeaderText="<%$ Resources:Resource, lblAddrEmail %>" SortExpression="Email" UniqueName="Email"
                                            GroupByExpression="Email Email GROUP BY Email" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px"
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" Display="false">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Email" Text='<%# Eval("Email") %>' 
                                   ToolTip='<%# Eval("Email") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="ExternalID" HeaderText="<%$ Resources:Resource, lblPassID %>" SortExpression="ExternalID" UniqueName="ExternalID"
                                            GroupByExpression="ExternalID ExternalID GROUP BY ExternalID" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px"
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ItemStyle-Wrap="false" HeaderStyle-Width="120px" ItemStyle-Width="120px">
                    <ItemTemplate>
                        <table cellpadding="0px" cellspacing="1px" style="border: none">
                            <tr>
                                <td style="padding: 0px; margin: 0px; border: none; width:20px;">
                                    <div style='width: 16px; height: 16px; background-color: <%# Eval("PassColor") %>'></div>
                                </td>
                                <td style="padding: 0px; margin: 0px; border: none;">
                                    <asp:Label runat="server" ID="ExternalID" Font-Size="Small" Text='<%# Eval("ExternalID") %>'></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 0px; margin: 0px; border: none;" colspan="2">
                                    <asp:Label runat="server" ID="TradeName" Font-Size="Small" Text='<%# Eval("TradeName") %>' ToolTip='<%# Eval("TradeName") %>'></asp:Label>
                                </td>
                            </tr>
                        </table>

                    </ItemTemplate>

<HeaderStyle Width="120px"></HeaderStyle>

<ItemStyle Wrap="False" Width="120px"></ItemStyle>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="AccessTime" HeaderText="<%$ Resources:Resource, lblPresent %>" SortExpression="AccessTime" UniqueName="AccessTime"
                                            GroupByExpression="AccessTime AccessTime GROUP BY AccessTime" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px"
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" Display="false">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="AccessTime" Text='<%# ((Convert.ToInt32(Eval("Present")) == 1) ? Resources.Resource.lblPresent : Resources.Resource.lblAbsent) + " " + Resources.Resource.lblSince.ToLower() + " " + ((DateTime)Eval("AccessTime")).ToString("G") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridBoundColumn DataField="UserBit1" DefaultInsertValue="false" HeaderText="UserBit1" Visible="false" UniqueName="UserBit1" ReadOnly="true" ForceExtractValue="Always">
                </telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="UserBit2" DefaultInsertValue="false" HeaderText="UserBit2" Visible="false" UniqueName="UserBit2" ReadOnly="true" ForceExtractValue="Always">
                </telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="UserBit3" DefaultInsertValue="false" HeaderText="UserBit3" Visible="false" UniqueName="UserBit3" ReadOnly="true" ForceExtractValue="Always">
                </telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="UserBit4" DefaultInsertValue="false" HeaderText="UserBit4" Visible="false" UniqueName="UserBit4" ReadOnly="true" ForceExtractValue="Always">
                </telerik:GridBoundColumn>

                <telerik:GridDateTimeColumn FilterControlWidth="100px" DataField="CreatedOn" HeaderText="<%$ Resources:Resource, lblCreatedOn %>" SortExpression="CreatedOn" Display="false"
                                            UniqueName="CreatedOn" PickerType="DatePicker" EnableRangeFiltering="true" HeaderStyle-Width="170px" ItemStyle-Width="170px" CurrentFilterFunction="Between" 
                                            AutoPostBackOnFilter="true" EnableTimeIndependentFiltering="true">
<HeaderStyle Width="170px"></HeaderStyle>

<ItemStyle Width="170px"></ItemStyle>
                </telerik:GridDateTimeColumn>

                <telerik:GridBoundColumn DataField="EditOn" HeaderText="<%$ Resources:Resource, lblEditOn %>" SortExpression="EditOn" UniqueName="EditOn" 
                                         HeaderStyle-Width="170px" ItemStyle-Width="170px" DataType="System.DateTime" DataFormatString="{0:G}" HeaderStyle-HorizontalAlign="Right" 
                                         ItemStyle-HorizontalAlign="Right">
                    <FilterTemplate>
                        <table>
                            <tr>
                                <td align="right">
                                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblFrom %>"></asp:Label>
                                </td>
                                <td>
                                    <telerik:RadDatePicker ID="FromDatePicker" runat="server" Width="100px" ClientEvents-OnDateSelected="FromDateSelected" MaxDate="<%# DateTime.Now %>" 
                                                           EnableShadows="true" ShowPopupOnFocus="true" DbSelectedDate='<%# GetFilterDate(((GridItem)Container).OwnerTableView.GetColumn("EditOn").CurrentFilterValue, 0) %>'>
                                    </telerik:RadDatePicker>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblUntil %>"></asp:Label>
                                </td>
                                <td>
                                    <telerik:RadDatePicker ID="ToDatePicker" runat="server" Width="100px" ClientEvents-OnDateSelected="ToDateSelected" MaxDate="<%# DateTime.Now %>" 
                                                           EnableShadows="true" ShowPopupOnFocus="true" DbSelectedDate='<%# GetFilterDate(((GridItem)Container).OwnerTableView.GetColumn("EditOn").CurrentFilterValue, 1) %>'>
                                    </telerik:RadDatePicker>
                                </td>
                                <td>
                                    <telerik:RadButton ID="BtnClear" runat="server" OnClientClicked="OnClientClicked" ToolTip="<%$ Resources:Resource, ttRemoveFilter %>"  
                                                       ButtonType="SkinnedButton" BorderStyle="None" BackColor="Transparent" Width="20px" Icon-PrimaryIconCssClass="rbRemove" >
                                    </telerik:RadButton>
                                </td>
                            </tr>
                        </table>
                        <telerik:RadScriptBlock ID="RadScriptBlock4" runat="server">
                            <script type="text/javascript">
                                function FromDateSelected(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    var ToPicker = $find('<%# ((GridItem)Container).FindControl("ToDatePicker").ClientID %>');

                                    var fromDate = FormatSelectedDate(sender);
                                    var toDate = FormatSelectedDate(ToPicker);

                                    if (fromDate !== '' && toDate !== '' && toDate !== '01/01/1970') {
                                        tableView.filter("EditOn", fromDate + ",00:00:00 " + toDate + ",23:59:59", "Between");
                                    }
                                }

                                function ToDateSelected(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    var FromPicker = $find('<%# ((GridItem)Container).FindControl("FromDatePicker").ClientID %>');

                                    var fromDate = FormatSelectedDate(FromPicker);
                                    var toDate = FormatSelectedDate(sender);

                                    if (fromDate !== '' && toDate !== '') {
                                        tableView.filter("EditOn", fromDate + ",00:00:00 " + toDate + ",23:59:59", "Between");
                                    }
                                }

                                function FormatSelectedDate(picker) {
                                    var date = picker.get_selectedDate();
                                    var dateInput = picker.get_dateInput();
                                    var formattedDate = dateInput.get_dateFormatInfo().FormatDate(date, "MM/dd/yyyy");
                                    return formattedDate;
                                }

                                function OnClientClicked(sender, args) {
                                    var FromPicker = $find('<%# ((GridItem)Container).FindControl("FromDatePicker").ClientID %>');
                                    var ToPicker = $find('<%# ((GridItem)Container).FindControl("ToDatePicker").ClientID %>');
                                    FromPicker.clear();
                                    FromPicker.hidePopup();
                                    ToPicker.clear();
                                    ToPicker.hidePopup();
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    tableView.filter("EditOn", "", "NoFilter");
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>

<HeaderStyle HorizontalAlign="Right" Width="170px"></HeaderStyle>

<ItemStyle HorizontalAlign="Right" Width="170px"></ItemStyle>
                </telerik:GridBoundColumn>

                <telerik:GridTemplateColumn DataField="Zip" HeaderText="<%$ Resources:Resource, lblAddrZip %>" SortExpression="Zip" UniqueName="Zip"
                                            GroupByExpression="Zip Zip GROUP BY Zip" ForceExtractValue="Always" AllowFiltering="false" FilterControlWidth="80px"
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true"  Display="false">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Zip" Text='<%# Eval("Zip") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="BirthDate" HeaderText="<%$ Resources:Resource, lblAddrBirthDate %>" SortExpression="BirthDate" UniqueName="BirthDate"
                                            GroupByExpression="BirthDate BirthDate GROUP BY BirthDate" ForceExtractValue="Always" AllowFiltering="false" FilterControlWidth="80px"
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true"  Display="false">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="BirthDate" Text='<%# Eval("BirthDate", "{0:d}") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Duplicates" HeaderText="<%$ Resources:Resource, lblDuplicates %>" SortExpression="Duplicates" UniqueName="Duplicates"
                                            GroupByExpression="Duplicates Duplicates GROUP BY Duplicates" ForceExtractValue="Always" AllowFiltering="false" Display="false">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Duplicates" Text='<%# Eval("Duplicates") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridButtonColumn UniqueName="deleteColumn" Visible="true" Text="<%$ Resources:Resource, lblActionDelete %>" ConfirmTextFormatString='<%$ Resources:Resource, qstDeleteRow1 %>'
                                          ConfirmTextFields="LastName,FirstName,EmployeeID"
                                          ConfirmDialogType="RadWindow" ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete">
                    <ItemStyle BackColor="Control" />
                </telerik:GridButtonColumn>

            </Columns>

        </MasterTableView>

    </telerik:RadGrid>

    <telerik:RadToolTipManager ID="RadToolTipManager1" OffsetY="-1" HideEvent="LeaveToolTip" runat="server" OnAjaxUpdate="RadToolTipManager1_AjaxUpdate"
                               RelativeTo="Element" Position="MiddleRight">
    </telerik:RadToolTipManager>

    <telerik:RadToolTipManager ID="RadToolTipManager2" OffsetY="-1" HideEvent="LeaveToolTip" runat="server" OnAjaxUpdate="RadToolTipManager2_AjaxUpdate"
                               RelativeTo="Element" Position="MiddleRight">
    </telerik:RadToolTipManager>

    <asp:SqlDataSource ID="SqlDataSource_Companies" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommandType="StoredProcedure" SelectCommand="GetCompaniesSelection">
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="CompanyID" DefaultValue="0" Name="CompanyID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="UserID" DefaultValue="0" Name="UserID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Trades" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT * FROM Master_Trades WHERE (SystemID = @SystemID) AND (BpID = @BpID) ORDER BY TradeNumber">
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_EmploymentStatus" runat="server" EnableCaching="true" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT * FROM [Master_EmploymentStatus] WHERE ([SystemID] = @SystemID) AND ([BpID] = @BpID)">
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Languages" runat="server" EnableCaching="true" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT LanguageID, LanguageName, FlagName FROM View_Languages ORDER BY LanguageName"></asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Countries" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT DISTINCT Master_Countries.CountryID, View_Countries.CountryName AS CountryName, View_Countries.FlagName FROM Master_Countries INNER JOIN View_Countries ON Master_Countries.CountryID = View_Countries.CountryID WHERE (Master_Countries.SystemID = @SystemID) AND (Master_Countries.BpID = @BpID) order by View_Countries.CountryName">
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Salutations" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT * FROM System_Salutations "></asp:SqlDataSource>
</asp:Content>
