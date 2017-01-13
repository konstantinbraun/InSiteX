<%@ Page Title="<%$ Resources:Resource, lblLogin %>" Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="InSite.App.Views.Login" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

    <head runat="server" id="LoginHead">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link href="~/Styles/DefaultStyleSheet.css" rel="stylesheet" type="text/css" />
        <link rel="shortcut icon" href="~/Resources/Images/favicon.ico" />

        <title></title>

        <telerik:RadScriptBlock runat="server">
            <script type="text/javascript">
                var isDoubleClick = false;
                var clickHandler = null;
                var clickedDataKey = null;

                function RowClick(sender, args) {
                    clickedDataKey = args._dataKeyValues.BpID;
                    isDoubleClick = false;
                    if (clickHandler) {
                        window.clearTimeout(clickHandler);
                        clickHandler = null;
                    }
                    clickHandler = window.setTimeout(ActualClick(sender, args), 400);
                }

                function RowDblClick(sender, args) {
                    isDoubleClick = true;
                    if (clickHandler) {
                        window.clearTimeout(clickHandler);
                        clickHandler = null;
                    }
                    clickHandler = window.setTimeout(ActualClick(sender, args), 400);
                }

                function ActualClick(sender, args) {
                    var grid = $find("<%= RadGridBpSelect.ClientID %>");
                    var masterTable = grid.get_masterTableView();
                    var rows = masterTable.get_dataItems();
                    if (grid) {
                        for (var i = 0; i < rows.length; i++) {
                            var row = rows[i];
                            if (clickedDataKey !== null && clickedDataKey === row.getDataKeyValue("BpID")) {
                                if (isDoubleClick) {
                                    $find("<%= BtnSelect.ClientID %>").click(sender, args);
                                } else {
                                    masterTable.fireCommand("RowClick", clickedDataKey);
                                }
                            }
                        }
                    }
                }

                function OnClientKeyPressing(sender, args) {
                    sender.showDropDown();
                }
            </script>
        </telerik:RadScriptBlock>

    </head>

    <body>
        <form id="form1" runat="server" autocomplete="off">
            <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
            </telerik:RadScriptManager>

            <telerik:RadFormDecorator ID="FormDecorator1" runat="server" EnableRoundedCorners="true" DecoratedControls="All" Skin="Default"></telerik:RadFormDecorator>

            <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" >
                <AjaxSettings>
                    <telerik:AjaxSetting AjaxControlID="RadGridBpSelect">
                        <UpdatedControls>
                            <telerik:AjaxUpdatedControl ControlID="RadGridBpSelect" />
                        </UpdatedControls>
                    </telerik:AjaxSetting>
                    <telerik:AjaxSetting AjaxControlID="BpID">
                        <UpdatedControls>
                            <telerik:AjaxUpdatedControl ControlID="BpID" />
                        </UpdatedControls>
                    </telerik:AjaxSetting>
                    <telerik:AjaxSetting AjaxControlID="BpID">
                        <UpdatedControls>
                            <telerik:AjaxUpdatedControl ControlID="CompanyID" />
                        </UpdatedControls>
                    </telerik:AjaxSetting>
                </AjaxSettings>
            </telerik:RadAjaxManager>

            <telerik:RadWindow runat="server" ID="RadWindowPopUp" DestroyOnClose="false" InitialBehaviors="Resize,Close,Reload,Move" Behaviors="Resize,Close,Reload,Move" 
                               AutoSize="true" AutoSizeBehaviors="Height,Width" ReloadOnShow="true" ShowContentDuringLoad="false">
            </telerik:RadWindow>

            <div style="margin: 0 auto; _margin: auto; margin-top: 20px; text-align: center; width: 960px; _width: 100%;" class="PanelShadow">
                <div style="border: 0px solid #ff0000; width: 960px; padding: 0px 0 0 0px; border-radius: 5px;">
                    <div style="text-align: left; border-radius: 5px;">
