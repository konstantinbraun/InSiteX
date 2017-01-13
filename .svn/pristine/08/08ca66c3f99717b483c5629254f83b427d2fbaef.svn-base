<%@ Page Title="<%$ Resources:Resource, lblAllowedLanguages %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AllowedLanguages.aspx.cs" Inherits="InSite.App.Views.Configuration.AllowedLanguages" %>

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
        <telerik:RadGrid ID="RadGrid1" runat="server" AllowAutomaticDeletes="true" DataSourceID="SqlDataSource_AllowedLanguages" EnableLinqExpressions="false" AllowPaging="true"
                         CellSpacing="0" GridLines="None" CssClass="MainGrid" EnableAjaxSkinRendering="true" AllowAutomaticInserts="true" EnableHierarchyExpandAll="true" AllowSorting="true"
                         OnItemInserted="RadGrid1_ItemInserted" OnPreRender="RadGrid1_PreRender" OnItemCreated="RadGrid1_ItemCreated"
                         OnItemDeleted="RadGrid1_ItemDeleted" OnItemUpdated="RadGrid1_ItemUpdated" OnItemCommand="RadGrid1_ItemCommand" OnGroupsChanging="RadGrid1_GroupsChanging">

            <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false">
                <Resizing AllowColumnResize="true"></Resizing>
                <Selecting AllowRowSelect="True" />
                <ClientEvents OnRowClick="OnRowClick" OnGridCreated="OnGridCreated" OnKeyPress="GridKeyPress" />
            </ClientSettings>

        <SortingSettings SortedBackColor="Transparent" />

            <MasterTableView Name="AllowedLanguages" EnableHierarchyExpandAll="true" HierarchyLoadMode="ServerOnDemand" CssClass="MasterClass" EditMode="PopUp" AutoGenerateColumns="False"
                             DataKeyNames="SystemID,BpID,LanguageID"
                             DataSourceID="SqlDataSource_AllowedLanguages" CommandItemDisplay="Top" EnableHeaderContextMenu="true">

                <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

                <SortExpressions>
                    <telerik:GridSortExpression FieldName="LanguageID" SortOrder="Ascending"></telerik:GridSortExpression>
                </SortExpressions>

                <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true"
                                     AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                <EditFormSettings CaptionDataField="LanguageName" CaptionFormatString="<%$ Resources:Resource, lblActionCreate %>">
                    <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                    <EditColumn ButtonType="ImageButton" UniqueName="EditCommandColumn1" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                    <FormTableStyle CellPadding="3" CellSpacing="3" />
                </EditFormSettings>

                <Columns>
                    <telerik:GridTemplateColumn DataField="LanguageID" HeaderText="<%$ Resources:Resource, lblID %>" SortExpression="LanguageID" UniqueName="LanguageID"
                                                GroupByExpression="LanguageID LanguageID GROUP BY LanguageID">
                        <InsertItemTemplate>
                            <telerik:RadComboBox runat="server" ID="LanguageID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataSourceID="SqlDataSource_Languages"
                                                 DataValueField="LanguageID" DataTextField="LanguageName" Width="300" Filter="Contains" SelectedValue='<%# Bind("LanguageID") %>'
                                                 AppendDataBoundItems="true" DropDownAutoWidth="Enabled">
                                <ItemTemplate>
                                    <table cellpadding="2px" style="text-align: left;">
                                        <tr>
                                            <td style="text-align: left;">
                                                <asp:Label ID="ItemName" Text='<%# Eval("LanguageID") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                            <td style="text-align: left;">
                                                <asp:Label ID="ItemDescr" Text='<%# Eval("LanguageName") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </ItemTemplate>
                            </telerik:RadComboBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label runat="server" ID="LanguageID" Text='<%# Eval("LanguageID") %>'></asp:Label>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn DataField="LanguageName" HeaderText="<%$ Resources:Resource, lblLanguage %>" SortExpression="LanguageName" UniqueName="LanguageName"
                                                GroupByExpression="LanguageName LanguageName GROUP BY LanguageName">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="LanguageName" Text='<%# Eval("LanguageName") %>'></asp:Label>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                <telerik:GridButtonColumn UniqueName="deleteColumn" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                          ConfirmDialogType="RadWindow"
                                          ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                    <ItemStyle BackColor="Control" />
                </telerik:GridButtonColumn>
                </Columns>

                <NestedViewSettings DataSourceID="SqlDataSource_AllowedLanguageDetails">
                    <ParentTableRelation>
                        <telerik:GridRelationFields DetailKeyField="LanguageID" MasterKeyField="LanguageID"></telerik:GridRelationFields>
                    </ParentTableRelation>
                </NestedViewSettings>

                <%-- AllowedLaguageDetails--%>
                <NestedViewTemplate>
                    <asp:Panel ID="NestedViewPanel" runat="server">
                        <div>
                            <fieldset style="padding: 5px;">
                                <legend style="padding: 5px;">
                                    <b><%= Resources.Resource.lblDetailsFor %> <%#Eval("LanguageName") %></b>
                                </legend>
                                <table>
                                    <tr>
                                        <td><%= Resources.Resource.lblBpID %>: </td>
                                        <td>
                                            <asp:Label Text='<%#Eval("LanguageID") %>' runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><%= Resources.Resource.lblLanguage %>: </td>
                                        <td>
                                            <asp:Label Text='<%#Eval("LanguageName") %>' runat="server"></asp:Label>
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

        <asp:Label ID="Label1" runat="server"></asp:Label>
    </div>

    <asp:SqlDataSource ID="SqlDataSource_AllowedLanguages" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>" OnInserted="SqlDataSource_Inserted"
                       OldValuesParameterFormatString="original_{0}"
                       DeleteCommand="INSERT INTO History_AllowedLanguages SELECT * FROM Master_AllowedLanguages WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [LanguageID] = @original_LanguageID; 
                       DELETE FROM Master_AllowedLanguages WHERE (SystemID = @original_SystemID) AND (BpID = @original_BpID) AND (LanguageID = @original_LanguageID)"
                       InsertCommand="INSERT INTO Master_AllowedLanguages(SystemID, BpID, LanguageID, [CreatedFrom], [CreatedOn], [EditFrom], [EditOn]) VALUES (@SystemID, @BpID, @LanguageID, @UserName, SYSDATETIME(), @UserName, SYSDATETIME()); 
                       EXEC CreateFieldsTranslations @SystemID, @BpID 
                       SELECT @ReturnValue = SCOPE_IDENTITY()"
                       SelectCommand="SELECT DISTINCT Master_AllowedLanguages.*, View_Languages.LanguageName, '' AS FlagName FROM Master_AllowedLanguages INNER JOIN View_Languages ON Master_AllowedLanguages.LanguageID = View_Languages.LanguageID WHERE (Master_AllowedLanguages.SystemID = @SystemID) AND (Master_AllowedLanguages.BpID = @BpID)">
        <DeleteParameters>
            <asp:SessionParameter DefaultValue="0" Name="original_SystemID" SessionField="SystemID" />
            <asp:SessionParameter DefaultValue="0" Name="original_BpID" SessionField="BpID" />
            <asp:Parameter Name="original_LanguageID" Type="String" />
        </DeleteParameters>
        <InsertParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" />
            <asp:Parameter Name="LanguageID" Type="String" />
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
            <asp:Parameter Direction="Output" Name="ReturnValue" Type="Int32" />
        </InsertParameters>
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_AllowedLanguageDetails" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT DISTINCT Master_AllowedLanguages.SystemID, Master_AllowedLanguages.BpID, Master_AllowedLanguages.LanguageID, Master_AllowedLanguages.CreatedFrom, Master_AllowedLanguages.CreatedOn, Master_AllowedLanguages.EditFrom, Master_AllowedLanguages.EditOn, View_Languages.LanguageName, '' AS FlagName FROM Master_AllowedLanguages INNER JOIN View_Languages ON Master_AllowedLanguages.LanguageID = View_Languages.LanguageID WHERE (Master_AllowedLanguages.SystemID = @SystemID) AND (Master_AllowedLanguages.BpID = @BpID) AND (Master_AllowedLanguages.LanguageID = @LanguageID)">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" />
            <asp:Parameter Name="LanguageID" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Languages" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT DISTINCT LanguageID, LanguageName, '' AS FlagName FROM View_Languages AS l1 WHERE (NOT EXISTS (SELECT 1 FROM Master_AllowedLanguages AS l2 WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (LanguageID = l1.LanguageID))) ORDER BY LanguageName">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
            <asp:SessionParameter DefaultValue="-1" Name="BpID" SessionField="BpID" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
