<%@ Page Title="<%$ Resources:Resource, lblMinWageReportEmployee %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MinWageReportEmployee.aspx.cs" Inherits="InSite.App.Views.Reports.MinWageReportEmployee" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">

    <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGrid1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadGridTariffHistory">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridTariffHistory" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="MonthFrom">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="MonthUntil">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <div style="background-color: InactiveBorder;">
        <table cellpadding="3px" style="padding-left: 5px;">
            <tr>
                <td>
                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblTimeInterval %>" Font-Bold="true"></asp:Label>
                </td>
                <td>
                    <table style="padding-left: -3px;">
                        <tr>
                            <td style="vertical-align: top;">
                                <asp:Label runat="server" Text="<%$ Resources:Resource, lblFrom %>" Font-Bold="true"></asp:Label>
                                <br />
                                <telerik:RadMonthYearPicker ID="MonthFrom" runat="server" OnSelectedDateChanged="MonthFrom_SelectedDateChanged" AutoPostBack="true" ShowPopupOnFocus="true">
                                </telerik:RadMonthYearPicker>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="MonthFrom" ErrorMessage="<%$ Resources:Resource, msgDateFromRequired %>" Text="*" 
                                                            SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                </asp:RequiredFieldValidator>
                            </td>
                            <td style="vertical-align: top;">
                                <asp:Label runat="server" Text="<%$ Resources:Resource, lblTo %>" Font-Bold="true"></asp:Label>
                                <br />
                                <telerik:RadMonthYearPicker ID="MonthUntil" runat="server" OnSelectedDateChanged="MonthUntil_SelectedDateChanged" AutoPostBack="true" ShowPopupOnFocus="true">
                                </telerik:RadMonthYearPicker>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="MonthUntil" ErrorMessage="<%$ Resources:Resource, msgDateUntilRequired %>" Text="*" 
                                                            SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                </asp:RequiredFieldValidator>
                                <asp:CompareValidator runat="server" ControlToValidate="MonthUntil" ControlToCompare="MonthFrom" ValueToCompare="SelectedDate" Operator="GreaterThanEqual"
                                                      Text="*" SetFocusOnError="true" ForeColor="Red" ErrorMessage="<%$ Resources:Resource, msgDateFromLargerDateUntil %>" ValidationGroup="Submit">
                                </asp:CompareValidator>
                            </td>
                        </tr>
                    </table>
                </td>
                <td rowspan="6" style="vertical-align: top; padding: 5px;">
                    <telerik:RadAjaxPanel runat="server" ID="PanelCompanyInfo" Visible="false">
                        <fieldset style="padding: 5px;">
                            <legend style="padding: 5px; background-color: transparent;">
                                <asp:Label runat="server" Text="<%$ Resources:Resource, lblCompanyInfo %>" Font-Bold="true"></asp:Label>
                            </legend>
                            <table>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" Text="<%$ Resources:Resource, lblCompany %>" ForeColor="Gray"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="CompanyName" runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" Text="<%$ Resources:Resource, lblAddress %>" ForeColor="Gray"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Address" runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" Text="<%$ Resources:Resource, lblAddrZip %>" ForeColor="Gray"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Zip" runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" Text="<%$ Resources:Resource, lblAddrCity %>" ForeColor="Gray"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="City" runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" Text="<%$ Resources:Resource, lblClientID %>" ForeColor="Gray"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="ClientID" runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" Text="<%$ Resources:Resource, lblClient %>" ForeColor="Gray"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Client" runat="server"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                    </telerik:RadAjaxPanel>
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top;">
                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblCompany %>" Font-Bold="true"></asp:Label>
                </td>
                <td style="vertical-align: top;">
                    <telerik:RadDropDownTree runat="server" ID="CompanyID" DataFieldParentID="ParentID" DataFieldID="CompanyID" DataValueField="CompanyID" EnableFiltering="true" 
                                             DataTextField="CompanyName" Width="300px" DefaultMessage="<%$ Resources:Resource, msgPleaseSelect %>"
                                             DropDownSettings-AutoWidth="Enabled" DataSourceID="SqlDataSource_Companies" AutoPostBack="true" CheckBoxes="None" 
                                             OnEntryRemoved="CompanyID_EntryRemoved" OnEntryAdded="CompanyID_EntryAdded" OnClientKeyPressing="OnClientKeyPressing">
                        <ButtonSettings ShowClear="true" />
                        <FilterSettings Highlight="Matches" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" Filter="Contains" />
                        <DropDownSettings OpenDropDownOnLoad="false" CloseDropDownOnSelection="true" />
                    </telerik:RadDropDownTree>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label runat="server" ID="LabelShowCorrectMonths" Text='<%$ Resources:Resource, lblShowCorrectMonths %>'></asp:Label>
                </td>
                <td>
                    <asp:CheckBox runat="server" ID="ShowCorrectMonths" Checked="true" OnCheckedChanged="ShowCorrectMonths_CheckedChanged" AutoPostBack="true" />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label runat="server" ID="LabelShowTariffHistory" Text='<%$ Resources:Resource, lblShowTariffHistory %>'></asp:Label>
                </td>
                <td>
                    <asp:CheckBox runat="server" ID="ShowTariffHistory" Checked="false" OnCheckedChanged="ShowTariffHistory_CheckedChanged" AutoPostBack="true" />
                </td>
            </tr>
            <tr>
                <td nowrap="nowrap">
                    <asp:Label runat="server" ID="LabelTemplate" Text='<%$ Resources:Resource, lblTemplate %>'></asp:Label>
                </td>
                <td>
                    <telerik:RadComboBox runat="server" ID="TemplateID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                         Width="300" OnClientKeyPressing="OnClientKeyPressing"
                                         AppendDataBoundItems="true" Filter="Contains" DropDownAutoWidth="Enabled">
                        <Items>
                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblDefault %>" Value="0" Selected="true" />
                        </Items>
                    </telerik:RadComboBox>
                </td>
            </tr>
            <tr>
                <td nowrap="nowrap">
                    <asp:Label runat="server" ID="LabelRemark" Text='<%$ Resources:Resource, lblRemarks %>'></asp:Label>
                </td>
                <td>
                    <telerik:RadTextBox runat="server" ID="Remarks" Width="300px"></telerik:RadTextBox>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:ValidationSummary runat="server" DisplayMode="BulletList" ShowMessageBox="true" ShowSummary="true" BorderStyle="None"  
                                            ValidationGroup="Submit" />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <telerik:RadButton ID="btnExportExcel" runat="server" Text="<%$ Resources:Resource, lblExportToExcel %>" ToolTip="<%$ Resources:Resource, lblExportToExcel %>" 
                                       OnClick="BtnOK_Click" ButtonType="StandardButton" CommandArgument="Excel" ValidationGroup="Submit">
                        <Icon PrimaryIconUrl="/InSiteApp/Resources/Icons/export_xlsx_16.png" />
                    </telerik:RadButton>
                    <telerik:RadButton ID="btnExportPdf" runat="server" Text="<%$ Resources:Resource, lblExportToPdf %>" ToolTip="<%$ Resources:Resource, lblExportToPdf %>" 
                                       OnClick="BtnOK_Click" ButtonType="StandardButton" CommandArgument="Pdf" ValidationGroup="Submit">
                        <Icon PrimaryIconUrl="/InSiteApp/Resources/Icons/export_pdf_16.png" />
                    </telerik:RadButton>
                    <telerik:RadButton ID="BtnMWReportCompany" runat="server" Text="<%$ Resources:Resource, lblMinWageReportCompany %>" ToolTip="<%$ Resources:Resource, lblMinWageReportCompany %>" 
                                       OnClick="BtnMWReportCompany_Click" ButtonType="StandardButton" Visible="false">
                        <Icon PrimaryIconUrl="/InSiteApp/Resources/Icons/minwage_16.png" />
                    </telerik:RadButton>
                </td>
            </tr>
        </table>
    </div>

    <asp:Panel runat="server" ID="PanelTariffHistory" Visible="false" >
        <div style="padding-top: 5px;"></div>

        <telerik:RadGrid runat="server" ID="RadGridTariffHistory" AutoGenerateColumns="False" GroupPanelPosition="Top" CssClass="RadGrid" PageSize="10" AllowPaging="true"
                         DataSourceID="SqlDataSource_CompanyTariffs">

        <SortingSettings SortedBackColor="Transparent" />

            <MasterTableView CssClass="MasterClass" AllowMultiColumnSorting="true" NoMasterRecordsText="<%$ Resources:Resource, msgNoDataFound %>"
                             AllowSorting="true" AllowPaging="true" ShowHeader="true" Caption="<%$ Resources:Resource, lblTariffContractHistory %>"
                             DataSourceID="SqlDataSource_CompanyTariffs">

                <PagerStyle PageSizes="10,20,50" AlwaysVisible="true" />

                <SortExpressions>
                    <telerik:GridSortExpression FieldName="ValidFrom" SortOrder="Descending"></telerik:GridSortExpression>
                </SortExpressions>

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

                    <telerik:GridTemplateColumn DataField="NameVisibleTariff" HeaderText="<%$ Resources:Resource, lblTariff %>" SortExpression="NameVisibleTariff"
                                                UniqueName="NameVisibleTariff" GroupByExpression="NameVisibleTariff NameVisibleTariff GROUP BY NameVisibleTariff" 
                                                FilterControlWidth="80px">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="NameVisibleTariff" Text='<%# Eval("NameVisibleTariff") %>'></asp:Label>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn DataField="NameVisibleContract" HeaderText="<%$ Resources:Resource, lblTariffContract %>" SortExpression="NameVisibleContract"
                                                UniqueName="NameVisibleContract" GroupByExpression="NameVisibleContract NameVisibleContract GROUP BY NameVisibleContract" 
                                                FilterControlWidth="80px">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="NameVisibleContract" Text='<%# Eval("NameVisibleContract") %>'></asp:Label>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn DataField="NameVisible" HeaderText="<%$ Resources:Resource, lblTariffScope %>" SortExpression="NameVisible" UniqueName="NameVisible1"
                                                GroupByExpression="NameVisible NameVisible GROUP BY NameVisible" 
                                                FilterControlWidth="80px">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="NameVisible1" Text='<%# Eval("NameVisible") %>'></asp:Label>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn DataField="ValidFrom" DataType="System.DateTime" FilterControlAltText="Filter ValidFrom column" HeaderText="<%$ Resources:Resource, lblValidFrom %>"
                                                SortExpression="ValidFrom" UniqueName="ValidFrom" GroupByExpression="ValidFrom ValidFrom GROUP BY ValidFrom" 
                                                FilterControlWidth="80px">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="LabelValidFrom" Text='<%# Eval("ValidFrom", "{0:d}") %>'></asp:Label>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn DataField="CreatedOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedOn column"
                                                HeaderText="<%$ Resources:Resource, lblCreatedOn %>" SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="true" 
                                                FilterControlWidth="80px">
                        <ItemTemplate>
                            <asp:Label ID="CreatedOnLabel" runat="server" Text='<%# Eval("CreatedOn")%>'></asp:Label>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn DataField="WageGroupName" HeaderText="<%$ Resources:Resource, lblTariffWageGroup %>" SortExpression="WageGroupName" UniqueName="WageGroupName"
                                                GroupByExpression="WageGroupName WageGroupName GROUP BY WageGroupName" 
                                                FilterControlWidth="80px">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="WageGroupName" Text='<%# Eval("WageGroupName") %>'></asp:Label>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                </Columns>

            </MasterTableView>
        </telerik:RadGrid>
    </asp:Panel>

    <telerik:RadGrid ID="RadGrid1" runat="server" AutoGenerateColumns="False" GroupPanelPosition="Top" CssClass="MainGrid" PageSize="20" AllowPaging="true"
                     OnNeedDataSource="RadGrid1_NeedDataSource" OnItemCreated="RadGrid1_ItemCreated" Width="100%" ShowStatusBar="true" ShowHeader="true">

        <SortingSettings SortedBackColor="Transparent" />

        <MasterTableView CssClass="MasterClass" AllowMultiColumnSorting="true" NoMasterRecordsText="<%$ Resources:Resource, msgNoDataFound %>"
                         AllowSorting="true" AllowFilteringByColumn="true" AllowPaging="true" Width="100%" Caption="<%$ Resources:Resource, lblMWAttestations %>">

            <PagerStyle PageSizes="10,20,50,100" AlwaysVisible="true" />

            <SortExpressions>
                <telerik:GridSortExpression FieldName="LastName" SortOrder="Ascending"></telerik:GridSortExpression>
                <telerik:GridSortExpression FieldName="FirstName" SortOrder="Ascending"></telerik:GridSortExpression>
                <telerik:GridSortExpression FieldName="MWMonth" SortOrder="Descending"></telerik:GridSortExpression>
            </SortExpressions>

            <Columns>

                <telerik:GridTemplateColumn DataField="EmployeeID" Visible="false" InsertVisiblityMode="AlwaysHidden" DataType="System.Int32"
                                            FilterControlAltText="Filter EmployeeID column" HeaderText="<%$ Resources:Resource, lblID %>"
                                            SortExpression="EmployeeID" UniqueName="EmployeeID" 
                                            GroupByExpression="EmployeeID EmployeeID GROUP BY EmployeeID">
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

                <telerik:GridDateTimeColumn FilterControlWidth="100px" DataField="BirthDate" HeaderText="<%$ Resources:Resource, lblAddrBirthDate %>" SortExpression="BirthDate"
                                            UniqueName="BirthDate" PickerType="DatePicker" EnableRangeFiltering="true" HeaderStyle-Width="170px" ItemStyle-Width="170px" CurrentFilterFunction="Between" 
                                            AutoPostBackOnFilter="true" DataFormatString="{0:d}" ReadOnly="true" EnableTimeIndependentFiltering="true">
                </telerik:GridDateTimeColumn>

                <telerik:GridTemplateColumn DataField="StaffFunction" HeaderText="<%$ Resources:Resource, lblFunction %>" SortExpression="StaffFunction" UniqueName="StaffFunction"
                                            GroupByExpression="StaffFunction StaffFunction GROUP BY StaffFunction" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px"
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="StaffFunction" Text='<%# Eval("StaffFunction") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridDateTimeColumn FilterControlWidth="100px" DataField="MWMonth" HeaderText="<%$ Resources:Resource, lblMonth %>" SortExpression="MWMonth"
                                            UniqueName="MWMonth" PickerType="DatePicker" EnableRangeFiltering="true" HeaderStyle-Width="170px" ItemStyle-Width="170px" CurrentFilterFunction="Between" 
                                            AutoPostBackOnFilter="true" DataFormatString="{0:MMM yyyy}" ReadOnly="true" EnableTimeIndependentFiltering="true">
                </telerik:GridDateTimeColumn>

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

                <telerik:GridTemplateColumn DataField="WageName" HeaderText="<%$ Resources:Resource, lblTariffWageGroup %>" SortExpression="WageName" UniqueName="WageName"
                                            GroupByExpression="WageName WageName GROUP BY WageName" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px"
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="WageName" Text='<%# Eval("WageName") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Wage" HeaderText="<%$ Resources:Resource, lblTariffWage %>" SortExpression="Wage" UniqueName="Wage" 
                                            GroupByExpression="Wage Wage GROUP BY Wage" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right"
                                            HeaderStyle-Width="120px" ItemStyle-Width="120px">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Wage" Text='<%# Eval("Wage", "{0:#,##0.00}") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Amount" HeaderText="<%$ Resources:Resource, lblAmount %>" SortExpression="Amount" UniqueName="Amount" 
                                            GroupByExpression="Amount Amount GROUP BY Amount" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Right"
                                            HeaderStyle-Width="120px" ItemStyle-Width="120px">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Amount" Text='<%# Eval("Amount", "{0:#,##0.00}") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridDateTimeColumn FilterControlWidth="100px" DataField="ReceivedOn" HeaderText="<%$ Resources:Resource, lblReceivedOn %>" SortExpression="ReceivedOn"
                                            UniqueName="ReceivedOn" PickerType="DatePicker" EnableRangeFiltering="true" HeaderStyle-Width="170px" ItemStyle-Width="170px" CurrentFilterFunction="Between" 
                                            AutoPostBackOnFilter="true" DataFormatString="{0:g}" ReadOnly="true" EnableTimeIndependentFiltering="true">
                </telerik:GridDateTimeColumn>

                <telerik:GridTemplateColumn DataField="ReceivedFrom" HeaderText="<%$ Resources:Resource, lblReceivedFrom %>" SortExpression="ReceivedFrom" UniqueName="ReceivedFrom"
                                            GroupByExpression="ReceivedFrom ReceivedFrom GROUP BY ReceivedFrom" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px"
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="ReceivedFrom" Text='<%# Eval("ReceivedFrom") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridDateTimeColumn FilterControlWidth="100px" DataField="RequestedOn" HeaderText="<%$ Resources:Resource, lblRequestOn %>" SortExpression="RequestedOn"
                                            UniqueName="RequestedOn" PickerType="DatePicker" EnableRangeFiltering="true" HeaderStyle-Width="170px" ItemStyle-Width="170px" CurrentFilterFunction="Between" 
                                            AutoPostBackOnFilter="true" DataFormatString="{0:g}" ReadOnly="true" EnableTimeIndependentFiltering="true">
                </telerik:GridDateTimeColumn>

                <telerik:GridTemplateColumn DataField="RequestedFrom" HeaderText="<%$ Resources:Resource, lblRequestFrom %>" SortExpression="RequestedFrom" UniqueName="RequestedFrom"
                                            GroupByExpression="RequestedFrom RequestedFrom GROUP BY RequestedFrom" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px"
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="RequestedFrom" Text='<%# Eval("RequestedFrom") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="RequestListID" Visible="true" InsertVisiblityMode="AlwaysHidden" DataType="System.Int32"
                                            FilterControlAltText="Filter RequestListID column" HeaderText="<%$ Resources:Resource, lblID %>"
                                            SortExpression="RequestListID" UniqueName="RequestListID" FilterControlWidth="80px" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true"
                                            GroupByExpression="RequestListID RequestListID GROUP BY RequestListID">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="RequestListID" Text='<%# Eval("RequestListID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
            </Columns>

        </MasterTableView>
    </telerik:RadGrid>

    <asp:SqlDataSource runat="server" ID="SqlDataSource_CompanyTariffs" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                       SelectCommand="SELECT m_ct.SystemID, m_ct.BpID, m_ct.TariffScopeID, m_ct.CompanyID, m_ct.ValidFrom, m_ct.CreatedFrom, m_ct.CreatedOn, m_ct.EditFrom, m_ct.EditOn, s_ts.NameVisible, s_ts.DescriptionShort, s_tc.NameVisible AS NameVisibleContract, s_t.NameVisible AS NameVisibleTariff, s_twg.NameVisible AS WageGroupName FROM Master_CompanyTariffs AS m_ct INNER JOIN System_TariffScopes AS s_ts ON m_ct.SystemID = s_ts.SystemID AND m_ct.TariffScopeID = s_ts.TariffScopeID INNER JOIN System_TariffContracts AS s_tc ON s_ts.SystemID = s_tc.SystemID AND s_ts.TariffID = s_tc.TariffID AND s_ts.TariffContractID = s_tc.TariffContractID INNER JOIN System_Tariffs AS s_t ON s_tc.SystemID = s_t.SystemID AND s_tc.TariffID = s_t.TariffID INNER JOIN System_TariffWageGroups AS s_twg ON s_ts.SystemID = s_twg.SystemID AND s_ts.TariffID = s_twg.TariffID AND s_ts.TariffContractID = s_twg.TariffContractID AND s_ts.TariffScopeID = s_twg.TariffScopeID WHERE (m_ct.SystemID = @SystemID) AND (m_ct.BpID = @BpID) AND (m_ct.CompanyID = @CompanyID) ORDER BY m_ct.ValidFrom DESC">
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
            <asp:Parameter DefaultValue="0" Name="CompanyID" Type="Int32"></asp:Parameter>

        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Companies" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
        SelectCommand="SELECT c.SystemID, c.BpID, c.CompanyID, (CASE WHEN @CompanyID > 0 THEN NULL ELSE (CASE WHEN c.ParentID = 0 THEN NULL ELSE c.ParentID END) END) AS ParentID, s_c.NameVisible, s_c.NameAdditional, c.Description, c.AddressID, c.IsVisible, c.IsValid, c.TradeAssociation, c.BlnSOKA, c.CreatedFrom, c.CreatedOn, c.EditFrom, c.EditOn, a.Address1, a.Address2, a.Zip, a.City, a.State, a.CountryID, a.Phone, a.Email, a.WWW, s_c.NameVisible + (CASE WHEN s_c.NameAdditional IS NULL THEN '' ELSE ', ' + s_c.NameAdditional END) + (CASE WHEN a.City IS NULL THEN '' ELSE ', ' + a.City END) AS CompanyName FROM Master_Companies AS c INNER JOIN System_Companies AS s_c ON c.SystemID = s_c.SystemID AND c.CompanyCentralID = s_c.CompanyID LEFT OUTER JOIN System_Addresses AS a ON c.SystemID = a.SystemID AND c.AddressID = a.AddressID WHERE (c.SystemID = @SystemID) AND (c.BpID = @BpID) AND (c.ReleaseOn IS NOT NULL) AND (c.CompanyCentralID = (CASE WHEN @CompanyID = 0 THEN c.CompanyCentralID ELSE @CompanyID END)) AND (dbo.HasLockedMainContractor(c.SystemID, c.BpID, c.CompanyID) = 0) ORDER BY s_c.NameVisible">
        <SelectParameters>
            <asp:SessionParameter SessionField="CompanyID" DefaultValue="0" Name="CompanyID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
