<%@ Page Title="<%$ Resources:Resource, lblMWAttestationRequest %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MinWageAttestationRequest.aspx.cs" Inherits="InSite.App.Views.Reports.MinWageAttestationRequest" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
        <script type="text/javascript">
            function gridCommand(sender, args) {
                if (args.get_commandName() == "GetFile") {
                    var manager = $find('<%= RadAjaxManager.GetCurrent(Page).ClientID %>');
                    manager.set_enableAJAX(false);

                    setTimeout(function () {
                        manager.set_enableAJAX(true);
                    }, 0);
                }
            }
        </script>
    </telerik:RadCodeBlock>

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
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <div style="background-color: InactiveBorder;">
        <table cellpadding="3px" style="padding-left: 5px;">
            <tr>
                <td>
                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblTo %>" Font-Bold="true"></asp:Label>
                </td>
                <td>
                    <telerik:RadMonthYearPicker ID="MonthUntil" runat="server" ShowPopupOnFocus="true">
                    </telerik:RadMonthYearPicker>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="MonthUntil" ErrorMessage="<%$ Resources:Resource, msgDateUntilRequired %>" Text="*" 
                                                SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                    </asp:RequiredFieldValidator>
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
                    <telerik:RadComboBox runat="server" ID="CompanyID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                         DataSourceID="SqlDataSource_Companies" DataValueField="CompanyID" DataTextField="CompanyName" Width="700" 
                                         AppendDataBoundItems="true" Filter="Contains" DropDownAutoWidth="Enabled" OnClientKeyPressing="OnClientKeyPressing"
                                         OnSelectedIndexChanged="CompanyID_SelectedIndexChanged" AutoPostBack="true" CausesValidation="false">
                    </telerik:RadComboBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="CompanyID" ErrorMessage="<%$ Resources:Resource, msgCompanyRequired %>" Text="*" 
                                                SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                    </asp:RequiredFieldValidator>
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
                    <telerik:RadButton ID="BtnExportPdf" runat="server" Text="<%$ Resources:Resource, lblCreateRequest %>" ToolTip="<%$ Resources:Resource, lblCreateRequest %>" 
                                       OnClick="BtnOK_Click" ButtonType="StandardButton" CommandArgument="Pdf" ValidationGroup="Submit">
                        <Icon PrimaryIconUrl="/InSiteApp/Resources/Icons/export_pdf_16.png" />
                    </telerik:RadButton>
                </td>
            </tr>
        </table>
    </div>

    <telerik:RadGrid ID="RadGrid1" runat="server" AutoGenerateColumns="False" GroupPanelPosition="Top" CssClass="MainGrid" PageSize="20" AllowPaging="true"
                     Width="100%" ShowStatusBar="false" ShowHeader="true"
                     OnNeedDataSource="RadGrid1_NeedDataSource" OnItemCreated="RadGrid1_ItemCreated" OnItemCommand="RadGrid1_ItemCommand">

        <SortingSettings SortedBackColor="Transparent" />

        <MasterTableView CssClass="MasterClass" AllowMultiColumnSorting="true" NoMasterRecordsText="<%$ Resources:Resource, msgNoDataFound %>" CommandItemDisplay="Top"
                         AllowSorting="true" AllowFilteringByColumn="true" AllowPaging="true" Width="100%" Caption="<%$ Resources:Resource, lblMWAttestationRequests %>">

            <PagerStyle PageSizes="10,20,50,100" AlwaysVisible="true" />

            <SortExpressions>
                <telerik:GridSortExpression FieldName="NameVisible" SortOrder="Ascending"></telerik:GridSortExpression>
                <telerik:GridSortExpression FieldName="MWMonth" SortOrder="Descending"></telerik:GridSortExpression>
                <telerik:GridSortExpression FieldName="CreatedOn" SortOrder="Descending"></telerik:GridSortExpression>
            </SortExpressions>

            <CommandItemSettings ShowAddNewRecordButton="false" ShowRefreshButton="true" />

            <Columns>

                <telerik:GridTemplateColumn DataField="RequestID" Visible="true" InsertVisiblityMode="AlwaysHidden" DataType="System.Int32" UniqueName="RequestID"
                                            HeaderText="<%$ Resources:Resource, lblRequestID %>" SortExpression="RequestID" GroupByExpression="RequestID RequestID GROUP BY RequestID"
                                            ForceExtractValue="Always" FilterControlWidth="60px" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" ItemStyle-Width="90px" HeaderStyle-Width="90px">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="RequestID" Text='<%# Eval("RequestID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="CompanyID" Visible="false" InsertVisiblityMode="AlwaysHidden" DataType="System.Int32" UniqueName="CompanyID">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="CompanyID" Text='<%# Eval("CompanyID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="NameVisible" HeaderText="<%$ Resources:Resource, lblCompany %>" SortExpression="NameVisible" UniqueName="NameVisible"
                                            GroupByExpression="NameVisible NameVisible GROUP BY NameVisible" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px"
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="NameVisible" Text='<%# Eval("NameVisible") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridDateTimeColumn FilterControlWidth="100px" DataField="MWMonth" HeaderText="<%$ Resources:Resource, lblMonth %>" SortExpression="MWMonth"
                                            UniqueName="MWMonth" PickerType="DatePicker" EnableRangeFiltering="true" HeaderStyle-Width="170px" ItemStyle-Width="170px" CurrentFilterFunction="Between" 
                                            AutoPostBackOnFilter="true" DataFormatString="{0:MMM yyyy}" ReadOnly="true" EnableTimeIndependentFiltering="true">
                </telerik:GridDateTimeColumn>

                <telerik:GridTemplateColumn DataField="FileName" HeaderText="<%$ Resources:Resource, lblFileName %>" SortExpression="FileName" UniqueName="FileName"
                                            GroupByExpression="FileName FileName GROUP BY FileName" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px"
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <telerik:RadButton ID="FileName" runat="server" Text='<%# Eval("FileName") %>' ToolTip="<%$ Resources:Resource, msgClickToDownload %>" 
                                           ButtonType="StandardButton" CommandName="GetFile" CommandArgument='<%# Eval("RequestID") %>' OnClientClicked="gridCommand">
                            <Icon PrimaryIconUrl="/InSiteApp/Resources/Icons/go-down_16.png" />
                        </telerik:RadButton>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridDateTimeColumn FilterControlWidth="100px" DataField="CreatedOn" HeaderText="<%$ Resources:Resource, lblCreatedOn %>" SortExpression="CreatedOn"
                                            UniqueName="CreatedOn" PickerType="DatePicker" EnableRangeFiltering="true" HeaderStyle-Width="170px" ItemStyle-Width="170px" 
                                            CurrentFilterFunction="Between" AutoPostBackOnFilter="true" DataFormatString="{0:G}" ReadOnly="true" EnableTimeIndependentFiltering="true">
                </telerik:GridDateTimeColumn>

                <telerik:GridTemplateColumn DataField="CreatedFrom" HeaderText="<%$ Resources:Resource, lblCreatedFrom %>" SortExpression="CreatedFrom" UniqueName="CreatedFrom"
                                            GroupByExpression="CreatedFrom CreatedFrom GROUP BY CreatedFrom" Visible="true" ForceExtractValue="Always" FilterControlWidth="80px"
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="CreatedFrom" Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
            </Columns>

        </MasterTableView>
    </telerik:RadGrid>

    <asp:SqlDataSource ID="SqlDataSource_Companies" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
        SelectCommand="GetBpCompaniesWithLevel" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
            <asp:Parameter DefaultValue="2" Name="Level" Type="Int32"></asp:Parameter>
            <asp:SessionParameter SessionField="CompanyID" DefaultValue="0" Name="CompanyID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
