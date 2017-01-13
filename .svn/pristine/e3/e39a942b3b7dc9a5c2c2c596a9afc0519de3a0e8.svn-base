<%@ Page Title="<%$ Resources:Resource, lblCostLocations %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CostLocations.aspx.cs" Inherits="InSite.App.Views.Central.CostLocations" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <telerik:RadPersistenceManagerProxy ID="RadPersistenceManagerProxy1" runat="server">
        <PersistenceSettings>
            <telerik:PersistenceSetting ControlID="RadGrid1" />
        </PersistenceSettings>
    </telerik:RadPersistenceManagerProxy>

    <div>
        <telerik:RadGrid ID="RadGrid1" runat="server" DataSourceID="SqlDataSource_CostLocations" AllowSorting="true" CssClass="MainGrid"
                         OnItemInserted="RadGrid1_ItemInserted" OnItemDeleted="RadGrid1_ItemDeleted" OnPreRender="RadGrid1_PreRender" OnItemUpdated="RadGrid1_ItemUpdated"
                         OnItemCommand="RadGrid1_ItemCommand" OnItemCreated="RadGrid1_ItemCreated" OnItemDataBound="RadGrid1_ItemDataBound" OnGroupsChanging="RadGrid1_GroupsChanging"
                         AllowAutomaticInserts="true" AllowAutomaticUpdates="true" AllowAutomaticDeletes="true" AllowPaging="true">

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

            <MasterTableView AutoGenerateColumns="False" DataKeyNames="SystemID,CostLocationID" CommandItemDisplay="Top" EditMode="PopUp" DataSourceID="SqlDataSource_CostLocations">

                <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

                <SortExpressions>
                    <telerik:GridSortExpression FieldName="CostLocationNumber" SortOrder="Descending"></telerik:GridSortExpression>
                </SortExpressions>

                <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="False" ShowExportToExcelButton="True" ShowExportToPdfButton="False"
                                     AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                <EditFormSettings CaptionDataField="NameVisible" CaptionFormatString="{0}">
                    <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                    <EditColumn ButtonType="ImageButton" UniqueName="EditCommandColumn1" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                    <FormTableStyle CellPadding="3" CellSpacing="3" />
                </EditFormSettings>

                <Columns>

                <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                               UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                    <ItemStyle BackColor="Control" Width="30px" />
                    <HeaderStyle Width="30px" />
                </telerik:GridEditCommandColumn>

                    <telerik:GridTemplateColumn DataField="CostLocationNumber" HeaderText="<%$ Resources:Resource, lblCostLocationNumber %>" SortExpression="CostLocationNumber" UniqueName="CostLocationNumber"
                                                GroupByExpression="CostLocationNumber CostLocationNumber GROUP BY CostLocationNumber">
                        <EditItemTemplate>
                            <telerik:RadTextBox runat="server" ID="tbCostLocationNumber" Text='<%# Bind("CostLocationNumber") %>'></telerik:RadTextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" ID="CostLocationNumber" Text='<%# Eval("CostLocationNumber") %>'></asp:Label>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn DataField="NameVisible" HeaderText="<%$ Resources:Resource, lblCostLocationNameVisible %>" SortExpression="NameVisible" UniqueName="NameVisible"
                                                GroupByExpression="NameVisible NameVisible GROUP BY NameVisible">
                        <EditItemTemplate>
                            <telerik:RadTextBox runat="server" ID="tbNameVisible" Text='<%# Bind("NameVisible") %>'></telerik:RadTextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" ID="NameVisible" Text='<%# Eval("NameVisible") %>'></asp:Label>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn DataField="DescriptionShort" HeaderText="<%$ Resources:Resource, lblDescriptionShort %>" SortExpression="DescriptionShort" UniqueName="DescriptionShort"
                                                GroupByExpression="DescriptionShort DescriptionShort GROUP BY DescriptionShort">
                        <EditItemTemplate>
                            <telerik:RadTextBox runat="server" ID="tbDescriptionShort" Text='<%# Bind("DescriptionShort") %>'></telerik:RadTextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" ID="DescriptionShort" Text='<%# Eval("DescriptionShort") %>'></asp:Label>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridBoundColumn DataField="TypeID" DataType="System.Byte" FilterControlAltText="Filter TypeID column" HeaderText="<%$ Resources:Resource, lblType %>" SortExpression="TypeID" UniqueName="TypeID" Visible="False" DefaultInsertValue="1">
                        <ColumnValidationSettings>
                            <ModelErrorMessage Text="" />
                        </ColumnValidationSettings>
                    </telerik:GridBoundColumn>

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

                <telerik:GridButtonColumn UniqueName="deleteColumn" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                          ConfirmDialogType="RadWindow"
                                          ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                    <ItemStyle BackColor="Control" />
                </telerik:GridButtonColumn>

                </Columns>
            </MasterTableView>

        </telerik:RadGrid>
    </div>

    <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGrid1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                    <telerik:AjaxUpdatedControl ControlID="RadDropDownList1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <asp:SqlDataSource ID="SqlDataSource_CostLocations" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>" OnInserted="SqlDataSource_Inserted"
        OldValuesParameterFormatString="original_{0}"
                       DeleteCommand="INSERT INTO History_S_CostLocations SELECT * FROM System_CostLocations WHERE [SystemID] = @original_SystemID AND (CostLocationID = @original_CostLocationID); 
                       DELETE FROM System_CostLocations WHERE (SystemID = @original_SystemID) AND (CostLocationID = @original_CostLocationID)"
                       InsertCommand="INSERT INTO Sytem_CostLocations(SystemID, TypeID, IsVisible, CostLocationNumber, NameVisible, DescriptionShort, CreatedFrom, CreatedOn, EditFrom, EditOn) VALUES (@SystemID, @TypeID, @IsVisible, @CostLocationNumber, @NameVisible, @DescriptionShort, @UserName, SYSDATETIME(), @UserName, SYSDATETIME()) 
                       SELECT @ReturnValue = SCOPE_IDENTITY()"
                       UpdateCommand="INSERT INTO History_S_CostLocations SELECT * FROM System_CostLocations WHERE [SystemID] = @original_SystemID AND (CostLocationID = @original_CostLocationID); 
                       UPDATE System_CostLocations SET CostLocationNumber=@CostLocationNumber, NameVisible=@NameVisible, DescriptionShort=@DescriptionShort, TypeID=@TypeID, IsVisible=@IsVisible, EditFrom=@UserName, EditOn=SYSDATETIME() WHERE (SystemID = @original_SystemID) AND (CostLocationID = @original_CostLocationID)"
                       SelectCommand="SELECT SystemID, CostLocationID, CostLocationNumber, NameVisible, DescriptionShort, TypeID, IsVisible, CreatedFrom, CreatedOn, EditFrom, EditOn FROM System_CostLocations WHERE (SystemID = @SystemID) ORDER BY CostLocationNumber DESC">

        <DeleteParameters>
            <asp:Parameter Name="original_SystemID" Type="Int32" />
            <asp:Parameter Name="original_CostLocationID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
            <asp:Parameter Name="TypeID" Type="Byte" />
            <asp:Parameter Name="IsVisible" Type="Boolean" />
            <asp:Parameter Name="CostLocationNumber" Type="String" />
            <asp:Parameter Name="NameVisible" Type="String" />
            <asp:Parameter Name="DescriptionShort" Type="String" />
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
            <asp:Parameter Name="ReturnValue" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="CostLocationNumber" Type="String" />
            <asp:Parameter Name="NameVisible" Type="String" />
            <asp:Parameter Name="DescriptionShort" Type="String" />
            <asp:Parameter Name="TypeID" Type="Byte" />
            <asp:Parameter Name="IsVisible" Type="Boolean" />
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
            <asp:Parameter Name="original_SystemID" Type="Int32" />
            <asp:Parameter Name="original_CostLocationID" Type="Int32" />
        </UpdateParameters>
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
