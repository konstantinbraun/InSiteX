<%@ Page Title="<%$ Resources:Resource, lblReportConfiguration%>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ReportConfiguration.aspx.cs" Inherits="InSite.App.Views.Central.ReportConfiguration" %>
<%@ Register src="../../CustomControls/wcBpSwitcher.ascx" tagname="wcBpSwitcher" tagprefix="uc1" %>
<%@ Register Src="~/CustomControls/wcBpSwitcher.ascx" TagPrefix="uc2" TagName="wcBpSwitcher" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <asp:ObjectDataSource ID="ReportVisibilityDataSource" runat="server" DataObjectTypeName="InSite.App.Models.clsReport" DeleteMethod="Delete" InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" SelectMethod="GetReportVisibilityDataSource" TypeName="InSite.App.BLL.dtoReport" UpdateMethod="Update"></asp:ObjectDataSource>
    <asp:ObjectDataSource ID="ReportDataSource" runat="server" DataObjectTypeName="InSite.App.Models.clsReport" DeleteMethod="Delete" InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" SelectMethod="GetAll" TypeName="InSite.App.BLL.dtoReport" UpdateMethod="Update"></asp:ObjectDataSource>
    <telerik:RadGrid ID="RadGrid1" runat="server" 
            AllowPaging="True" 
            AllowSorting="True"
            Culture="de-DE" CssClass="MainGrid"
            DataSourceID="ReportDataSource" 
            AllowFilteringByColumn="True" OnItemCommand="RadGrid1_ItemCommand" >
        <GroupingSettings CollapseAllTooltip="Collapse all groups">
        </GroupingSettings>
        <MasterTableView AutoGenerateColumns="False" 
                DataSourceID="ReportDataSource" 
                DataKeyNames="Id" 
                Caption ="<%$ Resources:Resource, lblReportConfiguration%>"
                CommandItemDisplay ="Top"  
                InsertItemDisplay ="Top" 
                InsertItemPageIndexAction="ShowItemOnFirstPage" 
                CssClass="MasterClass"
                AllowAutomaticInserts="True"
                AllowAutomaticUpdates="True" AllowAutomaticDeletes="True">
            
            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" PageSizes="15,30,60" />

            <EditFormSettings CaptionDataField="Name" CaptionFormatString="{0}" InsertCaption ="<%$ Resources:Resource, lblReportConfiguration %>">
                <FormCaptionStyle Font-Bold ="true"  Font-Underline ="true"  />
                <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                <EditColumn ButtonType="PushButton" UniqueName="EditCommandColumn1" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                            UpdateText="<%$ Resources:Resource, lblActionUpdate %>"  />
                <FormTableStyle CellPadding="3" CellSpacing="3" Width ="400px" />
            </EditFormSettings>
            <NestedViewTemplate>
                <div style="padding: 10px">
                        <telerik:RadTabStrip RenderMode="Lightweight" runat="server" ID="RadTabStrip2"  MultiPageID="RadMultiPage2" SelectedIndex="0">
                            <Tabs>
                                <telerik:RadTab runat="server" Text="Root RadTab1">
                                    <TabTemplate>
                                         <%#Resources.Resource.lblRoles %>
                                    </TabTemplate>
                                </telerik:RadTab>
                                <telerik:RadTab runat="server" Text="Root RadTab2">
                                    <TabTemplate>
                                        <%#Resources.Resource.lblBPAvailable %>
                                    </TabTemplate>
                                </telerik:RadTab>
                            </Tabs>
                        </telerik:RadTabStrip>
                        <telerik:RadMultiPage ID="RadMultiPage2" runat="server"  SelectedIndex="0"  BorderStyle="Solid" BorderWidth="1px" BorderColor="#a4abb2" >
                            <telerik:RadPageView ID="RadPageView1" runat="server" >
                                <uc1:wcBpSwitcher ID="RoleSwitcher" runat="server" />
                            </telerik:RadPageView>
                            <telerik:RadPageView ID="RadPageView2" runat="server" >
                                <uc1:wcBpSwitcher ID="BpSwitcher" runat="server" />
                            </telerik:RadPageView>
                        </telerik:RadMultiPage>

                </div>
            </NestedViewTemplate>
            <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="True" ShowExportToCsvButton="false"
                            ShowExportToExcelButton="true" ShowExportToPdfButton="false"
                            AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />
            <Columns>
                <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                                UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false" >
                    <ItemStyle BackColor="Control" Width="30px" />
                    <HeaderStyle Width="30px" />
                </telerik:GridEditCommandColumn>

                <telerik:GridHyperLinkColumn HeaderText="Name" DataNavigateUrlFields="Id" UniqueName="Link" DataTextField="Name" DataNavigateUrlFormatString="~/Views/Central/ReportDesigner.aspx?id={0}">
                </telerik:GridHyperLinkColumn>

                <telerik:GridBoundColumn DataField="Name" FilterControlAltText="Filter Name column" HeaderText="Name" SortExpression="Name" UniqueName="Name" Visible ="false">
                    <ColumnValidationSettings EnableRequiredFieldValidation="True" >
                        <RequiredFieldValidator CssClass ="Bubble" ErrorMessage ="<%$ Resources:Resource, msgInputRequired %>" ForeColor ="White"></RequiredFieldValidator>
                    </ColumnValidationSettings>
                </telerik:GridBoundColumn>

                <telerik:GridBoundColumn DataField="Description" FilterControlAltText="Filter Description column" HeaderText="<%$ Resources:Resource, lblDescriptionShort %>"   SortExpression="Description" UniqueName="Description">
                </telerik:GridBoundColumn>

                <telerik:GridTemplateColumn DataField="ReportVisibility" HeaderText="Report visibility" UniqueName="ReportVisibility2">
                        <ItemTemplate> 
                            <asp:Label ID="Label1" runat="server" Text='<%# GetDisplayText((Int32)Eval("ReportVisibility")) %>' ForeColor='<%#Eval("ItemColor")%>'></asp:Label> 
                        </ItemTemplate>
                        <EditItemTemplate>
                            <telerik:RadComboBox ID="TinyCombo" runat="server" DataSourceID="ReportVisibilityDataSource" DataTextField="Value" DataValueField="Key" SelectedValue='<%# Bind("ReportVisibilityInt") %>'>
                            </telerik:RadComboBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <telerik:RadComboBox ID="TinyCombo" runat="server" DataSourceID="ReportVisibilityDataSource" DataTextField="Value" DataValueField="Key" SelectedValue='<%# Bind("ReportVisibilityInt") %>'>
                            </telerik:RadComboBox>
                        </InsertItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridButtonColumn UniqueName="deleteColumn" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                        ConfirmDialogType="RadWindow" ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton"  CommandName="Delete" 
                                        HeaderStyle-Width="30px" ItemStyle-Width="30px" >
<HeaderStyle Width="30px"></HeaderStyle>

                    <ItemStyle BackColor="Control" />
                </telerik:GridButtonColumn>

            </Columns>
            <PagerStyle AlwaysVisible="True" />
        </MasterTableView>
    </telerik:RadGrid>

    <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGrid1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
               </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    </asp:Content>
