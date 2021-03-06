﻿<%@ Page Title="<%$ Resources:Resource, lblFirstAiders %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="FirstAiders.aspx.cs" Inherits="InSite.App.Views.Configuration.FirstAiders" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
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
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <div>
        <telerik:RadGrid ID="RadGrid1" runat="server" DataSourceID="SqlDataSource_FirstAiders" AllowPaging="True" AllowSorting="True" CellSpacing="0"
                         GridLines="None" AllowAutomaticDeletes="true" AllowAutomaticInserts="true" AllowAutomaticUpdates="true" CssClass="MainGrid" EnableHierarchyExpandAll="true"
                         EnableGroupsExpandAll="true" 
                         OnItemCommand="RadGrid1_ItemCommand" OnItemCreated="RadGrid1_ItemCreated" OnGroupsChanging="RadGrid1_GroupsChanging"
                         OnItemDeleted="RadGrid1_ItemDeleted" OnItemInserted="RadGrid1_ItemInserted" OnItemUpdated="RadGrid1_ItemUpdated" OnPreRender="RadGrid1_PreRender" >

            <ExportSettings ExportOnlyData="true" IgnorePaging="true">
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

            <MasterTableView runat="server" DataSourceID="SqlDataSource_FirstAiders" DataKeyNames="SystemID,BpID,FirstAiderID" AutoGenerateColumns="False" CommandItemDisplay="Top"
                             EditMode="PopUp" Name="StaffRoles" ShowHeader="true" CssClass="MasterClass">

                <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

                <SortExpressions>
                    <telerik:GridSortExpression FieldName="MaxPresent" SortOrder="Ascending"></telerik:GridSortExpression>
                </SortExpressions>

                <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="False" ShowExportToExcelButton="True" ShowExportToPdfButton="False"
                                     AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                <EditFormSettings EditFormType="AutoGenerated" CaptionDataField="DescriptionShort" CaptionFormatString="{0}">
                    <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                    <EditColumn ButtonType="ImageButton" UniqueName="EditColumn1" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                                EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                    <FormTableStyle CellPadding="3" CellSpacing="3" />
                </EditFormSettings>

                <Columns>
                <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                               UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                    <ItemStyle BackColor="Control" Width="30px" />
                    <HeaderStyle Width="30px" />
                </telerik:GridEditCommandColumn>

                    <telerik:GridTemplateColumn DataField="FirstAiderID" Visible="false" InsertVisiblityMode="AlwaysHidden" DataType="System.Int32"
                                                FilterControlAltText="Filter FirstAiderID column" HeaderText="<%$ Resources:Resource, lblID %>"
                                                SortExpression="FirstAiderID" UniqueName="FirstAiderID" GroupByExpression="FirstAiderID FirstAiderID GROUP BY FirstAiderID">
                        <EditItemTemplate>
                            <asp:Label runat="server" ID="LabelFirstAiderID" Text='<%# Eval("FirstAiderID") %>'></asp:Label>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                        </InsertItemTemplate>
                        <ItemTemplate>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn DataField="MaxPresent" HeaderText="<%$ Resources:Resource, lblMaxPresent %>" SortExpression="MaxPresent" UniqueName="MaxPresent"
                                                GroupByExpression="MaxPresent MaxPresent GROUP BY MaxPresent">
                        <EditItemTemplate>
                            <telerik:RadNumericTextBox runat="server" ID="MaxPresent" Text='<%# Bind("MaxPresent") %>' ShowSpinButtons="true" ButtonsPosition="Right"
                                                       MinValue="0">
                                <IncrementSettings Step="1" />
                                <NumberFormat DecimalDigits="0" />
                            </telerik:RadNumericTextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Eval("MaxPresent") %>'></asp:Label>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn DataField="MinAiders" HeaderText="<%$ Resources:Resource, lblMinAiders %>" SortExpression="MinAiders" UniqueName="MinAiders"
                                                GroupByExpression="MinAiders MinAiders GROUP BY MinAiders">
                        <EditItemTemplate>
                            <telerik:RadNumericTextBox runat="server" ID="MinAiders" Text='<%# Bind("MinAiders") %>' ShowSpinButtons="true" ButtonsPosition="Right"
                                                       MinValue="0">
                                <IncrementSettings Step="1" />
                                <NumberFormat DecimalDigits="0" />
                            </telerik:RadNumericTextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Eval("MinAiders") %>'></asp:Label>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn DataField="DescriptionShort" FilterControlAltText="Filter DescriptionShort column" HeaderText="<%$ Resources:Resource, lblDescriptionShort %>"
                                                SortExpression="DescriptionShort" UniqueName="DescriptionShort" GroupByExpression="DescriptionShort DescriptionShort GROUP BY DescriptionShort">
                        <EditItemTemplate>
                            <telerik:RadTextBox runat="server" ID="DescriptionShort" Text='<%# Bind("DescriptionShort") %>' Width="300px"></telerik:RadTextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" ID="LabelDescriptionShort" Text='<%# Eval("DescriptionShort") %>'></asp:Label>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

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

                <NestedViewSettings DataSourceID="SqlDataSource_FirstAiderDetails">
                    <ParentTableRelation>
                        <telerik:GridRelationFields DetailKeyField="FirstAiderID" MasterKeyField="FirstAiderID"></telerik:GridRelationFields>
                    </ParentTableRelation>
                </NestedViewSettings>

                <NestedViewTemplate>
                    <fieldset style="padding: 10px; width: 500px; margin-left: 10px; margin-bottom: 10px;">
                        <legend style="padding: 5px; background-color: transparent;">
                            <b><%= Resources.Resource.lblDetailsFor %> <%= Resources.Resource.lblMaxPresent %>: <%#Eval("MaxPresent") %></b>
                        </legend>
                        <table style="width: 100%;">
                            <tr>
                                <td><%= Resources.Resource.lblID %>: </td>
                                <td>
                                    <asp:Label Text='<%#Eval("FirstAiderID") %>' runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td><%= Resources.Resource.lblMaxPresent %>: </td>
                                <td>
                                    <asp:Label Text='<%#Eval("MaxPresent") %>' runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td><%= Resources.Resource.lblMinAiders %>: </td>
                                <td>
                                    <asp:Label Text='<%#Eval("MinAiders") %>' runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td><%= Resources.Resource.lblDescriptionShort %>: </td>
                                <td>
                                    <asp:Label Text='<%#Eval("DescriptionShort") %>' runat="server" Width="300px"></asp:Label>
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
                </NestedViewTemplate>

            </MasterTableView>
        </telerik:RadGrid>
    </div>

    <asp:SqlDataSource ID="SqlDataSource_FirstAiders" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>" OnInserted="SqlDataSource_Inserted"
                       OldValuesParameterFormatString="original_{0}"
                       DeleteCommand="INSERT INTO History_FirstAiders SELECT * FROM Master_FirstAiders WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [FirstAiderID] = @original_FirstAiderID; 
                       DELETE FROM [Master_FirstAiders] WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [FirstAiderID] = @original_FirstAiderID" 
                       InsertCommand="INSERT INTO [Master_FirstAiders] ([SystemID], [BpID], [MaxPresent], [MinAiders], [DescriptionShort], [CreatedFrom], [CreatedOn], [EditFrom], [EditOn]) VALUES (@SystemID, @BpID, @MaxPresent, @MinAiders, @DescriptionShort, @UserName, SYSDATETIME(), @UserName, SYSDATETIME()) 
                       SELECT @ReturnValue = SCOPE_IDENTITY()" 
                       SelectCommand="SELECT * FROM [Master_FirstAiders] WHERE (([SystemID] = @SystemID) AND ([BpID] = @BpID)) ORDER BY [MaxPresent]" 
                       UpdateCommand="INSERT INTO History_FirstAiders SELECT * FROM Master_FirstAiders WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [FirstAiderID] = @original_FirstAiderID; 
                       UPDATE [Master_FirstAiders] SET [MaxPresent] = @MaxPresent, [MinAiders] = @MinAiders, [DescriptionShort] = @DescriptionShort, [EditFrom] = @UserName, [EditOn] = SYSDATETIME() WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [FirstAiderID] = @original_FirstAiderID">
        <DeleteParameters>
            <asp:Parameter Name="original_SystemID" Type="Int32" />
            <asp:Parameter Name="original_BpID" Type="Int32" />
            <asp:Parameter Name="original_FirstAiderID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
            <asp:Parameter Name="MaxPresent" Type="Int32" />
            <asp:Parameter Name="MinAiders" Type="Int32" />
            <asp:Parameter Name="DescriptionShort" Type="String" />
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
            <asp:Parameter Direction="Output" Name="ReturnValue" Type="Int32" />
        </InsertParameters>
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="MaxPresent" Type="Int32" />
            <asp:Parameter Name="MinAiders" Type="Int32" />
            <asp:Parameter Name="DescriptionShort" Type="String" />
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
            <asp:Parameter Name="original_SystemID" Type="Int32" />
            <asp:Parameter Name="original_BpID" Type="Int32" />
            <asp:Parameter Name="original_FirstAiderID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_FirstAiderDetails" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>" 
                       SelectCommand="SELECT * FROM [Master_FirstAiders] WHERE (([SystemID] = @SystemID) AND ([BpID] = @BpID) AND FirstAiderID = @FirstAiderID)" >
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
            <asp:Parameter Name="FirstAiderID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
