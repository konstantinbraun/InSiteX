<%@ Page Title="<%$ Resources:Resource, lblCompaniesBP %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Companies.aspx.cs" Inherits="InSite.App.Views.Main.Companies" %>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderContent" runat="server">
    <telerik:RadScriptBlock runat="server">
<%--        <link href="/InSiteApp/Styles/DragDropStyleSheet.css" rel="stylesheet" type="text/css" />--%>
        <script type="text/javascript" src="/InSiteApp/RadTreeListScript.js"></script>

        <script type="text/javascript">
            function confirmMoveCallBackFn(arg) {
                PageMethods.CompleteMoveTask(arg, OnMoveSucceeded, OnMoveFailed);
            }

            function OnMoveSucceeded() {
                var treelist = $find("<%= RadTreeList1.ClientID %>");
                treelist.fireCommand("RebindTreeList", "");
            }

            function OnMoveFailed(error) {
                radalert("<%= Resources.Resource.msgMoveFailed %>");
            }

            var currentIndex = -1;
            function onClientItemClicked(sender, args) {
                var commandName = args.get_item().get_value();
                $find('<%= RadTreeList1.ClientID %>').fireCommand(commandName, currentIndex);
            }

            function onItemContextMenu(sender, args) {
                var evTarget = args.get_domEvent().target;
                if (evTarget.tagName.toLowerCase() === "td") {
                    args.get_item().set_selected(true);
                    currentIndex = args.get_item().get_displayIndex();
                    $find('<%= RadContextMenu1.ClientID %>').show(args.get_domEvent());
                }
            }
        </script>
    </telerik:RadScriptBlock>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="BodyContent" runat="server">

    <telerik:RadPersistenceManagerProxy ID="RadPersistenceManagerProxy1" runat="server">
        <PersistenceSettings>
            <telerik:PersistenceSetting ControlID="RadTreeList1" />
        </PersistenceSettings>
    </telerik:RadPersistenceManagerProxy>

    <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadTreeList1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadTreeList1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>
