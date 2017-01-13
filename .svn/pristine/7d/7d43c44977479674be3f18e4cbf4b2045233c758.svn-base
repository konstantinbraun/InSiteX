<%@ Page Title="<%$ Resources:Resource, lblCompanyMasterCentral %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CompaniesCentral.aspx.cs" 
Inherits="InSite.App.Views.Central.CompaniesCentral" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <style type="text/css">
        .auto-style1 {
            width: 251px;
        }
    </style>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <telerik:RadScriptBlock runat="server">
        <script type="text/javascript">
            function openRadWindow(CompanyID) {
                var oWnd = radopen("RegisterToBp.aspx?CompanyID=" + CompanyID, "RadWindow1");
                //oWnd.add_close(OnClientCloseRadWindow);
                oWnd.center();
            }

            function OnClientSelectedIndexChanged(sender, eventArgs) {
                var masterTable = $find("<%= RadGrid1.ClientID %>").get_masterTableView();
                masterTable.rebind();
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
    
    <div style="background-color: InactiveBorder;">
        <table>
            <tr>
                <td style="padding: 5px; width: 150px;">
                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblBuildingProject %>" Font-Bold="true"></asp:Label>
                </td>
                <td style="padding: 5px; vertical-align: top;">
                    <telerik:RadComboBox ID="SelectBp" Runat="server" Culture="de-DE" DataSourceID="SqlDataSource_BuildingProject" DataTextField="Name" DataValueField="Id" OnClientSelectedIndexChanged ="OnClientSelectedIndexChanged" AppendDataBoundItems ="true" >
                        <Items>
                            <telerik:RadComboBoxItem Value ="0" Text="<%$ Resources:Resource, lblAll %>" Selected ="true"  />
                        </Items>
                    </telerik:RadComboBox>
                </td>
            </tr>
        </table>
    </div>

    <telerik:RadGrid ID="RadGrid1" runat="server" AllowAutomaticInserts="false" AllowAutomaticUpdates="false" AllowPaging="true" AllowSorting="true" GroupPanelPosition="BeforeHeader"
                     EnableHeaderContextFilterMenu="True" EnableHeaderContextMenu="True" ShowGroupPanel="True" PageSize="15" AllowFilteringByColumn="true" AllowAutomaticDeletes="false" 
                     CssClass="MainGrid" 
                     OnItemCommand="RadGrid1_ItemCommand" OnDeleteCommand="RadGrid1_DeleteCommand"
                     OnPreRender="RadGrid1_PreRender" OnItemDataBound="RadGrid1_ItemDataBound" OnInsertCommand="RadGrid1_InsertCommand" OnUpdateCommand="RadGrid1_UpdateCommand"
                     OnItemCreated="RadGrid1_ItemCreated" OnGroupsChanging="RadGrid1_GroupsChanging" OnNeedDataSource="RadGrid1_NeedDataSource">

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

        <ValidationSettings CommandsToValidate="PerformInsert,Update" EnableValidation="true"></ValidationSettings>

        <SortingSettings SortedBackColor="Transparent" />

        <MasterTableView EnableHierarchyExpandAll="true" AutoGenerateColumns="False" DataKeyNames="SystemID,CompanyID,AddressID"
                         CommandItemDisplay="Top" HierarchyLoadMode="ServerBind" AllowMultiColumnSorting="true" EditMode="PopUp">

            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" PageSizes="15,30,100" />

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
                <telerik:GridSortExpression FieldName="NameVisible" SortOrder="Ascending"></telerik:GridSortExpression>
            </SortExpressions>

            <CommandItemTemplate>
                <div style="margin: 3px; height: 20px;">
                    <telerik:RadButton ID="btnInitInsert" runat="server" CommandName="InitInsert" Visible="true" Text='<%# Resources.Resource.lblActionNew %>'
                                       Icon-PrimaryIconCssClass="rbAdd" ButtonType="SkinnedButton" BorderStyle="None" BackColor="Transparent">
                    </telerik:RadButton>

                    <asp:PlaceHolder runat="server" ID="AlphaFilter"></asp:PlaceHolder>

                    <%--                    <div class="vertical-line"></div>--%>

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
                </div>
            </CommandItemTemplate>

            <%--#################################################################################### Edit Template ########################################################################################################--%>

            <EditFormSettings EditFormType="Template" CaptionDataField="NameVisible" CaptionFormatString="<%$ Resources:Resource, lblCompanies %>">
                <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" Height="600px" />
                <FormTemplate>
                    <telerik:RadTabStrip ID="RadTabStrip1" runat="server" MultiPageID="RadMultiPage1" Align="Left" AutoPostBack="false" CausesValidation="false">
                        <Tabs>
                            <telerik:RadTab PageViewID="RadPageView1" ImageUrl="~/Resources/Icons/factory.png" Text="<%# Resources.Resource.lblGenerally %>" Selected="true" Font-Bold="true" Value="1" />
                            <telerik:RadTab PageViewID="RadPageView2" ImageUrl="~/Resources/Icons/list-add-5.png" Text="<%# Resources.Resource.lblAdvanced %>" Font-Bold="true" Value="2" />
                            <telerik:RadTab PageViewID="RadPageView3" ImageUrl="~/Resources/Icons/info.png" Text="<%# Resources.Resource.lblInfo %>" Font-Bold="true" Value="3" />
                            <telerik:RadTab PageViewID="RadPageView4" ImageUrl="~/Resources/Icons/Contract.png" Text="<%# Resources.Resource.lblTariffContracts %>" Font-Bold="true" Value="4" />
                        </Tabs>
                    </telerik:RadTabStrip>

                    <telerik:RadMultiPage ID="RadMultiPage1" runat="server" RenderSelectedPageOnly="false">
                        <%-- Generally --%>
                        <telerik:RadPageView ID="RadPageView1" runat="server" Selected="true">
                            <table id="Table2" cellspacing="5" cellpadding="5" border="0" rules="none" class="EditFormTable">
                                <tr>
                                    <td style="vertical-align: top;">
                                        <table id="Table3" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label1" Text='<%# String.Concat(Resources.Resource.lblID, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" ID="CompanyID" Text='<%# Eval("CompanyID") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <b><%= Resources.Resource.lblNameVisible %>:</b>
                                                </td>
                                                <td nowrap="nowrap">
                                                    <telerik:RadTextBox ID="NameVisible" runat="server" Width="300px" Text='<%# Eval("NameVisible") %>'></telerik:RadTextBox>
                                                    <asp:RequiredFieldValidator runat="server" ID="ValidatorNameVisible" ControlToValidate="NameVisible" ErrorMessage="<%$ Resources:Resource, msgNameVisibleObligate %>" Text="*" 
                                                                                SetFocusOnError="true" ForeColor="Red" ValidationGroup="Company">
                                                    </asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblNameAdditional %>: </td>
                                                <td>
                                                    <telerik:RadTextBox ID="NameAdditional"  runat="server" Width="300px" Text='<%# Eval("NameAdditional") %>'></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp; </td>
                                                <td>
                                                    <asp:HiddenField ID="AddressID" runat="server" Value='<%# Eval("AddressID") %>'></asp:HiddenField>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <b><%= Resources.Resource.lblAddress1 %>:</b>
                                                </td>
                                                <td nowrap="nowrap">
                                                    <telerik:RadTextBox ID="Address1" runat="server" Width="300px" Text='<%# Eval("Address1") %>'></telerik:RadTextBox>
                                                    <asp:RequiredFieldValidator runat="server" ID="ValidatorAddress1" ControlToValidate="Address1" ErrorMessage="<%$ Resources:Resource, msgAddress1Obligate %>" Text="*" 
                                                                                SetFocusOnError="true" ForeColor="Red" ValidationGroup="Company">
                                                    </asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblAddress2 %>: </td>
                                                <td>
                                                    <telerik:RadTextBox ID="Address2" runat="server" Width="300px" Text='<%# Eval("Address2") %>'></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <b><%= Resources.Resource.lblAddrZip %>:</b>
                                                </td>
                                                <td nowrap="nowrap">
                                                    <telerik:RadTextBox ID="Zip" runat="server" Text='<%# Eval("Zip") %>'></telerik:RadTextBox>
                                                    <asp:RequiredFieldValidator runat="server" ID="ValidatorZip" ControlToValidate="Zip" ErrorMessage="<%$ Resources:Resource, msgZipObligate %>" Text="*" 
                                                                                SetFocusOnError="true" ForeColor="Red" ValidationGroup="Company">
                                                    </asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <b><%= Resources.Resource.lblAddrCity %>:</b>
                                                </td>
                                                <td nowrap="nowrap">
                                                    <telerik:RadTextBox ID="City" runat="server" Width="300px" Text='<%# Eval("City") %>'></telerik:RadTextBox>
                                                    <asp:RequiredFieldValidator runat="server" ID="ValidatorCity" ControlToValidate="City" ErrorMessage="<%$ Resources:Resource, msgCityObligate %>" Text="*" 
                                                                                SetFocusOnError="true" ForeColor="Red" ValidationGroup="Company">
                                                    </asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblAddrState %>: </td>
                                                <td>
                                                    <telerik:RadTextBox ID="State" Text='<%# Bind("State") %>' runat="server" Width="300px"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <b><%= Resources.Resource.lblCountry %>:</b>
                                                </td>
                                                <td>
                                                    <asp:HiddenField ID="CountryID1" runat="server" Value='<%# Eval("CountryID") %>'></asp:HiddenField>
                                                    <telerik:RadComboBox runat="server" ID="CountryID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                                                         DataValueField="Name" DataTextField="DisplayName" Width="300" Filter="Contains"
                                                                         AppendDataBoundItems="true" DropDownAutoWidth="Enabled">
                                                        <ItemTemplate>
                                                            <table cellpadding="3px" style="text-align: left;">
                                                                <tr style="height: 24px;">
                                                                    <td style="text-align: left;">
                                                                        <asp:Image ID="ItemImage" ImageUrl='<%# String.Format("~/Resources/Icons/Flags/flag-{0}.png", Eval("Name"))%>' runat="server"
                                                                                   Width="24px" Height="24px" />
                                                                    </td>
                                                                    <td style="text-align: left;">
                                                                        <asp:Label ID="ItemName" Text='<%# Eval("Name") %>' runat="server">
                                                                        </asp:Label>
                                                                    </td>
                                                                    <td style="text-align: left;">
                                                                        <asp:Label ID="ItemDescr" Text='<%# Eval("DisplayName") %>' runat="server">
                                                                        </asp:Label>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </ItemTemplate>
                                                    </telerik:RadComboBox>
                                                    <asp:RequiredFieldValidator runat="server" ID="ValidatorCountryID" ControlToValidate="CountryID" ErrorMessage="<%$ Resources:Resource, msgCountryObligate %>" Text="*" 
                                                                                SetFocusOnError="true" ForeColor="Red" ValidationGroup="Company">
                                                    </asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp; </td>
                                                <td>&nbsp; </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblAddrPhone %>: </td>
                                                <td>
                                                    <telerik:RadTextBox ID="Phone" Text='<%# Bind("Phone") %>' runat="server" Width="300px"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblAddrEmail %>: </td>
                                                <td>
                                                    <telerik:RadTextBox ID="Email" Text='<%# Bind("Email") %>' runat="server" Width="300px"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblAddrWWW %>: </td>
                                                <td>
                                                    <telerik:RadTextBox ID="WWW" Text='<%# Bind("WWW") %>' runat="server" Width="300px"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="vertical-align: top;">&nbsp; </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="padding-right: 12px;">
                                        <asp:ValidationSummary ID="ValidationSummary3" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' ShowMessageBox="true" 
                                                               ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true" ValidationGroup="Company" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp; </td>
                                    <td>&nbsp; </td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="2">
                                        <telerik:RadButton ID="RadButton8" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionSave %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' CommandArgument="NoExit" Icon-PrimaryIconCssClass="rbSave" ValidationGroup="Company">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="RadButton17" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblInsertAndClose : Resources.Resource.lblUpdateAndClose %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' Icon-PrimaryIconCssClass="rbOk" ValidationGroup="Company">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="RadButton18" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                           CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                        </telerik:RadButton>

                                        <telerik:RadButton ID="RadButton10" Text='<%# Resources.Resource.lblRequestBp %>' runat="server" CausesValidation="False" 
                                            Visible='<%# (Container is GridEditFormInsertItem || Convert.ToInt32(Eval("StatusID")) != 20) ? false : true %>' OnClientClicked='<%# String.Concat("function (button,args){openRadWindow(", Eval("CompanyID"), "); return false;}") %>'>
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
                                        <table id="Table5" cellspacing="2" cellpadding="2" border="0" style="vertical-align: top; text-align: left;">
                                            <tr>
                                                <td>
                                                    <asp:HiddenField ID="HiddenField2" runat="server" Value='<%# Eval("CompanyID") %>'></asp:HiddenField>
                                                    <asp:Label runat="server" ID="Label8" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblNameVisible, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" ID="Label6" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("NameVisible") %>' Width="300px"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="Label9" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblNameAdditional, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:Label runat="server" ID="Label7" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("NameAdditional") %>' Width="300px"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp; </td>
                                                <td>&nbsp; </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblTradeAssociation %>: </td>
                                                <td>
                                                    <telerik:RadTextBox ID="TradeAssociation" Text='<%# Bind("TradeAssociation") %>' runat="server" Width="300px"></telerik:RadTextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap="nowrap">
                                                    <asp:Label runat="server" ID="LabelMinWageAttestation" Text='<%# String.Concat(Resources.Resource.lblMinWageAttestation, ":") %>'></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:CheckBox CssClass="cb" runat="server" ID="MinWageAttestation"></asp:CheckBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblUserAdminCompanyData %>: </td>
                                                <td>
                                                    <telerik:RadComboBox runat="server" ID="UserID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataSourceID="SqlDataSource_Users"
                                                                         DataValueField="UserID" DataTextField="LastName" Width="300" Filter="Contains"
                                                                         AppendDataBoundItems="true" DropDownAutoWidth="Enabled">
                                                        <ItemTemplate>
                                                            <table cellpadding="2px" style="text-align: left;">
                                                                <tr>
                                                                    <td style="text-align: left;">
                                                                        <asp:Label Text='<%# String.Concat(Eval("LastName"), ", ") %>' runat="server">
                                                                        </asp:Label>
                                                                    </td>
                                                                    <td style="text-align: left;">
                                                                        <asp:Label Text='<%# String.Concat(Eval("FirstName"), ", ") %>' runat="server">
                                                                        </asp:Label>
                                                                    </td>
                                                                    <td style="text-align: left;">
                                                                        <asp:Label Text='<%# String.Concat(Eval("Company"), ", ") %>' runat="server">
                                                                        </asp:Label>
                                                                    </td>
                                                                    <td style="text-align: left;">
                                                                        <asp:Label Text='<%# Eval("Email") %>' runat="server">
                                                                        </asp:Label>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </ItemTemplate>
                                                        <Items>
                                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                                                        </Items>
                                                    </telerik:RadComboBox>
                                                    <telerik:RadButton runat="server" ID="btnMasterUser" ButtonType="LinkButton" NavigateUrl='<%# String.Concat("/InSiteApp/Views/Central/Users.aspx?ID=", Eval("UserID"), "&Action=3") %>' Text="<%# Resources.Resource.lblUsers %>"></telerik:RadButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="padding-right: 12px;">
                                        <asp:ValidationSummary ID="ValidationSummary1" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' ShowMessageBox="true" 
                                                               ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true" ValidationGroup="Company" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp; </td>
                                    <td>&nbsp; </td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="2">
                                        <telerik:RadButton ID="RadButton1" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionSave %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' CommandArgument="NoExit" Icon-PrimaryIconCssClass="rbSave" ValidationGroup="Company">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="RadButton3" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblInsertAndClose : Resources.Resource.lblUpdateAndClose %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' Icon-PrimaryIconCssClass="rbOk" ValidationGroup="Company">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="RadButton5" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                           CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                        </telerik:RadButton>
                                    </td>
                                </tr>
                            </table>
                        </telerik:RadPageView>

                        <%-- Info --%>
                        <telerik:RadPageView ID="RadPageView3" runat="server">
                            <table id="Table10" cellspacing="2" cellpadding="2" border="0" rules="none" class="EditFormTable">
                                <tr>
                                    <td>
                                        <asp:HiddenField ID="HiddenField1" runat="server" Value='<%# Eval("CompanyID") %>'></asp:HiddenField>
                                        <asp:Label runat="server" ID="Label2" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblNameVisible, ":") %>'></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label runat="server" ID="Label3" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("NameVisible") %>' Width="300px"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" ID="Label14" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblNameAdditional, ":") %>'></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label runat="server" ID="Label15" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("NameAdditional") %>' Width="300px"></asp:Label>
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
                                <tr>
                                    <td>
                                        <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblRequestFrom, ":") %>'></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("RequestFrom")%>'></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblRequestOn, ":") %>'></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("RequestOn")%>'></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblReleaseFrom, ":") %>'></asp:Label>
                                    </td>
                                    <td>
                                        <telerik:RadTextBox runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' ID="ReleaseFrom" Text='<%# Bind("ReleaseFrom")%>' Enabled="false"></telerik:RadTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblReleaseOn, ":") %>'></asp:Label>
                                    </td>
                                    <td>
                                        <telerik:RadTextBox runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' ID="ReleaseOn" Text='<%# Bind("ReleaseOn")%>' Enabled="false"></telerik:RadTextBox>

                                        <telerik:RadButton ID="ReleaseIt" runat="server" Text="<%$ Resources:Resource, lblActionRelease %>" CommandName="ReleaseIt" CausesValidation="false" 
                                                           CommandArgument='<%# Eval("CompanyID") %>' Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></telerik:RadButton>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblLockedFrom, ":") %>'></asp:Label>
                                    </td>
                                    <td>
                                        <telerik:RadTextBox runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' ID="LockedFrom" Text='<%# Bind("LockedFrom")%>' Enabled="false"></telerik:RadTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblLockedOn, ":") %>'></asp:Label>
                                    </td>
                                    <td>
                                        <telerik:RadTextBox runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' ID="LockedOn" Text='<%# Bind("LockedOn")%>' Enabled="false"></telerik:RadTextBox>

                                        <telerik:RadButton ID="LockIt" runat="server" Text="<%$ Resources:Resource, lblActionLock %>" CommandName="LockIt" CausesValidation="false" 
                                                           CommandArgument='<%# Eval("CompanyID") %>' Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></telerik:RadButton>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="padding-right: 12px;">
                                        <asp:ValidationSummary ID="ValidationSummary5" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' ShowMessageBox="true" 
                                                               ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true" ValidationGroup="Company" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp; </td>
                                    <td>&nbsp; </td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="2">
                                        <telerik:RadButton ID="RadButton6" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionSave %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' CommandArgument="NoExit" Icon-PrimaryIconCssClass="rbSave" ValidationGroup="Company">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="RadButton7" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblInsertAndClose : Resources.Resource.lblUpdateAndClose %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' Icon-PrimaryIconCssClass="rbOk" ValidationGroup="Company">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="RadButton9" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                           CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                        </telerik:RadButton>
                                    </td>
                                </tr>
                            </table>

                            <asp:SqlDataSource ID="SqlDataSource_Users" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                               SelectCommand="SELECT DISTINCT m_u.SystemID, m_u.UserID, m_u.FirstName, m_u.LastName, m_u.CompanyID, m_u.LoginName, m_u.Password, m_u.RoleID, m_u.LanguageID, m_u.SkinName, m_u.Email, m_u.SessionID, m_u.IsVisible, m_u.CreatedFrom, m_u.CreatedOn, m_u.EditFrom, m_u.EditOn, s_c.NameVisible AS Company, m_u.BpID, m_u.ReleaseFrom, m_u.ReleaseOn, m_u.LockedFrom, m_u.LockedOn FROM Master_Roles AS m_r RIGHT OUTER JOIN Master_UserBuildingProjects AS m_ubp ON m_r.SystemID = m_ubp.SystemID AND m_r.BpID = m_ubp.BpID AND m_r.RoleID = m_ubp.RoleID RIGHT OUTER JOIN Master_Users AS m_u ON m_ubp.SystemID = m_u.SystemID AND m_ubp.UserID = m_u.UserID LEFT OUTER JOIN System_Companies AS s_c ON m_u.SystemID = s_c.SystemID AND m_u.CompanyID = s_c.CompanyID WHERE (m_u.SystemID = @SystemID) AND (m_r.TypeID <= @UserType OR m_r.TypeID IS NULL) AND (m_u.CompanyID = @CompanyID) ORDER BY m_u.LastName, m_u.FirstName, Company">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                    <asp:SessionParameter SessionField="UserType" DefaultValue="0" Name="UserType"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="CompanyID" PropertyName="Text" DefaultValue="0" Name="CompanyID"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </telerik:RadPageView>

                        <%-- Tariff Contracts --%>
                        <telerik:RadPageView ID="RadPageView4" runat="server">
                            <table id="Table6" cellspacing="2" cellpadding="2" border="0" rules="none" class="EditFormTable">
                                <tr>
                                    <td>
                                        <asp:HiddenField ID="CompanyID1" runat="server" Value='<%# Eval("CompanyID") %>'></asp:HiddenField>
                                        <asp:Label runat="server" ID="Label4" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblNameVisible, ":") %>'></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label runat="server" ID="Label5" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("NameVisible") %>' Width="300px"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" ID="Label16" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblNameAdditional, ":") %>'></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label runat="server" ID="Label17" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("NameAdditional") %>' Width="300px"></asp:Label>
                                    </td>
                                </tr>
                            </table>

                            <br />
                            <asp:Label runat="server" ID="LabelRadGridTariffs" Font-Bold="true" Text='<%# String.Concat(Resources.Resource.lblTariffContracts, ":") %>'></asp:Label>
                            <br />
                            <telerik:RadGrid ID="RadGridTariffs" runat="server" DataSourceID="SqlDataSource_CompanyTariffs" EnableLinqExpressions="false" EnableHierarchyExpandAll="true"
                                             CssClass="RadGrid" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" GroupPanelPosition="Top"
                                             OnItemInserted="RadGridTariffs_ItemInserted" OnPreRender="RadGridTariffs_PreRender" OnItemCreated="RadGridTariffs_ItemCreated"
                                             OnItemDeleted="RadGridTariffs_ItemDeleted" OnItemUpdated="RadGridTariffs_ItemUpdated" OnItemCommand="RadGridTariffs_ItemCommand">

                                <ValidationSettings ValidationGroup="Tariff" EnableValidation="false" CommandsToValidate="PerformUpdate,Insert" />

                                <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false">
                                    <Resizing AllowColumnResize="true"></Resizing>
                                    <Selecting AllowRowSelect="True" />
                                    <ClientEvents OnRowClick="OnRowClick" OnKeyPress="GridKeyPress" />
                                </ClientSettings>

                                <SortingSettings SortedBackColor="Transparent" />

                                <MasterTableView DataSourceID="SqlDataSource_CompanyTariffs" DataKeyNames="SystemID,TariffScopeID,CompanyID" EnableHierarchyExpandAll="true" 
                                                 AutoGenerateColumns="False" CommandItemDisplay="Top" HierarchyLoadMode="Conditional" AllowMultiColumnSorting="true" AllowPaging="true" 
                                                 CssClass="MasterClass" EditMode="EditForms">

                                    <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="false" PageSizes="10,20,50" />

                                    <EditFormSettings >
                                        <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                                        <EditColumn ButtonType="ImageButton" UniqueName="EditColumn2" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                                                    EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                                        <FormTableStyle CellPadding="3" CellSpacing="3" />
                                    </EditFormSettings>

                                    <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="False" ShowExportToExcelButton="True" ShowExportToPdfButton="False"
                                                         AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                                    <%-- Tariff Scope Details--%>
                                    <NestedViewTemplate>
                                        <fieldset style="padding: 10px; width: 500px; margin-left: 10px; margin-bottom: 10px;">
                                            <legend style="padding: 5px; background-color: transparent;">
                                                <b><%= Resources.Resource.lblDetailsFor%> <%# String.Concat(Eval("NameVisibleTariff").ToString(), " ", Resources.Resource.lblValidFrom.ToLower(), " ", Eval("ValidFrom", "{0:d}")) %></b>
                                            </legend>
                                            <table style="width: 100%;">
                                                <tr>
                                                    <td><%= Resources.Resource.lblTariff%>: </td>
                                                    <td>
                                                        <asp:Label Text='<%#Eval("NameVisibleTariff")%>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblTariffContract%>: </td>
                                                    <td>
                                                        <asp:Label Text='<%#Eval("NameVisibleContract")%>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblTariffScope%>: </td>
                                                    <td>
                                                        <asp:Label Text='<%#Eval("NameVisible")%>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblDescriptionShort%>: </td>
                                                    <td>
                                                        <asp:Label Text='<%#Eval("DescriptionShort")%>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblValidFrom%>: </td>
                                                    <td>
                                                        <asp:Label Text='<%#Eval("ValidFrom", "{0:d}")%>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp;</td>
                                                    <td>&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblCreatedFrom%>: </td>
                                                    <td>
                                                        <asp:Label Text='<%#Eval("CreatedFrom")%>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblCreatedOn%>: </td>
                                                    <td>
                                                        <asp:Label Text='<%#Eval("CreatedOn")%>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblEditFrom%>: </td>
                                                    <td>
                                                        <asp:Label Text='<%#Eval("EditFrom")%>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblEditOn%>: </td>
                                                    <td>
                                                        <asp:Label Text='<%#Eval("EditOn")%>' runat="server"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </fieldset>
                                    </NestedViewTemplate>

                                    <%-- Scope Columns --%>
                                    <Columns>
                                        <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                                                       UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                                            <ItemStyle BackColor="Control" Width="30px" />
                                            <HeaderStyle Width="30px" />
                                        </telerik:GridEditCommandColumn>

                                        <telerik:GridTemplateColumn DataField="TariffScopeID" DataType="System.Int32" Visible="false" FilterControlAltText="Filter TariffScopeID column" HeaderText="<%$ Resources:Resource, lblTariffScope %>"
                                                                    SortExpression="TariffScopeID" UniqueName="TariffScopeID" InsertVisiblityMode="AlwaysVisible">
                                            <InsertItemTemplate>
                                                <telerik:RadComboBox runat="server" ID="TariffScopeID" SelectedValue='<%# Bind("TariffScopeID") %>' EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"  
                                                                     DataSourceID="SqlDataSource_TariffScopes" DataValueField="TariffScopeID" DataTextField="Description" Width="280px" 
                                                                     Filter="Contains" AppendDataBoundItems="true" DropDownAutoWidth="Enabled" OnItemDataBound="TariffScopeID_ItemDataBound">
                                                    <ItemTemplate>
                                                        <table cellpadding="3px" style="text-align: left;">
                                                            <tr>
                                                                <td style="text-align: left;">
                                                                    <asp:Label ID="Label10" Text='<%# Eval("TariffNameVisible") %>' runat="server">
                                                                    </asp:Label>
                                                                </td>
                                                                <td style="text-align: left;">
                                                                    <asp:Label ID="Label11" Text='<%# Eval("ContractNameVisible") %>' runat="server">
                                                                    </asp:Label>
                                                                </td>
                                                                <td style="text-align: left;">
                                                                    <asp:Label ID="Label12" Text='<%# Eval("ValidFrom", "{0:d}") %>' runat="server">
                                                                    </asp:Label>
                                                                </td>
                                                                <td style="text-align: left;">
                                                                    <asp:Label ID="Label13" Text='<%# Eval("ValidTo", "{0:d}") %>' runat="server">
                                                                    </asp:Label>
                                                                </td>
                                                                <td style="text-align: left;">
                                                                    <asp:Label ID="ItemNameVisible" Text='<%# Eval("NameVisible") %>' runat="server">
                                                                    </asp:Label>
                                                                </td>
                                                                <td style="text-align: left;">
                                                                    <asp:Label ID="ItemDescriptionShort" Text='<%# Eval("DescriptionShort") %>' runat="server">
                                                                    </asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </ItemTemplate>
                                                </telerik:RadComboBox>
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="TariffScopeID" ErrorMessage="<%$ Resources:Resource, msgTariffScopeIDObligate %>" Text="*" 
                                                                            SetFocusOnError="true" ForeColor="Red">
                                                </asp:RequiredFieldValidator>
                                            </InsertItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridTemplateColumn DataField="NameVisibleTariff" HeaderText="<%$ Resources:Resource, lblTariff %>" SortExpression="NameVisibleTariff"
                                                                    UniqueName="NameVisibleTariff" GroupByExpression="NameVisibleTariff NameVisibleTariff GROUP BY NameVisibleTariff" InsertVisiblityMode="AlwaysHidden">
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="NameVisibleTariff" Text='<%# Eval("NameVisibleTariff") %>'></asp:Label>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridTemplateColumn DataField="NameVisibleContract" HeaderText="<%$ Resources:Resource, lblTariffContract %>" SortExpression="NameVisibleContract"
                                                                    UniqueName="NameVisibleContract" GroupByExpression="NameVisibleContract NameVisibleContract GROUP BY NameVisibleContract" InsertVisiblityMode="AlwaysHidden">
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="NameVisibleContract" Text='<%# Eval("NameVisibleContract") %>'></asp:Label>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridTemplateColumn DataField="NameVisible" HeaderText="<%$ Resources:Resource, lblTariffScope %>" SortExpression="NameVisible" UniqueName="NameVisible1"
                                                                    GroupByExpression="NameVisible NameVisible GROUP BY NameVisible" InsertVisiblityMode="AlwaysHidden">
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="NameVisible1" Text='<%# Eval("NameVisible") %>'></asp:Label>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridTemplateColumn DataField="DescriptionShort" FilterControlAltText="Filter DescriptionShort column" HeaderText="<%$ Resources:Resource, lblDescriptionShort %>"
                                                                    SortExpression="DescriptionShort" UniqueName="DescriptionShort" InsertVisiblityMode="AlwaysHidden"
                                                                    GroupByExpression="DescriptionShort DescriptionShort GROUP BY DescriptionShort">
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="LabelDescriptionShort" Text='<%# Eval("DescriptionShort") %>'></asp:Label>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridTemplateColumn DataField="ValidFrom" DataType="System.DateTime" FilterControlAltText="Filter ValidFrom column" HeaderText="<%$ Resources:Resource, lblValidFrom %>"
                                                                    SortExpression="ValidFrom" UniqueName="ValidFrom" GroupByExpression="ValidFrom ValidFrom GROUP BY ValidFrom">
                                            <EditItemTemplate>
                                                <telerik:RadDatePicker ID="ValidFrom" runat="server" DbSelectedDate='<%# Bind("ValidFrom") %>' MaxDate="2100/1/1" EnableShadows="true"
                                                                       ShowPopupOnFocus="true">
                                                    <Calendar runat="server">
                                                        <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                                                TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                                        </FastNavigationSettings>
                                                    </Calendar>
                                                </telerik:RadDatePicker>
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="ValidFrom" ErrorMessage="<%$ Resources:Resource, msgValidFromObligate %>" Text="*" 
                                                                            SetFocusOnError="true" ForeColor="Red">
                                                </asp:RequiredFieldValidator>
                                            </EditItemTemplate>
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="LabelValidFrom" Text='<%# Eval("ValidFrom", "{0:d}") %>'></asp:Label>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridTemplateColumn DataField="CreatedFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedFrom column"
                                                                    HeaderText="<%$ Resources:Resource, lblCreatedFrom %>" SortExpression="CreatedFrom" UniqueName="CreatedFrom" Visible="False">
                                            <ItemTemplate>
                                                <asp:Label ID="CreatedFromLabel" runat="server" Text='<%# Eval("CreatedFrom")%>'></asp:Label>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridTemplateColumn DataField="CreatedOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedOn column"
                                                                    HeaderText="<%$ Resources:Resource, lblCreatedOn %>" SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="False">
                                            <ItemTemplate>
                                                <asp:Label ID="CreatedOnLabel" runat="server" Text='<%# Eval("CreatedOn")%>'></asp:Label>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridTemplateColumn DataField="EditFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditFrom column"
                                                                    HeaderText="<%$ Resources:Resource, lblEditFrom %>" SortExpression="EditFrom" UniqueName="EditFrom" Visible="False">
                                            <ItemTemplate>
                                                <asp:Label ID="EditFromLabel" runat="server" Text='<%# Eval("EditFrom")%>'></asp:Label>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridTemplateColumn DataField="EditOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditOn column"
                                                                    HeaderText="<%$ Resources:Resource, lblEditOn %>" SortExpression="EditOn" UniqueName="EditOn" Visible="False">
                                            <ItemTemplate>
                                                <asp:Label ID="EditOnLabel" runat="server" Text='<%# Eval("EditOn") %>'></asp:Label>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridTemplateColumn HeaderText="<%$ Resources:Resource, lblHint %>">
                                            <EditItemTemplate>
                                                <asp:ValidationSummary ID="ValidationSummary2" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' 
                                                                       ShowMessageBox="true" ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true" />
                                            </EditItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridButtonColumn  ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" ConfirmDialogType="RadWindow" Visible="false"
                                                                   ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px" />
                                    </Columns>

                                </MasterTableView>

                            </telerik:RadGrid>
                            <asp:CustomValidator runat="server" ID="ValidatorRadGridTariffs" Text="*" SetFocusOnError="true" ForeColor="Red" ValidationGroup="Company"  
                                                 ErrorMessage="<%$ Resources:Resource, msgTariffScopeIDObligate %>" OnServerValidate="ValidatorRadGridTariffs_ServerValidate" >
                            </asp:CustomValidator>
                            <table>
                                <tr>
                                    <td colspan="2" style="padding-right: 12px;">
                                        <asp:ValidationSummary ID="ValidationSummary4" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' ShowMessageBox="true" 
                                                               ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true" ValidationGroup="Company" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp; </td>
                                    <td>&nbsp; </td>
                                </tr>
                                <tr>
                                    <td align="left" colspan="2">
                                        <telerik:RadButton ID="btnUpdateTariffsNoExit" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionSave %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' CommandArgument="NoExit" Icon-PrimaryIconCssClass="rbSave" ValidationGroup="Company">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="btnUpdateTariffs" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblInsertAndClose : Resources.Resource.lblUpdateAndClose %>'
                                                           runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' Icon-PrimaryIconCssClass="rbOk" ValidationGroup="Company">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="btnCancelTariffs" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                           CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                        </telerik:RadButton>
                                    </td>
                                </tr>
                            </table>

                            <asp:SqlDataSource ID="SqlDataSource_TariffScopes" runat="server" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                                               SelectCommand="SELECT t.NameVisible AS TariffNameVisible, c.NameVisible AS ContractNameVisible, c.ValidFrom, c.ValidTo, s.NameVisible, s.DescriptionShort, s.TariffScopeID, t.NameVisible + ', '  + c.NameVisible + ', ' + s.NameVisible AS Description FROM System_Tariffs AS t INNER JOIN System_TariffContracts AS c ON t.SystemID = c.SystemID AND t.TariffID = c.TariffID INNER JOIN System_TariffScopes AS s ON c.SystemID = s.SystemID AND c.TariffID = s.TariffID AND c.TariffContractID = s.TariffContractID WHERE (t.SystemID = @SystemID) AND (c.ValidTo >= SYSDATETIME()) ORDER BY TariffNameVisible, ContractNameVisible, s.NameVisible">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource runat="server" ID="SqlDataSource_CompanyTariffs" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                                               OldValuesParameterFormatString="original_{0}"
                                               DeleteCommand="DELETE FROM [System_CompanyTariffs] WHERE [SystemID] = @original_SystemID AND [TariffScopeID] = @original_TariffScopeID AND [CompanyID] = @original_CompanyID"
                                               InsertCommand="INSERT INTO System_CompanyTariffs(SystemID, TariffScopeID, CompanyID, ValidFrom, CreatedFrom, CreatedOn, EditFrom, EditOn) VALUES (@SystemID, @TariffScopeID, @CompanyID, @ValidFrom, @UserName, SYSDATETIME(), @UserName, SYSDATETIME());
                                               SELECT @ReturnValue = SCOPE_IDENTITY(); 
                                               INSERT INTO Master_CompanyTariffs(SystemID, BpID, TariffScopeID, CompanyID, ValidFrom, CreatedFrom, CreatedOn, EditFrom, EditOn) 
                                               SELECT SystemID, BpID, dbo.BestTariffScope(@SystemID, BpID, @TariffScopeID), CompanyID, @ValidFrom, @UserName, SYSDATETIME(), @UserName, SYSDATETIME() 
                                               FROM Master_Companies 
                                               WHERE SystemID = @SystemID AND CompanyCentralID = @CompanyID
                                               AND NOT EXISTS (SELECT 1 FROM Master_CompanyTariffs m_ct WHERE m_ct.SystemID = @SystemID AND m_ct.CompanyID = @CompanyID AND m_ct.TariffScopeID = dbo.BestTariffScope(@SystemID, BpID, @TariffScopeID))"
                                               SelectCommand="SELECT s_ct.SystemID, s_ct.TariffScopeID, s_ct.CompanyID, s_ct.ValidFrom, s_ct.CreatedFrom, s_ct.CreatedOn, s_ct.EditFrom, s_ct.EditOn, s_ts.NameVisible, s_ts.DescriptionShort, s_tc.NameVisible AS NameVisibleContract, s_t.NameVisible AS NameVisibleTariff FROM System_CompanyTariffs AS s_ct INNER JOIN System_TariffScopes AS s_ts ON s_ct.SystemID = s_ts.SystemID AND s_ct.TariffScopeID = s_ts.TariffScopeID INNER JOIN System_TariffContracts AS s_tc ON s_ts.SystemID = s_tc.SystemID AND s_ts.TariffID = s_tc.TariffID AND s_ts.TariffContractID = s_tc.TariffContractID INNER JOIN System_Tariffs AS s_t ON s_tc.SystemID = s_t.SystemID AND s_tc.TariffID = s_t.TariffID WHERE (s_ct.SystemID = @SystemID) AND (s_ct.CompanyID = @CompanyID) ORDER BY s_ct.ValidFrom DESC"
                                               UpdateCommand="UPDATE [System_CompanyTariffs] SET [ValidFrom] = @ValidFrom, [EditFrom] = @UserName, [EditOn] = SYSDATETIME() WHERE [SystemID] = @original_SystemID AND [TariffScopeID] = @original_TariffScopeID AND [CompanyID] = @original_CompanyID">
                                <DeleteParameters>
                                    <asp:Parameter Name="original_SystemID" Type="Int32"></asp:Parameter>
                                    <asp:Parameter Name="original_TariffScopeID" Type="Int32"></asp:Parameter>
                                    <asp:Parameter Name="original_CompanyID" Type="Int32"></asp:Parameter>
                                </DeleteParameters>
                                <InsertParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
                                    <asp:Parameter Name="TariffScopeID"></asp:Parameter>
                                    <asp:ControlParameter ControlID="CompanyID1" PropertyName="Value" DefaultValue="0" Name="CompanyID" Type="Int32"></asp:ControlParameter>
                                    <asp:Parameter Name="ValidFrom"></asp:Parameter>
                                    <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
                                    <asp:Parameter Name="ReturnValue" />
                                </InsertParameters>
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
                                    <asp:ControlParameter ControlID="CompanyID1" PropertyName="Value" DefaultValue="0" Name="CompanyID" Type="Int32"></asp:ControlParameter>
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:Parameter DbType="Date" Name="ValidFrom"></asp:Parameter>
                                    <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
                                    <asp:Parameter Name="original_SystemID" Type="Int32"></asp:Parameter>
                                    <asp:Parameter Name="original_TariffScopeID" Type="Int32"></asp:Parameter>
                                    <asp:Parameter Name="original_CompanyID" Type="Int32"></asp:Parameter>
                                </UpdateParameters>
                            </asp:SqlDataSource>
                        </telerik:RadPageView>
                    </telerik:RadMultiPage>
                </FormTemplate>
            </EditFormSettings>

            <%--#################################################################################### View Template ########################################################################################################--%>

            <NestedViewTemplate>
                <asp:Panel runat="server" ID="InnerContainer" Visible="false">

                    <div style="background-color: InactiveBorder;">
                        <telerik:RadTabStrip ID="RadTabStrip1" runat="server" MultiPageID="RadMultiPage1" Align="Left" AutoPostBack="true" CausesValidation="false">
                            <Tabs>
                                <telerik:RadTab PageViewID="RadPageView1" ImageUrl="~/Resources/Icons/factory.png" Text="<%# Resources.Resource.lblGenerally %>" Selected="true" Font-Bold="true" Value="1" />
                                <telerik:RadTab PageViewID="RadPageView2" ImageUrl="~/Resources/Icons/list-add-5.png" Text="<%# Resources.Resource.lblAdvanced %>" Font-Bold="true" Value="2" />
                                <telerik:RadTab PageViewID="RadPageView3" ImageUrl="~/Resources/Icons/info.png" Text="<%# Resources.Resource.lblInfo %>" Font-Bold="true" Value="3" />
                                <telerik:RadTab PageViewID="RadPageView4" ImageUrl="~/Resources/Icons/Contract.png" Text="<%# Resources.Resource.lblTariffContracts %>" Font-Bold="true" Value="4" />
                            </Tabs>
                        </telerik:RadTabStrip>

                        <telerik:RadMultiPage ID="RadMultiPage1" runat="server" RenderSelectedPageOnly="true">
                            <%-- Generally --%>
                            <telerik:RadPageView ID="RadPageView1" runat="server" Selected="true">
                                <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                                    <table id="Table2" cellspacing="5" cellpadding="5" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                                        <tr>
                                            <td style="vertical-align: top;">
                                                <table id="Table3" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="Label1" Text='<%# String.Concat(Resources.Resource.lblID, ":") %>'></asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:Label runat="server" ID="CompanyID" Text='<%# Eval("CompanyID") %>'></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><%= Resources.Resource.lblNameVisible %>: </td>
                                                        <td>
                                                            <asp:Label ID="NameVisible" Text='<%# Eval("NameVisible") %>' runat="server" Width="300px"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><%= Resources.Resource.lblNameAdditional %>: </td>
                                                        <td>
                                                            <asp:Label ID="NameAdditional" Text='<%# Eval("NameAdditional") %>' runat="server" Width="300px"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp; </td>
                                                        <td>
                                                            <asp:HiddenField ID="AddressID" runat="server" Value='<%# Eval("AddressID") %>'></asp:HiddenField>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><%= Resources.Resource.lblAddress1 %>: </td>
                                                        <td>
                                                            <asp:Label ID="Address1" Text='<%# Eval("Address1") %>' runat="server" Width="300px"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><%= Resources.Resource.lblAddress2 %>: </td>
                                                        <td>
                                                            <asp:Label ID="Address2" Text='<%# Eval("Address2") %>' runat="server" Width="300px"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><%= Resources.Resource.lblAddrZip %>: </td>
                                                        <td>
                                                            <asp:Label ID="Zip" Text='<%# Eval("Zip") %>' runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><%= Resources.Resource.lblAddrCity %>: </td>
                                                        <td>
                                                            <asp:Label ID="City" Text='<%# Eval("City") %>' runat="server" Width="300px"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><%= Resources.Resource.lblAddrState %>: </td>
                                                        <td>
                                                            <asp:Label ID="State" Text='<%# Eval("State") %>' runat="server" Width="300px"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><%= Resources.Resource.lblCountry %>: </td>
                                                        <td>
                                                            <asp:Label ID="CountryID" Text='<%# Eval("CountryID") %>' runat="server" Width="300px"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><%= Resources.Resource.lblAddrPhone %>: </td>
                                                        <td>
                                                            <asp:Label ID="Phone" Text='<%# Eval("Phone") %>' runat="server" Width="300px"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><%= Resources.Resource.lblAddrEmail %>: </td>
                                                        <td>
                                                            <asp:Label ID="Email" Text='<%# Eval("Email") %>' runat="server" Width="300px"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><%= Resources.Resource.lblAddrWWW %>: </td>
                                                        <td>
                                                            <asp:Label ID="WWW" Text='<%# Eval("WWW") %>' runat="server" Width="300px"></asp:Label>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td style="vertical-align: top;">&nbsp; </td>
                                        </tr>
                                        <tr>
                                            <td align="left" colspan="2">
                                                <telerik:RadButton ID="RadButton2" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                                   CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                                </telerik:RadButton>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </telerik:RadPageView>

                            <%-- Advanced --%>
                            <telerik:RadPageView ID="RadPageView2" runat="server">
                                <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                                    <table id="Table4" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top; text-align: left;">
                                        <tr>
                                            <td style="vertical-align: top;">
                                                <table id="Table5" cellspacing="2" cellpadding="2" border="0" style="vertical-align: top; text-align: left;">
                                                    <tr>
                                                        <td>
                                                            <asp:HiddenField ID="HiddenField2" runat="server" Value='<%# Eval("CompanyID") %>'></asp:HiddenField>
                                                            <asp:Label runat="server" ID="Label8" Text='<%# String.Concat(Resources.Resource.lblNameVisible, ":") %>'></asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:Label runat="server" ID="Label6" Text='<%# Eval("NameVisible") %>' Width="300px"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="Label9" Text='<%# String.Concat(Resources.Resource.lblNameAdditional, ":") %>'></asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:Label runat="server" ID="Label7" Text='<%# Eval("NameAdditional") %>' Width="300px"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp; </td>
                                                        <td>&nbsp; </td>
                                                    </tr>
                                                    <tr>
                                                        <td><%= Resources.Resource.lblTradeAssociation %>: </td>
                                                        <td>
                                                            <asp:Label ID="TradeAssociation" Text='<%# Eval("TradeAssociation") %>' runat="server" Width="300px"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td nowrap="nowrap">
                                                            <asp:Label runat="server" ID="LabelMinWageAttestation" Text='<%# String.Concat(Resources.Resource.lblMinWageAttestation, ":") %>'></asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:CheckBox CssClass="cb" runat="server" ID="MinWageAttestation" Checked='<%# Eval("MinWageAttestation") %>'></asp:CheckBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><%= Resources.Resource.lblUserAdminCompanyData %>: </td>
                                                        <td>
                                                            <telerik:RadComboBox runat="server" ID="UserID1" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataSourceID="SqlDataSource_Users1"
                                                                                 DataValueField="UserID" DataTextField="LastName" Width="300" Filter="Contains"
                                                                                 AppendDataBoundItems="true" DropDownAutoWidth="Enabled" Enabled="false">
                                                                <ItemTemplate>
                                                                    <table cellpadding="2px" style="text-align: left;">
                                                                        <tr>
                                                                            <td style="text-align: left;">
                                                                                <asp:Label Text='<%# String.Concat(Eval("LastName"), ", ") %>' runat="server">
                                                                                </asp:Label>
                                                                            </td>
                                                                            <td style="text-align: left;">
                                                                                <asp:Label Text='<%# String.Concat(Eval("FirstName"), ", ") %>' runat="server">
                                                                                </asp:Label>
                                                                            </td>
                                                                            <td style="text-align: left;">
                                                                                <asp:Label Text='<%# String.Concat(Eval("Company"), ", ") %>' runat="server">
                                                                                </asp:Label>
                                                                            </td>
                                                                            <td style="text-align: left;">
                                                                                <asp:Label Text='<%# Eval("Email") %>' runat="server">
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
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
                                        </tr>
                                        <tr>
                                            <td align="left" colspan="2">
                                                <telerik:RadButton ID="RadButton4" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                                   CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                                </telerik:RadButton>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </telerik:RadPageView>

                            <%-- Info --%>
                            <telerik:RadPageView ID="RadPageView3" runat="server">
                                <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                                    <table id="Table10" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="Label2" Text='<%# String.Concat(Resources.Resource.lblNameVisible, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="Label3" Text='<%# Eval("NameVisible") %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="Label14" Text='<%# String.Concat(Resources.Resource.lblNameAdditional, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="Label15" Text='<%# Eval("NameAdditional") %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
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
                                                <asp:Label runat="server" Text='<%# Eval("EditFrom")%>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEditOn, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# Eval("EditOn")%>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblRequestFrom, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# Eval("RequestFrom")%>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblRequestOn, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# Eval("RequestOn")%>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblReleaseFrom, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="ReleaseFrom" Text='<%# Eval("ReleaseFrom")%>' Enabled="false"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblReleaseOn, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="ReleaseOn" Text='<%# Eval("ReleaseOn")%>' Enabled="false"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblLockedFrom, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="LockedFrom" Text='<%# Eval("LockedFrom")%>' Enabled="false"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblLockedOn, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="LockedOn" Text='<%# Eval("LockedOn")%>' Enabled="false"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
                                        </tr>
                                        <tr>
                                            <td align="left" colspan="2">
                                                <telerik:RadButton ID="btnCancel" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                                   CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel"></telerik:RadButton>
                                            </td>
                                        </tr>
                                    </table>

                                    <asp:SqlDataSource ID="SqlDataSource_Users1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                                       SelectCommand="SELECT DISTINCT m_u.SystemID, m_u.UserID, m_u.FirstName, m_u.LastName, m_u.CompanyID, m_u.LoginName, m_u.Password, m_u.RoleID, m_u.LanguageID, m_u.SkinName, m_u.Email, m_u.SessionID, m_u.IsVisible, m_u.CreatedFrom, m_u.CreatedOn, m_u.EditFrom, m_u.EditOn, s_c.NameVisible AS Company, m_u.BpID, m_u.ReleaseFrom, m_u.ReleaseOn, m_u.LockedFrom, m_u.LockedOn FROM System_Companies AS s_c RIGHT OUTER JOIN Master_Users AS m_u ON s_c.SystemID = m_u.SystemID AND s_c.CompanyID = m_u.CompanyID WHERE (m_u.SystemID = @SystemID) AND (m_u.CompanyID = @CompanyID) ORDER BY m_u.LastName, m_u.FirstName, Company">
                                        <SelectParameters>
                                            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                            <asp:ControlParameter ControlID="CompanyID" PropertyName="Text" DefaultValue="0" Name="CompanyID"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </div>
                            </telerik:RadPageView>

                            <%-- Tariff Contracts --%>
                            <telerik:RadPageView ID="RadPageView4" runat="server">
                                <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                                    <table id="Table6" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                                        <tr>
                                            <td>
                                                <asp:HiddenField ID="CompanyID1" runat="server" Value='<%# Eval("CompanyID") %>'></asp:HiddenField>
                                                <asp:Label runat="server" ID="Label4" Text='<%# String.Concat(Resources.Resource.lblNameVisible, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="Label5" Text='<%# Eval("NameVisible") %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="Label16" Text='<%# String.Concat(Resources.Resource.lblNameAdditional, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="Label17" Text='<%# Eval("NameAdditional") %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>

                                    <br />
                                    <asp:Label runat="server" ID="LabelRadGridTariffs" Text='<%# String.Concat(Resources.Resource.lblTariffContracts, ":") %>'></asp:Label>
                                    <br />
                                    <telerik:RadGrid ID="RadGridTariffs" runat="server" DataSourceID="SqlDataSource_CompanyTariffs" EnableLinqExpressions="false" EnableHierarchyExpandAll="true"
                                                     CssClass="RadGrid" AllowAutomaticDeletes="false" AllowAutomaticInserts="false" AllowAutomaticUpdates="false" GroupPanelPosition="Top">

                                        <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false">
                                            <Resizing AllowColumnResize="true"></Resizing>
                                            <Selecting AllowRowSelect="True" />
                                            <ClientEvents OnRowClick="OnRowClick" OnKeyPress="GridKeyPress" />
                                        </ClientSettings>

                                        <SortingSettings SortedBackColor="Transparent" />

                                        <MasterTableView DataSourceID="SqlDataSource_CompanyTariffs" DataKeyNames="SystemID,TariffScopeID,CompanyID" EnableHierarchyExpandAll="true" 
                                                         AutoGenerateColumns="False" CommandItemDisplay="Top" HierarchyLoadMode="Conditional" AllowMultiColumnSorting="true" AllowPaging="true" 
                                                         CssClass="MasterClass" EditMode="EditForms">

                                            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="false" PageSizes="10,20,50" />

                                            <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="false" ShowExportToCsvButton="True" ShowExportToExcelButton="True" ShowExportToPdfButton="True"
                                                                 AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                                            <%-- Tariff Scope Details--%>
                                            <NestedViewTemplate>
                                                <fieldset style="padding: 10px; width: 500px; margin-left: 10px; margin-bottom: 10px;">
                                                    <legend style="padding: 5px; background-color: transparent;">
                                                        <b><%= Resources.Resource.lblDetailsFor%> <%# String.Concat(Eval("NameVisibleTariff").ToString(), " ", Resources.Resource.lblValidFrom.ToLower(), " ", Eval("ValidFrom", "{0:d}")) %></b>
                                                    </legend>
                                                    <table style="width: 100%;">
                                                        <tr>
                                                            <td><%= Resources.Resource.lblTariff%>: </td>
                                                            <td>
                                                                <asp:Label Text='<%#Eval("NameVisibleTariff")%>' runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><%= Resources.Resource.lblTariffContract%>: </td>
                                                            <td>
                                                                <asp:Label Text='<%#Eval("NameVisibleContract")%>' runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><%= Resources.Resource.lblTariffScope%>: </td>
                                                            <td>
                                                                <asp:Label Text='<%#Eval("NameVisible")%>' runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><%= Resources.Resource.lblDescriptionShort%>: </td>
                                                            <td>
                                                                <asp:Label Text='<%#Eval("DescriptionShort")%>' runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><%= Resources.Resource.lblValidFrom%>: </td>
                                                            <td>
                                                                <asp:Label Text='<%#Eval("ValidFrom", "{0:d}")%>' runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                        </tr>
                                                        <tr>
                                                            <td><%= Resources.Resource.lblCreatedFrom%>: </td>
                                                            <td>
                                                                <asp:Label Text='<%#Eval("CreatedFrom")%>' runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><%= Resources.Resource.lblCreatedOn%>: </td>
                                                            <td>
                                                                <asp:Label Text='<%#Eval("CreatedOn")%>' runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><%= Resources.Resource.lblEditFrom%>: </td>
                                                            <td>
                                                                <asp:Label Text='<%#Eval("EditFrom")%>' runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><%= Resources.Resource.lblEditOn%>: </td>
                                                            <td>
                                                                <asp:Label Text='<%#Eval("EditOn")%>' runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </fieldset>
                                            </NestedViewTemplate>

                                            <%-- Scope Columns --%>
                                            <Columns>
                                                <telerik:GridTemplateColumn DataField="NameVisibleTariff" HeaderText="<%$ Resources:Resource, lblTariff %>" SortExpression="NameVisibleTariff"
                                                                            UniqueName="NameVisibleTariff" GroupByExpression="NameVisibleTariff NameVisibleTariff GROUP BY NameVisibleTariff" InsertVisiblityMode="AlwaysHidden">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="NameVisibleTariff" Text='<%# Eval("NameVisibleTariff") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>

                                                <telerik:GridTemplateColumn DataField="NameVisibleContract" HeaderText="<%$ Resources:Resource, lblTariffContract %>" SortExpression="NameVisibleContract"
                                                                            UniqueName="NameVisibleContract" GroupByExpression="NameVisibleContract NameVisibleContract GROUP BY NameVisibleContract" InsertVisiblityMode="AlwaysHidden">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="NameVisibleContract" Text='<%# Eval("NameVisibleContract") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>

                                                <telerik:GridTemplateColumn DataField="NameVisible" HeaderText="<%$ Resources:Resource, lblTariffScope %>" SortExpression="NameVisible" UniqueName="NameVisible1"
                                                                            GroupByExpression="NameVisible NameVisible GROUP BY NameVisible" InsertVisiblityMode="AlwaysHidden">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="NameVisible1" Text='<%# Eval("NameVisible") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>

                                                <telerik:GridTemplateColumn DataField="DescriptionShort" FilterControlAltText="Filter DescriptionShort column" HeaderText="<%$ Resources:Resource, lblDescriptionShort %>"
                                                                            SortExpression="DescriptionShort" UniqueName="DescriptionShort" InsertVisiblityMode="AlwaysHidden"
                                                                            GroupByExpression="DescriptionShort DescriptionShort GROUP BY DescriptionShort">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="LabelDescriptionShort" Text='<%# Eval("DescriptionShort") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>

                                                <telerik:GridTemplateColumn DataField="ValidFrom" DataType="System.DateTime" FilterControlAltText="Filter ValidFrom column" HeaderText="<%$ Resources:Resource, lblValidFrom %>"
                                                                            SortExpression="ValidFrom" UniqueName="ValidFrom" GroupByExpression="ValidFrom ValidFrom GROUP BY ValidFrom">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="LabelValidFrom" Text='<%# Eval("ValidFrom", "{0:d}") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>

                                                <telerik:GridTemplateColumn DataField="CreatedFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedFrom column"
                                                                            HeaderText="<%$ Resources:Resource, lblCreatedFrom %>" SortExpression="CreatedFrom" UniqueName="CreatedFrom" Visible="False">
                                                    <ItemTemplate>
                                                        <asp:Label ID="CreatedFromLabel" runat="server" Text='<%# Eval("CreatedFrom")%>'></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>

                                                <telerik:GridTemplateColumn DataField="CreatedOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedOn column"
                                                                            HeaderText="<%$ Resources:Resource, lblCreatedOn %>" SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="False">
                                                    <ItemTemplate>
                                                        <asp:Label ID="CreatedOnLabel" runat="server" Text='<%# Eval("CreatedOn")%>'></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>

                                                <telerik:GridTemplateColumn DataField="EditFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditFrom column"
                                                                            HeaderText="<%$ Resources:Resource, lblEditFrom %>" SortExpression="EditFrom" UniqueName="EditFrom" Visible="False">
                                                    <ItemTemplate>
                                                        <asp:Label ID="EditFromLabel" runat="server" Text='<%# Eval("EditFrom")%>'></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>

                                                <telerik:GridTemplateColumn DataField="EditOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditOn column"
                                                                            HeaderText="<%$ Resources:Resource, lblEditOn %>" SortExpression="EditOn" UniqueName="EditOn" Visible="False">
                                                    <ItemTemplate>
                                                        <asp:Label ID="EditOnLabel" runat="server" Text='<%# Eval("EditOn") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                            </Columns>

                                        </MasterTableView>

                                    </telerik:RadGrid>
                                    <table>
                                        <tr>
                                            <td align="left" colspan="2">
                                                <telerik:RadButton ID="btnCancelTariffs" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                                   CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                                </telerik:RadButton>
                                            </td>
                                        </tr>
                                    </table>

                                    <asp:SqlDataSource ID="SqlDataSource_TariffScopes" runat="server" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                                                       SelectCommand="SELECT t.NameVisible AS TariffNameVisible, c.NameVisible AS ContractNameVisible, c.ValidFrom, c.ValidTo, s.NameVisible, s.DescriptionShort, s.TariffScopeID FROM System_Tariffs AS t INNER JOIN System_TariffContracts AS c ON t.SystemID = c.SystemID AND t.TariffID = c.TariffID INNER JOIN System_TariffScopes AS s ON c.SystemID = s.SystemID AND c.TariffID = s.TariffID AND c.TariffContractID = s.TariffContractID WHERE (t.SystemID = @SystemID) AND (c.ValidTo >= SYSDATETIME()) ORDER BY TariffNameVisible, ContractNameVisible, s.NameVisible">
                                        <SelectParameters>
                                            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>

                                    <asp:SqlDataSource runat="server" ID="SqlDataSource_CompanyTariffs" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                                                       SelectCommand="SELECT s_ct.SystemID, s_ct.TariffScopeID, s_ct.CompanyID, s_ct.ValidFrom, s_ct.CreatedFrom, s_ct.CreatedOn, s_ct.EditFrom, s_ct.EditOn, s_ts.NameVisible, s_ts.DescriptionShort, s_tc.NameVisible AS NameVisibleContract, s_t.NameVisible AS NameVisibleTariff FROM System_CompanyTariffs AS s_ct INNER JOIN System_TariffScopes AS s_ts ON s_ct.SystemID = s_ts.SystemID AND s_ct.TariffScopeID = s_ts.TariffScopeID INNER JOIN System_TariffContracts AS s_tc ON s_ts.SystemID = s_tc.SystemID AND s_ts.TariffID = s_tc.TariffID AND s_ts.TariffContractID = s_tc.TariffContractID INNER JOIN System_Tariffs AS s_t ON s_tc.SystemID = s_t.SystemID AND s_tc.TariffID = s_t.TariffID WHERE (s_ct.SystemID = @SystemID) AND (s_ct.CompanyID = @CompanyID) ORDER BY s_ct.ValidFrom DESC">
                                        <SelectParameters>
                                            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
                                            <asp:ControlParameter ControlID="CompanyID1" PropertyName="Value" DefaultValue="0" Name="CompanyID" Type="Int32"></asp:ControlParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </div>
                            </telerik:RadPageView>
                        </telerik:RadMultiPage>
                    </div>
                </asp:Panel>
            </NestedViewTemplate>

            <Columns>
                <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                               UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                    <ItemStyle BackColor="Control" Width="30px" />
                    <HeaderStyle Width="30px" />
                </telerik:GridEditCommandColumn>

                <telerik:GridTemplateColumn DataField="FirstChar" HeaderText="<%$ Resources:Resource, lblInitial %>" SortExpression="FirstChar" UniqueName="FirstChar"
                                            GroupByExpression="FirstChar FirstChar GROUP BY FirstChar" ForceExtractValue="Always" ItemStyle-Width="50px" HeaderStyle-Width="50px" 
                                            AllowFiltering="false" Display="false">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="FirstChar" Text='<%# Eval("FirstChar") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="StatusID" HeaderText="<%$ Resources:Resource, lblStatus %>" SortExpression="StatusID" UniqueName="StatusID" ItemStyle-HorizontalAlign="Center"
                                            GroupByExpression="StatusID StatusID GROUP BY StatusID" Visible="true" ForceExtractValue="Always" ItemStyle-Width="70px" HeaderStyle-Width="70px">
                    <ItemTemplate>
                        <asp:ImageButton runat="server" ID="ReleaseButton" />
                        <asp:HiddenField runat="server" ID="StatusID" Value='<%# Eval("StatusID") %>' />
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="StatusID" DataValueField="StatusID" Height="200px" AppendDataBoundItems="true" 
                                             SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("StatusID").CurrentFilterValue %>'
                                             runat="server" OnClientSelectedIndexChanged="StatusIDIndexChanged" DropDownAutoWidth="Enabled" Width="50px">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" Selected="true" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statCreated %>" Value="0" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statCreatedNotConfirmed %>" Value="5" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statLocked %>" Value="-10" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statWaitRelease %>" Value="10" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statReleased %>" Value="20" />
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

                <telerik:GridTemplateColumn DataField="CompanyID" DataType="System.Int32" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CompanyID column"
                                            HeaderText="<%$ Resources:Resource, lblID %>" SortExpression="CompanyID" UniqueName="CompanyID" Visible="false" ForceExtractValue="Always" 
                                            DefaultInsertValue="0">
                    <ItemTemplate>
                        <asp:Label ID="CompanyID" runat="server" Text='<%# Eval("CompanyID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="NameVisible" HeaderText="<%$ Resources:Resource, lblNameVisible %>" SortExpression="NameVisible" UniqueName="NameVisible"
                                            GroupByExpression="NameVisible NameVisible GROUP BY NameVisible" ForceExtractValue="Always" FilterControlWidth="80px" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="NameVisible" Text='<%# Eval("NameVisible") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="NameAdditional" HeaderText="<%$ Resources:Resource, lblNameAdditional %>" SortExpression="NameAdditional" UniqueName="NameAdditional"
                                            GroupByExpression="NameAdditional NameAdditional GROUP BY NameAdditional" ForceExtractValue="Always" FilterControlWidth="80px" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="NameAdditional" Text='<%# Eval("NameAdditional") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="AddressID" HeaderText="AddressID" SortExpression="AddressID" UniqueName="AddressID"
                                            GroupByExpression="AddressID AddressID GROUP BY AddressID" Visible="false" ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="AddressID" Text='<%# Eval("AddressID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Address1" HeaderText="<%$ Resources:Resource, lblAddress1 %>" SortExpression="Address1" UniqueName="Address1"
                                            GroupByExpression="Address1 Address1 GROUP BY Address1" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Address1" Text='<%# Eval("Address1") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Address2" HeaderText="<%$ Resources:Resource, lblAddress2 %>" SortExpression="Address2" UniqueName="Address2"
                                            GroupByExpression="Address2 Address2 GROUP BY Address2" Visible="false" ForceExtractValue="Always" FilterControlWidth="80px" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Address2" Text='<%# Eval("Address2") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Zip" HeaderText="<%$ Resources:Resource, lblAddrZip %>" SortExpression="Zip" UniqueName="Zip" ItemStyle-Width="90px" HeaderStyle-Width="90px"
                                            GroupByExpression="Zip Zip GROUP BY Zip" Visible="true" ForceExtractValue="Always" FilterControlWidth="50px" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Zip" Text='<%# Eval("Zip") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="City" HeaderText="<%$ Resources:Resource, lblAddrCity %>" SortExpression="City" UniqueName="City"
                                            GroupByExpression="City City GROUP BY City" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="City" Text='<%# Eval("City") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="State" HeaderText="<%$ Resources:Resource, lblAddrState %>" SortExpression="State" UniqueName="State"
                                            GroupByExpression="State State GROUP BY State" Visible="false" ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="State" Text='<%# Eval("State") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="CountryID" HeaderText="<%$ Resources:Resource, lblCountry %>" SortExpression="CountryID" UniqueName="CountryID" Visible="true" 
                                            ItemStyle-Height="20px" FilterControlWidth="80px" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains">
                    <ItemTemplate>
                        <table cellspacing="0" cellpadding="0" border="0" rules="none" style="border-style: none; height:24px; margin-bottom: -10px; margin-top: -3px">
                            <tr style="border-style: none; height:24px;">
                                <td style="border-style: none; height:24px; padding-right: 5px;">
                                    <asp:Image ID="ItemImage" ImageUrl='<%# String.Format("~/Resources/Icons/Flags/{0}", Eval("FlagName"))%>' Visible='<%# Eval("FlagName") != null %>' 
                                               Height="24px" Width="24px" runat="server" />
                                </td>
                                <td style="border-style: none; height:24px;">
                                    <asp:Label runat="server" ID="CountryName" Text='<%# Eval("CountryName") %>'></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="RadComboBoxCountryID" DataSourceID="SqlDataSource_Countries" DataTextField="CountryName"
                                             DataValueField="CountryID" Height="200px" AppendDataBoundItems="true" Filter="Contains"
                                             SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("CountryID").CurrentFilterValue %>'
                                             runat="server" OnClientSelectedIndexChanged="CountryIDIndexChanged" Width="110px">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock3" runat="server">
                            <script type="text/javascript">
                                function CountryIDIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    tableView.filter("CountryID", args.get_item().get_value(), "EqualTo");
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Phone" HeaderText="<%$ Resources:Resource, lblAddrPhone %>" SortExpression="Phone" UniqueName="Phone"
                                            GroupByExpression="Phone Phone GROUP BY Phone" Visible="false" ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Phone" Text='<%# Eval("Phone") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Email" HeaderText="<%$ Resources:Resource, lblAddrEmail %>" SortExpression="Email" UniqueName="Email"
                                            GroupByExpression="Email Email GROUP BY Email" Visible="false" ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Email" Text='<%# Eval("Email") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="WWW" HeaderText="<%$ Resources:Resource, lblAddrWWW %>" SortExpression="WWW" UniqueName="WWW"
                                            GroupByExpression="WWW WWW GROUP BY WWW" Visible="false" ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="WWW" Text='<%# Eval("WWW") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="TradeAssociation" HeaderText="<%$ Resources:Resource, lblTradeAssociation %>" SortExpression="TradeAssociation" UniqueName="TradeAssociation"
                                            GroupByExpression="TradeAssociation TradeAssociation GROUP BY TradeAssociation" Visible="false" ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:Label ID="TradeAssociation" runat="server" Text='<%# Eval("TradeAssociation") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridCheckBoxColumn DataField="MinWageAttestation" DefaultInsertValue="false" HeaderText="MinWageAttestation" Visible="false" UniqueName="MinWageAttestation" ReadOnly="true" ForceExtractValue="Always">
                </telerik:GridCheckBoxColumn>

                <telerik:GridTemplateColumn DataField="UserID" DataType="System.Int32" Visible="false" FilterControlAltText="Filter UserID column" HeaderText="<%$ Resources:Resource, lblUserAdminCompanyData %>"
                                            SortExpression="UserID" UniqueName="UserID" ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:Label ID="UserID" runat="server" Text='<%# Eval("UserID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="CreatedFrom" FilterControlAltText="Filter CreatedFrom column" HeaderText="<%$ Resources:Resource, lblCreatedFrom %>" SortExpression="CreatedFrom" UniqueName="CreatedFrom" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="CreatedFrom" runat="server" Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="CreatedOn" FilterControlAltText="Filter CreatedOn column" HeaderText="<%$ Resources:Resource, lblCreatedOn %>" SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="CreatedOn" runat="server" Text='<%# Eval("CreatedOn") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="EditFrom" FilterControlAltText="Filter EditFrom column" HeaderText="<%$ Resources:Resource, lblEditFrom %>" SortExpression="EditFrom" UniqueName="EditFrom" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="EditFrom" runat="server" Text='<%# Eval("EditFrom") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridDateTimeColumn FilterControlWidth="100px" DataField="EditOn" HeaderText="<%$ Resources:Resource, lblEditOn %>" SortExpression="EditOn"
                                            UniqueName="EditOn" PickerType="DatePicker" EnableRangeFiltering="true" HeaderStyle-Width="170px" ItemStyle-Width="170px" CurrentFilterFunction="Between" 
                                            AutoPostBackOnFilter="true" EnableTimeIndependentFiltering="true">
                </telerik:GridDateTimeColumn>

                <telerik:GridTemplateColumn DataField="RequestFrom" FilterControlAltText="Filter RequestFrom column" 
                                            HeaderText="<%$ Resources:Resource, lblRequestFrom %>" SortExpression="RequestFrom" UniqueName="RequestFrom" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="RequestFrom" runat="server" Text='<%# Eval("RequestFrom") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="RequestOn" FilterControlAltText="Filter RequestOn column" 
                                            HeaderText="<%$ Resources:Resource, lblRequestOn %>" SortExpression="RequestOn" UniqueName="RequestOn" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="RequestOn" runat="server" Text='<%# Eval("RequestOn") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="ReleaseFrom" FilterControlAltText="Filter ReleaseFrom column" 
                                            HeaderText="<%$ Resources:Resource, lblReleaseFrom %>" SortExpression="ReleaseFrom" UniqueName="ReleaseFrom" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="ReleaseFrom" runat="server" Text='<%# Eval("ReleaseFrom") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="ReleaseOn" FilterControlAltText="Filter ReleaseOn column" 
                                            HeaderText="<%$ Resources:Resource, lblReleaseOn %>" SortExpression="ReleaseOn" UniqueName="ReleaseOn" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="ReleaseOn" runat="server" Text='<%# Eval("ReleaseOn") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="LockedFrom" FilterControlAltText="Filter LockedFrom column" 
                                            HeaderText="<%$ Resources:Resource, lblLockedFrom %>" SortExpression="LockedFrom" UniqueName="LockedFrom" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="LockedFrom" runat="server" Text='<%# Eval("LockedFrom") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="LockedOn" FilterControlAltText="Filter LockedOn column" 
                                            HeaderText="<%$ Resources:Resource, lblLockedOn %>" SortExpression="LockedOn" UniqueName="LockedOn" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="LockedOn" runat="server" Text='<%# Eval("LockedOn") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Duplicates" HeaderText="<%$ Resources:Resource, lblDuplicates %>" SortExpression="Duplicates" UniqueName="Duplicates"
                                            GroupByExpression="Duplicates Duplicates GROUP BY Duplicates" ForceExtractValue="Always" AllowFiltering="false" Display="false">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Duplicates" Text='<%# Eval("Duplicates") %>'></asp:Label>
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

    <asp:SqlDataSource ID="SqlDataSource_CompaniesCentral" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>" OnInserting="SqlDataSource_CompaniesCentral_Inserting"
                       OldValuesParameterFormatString="original_{0}" OnInserted="SqlDataSource_Inserted"
                       DeleteCommand="INSERT INTO History_S_Companies SELECT * FROM System_Companies WHERE [SystemID] = @original_SystemID AND CompanyID = @original_CompanyID; 
                       DELETE FROM System_Addresses FROM System_Addresses INNER JOIN System_Companies ON System_Addresses.SystemID = System_Companies.SystemID AND System_Addresses.AddressID = System_Companies.AddressID WHERE (System_Addresses.SystemID = @original_SystemID) AND (System_Companies.CompanyID = @original_CompanyID); 
                       DELETE FROM System_Companies WHERE SystemID = @original_SystemID AND CompanyID = @original_CompanyID"
                       SelectCommand="SELECT DISTINCT s_c.SystemID, s_c.CompanyID, s_c.NameVisible, s_c.NameAdditional, s_c.Description, s_c.AddressID, s_c.IsVisible, s_c.IsValid, s_c.TradeAssociation, s_c.BlnSOKA, s_c.UserID, s_c.StatusID, s_c.CreatedFrom, s_c.CreatedOn, s_c.EditFrom, s_c.EditOn, s_a.Address1, s_a.Address2, s_a.Zip, s_a.City, s_a.State, s_a.CountryID, s_a.Phone, s_a.Email, s_a.WWW, s_c.RequestFrom, s_c.RequestOn, s_c.ReleaseFrom, s_c.ReleaseOn, s_c.LockedFrom, s_c.LockedOn, s_l.FlagName, s_c.MinWageAttestation, s_l.CountryName FROM View_Languages AS s_l INNER JOIN System_Addresses AS s_a ON s_l.CountryID = s_a.CountryID RIGHT OUTER JOIN System_Companies AS s_c ON s_a.SystemID = s_c.SystemID AND s_a.AddressID = s_c.AddressID WHERE (s_c.SystemID = @SystemID) AND (s_c.CompanyID = (CASE WHEN @CompanyID = 0 THEN s_c.CompanyID ELSE @CompanyID END)) ORDER BY s_c.NameVisible">
        <DeleteParameters>
            <asp:Parameter Name="original_SystemID"></asp:Parameter>
            <asp:Parameter Name="original_CompanyID"></asp:Parameter>
        </DeleteParameters>
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter SessionField="CompanyID" DefaultValue="-1" Name="CompanyID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Countries" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT DISTINCT CountryID, CountryName, FlagName FROM View_Countries ORDER BY View_Countries.CountryName"></asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Trades" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT * FROM Master_Trades WHERE (SystemID = @SystemID) AND (BpID = @BpID) ORDER BY NameVisible">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_BuildingProject" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT m_bp.BpID AS Id, m_bp.NameVisible As Name FROM Master_BuildingProjects AS m_bp INNER JOIN Master_UserBuildingProjects AS m_ubp ON m_bp.SystemID = m_ubp.SystemID AND m_bp.BpID = m_ubp.BpID LEFT OUTER JOIN View_Countries ON m_bp.CountryID = View_Countries.CountryID LEFT OUTER JOIN Master_BuildingProjects AS m_bp_based_on ON m_bp.SystemID = m_bp_based_on.SystemID AND m_bp.BasedOn = m_bp_based_on.BpID LEFT OUTER JOIN Master_TimeSlotGroups AS m_tsg ON m_bp.SystemID = m_tsg.SystemID AND m_bp.BpID = m_tsg.BpID AND m_bp.DefaultTimeSlotGroupID = m_tsg.TimeSlotGroupID LEFT OUTER JOIN Master_AccessAreas AS m_aa ON m_bp.SystemID = m_aa.SystemID AND m_bp.BpID = m_aa.BpID AND m_bp.DefaultAccessAreaID = m_aa.AccessAreaID LEFT OUTER JOIN Master_Roles AS m_r ON m_bp.SystemID = m_r.SystemID AND m_bp.BpID = m_r.BpID AND m_bp.DefaultRoleID = m_r.RoleID INNER JOIN Master_Companies m_c ON m_c.BpID = m_bp.BpID WHERE (m_bp.SystemID = @SystemID) AND (m_ubp.UserID = @UserID) GROUP BY m_bp.BpID, m_bp.NameVisible ORDER BY m_bp.NameVisible">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="1" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter SessionField="UserID" DefaultValue="0" Name="UserID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>


</asp:Content>
