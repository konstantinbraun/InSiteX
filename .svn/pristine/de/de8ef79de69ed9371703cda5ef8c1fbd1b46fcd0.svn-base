<%@ Page Title="<%$ Resources:Resource, lblTranslations %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DialogsFields.aspx.cs" Inherits="InSite.App.Views.Configuration.DialogsFields" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <telerik:RadScriptBlock ID="RadCodeBlock1" runat="server">
        <script type="text/javascript">
            function OnSingleRowClick(sender, args) {
                if (editedRow !== null && hasChanges) {
                    if (confirm('<%= Resources.Resource.qstSaveChanges %>')) {
                        hasChanges = false;
                        sender.get_masterTableView().updateItem(editedRow);
                    } else {
                        hasChanges = false;
                        sender.get_masterTableView().cancelUpdate(editedRow);
                    }
                } else {
                    var _args = "Expand|" + args.get_tableView().get_id() + "|" + args.get_itemIndexHierarchical();
                    sender.get_masterTableView().fireCommand("RowClick", _args);
                }
            }
        </script>
    </telerik:RadScriptBlock>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">

    <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGrid1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <telerik:RadPersistenceManagerProxy ID="RadPersistenceManagerProxy1" runat="server">
        <PersistenceSettings>
            <telerik:PersistenceSetting ControlID="RadGrid1" />
        </PersistenceSettings>
    </telerik:RadPersistenceManagerProxy>

    <div>
        <telerik:RadGrid ID="RadGrid1" runat="server" AllowAutomaticUpdates="True" AllowPaging="true" AllowSorting="true"
                         CellSpacing="0" GridLines="None" CssClass="MainGrid" DataSourceID="SqlDataSource_Dialogs"
                         GroupPanel-Text="<%$ Resources:Resource, msgGroupPanel %>"
                         OnItemInserted="RadGrid1_ItemInserted" OnPreRender="RadGrid1_PreRender" OnItemDataBound="RadGrid1_ItemDataBound"
                         OnItemDeleted="RadGrid1_ItemDeleted" OnItemUpdated="RadGrid1_ItemUpdated" OnItemCreated="RadGrid1_ItemCreated"
                         OnDetailTableDataBind="RadGrid1_DetailTableDataBind" OnItemCommand="RadGrid1_ItemCommand" OnGroupsChanging="RadGrid1_GroupsChanging">

            <GroupingSettings ShowUnGroupButton="True" />

            <ExportSettings ExportOnlyData="True" IgnorePaging="True">
                <Pdf PaperSize="A4">
                </Pdf>
                <Excel Format="ExcelML" />
            </ExportSettings>

            <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false">
                <Resizing AllowColumnResize="true"></Resizing>
                <Selecting AllowRowSelect="True" />
                <ClientEvents OnRowClick="OnSingleRowClick" OnGridCreated="OnGridCreated" OnKeyPress="GridKeyPress" />
            </ClientSettings>

        <SortingSettings SortedBackColor="Transparent" />

            <MasterTableView Name="Dialogs" EnableHierarchyExpandAll="true" CssClass="MasterClass" EditMode="InPlace" AutoGenerateColumns="False" DataKeyNames="SystemID,DialogID"
                             DataSourceID="SqlDataSource_Dialogs" CommandItemDisplay="Top" ShowHeader="true" Caption="<%$ Resources:Resource, lblDialogs %>" PageSize="20"
                             HierarchyLoadMode="ServerOnDemand" CanRetrieveAllData="true">

                <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" Position="Bottom" />

                <SortExpressions>
                    <telerik:GridSortExpression FieldName="ResourceID" SortOrder="Ascending"></telerik:GridSortExpression>
                </SortExpressions>

                <EditFormSettings CaptionDataField="NameVisible" CaptionFormatString="{0}">
                    <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                    <EditColumn ButtonType="ImageButton" UniqueName="EditCommandColumn1" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                    <FormTableStyle CellPadding="3" CellSpacing="3" />
                </EditFormSettings>

                <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="False" ShowExportToCsvButton="True" ShowExportToExcelButton="True" ShowExportToPdfButton="True"
                                     AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                <DetailTables>
                    <telerik:GridTableView EnableHierarchyExpandAll="true" DataKeyNames="SystemID,DialogID,FieldID" DataSourceID="SqlDataSource_Fields" Width="100%"
                                           runat="server" CommandItemDisplay="None" Name="Fields" AutoGenerateColumns="false" ShowHeader="true" Caption="<%$ Resources:Resource, lblFields %>"
                                           AllowPaging="false" HierarchyLoadMode="ServerOnDemand">

                        <ParentTableRelation>
                            <telerik:GridRelationFields DetailKeyField="DialogID" MasterKeyField="DialogID"></telerik:GridRelationFields>
                        </ParentTableRelation>

                        <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

                        <SortExpressions>
                            <telerik:GridSortExpression FieldName="ResourceID" SortOrder="Ascending"></telerik:GridSortExpression>
                        </SortExpressions>

                        <EditFormSettings CaptionDataField="NameVisible" CaptionFormatString="{0}">
                            <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                            <EditColumn ButtonType="ImageButton" UniqueName="EditCommandColumn1" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                        UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                            <FormTableStyle CellPadding="3" CellSpacing="3" />
                        </EditFormSettings>

                        <DetailTables>
                            <telerik:GridTableView EnableHierarchyExpandAll="true" DataKeyNames="SystemID,BpID,DialogID,FieldID,LanguageID" DataSourceID="SqlDataSource_Translations" Width="100%"
                                                   runat="server" CommandItemDisplay="None" Name="Translations" AutoGenerateColumns="false" ShowHeader="true" Caption="<%$ Resources:Resource, lblTranslations %>"
                                                   AllowPaging="false" EditMode="PopUp" HierarchyLoadMode="ServerOnDemand">

                                <ParentTableRelation>
                                    <telerik:GridRelationFields DetailKeyField="DialogID" MasterKeyField="DialogID"></telerik:GridRelationFields>
                                    <telerik:GridRelationFields DetailKeyField="FieldID" MasterKeyField="FieldID"></telerik:GridRelationFields>
                                </ParentTableRelation>

                                <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

                                <SortExpressions>
                                    <telerik:GridSortExpression FieldName="LanguageName" SortOrder="Ascending"></telerik:GridSortExpression>
                                </SortExpressions>

                                <EditFormSettings CaptionDataField="LanguageName" CaptionFormatString="{0}">
                                    <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                                    <EditColumn ButtonType="ImageButton" UniqueName="EditCommandColumn1" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                                UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                                    <FormTableStyle CellPadding="3" CellSpacing="3" />
                                </EditFormSettings>

                                <NestedViewTemplate>
                                    <fieldset style="padding: 10px; width: 500px; margin-left: 10px; margin-bottom: 10px;">
                                        <legend style="padding: 5px; background-color: transparent;">
                                            <b><%= Resources.Resource.lblDetailsFor %> <%#Eval("LanguageName") %></b>
                                        </legend>
                                        <table style="width: 100%;">
                                            <tr>
                                                <td><%= Resources.Resource.lblLanguage %>: </td>
                                                <td>
                                                    <asp:Label Text='<%#Eval("LanguageID") %>' runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblNameVisible %>: </td>
                                                <td>
                                                    <asp:Label Text='<%#Eval("NameTranslated") %>' runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblDescriptionShort %>: </td>
                                                <td>
                                                    <asp:Label Text='<%#Eval("DescriptionTranslated") %>' runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblHtmlText %>: </td>
                                                <td>
                                                    <asp:Label Text='<%#Eval("HtmlTranslated") %>' runat="server"></asp:Label>
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

                                <Columns>
                <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                               UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                    <ItemStyle BackColor="Control" Width="30px" />
                    <HeaderStyle Width="30px" />
                </telerik:GridEditCommandColumn>

                                    <telerik:GridTemplateColumn DataField="LanguageName" HeaderText="<%$ Resources:Resource, lblLanguage %>" SortExpression="LanguageName" UniqueName="LanguageName"
                                                                GroupByExpression="LanguageName LanguageName GROUP BY LanguageName">
                                        <EditItemTemplate>
                                            <asp:Label runat="server" ID="LanguageName" Text='<%# Eval("LanguageName") %>'></asp:Label>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:Label runat="server" ID="LanguageName" Text='<%# Eval("LanguageName") %>'></asp:Label>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>

                                    <telerik:GridTemplateColumn DataField="NameTranslated" HeaderText="<%$ Resources:Resource, lblNameVisible %>" SortExpression="NameTranslated" UniqueName="NameTranslated"
                                                                GroupByExpression="NameTranslated NameTranslated GROUP BY NameTranslated">
                                        <EditItemTemplate>
                                            <telerik:RadTextBox runat="server" ID="NameTranslated" Text='<%# Bind("NameTranslated") %>'></telerik:RadTextBox>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:Label runat="server" ID="NameTranslated" Text='<%# Eval("NameTranslated") %>'></asp:Label>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>

                                    <telerik:GridTemplateColumn DataField="DescriptionTranslated" 
                                        HeaderText="<%$ Resources:Resource, lblDescriptionShort %>" 
                                        SortExpression="DescriptionTranslated" UniqueName="DescriptionTranslated"
                                                                GroupByExpression="DescriptionTranslated DescriptionTranslated GROUP BY DescriptionTranslated">
                                        <EditItemTemplate>
                                            <telerik:RadTextBox runat="server" ID="DescriptionTranslated" Text='<%# Bind("DescriptionTranslated") %>' Width="500px"></telerik:RadTextBox>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:Label runat="server" ID="DescriptionTranslated" Text='<%# Eval("DescriptionTranslated") %>'></asp:Label>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>

                                    <telerik:GridTemplateColumn DataField="HtmlTranslated" HeaderText="<%$ Resources:Resource, lblHtmlText %>" UniqueName="HtmlTranslated" Visible="true" >
                                        <EditItemTemplate>
                                            <asp:HiddenField runat="server" ID="FieldID" Value='<%# Eval("FieldID") %>' />
                                            <telerik:RadEditor runat="server" ID="HtmlTranslated" Content='<%# Bind("HtmlTranslated") %>' Skin="Office2010Silver">
                                                <Tools>
                                                    <telerik:EditorToolGroup Tag="MainToolbar">
                                                        <telerik:EditorTool Name="FindAndReplace"></telerik:EditorTool>
                                                        <telerik:EditorSeparator></telerik:EditorSeparator>
                                                        <telerik:EditorSplitButton Name="Undo"></telerik:EditorSplitButton>
                                                        <telerik:EditorSplitButton Name="Redo"></telerik:EditorSplitButton>
                                                        <telerik:EditorTool Name="SelectAll" ShortCut="CTRL+A / CMD+A"></telerik:EditorTool>
                                                        <telerik:EditorTool Name="Cut" ShortCut="CTRL+X / CMD+X"></telerik:EditorTool>
                                                        <telerik:EditorTool Name="Copy" ShortCut="CTRL+C / CMD+C"></telerik:EditorTool>
                                                        <telerik:EditorSeparator></telerik:EditorSeparator>
                                                        <telerik:EditorDropDown Name="InsertSnippet" Width="150px"></telerik:EditorDropDown>
                                                    </telerik:EditorToolGroup>
                                                    <telerik:EditorToolGroup Tag="Formatting">
                                                        <telerik:EditorTool Name="Bold"></telerik:EditorTool>
                                                        <telerik:EditorTool Name="Italic"></telerik:EditorTool>
                                                        <telerik:EditorTool Name="Underline"></telerik:EditorTool>
                                                        <telerik:EditorTool Name="StrikeThrough"></telerik:EditorTool>
                                                        <telerik:EditorSeparator></telerik:EditorSeparator>
                                                        <telerik:EditorSplitButton Name="ForeColor"></telerik:EditorSplitButton>
                                                        <telerik:EditorSplitButton Name="BackColor"></telerik:EditorSplitButton>
                                                        <telerik:EditorSeparator></telerik:EditorSeparator>
                                                        <telerik:EditorDropDown Name="FontName"></telerik:EditorDropDown>
                                                        <telerik:EditorDropDown Name="RealFontSize"></telerik:EditorDropDown>
                                                        <telerik:EditorSeparator></telerik:EditorSeparator>
                                                        <telerik:EditorTool Name="JustifyLeft"></telerik:EditorTool>
                                                        <telerik:EditorTool Name="JustifyCenter"></telerik:EditorTool>
                                                        <telerik:EditorTool Name="JustifyRight"></telerik:EditorTool>
                                                        <telerik:EditorTool Name="JustifyFull"></telerik:EditorTool>
                                                        <telerik:EditorTool Name="JustifyNone"></telerik:EditorTool>
                                                        <telerik:EditorSeparator></telerik:EditorSeparator>
                                                        <telerik:EditorTool Name="Indent"></telerik:EditorTool>
                                                        <telerik:EditorTool Name="Outdent"></telerik:EditorTool>
                                                        <telerik:EditorSeparator></telerik:EditorSeparator>
                                                        <telerik:EditorTool Name="InsertOrderedList"></telerik:EditorTool>
                                                        <telerik:EditorTool Name="InsertUnorderedList"></telerik:EditorTool>
                                                    </telerik:EditorToolGroup>
                                                </Tools>
                                                <Snippets>
                                                    <telerik:EditorSnippet Name="Firmenname" Value="##CompanyName##"></telerik:EditorSnippet>
                                                    <telerik:EditorSnippet Name="Zusatzbezeichnung" Value="##Description##"></telerik:EditorSnippet>
                                                    <telerik:EditorSnippet Name="Adresse 1" Value="##Address1##"></telerik:EditorSnippet>
                                                    <telerik:EditorSnippet Name="Adresse 2" Value="##Adresse2##"></telerik:EditorSnippet>
                                                    <telerik:EditorSnippet Name="PLZ" Value="##Zip##"></telerik:EditorSnippet>
                                                    <telerik:EditorSnippet Name="Ort" Value="##City##"></telerik:EditorSnippet>
                                                    <telerik:EditorSnippet Name="Staat / Bundesland" Value="##State##"></telerik:EditorSnippet>
                                                    <telerik:EditorSnippet Name="Land" Value="##Country##"></telerik:EditorSnippet>
                                                    <telerik:EditorSnippet Name="Telefon" Value="##Phone##"></telerik:EditorSnippet>
                                                    <telerik:EditorSnippet Name="Email" Value="##Email##"></telerik:EditorSnippet>
                                                    <telerik:EditorSnippet Name="WWW" Value="##WWW##"></telerik:EditorSnippet>
                                                    <telerik:EditorSnippet Name="Berufsgenossenschaft" Value="##TradeAssociation##"></telerik:EditorSnippet>
                                                    <telerik:EditorSnippet Name="Mitarbeiternummer" Value="##EmployeeID##"></telerik:EditorSnippet>
                                                    <telerik:EditorSnippet Name="Anrede" Value="##Salutation##"></telerik:EditorSnippet>
                                                    <telerik:EditorSnippet Name="Vorname" Value="##FirstName##"></telerik:EditorSnippet>
                                                    <telerik:EditorSnippet Name="Nachname" Value="##LastName##"></telerik:EditorSnippet>
                                                    <telerik:EditorSnippet Name="Sprache" Value="##LanguageName##"></telerik:EditorSnippet>
                                                    <telerik:EditorSnippet Name="Email Benutzer" Value="##EmailUser##"></telerik:EditorSnippet>
                                                    <telerik:EditorSnippet Name="Benutzername" Value="##LoginName##"></telerik:EditorSnippet>
                                                </Snippets>
                                            </telerik:RadEditor>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:Label runat="server" ID="HtmlTranslated" Text='<%# Tail(InSite.App.Helpers.HtmlToPlainText(Eval("HtmlTranslated").ToString()), 100) %>'></asp:Label>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>

                                    <telerik:GridTemplateColumn DataField="CreatedFrom" FilterControlAltText="Filter CreatedFrom column" HeaderText="<%$ Resources:Resource, lblCreatedFrom %>" 
                                        SortExpression="CreatedFrom" UniqueName="CreatedFrom" InsertVisiblityMode="AlwaysHidden" Visible="false">
                                        <EditItemTemplate>
                                            <asp:Label ID="CreatedFrom" runat="server" Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                                        </EditItemTemplate>
                                    </telerik:GridTemplateColumn>

                                    <telerik:GridTemplateColumn DataField="CreatedOn" FilterControlAltText="Filter CreatedOn column" HeaderText="<%$ Resources:Resource, lblCreatedOn %>" 
                                        SortExpression="CreatedOn" UniqueName="CreatedOn" InsertVisiblityMode="AlwaysHidden" Visible="false">
                                        <EditItemTemplate>
                                            <asp:Label ID="CreatedOn" runat="server" Text='<%# Eval("CreatedOn") %>'></asp:Label>
                                        </EditItemTemplate>
                                    </telerik:GridTemplateColumn>

                                    <telerik:GridTemplateColumn DataField="EditFrom" FilterControlAltText="Filter EditFrom column" HeaderText="<%$ Resources:Resource, lblEditFrom %>" 
                                        SortExpression="EditFrom" UniqueName="EditFrom" InsertVisiblityMode="AlwaysHidden" Visible="false">
                                        <EditItemTemplate>
                                            <asp:Label ID="EditFrom" runat="server" Text='<%# Eval("EditFrom") %>'></asp:Label>
                                        </EditItemTemplate>
                                    </telerik:GridTemplateColumn>

                                    <telerik:GridTemplateColumn DataField="EditOn" FilterControlAltText="Filter EditOn column" HeaderText="<%$ Resources:Resource, lblEditOn %>" 
                                        SortExpression="EditOn" UniqueName="EditOn" InsertVisiblityMode="AlwaysHidden" Visible="false">
                                        <EditItemTemplate>
                                            <asp:Label ID="EditOn" runat="server" Text='<%# Eval("EditOn") %>'></asp:Label>
                                        </EditItemTemplate>
                                    </telerik:GridTemplateColumn>
                                </Columns>
                            </telerik:GridTableView>
                        </DetailTables>

                        <Columns>
                            <telerik:GridTemplateColumn DataField="ResourceID" HeaderText="<%$ Resources:Resource, lblNameVisible %>" SortExpression="ResourceID" UniqueName="ResourceID"
                                                        GroupByExpression="ResourceID ResourceID GROUP BY ResourceID">
                                <ItemTemplate>
                                    <asp:Label runat="server" ID="NameVisible" Text=""></asp:Label>
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>

                            <telerik:GridTemplateColumn DataField="InternalName" HeaderText="<%$ Resources:Resource, lblInternalName %>" SortExpression="InternalName" UniqueName="InternalName"
                                                        GroupByExpression="InternalName InternalName GROUP BY InternalName">
                                <EditItemTemplate>
                                    <asp:Label runat="server" ID="InternalName" Text='<%# Bind("InternalName") %>'></asp:Label>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label runat="server" ID="InternalName" Text='<%# Bind("InternalName") %>'></asp:Label>
                                </ItemTemplate>
                            </telerik:GridTemplateColumn>
                        </Columns>
                    </telerik:GridTableView>
                </DetailTables>

                <Columns>
                    <telerik:GridTemplateColumn DataField="ResourceID" HeaderText="<%$ Resources:Resource, lblNameVisible %>" SortExpression="ResourceID" UniqueName="ResourceID"
                                                GroupByExpression="ResourceID ResourceID GROUP BY ResourceID">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="NameVisible" Text=""></asp:Label>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn DataField="DescriptionShort" FilterControlAltText="Filter DescriptionShort column" HeaderText="<%$ Resources:Resource, lblDescriptionShort %>"
                                                SortExpression="DescriptionShort" UniqueName="DescriptionShort" GroupByExpression="DescriptionShort DescriptionShort GROUP BY DescriptionShort">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="LabelDescriptionShort" Text='<%# Eval("DescriptionShort") %>'></asp:Label>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
    </div>

    <asp:SqlDataSource ID="SqlDataSource_Dialogs" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT * FROM System_Dialogs WHERE (SystemID = @SystemID) AND (UseFieldRights = 1 OR TranslationOnly = 1) ORDER BY NameVisible">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Fields" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT * FROM System_Fields WHERE (SystemID = @SystemID) AND (DialogID = @DialogID) ORDER BY InternalName">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:Parameter Name="DialogID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Translations" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
        OldValuesParameterFormatString="original_{0}"
        SelectCommand="SELECT Master_Translations.SystemID, Master_Translations.BpID, Master_Translations.DialogID, Master_Translations.FieldID, Master_Translations.LanguageID, Master_Translations.NameTranslated, Master_Translations.DescriptionTranslated, Master_Translations.CreatedFrom, Master_Translations.CreatedOn, Master_Translations.EditFrom, Master_Translations.EditOn, View_Languages.LanguageName, '' AS FlagName, Master_Translations.HtmlTranslated, System_Fields.HasVariables FROM Master_Translations INNER JOIN Master_AllowedLanguages ON Master_Translations.SystemID = Master_AllowedLanguages.SystemID AND Master_Translations.BpID = Master_AllowedLanguages.BpID AND Master_Translations.LanguageID = Master_AllowedLanguages.LanguageID INNER JOIN View_Languages ON Master_AllowedLanguages.LanguageID = View_Languages.LanguageID INNER JOIN System_Fields ON Master_Translations.SystemID = System_Fields.SystemID AND Master_Translations.DialogID = System_Fields.DialogID AND Master_Translations.FieldID = System_Fields.FieldID WHERE (Master_Translations.SystemID = @SystemID) AND (Master_Translations.BpID = @BpID) AND (Master_Translations.DialogID = @DialogID) AND (Master_Translations.FieldID = @FieldID) ORDER BY Master_Translations.LanguageID"
        UpdateCommand="INSERT INTO History_Translations SELECT * FROM Master_Translations WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND (DialogID = @original_DialogID) AND (FieldID = @original_FieldID) AND (LanguageID = @original_LanguageID); 
                       UPDATE Master_Translations SET NameTranslated = @NameTranslated, DescriptionTranslated = @DescriptionTranslated, HtmlTranslated = @HtmlTranslated, EditFrom = @UserName, EditOn = SYSDATETIME() WHERE (SystemID = @original_SystemID) AND (BpID = @original_BpID) AND (DialogID = @original_DialogID) AND (FieldID = @original_FieldID) AND (LanguageID = @original_LanguageID)">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
            <asp:Parameter Name="DialogID" Type="Int32" />
            <asp:Parameter Name="FieldID" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="NameTranslated" Type="String" />
            <asp:Parameter Name="DescriptionTranslated" Type="String" />
            <asp:Parameter Name="HtmlTranslated" Type="String" DefaultValue=""></asp:Parameter>
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
            <asp:Parameter Name="original_SystemID" Type="Int32" />
            <asp:Parameter Name="original_BpID" Type="Int32" />
            <asp:Parameter Name="original_DialogID" Type="Int32" />
            <asp:Parameter Name="original_FieldID" Type="Int32" />
            <asp:Parameter Name="original_LanguageID" Type="String" />
        </UpdateParameters>
    </asp:SqlDataSource>

</asp:Content>
