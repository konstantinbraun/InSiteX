<%@ Page Title="<%$ Resources:Resource, lblEmplAccess2 %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AccessHistory.aspx.cs" Inherits="InSite.App.Views.Main.AccessHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <telerik:RadScriptBlock ID="RadCodeBlock1" runat="server">
        <script type="text/javascript">
            function getValueFromApplet(myParam, myParam2) {
                var grid = $find("<%=RadGrid1.ClientID %>");
                var masterTableView = grid.get_masterTableView();
                masterTableView.clearFilter();
                masterTableView.filter("InternalID", myParam, Telerik.Web.UI.GridFilterFunction.Contains, true);
            }

            var currentIndex = -1;
            function onClientItemClicked(sender, args) {
                var commandName = args.get_item().get_value();
                $find('<%= RadGrid1.ClientID %>').fireCommand(commandName, currentIndex);
            }

            function onRowContextMenu(sender, eventArgs) {
                var menu = $telerik.findControl(document, "RadContextMenu1");
                var evt = eventArgs.get_domEvent();
                if (evt.target.tagName === "INPUT" || evt.target.tagName === "A") {
                    return;
                }
 
                var index = eventArgs.get_itemIndexHierarchical();
                document.getElementById("radGridClickedRowIndex").value = index;
 
                sender.get_masterTableView().selectItem(sender.get_masterTableView().get_dataItems()[index].get_element(), true);
 
                menu.show(evt);
                evt.cancelBubble = true;
                evt.returnValue = false;
 
                if (evt.stopPropagation) {
                    evt.stopPropagation();
                    evt.preventDefault();
                }
            }

            cardReader.register({
                name: "FilterInternalId",
                uuid: "D5109126-69ED-401C-AB7E-829DCAF50BA9",
                onmessage: function (cardState) {
                    if (cardState.online == true) {
                        if (typeof cardState.cardId !== "undefined") {
                            var grid = $find("<%=RadGrid1.ClientID %>");
                            var masterTableView = grid.get_masterTableView();
                            masterTableView.clearFilter();
                            masterTableView.filter("InternalID", cardState.cardId, Telerik.Web.UI.GridFilterFunction.Contains, true);
                        }
                    }
                }
            });
        </script>

    </telerik:RadScriptBlock>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <telerik:RadScriptBlock ID="RadScriptBlock2" runat="server">
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
                    <telerik:AjaxUpdatedControl ControlID="RadContextMenu1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadContextMenu1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                    <telerik:AjaxUpdatedControl ControlID="RadContextMenu1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="PresentFilter">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="Timer1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" />
                    <telerik:AjaxUpdatedControl ControlID="PanelAccessInfo" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <asp:Panel ID="PanelTimer" runat="server">
        <asp:Timer ID="Timer1" runat="server" Interval="15000" OnTick="Timer1_Tick" Enabled="false">
        </asp:Timer>
    </asp:Panel>

    <div style="background-color: InactiveBorder;">
        <asp:Panel runat="server" ID="PanelAccessInfo">
            <table>
                <tr>
                    <td style="vertical-align: top;">
                        <table>
                            <tr>
                                <td style="text-align: right; padding-left: 5px;">
                                    <asp:Image runat="server" ID="Signal" ImageUrl="/InSiteApp/Resources/Icons/Offline_24.png" Width="24px" Height="24px" />
                                </td>
                                <td style="padding-left: 5px;">
                                    <asp:Label runat="server" ID="SignalText"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right; padding-left: 5px;">
                                    <asp:Image runat="server" ID="Terminals" ImageUrl="/InSiteApp/Resources/Icons/TerminalsOffline_24.png" Width="24px" Height="24px" />
                                </td>
                                <td style="padding-left: 5px;">
                                    <asp:Label runat="server" ID="TerminalsText"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: left; color: gray; padding-left: 5px;" colspan="2">
                                    <%= String.Concat(Resources.Resource.lblLastUpdate, ":") %>
                                    <asp:Label ID="LabelLastUpdate" runat="server" Text="" ForeColor="Black"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="border-right-color: ActiveBorder; border-right-style: solid; border-right-width: 1px;">&nbsp;</td>
                    <td>&nbsp;</td>
                    <td style="vertical-align: top;">
                        <table>
                            <tr>
                                <td style="text-align: right;">
                                    <asp:Image ID="Image66" runat="server" ImageUrl="~/Resources/Icons/Staff.png" Width="24px" Height="24px" ToolTip="<%# Resources.Resource.lblEmployee %>" />
                                </td>
                                <td style="text-align: right; color: gray;">
                                <%= String.Concat(Resources.Resource.lblEmployeesPresent, ":") %>
                                </td>
                                <td style="padding-left: 5px; vertical-align: middle;">
                                    <asp:Label ID="LabelEmployeesPresent" runat="server" Text=""></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right; color: gray; width: 150px;" colspan="2">
                                    <asp:Label ID="LabelEmployeesFaultyHeader" runat="server" Visible="false"></asp:Label>
                                </td>
                                <td style="padding-left: 5px; vertical-align: bottom;">
                                    <asp:Label ID="LabelEmployeesFaulty" runat="server" Text="" ForeColor="Red" Visible="false"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right;">
                                    <asp:Image ID="Image55" runat="server" ImageUrl="~/Resources/Icons/ShortTermPass.png" Width="24px" Height="24px" ToolTip="<%# Resources.Resource.lblVisitor %>" />
                                </td>
                                <td style="text-align: right; color: gray;">
                                <%= String.Concat(Resources.Resource.lblVisitorsPresent, ":") %>
                                </td>
                                <td style="padding-left: 5px; vertical-align: middle;">
                                    <asp:Label ID="LabelVisitorsPresent" runat="server" Text=""></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right; color: gray;" colspan="2">
                                    <asp:Label ID="LabelVisitorsFaultyHeader" runat="server" Visible="false"></asp:Label>
                                </td>
                                <td style="padding-left: 5px; vertical-align: bottom;">
                                    <asp:Label ID="LabelVisitorsFaulty" runat="server" Text="" ForeColor="Red"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="border-right-color: ActiveBorder; border-right-style: solid; border-right-width: 1px;">&nbsp;</td>
                    <td>&nbsp;</td>
                    <td style="vertical-align: top;">
                        <table>
                            <tr>
                                <td style="text-align: right;">
                                    <asp:Image ID="Image5" runat="server" ImageUrl="~/Resources/Icons/enter-24.png" Width="24px" Height="24px" ToolTip="<%# Resources.Resource.lblLastAccess %>" />
                                </td>
                                <td style="text-align: right; color: gray;">
                                <%= String.Concat(Resources.Resource.lblLastAccess, ":") %>
                                </td>
                                <td style="padding-left: 5px;" nowrap="nowrap">
                                    <asp:Label ID="LabelLastAccess" runat="server" Text=""></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right;">
                                    <asp:Image ID="Image6" runat="server" ImageUrl="~/Resources/Icons/exit-24.png" Width="24px" Height="24px" ToolTip="<%# Resources.Resource.lblLastExit %>" />
                                </td>
                                <td style="text-align: right; color: gray;">
                                <%= String.Concat(Resources.Resource.lblLastExit, ":") %>
                                </td>
                                <td style="padding-left: 5px;" nowrap="nowrap">
                                    <asp:Label ID="LabelLastExit" runat="server" Text=""></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right; color: gray;" colspan="2">
                                <%= String.Concat(Resources.Resource.lblLastCorrectionAccessEvents, ":") %>
                                </td>
                                <td style="padding-left: 5px;" nowrap="nowrap">
                                    <asp:Label ID="LastCorrection" runat="server" Text=""></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="border-right-color: ActiveBorder; border-right-style: solid; border-right-width: 1px;">&nbsp;</td>
                    <td>&nbsp;</td>
                    <td style="vertical-align: top;">
                        <table>
                            <tr>
                                <td>
                                <%= String.Concat(Resources.Resource.lblPresentState, ":") %>
                                </td>
                                <td>
                                    <telerik:RadComboBox ID="PresentFilter" runat="server" OnSelectedIndexChanged="PresentFilter_SelectedIndexChanged"
                                                         AppendDataBoundItems="true" DropDownAutoWidth="Enabled" Width="170px" AutoPostBack="true">
                                        <Items>
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" Value="-1" Selected="true" />
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAccessStatePresent %>" Value="1" />
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAccessStateAbsent %>" Value="0" />
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAccessStateUndefined %>" Value="2" />
                                        </Items>
                                    </telerik:RadComboBox>
                                </td>
                            </tr>
