<%@ Page Title="<%$ Resources:Resource, lblChangeLanguage %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Languages.aspx.cs" Inherits="InSite.App.Views.Costumization.Languages" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server">
    </telerik:RadAjaxManagerProxy>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <div style="border-radius: 10px; border-style: solid; border-width: 1px; border-color: ActiveBorder; padding: 5px; ">
        <table cellpadding="3px">
            <tr>
                <td>
                    <telerik:RadDropDownList ID="RadDropDownList1" runat="server" AutoPostBack="true" DataSourceID="SqlDataSource_Languages" DataTextField="LanguageName" 
                        DataValueField="LanguageID" DropDownHeight="400px" EnableVirtualScrolling="True" DropDownWidth="300px" Width="300px" OnDataBound="RadDropDownList1_DataBound" 
                        OnItemDataBound="RadDropDownList1_ItemDataBound" OnItemSelected="RadDropDownList1_ItemSelected">
                        <ItemTemplate>
                            <table>
                                <tr>
                                    <td style="text-align: left;">
                                        <asp:Label ID="ItemName" Text='<%# Eval("LanguageID") %>' runat="server" Width="20px">
                                        </asp:Label>
                                    </td>
                                    <td style="text-align: left;">
                                        <asp:Label ID="ItemDescr" Text='<%# Eval("LanguageName") %>' runat="server">
                                        </asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </ItemTemplate>
                    </telerik:RadDropDownList>
                    <asp:SqlDataSource ID="SqlDataSource_Languages" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>" 
                        SelectCommand="SELECT View_Languages.LanguageID, View_Languages.LanguageName, View_Languages.FlagName, Master_AllowedLanguages.SystemID, Master_AllowedLanguages.BpID FROM View_Languages INNER JOIN Master_AllowedLanguages ON View_Languages.LanguageID = Master_AllowedLanguages.LanguageID WHERE (Master_AllowedLanguages.SystemID = @SystemID) AND (Master_AllowedLanguages.BpID = CASE WHEN @BpID = 0 THEN Master_AllowedLanguages.BpID ELSE @BpID END) ORDER BY View_Languages.LanguageName">
                        <SelectParameters>
                            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
                            <asp:SessionParameter DefaultValue="-1" Name="BpID" SessionField="BpID" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </td>
            </tr>
            <tr>
                <td>&nbsp;
                </td>
            </tr>
            <tr>
                <td style="text-align: right;">
                    <asp:Button runat="server" Text="<%$ Resources:Resource, lblCancel %>" ID="btnCancel" OnClick="btnCancel_Click" />
                    <asp:Button runat="server" Text="<%$ Resources:Resource, lblOK %>" ID="btnOK" OnClick="btnOK_Click" />
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