<%--                        <div style="width: 960px; padding-bottom: 5px; height: 56px; border-top-left-radius: 5px; border-top-right-radius: 5px;" class="Gradient">
                            <table style="width: 100%;">
                                <tr>
                                    <td>
                                        <img alt="Logo" src="/InSiteApp/Resources/Images/zeppelin_logo_transparent_150x56.png" />
                                    </td>
                                    <td style="vertical-align: middle; text-align: center;">
                                        <asp:Label runat="server" ID="PageTitle" Style="font-size: 16px; font-weight: bold;">
                                        </asp:Label>
                                    </td>
                                    <td style="text-align: right; padding-right: 15px;">
                                        <asp:Label runat="server" Text="<%$ Resources:Resource, appName %>" Font-Bold="true" ForeColor="#5D686D" style="font-size: large">
                                        </asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </div>--%>
                        <div style="padding: 10px 0px 0px 20px;">
                            <img alt="Logo" src="/InSiteApp/Resources/Images/zeppelin_logo_transparent_150x56.png" />
                        </div>
                        <div>
                            <img src="../Resources/Images/Header.png" />
                        </div>

                        <%-- ################## Login ################# --%>
                        <asp:Panel ID="LoginPanel" runat="server" DefaultButton="BtnLogin">
                            <table style="padding: 5px; vertical-align: top; width: 100%;">
                                <tr>
                                    <td valign="top">
                                        <table style="padding: 5px; vertical-align: top;">
                                            <tr>
                                                <td style="width: 24px; padding-right: 10px;">
                                                    <img src="../Resources/Icons/log_in.png" />
                                                </td>
                                                <td colspan="2">
                                                    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:Resource, lblLogin %>" Style="font-size: 16px; font-weight: bold;"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>

                                        <div style="border-style: none; border-color: lightgray; border-width: 1px; border-radius: 5px; padding: 5px; background-color: #EEEEEE">
                                            <table>
                                                <tr>
                                                    <td colspan="3">
                                                        <asp:Label ID="Label4" runat="server" Text="<%$ Resources:Resource, msgWelcome %>" Font-Bold="true"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3">&nbsp; </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <asp:Label ID="Label1" runat="server" Text="<%$ Resources:Resource, lblUserName %>"></asp:Label>
                                                    </td>
                                                    <td nowrap="nowrap" style="text-align: right; padding-left: 5px;">
                                                        <asp:TextBox ID="UserName" runat="server" Width="170px" AutoCompleteType="Disabled"></asp:TextBox>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="UserName" ErrorMessage="<%$ Resources:Resource, msgUserNameObligate %>" Text="*"
                                                                                    SetFocusOnError="true" ForeColor="Red" ValidationGroup="Login">
                                                        </asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <asp:Label ID="Label2" runat="server" Text="<%$ Resources:Resource, lblPassword %>"></asp:Label>
                                                    </td>
                                                    <td nowrap="nowrap" style="text-align: right; padding-left: 5px;">
                                                        <asp:TextBox ID="Password" runat="server" Width="170px" TextMode="Password" AutoCompleteType="Disabled" EnableEmbeddedBaseStylesheet="true" 
                                                                     EnableEmbeddedSkins="true"></asp:TextBox>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="Password" ErrorMessage="<%$ Resources:Resource, msgPasswordObligate %>" Text="*"
                                                                                    SetFocusOnError="true" ForeColor="Red" ValidationGroup="Login">
                                                        </asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">&nbsp; </td>
                                                    <td>
                                                        <asp:ValidationSummary runat="server" DisplayMode="BulletList" ShowMessageBox="true" ShowSummary="true" BorderStyle="None" ValidationGroup="Login" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3">
                                                        <telerik:RadButton ID="BtnLogin" runat="server" Text="<%$ Resources:Resource, lblLogin %>" OnClick="BtnLogin_Click" CausesValidation="true" ValidationGroup="Login" 
                                                                           Icon-PrimaryIconCssClass="rbOk" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <table>
                                            <tr>
                                                <td colspan="3" style="vertical-align: bottom;">
                                                    <br />
                                                    <br />
                                                    <br />
                                                    <br />
                                                    <br />
                                                    <br />
                                                    <br />
                                                    <br />
                                                    <br />
                                                    <br />
                                                    <br />
                                                    <telerik:RadButton ID="BtnResetPassword" runat="server" Text="<%$ Resources:Resource, lblForgotPassword %>" OnClick="BtnResetPassword_Click" 
                                                                       CausesValidation="false" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="width: 5px;"></td>
                                    <%--                                    <td style="border-color: #E6E6E6; width: 0px; border-width: 1px; border-left-style: solid;"></td>--%>
                                    <td style="width: 0px;"></td>
                                    <td valign="top">
                                        <table style="padding: 5px; vertical-align: top;">
                                            <tr>
                                                <td style="width: 24px; padding-right: 10px;">
                                                    <img src="../Resources/Icons/Contract.png" width="24px" height="24px" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="Label5" runat="server" Text="<%$ Resources:Resource, lblRegister %>" Style="font-size: 16px; font-weight: bold;"></asp:Label>
                                                </td>
                                                <td style="vertical-align: bottom; text-align: left; padding-top: 2px;">
                                                    <telerik:RadButton ID="GetHelp" runat="server" BorderStyle="None" BackColor="Transparent" ButtonType="SkinnedButton"
                                                                       OnClick="GetHelp_Click" CommandArgument="/Help/Beschreibung_Selbstregistrierung.htm" AutoPostBack="true" ToolTip="<%$ Resources:Resource, lblDialogHelp %>">
                                                        <ContentTemplate>
                                                            <asp:Image runat="server" ID="PageIcon" ImageUrl="~/Resources/Icons/Help_22.png" Height="22px" Width="22px" />
                                                        </ContentTemplate>
                                                    </telerik:RadButton>
                                                </td>
                                            </tr>
                                        </table>

                                        <div style="border-style: none; border-color: lightgray; border-width: 1px; border-radius: 5px; padding: 5px; background-color: #EEEEEE">
                                            <table>
                                                <tr>
                                                    <td colspan="2">
                                                        <asp:Label ID="Label6" runat="server" Text="<%$ Resources:Resource, msgRegisterCompany %>" Font-Bold="true"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">&nbsp; </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2" style="text-align: left;">
                                                        <telerik:RadButton ID="BtnRegisterCompany" runat="server" Text="<%$ Resources:Resource, lblRegisterCompany %>"
                                                                           PostBackUrl="~/Views/RegisterCompanyCentral.aspx" CausesValidation="false" Icon-PrimaryIconCssClass="rbEdit" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>

                                        <br />

                                        <div style="border-style: none; border-color: lightgray; border-width: 1px; border-radius: 5px; padding: 5px; background-color: #EEEEEE">
                                            <table style="width: 100%;">
                                                <tr>
                                                    <td colspan="2">
                                                        <asp:Label ID="Label12" runat="server" Text="<%$ Resources:Resource, msgRequestCompanyBp %>" Font-Bold="true"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">&nbsp; </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2" style="text-align: left;">
                                                        <telerik:RadButton ID="BtnRequestBp" runat="server" Text="<%$ Resources:Resource, lblRequestBp %>" 
                                                                           OnClick="BtnRequestBp_Click" CausesValidation="true" ValidationGroup="Login" Icon-PrimaryIconCssClass="rbEdit" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>

                                        <br />

                                        <div style="border-style: none; border-color: lightgray; border-width: 1px; border-radius: 5px; padding: 5px; background-color: #EEEEEE">
                                            <table width="100%">
                                                <tr>
                                                    <td colspan="3">
                                                        <asp:Label ID="Label8" runat="server" Text="<%$ Resources:Resource, msgRegisterEmployee %>" Font-Bold="true"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3">&nbsp; </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="Label7" runat="server" Text="<%$ Resources:Resource, lblRegistrationCode %>"></asp:Label>
                                                    </td>
                                                    <td nowrap="nowrap" style="text-align: right; padding-left: 5px;">
                                                        <asp:TextBox ID="RegistrationCode" runat="server" Width="174px" AutoCompleteType="Disabled"
                                                                     ToolTip="<%$ Resources:Resource, msgEnterRegCode %>">
                                                        </asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="RegistrationCode" ErrorMessage="<%$ Resources:Resource, msgCodeObligate %>" Text="*"
                                                                                    SetFocusOnError="true" ForeColor="Red" ValidationGroup="Register">
                                                        </asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3">
                                                        <asp:ValidationSummary runat="server" DisplayMode="BulletList" ShowMessageBox="true" ShowSummary="true" BorderStyle="None" ValidationGroup="Register" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3">&nbsp; </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3" style="text-align: left;">
                                                        <telerik:RadButton ID="BtnRegisterEmployee" runat="server" Width="170px" Text="<%$ Resources:Resource, lblRegisterEmployee %>"
                                                                           CausesValidation="true" OnClick="BtnRegisterEmployee_Click" Icon-PrimaryIconCssClass="rbEdit" ValidationGroup="Register" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>

                                    </td>
                                    <td style="float: right; border-radius: 5px; margin-left: -20px; margin-top: 10px; margin-bottom: 10px;">
                                        <img src="../Resources/Images/Speedy_3_transparent_300.png" style="float: right; border-radius: 5px;" />
                                    </td>
                                </tr>
                            </table>

                        </asp:Panel>

                        <%-- ################## Auswahl Bauvorhaben ################# --%>
                        <asp:Panel runat="server" ID="PanelBpSelect" Visible="false" CssClass="PanelShadow" Height="100%" DefaultButton="BtnSelect">
                            <div style="border-radius: 10px; padding: 5px;">
                                <table style="padding: 5px;">
                                    <tr>
                                        <td style="width: 24px;">
                                            <img src="../Resources/Icons/applications-development-5.png" width="24" height="24" />
                                        </td>
                                        <td valign="baseline">
                                            <asp:Label runat="server" Text="<%$ Resources:Resource, lblBpSelect%>" Font-Bold="true" Font-Size="Large">
                                            </asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">&nbsp; </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <telerik:RadGrid ID="RadGridBpSelect" runat="server" AllowPaging="True" AllowSorting="True" EnableHeaderContextFilterMenu="True" 
                                                             EnableHeaderContextMenu="True" BorderStyle="None" TabIndex="1"
                                                             OnNeedDataSource="RadGridBpSelect_NeedDataSource"
                                                             OnItemDataBound="RadGridBpSelect_ItemDataBound">

                                                <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="true">
                                                    <Resizing AllowColumnResize="true"></Resizing>
                                                    <Selecting AllowRowSelect="True" />
