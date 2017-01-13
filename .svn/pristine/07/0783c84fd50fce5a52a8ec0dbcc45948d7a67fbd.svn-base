<%@ Page Title="<%$ Resources:Resource, lblRegisterEmployee %>" Language="C#" AutoEventWireup="true" CodeBehind="RegisterEmployee.aspx.cs" Inherits="InSite.App.Views.RegisterEmployee" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <link href="~/Styles/DefaultStyleSheet.css" rel="stylesheet" type="text/css" />
        <link rel="shortcut icon" href="~/Resources/Images/favicon.ico" />

        <title></title>
        <telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
            <script type="text/javascript">
                var uploadedFilesCount = 0;
                var isEditMode;

                function validateRadUpload(source, e) {
                    // When the RadGrid is in Edit mode the user is not obliged to upload file.
                    if (isEditMode === null || isEditMode === undefined) {
                        e.IsValid = false;

                        if (uploadedFilesCount > 0) {
                            e.IsValid = true;
                        }
                    }
                    isEditMode = null;
                }

                function OnClientFileUploaded(sender, eventArgs) {
                    uploadedFilesCount++;
                }

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

            <telerik:RadFormDecorator ID="FormDecorator1" runat="server" DecoratedControls="All" EnableRoundedCorners="true" Skin="Default"></telerik:RadFormDecorator>

            <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
            </telerik:RadAjaxManager>

            <telerik:RadWindow runat="server" ID="RadWindowPopUp" DestroyOnClose="false" InitialBehaviors="Resize,Close,Reload,Move" Behaviors="Resize,Close,Reload,Move" 
                               AutoSize="true" AutoSizeBehaviors="Height,Width" ReloadOnShow="true" ShowContentDuringLoad="false">
            </telerik:RadWindow>

            <div style="margin: auto; margin-top: 20px; border: 0px solid #ff0000; width: 960px; padding: 8px 0 0 0px; border-radius: 5px; box-shadow: 3px 3px 6px darkgray;">
                <div style="text-align: left; border-radius: 5px; width: 960px;">
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
                                    <asp:Image runat="server" ID="PageIcon" ImageUrl="~/Resources/Icons/Contract.png" Height="22px" Width="22px" />
                                </td>
                                <td>
                                    <asp:Label runat="server" Text='<%$ Resources:Resource, lblRegisterEmployee %>' Style="font-size: 16px; font-weight: bold; vertical-align: top;"></asp:Label>
                                </td>
                                <td style="vertical-align: bottom; text-align: left; padding-top: 2px;">
                                    <telerik:RadButton ID="GetHelp" runat="server" BorderStyle="None" BackColor="Transparent" ButtonType="SkinnedButton"
                                                       OnClick="GetHelp_Click" CommandArgument="/Help/Mitarbeiter_registrieren.htm" AutoPostBack="true" ToolTip="<%$ Resources:Resource, lblDialogHelp %>">
                                        <ContentTemplate>
                                            <asp:Image runat="server" ID="PageIcon" ImageUrl="~/Resources/Icons/Help_22.png" Height="22px" Width="22px" />
                                        </ContentTemplate>
                                    </telerik:RadButton>
                                </td>
                            </tr>
                        </table>
                        <table id="Table1" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top; width: 100%;">
                            <tr>
                                <td style="vertical-align: top;">
                                    <table id="Table2" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                        <tr>
                                            <td>
                                            <%= String.Concat(Resources.Resource.lblBuildingProject, ":") %>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="BuildingProject"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                            <%= String.Concat(Resources.Resource.lblCompany, ":") %>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="Company"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <b><%= String.Concat(Resources.Resource.lblAddrSalutation, ":") %></b>
                                            </td>
                                            <td nowrap="nowrap">
                                                <telerik:RadComboBox runat="server" ID="Salutation" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                     DataSourceID="SqlDataSource_Salutations" DataValueField="Salutation" DataTextField="Salutation" Width="300px" 
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
                                                <b><%= String.Concat(Resources.Resource.lblAddrFirstName, ":") %></b>
                                            </td>
                                            <td nowrap="nowrap">
                                                <telerik:RadTextBox runat="server" ID="FirstName" Width="300px"></telerik:RadTextBox>
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="FirstName" ErrorMessage="<%$ Resources:Resource, msgFirstNameObligate %>" Text="*" 
                                                                            SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                </asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <b><%= String.Concat(Resources.Resource.lblAddrLastName, ":") %></b>
                                            </td>
                                            <td nowrap="nowrap">
                                                <telerik:RadTextBox runat="server" ID="LastName" Width="300px"></telerik:RadTextBox>
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="LastName" ErrorMessage="<%$ Resources:Resource, msgLastNameObligate %>" Text="*" 
                                                                            SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                </asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <b><%= String.Concat(Resources.Resource.lblAddress1, ":") %></b>
                                            </td>
                                            <td nowrap="nowrap">
                                                <telerik:RadTextBox runat="server" ID="Address1" Width="300px"></telerik:RadTextBox>
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="Address1" ErrorMessage="<%$ Resources:Resource, msgAddress1Obligate %>" Text="*" 
                                                                            SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                </asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                            <%= String.Concat(Resources.Resource.lblAddress2, ":") %>
                                            </td>
                                            <td nowrap="nowrap">
                                                <telerik:RadTextBox runat="server" ID="Address2" Width="300px"></telerik:RadTextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <b><%= String.Concat(Resources.Resource.lblAddrZip, " ", Resources.Resource.lblAddrCity, ":") %></b>
                                            </td>
                                            <td nowrap="nowrap">
                                                <telerik:RadTextBox runat="server" ID="Zip" Width="60px"></telerik:RadTextBox>
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="Zip" ErrorMessage="<%$ Resources:Resource, msgZipObligate %>" Text="*" 
                                                                            SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                </asp:RequiredFieldValidator>
                                                <telerik:RadTextBox runat="server" ID="City" Text='<%# Bind("City") %>' Width="224px"></telerik:RadTextBox>
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="City" ErrorMessage="<%$ Resources:Resource, msgCityObligate %>" Text="*" 
                                                                            SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                </asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                            <%= String.Concat(Resources.Resource.lblAddrState, ":") %>
                                            </td>
                                            <td nowrap="nowrap">
                                                <telerik:RadTextBox runat="server" ID="State" Width="300px"></telerik:RadTextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <b><%= String.Concat(Resources.Resource.lblCountry, ":") %></b>
                                            </td>
                                            <td nowrap="nowrap">
                                                <telerik:RadComboBox runat="server" ID="CountryID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataSourceID="SqlDataSource_Countries"
                                                                     DataValueField="CountryID" DataTextField="CountryName" Width="300px" Filter="Contains"
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
                                            <td>
                                            <%= String.Concat(Resources.Resource.lblAddrPhone, ":") %>
                                            </td>
                                            <td nowrap="nowrap">
                                                <telerik:RadTextBox runat="server" ID="Phone" Width="300px"></telerik:RadTextBox>
                                            <%--                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="Phone" ErrorMessage="<%$ Resources:Resource, msgPhoneObligate %>" Text="*" 
                                            SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                            </asp:RequiredFieldValidator>--%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                            <%= String.Concat(Resources.Resource.lblAddrEmail, ":") %>
                                            </td>
                                            <td nowrap="nowrap">
                                                <telerik:RadTextBox runat="server" ID="Email" Width="300px"></telerik:RadTextBox>
                                                <%--                                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="Email" ErrorMessage="<%$ Resources:Resource, msgEmailObligate %>" Text="*" 
                                                SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                </asp:RequiredFieldValidator>--%>
                                                <asp:RegularExpressionValidator ID="emailValidator" runat="server" ControlToValidate="Email" SetFocusOnError="true" ForeColor="Red" Text="*"
                                                                                ErrorMessage="<%$ Resources:Resource, msgEmailObligate %>" ValidationGroup="Submit" 
                                                                                ValidationExpression="^[\w\.\-]+@[a-zA-Z0-9\-]+(\.[a-zA-Z0-9\-]{1,})*(\.[a-zA-Z]{2,3}){1,2}$">
                                                </asp:RegularExpressionValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <b><%= String.Concat(Resources.Resource.lblAddrBirthDate, ":") %></b>
                                            </td>
                                            <td nowrap="nowrap">
                                                <telerik:RadDatePicker ID="BirthDate" runat="server" MinDate="1900/1/1" MaxDate="2100/1/1" EnableShadows="true"
                                                                       ShowPopupOnFocus="true">
                                                    <Calendar runat="server">
                                                        <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                                                TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                                        </FastNavigationSettings>
                                                    </Calendar>
                                                </telerik:RadDatePicker>
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="BirthDate" ErrorMessage="<%$ Resources:Resource, msgBirthDateObligate %>" Text="*" 
                                                                            SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                </asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <b><%= String.Concat(Resources.Resource.lblNationality, ":") %></b>
                                            </td>
                                            <td nowrap="nowrap">
                                                <telerik:RadComboBox runat="server" ID="NationalityID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataSourceID="SqlDataSource_Countries"
                                                                     DataValueField="CountryID" DataTextField="CountryName" Width="300px" Filter="Contains"
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
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="NationalityID" ErrorMessage="<%$ Resources:Resource, msgNationalityObligate %>" Text="*" 
                                                                            SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                </asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <b><%= String.Concat(Resources.Resource.lblLanguage, ":") %></b>
                                            </td>
                                            <td nowrap="nowrap">
                                                <telerik:RadComboBox runat="server" ID="LanguageID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataSourceID="SqlDataSource_Languages"
                                                                     DataValueField="LanguageID" DataTextField="LanguageName" Width="300px" Filter="Contains"
                                                                     AppendDataBoundItems="true" DropDownAutoWidth="Enabled" OnClientKeyPressing="OnClientKeyPressing">
                                                    <ItemTemplate>
                                                        <table cellpadding="5px" style="text-align: left;">
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
                                                    <Items>
                                                        <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                                                    </Items>
                                                </telerik:RadComboBox>
                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="LanguageID" ErrorMessage="<%$ Resources:Resource, msgLanguageObligate %>" Text="*" 
                                                                            SetFocusOnError="true" ForeColor="Red" ValidationGroup="Submit">
                                                </asp:RequiredFieldValidator>
                                            </td>
                                        </tr>

                                    </table>
                                </td>
                                <td style="vertical-align: top;">
                                    <table id="Table3" cellspacing="2" cellpadding="2" border="0">
                                        <tr>
                                            <td>
                                                <%= Resources.Resource.lblPhoto %>:
                                            </td>
                                            <td nowrap="nowrap" style="width: 290px;">
                                                <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin-top: 72px;  width: 290px;">
                                                    <asp:Panel runat="server" ID="PanelPhoto">
                                                        <telerik:RadBinaryImage runat="server" ID="PhotoData" AutoAdjustImageControlSize="true">
                                                        </telerik:RadBinaryImage>
                                                        <br />
                                                        <asp:Label runat="server" ID="PhotoFileName"></asp:Label>
                                                        <br />
                                                        <br />
                                                        <telerik:RadAsyncUpload runat="server" ID="AsyncUpload1" OnClientFileUploaded="OnClientFileUploaded" 
                                                                                AllowedFileExtensions="jpg,jpeg,png,gif" MaxFileSize="2097152" MultipleFileSelection="Disabled" >
                                                            <Localization Select="<%$ Resources:Resource, lblActionSelect %>" Cancel="<%$ Resources:Resource, lblActionCancel %>"
                                                                          Remove="<%$ Resources:Resource, lblActionDelete %>" />
                                                        </telerik:RadAsyncUpload>
                                                    </asp:Panel>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
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
                                            <td style="width: 80px;">
                                                <b><%= Resources.Resource.msgPleaseEnterCode %>:</b>
                                            </td>
                                            <td>
                                                <telerik:RadCaptcha ID="RadCaptcha2" runat="server" ValidationGroup="Submit" CaptchaTextBoxLabel="" EnableRefreshImage="true"
                                                                    CaptchaLinkButtonText="<%$ Resources:Resource, lblNewCode %>" ErrorMessage="<%$ Resources:Resource, msgCodeWrong %>"
                                                                    OnCaptchaValidate="RadCaptcha2_CaptchaValidate" CaptchaAudioLinkButtonText="<%$ Resources:Resource, lblGetAudioCode %>" >
                                                    <CaptchaImage TextLength="4" Width="300" ImageCssClass="imageClass" BackgroundColor="#005AA1" TextColor="White" BackgroundNoise="None" 
                                                                  LineNoise="Extreme" FontWarp="High" EnableCaptchaAudio="true" UseAudioFiles="true" PersistCodeDuringAjax="true" TextChars="Numbers"/>
                                                </telerik:RadCaptcha>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <div style="margin-left: 10px;">
                                                    <asp:ValidationSummary ID="ValidationSummary2" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' ShowMessageBox="true" 
                                                                           ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true" ValidationGroup="Submit" BorderStyle="None" />
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                    <br />
                                </td>
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

            <asp:SqlDataSource ID="SqlDataSource_Countries" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                               SelectCommand="SELECT DISTINCT CountryID, CountryName, FlagName FROM View_Countries ORDER BY CountryName"></asp:SqlDataSource>

            <asp:SqlDataSource ID="SqlDataSource_Languages" runat="server" EnableCaching="true" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                               SelectCommand="SELECT LanguageID, LanguageName, FlagName FROM View_Languages ORDER BY LanguageName">
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="SqlDataSource_Salutations" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                               SelectCommand="SELECT * FROM System_Salutations ">
            </asp:SqlDataSource>

            <telerik:RadNotification ID="Notification" runat="server" TitleIcon="~/Resources/Icons/TitleIcon.png" BackColor="White" Animation="Resize" AutoCloseDelay="7000"
                                     EnableRoundedCorners="True" EnableShadow="True" Position="Center" VisibleOnPageLoad="False">
            </telerik:RadNotification>
        </form>
    </body>

</html>
