<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="wcShortTermPassAccess.ascx.cs" Inherits="InSite.App.CustomControls.wcShortTermPassAccess" %>

<style type="text/css">
    .auto-style1 {
        width: 10px;
    }
</style>

<h1>
    <asp:Label runat="server" ID="LabelRadGridEmplAccess2" Text='<%# String.Concat(Resources.Resource.lblEmplAccess2, ":") %>'></asp:Label>
</h1>

<telerik:RadGrid ID="RadGrid2" runat="server" DataSourceID="AccessEventsDataSource" AllowFilteringByColumn="True">
   <GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>
   <MasterTableView AutoGenerateColumns="False" CommandItemDisplay ="Top" EditMode ="EditForms"  DataSourceID="AccessEventsDataSource" 
                        AllowAutomaticInserts ="true" AllowAutomaticUpdates ="true" AllowAutomaticDeletes ="true"  AllowPaging ="true"  
                        PageSize="5"  DataKeyNames ="AccessEventID, SystemID, BpID" BorderStyle ="None"  >

        <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="false" />
        <NestedViewTemplate>
            <fieldset style="padding: 10px; width: 500px; margin-left: 10px; margin-bottom: 10px;">
                <legend style="padding: 5px; background-color: transparent;">
                    <b><%= Resources.Resource.lblDetailsFor %> <%# Convert.ToDateTime(Eval("AccessOn")).ToString("G") %></b>
                </legend>
                <table>
                    <tr>
                        <td nowrap="nowrap">
                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblTimeStamp, ":") %>'></asp:Label>
                        </td>
                        <td nowrap="nowrap">
                            <asp:Label runat="server" Text='<%# Convert.ToDateTime(Eval("AccessOn")).ToString("G") %>'></asp:Label>
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
                        <td nowrap="nowrap" class="auto-style1">
                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAccessArea, ":") %>'></asp:Label>
                        </td>
                        <td nowrap="nowrap">
                           <%-- <asp:Label runat="server" Text='<%# Eval("NameVisible") %>'></asp:Label>--%>
                            <telerik:RadComboBox ID="RadComboBox1" Runat="server" Culture="de-DE" DataSourceID="AccessAreaDataSource" DataTextField="Value" DataValueField="Key" Enabled="False" SelectedValue='<%# Bind("AccessAreaId") %>'>
                            </telerik:RadComboBox>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap" class="auto-style1">
                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblStatus, ":") %>'></asp:Label>
                        </td>
                        <td nowrap="nowrap">
                            <asp:Label runat="server" Text='<%# Convert.ToBoolean(Eval("IsOnlineAccessEvent")) ? Resources.Resource.lblOnline : Resources.Resource.lblOffline %>'></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap" class="auto-style1">
                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblResult, ":") %>'></asp:Label>
                        </td>
                        <td nowrap="nowrap">
                            <asp:Label runat="server" Text='<%# Eval("Result").ToString().Equals("1") ? Resources.Resource.lblOK : Resources.Resource.lblFault %>' 
                                        ForeColor='<%# Eval("Result").ToString().Equals("1") ? System.Drawing.Color.DarkGreen : System.Drawing.Color.Red %>'></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap" class="auto-style1">
                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblManual, ":") %>'></asp:Label>
                        </td>
                        <td nowrap="nowrap">
                            <asp:Label runat="server" Text='<%# Convert.ToBoolean(Eval("IsManualEntry")) ? Resources.Resource.lblYes : Resources.Resource.lblNo %>'></asp:Label>
                        </td>
                    </tr>
