<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="wcBpContact.ascx.cs" Inherits="InSite.App.CustomControls.wcBpContact" %>
<telerik:RadGrid ID="RadGrid1" runat="server" AllowPaging="True" Culture="de-DE" DataSourceID="BpContactDataSource" EnableHeaderContextFilterMenu="True" EnableHeaderContextMenu="True"
        AllowSorting="True"  AllowFilteringByColumn="True" ShowGroupPanel="True">
    
<GroupingSettings CollapseAllTooltip="Collapse all groups"></GroupingSettings>

    <ExportSettings>
        <Pdf PageWidth="">
        </Pdf>
    </ExportSettings>
    
    <ClientSettings AllowDragToGroup="True">
    </ClientSettings>
    
    <MasterTableView AutoGenerateColumns="False" DataSourceID="BpContactDataSource" DataKeyNames="Id" CommandItemDisplay ="Top" 
        InsertItemDisplay ="Top" InsertItemPageIndexAction="ShowItemOnFirstPage" AllowAutomaticDeletes ="true" AllowAutomaticInserts="True" AllowAutomaticUpdates="True">
        <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" PageSizes="15,30,60" />

        <EditFormSettings CaptionDataField="FullName" CaptionFormatString="{0}" InsertCaption ="<%$ Resources:Resource, lblContact %>">
            <FormCaptionStyle Font-Bold ="true"  Font-Underline ="true"  />
            <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
            <EditColumn ButtonType="PushButton" UniqueName="EditCommandColumn1" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                        UpdateText="<%$ Resources:Resource, lblActionUpdate %>"  />
            <FormTableStyle CellPadding="3" CellSpacing="3" Width ="400px" />
        </EditFormSettings>

        <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="True" ShowExportToCsvButton="false"
                            ShowExportToExcelButton="true" ShowExportToPdfButton="false"
                            AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

        <Columns>
            <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                            UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false" >
                <ItemStyle BackColor="Control" Width="30px" />
                <HeaderStyle Width="30px" />
            </telerik:GridEditCommandColumn>
            <telerik:GridTemplateColumn DataField="Id" DataType="System.Int32" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter BpID column" 
                                            HeaderText="<%$ Resources:Resource, lblBpID %>" SortExpression="Id" UniqueName="Id" Visible="true" HeaderStyle-HorizontalAlign="Right"
                                            ItemStyle-HorizontalAlign="Right" AllowFiltering="false" HeaderStyle-Width="50px" ItemStyle-Width="50px">
                    <EditItemTemplate>
                        <asp:Label ID="BpID" runat="server" Text='<%# Eval("Id") %>'></asp:Label>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" ID="BpID" Text='<%# Eval("Id") %>'></asp:Label>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Right" Width="50px"></HeaderStyle>
                    <ItemStyle HorizontalAlign="Right" Width="50px"></ItemStyle>
                </telerik:GridTemplateColumn>
            <telerik:GridBoundColumn DataField="FirstName"  FilterControlAltText="Filter FirstName column" HeaderText="<%$ Resources:Resource, lblFirstName %>" SortExpression="FirstName" UniqueName="FirstName">
                <ColumnValidationSettings EnableRequiredFieldValidation="True" >
                    <RequiredFieldValidator CssClass ="Bubble" ErrorMessage ="<%$ Resources:Resource, msgInputRequired %>" ForeColor ="White"></RequiredFieldValidator>
                </ColumnValidationSettings>
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="LastName" FilterControlAltText="Filter LastName column" HeaderText="<%$ Resources:Resource, lblLastName %>" SortExpression="LastName" UniqueName="LastName">
                <ColumnValidationSettings EnableRequiredFieldValidation ="true" >
                    <RequiredFieldValidator CssClass ="Bubble" ErrorMessage ="<%$ Resources:Resource, msgInputRequired %>" ForeColor ="White" ></RequiredFieldValidator>
                </ColumnValidationSettings>
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="Phone" FilterControlAltText="Filter Phone column" HeaderText="<%$ Resources:Resource, lblAddrPhone %>" SortExpression="Phone" UniqueName="Phone">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="Email" FilterControlAltText="Filter Email column" HeaderText="<%$ Resources:Resource, lblEmail %>" SortExpression="Email" UniqueName="Email">
            </telerik:GridBoundColumn>
            <telerik:GridBoundColumn DataField="Comments" FilterControlAltText="Filter Comments column" HeaderText="Comments" SortExpression="Comments" UniqueName="Comments">
            </telerik:GridBoundColumn>
            <telerik:GridCheckBoxColumn DataField="IsZplContact" DataType="System.Boolean" FilterControlAltText="Filter IsZplContact column" HeaderText="IsZplContact" SortExpression="IsZplContact" UniqueName="IsZplContact">
            </telerik:GridCheckBoxColumn>
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
<asp:ObjectDataSource ID="BpContactDataSource" runat="server" DataObjectTypeName="InSite.App.Models.clsBpContact" DeleteMethod="Delete" InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="InSite.App.BLL.dtoBpContact" UpdateMethod="Update" OnInserting="BpContactDataSource_Inserting" >
    <SelectParameters>
        <asp:QueryStringParameter Name="BpId" QueryStringField="id" Type="Int32" />
    </SelectParameters>
</asp:ObjectDataSource>