<%--            <telerik:AjaxSetting AjaxControlID="RadGridContacts">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridContacts" />
                </UpdatedControls>
            </telerik:AjaxSetting>--%>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <telerik:RadContextMenu ID="RadContextMenu1" runat="server" OnClientItemClicked="onClientItemClicked">
        <Items>
            <telerik:RadMenuItem Text="<%$ Resources:Resource, lblActionNew %>" Value="InitInsert" ImageUrl="/InSiteApp/Resources/Icons/edit-add.png"></telerik:RadMenuItem>
            <telerik:RadMenuItem Text="<%$ Resources:Resource, lblActionEdit %>" Value="Edit" ImageUrl="/InSiteApp/Resources/Icons/edit-3.png"></telerik:RadMenuItem>
            <telerik:RadMenuItem Text="<%$ Resources:Resource, lblActionDelete %>" Value="Delete" ImageUrl="/InSiteApp/Resources/Icons/edit-delete-6.png"></telerik:RadMenuItem>
        </Items>
    </telerik:RadContextMenu>

    <div style="background-color: InactiveBorder;">
        <table>
            <tr>
                <td style="padding: 5px; vertical-align: top; width: 150px;">
                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblLevels %>" Font-Bold="true"></asp:Label>
                    <br />
                    <asp:Label runat="server" Text="<%$ Resources:Resource, msgLevels %>"></asp:Label>
                </td>
                <td style="padding: 5px; vertical-align: top;">
                    <telerik:RadComboBox runat="server" ID="SelectLevel" OnSelectedIndexChanged="SelectLevel_SelectedIndexChanged" EmptyMessage="<%$ Resources:Resource, lblLevelsShow %>" 
                                         AutoPostBack="true" DropDownAutoWidth="Enabled">
                        <Items>
                            <telerik:RadComboBoxItem Value="0" Text="<%$ Resources:Resource, lblLevelMain %>"></telerik:RadComboBoxItem>
                            <telerik:RadComboBoxItem IsSeparator="true" Height="5px" Text="—————————"></telerik:RadComboBoxItem>
                            <telerik:RadComboBoxItem Value="1" Text="2"></telerik:RadComboBoxItem>
                            <telerik:RadComboBoxItem Value="2" Text="3"></telerik:RadComboBoxItem>
                            <telerik:RadComboBoxItem Value="3" Text="4" Selected="true"></telerik:RadComboBoxItem>
                            <telerik:RadComboBoxItem Value="4" Text="5"></telerik:RadComboBoxItem>
                            <telerik:RadComboBoxItem IsSeparator="true" Height="5px" Text="—————————"></telerik:RadComboBoxItem>
                            <telerik:RadComboBoxItem Value="99" Text="<%$ Resources:Resource, lblLevelAll %>"></telerik:RadComboBoxItem>
                        </Items>
                    </telerik:RadComboBox>
                </td>
                <td style="border-right-color: ActiveBorder; border-right-style: solid; border-right-width: 1px;">&nbsp;</td>
                <td>&nbsp;</td>
                <td style="padding: 5px; vertical-align: top; width: 200px;">
                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblSimpleSearch %>" Font-Bold="true"></asp:Label>
                    <br />
                    <asp:Label runat="server" Text="<%$ Resources:Resource, msgSimpleSearch %>"></asp:Label>
                </td>
                <td style="padding: 5px; vertical-align: top;">
                    <asp:TextBox runat="server" ID="SearchText" AutoPostBack="true" OnTextChanged="StartSearch_Click"></asp:TextBox>
                    <br />
                    <telerik:RadButton runat="server" ID="ResetSearch" AutoPostBack="true" OnClick="ResetSearch_Click" Text="<%$ Resources:Resource, lblActionReset %>"></telerik:RadButton>
                    <telerik:RadButton runat="server" ID="StartSearch" AutoPostBack="true" OnClick="StartSearch_Click" Text="<%$ Resources:Resource, lblActionSearch %>"></telerik:RadButton>
                </td>
                <td style="border-right-color: ActiveBorder; border-right-style: solid; border-right-width: 1px;">&nbsp;</td>
                <td>&nbsp;</td>
                <td style="padding: 5px; vertical-align: top; width: 200px;">
                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblRepresentation %>" Font-Bold="true"></asp:Label>
                    <br />
                    <asp:Label runat="server" Text="<%$ Resources:Resource, msgRepresentation %>"></asp:Label>
                </td>
                <td style="padding: 5px; vertical-align: top;">
                    <telerik:RadButton runat="server" ID="SwitchToTree" ToggleType="Radio" ButtonType="StandardButton" GroupName="SwitchTo" Text="<%$ Resources:Resource, lblTree %>" 
                                       Checked="true" AutoPostBack="true" OnCheckedChanged="SwitchToTree_CheckedChanged">
                    </telerik:RadButton>
                </td>
                <td style="padding: 5px; vertical-align: top;">
                    <telerik:RadButton runat="server" ID="SwitchToList" ToggleType="Radio" ButtonType="StandardButton" GroupName="SwitchTo" Text="<%$ Resources:Resource, lblList %>">
                    </telerik:RadButton>
                </td>
                <td style="border-right-color: ActiveBorder; border-right-style: solid; border-right-width: 1px;">&nbsp;</td>
                <td>&nbsp;</td>
                <td>
                    <telerik:RadButton ID="btnExportExcel" runat="server" Text="" ToolTip='<%# Resources.Resource.lblExportToExcel %>' ButtonType="SkinnedButton" 
                                       Visible="true" BorderStyle="None" BackColor="Transparent" Width="20px" Height="20px" OnClick="btnExportExcel_Click" AutoPostBack="true">
                        <Icon PrimaryIconUrl="../../Resources/Icons/export_xlsx_16.png" />
                    </telerik:RadButton>
                </td>
            </tr>
        </table>
    </div>

    <asp:ValidationSummary ID="ValidationSummary3" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' ShowMessageBox="true" 
                           ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true" />

    <telerik:RadTreeList ID="RadTreeList1" runat="server" ParentDataKeyNames="ParentIDReal" DataKeyNames="CompanyID" ClientDataKeyNames="CompanyID" AllowLoadOnDemand="false" CssClass="RadTreeList"
                         AllowPaging="True" AllowSorting="True" AutoGenerateColumns="false" ShowTreeLines="true" HideExpandCollapseButtonIfNoChildren="true" PageSize="15"
                         AllowRecursiveDelete="true" AllowMultiItemSelection="false" ShowOuterBorders="true" AllowNaturalSort="true" AllowStableSort="true" EditMode="PopUp"
                         AllowMultiColumnSorting="true" 
                         OnPreRender="RadTreeList1_PreRender" OnItemDataBound="RadTreeList1_ItemDataBound" OnInsertCommand="RadTreeList1_InsertCommand"
                         OnItemCommand="RadTreeList1_ItemCommand" OnItemDeleted="RadTreeList1_ItemDeleted" OnItemInserted="RadTreeList1_ItemInserted"
                         OnItemUpdated="RadTreeList1_ItemUpdated" OnDeleteCommand="RadTreeList1_DeleteCommand" OnItemDrop="RadTreeList1_ItemDrop"
                         OnItemCreated="RadTreeList1_ItemCreated" OnNeedDataSource="RadTreeList1_NeedDataSource" OnUpdateCommand="RadTreeList1_UpdateCommand"
                         OnPageIndexChanged="RadTreeList1_PageIndexChanged" OnPageSizeChanged="RadTreeList1_PageSizeChanged">

        <ClientSettings AllowItemsDragDrop="true" AllowPostBackOnItemClick="true">
            <Resizing AllowColumnResize="true" EnableRealTimeResize="true"></Resizing>
            <Reordering AllowColumnsReorder="true" ReorderColumnsOnClient="true"></Reordering>
            <Selecting AllowItemSelection="True" />
            <ClientEvents OnItemDropping="itemDropping" OnItemDragging="itemDragging" OnTreeListCreated="function(sender) { treeList1 = sender; }" 
                          OnItemContextMenu="onItemContextMenu" OnKeyPress="GridKeyPress"></ClientEvents>
        </ClientSettings>

        <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" PageSizeControlType="RadComboBox"  />

        <SortExpressions>
            <telerik:TreeListSortExpression FieldName="NameVisible" SortOrder="Ascending"></telerik:TreeListSortExpression>
        </SortExpressions>

        <%--#################################################################################### Edit Template ########################################################################################################--%>

        <EditFormSettings EditFormType="Template" CaptionDataField="NameVisible" CaptionFormatString="{0}">
            <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
            <FormTemplate>
                <telerik:RadTabStrip ID="RadTabStrip1" runat="server" MultiPageID="RadMultiPage1" Align="Left" AutoPostBack="false" CausesValidation="false">
                    <Tabs>
                        <telerik:RadTab PageViewID="RadPageView1" ImageUrl="~/Resources/Icons/factory.png" Text="<%# Resources.Resource.lblGenerally %>" Selected="true" Font-Bold="true" Value="1" />
                        <telerik:RadTab PageViewID="RadPageView2" ImageUrl="~/Resources/Icons/list-add-5.png" Text="<%# Resources.Resource.lblAdvanced %>" Font-Bold="true" Value="2" />
                        <telerik:RadTab PageViewID="RadPageView3" ImageUrl="~/Resources/Icons/info.png" Text="<%# Resources.Resource.lblInfo %>" Font-Bold="true" Value="3" />
                        <telerik:RadTab PageViewID="RadPageView4" ImageUrl="~/Resources/Icons/Contract.png" Text="<%# Resources.Resource.lblTariffContracts %>" Font-Bold="true" Value="4" />
                        <telerik:RadTab PageViewID="RadPageView5" ImageUrl="~/Resources/Icons/emblem-development.png" Text="<%# Resources.Resource.lblTrades %>" Font-Bold="true" Value="5" />
                        <telerik:RadTab PageViewID="RadPageView6" ImageUrl="~/Resources/Icons/criteria.png" Text="<%# Resources.Resource.lblOtherCriterias %>" Font-Bold="true" Value="6" />
                    </Tabs>
                </telerik:RadTabStrip>

                <telerik:RadMultiPage ID="RadMultiPage1" runat="server" RenderSelectedPageOnly="false">
                    <%-- Generally --%>
                    <telerik:RadPageView ID="RadPageView1" runat="server" Selected="true">
                        <table id="Table2" cellspacing="2" cellpadding="2" border="0" rules="none" class="EditFormTable">
                            <tr>
                                <td style="vertical-align: top;">
                                    <table id="Table3" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelID" Text='<%# String.Concat(Resources.Resource.lblID, ":") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="CompanyID" Text='<%# Eval("CompanyID") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                                <asp:HiddenField ID="StatusID" runat="server" Value='<%# Eval("StatusID") %>'></asp:HiddenField>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelCompany" Text='<%# String.Concat(Resources.Resource.lblCompany, ":") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? true : false%>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:HiddenField ID="CompanyCentralID1" runat="server" Value='<%# Eval("CompanyCentralID") %>'></asp:HiddenField>
                                                <telerik:RadDropDownList ID="CompanyCentralID" runat="server" SelectedValue='<%# Bind("CompanyCentralID") %>' DataSourceID="SqlDataSource_CompaniesCentral"
                                                                         DataTextField="NameVisible" DataValueField="CompanyID" DropDownHeight="400px" EnableVirtualScrolling="false" DropDownWidth="700px" Width="300px"
                                                                         Visible='<%# (Container is TreeListEditFormInsertItem) ? true : false%>'
                                                                         DefaultMessage="<%# Resources.Resource.msgPleaseSelect %>">
                                                    <ItemTemplate>
                                                        <table cellpadding="5px" style="text-align: left;">
                                                            <tr>
                                                                <td style="text-align: left;">
                                                                    <asp:Label Text='<%# String.Concat(Eval("NameVisible"), ", ") %>' runat="server"></asp:Label>
                                                                </td>
                                                                <td style="text-align: left;">
                                                                    <asp:Label Text='<%# String.Concat(Eval("NameAdditional"), ", ") %>' runat="server"></asp:Label>
                                                                </td>
                                                                <td style="text-align: left;">
                                                                    <asp:Label Text='<%# String.Concat(Eval("Address1"), ", ") %>' runat="server"></asp:Label>
                                                                </td>
                                                                <td style="text-align: left;">
                                                                    <asp:Label Text='<%# String.Concat(Eval("City"), ", ") %>' runat="server"></asp:Label>
                                                                </td>
                                                                <td style="text-align: left;">
                                                                    <asp:Label Text='<%# Eval("CountryID") %>' runat="server"></asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </ItemTemplate>
                                                </telerik:RadDropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelNameVisible" Text='<%# String.Concat(Resources.Resource.lblNameVisible, ":") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="NameVisible" Text='<%# Eval("NameVisible") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelNameAdditional" Text='<%# String.Concat(Resources.Resource.lblNameAdditional, ":") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="NameAdditional" Text='<%# Eval("NameAdditional") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
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
                                                <asp:Label runat="server" ID="LabelAddress1" Text='<%# String.Concat(Resources.Resource.lblAddress1, ":") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="Address1" Text='<%# Eval("Address1") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelAddress2" Text='<%# String.Concat(Resources.Resource.lblAddress2, ":") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="Address2" Text='<%# Eval("Address2") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelAddrZip" Text='<%# String.Concat(Resources.Resource.lblAddrZip, ":") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="Zip" Text='<%# Eval("Zip") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelAddrCity" Text='<%# String.Concat(Resources.Resource.lblAddrCity, ":") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="City" Text='<%# Eval("City") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelAddrState" Text='<%# String.Concat(Resources.Resource.lblAddrState, ":") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="State" Text='<%# Eval("State") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelCountry" Text='<%# String.Concat(Resources.Resource.lblCountry, ":") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                            <td>
                                                <telerik:RadComboBox runat="server" ID="CountryID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataSourceID="SqlDataSource_Countries"
                                                                     DataValueField="CountryID" DataTextField="CountryName" Width="300" Filter="Contains" SelectedValue='<%# Bind("CountryID") %>'
                                                                     AppendDataBoundItems="true" DropDownAutoWidth="Enabled" Enabled="false"
                                                                     Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'>
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
                                                <asp:Label runat="server" ID="LabelAddddrPhone" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ":") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="Phone" Text='<%# Eval("Phone") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelAddrEmail" Text='<%# String.Concat(Resources.Resource.lblAddrEmail, ":") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="Email" Text='<%# Eval("Email") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelAddrWWW" Text='<%# String.Concat(Resources.Resource.lblAddrWWW, ":") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="WWW" Text='<%# Eval("WWW") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                        </tr>

                                    </table>
                                </td>
                                <td style="vertical-align: top;">&nbsp; </td>
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
                            <tr>
                                <td align="left" colspan="2">
                                    <telerik:RadButton ID="RadButton1" Text='<%# (Container is TreeListEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionSave %>'
                                                       runat="server" CommandName='<%# (Container is TreeListEditFormInsertItem) ? "PerformInsert" : "Update" %>' CommandArgument="NoExit" Icon-PrimaryIconCssClass="rbSave">
                                    </telerik:RadButton>
                                    <telerik:RadButton ID="RadButton17" Text='<%# (Container is TreeListEditFormInsertItem) ? Resources.Resource.lblInsertAndClose : Resources.Resource.lblUpdateAndClose %>'
                                                       runat="server" CommandName='<%# (Container is TreeListEditFormInsertItem) ? "PerformInsert" : "Update" %>' Icon-PrimaryIconCssClass="rbOk">
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
                                    <table id="Table5" cellspacing="2" cellpadding="2" border="0" style="vertical-align: top; text-align: left;">
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="Label26" Text='<%# String.Concat(Resources.Resource.lblNameVisible, ":") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="RadTextBox1" Text='<%# Eval("NameVisible") %>' Width="300px"
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="Label27" Text='<%# String.Concat(Resources.Resource.lblNameAdditional, ":") %>'
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="Label1NameAdditional" Text='<%# Eval("NameAdditional") %>' Width="300px"
                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" colspan="2">
                                                <fieldset style="border-radius: 5px; border-style: solid; border-color: ActiveBorder; border-width: 1px;">
                                                    <legend style="background-color: transparent;">
                                                        <b><%= Resources.Resource.lblRegistrationCode %></b>
                                                    </legend>
                                                    <table id="Table3" cellspacing="2" cellpadding="2" border="0">
                                                        <tr>
                                                            <td nowrap="nowrap">
                                                                <asp:Label runat="server" ID="LabelRegistrationCode" Text='<%# String.Concat(Resources.Resource.lblRegistrationCode, ":") %>' 
                                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                                            </td>
                                                            <td nowrap="nowrap">
                                                                <asp:Panel runat="server" ID="PanelRegistrationCode" Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'>
                                                                    <telerik:RadTextBox runat="server" ID="RegistrationCode" Text='<%# Bind("RegistrationCode") %>' Width="124px"></telerik:RadTextBox>&nbsp;
                                                                    <telerik:RadButton runat="server" ID="BtnGenerateCode" Text='<%# Resources.Resource.lblGenerateCode %>' CausesValidation="false" 
                                                                                       CommandName="GenerateCode" CommandArgument='<%# Eval("CompanyID") %>'></telerik:RadButton>
                                                                </asp:Panel>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td nowrap="nowrap">
                                                                <asp:Label runat="server" ID="LabelCodeValidUntil" Text='<%# String.Concat(Resources.Resource.lblCodeValidUntil, ":") %>' 
                                                                           Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                                            </td>
                                                            <td>
                                                                <telerik:RadDatePicker ID="CodeValidUntil" runat="server" DbSelectedDate='<%# Bind("CodeValidUntil") %>' MinDate="<%# DateTime.Now %>" MaxDate="2100/1/1" EnableShadows="true"
                                                                                       ShowPopupOnFocus="true" Width="150px" 
                                                                                       Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'>
                                                                    <Calendar runat="server">
                                                                        <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                                                                TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                                                        </FastNavigationSettings>
                                                                    </Calendar>
                                                                </telerik:RadDatePicker>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </fieldset>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelParentID" Text='<%# String.Concat(Resources.Resource.lblClient, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <%-- Panel als Workaround wegen Plazierung RequiredFieldValidator --%>
                                                <asp:Panel runat="server" ID="Panel99">
                                                    <telerik:RadDropDownTree runat="server" ID="ParentID" DataFieldParentID="ParentID" DataFieldID="CompanyID" DataValueField="CompanyID" 
                                                                             EnableFiltering="true" EnableEmbeddedScripts="true"  
                                                                             DataTextField="NameVisible" Width="500px" DefaultMessage="<%$ Resources:Resource, msgPleaseSelect %>"
                                                                             DataSourceID="SqlDataSource_CompaniesExcl" SelectedValue='<%# Bind("ParentID") %>'>
                                                        <ButtonSettings ShowClear="true" />
                                                        <FilterSettings Highlight="Matches" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" Filter="Contains" />
                                                        <DropDownSettings OpenDropDownOnLoad="false" CloseDropDownOnSelection="true" AutoWidth="Enabled" />
                                                    </telerik:RadDropDownTree>
                                                </asp:Panel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelDescription" Text='<%# String.Concat(Resources.Resource.lblRemarks, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <telerik:RadTextBox runat="server" ID="Description" Text='<%# Bind("Description") %>' Width="100%" TextMode="MultiLine" Height="60px" Wrap="true"></telerik:RadTextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelTradeAssociation" Text='<%# String.Concat(Resources.Resource.lblTradeAssociation, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <telerik:RadTextBox runat="server" ID="TradeAssociation" Text='<%# Bind("TradeAssociation") %>' Width="300px"></telerik:RadTextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelIsPartner" Text='<%# String.Concat(Resources.Resource.lblIsPartner, ":") %>'></asp:Label>
                                            </td>
                                            <td >
                                                <asp:CheckBox CssClass="cb" runat="server" ID="IsPartner"></asp:CheckBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelBlnSOKA" Text='<%# String.Concat(Resources.Resource.lblBlnSOKA, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:CheckBox CssClass="cb" runat="server" ID="BlnSOKA"></asp:CheckBox>
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
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelAllowSubcontractorEdit" Text='<%# String.Concat(Resources.Resource.lblAllowSubcontractorEdit, ":") %>' 
                                                           ToolTip="<%# Resources.Resource.ttAllowSubcontractorEdit %>"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:CheckBox CssClass="cb" runat="server" ID="AllowSubcontractorEdit" ToolTip="<%# Resources.Resource.ttAllowSubcontractorEdit %>"></asp:CheckBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap="nowrap">
                                                <asp:Label runat="server" ID="LabelPassBudget" Text='<%# String.Concat(Resources.Resource.lblPassBudget, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <telerik:RadTextBox runat="server" ID="PassBudget" Text='<%# Bind("PassBudget", "{0:#,##0.00}") %>'>
                                                </telerik:RadTextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
                                        </tr>

                                    </table>
                                </td>
                                <td style="vertical-align: top;">&nbsp; </td>
                            </tr>
                        </table>

                        <table id="Table4" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top; text-align: left;">
                            <tr>
                                <td nowrap="nowrap" align="left" colspan="2">
                                    <asp:Label runat="server" ID="LabelRadGridContacts" Text='<%# String.Concat(Resources.Resource.lblContact, ":") %>' ></asp:Label>
                                    <telerik:RadGrid ID="RadGridContacts" runat="server" DataSourceID="SqlDataSourceContacts"
                                                     CssClass="RadGrid" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowAutomaticUpdates="true"
                                                     OnItemInserted="RadGridContacts_ItemInserted" OnPreRender="RadGridContacts_PreRender" OnItemCreated="RadGridContacts_ItemCreated"
                                                     OnItemDeleted="RadGridContacts_ItemDeleted" OnItemUpdated="RadGridContacts_ItemUpdated" OnItemDataBound="RadGridContacts_ItemDataBound"
                                                     OnItemCommand="RadGridContacts_ItemCommand" GroupPanelPosition="Top">

                                        <ValidationSettings ValidationGroup="Contacts" EnableValidation="false" />

                                        <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false">
                                            <Resizing AllowColumnResize="true"></Resizing>
                                            <Selecting AllowRowSelect="True" />
                                            <ClientEvents OnRowClick="OnRowClick" OnKeyPress="GridKeyPress" />
                                        </ClientSettings>

                                        <SortingSettings SortedBackColor="Transparent" />

                                        <MasterTableView DataKeyNames="SystemID,BpID,CompanyID,ContactID" DataSourceID="SqlDataSourceContacts" AutoGenerateColumns="False" 
                                                         EditMode="EditForms" CssClass="MasterClass" CommandItemDisplay="Top" AllowPaging="true" AllowSorting="true" 
                                                         AllowMultiColumnSorting="true" PageSize="5">

                                            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="false" PageSizes="5,10,50" />

                                            <EditFormSettings>
                                                <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                                                <EditColumn ButtonType="ImageButton" UniqueName="EditColumn2" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                                                            EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                                                <FormTableStyle CellPadding="3" CellSpacing="3" />
                                            </EditFormSettings>

                                            <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="False" ShowExportToExcelButton="True" ShowExportToPdfButton="False"
                                                                 AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                                            <SortExpressions>
                                                <telerik:GridSortExpression FieldName="LastName" SortOrder="Ascending"></telerik:GridSortExpression>
                                                <telerik:GridSortExpression FieldName="FirstName" SortOrder="Ascending"></telerik:GridSortExpression>
                                            </SortExpressions>

                                            <Columns>
                                                <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                                                               UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                                                    <ItemStyle BackColor="Control" Width="30px" />
                                                    <HeaderStyle Width="30px" />
                                                </telerik:GridEditCommandColumn>

                                                <telerik:GridTemplateColumn DataField="ContactID" Visible="false" DataType="System.Int32" FilterControlAltText="Filter ContactID column" 
                                                                            HeaderText="<%$ Resources:Resource, lblID %>" SortExpression="ContactID" UniqueName="ContactID" 
                                                                            GroupByExpression="ContactID ContactID GROUP BY ContactID" HeaderStyle-HorizontalAlign="Right">
                                                    <EditItemTemplate>
                                                        <asp:Label runat="server" ID="ContactID" Text='<%# Eval("ContactID") %>'></asp:Label>
                                                    </EditItemTemplate>
                                                </telerik:GridTemplateColumn>

                                                <telerik:GridTemplateColumn DataField="DescriptionShort" FilterControlAltText="Filter DescriptionShort column" HeaderText="<%$ Resources:Resource, lblTopic %>"
                                                                            SortExpression="DescriptionShort" UniqueName="DescriptionShort" GroupByExpression="DescriptionShort DescriptionShort GROUP BY DescriptionShort">
                                                    <EditItemTemplate>
                                                        <telerik:RadTextBox runat="server" ID="DescriptionShort" Text='<%# Bind("DescriptionShort") %>' Width="300px"></telerik:RadTextBox>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="LabelDescriptionShort" Text='<%# Eval("DescriptionShort") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>

                                                <telerik:GridTemplateColumn DataField="Salutation" HeaderText="<%$ Resources:Resource, lblAddrSalutation %>" SortExpression="Salutation" UniqueName="Salutation"
                                                                            GroupByExpression="Salutation Salutation GROUP BY Salutation" Visible="false">
                                                    <EditItemTemplate>
                                                        <telerik:RadTextBox runat="server" ID="Salutation" Text='<%# Bind("Salutation") %>' Width="300px"></telerik:RadTextBox>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="Salutation" Text='<%# Eval("Salutation") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>

                                                <telerik:GridTemplateColumn DataField="LastName" HeaderText="<%$ Resources:Resource, lblAddrLastName %>" SortExpression="LastName" UniqueName="LastName"
                                                                            GroupByExpression="LastName LastName GROUP BY LastName">
                                                    <EditItemTemplate>
                                                        <telerik:RadTextBox runat="server" ID="LastName" Text='<%# Bind("LastName") %>' Width="300px"></telerik:RadTextBox>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="LastName" Text='<%# Eval("LastName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>

                                                <telerik:GridTemplateColumn DataField="FirstName" HeaderText="<%$ Resources:Resource, lblAddrFirstName %>" SortExpression="FirstName" UniqueName="FirstName"
                                                                            GroupByExpression="FirstName FirstName GROUP BY FirstName">
                                                    <EditItemTemplate>
                                                        <telerik:RadTextBox runat="server" ID="FirstName" Text='<%# Bind("FirstName") %>' Width="300px"></telerik:RadTextBox>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="FirstName" Text='<%# Eval("FirstName") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>

                                                <telerik:GridTemplateColumn DataField="Phone" HeaderText="<%$ Resources:Resource, lblAddrPhone %>" SortExpression="Phone" UniqueName="Phone"
                                                                            GroupByExpression="Phone Phone GROUP BY Phone">
                                                    <EditItemTemplate>
                                                        <telerik:RadTextBox runat="server" ID="Phone" Text='<%# Bind("Phone") %>' Width="300px"></telerik:RadTextBox>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="Phone" Text='<%# Eval("Phone") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>

                                                <telerik:GridTemplateColumn DataField="Mobile" HeaderText="<%$ Resources:Resource, lblAddrMobile %>" SortExpression="Mobile" UniqueName="Mobile"
                                                                            GroupByExpression="Mobile Mobile GROUP BY Mobile">
                                                    <EditItemTemplate>
                                                        <telerik:RadTextBox runat="server" ID="Mobile" Text='<%# Bind("Mobile") %>' Width="300px"></telerik:RadTextBox>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="Mobile" Text='<%# Eval("Mobile") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>

                                                <telerik:GridTemplateColumn DataField="Email" HeaderText="<%$ Resources:Resource, lblAddrEmail %>" SortExpression="Email" UniqueName="Email"
                                                                            GroupByExpression="LastName LastName GROUP BY LastName">
                                                    <EditItemTemplate>
                                                        <telerik:RadTextBox runat="server" ID="Email" Text='<%# Bind("Email") %>' Width="300px"></telerik:RadTextBox>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="Email" Text='<%# Eval("Email") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>

                                                <telerik:GridTemplateColumn DataField="IsMWRelevant" UniqueName="IsMWRelevant" SortExpression="IsMWRelevant" ForceExtractValue="Always" 
                                                                            HeaderText="<%$ Resources:Resource, lblMWContact %>" ItemStyle-CssClass="cb" DefaultInsertValue="false">
                                                    <EditItemTemplate>
                                                        <asp:CheckBox CssClass="cb" runat="server" ID="IsMWRelevant" Checked='<%# Bind("IsMWRelevant") %>'></asp:CheckBox>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:CheckBox CssClass="cb" runat="server" ID="IsMWRelevant" Checked='<%# Eval("IsMWRelevant") %>'></asp:CheckBox>
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

                                                <telerik:GridButtonColumn UniqueName="deleteColumn" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                                                          ConfirmDialogType="RadWindow"
                                                                          ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                                                    <ItemStyle BackColor="Control" />
                                                </telerik:GridButtonColumn>
                                            </Columns>
                                        </MasterTableView>
                                    </telerik:RadGrid>
                                    <asp:CustomValidator runat="server" ID="ValidatorRadGridContacts" Enabled="false" Visible="false" 
                                                         OnServerValidate="ValidatorRadGridContacts_ServerValidate" ></asp:CustomValidator>
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
                                    <telerik:RadButton ID="btnUpdateAdvancedNoExit" Text='<%# (Container is TreeListEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionSave %>'
                                                       runat="server" CommandName='<%# (Container is TreeListEditFormInsertItem) ? "PerformInsert" : "Update" %>' CommandArgument="NoExit" Icon-PrimaryIconCssClass="rbSave">
                                    </telerik:RadButton>
                                    <telerik:RadButton ID="btnUpdateAdvanced" Text='<%# (Container is TreeListEditFormInsertItem) ? Resources.Resource.lblInsertAndClose : Resources.Resource.lblUpdateAndClose %>'
                                                       runat="server" CommandName='<%# (Container is TreeListEditFormInsertItem) ? "PerformInsert" : "Update" %>' Icon-PrimaryIconCssClass="rbOk">
                                    </telerik:RadButton>
                                    <telerik:RadButton ID="btnCancelAdvanced" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                       CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                    </telerik:RadButton>
                                </td>
                            </tr>
                        </table>

                        <asp:SqlDataSource ID="SqlDataSourceContacts" runat="server" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                                           OldValuesParameterFormatString="original_{0}"
                                           DeleteCommand="DELETE FROM [Master_CompanyContacts] WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [CompanyID] = @original_CompanyID AND [ContactID] = @original_ContactID"
                                           InsertCommand="INSERT INTO [Master_CompanyContacts] ([SystemID], [BpID], [CompanyID], [Salutation], [FirstName], [LastName], [Phone], [Mobile], [Email], [DescriptionShort], IsMWRelevant, [CreatedFrom], [CreatedOn], [EditFrom], [EditOn]) VALUES (@SystemID, @BpID, @CompanyID, @Salutation, @FirstName, @LastName, @Phone, @Mobile, @Email, @DescriptionShort, @IsMWRelevant, @UserName, SYSDATETIME(), @UserName, SYSDATETIME()) 
                                           SELECT @ReturnValue = SCOPE_IDENTITY()"
                                           SelectCommand="SELECT * FROM [Master_CompanyContacts] WHERE (([SystemID] = @SystemID) AND ([BpID] = @BpID) AND ([CompanyID] = @CompanyID)) ORDER BY [LastName], [FirstName]"
                                           UpdateCommand="UPDATE [Master_CompanyContacts] SET [Salutation] = @Salutation, [FirstName] = @FirstName, [LastName] = @LastName, [Phone] = @Phone, [Mobile] = @Mobile, [Email] = @Email, [DescriptionShort] = @DescriptionShort, IsMWRelevant = @IsMWRelevant, [EditFrom] = @UserName, [EditOn] = SYSDATETIME() WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [CompanyID] = @original_CompanyID AND [ContactID] = @original_ContactID">
                            <DeleteParameters>
                                <asp:Parameter Name="original_SystemID" Type="Int32"></asp:Parameter>
                                <asp:Parameter Name="original_BpID" Type="Int32"></asp:Parameter>
                                <asp:Parameter Name="original_CompanyID" Type="Int32"></asp:Parameter>
                                <asp:Parameter Name="original_ContactID" Type="Int32"></asp:Parameter>
                            </DeleteParameters>
                            <InsertParameters>
                                <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
                                <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
                                <asp:ControlParameter ControlID="CompanyID" PropertyName="Text" DefaultValue="0" Name="CompanyID" Type="Int32"></asp:ControlParameter>
                                <asp:Parameter Name="Salutation" Type="String"></asp:Parameter>
                                <asp:Parameter Name="FirstName" Type="String"></asp:Parameter>
                                <asp:Parameter Name="LastName" Type="String"></asp:Parameter>
                                <asp:Parameter Name="Phone" Type="String"></asp:Parameter>
                                <asp:Parameter Name="Mobile" Type="String"></asp:Parameter>
                                <asp:Parameter Name="Email" Type="String"></asp:Parameter>
                                <asp:Parameter Name="DescriptionShort" Type="String"></asp:Parameter>
                                <asp:Parameter Name="IsMWRelevant"></asp:Parameter>
                                <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
                                <asp:Parameter Name="ReturnValue" />
                            </InsertParameters>
                            <SelectParameters>
                                <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
                                <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
                                <asp:ControlParameter ControlID="CompanyID" PropertyName="Text" DefaultValue="0" Name="CompanyID" Type="Int32"></asp:ControlParameter>
                            </SelectParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="Salutation" Type="String"></asp:Parameter>
                                <asp:Parameter Name="FirstName" Type="String"></asp:Parameter>
                                <asp:Parameter Name="LastName" Type="String"></asp:Parameter>
                                <asp:Parameter Name="Phone" Type="String"></asp:Parameter>
                                <asp:Parameter Name="Mobile" Type="String"></asp:Parameter>
                                <asp:Parameter Name="Email" Type="String"></asp:Parameter>
                                <asp:Parameter Name="DescriptionShort" Type="String"></asp:Parameter>
                                <asp:Parameter Name="IsMWRelevant"></asp:Parameter>
                                <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
                                <asp:Parameter Name="original_SystemID" Type="Int32"></asp:Parameter>
                                <asp:Parameter Name="original_BpID" Type="Int32"></asp:Parameter>
                                <asp:Parameter Name="original_CompanyID" Type="Int32"></asp:Parameter>
                                <asp:Parameter Name="original_ContactID" Type="Int32"></asp:Parameter>
                            </UpdateParameters>
                        </asp:SqlDataSource>

                        <asp:SqlDataSource ID="SqlDataSource_CompaniesExcl" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                         SelectCommandType="StoredProcedure" SelectCommand="GetCompaniesSelection">
                            <SelectParameters>
                                <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                <asp:Parameter Name="CompanyID" DefaultValue="0" />
                                <asp:SessionParameter SessionField="UserID" DefaultValue="0" Name="UserID"></asp:SessionParameter>
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </telerik:RadPageView>

                    <%-- Info --%>
                    <telerik:RadPageView ID="RadPageView3" runat="server">
                        <table id="Table10" cellspacing="2" cellpadding="2" border="0" rules="none" class="EditFormTable">
                            <tr>
                                <td>
                                    <asp:Label runat="server" ID="Label2" Text='<%# String.Concat(Resources.Resource.lblNameVisible, ":") %>'
                                               Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                </td>
                                <td>
                                    <asp:Label runat="server" ID="Label3" Text='<%# Eval("NameVisible") %>' Width="300px"
                                               Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label runat="server" ID="Label28" Text='<%# String.Concat(Resources.Resource.lblNameAdditional, ":") %>'
                                               Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                </td>
                                <td>
                                    <asp:Label runat="server" ID="Label29" Text='<%# Eval("NameAdditional") %>' Width="300px"
                                               Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp; </td>
                                <td>&nbsp; </td>
                            </tr>
                            <tr>
                                <td>
                                    <%# Resources.Resource.lblSubcontratorDirect %>:
                                </td>
                                <td>
                                    <asp:Label runat="server" ID="SubcontratorDirect" Text="0"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <%# Resources.Resource.lblSubcontractorTotal %>:
                                </td>
                                <td>
                                    <asp:Label runat="server" ID="SubcontractorTotal" Text="0"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <%# Resources.Resource.lblEmployeesDirect %>:
                                </td>
                                <td>
                                    <asp:Label runat="server" ID="EmployeesDirect" Text="0"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <%# Resources.Resource.lblEmployeesTotal %>:
                                </td>
                                <td>
                                    <asp:Label runat="server" ID="EmployeesTotal" Text="0"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp; </td>
                                <td>&nbsp; </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label runat="server" Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblCreatedFrom, ":") %>'></asp:Label>
                                </td>
                                <td>
                                    <asp:Label runat="server" Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>' Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label runat="server" Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblCreatedOn, ":") %>'></asp:Label>
                                </td>
                                <td>
                                    <asp:Label runat="server" Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>' Text='<%# Eval("CreatedOn") %>'></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label runat="server" Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblEditFrom, ":") %>'></asp:Label>
                                </td>
                                <td>
                                    <asp:Label runat="server" Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>' Text='<%# Eval("EditFrom")%>'></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label runat="server" Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblEditOn, ":") %>'></asp:Label>
                                </td>
                                <td>
                                    <asp:Label runat="server" Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>' Text='<%# Eval("EditOn")%>'></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td><%= Resources.Resource.lblRequestFrom %>: </td>
                                <td>
                                    <asp:Label Text='<%# Eval("RequestFrom") %>' runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td><%= Resources.Resource.lblRequestOn %>: </td>
                                <td>
                                    <asp:Label Text='<%# Eval("RequestOn") %>' runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td><%= Resources.Resource.lblReleaseFrom %>: </td>
                                <td>
                                    <asp:Label ID="ReleaseFrom" Text='<%# Eval("ReleaseFrom") %>' runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td><%= Resources.Resource.lblReleaseOn %>: </td>
                                <td>
                                    <asp:Label ID="ReleaseOn" Text='<%# Eval("ReleaseOn") %>' runat="server"></asp:Label>
                                    <telerik:RadButton ID="ReleaseIt" runat="server" ButtonType="StandardButton" Text="<%$ Resources:Resource, lblActionRelease %>"
                                                       CommandName="ReleaseIt" CommandArgument='<%# Eval("CompanyID") %>' CausesValidation="false"></telerik:RadButton>
                                </td>
                            </tr>
                            <tr>
                                <td><%= Resources.Resource.lblLockedFrom %>: </td>
                                <td>
                                    <asp:Label ID="LockedFrom" Text='<%# Eval("LockedFrom") %>' runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td><%= Resources.Resource.lblLockedOn %>: </td>
                                <td>
                                    <asp:Label ID="LockedOn" Text='<%# Eval("LockedOn") %>' runat="server"></asp:Label>
                                    <telerik:RadButton ID="LockIt" runat="server" ButtonType="StandardButton" Text="<%$ Resources:Resource, lblActionLock %>"
                                                       CommandName="LockIt" CommandArgument='<%# Eval("CompanyID") %>' CausesValidation="false"></telerik:RadButton>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label runat="server" ID="LabelLockSubContractors" Text='<%# String.Concat(Resources.Resource.lblLockSubContractors, ":") %>'></asp:Label>
                                </td>
                                <td>
                                    <asp:CheckBox ID="LockSubContractors" runat="server" CssClass="cb" Checked='<%# (Container is TreeListEditFormInsertItem) ? false : Eval("LockSubContractors") %>' />
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
                            <tr>
                                <td align="left" colspan="2">
                                    <telerik:RadButton ID="RadButton2" Text='<%# (Container is TreeListEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionSave %>'
                                                       runat="server" CommandName='<%# (Container is TreeListEditFormInsertItem) ? "PerformInsert" : "Update" %>' CommandArgument="NoExit" Icon-PrimaryIconCssClass="rbSave">
                                    </telerik:RadButton>
                                    <telerik:RadButton ID="RadButton3" Text='<%# (Container is TreeListEditFormInsertItem) ? Resources.Resource.lblInsertAndClose : Resources.Resource.lblUpdateAndClose %>'
                                                       runat="server" CommandName='<%# (Container is TreeListEditFormInsertItem) ? "PerformInsert" : "Update" %>' Icon-PrimaryIconCssClass="rbOk">
                                    </telerik:RadButton>
                                    <telerik:RadButton ID="RadButton4" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                       CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                    </telerik:RadButton>
                                </td>
                            </tr>
                        </table>
                    </telerik:RadPageView>

                    <%-- Tariff Contracts --%>
                    <telerik:RadPageView ID="RadPageView4" runat="server">
                        <table id="Table6" cellspacing="2" cellpadding="2" border="0" rules="none" class="EditFormTable">
                            <tr>
                                <td>
                                    <asp:HiddenField ID="CompanyID1" runat="server" Value='<%# Eval("CompanyID") %>'></asp:HiddenField>
                                    <%# Resources.Resource.lblNameVisible %>:
                                </td>
                                <td>
                                    <asp:Label runat="server" ID="Label4" Text='<%# Eval("NameVisible") %>' Width="300px"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <%# Resources.Resource.lblNameAdditional %>:
                                </td>
                                <td>
                                    <asp:Label runat="server" ID="Label5" Text='<%# Eval("NameAdditional") %>' Width="300px"></asp:Label>
                                </td>
                            </tr>
                        </table>

                        <br />
                        <asp:Label runat="server" ID="LabelRadGridTariffs" Text='<%# String.Concat(Resources.Resource.lblTariffContracts, ":") %>'></asp:Label>
                        <br />
                        <telerik:RadGrid ID="RadGridTariffs" runat="server" DataSourceID="SqlDataSource_CompanyTariffs" EnableLinqExpressions="false" EnableHierarchyExpandAll="true"
                                         CssClass="RadGrid" AllowAutomaticDeletes="true" AllowAutomaticInserts="false" AllowAutomaticUpdates="false" GroupPanelPosition="Top"
                                         OnItemInserted="RadGridTariffs_ItemInserted" OnPreRender="RadGridTariffs_PreRender" OnItemCreated="RadGridTariffs_ItemCreated" 
                                         OnItemDataBound="RadGridTariffs_ItemDataBound" OnItemDeleted="RadGridTariffs_ItemDeleted" OnItemUpdated="RadGridTariffs_ItemUpdated" 
                                         OnItemCommand="RadGridTariffs_ItemCommand" OnUpdateCommand="RadGridTariffs_UpdateCommand">

                            <ValidationSettings ValidationGroup="Tariffs" EnableValidation="false" />

                            <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false">
                                <Resizing AllowColumnResize="true"></Resizing>
                                <Selecting AllowRowSelect="True" />
                                <ClientEvents OnRowClick="OnRowClick" OnKeyPress="GridKeyPress" />
                            </ClientSettings>

                            <SortingSettings SortedBackColor="Transparent" />

                            <MasterTableView DataSourceID="SqlDataSource_CompanyTariffs" DataKeyNames="SystemID,BpID,TariffScopeID,CompanyID" EnableHierarchyExpandAll="true" 
                                             AutoGenerateColumns="False" CommandItemDisplay="Top" HierarchyLoadMode="Conditional" AllowMultiColumnSorting="true" AllowPaging="true" 
                                             CssClass="MasterClass" EditMode="EditForms">

                                <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="false" PageSizes="10,20,50" />

                                <EditFormSettings >
                                    <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                                    <EditColumn ButtonType="ImageButton" UniqueName="EditColumn2" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                                                EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                                    <FormTableStyle CellPadding="3" CellSpacing="3" />
                                </EditFormSettings>

                                <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="false" ShowExportToCsvButton="True" ShowExportToExcelButton="True" ShowExportToPdfButton="True"
                                                     AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                                <%-- Tariff Scope Details--%>
                                <NestedViewTemplate>
                                    <fieldset style="padding: 10px; width: 500px; margin-left: 10px; margin-bottom: 10px;">
                                        <legend style="padding: 5px; background-color: transparent;">
                                            <b><%= Resources.Resource.lblDetailsFor%> <%# Eval("NameVisible") %></b>
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
                                                    <asp:Label Text='<%#Eval("ValidFrom")%>' runat="server"></asp:Label>
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
                                    <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn2" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                                                   UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                                        <ItemStyle BackColor="Control" Width="30px" />
                                        <HeaderStyle Width="30px" />
                                    </telerik:GridEditCommandColumn>

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

                                    <telerik:GridTemplateColumn DataField="TariffScopeID" DataType="System.Int32" Visible="false" FilterControlAltText="Filter TariffScopeID column" HeaderText="<%$ Resources:Resource, lblTariffScope %>"
                                                                SortExpression="TariffScopeID" UniqueName="TariffScopeID" InsertVisiblityMode="AlwaysVisible">
                                        <EditItemTemplate>
                                            <asp:HiddenField ID="TariffContractID" runat="server" Value='<%# Eval("TariffContractID") %>'></asp:HiddenField>
                                            <asp:HiddenField ID="CompanyID" runat="server" Value='<%# Eval("CompanyID") %>'></asp:HiddenField>
                                            <telerik:RadDropDownList ID="TariffScopeID" runat="server"
                                                                     DataTextField="NameVisible" DataValueField="TariffScopeID" DropDownHeight="400px" EnableVirtualScrolling="false"
                                                                     DropDownWidth="700px" Width="300px">
                                                <ItemTemplate>
                                                    <table cellpadding="5px" style="text-align: left;">
                                                        <tr>
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
                                            </telerik:RadDropDownList>
                                        </EditItemTemplate>
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
                                        <editItemTemplate>
                                            <asp:Label runat="server" ID="LabelValidFrom" Text='<%# Eval("ValidFrom", "{0:d}") %>'></asp:Label>
                                        </editItemTemplate>
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

                                    <telerik:GridButtonColumn UniqueName="deleteColumn" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                                              ConfirmDialogType="RadWindow"
                                                              ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                                        <ItemStyle BackColor="Control" />
                                    </telerik:GridButtonColumn>
                                </Columns>

                            </MasterTableView>

                        </telerik:RadGrid>
                        <asp:CustomValidator runat="server" ID="ValidatorRadGridTariffs" Enabled="false" Visible="false" ControlToValidate="RadGridTariffs"
                                             OnServerValidate="ValidatorRadGridTariffs_ServerValidate" ></asp:CustomValidator>
                        <table>
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
                            <tr>
                                <td align="left" colspan="2">
                                    <telerik:RadButton ID="btnUpdateTariffsNoExit" Text='<%# (Container is TreeListEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionSave %>'
                                                       runat="server" CommandName='<%# (Container is TreeListEditFormInsertItem) ? "PerformInsert" : "Update" %>' CommandArgument="NoExit" Icon-PrimaryIconCssClass="rbSave">
                                    </telerik:RadButton>
                                    <telerik:RadButton ID="btnUpdateTariffs" Text='<%# (Container is TreeListEditFormInsertItem) ? Resources.Resource.lblInsertAndClose : Resources.Resource.lblUpdateAndClose %>'
                                                       runat="server" CommandName='<%# (Container is TreeListEditFormInsertItem) ? "PerformInsert" : "Update" %>' Icon-PrimaryIconCssClass="rbOk">
                                    </telerik:RadButton>
                                    <telerik:RadButton ID="btnCancelTariffs" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                       CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                    </telerik:RadButton>
                                </td>
                            </tr>
                        </table>

                        <asp:SqlDataSource runat="server" ID="SqlDataSource_CompanyTariffs" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                                           OldValuesParameterFormatString="original_{0}"
                                           DeleteCommand="DELETE FROM [Master_CompanyTariffs] WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [TariffScopeID] = @original_TariffScopeID AND [CompanyID] = @original_CompanyID"
                                           SelectCommand="SELECT ct.SystemID, ct.BpID, ct.TariffScopeID, ct.CompanyID, ct.ValidFrom, ct.CreatedFrom, ct.CreatedOn, ct.EditFrom, ct.EditOn, s.TariffContractID, s.NameVisible, s.DescriptionShort, c.NameVisible AS NameVisibleContract, t.NameVisible AS NameVisibleTariff FROM Master_CompanyTariffs AS ct INNER JOIN System_TariffScopes AS s ON ct.SystemID = s.SystemID AND ct.TariffScopeID = s.TariffScopeID INNER JOIN System_TariffContracts AS c ON s.SystemID = c.SystemID AND s.TariffID = c.TariffID AND s.TariffContractID = c.TariffContractID INNER JOIN System_Tariffs AS t ON c.SystemID = t.SystemID AND c.TariffID = t.TariffID WHERE (ct.SystemID = @SystemID) AND (ct.BpID = @BpID) AND (ct.CompanyID = @CompanyID) ORDER BY ct.ValidFrom DESC">
                            <DeleteParameters>
                                <asp:Parameter Name="original_SystemID" Type="Int32"></asp:Parameter>
                                <asp:Parameter Name="original_BpID" Type="Int32"></asp:Parameter>
                                <asp:Parameter Name="original_TariffScopeID" Type="Int32"></asp:Parameter>
                                <asp:Parameter Name="original_CompanyID" Type="Int32"></asp:Parameter>
                            </DeleteParameters>
                            <SelectParameters>
                                <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
                                <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
                                <asp:ControlParameter ControlID="CompanyID1" PropertyName="Value" DefaultValue="0" Name="CompanyID" Type="Int32"></asp:ControlParameter>
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </telerik:RadPageView>

                    <%-- Statistical Trades --%>
                    <telerik:RadPageView ID="RadPageView5" runat="server">
                        <table id="Table8" cellspacing="2" cellpadding="2" border="0" rules="none" class="EditFormTable">
                            <tr>
                                <td>
                                    <asp:HiddenField runat="server" ID="CompanyID3" Value='<%# Eval("CompanyID")%>' />
                                    <table>
                                        <tr>
                                            <td colspan="2">
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <%# Resources.Resource.lblNameVisible %>:
                                                        </td>
                                                        <td>
                                                            <asp:Label runat="server" ID="Label6" Text='<%# Eval("NameVisible") %>' Width="300px"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <%# Resources.Resource.lblNameAdditional %>:
                                                        </td>
                                                        <td>
                                                            <asp:Label runat="server" ID="Label7" Text='<%# Eval("NameAdditional") %>' Width="300px"></asp:Label>
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
                                            <td>
                                                <asp:Label runat="server" ID="LabelAvailableTrades" Text='<%# String.Concat(Resources.Resource.lblAvailableTrades, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="LabelAssignedTrades" Text='<%# String.Concat(Resources.Resource.lblAssignedTrades, ":") %>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <telerik:RadListBox ID="AvailableTrades" runat="server" DataValueField="TradeID" DataSourceID="SqlDataSource_Trades" DataKeyField="TradeID"
                                                                    DataTextField="TradeName" Width="300px" Height="300px" OnTransferred="AvailableTrades_Transferred" SelectionMode="Multiple"
                                                                    AllowTransfer="true" TransferToID="AssignedTrades" AutoPostBackOnTransfer="true"
                                                                    EnableDragAndDrop="true">
                                                </telerik:RadListBox>
                                            </td>
                                            <td>
                                                <telerik:RadListBox ID="AssignedTrades" runat="server" DataSourceID="SqlDataSource_CompanyTrades" DataValueField="TradeID"
                                                                    DataKeyField="TradeID" DataTextField="TradeName" Width="300px" Height="300px" SelectionMode="Multiple" EnableDragAndDrop="true">
                                                </telerik:RadListBox>
                                                <asp:CustomValidator runat="server" ID="ValidatorAssignedTrades" Enabled="false" Visible="false" 
                                                                     OnServerValidate="ValidatorAssignedTrades_ServerValidate" ></asp:CustomValidator>
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
                                    <telerik:RadButton ID="RadButton5" Text='<%# (Container is TreeListEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionSave %>'
                                                       runat="server" CommandName='<%# (Container is TreeListEditFormInsertItem) ? "PerformInsert" : "Update" %>' CommandArgument="NoExit" Icon-PrimaryIconCssClass="rbSave">
                                    </telerik:RadButton>
                                    <telerik:RadButton ID="RadButton6" Text='<%# (Container is TreeListEditFormInsertItem) ? Resources.Resource.lblInsertAndClose : Resources.Resource.lblUpdateAndClose %>'
                                                       runat="server" CommandName='<%# (Container is TreeListEditFormInsertItem) ? "PerformInsert" : "Update" %>' Icon-PrimaryIconCssClass="rbOk">
                                    </telerik:RadButton>
                                    <telerik:RadButton ID="RadButton7" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                       CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                    </telerik:RadButton>
                                </td>
                            </tr>
                        </table>

                        <asp:SqlDataSource ID="SqlDataSource_Trades" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                           SelectCommand="SELECT m_t.SystemID, m_t.BpID, m_t.TradeGroupID, m_t.TradeID, m_t.NameVisible, m_t.DescriptionShort, m_t.TradeNumber, m_t.CostLocationID, m_t.TradeGroupStatisticalID, m_t.CreatedFrom, m_t.CreatedOn, m_t.EditFrom, m_t.EditOn, m_tg.NameVisible + ' : ' + m_t.NameVisible AS TradeName FROM Master_Trades AS m_t INNER JOIN Master_TradeGroups AS m_tg ON m_t.SystemID = m_tg.SystemID AND m_t.BpID = m_tg.BpID AND m_t.TradeGroupID = m_tg.TradeGroupID WHERE (m_t.SystemID = @SystemID) AND (m_t.BpID = @BpID) AND (NOT EXISTS (SELECT 1 AS Expr1 FROM Master_CompanyTrades AS t2 WHERE (SystemID = m_t.SystemID) AND (BpID = m_t.BpID) AND (CompanyID = @CompanyID) AND (TradeID = m_t.TradeID))) ORDER BY m_tg.NameVisible, m_t.NameVisible">
                            <SelectParameters>
                                <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
                                <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" />
                                <asp:ControlParameter ControlID="CompanyID3" PropertyName="Value" Type="Int32" Name="CompanyID"></asp:ControlParameter>
                            </SelectParameters>
                        </asp:SqlDataSource>

                        <asp:SqlDataSource ID="SqlDataSource_CompanyTrades" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                           SelectCommand="SELECT m_ct.SystemID, m_ct.BpID, m_ct.TradeGroupID, m_ct.TradeID, m_ct.CompanyID, m_ct.CreatedFrom, m_ct.CreatedOn, m_ct.EditFrom, m_ct.EditOn, m_t.NameVisible, m_t.DescriptionShort, m_tg.NameVisible + ' : ' + m_t.NameVisible AS TradeName FROM Master_CompanyTrades AS m_ct INNER JOIN Master_Trades AS m_t ON m_ct.SystemID = m_t.SystemID AND m_ct.BpID = m_t.BpID AND m_ct.TradeGroupID = m_t.TradeGroupID AND m_ct.TradeID = m_t.TradeID INNER JOIN Master_TradeGroups AS m_tg ON m_t.SystemID = m_tg.SystemID AND m_t.BpID = m_tg.BpID AND m_t.TradeGroupID = m_tg.TradeGroupID WHERE (m_ct.SystemID = @SystemID) AND (m_ct.BpID = @BpID) AND (m_ct.CompanyID = @CompanyID) ORDER BY m_tg.NameVisible, m_t.NameVisible">
                            <SelectParameters>
                                <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
                                <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" />
                                <asp:ControlParameter ControlID="CompanyID3" PropertyName="Value" Type="Int32" Name="CompanyID"></asp:ControlParameter>
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </telerik:RadPageView>

                    <%-- Other Criterias --%>
                    <telerik:RadPageView ID="RadPageView6" runat="server">
                        <table id="Table12" cellspacing="2" cellpadding="2" border="0" rules="none" class="EditFormTable">
                            <tr>
                                <td>
                                    <asp:Label runat="server" ID="Label8" Text='<%# String.Concat(Resources.Resource.lblNameVisible, ":") %>'
                                               Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                </td>
                                <td>
                                    <asp:Label runat="server" ID="Label9" Text='<%# Eval("NameVisible") %>' Width="300px"
                                               Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label runat="server" ID="Label30" Text='<%# String.Concat(Resources.Resource.lblNameAdditional, ":") %>'
                                               Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
                                </td>
                                <td>
                                    <asp:Label runat="server" ID="Label31" Text='<%# Eval("NameAdditional") %>' Width="300px"
                                               Visible='<%# (Container is TreeListEditFormInsertItem) ? false : true%>'></asp:Label>
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
                                    <asp:CheckBox runat="server" CssClass="cb" ID="UserBit1"></asp:CheckBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label runat="server" ID="LabelUserBit2" Text='<%# String.Concat(Resources.Resource.lblUserDefinedBit, " 2:") %>'></asp:Label>
                                </td>
                                <td>
                                    <asp:CheckBox runat="server" CssClass="cb" ID="UserBit2"></asp:CheckBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label runat="server" ID="LabelUserBit3" Text='<%# String.Concat(Resources.Resource.lblUserDefinedBit, " 3:") %>'></asp:Label>
                                </td>
                                <td>
                                    <asp:CheckBox runat="server" CssClass="cb" ID="UserBit3"></asp:CheckBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label runat="server" ID="LabelUserBit4" Text='<%# String.Concat(Resources.Resource.lblUserDefinedBit, " 4:") %>'></asp:Label>
                                </td>
                                <td>
                                    <asp:CheckBox runat="server" CssClass="cb" ID="UserBit4"></asp:CheckBox>
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
                                                <asp:Label runat="server" ID="LabelAvailableAttributes" Text='<%# String.Concat(Resources.Resource.lblAvailableAttributes, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="LabelAssignedAttributes" Text='<%# String.Concat(Resources.Resource.lblAssignedAttributes, ":") %>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <telerik:RadListBox ID="AvailableAttributes" runat="server" DataValueField="AttributeID" DataSourceID="SqlDataSource_AvailableAttributes" DataKeyField="AttributeID"
                                                                    DataTextField="NameVisible" Width="300px" Height="100px" OnTransferred="AvailableAttributes_Transferred" SelectionMode="Multiple"
                                                                    AllowTransfer="true" TransferToID="AssignedAttributes" AutoPostBackOnTransfer="true"
                                                                    EnableDragAndDrop="true">
                                                </telerik:RadListBox>
                                            </td>
                                            <td>
                                                <telerik:RadListBox ID="AssignedAttributes" runat="server" DataSourceID="SqlDataSource_AssignedAttributes" DataValueField="AttributeID"
                                                                    DataKeyField="AttributeID" DataTextField="NameVisible" Width="300px" Height="100px" SelectionMode="Multiple" EnableDragAndDrop="true">
                                                </telerik:RadListBox>
                                                <asp:CustomValidator runat="server" ID="ValidatorAssignedAttributes" Enabled="false" Visible="false" 
                                                                     OnServerValidate="ValidatorAssignedAttributes_ServerValidate" ></asp:CustomValidator>
                                            </td>
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
                                <td>&nbsp; </td>
                                <td>&nbsp; </td>
                            </tr>
                            <tr>
                                <td align="left" colspan="2">
                                    <telerik:RadButton ID="RadButton8" Text='<%# (Container is TreeListEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionSave %>'
                                                       runat="server" CommandName='<%# (Container is TreeListEditFormInsertItem) ? "PerformInsert" : "Update" %>' CommandArgument="NoExit" Icon-PrimaryIconCssClass="rbSave">
                                    </telerik:RadButton>
                                    <telerik:RadButton ID="RadButton9" Text='<%# (Container is TreeListEditFormInsertItem) ? Resources.Resource.lblInsertAndClose : Resources.Resource.lblUpdateAndClose %>'
                                                       runat="server" CommandName='<%# (Container is TreeListEditFormInsertItem) ? "PerformInsert" : "Update" %>' Icon-PrimaryIconCssClass="rbOk">
                                    </telerik:RadButton>
                                    <telerik:RadButton ID="RadButton10" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                       CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                    </telerik:RadButton>
                                </td>
                            </tr>
                        </table>

                        <asp:SqlDataSource ID="SqlDataSource_AvailableAttributes" runat="server" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                                           SelectCommand="SELECT SystemID, BpID, AttributeID, NameVisible, DescriptionShort, PassColor, TemplateID, CreatedFrom, CreatedOn, EditFrom, EditOn FROM Master_AttributesBuildingProject AS ab WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (NOT EXISTS (SELECT 1 AS Expr1 FROM Master_AttributesCompany WHERE (SystemID = ab.SystemID) AND (BpID = ab.BpID) AND (AttributeID = ab.AttributeID) AND (CompanyID = @CompanyID)))">
                            <SelectParameters>
                                <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
                                <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
                                <asp:ControlParameter ControlID="CompanyID" PropertyName="Text" DefaultValue="0" Name="CompanyID"></asp:ControlParameter>
                            </SelectParameters>
                        </asp:SqlDataSource>

                        <asp:SqlDataSource ID="SqlDataSource_AssignedAttributes" runat="server" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                                           SelectCommand="SELECT ac.SystemID, ac.BpID, ac.AttributeID, ab.NameVisible, ab.DescriptionShort, ac.CreatedFrom, ac.CreatedOn, ac.EditFrom, ac.EditOn, ac.CompanyID FROM Master_AttributesCompany AS ac INNER JOIN Master_AttributesBuildingProject AS ab ON ac.SystemID = ab.SystemID AND ac.BpID = ab.BpID AND ac.AttributeID = ab.AttributeID WHERE (ac.SystemID = @SystemID) AND (ac.BpID = @BpID) AND (ac.CompanyID = @CompanyID)">
                            <SelectParameters>
                                <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
                                <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
                                <asp:ControlParameter ControlID="CompanyID" PropertyName="Text" DefaultValue="0" Name="CompanyID"></asp:ControlParameter>
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </telerik:RadPageView>

                </telerik:RadMultiPage>
            </FormTemplate>
        </EditFormSettings>

        <%--#################################################################################### View Template ########################################################################################################--%>

        <DetailTemplate>
            <asp:Panel runat="server" ID="PanelDetail" Visible="<%# Hide(Container) %>" BackColor="White">

            </asp:Panel>
        </DetailTemplate>

        <Columns>
            <telerik:TreeListDragDropColumn Visible="false" HeaderStyle-Width="20px" UniqueName="TreeListDragDropColumn"></telerik:TreeListDragDropColumn>

            <telerik:TreeListEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                               UpdateText="<%$ Resources:Resource, lblActionUpdate %>" ItemStyle-Width="60px" HeaderStyle-Width="60px" AddRecordText="<%$ Resources:Resource, lblActionAdd %>">
                <ItemStyle BackColor="Control" />
            </telerik:TreeListEditCommandColumn>

            <telerik:TreeListTemplateColumn DataField="StatusID" HeaderText="<%$ Resources:Resource, lblStatus %>" SortExpression="StatusID" UniqueName="StatusID" ItemStyle-HorizontalAlign="Center"
                                            ForceExtractValue="Always" ItemStyle-Width="50px" HeaderStyle-Width="50px">
                <ItemTemplate>
                    <asp:HiddenField ID="StatusID" runat="server" Value='<%# Eval("StatusID") %>'></asp:HiddenField>
                    <asp:ImageButton runat="server" ID="ReleaseButton" />
                </ItemTemplate>
            </telerik:TreeListTemplateColumn>

            <telerik:TreeListTemplateColumn DataField="StatusID" HeaderText="<%$ Resources:Resource, lblLocked %>" SortExpression="StatusID" UniqueName="StatusID1" ItemStyle-HorizontalAlign="Center"
                                            ForceExtractValue="Always" ItemStyle-Width="50px" HeaderStyle-Width="50px">
                <ItemTemplate>
                    <asp:ImageButton runat="server" ID="LockedButton" />
                </ItemTemplate>
            </telerik:TreeListTemplateColumn>

            <telerik:TreeListBoundColumn DataField="CompanyID" UniqueName="CompanyID" ForceExtractValue="Always" Visible="false">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="CompanyCentralID" HeaderText="CompanyCentralID" Visible="false" UniqueName="CompanyCentralID" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListTemplateColumn DataField="NameVisible" HeaderText="<%$ Resources:Resource, lblNameVisible %>" SortExpression="NameVisible" UniqueName="NameVisible2">
                <ItemTemplate>
                    <asp:Label runat="server" ID="NameVisible2" Text='<%# Eval("NameVisible") %>'></asp:Label>
                </ItemTemplate>
            </telerik:TreeListTemplateColumn>

            <telerik:TreeListTemplateColumn DataField="NameAdditional" HeaderText="<%$ Resources:Resource, lblNameAdditional %>" SortExpression="NameAdditional" UniqueName="NameAdditional">
                <ItemTemplate>
                    <asp:Label runat="server" ID="NameAdditional" Text='<%# Eval("NameAdditional") %>'></asp:Label>
                </ItemTemplate>
            </telerik:TreeListTemplateColumn>

            <telerik:TreeListTemplateColumn DataField="Description" HeaderText="<%$ Resources:Resource, lblDescriptionShort %>" SortExpression="Description" UniqueName="Description" Visible="false">
                <ItemTemplate>
                    <asp:Label runat="server" ID="Description" Text='<%# Eval("Description") %>'></asp:Label>
                </ItemTemplate>
            </telerik:TreeListTemplateColumn>

            <telerik:TreeListBoundColumn DataField="AddressID" HeaderText="AddressID" Visible="false" UniqueName="AddressID" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListTemplateColumn DataField="Address1" HeaderText="<%$ Resources:Resource, lblAddress1 %>" SortExpression="Address1" UniqueName="Address1" >
                <ItemTemplate>
                    <asp:Label runat="server" ID="Address1" Text='<%# Eval("Address1") %>'></asp:Label>
                </ItemTemplate>
            </telerik:TreeListTemplateColumn>

            <telerik:TreeListBoundColumn DataField="Address2" HeaderText="Address2" Visible="false" UniqueName="Address2" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="Zip" HeaderText="Zip" Visible="false" UniqueName="Zip" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListTemplateColumn DataField="City" HeaderText="<%$ Resources:Resource, lblAddrCity %>" SortExpression="City" UniqueName="City" >
                <ItemTemplate>
                    <asp:Label runat="server" ID="City" Text='<%# Eval("City") %>'></asp:Label>
                </ItemTemplate>
            </telerik:TreeListTemplateColumn>

            <telerik:TreeListBoundColumn DataField="State" HeaderText="State" Visible="false" UniqueName="State" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListTemplateColumn DataField="CountryID" HeaderText="<%$ Resources:Resource, lblCountry %>" SortExpression="CountryID" UniqueName="CountryID"  ItemStyle-Height="20px">
                <ItemTemplate>
                    <table cellspacing="0" cellpadding="0" border="0" rules="none" style="border-style: none; height:24px; margin-bottom: -10px; margin-top: -3px">
                        <tr style="border-style: none; height:24px;">
                            <td style="border-style: none; height:24px;">
                                <asp:Image ID="ItemImage" ImageUrl='<%# String.Format("~/Resources/Icons/Flags/{0}", Eval("FlagName"))%>' Visible='<%# Eval("FlagName") != null %>' 
                                           Height="24px" Width="24px" runat="server" />
                            </td>
                            <td style="border-style: none; height:24px;">
                                <asp:Label runat="server" ID="CountryName" Text='<%# Eval("CountryName") %>'></asp:Label>
                            </td>
                        </tr>
                    </table>
                </ItemTemplate>
            </telerik:TreeListTemplateColumn>

            <telerik:TreeListBoundColumn DataField="Phone" HeaderText="Phone" Visible="false" UniqueName="Phone" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="Email" HeaderText="Email" Visible="false" UniqueName="Email" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="WWW" HeaderText="WWW" Visible="false" UniqueName="WWW" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="ParentNameVisible" HeaderText="<%$ Resources:Resource, lblClient %>" Visible="false" UniqueName="ParentNameVisible" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="ParentNameAdditional" HeaderText="ParentNameAdditional" Visible="false" UniqueName="ParentNameAdditional" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="TradeAssociation" HeaderText="TradeAssociation" Visible="false" UniqueName="TradeAssociation" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="RegistrationCode" HeaderText="RegistrationCode" Visible="false" UniqueName="RegistrationCode" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="CodeValidUntil" HeaderText="CodeValidUntil" Visible="false" UniqueName="CodeValidUntil" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListCheckBoxColumn DataField="IsPartner" DefaultInsertValue="false" HeaderText="IsPartner" Visible="false" UniqueName="IsPartner" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListCheckBoxColumn>

            <telerik:TreeListCheckBoxColumn DataField="BlnSOKA" DefaultInsertValue="True" HeaderText="BlnSOKA" Visible="false" UniqueName="BlnSOKA" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListCheckBoxColumn>

            <telerik:TreeListCheckBoxColumn DataField="MinWageAttestation" DefaultInsertValue="false" HeaderText="MinWageAttestation" Visible="false" UniqueName="MinWageAttestation" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListCheckBoxColumn>

            <telerik:TreeListCheckBoxColumn DataField="AllowSubcontractorEdit" DefaultInsertValue="false" HeaderText="AllowSubcontractorEdit" Visible="false" UniqueName="AllowSubcontractorEdit" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListCheckBoxColumn>

            <telerik:TreeListCheckBoxColumn DataField="MinWageAccessRelevance" DefaultInsertValue="false" HeaderText="MinWageAccessRelevance" Visible="false" UniqueName="MinWageAccessRelevance" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListCheckBoxColumn>

            <telerik:TreeListBoundColumn DataField="PassBudget" HeaderText="PassBudget" Visible="false" UniqueName="PassBudget" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListCheckBoxColumn DataField="LockSubContractors" DefaultInsertValue="false" HeaderText="LockSubContractors" Visible="false" UniqueName="LockSubContractors" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListCheckBoxColumn>

            <telerik:TreeListTemplateColumn DataField="CreatedFrom" HeaderText="<%$ Resources:Resource, lblCreatedFrom %>" SortExpression="CreatedFrom" UniqueName="CreatedFrom" Visible="False">
                <ItemTemplate>
                    <asp:Label ID="CreatedFromLabel" runat="server" Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                </ItemTemplate>
            </telerik:TreeListTemplateColumn>

            <telerik:TreeListTemplateColumn DataField="CreatedOn" HeaderText="<%$ Resources:Resource, lblCreatedOn %>" SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="False">
                <ItemTemplate>
                    <asp:Label ID="CreatedOnLabel" runat="server" Text='<%# Eval("CreatedOn") %>'></asp:Label>
                </ItemTemplate>
            </telerik:TreeListTemplateColumn>

            <telerik:TreeListTemplateColumn DataField="EditFrom" HeaderText="<%$ Resources:Resource, lblEditFrom %>" SortExpression="EditFrom" UniqueName="EditFrom" Visible="False">
                <ItemTemplate>
                    <asp:Label ID="EditFromLabel" runat="server" Text='<%# Eval("EditFrom") %>'></asp:Label>
                </ItemTemplate>
            </telerik:TreeListTemplateColumn>

            <telerik:TreeListTemplateColumn DataField="EditOn" HeaderText="<%$ Resources:Resource, lblEditOn %>" SortExpression="EditOn" UniqueName="EditOn" Visible="true">
                <ItemTemplate>
                    <asp:Label ID="EditOnLabel" runat="server" Text='<%# Eval("EditOn") %>'></asp:Label>
                </ItemTemplate>
            </telerik:TreeListTemplateColumn>

            <telerik:TreeListTemplateColumn DataField="RequestFrom" HeaderText="<%$ Resources:Resource, lblRequestFrom %>" SortExpression="RequestFrom" UniqueName="RequestFrom" Visible="False">
                <ItemTemplate>
                    <asp:Label ID="RequestFromLabel" runat="server" Text='<%# Eval("RequestFrom") %>'></asp:Label>
                </ItemTemplate>
            </telerik:TreeListTemplateColumn>

            <telerik:TreeListTemplateColumn DataField="RequestOn" HeaderText="<%$ Resources:Resource, lblRequestOn %>" SortExpression="RequestOn" UniqueName="RequestOn" Visible="False">
                <ItemTemplate>
                    <asp:Label ID="LabelRequestOn" runat="server" Text='<%# Eval("RequestOn") %>'></asp:Label>
                </ItemTemplate>
            </telerik:TreeListTemplateColumn>

            <telerik:TreeListTemplateColumn DataField="ReleaseFrom" HeaderText="<%$ Resources:Resource, lblReleaseFrom %>" SortExpression="ReleaseFrom" UniqueName="ReleaseFrom" Visible="False">
                <ItemTemplate>
                    <asp:Label ID="ReleaseFromLabel" runat="server" Text='<%# Eval("ReleaseFrom") %>'></asp:Label>
                </ItemTemplate>
            </telerik:TreeListTemplateColumn>

            <telerik:TreeListTemplateColumn DataField="ReleaseOn" HeaderText="<%$ Resources:Resource, lblReleaseOn %>" SortExpression="ReleaseOn" UniqueName="ReleaseOn" Visible="False">
                <ItemTemplate>
                    <asp:Label ID="ReleaseOnLabel" runat="server" Text='<%# Eval("ReleaseOn") %>'></asp:Label>
                </ItemTemplate>
            </telerik:TreeListTemplateColumn>

            <telerik:TreeListTemplateColumn DataField="LockedFrom" HeaderText="<%$ Resources:Resource, lblLockedFrom %>" SortExpression="LockedFrom" UniqueName="LockedFrom" Visible="False">
                <ItemTemplate>
                    <asp:Label ID="LockedFromLabel" runat="server" Text='<%# Eval("LockedFrom") %>'></asp:Label>
                </ItemTemplate>
            </telerik:TreeListTemplateColumn>

            <telerik:TreeListTemplateColumn DataField="LockedOn" HeaderText="<%$ Resources:Resource, lblLockedOn %>" SortExpression="LockedOn" UniqueName="LockedOn" Visible="False">
                <ItemTemplate>
                    <asp:Label ID="LockedOnLabel" runat="server" Text='<%# Eval("LockedOn") %>'></asp:Label>
                </ItemTemplate>
            </telerik:TreeListTemplateColumn>

            <telerik:TreeListBoundColumn DataField="UserString1" HeaderText="UserString1" Visible="false" UniqueName="UserString1" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="UserString2" HeaderText="UserString2" Visible="false" UniqueName="UserString2" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="UserString3" HeaderText="UserString3" Visible="false" UniqueName="UserString3" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="UserString4" HeaderText="UserString4" Visible="false" UniqueName="UserString4" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListCheckBoxColumn DataField="UserBit1" DefaultInsertValue="false" HeaderText="UserBit1" Visible="false" UniqueName="UserBit1" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListCheckBoxColumn>

            <telerik:TreeListCheckBoxColumn DataField="UserBit2" DefaultInsertValue="false" HeaderText="UserBit2" Visible="false" UniqueName="UserBit2" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListCheckBoxColumn>

            <telerik:TreeListCheckBoxColumn DataField="UserBit3" DefaultInsertValue="false" HeaderText="UserBit3" Visible="false" UniqueName="UserBit3" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListCheckBoxColumn>

            <telerik:TreeListCheckBoxColumn DataField="UserBit4" DefaultInsertValue="false" HeaderText="UserBit4" Visible="false" UniqueName="UserBit4" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListCheckBoxColumn>

            <telerik:TreeListBoundColumn DataField="ParentID" HeaderText="ParentID" Visible="false" UniqueName="ParentID" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

        </Columns>
    </telerik:RadTreeList>

    <asp:SqlDataSource ID="SqlDataSource_CompaniesCentral" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT c.SystemID, c.CompanyID, c.NameVisible, c.NameAdditional, c.Description, c.AddressID, c.IsVisible, c.IsValid, c.TradeAssociation, c.BlnSOKA, c.CreatedFrom, c.CreatedOn, c.EditFrom, c.EditOn, a.Address1, a.Address2, a.Zip, a.City, a.State, a.CountryID, a.Phone, a.Email, a.WWW FROM System_Companies AS c INNER JOIN System_Addresses AS a ON c.SystemID = a.SystemID AND c.AddressID = a.AddressID WHERE (c.SystemID = @SystemID) AND (NOT (c.ReleaseOn IS NULL)) AND (c.LockedOn IS NULL) AND (NOT EXISTS (SELECT 1 AS Expr1 FROM Master_Companies AS m WHERE (SystemID = c.SystemID) AND (BpID = @BpID) AND (CompanyCentralID = c.CompanyID))) AND StatusID = 20 ORDER BY c.NameVisible">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter SessionField="CompanyID" DefaultValue="-1" Name="CompanyID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Countries" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT DISTINCT Master_Countries.CountryID, Master_Countries.NameVisible AS CountryName, View_Countries.FlagName FROM Master_Countries INNER JOIN View_Countries ON Master_Countries.CountryID = View_Countries.CountryID WHERE (Master_Countries.SystemID = @SystemID) AND (Master_Countries.BpID = @BpID) order by Master_Countries.NameVisible">
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