<%--                            <tr>
                                <td>
                                <%= String.Concat(Resources.Resource.lblAutoRefresh, ":") %>
                                </td>
                                <td>
                                    <asp:CheckBox runat="server" ID="AutoRefresh" Checked="false" OnCheckedChanged="AutoRefresh_CheckedChanged" AutoPostBack="true" />
                                </td>
                            </tr>--%>
                        </table>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </div>

    <telerik:RadContextMenu ID="RadContextMenu1" runat="server" OnItemClick="RadContextMenu1_ItemClick" EnableRoundedCorners="true" EnableShadows="true">
        <Items>
            <telerik:RadMenuItem Text="<%$ Resources:Resource, lblActionNew %>" Value="InitInsert" ImageUrl="/InSiteApp/Resources/Icons/edit-add.png"></telerik:RadMenuItem>
            <telerik:RadMenuItem Text="<%$ Resources:Resource, lblActionEdit %>" Value="Edit" ImageUrl="/InSiteApp/Resources/Icons/edit-3.png"></telerik:RadMenuItem>
            <telerik:RadMenuItem Text="<%$ Resources:Resource, lblActionDelete %>" Value="Delete" ImageUrl="/InSiteApp/Resources/Icons/edit-delete-6.png"></telerik:RadMenuItem>
        </Items>
    </telerik:RadContextMenu>

    <input type="hidden" id="radGridClickedRowIndex" name="radGridClickedRowIndex" />

    <telerik:RadGrid runat="server" ID="RadGrid1" AllowSorting="true" CssClass="MainGrid" AllowFilteringByColumn="true" EnableHeaderContextMenu="true" EnableHeaderContextFilterMenu="true"
                     GroupPanelPosition="BeforeHeader" ShowGroupPanel="true" GroupingEnabled="true" ShowStatusBar="true" EnableLinqExpressions="true"
                     OnItemDataBound="RadGrid1_ItemDataBound" OnPreRender="RadGrid1_PreRender" OnItemCommand="RadGrid1_ItemCommand" OnItemCreated="RadGrid1_ItemCreated"
                     OnNeedDataSource="RadGrid1_NeedDataSource" OnGroupsChanging="RadGrid1_GroupsChanging" OnDeleteCommand="RadGrid1_DeleteCommand"
                     OnInsertCommand="RadGrid1_InsertCommand">

        <GroupingSettings ShowUnGroupButton="True" CaseSensitive="false" />

        <ExportSettings ExportOnlyData="false" IgnorePaging="true" FileName="AccessHistory" >
            <Pdf PaperSize="A4">
            </Pdf>
            <Excel Format="Xlsx" AutoFitImages="true" DefaultCellAlignment="Left" FileExtension="xlsx" />
        </ExportSettings>

        <ClientSettings AllowColumnsReorder="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false" AllowExpandCollapse="true" AllowGroupExpandCollapse="true" AllowDragToGroup="True"
                        ReorderColumnsOnClient="True" >
            <Selecting AllowRowSelect="True" />
            <ClientEvents OnRowClick="OnRowClick" OnKeyPress="GridKeyPress" OnRowContextMenu="onRowContextMenu" />
        </ClientSettings>

        <SortingSettings SortedBackColor="Transparent" />

        <MasterTableView AutoGenerateColumns="false" AllowPaging="true" PageSize="20" AllowSorting="true" AllowMultiColumnSorting="true" AllowNaturalSort="true"
                         CommandItemDisplay="Top" DataKeyNames="AccessEventID" AllowFilteringByColumn="true" FilterItemStyle-VerticalAlign="Bottom"
                         FilterExpression='Int32(it[ "Result" ]) = 1' HierarchyLoadMode="ServerOnDemand" GroupLoadMode="Client" EnableGroupsExpandAll="true" EditMode="PopUp" 
                         AllowAutomaticDeletes="false" AllowAutomaticInserts="false" AllowAutomaticUpdates="false">

            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" PageSizes="10,20,50,100" Position="TopAndBottom" />

            <SortExpressions>
                <telerik:GridSortExpression FieldName="Timestamp" SortOrder="Descending"></telerik:GridSortExpression>
            </SortExpressions>

            <CommandItemTemplate>
                <div style="margin: 3px; height: 20px;">
                    <telerik:RadButton ID="btnInitInsert" runat="server" CommandName="InitInsert" Visible="true" Text='<%# Resources.Resource.lblActionNew %>'
                                       Icon-PrimaryIconCssClass="rbAdd" ButtonType="SkinnedButton" BorderStyle="None" BackColor="Transparent">
                    </telerik:RadButton>

