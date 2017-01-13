    <%@ Page Title="<%$ Resources:Resource, lblBuildingProjects %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BuildingProjects.aspx.cs" 
Inherits="InSite.App.Views.Central.BuildingProjects" %>

<%@ Register Src="~/CustomControls/wcBpContact.ascx" TagPrefix="uc1" TagName="wcBpContact" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <telerik:RadPersistenceManagerProxy ID="RadPersistenceManagerProxy1" runat="server">
        <PersistenceSettings>
            <telerik:PersistenceSetting ControlID="RadGrid1" />
        </PersistenceSettings>
    </telerik:RadPersistenceManagerProxy>

    <telerik:RadGrid ID="RadGrid1" runat="server" AllowAutomaticInserts="True" AllowAutomaticUpdates="True" AllowFilteringByColumn="True" AllowPaging="True"
        AllowSorting="True" EnableHeaderContextFilterMenu="True" EnableHeaderContextMenu="True" DataSourceID="SqlDataSource_BuidingProjects" ShowGroupPanel="True" GroupPanelPosition="BeforeHeader"
        GroupPanel-Text="<%$ Resources:Resource, msgGroupPanel %>" CssClass="MainGrid"
        OnItemDeleted="RadGrid1_ItemDeleted" OnItemCommand="RadGrid1_ItemCommand" OnDeleteCommand="RadGrid1_DeleteCommand"
        OnItemInserted="RadGrid1_ItemInserted" OnItemUpdated="RadGrid1_ItemUpdated" OnPreRender="RadGrid1_PreRender" OnItemDataBound="RadGrid1_ItemDataBound"
        OnGroupsChanging="RadGrid1_GroupsChanging" OnItemCreated="RadGrid1_ItemCreated">

        <GroupingSettings ShowUnGroupButton="True" />

        <ExportSettings ExportOnlyData="True" IgnorePaging="True">
            <Pdf PaperSize="A4">
            </Pdf>
            <Excel Format="ExcelML" />
        </ExportSettings>

        <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false">
            <Resizing AllowColumnResize="true"></Resizing>
            <Selecting AllowRowSelect="True" />
            <ClientEvents OnRowClick="OnRowClick" OnGridCreated="OnGridCreated" OnKeyPress="GridKeyPress" />
        </ClientSettings>

        <SortingSettings SortedBackColor="Transparent" />

        <MasterTableView EnableHierarchyExpandAll="true" EditMode="PopUp" AutoGenerateColumns="False" DataKeyNames="SystemID,BpID" DataSourceID="SqlDataSource_BuidingProjects"
                         CommandItemDisplay="Top" HierarchyLoadMode="Client" AllowMultiColumnSorting="true" PageSize="15">

            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" PageSizes="15,30,60" />

            <EditFormSettings CaptionDataField="NameVisible" CaptionFormatString="{0}">
                <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                <EditColumn ButtonType="ImageButton" UniqueName="EditCommandColumn1" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                            UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                <FormTableStyle CellPadding="3" CellSpacing="3" />
            </EditFormSettings>

            <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="false" ShowExportToExcelButton="True" ShowExportToPdfButton="false"
                                 AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

            <Columns>
                <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                               UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false" >
                    <ItemStyle BackColor="Control" Width="30px" />
                    <HeaderStyle Width="30px" />
                </telerik:GridEditCommandColumn>

                <telerik:GridTemplateColumn DataField="BpID" DataType="System.Int32" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter BpID column" 
                                            HeaderText="<%$ Resources:Resource, lblBpID %>" SortExpression="BpID" UniqueName="BpID" Visible="true" HeaderStyle-HorizontalAlign="Right"
                                            ItemStyle-HorizontalAlign="Right" AllowFiltering="false" HeaderStyle-Width="50px" ItemStyle-Width="50px">
                    <EditItemTemplate>
                        <asp:Label ID="BpID" runat="server" Text='<%# Eval("BpID") %>'></asp:Label>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" ID="BpID" Text='<%# Eval("BpID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="NameVisible" HeaderText="<%$ Resources:Resource, lblNameVisible %>" SortExpression="NameVisible" UniqueName="NameVisible"
                                            GroupByExpression="NameVisible NameVisible GROUP BY NameVisible" ItemStyle-Wrap="false" FilterControlWidth="80px">
                    <EditItemTemplate>
                        <telerik:RadTextBox runat="server" ID="NameVisible" Text='<%# Bind("NameVisible") %>' Width="300px"></telerik:RadTextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="NameVisible" Text="*" ForeColor="Red" 
                                                    ErrorMessage='<%# String.Concat(Resources.Resource.lblNameVisible, " ", Resources.Resource.lblRequired) %>'></asp:RequiredFieldValidator>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:HyperLink ID="HyperLink1" runat="server" Text ='<%# ((System.Data.DataRowView)Container.DataItem)["NameVisible"] %>' NavigateUrl ='<%# Eval("BpID","~/Views/Central/BpContact.aspx?id={0}") %>'></asp:HyperLink>
