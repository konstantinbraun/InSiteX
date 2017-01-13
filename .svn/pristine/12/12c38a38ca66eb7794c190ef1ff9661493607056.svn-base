<%@ Page Title="<%$ Resources:Resource, lblPresenceReport %>" Language="C#" AutoEventWireup="true" CodeBehind="PresenceReport.aspx.cs" Inherits="InSite.App.Views.Reports.PresenceReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link href="/InSiteApp/Styles/DefaultStyleSheet.css" rel="stylesheet" type="text/css" />
        <link rel="shortcut icon" href="/InSiteApp/Resources/Images/favicon.ico" />

        <title></title>

        <telerik:RadScriptBlock runat="server">
            <script type="text/javascript">
                function cancelAndClose() {
                    var oWindow = GetRadWindow();
                    oWindow.close(null);
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

                function AdjustRadWindow() {
                    var oWindow = GetRadWindow();
                    setTimeout(function () {
                        oWindow.autoSize(true);
                    }, 320);
                }
            </script>
        </telerik:RadScriptBlock>
    </head>

    <body>
        <form id="form1" runat="server">
            <telerik:RadScriptManager ID="RadScriptManager2" runat="server">
            </telerik:RadScriptManager>

            <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server">
                <AjaxSettings>
                    <telerik:AjaxSetting AjaxControlID="RadTabStrip1">
                        <UpdatedControls>
                            <telerik:AjaxUpdatedControl ControlID="RadTabStrip1" />
                        </UpdatedControls>
                    </telerik:AjaxSetting>
                    <telerik:AjaxSetting AjaxControlID="OK">
                        <UpdatedControls>
                            <telerik:AjaxUpdatedControl ControlID="OK" />
                        </UpdatedControls>
                    </telerik:AjaxSetting>
                    <telerik:AjaxSetting AjaxControlID="ExecutionInterval">
                        <UpdatedControls>
                            <telerik:AjaxUpdatedControl ControlID="PanelWeekly" />
                            <telerik:AjaxUpdatedControl ControlID="PanelMonthly" />
                        </UpdatedControls>
                    </telerik:AjaxSetting>
                </AjaxSettings>
            </telerik:RadAjaxManagerProxy>

            <telerik:RadNotification ID="Notification1" runat="server" TitleIcon="~/Resources/Icons/TitleIcon.png" Animation="Slide" Width="400px" 
                                     AutoCloseDelay="5000" EnableRoundedCorners="True" EnableShadow="True" Position="Center" VisibleOnPageLoad="False"
                                     CloseButtonToolTip="<%$ Resources:Resource, lblActionClose %>" ContentIcon="info" KeepOnMouseOver="true">
            </telerik:RadNotification>

            <telerik:RadTabStrip ID="RadTabStrip1" runat="server" MultiPageID="RadMultiPage1" Align="Left" AutoPostBack="false" CausesValidation="false" OnClientTabSelected="AdjustRadWindow">
                <Tabs>
                    <telerik:RadTab PageViewID="RadPageView1" ImageUrl="~/Resources/Icons/params_22.png" Text="<%$ Resources:Resource, lblParameters %>" Font-Bold="true" Value="1" Selected="true" />
                    <telerik:RadTab PageViewID="RadPageView2" ImageUrl="~/Resources/Icons/schedule_22.png" Text="<%$ Resources:Resource, lblScheduling %>" Font-Bold="true" Value="2" />
                </Tabs>
            </telerik:RadTabStrip>

            <telerik:RadMultiPage ID="RadMultiPage1" runat="server" RenderSelectedPageOnly="false">

                <%-- Parameter --%>
                <telerik:RadPageView ID="RadPageView1" runat="server" Selected="true">
                    <div style="border-color: ActiveBorder; border-width: 1px; border-style: none; border-radius: 5px; padding: 5px; margin: 5px;">

                        <table cellpadding="3px" style="padding: 5px; margin-right: 10px;">
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label runat="server" ID="LabelCompanyID" Text='<%$ Resources:Resource, lblCompany %>'></asp:Label>
                                </td>
                                <td colspan="2" nowrap="nowrap">
                                    <telerik:RadDropDownTree runat="server" ID="CompanyID" DataFieldParentID="ParentID" DataFieldID="CompanyID" DataValueField="CompanyID" EnableFiltering="true" 
                                                             DataTextField="CompanyName" Width="300px" OnClientKeyPressing="OnClientKeyPressing" DefaultMessage="<%$ Resources:Resource, lblAll %>"
                                                             DropDownSettings-AutoWidth="Enabled" DataSourceID="SqlDataSource_Companies" OnClientDropDownOpening="AdjustRadWindow" 
                                                             OnClientDropDownClosing="AdjustRadWindow">
                                        <ButtonSettings ShowClear="true" />
                                        <FilterSettings Highlight="Matches" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" Filter="Contains" />
                                        <DropDownSettings OpenDropDownOnLoad="false" CloseDropDownOnSelection="true" />
                                    </telerik:RadDropDownTree>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label runat="server" ID="LabelSelectNodes" Text='<%$ Resources:Resource, lblConsideredLevels %>'></asp:Label>
                                </td>
                                <td colspan="2">
                                    <telerik:RadComboBox runat="server" ID="SelectNodes" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                                         Width="300" OnClientKeyPressing="OnClientKeyPressing"
                                                         AppendDataBoundItems="true" Filter="Contains" DropDownAutoWidth="Enabled">
                                        <Items>
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblLevelCompanyOnly %>" Value="1" />
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblLevelFirstSubcontractors %>" Value="2" />
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblLevelAllSubcontractors %>" Value="3" Selected="true" />
                                        </Items>
                                    </telerik:RadComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label ID="LabelAccessAreaID" runat="server" Text='<%$ Resources:Resource, lblAccessArea %>'></asp:Label>
                                </td>
                                <td colspan="2" nowrap="nowrap">
                                    <telerik:RadComboBox runat="server" ID="AccessAreaID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                         DataSourceID="SqlDataSource_AccessAreas" AppendDataBoundItems="true"
                                                         DataValueField="AccessAreaID" DataTextField="NameVisible" Width="300" Filter="Contains" 
                                                         DropDownAutoWidth="Enabled">
                                        <Items>
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" Value="0" Selected="true" />
                                        </Items>
                                    </telerik:RadComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label runat="server" ID="LabelEvaluationPeriod" Text='<%$ Resources:Resource, lblEvaluationPeriod %>'></asp:Label>
                                </td>
                                <td colspan="2">
                                    <telerik:RadComboBox runat="server" ID="EvaluationPeriod" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                                         Width="300" OnClientKeyPressing="OnClientKeyPressing" AutoPostBack="true" 
                                                         OnSelectedIndexChanged="EvaluationPeriod_SelectedIndexChanged"
                                                         AppendDataBoundItems="true" Filter="Contains" DropDownAutoWidth="Enabled">
                                        <Items>
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selUserDefined %>" Value="1" Selected="true" />
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selAccumulatedUpUntilYesterday %>" Value="2" />
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selAccumulatedUpUntilEOLW %>" Value="3" />
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selAccumulatedUpUntilEOLM %>" Value="4" />
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selLastMonthOnly %>" Value="5" />
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selLastWeekOnly %>" Value="6" />
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selYesterdayOnly %>" Value="7" />
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selCurrentMonthAccumulatedUpUntilYesterday %>" Value="8" />
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selCurrentWeekAccumulatedUpUntilYesterday %>" Value="9" />
                                        </Items>
                                    </telerik:RadComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="LabelAccess" runat="server" Text="<%$ Resources:Resource, lblAccess %>"></asp:Label>
                                </td>
                                <td style="text-align: left; vertical-align: bottom">
                                    <asp:Label ID="LabelAccess1" runat="server" Text="<%$ Resources:Resource, lblBetweenToLower %>"></asp:Label>
                                    <br />
                                    <telerik:RadDatePicker ID="DateTimeFrom" runat="server" MinDate="1900/1/1" EnableShadows="true" Width="148px"
                                                           ShowPopupOnFocus="true" >
                                        <ClientEvents OnPopupOpening="AdjustRadWindow" OnPopupClosing="AdjustRadWindow" />
                                        <Calendar runat="server">
                                            <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                                    TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                            </FastNavigationSettings>
                                        </Calendar>
                                    </telerik:RadDatePicker>
                                </td>
                                <td nowrap="nowrap">
                                    <asp:Label ID="LabelAccess2" runat="server" Text="<%$ Resources:Resource, lblAndToLower %>"></asp:Label>
                                    <br />
                                    <telerik:RadDatePicker ID="DateTimeUntil" runat="server" MinDate="1900/1/1" EnableShadows="true" Width="148px"
                                                           ShowPopupOnFocus="true" >
                                        <ClientEvents OnPopupOpening="AdjustRadWindow" OnPopupClosing="AdjustRadWindow" />
                                        <Calendar runat="server">
                                            <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                                    TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                            </FastNavigationSettings>
                                        </Calendar>
                                    </telerik:RadDatePicker>
                                    <asp:CompareValidator runat="server" ControlToValidate="DateTimeUntil" ControlToCompare="DateTimeFrom" ValueToCompare="SelectedDate" Operator="GreaterThanEqual"
                                                          Text="*" SetFocusOnError="true" ForeColor="Red" ErrorMessage="<%$ Resources:Resource, msgDateFromLargerDateUntil %>" ValidationGroup="Select">
                                    </asp:CompareValidator>
                                </td>
                            </tr>
<%--                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label runat="server" ID="LabelEmployeesShowName" Text='<%$ Resources:Resource, lblEmployeesShowName %>'></asp:Label>
                                </td>
                                <td colspan="2">
                                    <asp:CheckBox runat="server" ID="EmployeesShowName" Checked="true" />
                                </td>
                            </tr>--%>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label runat="server" ID="LabelTemplate" Text='<%$ Resources:Resource, lblTemplate %>'></asp:Label>
                                </td>
                                <td colspan="2">
                                    <telerik:RadComboBox runat="server" ID="TemplateID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                                         Width="300" OnClientKeyPressing="OnClientKeyPressing"
                                                         AppendDataBoundItems="true" Filter="Contains" DropDownAutoWidth="Enabled">
                                        <Items>
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblDefault %>" Value="0" Selected="true" />
                                        </Items>
                                    </telerik:RadComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label runat="server" ID="LabelExportFormat" Text='<%$ Resources:Resource, lblExportFormat %>'></asp:Label>
                                </td>
                                <td colspan="2">
                                    <telerik:RadComboBox runat="server" ID="ExportFormat" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                                         Width="300" OnClientKeyPressing="OnClientKeyPressing"
                                                         AppendDataBoundItems="true" Filter="Contains" DropDownAutoWidth="Enabled">
                                        <Items>
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblExportToPdf %>" Value="pdf" ImageUrl="/InSiteApp/Resources/Icons/export_pdf_22.png" 
                                                Selected="true" />
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblExportToExcel %>" Value="xls" ImageUrl="/InSiteApp/Resources/Icons/export_xlsx_22.png" />
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblExportToXml %>" Value="xml" ImageUrl="/InSiteApp/Resources/Icons/export_xml_22.png" />
                                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblExportToCsv %>" Value="csv" ImageUrl="/InSiteApp/Resources/Icons/export_csv_22.png" />
                                        </Items>
                                    </telerik:RadComboBox>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label runat="server" ID="LabelRemark" Text='<%$ Resources:Resource, lblRemarks %>'></asp:Label>
                                </td>
                                <td colspan="2">
                                    <telerik:RadTextBox runat="server" ID="Remarks" Width="300px" TextMode="MultiLine"></telerik:RadTextBox>
                                </td>
                            </tr>
                        </table>
                    </div>
                </telerik:RadPageView>

                <%-- Terminierung --%>
                <telerik:RadPageView ID="RadPageView2" runat="server" Selected="false">
                    <div style="border-color: ActiveBorder; border-width: 1px; border-style: none; border-radius: 5px; padding: 5px; margin: 5px;">

                        <table cellpadding="3px" style="padding: 5px; margin-right: 10px; padding-right: 20px;">
                            <tr>
                                <td nowrap="nowrap" style="vertical-align: top;">
                                    <asp:Label runat="server" ID="LabelExecutionInterval" Text='<%$ Resources:Resource, lblExecutionInterval %>'></asp:Label>
                                </td>
                                <td colspan="2">
                                    <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px;">
                                        <telerik:RadComboBox runat="server" ID="ExecutionInterval" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                                             OnClientKeyPressing="OnClientKeyPressing" OnSelectedIndexChanged="ExecutionInterval_SelectedIndexChanged"
                                                             AppendDataBoundItems="true" Filter="Contains" DropDownAutoWidth="Enabled" AutoPostBack="true">
                                            <Items>
                                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblOnceOnly %>" Value="0" Selected="true" />
                                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblDaily %>" Value="1" />
                                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblWeekly %>" Value="2" />
                                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblMonthly %>" Value="3" />
                                            </Items>
                                        </telerik:RadComboBox>
                                        <br />
                                        <br />
                                        <asp:Panel runat="server" ID="PanelWeekly" Visible="false">
                                            <asp:Label runat="server" ID="LabelWeekly" Text='<%$ Resources:Resource, lblValidDays %>'></asp:Label>
                                            <table>
                                                <tr>
                                                    <td>
                                                        <telerik:RadAjaxPanel runat="server">
                                                            <telerik:RadTextBox runat="server" ID="ValidDays" Text="1111111" Visible="false"></telerik:RadTextBox>
                                                            <table>
                                                                <tr>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:Label runat="server" Text="<%$ Resources:Resource, dayMo %>"></asp:Label>
                                                                    </td>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:Label runat="server" Text="<%$ Resources:Resource, dayTu %>"></asp:Label>
                                                                    </td>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:Label runat="server" Text="<%$ Resources:Resource, dayWe %>"></asp:Label>
                                                                    </td>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:Label runat="server" Text="<%$ Resources:Resource, dayTh %>"></asp:Label>
                                                                    </td>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:Label runat="server" Text="<%$ Resources:Resource, dayFr %>"></asp:Label>
                                                                    </td>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:Label runat="server" Text="<%$ Resources:Resource, daySa %>" ForeColor="Red"></asp:Label>
                                                                    </td>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:Label runat="server" Text="<%$ Resources:Resource, daySu %>" ForeColor="Red"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:CheckBox runat="server" ID="DayMo" Checked="true" OnCheckedChanged="DayMo_CheckedChanged" 
                                                                                      AutoPostBack="true" CausesValidation="false" />
                                                                    </td>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:CheckBox runat="server" ID="DayTu" Checked="true" OnCheckedChanged="DayTu_CheckedChanged" 
                                                                                      AutoPostBack="true" CausesValidation="false" />
                                                                    </td>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:CheckBox runat="server" ID="DayWe" Checked="true" OnCheckedChanged="DayWe_CheckedChanged" 
                                                                                      AutoPostBack="true" CausesValidation="false" />
                                                                    </td>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:CheckBox runat="server" ID="DayTh" Checked="true" OnCheckedChanged="DayTh_CheckedChanged" 
                                                                                      AutoPostBack="true" CausesValidation="false" />
                                                                    </td>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:CheckBox runat="server" ID="DayFr" Checked="true" OnCheckedChanged="DayFr_CheckedChanged" 
                                                                                      AutoPostBack="true" CausesValidation="false" />
                                                                    </td>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:CheckBox runat="server" ID="DaySa" Checked="true" OnCheckedChanged="DaySa_CheckedChanged" 
                                                                                      AutoPostBack="true" CausesValidation="false" />
                                                                    </td>
                                                                    <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                                        <asp:CheckBox runat="server" ID="DaySu" Checked="true" OnCheckedChanged="DaySu_CheckedChanged" 
                                                                                      AutoPostBack="true" CausesValidation="false" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </telerik:RadAjaxPanel>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>

                                        <asp:Panel runat="server" ID="PanelMonthly" Visible="false">
                                            <asp:Label runat="server" ID="Label3" Text='<%$ Resources:Resource, lblDOM %>'></asp:Label>
                                            <br />
                                            <telerik:RadComboBox runat="server" ID="DayOfMonth" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                                                 OnClientKeyPressing="OnClientKeyPressing"
                                                                 AppendDataBoundItems="true" Filter="Contains" DropDownAutoWidth="Enabled">
                                                <Items>
                                                    <telerik:RadComboBoxItem Text="1." Value="1" Selected="true" />
                                                    <telerik:RadComboBoxItem Text="2." Value="2" />
                                                    <telerik:RadComboBoxItem Text="3." Value="3" />
                                                    <telerik:RadComboBoxItem Text="4." Value="4" />
                                                    <telerik:RadComboBoxItem Text="5." Value="5" />
                                                    <telerik:RadComboBoxItem Text="6." Value="6" />
                                                    <telerik:RadComboBoxItem Text="7." Value="7" />
                                                    <telerik:RadComboBoxItem Text="8." Value="8" />
                                                    <telerik:RadComboBoxItem Text="9." Value="9" />
                                                    <telerik:RadComboBoxItem Text="10." Value="10" />
                                                    <telerik:RadComboBoxItem Text="11." Value="11" />
                                                    <telerik:RadComboBoxItem Text="12." Value="12" />
                                                    <telerik:RadComboBoxItem Text="13." Value="13" />
                                                    <telerik:RadComboBoxItem Text="14." Value="14" />
                                                    <telerik:RadComboBoxItem Text="15." Value="15" />
                                                    <telerik:RadComboBoxItem Text="16." Value="16" />
                                                    <telerik:RadComboBoxItem Text="17." Value="17" />
                                                    <telerik:RadComboBoxItem Text="18." Value="18" />
                                                    <telerik:RadComboBoxItem Text="19." Value="19" />
                                                    <telerik:RadComboBoxItem Text="20." Value="20" />
                                                    <telerik:RadComboBoxItem Text="21." Value="21" />
                                                    <telerik:RadComboBoxItem Text="22." Value="22" />
                                                    <telerik:RadComboBoxItem Text="23." Value="23" />
                                                    <telerik:RadComboBoxItem Text="24." Value="24" />
                                                    <telerik:RadComboBoxItem Text="25." Value="25" />
                                                    <telerik:RadComboBoxItem Text="26." Value="26" />
                                                    <telerik:RadComboBoxItem Text="27." Value="27" />
                                                    <telerik:RadComboBoxItem Text="28." Value="28" />
                                                    <telerik:RadComboBoxItem Text="29." Value="29" />
                                                    <telerik:RadComboBoxItem Text="30." Value="30" />
                                                    <telerik:RadComboBoxItem Text="31." Value="31" />
                                                </Items>
                                            </telerik:RadComboBox>
                                        </asp:Panel>

                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label runat="server" ID="LabelExecutionTime" Text='<%$ Resources:Resource, lblExecutionTime %>' Font-Bold="true"></asp:Label>
                                </td>
                                <td colspan="2" nowrap="nowrap">
                                    <telerik:RadTimePicker ID="ExecutionTime" runat="server"  EnableShadows="true" DateInput-DisplayDateFormat="T" 
                                                           DateInput-DateFormat="T" ShowPopupOnFocus="true">
                                        <ClientEvents OnPopupOpening="AdjustRadWindow" OnPopupClosing="AdjustRadWindow" />
                                        <TimeView runat="server" ShowHeader="true" HeaderText="<%$ Resources:Resource, lblExecutionTime %>" StartTime="00:00:00" Interval="01:00:00" EndTime="23:59:59" 
                                                  Columns="4" TimeFormat="T">
                                        </TimeView>
                                    </telerik:RadTimePicker>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ExecutionTime" Text="*" SetFocusOnError="true" ForeColor="Red" ValidationGroup="Select" 
                                                                ErrorMessage="<%$ Resources:Resource, errExecutionTimeRequired %>">
                                    </asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="LabelStartDate" runat="server" Text="<%$ Resources:Resource, lblStartDate %>"></asp:Label>
                                </td>
                                <td colspan="2" style="text-align: left; vertical-align: bottom">
                                    <telerik:RadDatePicker ID="StartDate" runat="server" EnableShadows="true"
                                                           ShowPopupOnFocus="true" >
                                        <ClientEvents OnPopupOpening="AdjustRadWindow" OnPopupClosing="AdjustRadWindow" />
                                        <Calendar runat="server">
                                            <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                                    TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                            </FastNavigationSettings>
                                        </Calendar>
                                    </telerik:RadDatePicker>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="LabelEndDate" runat="server" Text="<%$ Resources:Resource, lblEndDate %>"></asp:Label>
                                </td>
                                <td colspan="2" style="text-align: left; vertical-align: bottom" nowrap="nowrap">
                                    <telerik:RadDatePicker ID="EndDate" runat="server" EnableShadows="true"
                                                           ShowPopupOnFocus="true" >
                                        <ClientEvents OnPopupOpening="AdjustRadWindow" OnPopupClosing="AdjustRadWindow" />
                                        <Calendar runat="server">
                                            <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                                    TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                            </FastNavigationSettings>
                                        </Calendar>
                                    </telerik:RadDatePicker>
                                    <asp:CompareValidator runat="server" ControlToValidate="EndDate" ControlToCompare="StartDate" ValueToCompare="SelectedDate" Operator="GreaterThanEqual"
                                                          Text="*" SetFocusOnError="true" ForeColor="Red" ErrorMessage="<%$ Resources:Resource, msgDateFromLargerDateUntil %>" ValidationGroup="Select">
                                    </asp:CompareValidator>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblReceiver %>" Font-Bold="true"></asp:Label>
                                </td>
                                <td colspan="2" nowrap="nowrap">
                                    <telerik:RadAutoCompleteBox runat="server" ID="Receiver" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataValueField="UserID"
                                        DataSourceID="SqlDataSource_Users" DataTextField="UserName" InputType="Token" Width="500px" ShowLoadingIcon="true" Filter="Contains" 
                                        HighlightFirstMatch="true" AllowCustomEntry="true" OnClientEntryAdded="AdjustRadWindow" OnClientEntryRemoved="AdjustRadWindow" 
                                        OnClientDropDownOpened="AdjustRadWindow" OnClientDropDownClosed="AdjustRadWindow" DropDownHeight="300px">
                                        <DropDownItemTemplate>
                                            <table cellpadding="0px" style="text-align: left;">
                                                <tr>
                                                    <td style="text-align: left;">
                                                        <asp:Label Text='<%# String.Concat(DataBinder.Eval(Container.DataItem, "LastName"), ", ") %>' runat="server">
                                                        </asp:Label>
                                                    </td>
                                                    <td style="text-align: left;">
                                                        <asp:Label Text='<%# String.Concat(DataBinder.Eval(Container.DataItem, "FirstName"), ", ") %>' runat="server" ForeColor="Gray">
                                                        </asp:Label>
                                                    </td>
                                                    <td style="text-align: left;">
                                                        <asp:Label Text='<%# String.Concat(DataBinder.Eval(Container.DataItem, "Company"), ", ") %>' runat="server">
                                                        </asp:Label>
                                                    </td>
                                                    <td style="text-align: left;">
                                                        <asp:Label Text='<%# DataBinder.Eval(Container.DataItem, "LoginName") %>' runat="server">
                                                        </asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </DropDownItemTemplate>
                                    </telerik:RadAutoCompleteBox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="Receiver" Text="*" SetFocusOnError="true" ForeColor="Red" ValidationGroup="Select" 
                                                                ErrorMessage="<%$ Resources:Resource, errReceiverRequired %>">
                                    </asp:RequiredFieldValidator>
                                </td>
                            </tr>
                        </table>
                    </div>
                </telerik:RadPageView>
            </telerik:RadMultiPage>

            <table style="width: 100%;">
                <tr>
                    <td>
                        <asp:ValidationSummary runat="server" DisplayMode="BulletList" ShowMessageBox="true" ShowSummary="true" BorderStyle="None"  
                                               ValidationGroup="Select" ForeColor="Red" />
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr style="float: right;">
                    <td style="text-align: right; float: right;" nowrap="nowrap">
                        <telerik:RadButton runat="server" Text="<%$ Resources:Resource, lblCancel %>" ID="BtnCancel" OnClick="BtnCancel_Click" />
                        <telerik:RadButton ID="OK" runat="server" Text="<%$ Resources:Resource, lblOk %>" ToolTip="<%$ Resources:Resource, msgStartReport %>" 
                                           OnClick="OK_Click" ButtonType="StandardButton" CommandArgument="Excel" ValidationGroup="Select">
                            <Icon PrimaryIconUrl="/InSiteApp/Resources/Icons/go_16.png" />
                        </telerik:RadButton>
                        <telerik:RadButton ID="btnExportPdf" runat="server" Text="<%$ Resources:Resource, lblExportToPdf %>" ToolTip="<%$ Resources:Resource, lblExportToPdf %>" 
                                           OnClick="BtnOK_Click" ButtonType="StandardButton" CommandArgument="Pdf" ValidationGroup="Select" Visible="false">
                            <Icon PrimaryIconUrl="/InSiteApp/Resources/Icons/export_pdf_16.png" />
                        </telerik:RadButton>
                    </td>
                </tr>
            </table>

            <asp:SqlDataSource ID="SqlDataSource_Companies" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                               SelectCommand="SELECT c.SystemID, c.BpID, c.CompanyID, (CASE WHEN @CompanyID > 0 THEN NULL ELSE (CASE WHEN c.ParentID = 0 THEN NULL ELSE c.ParentID END) END) AS ParentID, c.NameVisible, c.NameAdditional, c.Description, c.AddressID, c.IsVisible, c.IsValid, c.TradeAssociation, c.BlnSOKA, c.CreatedFrom, c.CreatedOn, c.EditFrom, c.EditOn, a.Address1, a.Address2, a.Zip, a.City, a.State, a.CountryID, a.Phone, a.Email, a.WWW, c.NameVisible + (CASE WHEN c.NameAdditional IS NULL THEN '' ELSE ', ' + c.NameAdditional END) + (CASE WHEN a.City IS NULL THEN '' ELSE ', ' + a.City END) AS CompanyName FROM Master_Companies AS c LEFT OUTER JOIN System_Addresses AS a ON c.SystemID = a.SystemID AND c.AddressID = a.AddressID WHERE (c.SystemID = @SystemID) AND (c.BpID = @BpID) AND (c.ReleaseOn IS NOT NULL) AND (c.CompanyCentralID = (CASE WHEN @CompanyID = 0 THEN c.CompanyCentralID ELSE @CompanyID END)) AND (dbo.HasLockedMainContractor(c.SystemID, c.BpID, c.CompanyID) = 0) ORDER BY c.NameVisible">
                <SelectParameters>
                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                    <asp:SessionParameter SessionField="CompanyID" DefaultValue="0" Name="CompanyID"></asp:SessionParameter>
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="SqlDataSource_AccessAreas" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                               SelectCommand="SELECT DISTINCT * FROM Master_AccessAreas aa WHERE aa.SystemID = @SystemID AND aa.BpID = @BpID">
                <SelectParameters>
                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="SqlDataSource_Users" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                SelectCommand="SELECT m_u.SystemID, m_u.UserID, m_u.FirstName, m_u.LastName, m_u.LoginName, m_u.Email, s_c.NameVisible AS Company, s_c.NameAdditional, m_u.LoginName COLLATE Latin1_General_CI_AS + ': ' + m_u.LastName + ', ' + m_u.FirstName + (CASE WHEN s_c.NameVisible IS NULL THEN '' ELSE (' (' + s_c.NameVisible + ')') END) AS UserName FROM Master_Users AS m_u LEFT OUTER JOIN System_Companies AS s_c ON m_u.SystemID = s_c.SystemID AND m_u.CompanyID = s_c.CompanyID WHERE (m_u.SystemID = @SystemID) AND (m_u.LockedOn IS NULL) AND (m_u.ReleaseOn IS NOT NULL) ORDER BY m_u.LastName, m_u.FirstName, Company">
                <SelectParameters>
                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                </SelectParameters>
            </asp:SqlDataSource>
        </form>
    </body>
</html>
