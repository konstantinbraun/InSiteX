<%@ Page Title="<%$ Resources:Resource, lblLogViewer %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LogViewer.aspx.cs" Inherits="InSite.App.Views.Costumization.LogViewer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <telerik:RadGrid ID="RadGrid1" runat="server" DataSourceID="SqlDataSource_Logging" AllowFilteringByColumn="True" AllowPaging="True" AllowSorting="True" CssClass="MainGrid"
        EnableHeaderContextFilterMenu="True" EnableHeaderContextMenu="True" CellSpacing="0" GridLines="None" ShowGroupPanel="True" PageSize="20" GroupPanelPosition="BeforeHeader"
        OnItemCreated="RadGrid1_ItemCreated" OnGroupsChanging="RadGrid1_GroupsChanging">

        <GroupPanel Text="<%$ Resources:Resource, msgGroupPanel %>">
        </GroupPanel>

        <GroupingSettings ShowUnGroupButton="True" />

        <ExportSettings ExportOnlyData="True" IgnorePaging="True">
            <Pdf PageHeight="" PageWidth="" PaperSize="A4">
            </Pdf>
            <Excel Format="ExcelML" />
        </ExportSettings>

        <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false">
            <Resizing AllowColumnResize="true"></Resizing>
            <Selecting AllowRowSelect="True" />
            <ClientEvents OnRowClick="OnRowClick" OnKeyPress="GridKeyPress" />
        </ClientSettings>

        <SortingSettings SortedBackColor="Transparent" />

        <MasterTableView EnableHierarchyExpandAll="true" AutoGenerateColumns="False" DataKeyNames="LoggingID" DataSourceID="SqlDataSource_Logging"
            CommandItemDisplay="Top" HierarchyLoadMode="ServerOnDemand" AllowMultiColumnSorting="true">

            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" PageSizes="20,50,100,250" />

            <SortExpressions>
                <telerik:GridSortExpression FieldName="LoggingID" SortOrder="Descending"></telerik:GridSortExpression>
            </SortExpressions>

            <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="false" ShowExportToCsvButton="True" ShowExportToExcelButton="True" ShowExportToPdfButton="True"
                AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                <SortExpressions>
                    <telerik:GridSortExpression FieldName="LoggingDate" SortOrder="Descending"></telerik:GridSortExpression>
                </SortExpressions>

            <Columns>
                <telerik:GridTemplateColumn DataField="LoggingID" DataType="System.Int32" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter LoggingID column"
                    HeaderText="<%$ Resources:Resource, lblID %>" SortExpression="LoggingID" UniqueName="LoggingID" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="LoggingID" runat="server" Text='<%# Eval("LoggingID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridDateTimeColumn FilterControlWidth="150px" DataField="LoggingDate" HeaderText="<%$ Resources:Resource, lblTimeStamp %>" SortExpression="LoggingDate"
                    UniqueName="LoggingDate" PickerType="DateTimePicker" EnableRangeFiltering="true" AutoPostBackOnFilter="true" CurrentFilterFunction="Between">
                </telerik:GridDateTimeColumn>

                <telerik:GridTemplateColumn DataField="UserName" HeaderText="<%$ Resources:Resource, lblUserName %>" SortExpression="UserName" UniqueName="UserName"
                    GroupByExpression="UserName UserName GROUP BY UserName" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="UserName" Text='<%# String.Concat(Eval("LoginName"), " (", Eval("UserName"), ")") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="BuildingProjectName" HeaderText="<%$ Resources:Resource, lblBuildingProject %>" SortExpression="BuildingProjectName" UniqueName="BuildingProjectName"
                    GroupByExpression="BuildingProjectName BuildingProjectName GROUP BY BuildingProjectName" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="BuildingProjectName" Text='<%# Eval("BuildingProjectName") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="DialogResourceID" HeaderText="<%$ Resources:Resource, lblDialog %>" SortExpression="DialogResourceID" UniqueName="DialogResourceID"
                    GroupByExpression="DialogResourceID DialogResourceID GROUP BY DialogResourceID" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="DialogResourceID" Text='<%# GetResource(Eval("DialogResourceID").ToString())%>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="ActionResourceID" HeaderText="<%$ Resources:Resource, lblAction %>" SortExpression="ActionResourceID" UniqueName="ActionResourceID"
                    GroupByExpression="ActionResourceID ActionResourceID GROUP BY ActionResourceID" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="ActionResourceID" Text='<%# GetResource(Eval("ActionResourceID").ToString())%>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Message" HeaderText="<%$ Resources:Resource, lblMessage %>" SortExpression="Message" UniqueName="Message"
                    GroupByExpression="Message Message GROUP BY Message" Visible="true" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Message" Text='<%# Tail(Eval("Message").ToString(), 50) %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="RefID" HeaderText="<%$ Resources:Resource, lblChangedRecord %>" SortExpression="RefID" UniqueName="RefID"
                    GroupByExpression="ActionResourceID ActionResourceID GROUP BY ActionResourceID" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="RefID" Text='<%# Eval("RefID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
            </Columns>

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

    <asp:SqlDataSource ID="SqlDataSource_Logging" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
        SelectCommand="SELECT l.LoggingID, l.SystemID, l.BpID, l.[Date] AS LoggingDate, l.Thread, l.Level, l.Logger, l.Message, l.Exception, l.SessionID, l.DialogID, l.UserID, l.ActionID, l.RefID, a.NameVisible AS ActionName, a.ResourceID AS ActionResourceID, u.FirstName + ' ' + u.LastName AS UserName, u.Company, u.LoginName, u.RoleID, d.NameVisible AS DialogName, d.ResourceID AS DialogResourceID, b.NameVisible AS BuildingProjectName FROM Data_Logging AS l LEFT OUTER JOIN Master_BuildingProjects AS b ON l.SystemID = b.SystemID AND l.BpID = b.BpID LEFT OUTER JOIN Master_Users AS u ON l.SystemID = u.SystemID AND l.UserID = u.UserID LEFT OUTER JOIN System_Dialogs AS d ON l.SystemID = d.SystemID AND l.DialogID = d.DialogID LEFT OUTER JOIN System_Actions AS a ON l.SystemID = a.SystemID AND l.ActionID = a.ActionID WHERE (l.SystemID = @SystemID)">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Dialogs" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
        SelectCommand="SELECT * FROM System_Dialogs WHERE (SystemID = @SystemID) ORDER BY NameVisible">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