<%--                    <tr>
                        <td nowrap="nowrap">
                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblRemark, ":") %>'></asp:Label>
                        </td>
                        <td>
                            <asp:Label runat="server" Text='<%# Eval("Remark") %>'></asp:Label>
                        </td>
                    </tr>--%>
                    <tr>
                        <td nowrap="nowrap" class="auto-style1">
                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblDenialReason, ":") %>'></asp:Label>
                        </td>
                        <td>
                            <asp:Label runat="server" Text='<%# Eval("OriginalMessage") %>'></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblCreatedFrom, ":") %>'></asp:Label>
                        </td>
                        <td>
                            <asp:Label runat="server" Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblCreatedOn, ":") %>'></asp:Label>
                        </td>
                        <td>
                            <asp:Label runat="server" Text='<%# Eval("CreatedOn") %>'></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEditFrom, ":") %>'></asp:Label>
                        </td>
                        <td>
                            <asp:Label runat="server" Text='<%# Eval("EditFrom") %>'></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEditOn, ":") %>'></asp:Label>
                        </td>
                        <td>
                            <asp:Label runat="server" Text='<%# Eval("EditOn") %>'></asp:Label>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </NestedViewTemplate>

        <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="false"
                            ShowExportToExcelButton="false" ShowExportToPdfButton="false"
                            AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

        <EditFormSettings EditFormType="AutoGenerated" >
               <EditColumn ButtonType="PushButton" UniqueName="EditColumn2" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                        EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
        </EditFormSettings>

        <Columns>
        <%--    <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn5" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                            UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                <ItemStyle BackColor="Control" Width="30px" />
                <HeaderStyle Width="30px" />
            </telerik:GridEditCommandColumn>--%>

            <telerik:GridTemplateColumn AutoPostBackOnFilter="True" CurrentFilterFunction="Between" DataField="AccessOn" DataType="System.DateTime" 
                FilterControlWidth="100px" SortExpression="AccessOn" UniqueName="AccessOn" HeaderText="<%$ Resources:Resource, lblTimeStamp %>">
                <EditItemTemplate>
                    <telerik:RadDateTimePicker ID="AccessOnRadDateTimePicker" runat="server" DbSelectedDate='<%# Bind("AccessOn") %>'>
                    </telerik:RadDateTimePicker>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="AccessOnLabel" runat="server" Text='<%# Eval("AccessOn") %>'></asp:Label>
                </ItemTemplate>
            </telerik:GridTemplateColumn>

            <telerik:GridDropDownColumn UniqueName="AccessAreaId" DataField ="AccessAreaID" DataSourceID ="AccessAreaDataSource" 
                                        ListValueField ="key" ListTextField ="value"  HeaderText ="<%$ Resources:Resource, lblAccessArea %>">
                <ColumnValidationSettings EnableRequiredFieldValidation="True">
                </ColumnValidationSettings>
            </telerik:GridDropDownColumn>

            <telerik:GridTemplateColumn DataField="AccessTypeID" HeaderText="<%$ Resources:Resource, lblDirection %>" UniqueName="AccessTypeID" CurrentFilterFunction="Contains">
                <ItemTemplate>
                    <asp:Image runat="server" ImageUrl='<%# Eval("AccessTypeImage") %>' ToolTip='<%# Eval("AccessTypeToolTip") %>' Width="16px" Height="16px" />
                </ItemTemplate>

                <EditItemTemplate>
                    <telerik:RadButton runat="server" ID="Access" ButtonType="ToggleButton" ToggleType="Radio" GroupName ="myGroup"  AutoPostBack ="false"  Value ="1"
                                         Checked = '<%# Eval("IsComing")%>' Text="<%$ Resources:Resource, lblAccessTypeComing %>"></telerik:RadButton>

                     <asp:Image runat="server" ImageUrl="~/Resources/Icons/enter-16.png" Width="16px" Height="16px" />

                    <telerik:RadButton runat="server" ID="RadButton1" ButtonType="ToggleButton" ToggleType="Radio" GroupName ="myGroup" AutoPostBack ="false"  Value ="0"  
                                         Checked = '<%# Eval("IsLeaving")%>'  Text="<%$ Resources:Resource, lblAccessTypeLeaving %>"></telerik:RadButton>
                    <asp:Image runat="server" ImageUrl="~/Resources/Icons/exit-16.png" Width="16px" Height="16px"  />

                </EditItemTemplate>

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
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
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

            <telerik:GridBoundColumn DataField="OriginalMessage" HeaderText="<%$ Resources:Resource, lblDenialReason %>" ForceExtractValue="Always" SortExpression="OriginalMessage" 
                                        UniqueName="OriginalMessage" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="80px">
            </telerik:GridBoundColumn>

            <telerik:GridButtonColumn UniqueName="deleteColumn2" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                        ConfirmDialogType="RadWindow"
                                        ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                <HeaderStyle Width="30px" />
                <ItemStyle BackColor="Control" />
            </telerik:GridButtonColumn>
        </Columns>
    </MasterTableView>
</telerik:RadGrid>

<asp:ObjectDataSource ID="AccessEventsDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
    SelectMethod="GetData" TypeName="InSite.App.BLL.dtoAccessEvent" DataObjectTypeName="InSite.App.Models.clsAccessEvent" 
    DeleteMethod="Delete" InsertMethod="Insert" UpdateMethod="Update"  OnInserting="AccessEventsDataSource_Inserting" >
    <SelectParameters>
        <asp:SessionParameter Name="systemId" SessionField="SystemId" Type="Int32" />
        <asp:SessionParameter DefaultValue="" Name="bpId" SessionField="BpId" Type="Int32" />
        <asp:SessionParameter Name="internalId" SessionField="InternalId" Type="String" />
    </SelectParameters>
</asp:ObjectDataSource>

<asp:ObjectDataSource ID="AccessAreaDataSource" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InSite.App.BLL.dtoAccessArea">
     <SelectParameters>
         <asp:SessionParameter Name="systemId" SessionField="SystemId" Type="Int32" />
         <asp:SessionParameter Name="bpId" SessionField="BpId" Type="Int32" />
     </SelectParameters>
</asp:ObjectDataSource>

