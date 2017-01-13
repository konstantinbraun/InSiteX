<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HistoryTables.aspx.cs" Inherits="InSite.App.Views.Central.HistoryTables" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server" id="Header">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link href="/InSiteApp/Styles/DefaultStyleSheet.css" rel="stylesheet" type="text/css" />
        <link rel="shortcut icon" href="/InSiteApp/Resources/Images/favicon.ico" />

        <title></title>

        <telerik:RadScriptBlock runat="server">
            <script type="text/javascript">
                function cancelAndClose() {
                    GetRadWindow().close();
                }

                function GetRadWindow() {
                    var oWindow = null;
                    if (window.radWindow)
                        oWindow = window.radWindow;
                    else if (window.frameElement.radWindow)
                        oWindow = window.frameElement.radWindow;
                    return oWindow;
                }

                function OnClientKeyPressing(sender, args) {
                    sender.showDropDown();
                }
            </script>
        </telerik:RadScriptBlock>
    </head>

    <body>
        <form id="form1" runat="server" style="height: 300px;">
            <telerik:RadScriptManager ID="RadScriptManager2" runat="server">
            </telerik:RadScriptManager>

            <telerik:RadNotification ID="Notification1" runat="server" TitleIcon="~/Resources/Icons/TitleIcon.png" Animation="Slide" 
                                        AutoCloseDelay="2000" EnableRoundedCorners="True" EnableShadow="True" Position="Center" VisibleOnPageLoad="False"
                                        CloseButtonToolTip="<%$ Resources:Resource, lblActionClose %>" ContentIcon="info" KeepOnMouseOver="true">
            </telerik:RadNotification>

            <table cellpadding="3px" style="padding: 5px; margin-right: 10px;">
                <tr>
                    <td nowrap="nowrap">
                        <asp:Label runat="server" ID="LabelTableNames" Text='<%$ Resources:Resource, lblTableName %>'></asp:Label>
                    </td>
                    <td colspan="2">
                        <telerik:RadComboBox runat="server" ID="TableNames" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                             DataValueField="TABLE_NAME" DataTextField="TABLE_NAME" Width="300px" OnClientKeyPressing="OnClientKeyPressing"
                                             AppendDataBoundItems="true" Filter="Contains" DropDownAutoWidth="Enabled">
                            <ItemTemplate>
                                <table cellpadding="0px" style="text-align: left;">
                                    <tr>
                                        <td style="text-align: left;">
                                            <asp:Label Text='<%# String.Concat(GetResource(Eval("ResourceID").ToString()), " (") %>' runat="server">
                                            </asp:Label>
                                        </td>
                                        <td style="text-align: left;">
                                            <asp:Label Text='<%# String.Concat(Eval("TABLE_NAME").ToString().Replace("History_S_","System_").Replace("History_M_","Master_").Replace("History_",""), ")") %>' runat="server">
                                            </asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                        </telerik:RadComboBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="TableNames" 
                                                    ErrorMessage="<%$ Resources:Resource, lblTableNameRequired %>" 
                                                    Text="*" SetFocusOnError="true" ForeColor="Red" ValidationGroup="Select">
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td nowrap="nowrap">
                        <asp:Label runat="server" ID="LabelUserNames" Text='<%$ Resources:Resource, lblLastEditBy %>'></asp:Label>
                    </td>
                    <td colspan="2">
                        <telerik:RadComboBox runat="server" ID="UserNames" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                             DataValueField="UserID" DataTextField="LoginName" Width="300" OnClientKeyPressing="OnClientKeyPressing"
                                             AppendDataBoundItems="true" Filter="Contains" DropDownAutoWidth="Enabled">
                            <ItemTemplate>
                                <table cellpadding="0px" style="text-align: left;">
                                    <tr>
                                        <td style="text-align: left;">
                                            <asp:Label Text='<%# String.Concat(Eval("LoginName").ToString(), " (") %>' runat="server">
                                            </asp:Label>
                                        </td>
                                        <td style="text-align: left;">
                                            <asp:Label Text='<%# String.Concat(Eval("FirstName").ToString(), " ", Eval("LastName").ToString(), ")") %>' runat="server">
                                            </asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                        </telerik:RadComboBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="LabelLastEdit" runat="server" Text="<%$ Resources:Resource, lblLastEdit %>"></asp:Label>
                    </td>
                    <td style="text-align: left; vertical-align: bottom">
                        <asp:Label ID="Label1" runat="server" Text="<%$ Resources:Resource, lblBetweenToLower %>"></asp:Label>
                        <br />
                        <telerik:RadDateTimePicker ID="DateTimeFrom" runat="server" MinDate="1900/1/1" MaxDate="2100/1/1" EnableShadows="true"
                                                   ShowPopupOnFocus="true" >
                            <Calendar runat="server">
                                <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                        TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                </FastNavigationSettings>
                            </Calendar>
                            <TimeView runat="server" ShowHeader="true" HeaderText="<%$ Resources:Resource, lblFrom %>" StartTime="00:00:00" Interval="01:00:00" EndTime="23:59:59" 
                                      Columns="4">
                            </TimeView>
                        </telerik:RadDateTimePicker>
                    </td>
                    <td>
                        <asp:Label ID="Label2" runat="server" Text="<%$ Resources:Resource, lblAndToLower %>"></asp:Label>
                        <br />
                        <telerik:RadDateTimePicker ID="DateTimeUntil" runat="server" MinDate="1900/1/1" MaxDate="2100/1/1" EnableShadows="true"
                                                   ShowPopupOnFocus="true" >
                            <Calendar runat="server">
                                <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                        TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                </FastNavigationSettings>
                            </Calendar>
                            <TimeView runat="server" ShowHeader="true" HeaderText="<%$ Resources:Resource, lblUntil %>" StartTime="00:00:00" Interval="01:00:00" EndTime="23:59:59" 
                                      Columns="4">
                            </TimeView>
                        </telerik:RadDateTimePicker>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <asp:ValidationSummary runat="server" DisplayMode="BulletList" ShowMessageBox="true" ShowSummary="true" BorderStyle="None"  
                                                ValidationGroup="Select" ForeColor="Red" />
                    </td>
                </tr>
                <tr>
                    <td>&nbsp; </td>
                    <td>&nbsp; </td>
                    <td>&nbsp; </td>
                </tr>
                <tr>
                    <td style="text-align: right;" nowrap="nowrap" colspan="3">
                        <telerik:RadButton runat="server" Text="<%$ Resources:Resource, lblCancel %>" ID="BtnCancel" OnClick="BtnCancel_Click" />
                        <telerik:RadButton runat="server" Text="<%$ Resources:Resource, lblActionSelect %>" ID="BtnOK" OnClick="BtnOK_Click" ValidationGroup="Select" />
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