<%--                                                    <ClientEvents OnRowDblClick="RowDblClick" OnRowClick="RowClick" />--%>
                                                </ClientSettings>

                                                <SortingSettings SortedBackColor="Transparent" />

                                                <MasterTableView EnableHierarchyExpandAll="true" EditMode="PopUp" AutoGenerateColumns="False" DataKeyNames="BpID" ShowHeader="true" 
                                                                 CssClass="MasterClass" ClientDataKeyNames="BpID"
                                                                 CommandItemDisplay="None" AllowMultiColumnSorting="true" PageSize="50" Caption="<%$ Resources:Resource, msgPleaseSelect %>">

                                                    <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" PageSizes="15,25,50,100" />

                                                    <HeaderStyle Font-Bold="true" />

                                                    <Columns>
                                                        <telerik:GridBoundColumn DataField="BpName" HeaderText="<%$ Resources:Resource, lblBuildingProject %>" SortExpression="BpName" UniqueName="BpName"
                                                                                    GroupByExpression="BpName BpName GROUP BY BpName">
                                                        </telerik:GridBoundColumn>

                                                        <telerik:GridBoundColumn DataField="BpDescription" FilterControlAltText="Filter BpDescription column" HeaderText="<%$ Resources:Resource, lblDescriptionShort %>"
                                                                                    SortExpression="BpDescription" UniqueName="BpDescription" GroupByExpression="BpDescription BpDescription GROUP BY BpDescription">
                                                        </telerik:GridBoundColumn>

                                                        <telerik:GridBoundColumn DataField="BuilderName" HeaderText="<%$ Resources:Resource, lblBuilderName %>" SortExpression="BuilderName" UniqueName="BuilderName"
                                                                                    GroupByExpression="BuilderName BuilderName GROUP BY BuilderName">
                                                        </telerik:GridBoundColumn>

                                                        <telerik:GridBoundColumn DataField="BpID" DataType="System.Int32" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter BpID column" 
                                                                                    HeaderText="<%$ Resources:Resource, lblID %>" SortExpression="BpID" UniqueName="BpID" Visible="true" HeaderStyle-HorizontalAlign="Right"
                                                                                    ItemStyle-HorizontalAlign="Right" AllowFiltering="false" HeaderStyle-Width="50px" ItemStyle-Width="50px">
                                                        </telerik:GridBoundColumn>

                                                        <telerik:GridBoundColumn DataField="RoleName" HeaderText="<%$ Resources:Resource, lblRole %>" SortExpression="RoleName" UniqueName="RoleName"
                                                                                    GroupByExpression="RoleName RoleName GROUP BY RoleName">
                                                        </telerik:GridBoundColumn>

                                                    </Columns>

                                                    <SortExpressions>
                                                        <telerik:GridSortExpression FieldName="BpName" SortOrder="Ascending"></telerik:GridSortExpression>
                                                        <telerik:GridSortExpression FieldName="BpDescription" SortOrder="Ascending"></telerik:GridSortExpression>
                                                    </SortExpressions>
                                                </MasterTableView>

                                            </telerik:RadGrid>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">&nbsp; </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right" colspan="2">
                                            <telerik:RadButton runat="server" Text="<%$ Resources:Resource, lblCancel %>" ID="BtnCancel2" OnClick="BtnCancel_Click" CausesValidation="false"
                                                               Icon-PrimaryIconCssClass="rbCancel" />
                                            <telerik:RadButton ID="BtnSelect" runat="server" Text="<%$ Resources:Resource, lblActionSelect %>" OnClick="BtnSelect_Click" Icon-PrimaryIconCssClass="rbOk"
                                                               ></telerik:RadButton>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </asp:Panel>

                        <%-- ################## Firma für Bauvorhaben registrieren ################# --%>
                        <asp:Panel runat="server" ID="PanelRegisterBp" Visible="false" CssClass="PanelShadow" DefaultButton="BtnRegisterBp">
                            <div style="border-radius: 10px; padding: 5px;">
                                <table cellpadding="3px" cellspacing="3px" style="padding: 5px;">
                                    <tr>
                                        <td style="width: 24px;">
                                            <img src="../Resources/Icons/applications-development-5.png" width="24px" height="24px" />
                                        </td>
                                        <td valign="baseline">
                                            <asp:Label runat="server" Text="<%$ Resources:Resource, lblRequestBp%>" Font-Bold="true" Font-Size="Large">
                                            </asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap">
                                            <asp:Label runat="server" ID="Label9" Text='<%$ Resources:Resource, lblCompany %>'></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="CompanyName"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap">
                                            <asp:Label runat="server" ID="Label10" Text='<%$ Resources:Resource, lblBuildingProject %>'></asp:Label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <telerik:RadComboBox runat="server" ID="BpID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                                                 DataValueField="BpID" DataTextField="NameVisible" Width="300" OnSelectedIndexChanged="BpID_SelectedIndexChanged"
                                                                 AppendDataBoundItems="true" Filter="Contains" AutoPostBack="true" DropDownAutoWidth="Enabled"
                                                                 OnClientKeyPressing="OnClientKeyPressing">
                                            </telerik:RadComboBox>
                                        </td>
                                        <td>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="BpID" ErrorMessage="<%$ Resources:Resource, msgBpObligate %>" Text="*"
                                                                        SetFocusOnError="true" ForeColor="Red" ValidationGroup="RegisterBp">
                                            </asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label11" Text='<%$ Resources:Resource, lblClient %>'></asp:Label>
                                        </td>
                                        <td>
                                            <telerik:RadComboBox runat="server" ID="CompanyID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                                                 DataValueField="CompanyID" DataTextField="CompanyName" Width="300"
                                                                 AppendDataBoundItems="true" Filter="Contains" DropDownAutoWidth="Enabled" OnClientKeyPressing="OnClientKeyPressing">
                                                <Items>
                                                    <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0" />
                                                </Items>
                                            </telerik:RadComboBox>
                                        </td>
                                        <td>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="CompanyID" ErrorMessage="<%$ Resources:Resource, msgClientObligate %>" Text="*"
                                                                        SetFocusOnError="true" ForeColor="Red" ValidationGroup="RegisterBp">
                                            </asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td>
                                            <asp:ValidationSummary runat="server" DisplayMode="BulletList" ShowMessageBox="true" ShowSummary="true" BorderStyle="None"
                                                                   ValidationGroup="RegisterBp" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td>&nbsp; </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td style="text-align: right;" nowrap="nowrap">
                                            <telerik:RadButton runat="server" Text="<%$ Resources:Resource, lblCancel %>" ID="BtnCancel" OnClick="BtnCancel_Click" CausesValidation="false"
                                                               Icon-PrimaryIconCssClass="rbCancel" />
                                            <telerik:RadButton runat="server" Text="<%$ Resources:Resource, lblRegister %>" ID="BtnRegisterBp" OnClick="BtnRegisterBp_Click" ValidationGroup="RegisterBp"
                                                               Icon-PrimaryIconCssClass="rbOk" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </asp:Panel>

                        <%-- ################## Kennwort zurücksetzen ################# --%>
                        <asp:Panel runat="server" ID="PanelResetPassword" Visible="false" DefaultButton="BtnRequestNewPassword">
                            <div style="border-radius: 10px; padding: 5px;">
                                <table style="padding: 5px; width: 330px; vertical-align: top;">
                                    <tr>
                                        <td style="width: 24px;">
                                            <img src="../Resources/Icons/log_in.png" width="24px" height="24px" />
                                        </td>
                                        <td valign="baseline" colspan="2">
                                            <asp:Label runat="server" Text="<%$ Resources:Resource, lblResetPassword %>" Font-Bold="true" Font-Size="Large">
                                            </asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <asp:Label runat="server" Text="<%$ Resources:Resource, qstNewPassword %>">
                                            </asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">&nbsp; </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <asp:Label ID="Label13" runat="server" Text="<%$ Resources:Resource, lblUserName %>"></asp:Label>
                                        </td>
                                        <td nowrap="nowrap" style="text-align: left; padding-left: 5px;" colspan="1">
                                            <asp:TextBox ID="UserName1" runat="server" Width="170px" AutoCompleteType="Disabled"></asp:TextBox>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="UserName1" ErrorMessage="<%$ Resources:Resource, msgUserNameObligate %>" Text="*"
                                                                        SetFocusOnError="true" ForeColor="Red" ValidationGroup="ResetPWD"  Display="Dynamic" EnableClientScript="false" >
                                            </asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">&nbsp; </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                        <%= Resources.Resource.msgPleaseEnterCode %>
                                        </td>
                                        <td colspan="1">
                                            <telerik:RadCaptcha ID="CaptchaRequestNewPassword" runat="server" ValidationGroup="ResetPWD" CaptchaTextBoxLabel="" EnableRefreshImage="true"
                                                                CaptchaLinkButtonText="<%$ Resources:Resource, lblNewCode %>" ErrorMessage="<%$ Resources:Resource, msgCodeWrong %>"
                                                                CaptchaAudioLinkButtonText="<%$ Resources:Resource, lblGetAudioCode %>"
                                                                Display="Dynamic" EnableClientScript="false">
                                                <CaptchaImage TextLength="8" Width="300" ImageCssClass="imageClass" BackgroundColor="#005AA1" TextColor="White" BackgroundNoise="None"
                                                              LineNoise="Extreme" FontWarp="High" EnableCaptchaAudio="true" UseAudioFiles="true" TextChars="Numbers" />
                                            </telerik:RadCaptcha>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <asp:ValidationSummary runat="server" DisplayMode="BulletList" ShowMessageBox="true" ShowSummary="true" BorderStyle="None"
                                                                   ValidationGroup="ResetPWD" EnableClientScript="false" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">&nbsp; </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right; padding-right: 10px;" colspan="3">
                                            <telerik:RadButton runat="server" Text="<%$ Resources:Resource, lblCancel %>" ID="BtnCancel1" OnClick="BtnCancel_Click" CausesValidation="false"
                                                               Icon-PrimaryIconCssClass="rbCancel" />
                                            <telerik:RadButton runat="server" Text="<%$ Resources:Resource, lblRequestNewPassword %>" ID="BtnRequestNewPassword"
                                                               OnClick="BtnRequestNewPassword_Click" ValidationGroup="ResetPWD" CausesValidation="true" Icon-PrimaryIconCssClass="rbOk" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </asp:Panel>

                        <%-- ################## Neues Passwort eingeben ################# --%>
                        <asp:Panel runat="server" ID="PanelNewPassword" Visible="false" DefaultButton="BtnNewPassword">
                            <div style="border-radius: 10px; padding: 5px;">
                                <table style="padding: 5px; width: 500px">
                                    <tr>
                                        <td style="width: 24px;">
                                            <img src="../Resources/Icons/log_in.png" width="24px" height="24px" />
                                        </td>
                                        <td valign="baseline" colspan="2">
                                            <asp:Label runat="server" Text="<%$ Resources:Resource, lblNewPwd %>" Font-Bold="true" Font-Size="Large">
                                            </asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <asp:Label runat="server" Text="<%$ Resources:Resource, msgEnterNewPassword %>">
                                            </asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">&nbsp; </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <asp:Label runat="server" Text="<%$ Resources:Resource, lblNewPwd %>"></asp:Label>
                                        </td>
                                        <td style="text-align: left; vertical-align: bottom">
                                            <telerik:RadTextBox runat="server" ID="NewPwd" TextMode="Password" AutoCompleteType="Disabled" Width="250px">
                                                <PasswordStrengthSettings ShowIndicator="true" PreferredPasswordLength="6"
                                                                          RequiresUpperAndLowerCaseCharacters="false" TextStrengthDescriptions="<%$ Resources:Resource, lblTextStrengthDescriptions %>"
                                                                          IndicatorWidth="100px" />
                                            </telerik:RadTextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <asp:Label runat="server" Text="<%$ Resources:Resource, lblNewPwdRepeat %>"></asp:Label>
                                        </td>
                                        <td style="text-align: left; vertical-align: bottom">
                                            <telerik:RadTextBox runat="server" ID="NewPwdRepeat" TextMode="Password" AutoCompleteType="Disabled" Width="150px"></telerik:RadTextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <asp:ValidationSummary runat="server" DisplayMode="BulletList" ShowMessageBox="true" ShowSummary="true" BorderStyle="None"
                                                                   ValidationGroup="ResetPWD" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">&nbsp; </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right; padding-right: 10px;" colspan="3">
                                            <telerik:RadButton runat="server" Text="<%$ Resources:Resource, lblCancel %>" ID="RadButton1" OnClick="BtnCancel_Click" CausesValidation="false"
                                                               Icon-PrimaryIconCssClass="rbCancel" />
                                            <telerik:RadButton runat="server" Text="<%$ Resources:Resource, lblOK %>" ID="BtnNewPassword"
                                                               OnClick="BtnNewPassword_Click" Icon-PrimaryIconCssClass="rbOk" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </asp:Panel>

                        <%-- ################## Liste der Ansprechpartner ################# --%>
                        <asp:Repeater ID="repContacts" runat="server">
                            <HeaderTemplate>
                                <div style="margin:10px;">
                                  <div style="margin:5px;"><asp:Label ID="Label19" runat="server" Text="<%$ Resources:Resource, lblContact %>" Font-Bold="true" Font-Size="16px"></asp:Label></div>
                            </HeaderTemplate>
                            <FooterTemplate>
                                </div>
                            </FooterTemplate>
                            <ItemTemplate>
                                <div class ="Gradient PaddingSmall">
                                    <asp:Label ID="Label15" runat="server" Text='<%#Eval("Key") %>' Font-Size="14px"></asp:Label>
                                </div>
                                <asp:Repeater ID="Repeater1" runat="server" DataSource ='<%#Eval("Value") %>'>
                                    <ItemTemplate>
                                        <div class ="PaddingSmall">
                                            <asp:Image ID="Image1" runat="server" ImageUrl ='<%#Eval("ImageUrl") %>' />
                                            <asp:Label ID="Label14" runat="server" Text='<%#Eval("FullName")%>' Font-Size ="14px"></asp:Label>
                                            <asp:Label ID="Label16" runat="server" Text='<%#Eval("Phone", "({0})") %>' ForeColor="#339966" Font-Size ="14px" ></asp:Label>
                                            <asp:Label ID="Label17" runat="server" Text='<%#Eval("Email") %>' ForeColor="#3366ff" Font-Size ="14px"></asp:Label>
                                            <asp:Label ID="Label18" runat="server" Text='<%#Eval("Comments") %>' ForeColor="#999999"></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <AlternatingItemTemplate>
                                        <div class ="PaddingSmall" style ="background-color:#eee">
                                            <asp:Image ID="Image1" runat="server" ImageUrl ='<%#Eval("ImageUrl") %>' />
                                            <asp:Label ID="Label14" runat="server" Text='<%#Eval("FullName")%>' Font-Size ="14px"></asp:Label>
                                            <asp:Label ID="Label16" runat="server" Text='<%#Eval("Phone", "({0})") %>' ForeColor="#339966" Font-Size ="14px" ></asp:Label>
                                            <asp:Label ID="Label17" runat="server" Text='<%#Eval("Email") %>' ForeColor="#3366ff" Font-Size ="14px"></asp:Label>
                                            <asp:Label ID="Label18" runat="server" Text='<%#Eval("Comments") %>'  ForeColor="#666666"></asp:Label>
                                        </div>
                                    </AlternatingItemTemplate>
                                </asp:Repeater>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>

            <asp:UpdatePanel runat="server" ID="PanelNotification" UpdateMode="Conditional">
                <ContentTemplate>
                    <telerik:RadNotification ID="Notification" runat="server" TitleIcon="~/Resources/Icons/TitleIcon.png" Animation="Fade" OffsetY="100"
                                             AutoCloseDelay="7000" EnableRoundedCorners="True" EnableShadow="True" Position="Center" VisibleOnPageLoad="False"
                                             CloseButtonToolTip="<%$ Resources:Resource, lblActionClose %>" ContentIcon="info" KeepOnMouseOver="true" Style="z-index: 100000">
                    </telerik:RadNotification>
                </ContentTemplate>
            </asp:UpdatePanel>
        </form>
    </body>
</html>
