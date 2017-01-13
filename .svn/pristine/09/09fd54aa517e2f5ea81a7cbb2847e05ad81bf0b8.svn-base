<%@ Page Title="<%$ Resources:Resource, lblMinWageReportCompany %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MinWageReport.aspx.cs" Inherits="InSite.App.Views.Reports.MinWageReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">

    <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadTreeList1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadTreeList1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>
<%--            <telerik:AjaxSetting AjaxControlID="MonthFrom">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadTreeList1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="MonthUntil">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadTreeList1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="CompanyID">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadTreeList1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>--%>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <div style="background-color: InactiveBorder;">
        <table cellpadding="3px" style="padding-left: 5px;">
            <tr>
                <td>
                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblTimeInterval %>" Font-Bold="true"></asp:Label>
                </td>
                <td colspan="2" style="vertical-align: top;">
                    <table style="vertical-align: top;">
                        <tr style="vertical-align: top;">
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
            </tr>
            <tr>
                <td style="vertical-align: top;">
                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblCompany %>"></asp:Label>
                </td>
                <td style="vertical-align: top;" colspan="2">
                    <telerik:RadDropDownTree runat="server" ID="CompanyID" DataFieldParentID="ParentID" DataFieldID="CompanyID" DataValueField="CompanyID" EnableFiltering="true" 
                                             DataTextField="CompanyName" Width="300px" OnClientKeyPressing="OnClientKeyPressing" DefaultMessage="<%$ Resources:Resource, lblAll %>"
                                             DropDownSettings-AutoWidth="Enabled" DataSourceID="SqlDataSource_Companies" OnEntryAdded="CompanyID_EntryAdded" AutoPostBack="true">
                        <ButtonSettings ShowClear="true" />
                        <FilterSettings Highlight="Matches" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" Filter="Contains" />
                        <DropDownSettings OpenDropDownOnLoad="false" CloseDropDownOnSelection="true" />
                    </telerik:RadDropDownTree>
                </td>
            </tr>
            <tr>
                <td nowrap="nowrap">
                    <asp:Label runat="server" ID="LabelTemplate" Text='<%$ Resources:Resource, lblTemplate %>'></asp:Label>
                </td>
                <td colspan="2">
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
                <td colspan="2">
                    <telerik:RadTextBox runat="server" ID="Remarks" Width="880px"></telerik:RadTextBox>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <asp:ValidationSummary runat="server" DisplayMode="BulletList" ShowMessageBox="true" ShowSummary="true" BorderStyle="None"  
                                            ValidationGroup="Submit" />
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <telerik:RadButton ID="btnExportExcel" runat="server" Text="<%$ Resources:Resource, lblExportToExcel %>" ToolTip="<%$ Resources:Resource, lblExportToExcel %>" 
                                       OnClick="BtnOK_Click" ButtonType="StandardButton" CommandArgument="Excel" ValidationGroup="Submit" CausesValidation="true">
                        <Icon PrimaryIconUrl="/InSiteApp/Resources/Icons/export_xlsx_16.png" />
                    </telerik:RadButton>
                    <telerik:RadButton ID="btnExportPdf" runat="server" Text="<%$ Resources:Resource, lblExportToPdf %>" ToolTip="<%$ Resources:Resource, lblExportToPdf %>" 
                                       OnClick="BtnOK_Click" ButtonType="StandardButton" CommandArgument="Pdf" ValidationGroup="Submit" CausesValidation="true">
                        <Icon PrimaryIconUrl="/InSiteApp/Resources/Icons/export_pdf_16.png" />
                    </telerik:RadButton>
                </td>
            </tr>
        </table>
    </div>

    <telerik:RadTreeList ID="RadTreeList1" runat="server" ParentDataKeyNames="ParentID" DataKeyNames="CompanyID" ClientDataKeyNames="CompanyID" AllowLoadOnDemand="false" 
                         CssClass="RadTreeList" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="false" ShowTreeLines="true" HideExpandCollapseButtonIfNoChildren="true" 
                         PageSize="15" AllowRecursiveDelete="true" AllowMultiItemSelection="false" ShowOuterBorders="true" AllowNaturalSort="true" AllowStableSort="true" 
                         EditMode="PopUp" Caption="<%$ Resources:Resource, lblMWAttestations %>"
                         OnNeedDataSource="RadTreeList1_NeedDataSource" OnItemCommand="RadTreeList1_ItemCommand">

        <ExportSettings IgnorePaging="True" ExportMode="ReplaceControls" OpenInNewWindow="true">
            <Pdf PaperSize="A4"></Pdf>
        </ExportSettings>

        <ClientSettings AllowItemsDragDrop="false" AllowPostBackOnItemClick="true">
            <Selecting AllowItemSelection="true" />
        </ClientSettings>

        <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

        <SortExpressions>
            <telerik:TreeListSortExpression FieldName="NameVisible" SortOrder="Ascending"></telerik:TreeListSortExpression>
        </SortExpressions>

        <Columns>

            <telerik:TreeListBoundColumn DataField="CompanyID" UniqueName="CompanyID" ForceExtractValue="Always" Visible="false">
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

            <telerik:TreeListBoundColumn DataField="ParentID" HeaderText="ParentID" Visible="false" UniqueName="ParentID" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="MWAttestationMCRequired" HeaderText="<%$ Resources:Resource, lblMWAttestationMCRequired %>" Visible="true" UniqueName="MWAttestationMCRequired" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="MWAttestationSCRequired" HeaderText="<%$ Resources:Resource, lblMWAttestationSCRequired %>" Visible="true" UniqueName="MWAttestationSCRequired" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="MWAttestationMCOpen" HeaderText="<%$ Resources:Resource, lblMWAttestationMCOpen %>" Visible="true" UniqueName="MWAttestationMCOpen" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="MWAttestationSCOpen" HeaderText="<%$ Resources:Resource, lblMWAttestationSCOpen %>" Visible="true" UniqueName="MWAttestationSCOpen" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="MWAttestationMCExisting" HeaderText="<%$ Resources:Resource, lblMWAttestationMCExisting %>" Visible="true" UniqueName="MWAttestationMCExisting" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="MWAttestationSCExisting" HeaderText="<%$ Resources:Resource, lblMWAttestationSCExisting %>" Visible="true" UniqueName="MWAttestationSCExisting" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="MWAttestationMCFaulty" HeaderText="<%$ Resources:Resource, lblMWAttestationMCFaulty %>" Visible="true" UniqueName="MWAttestationMCFaulty" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="MWAttestationSCFaulty" HeaderText="<%$ Resources:Resource, lblMWAttestationSCFaulty %>" Visible="true" UniqueName="MWAttestationSCFaulty" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="MWAttestationMCToLow" HeaderText="<%$ Resources:Resource, lblMWAttestationMCToLow %>" Visible="false" UniqueName="MWAttestationMCToLow" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="MWAttestationSCToLow" HeaderText="<%$ Resources:Resource, lblMWAttestationSCToLow %>" Visible="false" UniqueName="MWAttestationSCToLow" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="MWAttestationMCWrong" HeaderText="<%$ Resources:Resource, lblMWAttestationMCWrong %>" Visible="false" UniqueName="MWAttestationMCWrong" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListBoundColumn DataField="MWAttestationSCWrong" HeaderText="<%$ Resources:Resource, lblMWAttestationSCWrong %>" Visible="false" UniqueName="MWAttestationSCWrong" ReadOnly="true" ForceExtractValue="Always">
            </telerik:TreeListBoundColumn>

            <telerik:TreeListTemplateColumn DataField="CompanyID" HeaderText="" UniqueName="MinWageEmployee" ItemStyle-HorizontalAlign="Center"
                                            ForceExtractValue="Always" ItemStyle-Width="30px" HeaderStyle-Width="30px">
                <ItemTemplate>
                        <telerik:RadButton ID="MinWageEmployee" runat="server" ButtonType="ToggleButton" CausesValidation="false" AutoPostBack="true" CommandName="MinWageEmployee"
                                           ToolTip="<%$ Resources:Resource, msgShowDetails %>" Width="16px" Height="16px" CommandArgument='<%# Eval("CompanyID") %>'>
                            <Image ImageUrl="/InSiteApp/Resources/Icons/Staff_16.png" />
                        </telerik:RadButton>
                </ItemTemplate>
            </telerik:TreeListTemplateColumn>

        </Columns>

    </telerik:RadTreeList>

    <asp:SqlDataSource ID="SqlDataSource_Companies" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
        SelectCommand="SELECT c.SystemID, c.BpID, c.CompanyID, (CASE WHEN @CompanyID > 0 THEN NULL ELSE (CASE WHEN c.ParentID = 0 THEN NULL ELSE c.ParentID END) END) AS ParentID, s_c.NameVisible, s_c.NameAdditional, c.Description, c.AddressID, c.IsVisible, c.IsValid, c.TradeAssociation, c.BlnSOKA, c.CreatedFrom, c.CreatedOn, c.EditFrom, c.EditOn, a.Address1, a.Address2, a.Zip, a.City, a.State, a.CountryID, a.Phone, a.Email, a.WWW, s_c.NameVisible + (CASE WHEN s_c.NameAdditional IS NULL THEN '' ELSE ', ' + s_c.NameAdditional END) + (CASE WHEN a.City IS NULL THEN '' ELSE ', ' + a.City END) AS CompanyName FROM Master_Companies AS c INNER JOIN System_Companies AS s_c ON c.SystemID = s_c.SystemID AND c.CompanyCentralID = s_c.CompanyID LEFT OUTER JOIN System_Addresses AS a ON c.SystemID = a.SystemID AND c.AddressID = a.AddressID WHERE (c.SystemID = @SystemID) AND (c.BpID = @BpID) AND (c.ReleaseOn IS NOT NULL) AND (c.CompanyCentralID = (CASE WHEN @CompanyID = 0 THEN c.CompanyCentralID ELSE @CompanyID END)) AND (dbo.HasLockedMainContractor(c.SystemID, c.BpID, c.CompanyID) = 0) ORDER BY s_c.NameVisible">
        <SelectParameters>
            <asp:SessionParameter SessionField="CompanyID" DefaultValue="0" Name="CompanyID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