<%--                        <asp:Label runat="server" ID="NameVisible" Text='<%# ((System.Data.DataRowView)Container.DataItem)["NameVisible"] %>'></asp:Label>--%>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="DescriptionShort" FilterControlAltText="Filter DescriptionShort column" HeaderText="<%$ Resources:Resource, lblDescriptionShort %>"
                                            SortExpression="DescriptionShort" UniqueName="DescriptionShort" GroupByExpression="DescriptionShort DescriptionShort GROUP BY DescriptionShort"
                                            FilterControlWidth="80px">
                    <EditItemTemplate>
                        <telerik:RadTextBox runat="server" ID="DescriptionShort" Text='<%# Bind("DescriptionShort") %>' Width="300px"></telerik:RadTextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" ID="LabelDescriptionShort" Text='<%# Eval("DescriptionShort") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="ContainerManagementName" HeaderText="<%$ Resources:Resource, lblContainerManagementName %>" SortExpression="ContainerManagementName" 
                                            UniqueName="ContainerManagementName" GroupByExpression="ContainerManagementName ContainerManagementName GROUP BY ContainerManagementName" 
                                            ItemStyle-Wrap="false" Visible="false" InsertVisiblityMode="AlwaysVisible">
                    <EditItemTemplate>
                        <telerik:RadTextBox runat="server" ID="ContainerManagementName" Text='<%# Bind("ContainerManagementName") %>' Width="270px"></telerik:RadTextBox>
                    <telerik:RadButton ID="InitContainerManagement" runat="server" CommandName="InitContainerManagement" Visible="true" ToolTip='<%# Resources.Resource.lblInitContainerManagement %>'
                                       Icon-PrimaryIconCssClass="rbUpload" ButtonType="SkinnedButton" BorderStyle="None" BackColor="Transparent" Width="24px" Enabled="false">
                    </telerik:RadButton>
                    </EditItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="TypeID" DataType="System.Byte" FilterControlAltText="Filter TypeID column" HeaderText="<%$ Resources:Resource, lblType %>"
                                            SortExpression="TypeID" UniqueName="TypeID" GroupByExpression="TypeID TypeID GROUP BY TypeID">
                    <EditItemTemplate>
                        <asp:Label runat="server" Text='<%# GetBpTypeName(Convert.ToInt32(Eval("TypeID"))) %>'></asp:Label>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <telerik:RadDropDownList ID="RadDropDownList1" runat="server" SelectedValue='<%# Bind("TypeID") %>' Width="300px">
                            <Items>
                                <telerik:DropDownListItem runat="server" Selected="True" Text="<%$ Resources:Resource, lblBuildingProject %>" Value="1" />
                                <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, lblTemplate %>" Value="2" />
                            </Items>
                        </telerik:RadDropDownList>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="RadDropDownList1" Text="*" ForeColor="Red" 
                                                    ErrorMessage='<%# String.Concat(Resources.Resource.lblType, " ", Resources.Resource.lblRequired) %>'></asp:RequiredFieldValidator>
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" Text='<%# GetBpTypeName(Convert.ToInt32(Eval("TypeID"))) %>'></asp:Label>
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="TypeIDCombo" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("TypeID").CurrentFilterValue %>'
                                             runat="server" OnClientSelectedIndexChanged="TypeIDComboIndexChanged">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" Value="" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblBuildingProject %>" Value="1" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblTemplate %>" Value="2" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock3" runat="server">
                            <script type="text/javascript">
                                function TypeIDComboIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    tableView.filter("TypeID", args.get_item().get_value(), "EqualTo");
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="BasedOn" FilterControlAltText="Filter TypeID column" HeaderText="<%$ Resources:Resource, lblBasedOn %>"
                                            SortExpression="TypeID" UniqueName="BasedOn" GroupByExpression="BasedOn BasedOn GROUP BY BasedOn" DefaultInsertValue="0">
                    <EditItemTemplate>
                        <telerik:RadDropDownList ID="BasedOn" DataSourceID="SqlDataSource_BasedOn" DataTextField="NameVisible" runat="server" DataValueField="BpID" 
                                                 SelectedValue='<%# Bind("BasedOn") %>' Width="300px" Enabled="false" AppendDataBoundItems="true">
                            <Items>
                                <telerik:DropDownListItem Text="<%$ Resources:Resource, selNoTemplate %>" Value="0" />
                            </Items>
                        </telerik:RadDropDownList>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <telerik:RadDropDownList ID="BasedOn" DataSourceID="SqlDataSource_BasedOn" DataTextField="NameVisible" runat="server" DataValueField="BpID" 
                                                 SelectedValue='<%# Bind("BasedOn") %>' Width="300px" DefaultMessage="<%# Resources.Resource.msgPleaseSelect %>" AppendDataBoundItems="true">
                            <Items>
                                <telerik:DropDownListItem Text="<%$ Resources:Resource, selNoTemplate %>" Value="0" />
                            </Items>
                        </telerik:RadDropDownList>
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" Text='<%# Eval("NameBasedOn") %>'></asp:Label>
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="RadComboBoxBasedOn" DataSourceID="SqlDataSource_BasedOn" DataTextField="NameVisible"
                                             DataValueField="BpID" Height="200px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("BasedOn").CurrentFilterValue %>'
                                             runat="server" OnClientSelectedIndexChanged="BasedOnIndexChanged">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock2" runat="server">
                            <script type="text/javascript">
                                function BasedOnIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    tableView.filter("BasedOn", args.get_item().get_value(), "EqualTo");
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="CountryID" DataType="System.Int32" Visible="false" FilterControlAltText="Filter CountryID column" HeaderText="<%$ Resources:Resource, lblCountry %>" 
                                            SortExpression="CountryID" UniqueName="CountryID" ItemStyle-Wrap="false" ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="CountryID" Text='<%# Eval("CountryID") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:HiddenField ID="CountryID1" runat="server" Value='<%# Eval("CountryID") %>'></asp:HiddenField>
                        <telerik:RadComboBox runat="server" ID="CountryID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                             DataValueField="Name" DataTextField="DisplayName" Width="300" Filter="Contains"
                                             AppendDataBoundItems="true" DropDownAutoWidth="Enabled" >
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

                        <asp:RequiredFieldValidator runat="server" ControlToValidate="CountryID" Text="*" ForeColor="Red" 
                                                    ErrorMessage='<%# String.Concat(Resources.Resource.lblCountry, " ", Resources.Resource.lblRequired) %>'></asp:RequiredFieldValidator>
                    </EditItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="BuilderName" HeaderText="<%$ Resources:Resource, lblBuilderName %>" SortExpression="BuilderName" UniqueName="BuilderName"
                                            GroupByExpression="BuilderName BuilderName GROUP BY BuilderName" FilterControlWidth="80px">
                    <EditItemTemplate>
                        <telerik:RadTextBox runat="server" ID="BuilderName" Text='<%# Bind("BuilderName") %>' Width="300px"></telerik:RadTextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" ID="BuilderName" Text='<%# Eval("BuilderName") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Address" FilterControlAltText="Filter CreatedFrom column" HeaderText="<%$ Resources:Resource, lblAddress %>" SortExpression="Address" UniqueName="Address" Visible="False">
                    <EditItemTemplate>
                        <telerik:RadTextBox runat="server" ID="Address" Text='<%# Bind("Address") %>' Width="300px" Height="100px" TextMode="MultiLine"></telerik:RadTextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <telerik:RadTextBox runat="server" ReadOnly="true" Text='<%# Eval("Address") %>' Width="300px" Height="100px" TextMode="MultiLine"></telerik:RadTextBox>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="PresentType" DataType="System.Byte" FilterControlAltText="Filter PresentType column" HeaderText="<%$ Resources:Resource, lblPresentType %>" 
                                            SortExpression="PresentType" UniqueName="PresentType" Visible="false" ItemStyle-Wrap="false" DefaultInsertValue="3">
                    <EditItemTemplate>
                        <telerik:RadComboBox ID="RadDropDownList_PresentType" runat="server" SelectedValue='<%# Bind("PresentType") %>' Width="300px"
                                             EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" Filter="Contains" DropDownAutoWidth="Enabled">
                            <Items>
                                <telerik:RadComboBoxItem runat="server" Text="<%$ Resources:Resource, selPresence1 %>" Value="1" />
                                <telerik:RadComboBoxItem runat="server" Text="<%$ Resources:Resource, selPresence2 %>" Value="2" />
                                <telerik:RadComboBoxItem runat="server" Text="<%$ Resources:Resource, selPresence3 %>" Value="3" Selected="true" />
                            </Items>
                        </telerik:RadComboBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="RadDropDownList_PresentType" Text="*" ForeColor="Red" 
                                                    ErrorMessage='<%# String.Concat(Resources.Resource.lblPresentType, " ", Resources.Resource.lblRequired) %>'></asp:RequiredFieldValidator>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" ID="PresentType" Text='<%# GetResource("selPresence" + Eval("PresentType").ToString()) %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridCheckBoxColumn DataField="MWCheck" DataType="System.Boolean" FilterControlAltText="Filter MWCheck column" HeaderText="<%$ Resources:Resource, lblMWCheck %>" 
                                            SortExpression="MWCheck" UniqueName="MWCheck" Visible="False" DefaultInsertValue="False">
                </telerik:GridCheckBoxColumn>

                <telerik:GridCheckBoxColumn DataField="MinWageAccessRelevance" DataType="System.Boolean" FilterControlAltText="Filter MinWageAccessRelevance column" 
                                            HeaderText="<%$ Resources:Resource, lblMinWageAccessRelevance %>" SortExpression="MinWageAccessRelevance" UniqueName="MinWageAccessRelevance" Visible="False" 
                                            DefaultInsertValue="False">
                </telerik:GridCheckBoxColumn>

                <telerik:GridTemplateColumn HeaderStyle-Wrap="true" DataField="MWHours" FilterControlAltText="Filter MWHours column" HeaderText="<%$ Resources:Resource, lblMWHours %>" 
                                            SortExpression="MWHours" UniqueName="MWHours" Visible="False" DefaultInsertValue="0">
                    <EditItemTemplate>
                        <telerik:RadTextBox runat="server" ID="MWHours" InputType="Number" Text='<%# Bind("MWHours") %>'></telerik:RadTextBox>
                        <asp:Label ID="Label1" runat="server" Text="<%$ Resources:Resource, lblHourShort %>"></asp:Label>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="MWHours" Text="*" ErrorMessage="<%$ Resources:Resource, msgMWHours %>" ForeColor="Red"></asp:RequiredFieldValidator>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="MWHoursLabel" runat="server" Text='<%# Eval("MWHours") %>'></asp:Label>
                        <asp:Label ID="Label1" runat="server" Text="<%$ Resources:Resource, lblHourShort %>"></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn HeaderStyle-Wrap="true" DataField="MWDeadline" FilterControlAltText="Filter MWDeadline column" HeaderText="<%$ Resources:Resource, lblMWDeadline %>" 
                                            SortExpression="MWDeadline" UniqueName="MWDeadline" Visible="False" DefaultInsertValue="0">
                    <EditItemTemplate>
                        <telerik:RadTextBox runat="server" ID="MWDeadline" InputType="Number" Text='<%# Bind("MWDeadline") %>'></telerik:RadTextBox>
                        <asp:Label ID="Label2" runat="server" Text="<%$ Resources:Resource, lblSuffixOfMonth %>"></asp:Label>
                        <asp:RangeValidator runat="server" ControlToValidate="MWDeadline" MinimumValue="0" MaximumValue="31" Text="*" Type="Integer" 
                            ErrorMessage="<%$ Resources:Resource, msgMWDeadline %>" ForeColor="Red">
                        </asp:RangeValidator>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="MWDeadlineLabel" runat="server" Text='<%# Eval("MWDeadline") %>'></asp:Label>
                        <asp:Label ID="Label2" runat="server" Text="<%$ Resources:Resource, lblSuffixOfMonth %>"></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn HeaderStyle-Wrap="true" DataField="MWLackTrigger" FilterControlAltText="Filter MWLackTrigger column" HeaderText="<%$ Resources:Resource, lblMWLackTrigger %>" 
                                            SortExpression="MWLackTrigger" UniqueName="MWLackTrigger" Visible="False" DefaultInsertValue="0">
                    <EditItemTemplate>
                        <telerik:RadTextBox runat="server" ID="MWLackTrigger" InputType="Number" Text='<%# Bind("MWLackTrigger") %>' ToolTip="<%$ Resources:Resource, ttMWLackTrigger %>"></telerik:RadTextBox>
                        <asp:Label ID="Label10" runat="server" Text="<%$ Resources:Resource, lblSuffixDays %>" ToolTip="<%$ Resources:Resource, ttMWLackTrigger %>"></asp:Label>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="MWLackTrigger" Text="*" ErrorMessage="<%$ Resources:Resource, msgMWLackTrigger %>" ForeColor="Red"></asp:RequiredFieldValidator>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="MWLackTriggerLabel" runat="server" Text='<%# Eval("MWLackTrigger") %>' ToolTip="<%$ Resources:Resource, ttMWLackTrigger %>"></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn HeaderStyle-Wrap="true" DataField="AccessRightValidDays" FilterControlAltText="Filter AccessRightValidDays column" 
                                            HeaderText="<%$ Resources:Resource, lblAccessRightValidDays %>" 
                                            SortExpression="AccessRightValidDays" UniqueName="AccessRightValidDays" Visible="False" DefaultInsertValue="365">
                    <EditItemTemplate>
                        <telerik:RadTextBox runat="server" ID="AccessRightValidDays" InputType="Number" Text='<%# Bind("AccessRightValidDays") %>'></telerik:RadTextBox>
                        <asp:Label ID="Label22" runat="server" Text="<%$ Resources:Resource, lblSuffixDays %>"></asp:Label>
                        <asp:RangeValidator runat="server" ControlToValidate="AccessRightValidDays" MinimumValue="1" MaximumValue="1825" Text="*" Type="Integer" 
                                            ErrorMessage="<%$ Resources:Resource, msgAccessRightValidDays %>" ForeColor="Red">
                        </asp:RangeValidator>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="AccessRightValidDays" runat="server" Text='<%# Eval("AccessRightValidDays") %>'></asp:Label>
                        <asp:Label ID="Label22" runat="server" Text="<%$ Resources:Resource, lblSuffixDays %>"></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="DefaultRoleID" HeaderText="<%$ Resources:Resource, lblDefaultRole %>" InsertVisiblityMode="AlwaysHidden" Visible="false">
                    <EditItemTemplate>
                        <telerik:RadComboBox runat="server" ID="DefaultRoleID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                             DataValueField="RoleID" DataTextField="NameVisible" Width="300" 
                                             Filter="Contains" AppendDataBoundItems="true" DropDownAutoWidth="Enabled">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                            </Items>
                        </telerik:RadComboBox>
                    </EditItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="DefaultAccessAreaID" HeaderText="<%$ Resources:Resource, lblDefaultAccessArea %>" InsertVisiblityMode="AlwaysHidden" Visible="false">
                    <EditItemTemplate>
                        <telerik:RadComboBox runat="server" ID="DefaultAccessAreaID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                             DataValueField="AccessAreaID" DataTextField="NameVisible" Width="300" 
                                             Filter="Contains" AppendDataBoundItems="true" DropDownAutoWidth="Enabled">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                            </Items>
                        </telerik:RadComboBox>
                    </EditItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="DefaultTimeSlotGroupID" HeaderText="<%$ Resources:Resource, lblDefaultTimeSlotGroup %>" InsertVisiblityMode="AlwaysHidden" Visible="false">
                    <EditItemTemplate>
                        <telerik:RadComboBox runat="server" ID="DefaultTimeSlotGroupID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                             DataValueField="TimeSlotGroupID" DataTextField="NameVisible" Width="300" 
                                             Filter="Contains" AppendDataBoundItems="true" DropDownAutoWidth="Enabled">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                            </Items>
                        </telerik:RadComboBox>
                    </EditItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="DefaultSTAccessAreaID" HeaderText="<%$ Resources:Resource, lblDefaultSTAccessArea %>" InsertVisiblityMode="AlwaysHidden" Visible="false">
                    <EditItemTemplate>
                        <telerik:RadComboBox runat="server" ID="DefaultSTAccessAreaID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                             DataValueField="AccessAreaID" DataTextField="NameVisible" Width="300" 
                                             Filter="Contains" AppendDataBoundItems="true" DropDownAutoWidth="Enabled">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                            </Items>
                        </telerik:RadComboBox>
                    </EditItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="DefaultSTTimeSlotGroupID" HeaderText="<%$ Resources:Resource, lblDefaultSTTimeSlotGroup %>" InsertVisiblityMode="AlwaysHidden" Visible="false">
                    <EditItemTemplate>
                        <telerik:RadComboBox runat="server" ID="DefaultSTTimeSlotGroupID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                             DataValueField="TimeSlotGroupID" DataTextField="NameVisible" Width="300" 
                                             Filter="Contains" AppendDataBoundItems="true" DropDownAutoWidth="Enabled">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                            </Items>
                        </telerik:RadComboBox>
                    </EditItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridCheckBoxColumn DataField="PrintPassOnCompleteDocs" DataType="System.Boolean" FilterControlAltText="Filter PrintPassOnCompleteDocs column" 
                                            HeaderText="<%$ Resources:Resource, lblPrintPassOnCompleteDocs %>" SortExpression="PrintPassOnCompleteDocs" UniqueName="PrintPassOnCompleteDocs" Visible="False" 
                                            DefaultInsertValue="False">
                </telerik:GridCheckBoxColumn>

                <telerik:GridTemplateColumn DataField="DefaultTariffScope" HeaderText="<%$ Resources:Resource, lblTariffScope %>" InsertVisiblityMode="AlwaysVisible" Visible="false">
                    <EditItemTemplate>
                        <telerik:RadDropDownList runat="server" ID="DefaultTariffScope" SelectedValue='<%# Bind("DefaultTariffScope") %>'>
                            <Items>
                                <telerik:DropDownListItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0" Selected="true" />
                                <telerik:DropDownListItem Text="West" Value="1" />
                                <telerik:DropDownListItem Text="Ost" Value="2" />
                                <telerik:DropDownListItem Text="Berlin" Value="3" />    
                          </Items>
                        </telerik:RadDropDownList>
                        <telerik:RadButton ID="TariffScopeBtn" runat="server" CommandName="TariffScopeChanged" Visible="true" ToolTip='<%# Resources.Resource.lblActionRefresh %>'
                                           Icon-PrimaryIconCssClass="rbRSS" ButtonType="SkinnedButton" BorderStyle="None" BackColor="Transparent" Width="24px"  >
                        </telerik:RadButton>
                    </EditItemTemplate>

                </telerik:GridTemplateColumn>

                <telerik:GridCheckBoxColumn DataField="IsVisible" DataType="System.Boolean" FilterControlAltText="Filter IsVisible column" HeaderText="<%$ Resources:Resource, lblVisible %>" SortExpression="IsVisible" UniqueName="IsVisible" Visible="False" DefaultInsertValue="True">
                </telerik:GridCheckBoxColumn>

                <telerik:GridTemplateColumn DataField="CreatedFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedFrom column" HeaderText="<%$ Resources:Resource, lblCreatedFrom %>" SortExpression="CreatedFrom" UniqueName="CreatedFrom" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="CreatedFromLabel" runat="server" Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="CreatedOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedOn column" HeaderText="<%$ Resources:Resource, lblCreatedOn %>" SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="CreatedOnLabel" runat="server" Text='<%# Eval("CreatedOn") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="EditFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditFrom column" HeaderText="<%$ Resources:Resource, lblEditFrom %>" SortExpression="EditFrom" UniqueName="EditFrom" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="EditFromLabel" runat="server" Text='<%# Eval("EditFrom") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="EditOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditOn column" HeaderText="<%$ Resources:Resource, lblEditOn %>" SortExpression="EditOn" UniqueName="EditOn" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="EditOnLabel" runat="server" Text='<%# Eval("EditOn") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn HeaderText="<%$ Resources:Resource, lblHint %>" Visible="false" InsertVisiblityMode="AlwaysVisible">
                    <EditItemTemplate>
                        <asp:ValidationSummary ID="ValidationSummary2" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' ShowMessageBox="true" 
                                               ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true" />
                    </EditItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridButtonColumn UniqueName="deleteColumn" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteBp %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                          ConfirmDialogType="RadWindow" ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" 
                                          HeaderStyle-Width="30px" ItemStyle-Width="30px" >
                    <ItemStyle BackColor="Control" />
                </telerik:GridButtonColumn>
            </Columns>

            <SortExpressions>
                <telerik:GridSortExpression FieldName="TypeID" SortOrder="Ascending"></telerik:GridSortExpression>
                <telerik:GridSortExpression FieldName="NameVisible" SortOrder="Ascending"></telerik:GridSortExpression>
            </SortExpressions>

            <NestedViewTemplate>
                <asp:Panel ID="NestedViewPanel" runat="server">
                    <div>
                        <fieldset style="padding: 10px;">
                            <legend style="padding: 5px;">
                                <b><%= Resources.Resource.lblDetailsFor %> <%#Eval("NameVisible") %></b>
                            </legend>
                            <table>
                                <tr>
                                    <td><%= Resources.Resource.lblBpID %>: </td>
                                    <td>
                                        <asp:Label Text='<%#Eval("BpID") %>' runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblNameVisible %>: </td>
                                    <td>
                                        <asp:Label Text='<%#Eval("NameVisible") %>' runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblDescriptionShort %>: </td>
                                    <td>
                                        <asp:Label Text='<%#Eval("DescriptionShort") %>' runat="server" Width="300px"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblType %>: </td>
                                    <td>
                                        <telerik:RadDropDownList Enabled="false" ID="RadDropDownList1" runat="server" SelectedText="Bauprojekt" SelectedValue='<%# Eval("TypeID") %>'>
                                            <Items>
                                                <telerik:DropDownListItem runat="server" Selected="True" Text="<%$ Resources:Resource, lblBuildingProject %>" Value="1" />
                                                <telerik:DropDownListItem runat="server" Text="<%$ Resources:Resource, lblTemplate %>" Value="2" />
                                            </Items>
                                        </telerik:RadDropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <%= Resources.Resource.lblBasedOn %>:
                                    </td>
                                    <td>
                                        <asp:Label runat="server" Text='<%# Eval("NameBasedOn") %>'></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <%= Resources.Resource.lblCountry %>:
                                    </td>
                                    <td>
                                        <asp:Label runat="server" Text='<%# Eval("CountryName") %>'></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <%= Resources.Resource.lblBuilderName %>:
                                    </td>
                                    <td>
                                        <asp:Label Text='<%#Eval("BuilderName") %>' runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblAddress %>: </td>
                                    <td>
                                        <telerik:RadTextBox ReadOnly="true" runat="server" Text='<%# Eval("Address") %>' Width="300px" Height="100px" TextMode="MultiLine"></telerik:RadTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblPresentType %>: </td>
                                    <td>
                                        <asp:Label runat="server" ID="PresentType" Text='<%# GetResource("selPresence" + Eval("PresentType").ToString()) %>'></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblMWCheck %>: </td>
                                    <td>
                                        <asp:CheckBox Checked='<%#Eval("MWCheck") %>' runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblMinWageAccessRelevance %>: </td>
                                    <td>
                                        <asp:CheckBox Checked='<%#Eval("MinWageAccessRelevance") %>' runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblMWHours %>: </td>
                                    <td>
                                        <asp:Label ID="Label5" runat="server" Text='<%# Eval("MWHours") %>'></asp:Label>
                                        <asp:Label ID="Label6" runat="server" Text="<%$ Resources:Resource, lblHourShort %>"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblMWDeadline %>: </td>
                                    <td>
                                        <asp:Label ID="Label7" runat="server" Text='<%# Eval("MWDeadline") %>'></asp:Label>
                                        <asp:Label ID="Label8" runat="server" Text="<%$ Resources:Resource, lblSuffixOfMonth %>"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblMWLackTrigger %>: </td>
                                    <td>
                                        <asp:Label ID="Label9" runat="server" Text='<%# Eval("MWLackTrigger") %>' ToolTip="<%$ Resources:Resource, ttMWLackTrigger %>"></asp:Label>
                                        <asp:Label ID="Label10" runat="server" Text="<%$ Resources:Resource, lblSuffixDays %>" ToolTip="<%$ Resources:Resource, ttMWLackTrigger %>"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblAccessRightValidDays %>: </td>
                                    <td>
                                        <asp:Label ID="Label3" runat="server" Text='<%# Eval("AccessRightValidDays") %>'></asp:Label>
                                        <asp:Label ID="Label4" runat="server" Text="<%$ Resources:Resource, lblSuffixDays %>"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblDefaultRole %>: </td>
                                    <td>
                                        <asp:Label Text='<%#Eval("NameRole") %>' runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblDefaultAccessArea %>: </td>
                                    <td>
                                        <asp:Label Text='<%#Eval("NameAccessArea") %>' runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblDefaultTimeSlotGroup %>: </td>
                                    <td>
                                        <asp:Label Text='<%#Eval("NameTimeSlotGroup") %>' runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblPrintPassOnCompleteDocs %>: </td>
                                    <td>
                                        <asp:CheckBox Checked='<%#Eval("PrintPassOnCompleteDocs") %>' runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblVisible %>: </td>
                                    <td>
                                        <asp:CheckBox Checked='<%#Eval("IsVisible") %>' runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblCreatedFrom %>: </td>
                                    <td>
                                        <asp:Label Text='<%#Eval("CreatedFrom") %>' runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblCreatedOn %>: </td>
                                    <td>
                                        <asp:Label Text='<%#Eval("CreatedOn") %>' runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblEditFrom %>: </td>
                                    <td>
                                        <asp:Label Text='<%#Eval("EditFrom") %>' runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td><%= Resources.Resource.lblEditOn %>: </td>
                                    <td>
                                        <asp:Label Text='<%#Eval("EditOn") %>' runat="server"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                    </div>
                </asp:Panel>
            </NestedViewTemplate>
        </MasterTableView>
    </telerik:RadGrid>

    <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGrid1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                    <telerik:AjaxUpdatedControl ControlID="RadToolTipManager1" />
                    <telerik:AjaxUpdatedControl ControlID="ValidationSummary2" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <asp:SqlDataSource ID="SqlDataSource_BuidingProjects" runat="server" OnInserted="SqlDataSource_Inserted"
        ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
        InsertCommand="INSERT INTO [Master_BuildingProjects] ([SystemID], [NameVisible], [DescriptionShort], ContainerManagementName, [TypeID], [BasedOn], [IsVisible], [CountryID], [BuilderName], [PresentType], [MWCheck], [MWHours], [MWDeadline], MWLackTrigger, MinWageAccessRelevance, [Address], [CreatedFrom], [CreatedOn], [EditFrom], [EditOn], DefaultRoleID, DefaultAccessAreaID, DefaultTimeSlotGroupID, DefaultSTAccessAreaID, DefaultSTTimeSlotGroupID, PrintPassOnCompleteDocs, DefaultTariffScope, AccessRightValidDays) VALUES (@SystemID, @NameVisible, @DescriptionShort, @ContainerManagementName, @TypeID, @BasedOn, @IsVisible, @CountryID, @BuilderName, @PresentType, @MWCheck, @MWHours, @MWDeadline, @MWLackTrigger, @MinWageAccessRelevance, @Address, @UserName, SYSDATETIME(), @UserName, SYSDATETIME(), 0, 0, 0, 0, 0, @PrintPassOnCompleteDocs, @DefaultTariffScope, @AccessRightValidDays);
                       SET @BpID = SCOPE_IDENTITY();
                       SET @ReturnValue = @BpID;
                       EXEC dbo.CopyBuildingProject @SystemID, @BasedOn, @ReturnValue, @UserID, @UserName"
        OldValuesParameterFormatString="original_{0}"
        SelectCommand="SELECT m_bp.SystemID, m_bp.BpID, m_bp.NameVisible, m_bp.DescriptionShort, m_bp.ContainerManagementName, m_bp.TypeID, m_bp.BasedOn, m_bp.IsVisible, m_bp.CountryID, m_bp.BuilderName, m_bp.PresentType, m_bp.MWCheck, m_bp.MWHours, m_bp.MWDeadline, m_bp.Address, m_bp.CreatedFrom, m_bp.CreatedOn, m_bp.EditFrom, m_bp.EditOn, m_bp.MinWageAccessRelevance, m_bp.DefaultRoleID, m_r.NameVisible AS NameRole, m_bp.DefaultAccessAreaID, m_bp.DefaultTimeSlotGroupID, m_bp.PrintPassOnCompleteDocs, m_aa.NameVisible AS NameAccessArea, m_tsg.NameVisible AS NameTimeSlotGroup, m_bp_based_on.NameVisible AS NameBasedOn, View_Countries.CountryName, m_bp.DefaultTariffScope, m_bp.AccessRightValidDays, m_bp.DefaultSTAccessAreaID, m_bp.DefaultSTTimeSlotGroupID, m_bp.MWLackTrigger FROM Master_BuildingProjects AS m_bp INNER JOIN Master_UserBuildingProjects AS m_ubp ON m_bp.SystemID = m_ubp.SystemID AND m_bp.BpID = m_ubp.BpID LEFT OUTER JOIN View_Countries ON m_bp.CountryID = View_Countries.CountryID LEFT OUTER JOIN Master_BuildingProjects AS m_bp_based_on ON m_bp.SystemID = m_bp_based_on.SystemID AND m_bp.BasedOn = m_bp_based_on.BpID LEFT OUTER JOIN Master_TimeSlotGroups AS m_tsg ON m_bp.SystemID = m_tsg.SystemID AND m_bp.BpID = m_tsg.BpID AND m_bp.DefaultTimeSlotGroupID = m_tsg.TimeSlotGroupID LEFT OUTER JOIN Master_AccessAreas AS m_aa ON m_bp.SystemID = m_aa.SystemID AND m_bp.BpID = m_aa.BpID AND m_bp.DefaultAccessAreaID = m_aa.AccessAreaID LEFT OUTER JOIN Master_Roles AS m_r ON m_bp.SystemID = m_r.SystemID AND m_bp.BpID = m_r.BpID AND m_bp.DefaultRoleID = m_r.RoleID WHERE (m_bp.SystemID = @SystemID) AND (m_ubp.UserID = @UserID) ORDER BY m_bp.TypeID, m_bp.NameVisible"
        UpdateCommand="INSERT INTO History_BuildingProjects SELECT * FROM Master_BuildingProjects WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID; 
                       UPDATE Master_BuildingProjects SET NameVisible = @NameVisible, DescriptionShort = @DescriptionShort, ContainerManagementName = @ContainerManagementName, BasedOn = @BasedOn, IsVisible = @IsVisible, CountryID = @CountryID, BuilderName = @BuilderName, PresentType = @PresentType, MWCheck = @MWCheck, MWHours = @MWHours, MWDeadline = @MWDeadline, MWLackTrigger = @MWLackTrigger, MinWageAccessRelevance = @MinWageAccessRelevance, Address = @Address, EditFrom = @UserName, EditOn = SYSDATETIME(), DefaultRoleID = @DefaultRoleID, DefaultAccessAreaID = @DefaultAccessAreaID, DefaultTimeSlotGroupID = @DefaultTimeSlotGroupID, DefaultSTAccessAreaID = @DefaultSTAccessAreaID, DefaultSTTimeSlotGroupID = @DefaultSTTimeSlotGroupID, PrintPassOnCompleteDocs = @PrintPassOnCompleteDocs, DefaultTariffScope = @DefaultTariffScope, AccessRightValidDays = @AccessRightValidDays WHERE (SystemID = @original_SystemID) AND (BpID = @original_BpID)">
        <InsertParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:Parameter Name="NameVisible" Type="String" />
            <asp:Parameter Name="DescriptionShort" Type="String" />
            <asp:Parameter Name="ContainerManagementName" />
            <asp:Parameter Name="TypeID" Type="Byte" />
            <asp:Parameter Name="BasedOn" Type="Int32" />
            <asp:Parameter Name="IsVisible" Type="Boolean" />
            <asp:Parameter Name="CountryID" Type="String" />
            <asp:Parameter Name="BuilderName" Type="String" />
            <asp:Parameter Name="PresentType" Type="Byte" DefaultValue="3" />
            <asp:Parameter Name="MWCheck" Type="Boolean" />
            <asp:Parameter Name="MWHours" Type="Int32" />
            <asp:Parameter Name="MWDeadline" Type="Int32" />
            <asp:Parameter Name="MWLackTrigger" />
            <asp:Parameter Name="MinWageAccessRelevance" Type="Boolean"></asp:Parameter>
            <asp:Parameter Name="Address" Type="String"></asp:Parameter>
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
            <asp:Parameter Name="PrintPassOnCompleteDocs"></asp:Parameter>
            <asp:Parameter Name="DefaultTariffScope"></asp:Parameter>
            <asp:Parameter Name="AccessRightValidDays" Type="Int32"></asp:Parameter>
            <asp:Parameter Name="BpID" Type="Int32" Direction="InputOutput" DefaultValue="0"></asp:Parameter>
            <asp:Parameter Name="ReturnValue" Type="Int32" Direction="InputOutput" DefaultValue="0"></asp:Parameter>
            <asp:SessionParameter SessionField="UserID" DefaultValue="0" Name="UserID"></asp:SessionParameter>
        </InsertParameters>
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter SessionField="UserID" DefaultValue="0" Name="UserID"></asp:SessionParameter>
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="original_SystemID" Type="Int32" />
            <asp:Parameter Name="original_BpID" Type="Int32" />
            <asp:Parameter Name="NameVisible" Type="String" />
            <asp:Parameter Name="DescriptionShort" Type="String" />
            <asp:Parameter Name="ContainerManagementName" />
            <asp:Parameter Name="BasedOn" Type="Int32" />
            <asp:Parameter Name="IsVisible" Type="Boolean" />
            <asp:Parameter Name="CountryID" Type="String" />
            <asp:Parameter Name="BuilderName" Type="String" />
            <asp:Parameter Name="PresentType" Type="Byte" />
            <asp:Parameter Name="MWCheck" Type="Boolean" />
            <asp:Parameter Name="MWHours" Type="Int32" />
            <asp:Parameter Name="MWDeadline" Type="Int32" />
            <asp:Parameter Name="MWLackTrigger" />
            <asp:Parameter Name="MinWageAccessRelevance" Type="Boolean"></asp:Parameter>
            <asp:Parameter Name="Address" Type="String"></asp:Parameter>
            <asp:SessionParameter SessionField="LoginName" DefaultValue="" Name="UserName" Type="String"></asp:SessionParameter>
            <asp:Parameter Name="DefaultRoleID" Type="Int32"></asp:Parameter>
            <asp:Parameter Name="DefaultAccessAreaID"></asp:Parameter>
            <asp:Parameter Name="DefaultTimeSlotGroupID"></asp:Parameter>
            <asp:Parameter Name="DefaultSTAccessAreaID"></asp:Parameter>
            <asp:Parameter Name="DefaultSTTimeSlotGroupID"></asp:Parameter>
            <asp:Parameter Name="PrintPassOnCompleteDocs"></asp:Parameter>
            <asp:Parameter Name="DefaultTariffScope"></asp:Parameter>
            <asp:Parameter Name="AccessRightValidDays" Type="Int32"></asp:Parameter>
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_BasedOn" runat="server"
                       ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT * FROM [Master_BuildingProjects] WHERE SystemID = @SystemID">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_BPDetails" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT * FROM [Master_BuildingProjects] WHERE SystemID = @SystemID AND BpID = @BpID">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:Parameter Name="BpID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
