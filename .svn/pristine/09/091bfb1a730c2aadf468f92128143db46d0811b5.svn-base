<%@ Page Title="<%$ Resources:Resource, lblRegisterCompany %>" Language="C#" AutoEventWireup="true" CodeBehind="RegisterCompanyCentral.aspx.cs" Inherits="InSite.App.Views.RegisterCompanyCentral" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <link href="~/Styles/DefaultStyleSheet.css" rel="stylesheet" type="text/css" />
        <link rel="shortcut icon" href="~/Resources/Images/favicon.ico" />

        <title></title>

        <telerik:RadScriptBlock runat="server">
            <script type="text/javascript">
                function OnClientKeyPressing(sender, args) {
                    sender.showDropDown();
                }

                function ValidateCheckBox(sender, args) {
                    if (document.getElementById("<%=PrivacyStatementOptIn.ClientID %>").checked === true) {
                        args.IsValid = true;
                    } else {
                        args.IsValid = false;
                    }
                }
            </script>
        </telerik:RadScriptBlock>

    </head>

    <body>
        <form id="form1" runat="server" defaultbutton="BtnOK">
            <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
            </telerik:RadScriptManager>

            <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
                <AjaxSettings>
                    <telerik:AjaxSetting AjaxControlID="Email1">
                        <UpdatedControls>
                            <telerik:AjaxUpdatedControl ControlID="LoginName" />
                        </UpdatedControls>
                    </telerik:AjaxSetting>
                </AjaxSettings>
            </telerik:RadAjaxManager>

            <telerik:RadFormDecorator ID="FormDecorator1" runat="server" DecoratedControls="All" EnableRoundedCorners="true" Skin="Default"></telerik:RadFormDecorator>

            <telerik:RadWindow runat="server" ID="RadWindowPopUp" DestroyOnClose="false" InitialBehaviors="Resize,Close,Reload,Move" Behaviors="Resize,Close,Reload,Move" 
                               AutoSize="true" AutoSizeBehaviors="Height,Width" ReloadOnShow="true" ShowContentDuringLoad="false">
            </telerik:RadWindow>

            <div style="margin: 0 auto; _margin: auto; margin-top: 20px; text-align: center; width: 960px; _width: 100%;" class="PanelShadow">
                <div style="border: 0px solid #ff0000; width: 960px; padding: 8px 0 0 0px; border-radius: 5px;">
                    <div style="text-align: left; border-radius: 5px;">
                        <div style="width: 960px; margin-top: -10px; padding-bottom: 5px; height: 56px; border-top-left-radius: 5px; border-top-right-radius: 5px;" class="Gradient">
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
                        </div>

                            <fieldset runat="server" style="border: none; background: none; background-color: transparent;">
                                <table>
                                    <tr>
                                        <td style="padding-right: 10px;">
                                            <img src="../Resources/Icons/Contract.png" width="24" height="24" />
                                        </td>
                                        <td>
                                            <asp:Label runat="server" Text='<%$ Resources:Resource, lblRegisterCompany %>' Style="font-size: 16px; font-weight: bold; vertical-align: top;"></asp:Label>
                                        </td>
                                        <td style="vertical-align: bottom; text-align: left; padding-top: 2px;">
                                            <telerik:RadButton ID="GetHelp" runat="server" BorderStyle="None" BackColor="Transparent" ButtonType="SkinnedButton"
                                                               OnClick="GetHelp_Click" CommandArgument="/Help/Firmenbeauftragter.htm" AutoPostBack="true" ToolTip="<%$ Resources:Resource, lblDialogHelp %>">
                                                <ContentTemplate>
                                                    <asp:Image runat="server" ID="PageIcon" ImageUrl="~/Resources/Icons/Help_22.png" Height="22px" Width="22px" />
                                                </ContentTemplate>
                                            </telerik:RadButton>
                                        </td>
                                    </tr>
                                </table>
                                <table cellpadding="3px" style="vertical-align: top;" >
                                    <tr>
                                        <td style="vertical-align: top;">
                                            <table cellpadding="3px" >
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.lblNameVisible %>:</b>
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <telerik:RadTextBox ID="NameVisible"  runat="server" Width="280px"></telerik:RadTextBox>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="NameVisible" ErrorMessage="<%$ Resources:Resource, msgNameVisibleObligate %>" Text="*" 
                                                                                    SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                        </asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblNameAdditional %>: </td>
                                                    <td>
                                                        <telerik:RadTextBox ID="NameAdditional"  runat="server" Width="280px"></telerik:RadTextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp; </td>
                                                    <td>&nbsp; </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.lblAddress1 %>:</b>
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <telerik:RadTextBox ID="Address1" runat="server" Width="280px"></telerik:RadTextBox>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="Address1" ErrorMessage="<%$ Resources:Resource, msgAddress1Obligate %>" Text="*" 
                                                                                    SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                        </asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblAddress2 %>: </td>
                                                    <td>
                                                        <telerik:RadTextBox ID="Address2" runat="server" Width="280px"></telerik:RadTextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.lblAddrZip %>:</b>
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <telerik:RadTextBox ID="Zip" runat="server"></telerik:RadTextBox>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="Zip" ErrorMessage="<%$ Resources:Resource, msgZipObligate %>" Text="*" 
                                                                                    SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                        </asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.lblAddrCity %>:</b>
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <telerik:RadTextBox ID="City" runat="server" Width="280px"></telerik:RadTextBox>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="City" ErrorMessage="<%$ Resources:Resource, msgCityObligate %>" Text="*" 
                                                                                    SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                        </asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblAddrState %>: </td>
                                                    <td>
                                                        <telerik:RadTextBox ID="State" Text='<%# Bind("State") %>' runat="server" Width="280px"></telerik:RadTextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.lblCountry %>:</b>
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <telerik:RadComboBox runat="server" ID="CountryID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataSourceID="SqlDataSource_Countries"
                                                                             DataValueField="CountryID" DataTextField="CountryName" Width="280" Filter="Contains"
                                                                             AppendDataBoundItems="true" DropDownAutoWidth="Enabled" OnClientKeyPressing="OnClientKeyPressing">
                                                            <ItemTemplate>
                                                                <table cellpadding="5px" style="text-align: left;">
                                                                    <tr>
                                                                        <td style="background-color: #EFEFEF; text-align: left;">
                                                                            <asp:Image ID="ItemImage" ImageUrl='<%# String.Format("~/Resources/Icons/Flags/{0}", Eval("FlagName"))%>' runat="server" />
                                                                        </td>
                                                                        <td style="text-align: left;">
                                                                            <asp:Label ID="ItemName" Text='<%# Eval("CountryID") %>' runat="server">
                                                                            </asp:Label>
                                                                        </td>
                                                                        <td style="text-align: left;">
                                                                            <asp:Label ID="ItemDescr" Text='<%# Eval("CountryName") %>' runat="server">
                                                                            </asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ItemTemplate>
                                                            <Items>
                                                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                                                            </Items>
                                                        </telerik:RadComboBox>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="CountryID" ErrorMessage="<%$ Resources:Resource, msgCountryObligate %>" Text="*" 
                                                                                    SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                        </asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp; </td>
                                                    <td>&nbsp; </td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblAddrWWW %>: </td>
                                                    <td nowrap="nowrap">
                                                        <telerik:RadTextBox ID="WWW" runat="server" Width="280px"></telerik:RadTextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><%= Resources.Resource.lblTradeAssociation %>: </td>
                                                    <td nowrap="nowrap">
                                                        <telerik:RadTextBox ID="TradeAssociation" runat="server" Width="280px"></telerik:RadTextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.lblMinWageAttestation %>:</b>
                                                    </td>
                                                    <td>
                                                        <asp:CheckBox CssClass="cb" runat="server" ID="MinWageAttestation" Checked="true"></asp:CheckBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.lblTariffScope %>:</b>
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <telerik:RadComboBox runat="server" ID="TariffScopeID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                             DataSourceID="SqlDataSource_TariffScopes" DataValueField="TariffScopeID" DataTextField="Description" Width="280px" 
                                                                             Filter="Contains" AppendDataBoundItems="true" DropDownAutoWidth="Enabled" OnItemDataBound="TariffScopeID_ItemDataBound">
                                                            <ItemTemplate>
                                                                <table cellpadding="3px" style="text-align: left;">
                                                                    <tr>
                                                                        <td style="text-align: left;">
                                                                            <asp:Label ID="Label10" Text='<%# Eval("TariffNameVisible") %>' runat="server">
                                                                            </asp:Label>
                                                                        </td>
                                                                        <td style="text-align: left;">
                                                                            <asp:Label ID="Label11" Text='<%# Eval("ContractNameVisible") %>' runat="server">
                                                                            </asp:Label>
                                                                        </td>
                                                                        <td style="text-align: left;">
                                                                            <asp:Label ID="Label12" Text='<%# Eval("ValidFrom", "{0:d}") %>' runat="server">
                                                                            </asp:Label>
                                                                        </td>
                                                                        <td style="text-align: left;">
                                                                            <asp:Label ID="Label13" Text='<%# Eval("ValidTo", "{0:d}") %>' runat="server">
                                                                            </asp:Label>
                                                                        </td>
                                                                        <td style="text-align: left;">
                                                                            <asp:Label ID="ItemNameVisible" Text='<%# Eval("NameVisible") %>' runat="server">
                                                                            </asp:Label>
                                                                        </td>
                                                                        <td style="text-align: left;">
                                                                            <asp:Label ID="ItemDescriptionShort" Text='<%# Eval("DescriptionShort") %>' runat="server">
                                                                            </asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ItemTemplate>
                                                        </telerik:RadComboBox>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="TariffScopeID" ErrorMessage="<%$ Resources:Resource, msgTariffScopeIDObligate %>" Text="*" 
                                                                                    SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                        </asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.lblValidFrom %>:</b>
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <telerik:RadDatePicker ID="ValidFrom" runat="server" MinDate="<%# DateTime.Now %>" MaxDate="2100/1/1" EnableShadows="true"
                                                                               ShowPopupOnFocus="true" >
                                                            <Calendar runat="server">
                                                                <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                                                        TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                                                </FastNavigationSettings>
                                                            </Calendar>
                                                        </telerik:RadDatePicker>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="ValidFrom" ErrorMessage="<%$ Resources:Resource, msgValidFromObligate %>" Text="*" 
                                                                                    SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                        </asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td style="vertical-align: top;">
                                            <table cellpadding="3px" style="vertical-align: top; margin-top: -15px">
                                                <tr>
                                                    <td colspan="2">
                                                        <asp:Label runat="server" Text='<%$ Resources:Resource, lblUserAdminCompany %>' Font-Bold="true"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.lblAddrSalutation %>:</b>
                                                    </td>
                                                    <td>
                                                        <telerik:RadComboBox runat="server" ID="Salutation" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                             DataSourceID="SqlDataSource_Salutations" DataValueField="Salutation" DataTextField="Salutation" Width="280" 
                                                                             AppendDataBoundItems="true" Filter="Contains" AllowCustomText="false"
                                                                             DropDownAutoWidth="Enabled">
                                                        </telerik:RadComboBox>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="Salutation" ErrorMessage="<%$ Resources:Resource, msgSalutationObligate %>" Text="*" 
                                                                                    SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                        </asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.lblAddrFirstName %>:</b>
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <telerik:RadTextBox ID="FirstName"  runat="server" Width="280px"></telerik:RadTextBox>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="FirstName" ErrorMessage="<%$ Resources:Resource, msgFirstNameObligate %>" Text="*" 
                                                                                    SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                        </asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.lblAddrLastName %>:</b>
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <telerik:RadTextBox ID="LastName"  runat="server" Width="280px"></telerik:RadTextBox>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="LastName" ErrorMessage="<%$ Resources:Resource, msgLastNameObligate %>" Text="*" 
                                                                                    SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                        </asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.lblLanguage %>:</b>
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <telerik:RadComboBox runat="server" ID="LanguageID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataSourceID="SqlDataSource_Languages"
                                                                             DataValueField="LanguageID" DataTextField="LanguageName" Width="280" Filter="Contains"
                                                                             AppendDataBoundItems="true" DropDownAutoWidth="Enabled" OnClientKeyPressing="OnClientKeyPressing">
                                                            <ItemTemplate>
                                                                <table cellpadding="5px" style="text-align: left;">
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
                                                            <Items>
                                                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                                                            </Items>
                                                        </telerik:RadComboBox>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="LanguageID" ErrorMessage="<%$ Resources:Resource, msgLanguageObligate %>" Text="*" 
                                                                                    SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                        </asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.lblAddrPhone %>:</b>
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <telerik:RadTextBox ID="Phone" runat="server" Width="280px"></telerik:RadTextBox>
                                                    </td>
                                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="Phone" ErrorMessage="<%$ Resources:Resource, msgPhoneObligate %>" Text="*" 
                                                                                SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                    </asp:RequiredFieldValidator>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.lblAddrEmail %>:</b>
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <telerik:RadTextBox ID="Email1" runat="server" Width="280px" OnTextChanged="Email1_TextChanged" AutoPostBack="true" CausesValidation="false"></telerik:RadTextBox>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="Email1" ErrorMessage="<%$ Resources:Resource, msgEmailObligate %>" Text="*" 
                                                                                    SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                        </asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.lblAddrEmail %> (<%= Resources.Resource.lblPleaseRepeat %>):</b>
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <telerik:RadTextBox ID="Email2" runat="server" Width="280px"></telerik:RadTextBox>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="Email2" ErrorMessage="<%$ Resources:Resource, msgEmailObligate %>" Text="*" 
                                                                                    SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                        </asp:RequiredFieldValidator>
                                                        <asp:CompareValidator runat="server" ControlToValidate="Email2" ControlToCompare="Email1" Operator="Equal" ForeColor="Red" Text="*"
                                                                              ErrorMessage="<%$ Resources:Resource, msgEmailNotEqual %>" ValidationGroup="Submit" SetFocusOnError="true" ></asp:CompareValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp; </td>
                                                    <td>&nbsp; </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.lblUserName %>:</b>
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <asp:Panel runat="server" ID="PanelLoginName" Wrap="false">
                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td nowrap="nowrap">
                                                                        <telerik:RadTextBox ID="LoginName" runat="server" Width="280px"></telerik:RadTextBox>
                                                                    </td>
                                                                    <td nowrap="nowrap">
                                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="LoginName" ErrorMessage="<%$ Resources:Resource, msgUserNameObligate %>" Text="*" 
                                                                                                    SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                                        </asp:RequiredFieldValidator>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </asp:Panel>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.lblPassword %>:</b>
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <asp:TextBox ID="Password" runat="server" Width="280px" TextMode="Password" AutoCompleteType="Disabled"></asp:TextBox>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="Password" ErrorMessage="<%$ Resources:Resource, msgPasswordObligate %>" Text="*" 
                                                                                    SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                        </asp:RequiredFieldValidator>
                                                        <asp:RegularExpressionValidator runat="server" ControlToValidate="Password" Text="*" SetFocusOnError="true" ValidationGroup="Submit" 
                                                                                        ErrorMessage="<%$ Resources:Resource, msgPwdLength %>" ValidationExpression=".{6}.*" ForeColor="Red" />

                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.lblPassword %> (<%= Resources.Resource.lblPleaseRepeat %>):</b>
                                                    </td>
                                                    <td nowrap="nowrap">
                                                        <asp:TextBox ID="Password1" runat="server" Width="280px" TextMode="Password" AutoCompleteType="Disabled"></asp:TextBox>
                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="Password1" ErrorMessage="<%$ Resources:Resource, msgPasswordObligate %>" Text="*" 
                                                                                    SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                        </asp:RequiredFieldValidator>
                                                        <asp:CompareValidator runat="server" ControlToValidate="Password1" ControlToCompare="Password" Operator="Equal" ForeColor="Red" Text="*"
                                                                              ErrorMessage="<%$ Resources:Resource, msgPwdNotEqual %>" ValidationGroup="Submit" SetFocusOnError="true" ></asp:CompareValidator>
                                                        <asp:RegularExpressionValidator runat="server" ControlToValidate="Password1" Text="*" SetFocusOnError="true" ValidationGroup="Submit" 
                                                                                        ErrorMessage="<%$ Resources:Resource, msgPwdLength %>" ValidationExpression=".{6}.*" ForeColor="Red" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.lblPrivacyStatement %>:</b>
                                                    </td>
                                                    <td>
                                                        <table>
                                                            <tr>
                                                                <td valign="top">
                                                                    <asp:CheckBox runat="server" ID="PrivacyStatementOptIn" Checked="false" />
                                                                </td>
                                                                <td>
                                                                    <asp:Label runat="server" ID="LabelPrivacyStatementOptIn" Text="<%$ Resources:Resource, msgPrivacyStatementOptIn %>" Width="280px"></asp:Label>
                                                                    <asp:CustomValidator runat="server" ID="ValidatorPrivacyStatementOptIn" ErrorMessage="<%$ Resources:Resource, msgAcceptPrivacyStatement %>"
                                                                                         Text="*" ForeColor="Red" ValidationGroup="Submit" ClientValidationFunction="ValidateCheckBox">
                                                                    </asp:CustomValidator>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <asp:LinkButton runat="server" ID="ViewPrivacyStatement" Text="<%$ Resources:Resource, lblPrivacyStatement %>" 
                                                                        OnClick="ViewPrivacyStatement_Click"></asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <b><%= Resources.Resource.msgPleaseEnterCode %>:</b>
                                                    </td>
                                                    <td>
                                                        <telerik:RadCaptcha ID="RadCaptcha2" runat="server" ValidationGroup="Submit" CaptchaTextBoxLabel="" EnableRefreshImage="true"
                                                                            CaptchaLinkButtonText="<%$ Resources:Resource, lblNewCode %>" ErrorMessage="<%$ Resources:Resource, msgCodeWrong %>"
                                                                            CaptchaAudioLinkButtonText="<%$ Resources:Resource, lblGetAudioCode %>">
                                                            <CaptchaImage TextLength="8" Width="280" ImageCssClass="imageClass" BackgroundColor="#005AA1" TextColor="White" BackgroundNoise="None" 
                                                                          LineNoise="Extreme" FontWarp="High" EnableCaptchaAudio="true" UseAudioFiles="true" TextChars="Numbers" PersistCodeDuringAjax="true"/>
                                                        </telerik:RadCaptcha>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:ValidationSummary runat="server" DisplayMode="BulletList" ShowMessageBox="true" ShowSummary="true" BorderStyle="None"  
                                                                   ValidationGroup="Submit" />
                                        </td>
                                        <td>&nbsp; </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right;" nowrap="nowrap" colspan="2">
                                            <telerik:RadButton runat="server" Text="<%$ Resources:Resource, lblCancel %>" ID="BtnCancel" CausesValidation="false" PostBackUrl="~/Views/Login.aspx" Icon-PrimaryIconCssClass="rbCancel" />
                                            <telerik:RadButton runat="server" Text="<%$ Resources:Resource, lblActionSave %>" ID="BtnOK" OnClick="BtnOK_Click" ValidationGroup="Submit" UseSubmitBehavior="true" Icon-PrimaryIconCssClass="rbOk" />
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>

                    </div>
                </div>
            </div>

            <asp:SqlDataSource ID="SqlDataSource_TariffScopes" runat="server" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                               SelectCommand="SELECT t.NameVisible AS TariffNameVisible, c.NameVisible AS ContractNameVisible, c.ValidFrom, c.ValidTo, s.NameVisible, s.DescriptionShort, s.TariffScopeID, t.NameVisible + ', '  + c.NameVisible + ', ' + s.NameVisible AS Description FROM System_Tariffs AS t INNER JOIN System_TariffContracts AS c ON t.SystemID = c.SystemID AND t.TariffID = c.TariffID INNER JOIN System_TariffScopes AS s ON c.SystemID = s.SystemID AND c.TariffID = s.TariffID AND c.TariffContractID = s.TariffContractID WHERE (t.SystemID = @SystemID) AND (c.ValidFrom <= SYSDATETIME()) AND (c.ValidTo >= SYSDATETIME()) ORDER BY TariffNameVisible, ContractNameVisible, s.NameVisible">
                <SelectParameters>
                    <asp:SessionParameter SessionField="SystemID" DefaultValue="1" Name="SystemID"></asp:SessionParameter>
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="SqlDataSource_Countries" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                               SelectCommand="SELECT DISTINCT CountryID, CountryName, FlagName FROM View_Countries ORDER BY CountryName"></asp:SqlDataSource>

            <asp:SqlDataSource ID="SqlDataSource_Languages" runat="server" EnableCaching="true" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                               SelectCommand="SELECT LanguageID, LanguageName, FlagName FROM View_Languages ORDER BY LanguageName">
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="SqlDataSource_Salutations" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                               SelectCommand="SELECT * FROM System_Salutations ">
            </asp:SqlDataSource>

            <telerik:RadNotification ID="Notification" runat="server" TitleIcon="~/Resources/Icons/TitleIcon.png" Animation="Slide"
                                     AutoCloseDelay="7000" EnableRoundedCorners="True" EnableShadow="True" Position="Center" VisibleOnPageLoad="False"
                                     CloseButtonToolTip="<%$ Resources:Resource, lblActionClose %>" ContentIcon="info" KeepOnMouseOver="true">
            </telerik:RadNotification>
        </form>
    </body>

</html>
