<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TranslationsToolTip.ascx.cs" Inherits="InSite.App.Controls.TranslationsToolTip" %>
<asp:FormView ID="TranslationToolTip" DataSourceID="SqlDataSource_Details" DataKeyNames="SystemID,BpID,DialogID,FieldID,LanguageID" runat="server" BackColor="Transparent" BorderColor="Transparent" OnDataBound="DialogToolTip_DataBound">
    <ItemTemplate>
        <fieldset style="padding: 10px; width: 500px; margin-left: 10px; margin-bottom: 10px;">
            <legend style="padding: 5px; background-color: transparent;"><b><%= Resources.Resource.lblDetailsFor %> <%#Eval("LanguageID") %></b>
            </legend>
            <table style="width: 100%;">
                <tr>
                    <td>
                        <asp:HiddenField runat="server" ID="FlagName" Value='<%#Eval("FlagName") %>' />
                        <asp:Image ID="ItemImage" runat="server" />
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblLanguage %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("LanguageID") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblNameVisible %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("NameTranslated") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblDescriptionShort %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("DescriptionTranslated") %>' runat="server" Width="400px"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblCreatedFrom %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("CreatedFrom") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblCreatedOn %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("CreatedOn") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblEditFrom %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("EditFrom") %>' runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td><%= Resources.Resource.lblEditOn %>:
                    </td>
                    <td>
                        <asp:Label Text='<%#Eval("EditOn") %>' runat="server"></asp:Label>
                    </td>
                </tr>
            </table>
        </fieldset>
    </ItemTemplate>
</asp:FormView>

<asp:SqlDataSource ID="SqlDataSource_Details" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
    SelectCommand="SELECT Master_Translations.SystemID, Master_Translations.BpID, Master_Translations.DialogID, Master_Translations.FieldID, Master_Translations.LanguageID, Master_Translations.NameTranslated, Master_Translations.DescriptionTranslated, Master_Translations.CreatedFrom, Master_Translations.CreatedOn, Master_Translations.EditFrom, Master_Translations.EditOn, View_Languages.LanguageName, View_Languages.FlagName FROM Master_Translations INNER JOIN Master_AllowedLanguages ON Master_Translations.SystemID = Master_AllowedLanguages.SystemID AND Master_Translations.BpID = Master_AllowedLanguages.BpID AND Master_Translations.LanguageID = Master_AllowedLanguages.LanguageID INNER JOIN View_Languages ON Master_AllowedLanguages.LanguageID = View_Languages.LanguageID WHERE (Master_Translations.SystemID = @SystemID) AND (Master_Translations.BpID = @BpID) AND (Master_Translations.DialogID = @DialogID) AND (Master_Translations.FieldID = @FieldID) AND (Master_Translations.LanguageID = @LanguageID)">
    <SelectParameters>
        <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
        <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
        <asp:Parameter Name="DialogID" Type="Int32" />
        <asp:Parameter Name="FieldID" Type="Int32" />
        <asp:Parameter Name="LanguageID" Type="String" />
    </SelectParameters>
</asp:SqlDataSource>