<%--                    <telerik:RadButton ID="btnExportExcel" runat="server" Text="" ToolTip='<%# Resources.Resource.lblExportToExcel %>' CssClass="rgExpXLS FloatRight" CommandName="ExportToExcel"
                                       ButtonType="SkinnedButton" Visible="true" BorderStyle="None" BackColor="Transparent" Width="30px" Height="20px">
                        <Icon PrimaryIconUrl="../../Resources/Icons/export_xlsx_16.png" />
                    </telerik:RadButton>--%>

                    <telerik:RadButton ID="btnExportExcel" runat="server" Text="" ToolTip='<%# Resources.Resource.lblExportToExcel %>' CssClass="rgExpXLS FloatRight" 
                                       ButtonType="SkinnedButton" Visible="true" BorderStyle="None" BackColor="Transparent" Width="30px" Height="20px" OnClick="btnExportExcel_Click">
                        <Icon PrimaryIconUrl="../../Resources/Icons/export_xlsx_16.png" />
                    </telerik:RadButton>

                    <div class="vertical-line"></div>

                    <telerik:RadButton ID="btnRefresh" runat="server" CommandName="RebindGrid" Text='<%# Resources.Resource.lblActionRefresh %>' AutoPostBack="true"
                                       Icon-PrimaryIconCssClass="rbRefresh" ButtonType="SkinnedButton" BorderStyle="None" CssClass="FloatRight" BackColor="Transparent">
                    </telerik:RadButton>

                    <div class="vertical-line"></div>

                        <table class="FloatRight">
                            <tr>
                                <td>
                                <%= String.Concat(Resources.Resource.lblAutoRefresh, ":") %>
                                </td>
                                <td>
                                    <asp:CheckBox runat="server" ID="AutoRefresh" Checked="<%# Timer1.Enabled %>" AutoPostBack="true" OnCheckedChanged="AutoRefresh_CheckedChanged" />
                                </td>
                            </tr>
                        </table>

                </div>
            </CommandItemTemplate>

            <EditFormSettings CaptionDataField="NameVisible" CaptionFormatString="{0}" EditFormType="Template">

                <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />

                <EditColumn ButtonType="ImageButton" UniqueName="EditColumn2" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                            EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />

                <FormTableStyle CellPadding="3" CellSpacing="3" />

                <FormTemplate>
                    <table>
                        <tr>
                            <td nowrap="nowrap">
                                <asp:Label runat="server" Font-Bold="true" Text='<%# String.Concat(Resources.Resource.lblEmployee, ":") %>'></asp:Label>
                            </td>
                            <td nowrap="nowrap">
                                <telerik:RadComboBox runat="server" ID="EmployeeID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                     DataSourceID="SqlDataSource_EmployeeDropDown" 
                                                     DataValueField="EmployeeID" DataTextField="EmployeeName" Width="300" Filter="Contains" 
                                                     DropDownAutoWidth="Enabled" Enabled="true">
                                </telerik:RadComboBox>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="EmployeeID" Text="*" SetFocusOnError="true" ForeColor="Red"
                                                            ErrorMessage='<%# String.Concat(Resources.Resource.lblEmployee, " ", Resources.Resource.lblRequired) %>'
                                                            ValidationGroup="AccessArea">
                                </asp:RequiredFieldValidator>
                            </td>
                        </tr>
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
                                <telerik:RadTextBox runat="server" ID="Remark" Width="300px" ></telerik:RadTextBox>
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
                                <asp:Label ID="Label34" runat="server" Text='<%# String.Concat(Resources.Resource.lblID, ":") %>'></asp:Label>
                            </td>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label35" runat="server" Text='<%# Eval("AccessEventID") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label36" runat="server" Text='<%# String.Concat(Resources.Resource.lblLinkedWith, ":") %>'></asp:Label>
                            </td>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label37" runat="server" Text='<%# Eval("AccessEventLinkedID") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label1" runat="server" Text='<%# String.Concat(Resources.Resource.lblTimeStamp, ":") %>'></asp:Label>
                            </td>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label2" runat="server" Text='<%# Convert.ToDateTime(Eval("Timestamp")).ToString("G") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label3" runat="server" Text='<%# String.Concat(Resources.Resource.lblDirection, ":") %>'></asp:Label>
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
                                            <asp:Image ID="Image1" runat="server" ImageUrl="~/Resources/Icons/enter-16.png" Width="16px" Height="16px" />
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
                                            <asp:Image ID="Image2" runat="server" ImageUrl="~/Resources/Icons/exit-16.png" Width="16px" Height="16px" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label14" runat="server" Text='<%# String.Concat(Resources.Resource.lblResult, ":") %>'></asp:Label>
                            </td>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label15" runat="server" Text='<%# Eval("Result").ToString().Equals("1") ? Resources.Resource.lblOK : Resources.Resource.lblFault %>' 
                                           ForeColor='<%# Eval("Result").ToString().Equals("1") ? System.Drawing.Color.DarkGreen : System.Drawing.Color.Red %>'></asp:Label>
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
                            <td nowrap="nowrap">
                                <asp:Label ID="Label12" runat="server" Text='<%# String.Concat(Resources.Resource.lblStatus, ":") %>'></asp:Label>
                            </td>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label13" runat="server" Text='<%# Convert.ToBoolean(Eval("IsOnlineAccessEvent")) ? Resources.Resource.lblOnline : Resources.Resource.lblOffline %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label16" runat="server" Text='<%# String.Concat(Resources.Resource.lblManual, ":") %>'></asp:Label>
                            </td>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label17" runat="server" Text='<%# Convert.ToBoolean(Eval("IsManualEntry")) ? Resources.Resource.lblYes : Resources.Resource.lblNo %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label4" runat="server" Text='<%# String.Concat(Resources.Resource.lblChipID, ":") %>'></asp:Label>
                            </td>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label5" runat="server" Text='<%# Eval("InternalID") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label30" runat="server" Text='<%# String.Concat(Resources.Resource.lblPassID, ":") %>'></asp:Label>
                            </td>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label31" runat="server" Text='<%# Eval("ExternalPassID") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label40" runat="server" Text='<%# String.Concat(Resources.Resource.lblOwnerID, ":") %>'></asp:Label>
                            </td>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label41" runat="server" Text='<%# Eval("EmployeeID") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label6" runat="server" Text='<%# String.Concat(Resources.Resource.lblAccessArea, ":") %>'></asp:Label>
                            </td>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label7" runat="server" Text='<%# Eval("NameVisible") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label32" runat="server" Text='<%# String.Concat(Resources.Resource.lblEntry, ":") %>'></asp:Label>
                            </td>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label33" runat="server" Text='<%# Eval("EntryID") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label8" runat="server" Text='<%# String.Concat(Resources.Resource.lblPassHolder, ":") %>'></asp:Label>
                            </td>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label9" runat="server" Text='<%# Eval("EmployeeName") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label10" runat="server" Text='<%# String.Concat(Resources.Resource.lblCompany, ":") %>'></asp:Label>
                            </td>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label11" runat="server" Text='<%# Eval("CompanyName") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label38" runat="server" Text='<%# String.Concat(Resources.Resource.lblCountsAs, ":") %>'></asp:Label>
                            </td>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label39" runat="server" Text='<%# Convert.ToBoolean(Eval("CountIt")) ? "1" : "0" %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap">
                                <asp:Label ID="Label18" runat="server" Text='<%# String.Concat(Resources.Resource.lblRemark, ":") %>'></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label19" runat="server" Text='<%# Eval("Remark") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label20" runat="server" Text='<%# String.Concat(Resources.Resource.lblCreatedFrom, ":") %>'></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label21" runat="server" Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label22" runat="server" Text='<%# String.Concat(Resources.Resource.lblCreatedOn, ":") %>'></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label23" runat="server" Text='<%# Eval("CreatedOn") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label24" runat="server" Text='<%# String.Concat(Resources.Resource.lblEditFrom, ":") %>'></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label25" runat="server" Text='<%# Eval("EditFrom") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label26" runat="server" Text='<%# String.Concat(Resources.Resource.lblEditOn, ":") %>'></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label27" runat="server" Text='<%# Eval("EditOn") %>'></asp:Label>
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </NestedViewTemplate>

            <Columns>
                <telerik:GridDateTimeColumn FilterControlWidth="100px" DataField="Timestamp" HeaderText="<%$ Resources:Resource, lblTimestamp %>" DataFormatString="{0:G}" 
                                            SortExpression="Timestamp" UniqueName="Timestamp" PickerType="DatePicker" EnableRangeFiltering="true" 
                                            CurrentFilterFunction="Between" DataType="System.DateTime" 
                                            AutoPostBackOnFilter="true" EnableTimeIndependentFiltering="true" Exportable="false">
                    <ItemStyle HorizontalAlign="Right" Width="150px" />
                    <HeaderStyle Width="150px" />
                </telerik:GridDateTimeColumn>

                <telerik:GridTemplateColumn HeaderText="<%$ Resources:Resource, lblTimeStamp %>" UniqueName="Timestamp1" Exportable="true" Visible="false">
                    <ItemStyle HorizontalAlign="Right" />
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Timestamp1" Text='<%# Eval("Timestamp", "{0:G}") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="AccessTypeID" HeaderText="<%$ Resources:Resource, lblDirection %>" HeaderStyle-Width="30px" ItemStyle-Width="30px" 
                                            ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" UniqueName="AccessTypeID" AllowSorting="true"
                                            SortExpression="AccessTypeID" GroupByExpression="AccessTypeID Group By AccessTypeID">
                    <ItemTemplate>
                        <asp:Image ID="Image3" runat="server" ImageUrl='<%# (Convert.ToInt32(Eval("AccessTypeID")) == 1) ? "~/Resources/Icons/enter-16.png" : "~/Resources/Icons/exit-16.png" %>' 
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

                <telerik:GridTemplateColumn DataField="Result" HeaderText="<%$ Resources:Resource, lblResult %>" UniqueName="Result" CurrentFilterFunction="EqualTo" HeaderStyle-Width="30px" 
                                            ItemStyle-Width="30px" SortExpression="Result" CurrentFilterValue="1" GroupByExpression="Result Group By Result">
                    <HeaderStyle ForeColor="DarkRed" Font-Bold="true" />
                    <ItemTemplate>
                        <asp:Label ID="Label28" runat="server" Text='<%# Eval("Result").ToString().Equals("1") ? Resources.Resource.lblOK : Resources.Resource.lblFault %>' 
                                   ForeColor='<%# Eval("Result").ToString().Equals("1") ? System.Drawing.Color.DarkGreen : System.Drawing.Color.Red %>'></asp:Label>
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="ResultFilter" DataValueField="Result" Height="200px" AppendDataBoundItems="true" 
                                             SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("Result").CurrentFilterValue %>'
                                             runat="server" OnClientSelectedIndexChanged="ResultFilterIndexChanged" DropDownAutoWidth="Enabled" Width="50px">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" />
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

                <telerik:GridTemplateColumn DataField="IsOnlineAccessEvent" HeaderText="<%$ Resources:Resource, lblStatus %>"  HeaderStyle-Width="30px" ItemStyle-Width="30px"
                                            ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" UniqueName="IsOnlineAccessEvent" 
                                            AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" SortExpression="IsOnlineAccessEvent" GroupByExpression="IsOnlineAccessEvent Group By IsOnlineAccessEvent">
                    <ItemTemplate>
                        <asp:Image ID="Image4" runat="server" ImageUrl='<%# Convert.ToBoolean(Eval("IsOnlineAccessEvent")) ? "~/Resources/Icons/Online_16.png" : "~/Resources/Icons/Offline_16.png" %>' 
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

                <telerik:GridTemplateColumn DataField="IsManualEntry" HeaderText="<%$ Resources:Resource, lblManual %>" HeaderStyle-Width="30px" ItemStyle-Width="30px"
                                            UniqueName="IsManualEntry" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" SortExpression="IsManualEntry" GroupByExpression="IsManualEntry Group By IsManualEntry">
                    <ItemTemplate>
                        <asp:Label ID="Label29" runat="server" Text='<%# Convert.ToBoolean(Eval("IsManualEntry")) ? Resources.Resource.lblYes : Resources.Resource.lblNo %>'></asp:Label>
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

                <telerik:GridTemplateColumn DataField="PassType" HeaderText="<%$ Resources:Resource, lblType %>"  HeaderStyle-Width="30px" ItemStyle-Width="30px"
                                            ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" UniqueName="PassType" 
                                            AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" SortExpression="PassType" GroupByExpression="PassType Group By PassType">
                    <ItemTemplate>
                        <asp:Image ID="Image44" runat="server" ImageUrl='<%# (Convert.ToInt32(Eval("PassType")) == 1) ? "~/Resources/Icons/Staff_16.png" : "~/Resources/Icons/ShortTermPass.png" %>' 
                                   Width="16px" Height="16px" ToolTip='<%# (Convert.ToInt32(Eval("PassType")) == 1) ? Resources.Resource.lblEmployee : Resources.Resource.lblVisitor %>' />
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="PassTypeFilter" DataValueField="PassType" Height="200px" AppendDataBoundItems="true" 
                                             SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("PassType").CurrentFilterValue %>'
                                             runat="server" OnClientSelectedIndexChanged="PassTypeFilterIndexChanged" DropDownAutoWidth="Enabled" Width="50px">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" Selected="true" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblEmployee %>" Value="1" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblVisitor %>" Value="2" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock321" runat="server">
                            <script type="text/javascript">
                                function PassTypeFilterIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    var filterVal = args.get_item().get_value();
                                    if (filterVal === "") {
                                        tableView.filter("PassType", filterVal, "NoFilter");
                                    } else if (filterVal === "1") {
                                        tableView.filter("PassType", "1", "EqualTo");
                                    } else if (filterVal === "2") {
                                        tableView.filter("PassType", "2", "EqualTo");
                                    }
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="EmployeeName" HeaderText="<%$ Resources:Resource, lblPassHolder %>" ForceExtractValue="Always" SortExpression="EmployeeName"
                                            UniqueName="EmployeeName" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="80px" GroupByExpression="EmployeeName Group By EmployeeName">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="EmployeeName" Text='<%# Eval("EmployeeName") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="CompanyName" HeaderText="<%$ Resources:Resource, lblCompany %>" ForceExtractValue="Always" SortExpression="CompanyName"
                                            UniqueName="CompanyName" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="80px" GroupByExpression="CompanyName Group By CompanyName">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="CompanyName" Text='<%# Eval("CompanyName") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="NameVisible" HeaderText="<%$ Resources:Resource, lblAccessArea %>" ForceExtractValue="Always" SortExpression="NameVisible"
                                            UniqueName="NameVisible" AutoPostBackOnFilter="true" FilterControlWidth="80px" GroupByExpression="NameVisible Group By NameVisible">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="NameVisible" Text='<%# Eval("NameVisible") %>'></asp:Label>
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="NameVisibleFilter" DataSourceID="SqlDataSource_AccessAreas" DataTextField="NameVisible"
                                             DataValueField="NameVisible" Height="200px" AppendDataBoundItems="true"
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

                <telerik:GridTemplateColumn DataField="InternalID" HeaderText="<%$ Resources:Resource, lblChipID %>" ForceExtractValue="Always" SortExpression="InternalID"
                                            UniqueName="InternalID" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="80px" 
                                            GroupByExpression="InternalID Group By InternalID">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="InternalID" Text='<%# Eval("InternalID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="ExternalPassID" HeaderText="<%$ Resources:Resource, lblPassID %>" ForceExtractValue="Always" SortExpression="ExternalPassID"
                                            UniqueName="ExternalPassID" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="80px" GroupByExpression="ExternalPassID Group By ExternalPassID">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="ExternalPassID" Text='<%# Eval("ExternalPassID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="EntryID" HeaderText="<%$ Resources:Resource, lblEntry %>" ForceExtractValue="Always" SortExpression="EntryID" AllowFiltering="true" 
                                            UniqueName="EntryID" AutoPostBackOnFilter="true" CurrentFilterFunction="EqualTo" FilterControlWidth="80px" 
                                            GroupByExpression="EntryID Group By EntryID">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="EntryID" Text='<%# Eval("EntryID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="OriginalMessage" HeaderText="<%$ Resources:Resource, lblDenialReason %>" ForceExtractValue="Always" SortExpression="OriginalMessage" 
                                            UniqueName="OriginalMessage" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="80px" GroupByExpression="OriginalMessage Group By OriginalMessage">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="OriginalMessage" Text='<%# Eval("OriginalMessage") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridDateTimeColumn FilterControlWidth="100px" DataField="CreatedOn" HeaderText="<%$ Resources:Resource, lblCreatedOn %>" DataFormatString="{0:G}" 
                                            SortExpression="CreatedOn" UniqueName="CreatedOn" PickerType="DatePicker" EnableRangeFiltering="true" 
                                            HeaderStyle-Width="150px" ItemStyle-Width="150px" CurrentFilterFunction="Between" DataType="System.DateTime" 
                                            AutoPostBackOnFilter="true" EnableTimeIndependentFiltering="true" Exportable="false" Display="false">
                </telerik:GridDateTimeColumn>

                <telerik:GridBoundColumn DataField="AccessEventID" UniqueName="AccessEventID" Display="false" HeaderText="<%$ Resources:Resource, lblID %>" ForceExtractValue="Always"
                                         FilterControlWidth="60px"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="AccessEventLinkedID" UniqueName="AccessEventLinkedID" Display="false" HeaderText="<%$ Resources:Resource, lblLinkedWith %>" ForceExtractValue="Always"
                                         FilterControlWidth="60px"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="CountIt" UniqueName="CountIt" Display="false" HeaderText="<%$ Resources:Resource, lblCountsAs %>" ForceExtractValue="Always"
                                         FilterControlWidth="60px"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="SystemID" UniqueName="SystemID" Visible="false" ForceExtractValue="Always"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="BpID" UniqueName="BpID" Visible="false" ForceExtractValue="Always"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn DataField="AccessAreaID" Visible="false"></telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="EmployeeID" UniqueName="EmployeeID2" Display="false" HeaderText="<%$ Resources:Resource, lblOwnerID %>" ForceExtractValue="Always"></telerik:GridBoundColumn>

                <telerik:GridButtonColumn UniqueName="deleteColumn" Visible="true" Text="<%$ Resources:Resource, lblActionDelete %>" ConfirmTextFormatString='<%$ Resources:Resource, qstDeleteRow1 %>'
                                          ConfirmTextFields="AccessEventID,InternalID,EmployeeName"  
                                          ConfirmDialogType="RadWindow" ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" 
                                          HeaderStyle-Width="20px" ItemStyle-Width="20px">
                    <ItemStyle BackColor="Control" />
                </telerik:GridButtonColumn>
            </Columns>
        </MasterTableView>
    </telerik:RadGrid>

    <asp:SqlDataSource ID="SqlDataSource_EmployeeDropDown" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>" 
                       SelectCommand="GetEmployeesDropDown" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" Name="SystemID" Type="Int32"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" Name="BpID" Type="Int32"></asp:SessionParameter>
            <asp:SessionParameter SessionField="CompanyID" Name="CompanyCentralID" Type="Int32"></asp:SessionParameter>
            <asp:SessionParameter SessionField="UserID" Name="UserID" Type="Int32"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_AccessAreas" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT DISTINCT * FROM Master_AccessAreas aa WHERE aa.SystemID = @SystemID AND aa.BpID = @BpID">
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
