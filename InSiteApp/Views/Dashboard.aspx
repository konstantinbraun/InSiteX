<%@ Page Title="<%$ Resources:Resource, lblHome %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="InSite.App.Views.Dashboard" %>

<asp:Content ID="Content2" ContentPlaceHolderID="HeaderContent" runat="server">

    <telerik:RadCodeBlock runat="server">
        <script type="text/javascript">
            function TableClick(event, location) {
                window.location = location;
            }
        </script>
    </telerik:RadCodeBlock>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="BodyContent" runat="server">

    <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="Timer1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="PanelMailbox" />
                    <telerik:AjaxUpdatedControl ControlID="PanelProcessEvents" />
                    <telerik:AjaxUpdatedControl ControlID="PanelAccessInfo" />
                    <telerik:AjaxUpdatedControl ControlID="PresentPersonsPerAccessArea" />
                    <telerik:AjaxUpdatedControl ControlID="FirstAidersMissed" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="BtnRefresh">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="PanelMailbox" />
                    <telerik:AjaxUpdatedControl ControlID="PanelProcessEvents" />
                    <telerik:AjaxUpdatedControl ControlID="PanelAccessInfo" />
                    <telerik:AjaxUpdatedControl ControlID="PresentPersonsPerAccessArea" />
                    <telerik:AjaxUpdatedControl ControlID="FirstAidersMissed" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <asp:Panel ID="PanelTimer" runat="server">
        <asp:Timer ID="Timer1" runat="server" Interval="15000" OnTick="Timer1_Tick">
        </asp:Timer>
    </asp:Panel>

    <telerik:RadButton ID="BtnRefresh" runat="server" CommandName="Refresh" Text='<%# Resources.Resource.lblActionRefresh %>' AutoPostBack="true" Width="24px"
                       Icon-PrimaryIconCssClass="rbRefresh" ButtonType="LinkButton" BorderStyle="None" CssClass="FloatRight" BackColor="Transparent" 
                       ToolTip="<%$ Resources:Resource, lblActionRefresh %>" OnClick="BtnRefresh_Click" Visible="false">
    </telerik:RadButton>

    <table class="PanelTable">
        <tr>
            <td>
                <!-- Willkommen -->
                <asp:Panel runat="server" ID="PanelWelcome" CssClass="TilePanelWide">
                    <table style="width: 100%;">
                        <tr>
                            <td>
                                <a href="http://www.zeppelin-streif-baulogistik.com" target="_blank">
                                    <img alt="Logo" src="/InSiteApp/Resources/Images/zeppelin_logo_transparent_150x56.png" />
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 17px;">
                                <asp:Label runat="server" ID="BpName" Font-Bold="true" Font-Size="Medium"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 17px;">
                                <asp:Label runat="server" ID="BpDescription"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 17px;">
                                <asp:Label runat="server" ID="BpOwner"></asp:Label>
                            </td>
                        </tr>
                    </table>

                </asp:Panel>
            </td>

            <td>
                <!-- Mailbox -->
                <asp:Panel runat="server" ID="PanelMailbox" CssClass="TilePanelSquare LiftOnHover Clickable">
                    <table style="width: 100%;" onclick='TableClick(event, "/InSiteApp/Views/MailBox/MailBox.aspx");'>
                        <tr>
                            <td style="padding-left: 5px;">
                                <asp:Label runat="server" Text="<%$ Resources:Resource, lblMailbox %>" Font-Bold="true" ForeColor="#5D686D"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr style="text-align: center;">
                            <td>
                                <asp:Image runat="server" ID="IconMailbox" ImageUrl="/InSiteApp/Resources/Icons/mail-mark-read-2.png" Width="64px" Height="64px" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 5px;">
                                <asp:Label runat="server" ID="LabelMailbox" Text=""></asp:Label>
                            </td>
                        </tr>
                    </table>

                </asp:Panel>
            </td>

            <td>
                <!-- Vorgangsverwaltung -->
                <asp:Panel runat="server" ID="PanelProcessEvents" CssClass="TilePanelSquare LiftOnHover Clickable">
                    <table style="width: 100%;" onclick='TableClick(event, "/InSiteApp/Views/Main/ProcessEvents.aspx");'>
                        <tr>
                            <td style="padding-left: 5px;">
                                <asp:Label runat="server" Text="<%$ Resources:Resource, lblProcessManagement %>" Font-Bold="true" ForeColor="#5D686D"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr style="text-align: center;">
                            <td>
                                <img alt="Logo" src="/InSiteApp/Resources/Icons/view-refresh-3_128.png" style="height: 64px; width: 64px;" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 5px;">
                                <asp:Label runat="server" ID="LabelProcessEvents" Text=""></asp:Label>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>

            <td>
                <!-- Zentrale Vorgangsverwaltung -->
                <asp:Panel runat="server" ID="PanelProcessEventsCentral" CssClass="TilePanelSquare LiftOnHover Clickable">
                    <table style="width: 100%;" onclick='TableClick(event, "/InSiteApp/Views/Main/ProcessEvents.aspx?Type=0");'>
                        <tr>
                            <td style="padding-left: 5px;">
                                <asp:Label runat="server" Text="<%$ Resources:Resource, lblProcessManagementCentral %>" Font-Bold="true" ForeColor="#5D686D"></asp:Label>
                            </td>
                        </tr>
                        <tr style="text-align: center;">
                            <td>
                                <img alt="Logo" src="/InSiteApp/Resources/Icons/view-refresh-3_128.png" style="height: 64px; width: 64px;" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="padding-left: 5px;">
                                <asp:Label runat="server" ID="LabelProcessEventsCentral" Text=""></asp:Label>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>

        <tr>
            <td>
                <!-- Zutrittskontrolle -->
                <asp:Panel runat="server" ID="PanelAccessInfo" CssClass="TilePanelWide Wide LiftOnHover Clickable">
                    <table cellpadding="1" cellspacing="0" style="width: 100%; padding-right: 5px;" id="TableAccessInfo" onclick='TableClick(event, "/InSiteApp/Views/Main/AccessHistory.aspx");'>
                        <tr>
                            <td style="padding-left: 5px; vertical-align: top;">
                                <asp:Label runat="server" Text="<%$ Resources:Resource, lblAccessControl %>" Font-Bold="true" ForeColor="#5D686D"></asp:Label>
                            </td>
                            <td style="text-align: right; padding-top: 5px;" colspan="2">
                                <asp:Image runat="server" ID="Terminals" ImageUrl="/InSiteApp/Resources/Icons/TerminalsOffline_24.png" Width="24px" />
                                <asp:Image runat="server" ID="Signal" ImageUrl="/InSiteApp/Resources/Icons/Offline_24.png" Width="24px" />
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; color: gray;">
                            <%= String.Concat(Resources.Resource.lblEmployeesPresent, ":") %>
                            </td>
                            <td colspan="2">
                                <asp:Label ID="LabelEmployeesPresent" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; color: gray;">
                                <asp:Label ID="LabelEmployeesFaultyHeader" runat="server" Text="<%$ Resources:Resource, lblEmployeesFaulty %>" ForeColor="Red" Visible="false"></asp:Label>
                            </td>
                            <td style="vertical-align: bottom;" colspan="2">
                                <asp:Label ID="LabelEmployeesFaulty" runat="server" Text="" ForeColor="Red" Visible="false"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; color: gray;">
                            <%= String.Concat(Resources.Resource.lblVisitorsPresent, ":") %>
                            </td>
                            <td colspan="2">
                                <asp:Label ID="LabelVisitorsPresent" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; color: gray;">
                                <asp:Label ID="LabelVisitorsFaultyHeader" runat="server" Text="<%$ Resources:Resource, lblVisitorsFaulty %>" ForeColor="Red" Visible="false"></asp:Label>
                            </td>
                            <td style="vertical-align: bottom;" colspan="2">
                                <asp:Label ID="LabelVisitorsFaulty" runat="server" Text="" ForeColor="Red"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; color: gray;">
                            <%= String.Concat(Resources.Resource.lblLastEvent, ":") %>
                            </td>
                            <td nowrap="nowrap">
                                <asp:Label ID="LabelLastAccess" runat="server" Text=""></asp:Label>
                            </td>
                            <td>
                                <asp:Image runat="server" ID="ImageLastEvent" ImageUrl="/InSiteApp/Resources/Icons/never-24.png" Width="16px" Height="16px" />
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; color: gray;">
                            <%= String.Concat(Resources.Resource.lblLastUpdate, ":") %>
                            </td>
                            <td nowrap="nowrap" colspan="2">
                                <asp:Label ID="LabelLastUpdate" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; color: gray;">
                            <%= String.Concat(Resources.Resource.lblLastCorrectionAccessEvents, ":") %>
                            </td>
                            <td style="vertical-align: bottom;" nowrap="nowrap" colspan="2">

                                <asp:Label ID="LastCorrection" runat="server" Text="">

                                </asp:Label>
                            </td>
                        </tr>
                    </table>

                </asp:Panel>
            </td>

            <td colspan="2">
                <!-- Auslaufende Tarife -->
                <asp:Panel runat="server" ID="PanelExpiringTariffs" CssClass="TilePanelWide ResizeOnHover Wide LiftOnHover" Visible="true">
                    <table style="width: 100%; padding-right: 5px;">
                        <tr>
                            <td style="padding-left: 5px;">
                                <asp:Label runat="server" Text="<%$ Resources:Resource, lblExpiringTariffs %>" Font-Bold="true" ForeColor="#5D686D"></asp:Label>
                            </td>
                        </tr>
                    </table>

                    <telerik:RadListBox ID="ExpiringTariffs" runat="server" DataKeyField="TariffContractID" DataSortField="ValidTo" DataTextField="TariffContractName" 
                                        DataValueField="TariffContractID" SelectionMode="Single" CssClass="NoBorder">
                        <HeaderTemplate>
                            <table cellpadding="0" cellspacing="0" style="text-align: left; width: 100%;">
                                <tr>
                                    <td style="text-align: left; width: 96px;" nowrap="nowrap">
                                        <asp:Label ID="Label1" Text="<%$ Resources:Resource, lblTariff %>" Font-Bold="true" runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="text-align: left; width: 100px;" nowrap="nowrap">
                                        <asp:Label ID="Label2" Text="<%$ Resources:Resource, lblTariffContract %>" Font-Bold="true" runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="text-align: right; width: 50px;" nowrap="nowrap">
                                        <asp:Label ID="Label3" Text="<%$ Resources:Resource, lblValidTo %>" Font-Bold="true" runat="server">
                                        </asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <table cellpadding="0" cellspacing="0" style="text-align: left; width: 100%;">
                                <tr>
                                    <td style="text-align: left; width: 100px;">
                                        <asp:Label ID="TariffName" Text='<%# Eval("TariffName") %>' runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="text-align: left; padding-left: 0px; width: 100px;">
                                        <asp:Label ID="TariffContractName" Text='<%# Eval("TariffContractName") %>' runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="text-align: right; padding-left: 0px; width: 50px;" nowrap="nowrap">
                                        <asp:Label ID="ValidTo" Text='<%# Eval("ValidTo", "{0:d}") %>' runat="server">
                                        </asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </ItemTemplate>
                    </telerik:RadListBox>
                </asp:Panel>
            </td>
        </tr>

        <tr>
            <td>
                <!-- Anwesend pro Zutrittsbereich -->
                <asp:Panel runat="server" ID="PanelPresentInAccessArea" CssClass="TilePanelWide ResizeOnHover Wide LiftOnHover">
                    <table cellpadding="1" cellspacing="1" style="text-align: left; width: 100%; border-top-left-radius: 5px; border-top-right-radius: 5px;">
                        <tr>
                            <td style="padding-left: 5px;">
                                <asp:Label ID="LabelHeader" runat="server" Text="<%$ Resources:Resource, lblPresentPerAccessArea %>" Font-Bold="true" ForeColor="#5D686D"></asp:Label>
                            </td>
                        </tr>
                    </table>

                    <telerik:RadListBox ID="PresentPersonsPerAccessArea" runat="server" DataKeyField="AccessAreaID" DataSortField="NameVisible" DataTextField="NameVisible" 
                                        DataValueField="AccessAreaID" SelectionMode="Single" CssClass="NoBorder">
                        <HeaderTemplate>
                            <table cellpadding="0" cellspacing="0" style="text-align: left; width: 100%;">
                                <tr>
                                    <td style="text-align: left; width: 150px;" nowrap="nowrap">
                                        <asp:Label ID="Label1" Text="<%$ Resources:Resource, lblAccessArea %>" Font-Bold="true" runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="padding-left: 3px; width: 50px;" nowrap="nowrap">
                                        <asp:Label ID="Label2" Text="<%$ Resources:Resource, lblEmployees %>" Font-Bold="true" runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="padding-left: 3px; width: 50px;" nowrap="nowrap">
                                        <asp:Label ID="Label3" Text="<%$ Resources:Resource, lblVisitors %>" Font-Bold="true" runat="server">
                                        </asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <table cellpadding="0" cellspacing="0" style="text-align: left; width: 100%;">
                                <tr>
                                    <td style="width: 150px;" nowrap="nowrap">
                                        <asp:Label ID="NameVisible" Text='<%# Eval("NameVisible") %>' runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="padding-left: 3px; width: 50px;" nowrap="nowrap">
                                        <asp:Label ID="EmployeesPresent" Text='<%# Eval("EmployeesPresent") %>' runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="padding-left: 3px; width: 50px;" nowrap="nowrap">
                                        <asp:Label ID="VisitorsPresent" Text='<%# Eval("VisitorsPresent") %>' runat="server">
                                        </asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </ItemTemplate>
                    </telerik:RadListBox>
                </asp:Panel>
            </td>

            <td colspan="2">
                <!-- Fehlende Ersthelfer -->
                <asp:Panel runat="server" ID="PanelMissingFirstAiders" CssClass="TilePanelWide ResizeOnHover Wide LiftOnHover">
                    <table cellpadding="1" cellspacing="1" style="text-align: left; width: 100%; border-top-left-radius: 5px; border-top-right-radius: 5px;">
                        <tr>
                            <td style="padding-left: 5px; vertical-align: top;">
                                <asp:Label ID="LabelMissingFirstAiders" runat="server" Text="<%$ Resources:Resource, lblMissingFirstAidersTitle %>" Font-Bold="true" ForeColor="#5D686D"></asp:Label>
                            </td>
                            <td style="text-align: right; padding-top: 5px; padding-right: 5px;">
                                <asp:Image runat="server" ID="ImageMissingFirstAiders" ImageUrl="/InSiteApp/Resources/Images/signal_3_red_24.png" Width="72px" />
                            </td>
                        </tr>
                    </table>

                    <telerik:RadListBox ID="FirstAidersMissed" runat="server" DataKeyField="CompanyID" DataSortField="CompanyName" DataTextField="CompanyName" 
                                        DataValueField="CompanyID" SelectionMode="Single" CssClass="NoBorder">
                        <HeaderTemplate>
                            <table cellpadding="0" cellspacing="0" style="text-align: left; width: 100%;">
                                <tr>
                                    <td style="text-align: left; width: 360px; vertical-align: bottom;" nowrap="nowrap">
                                        <asp:Label Text="<%$ Resources:Resource, lblCompany %>" Font-Bold="true" runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="text-align: right; padding-left: 3px; width: 45px;">
                                        <asp:Label Text="<%$ Resources:Resource, lblPresentEmployees %>" Font-Bold="true" runat="server" Font-Size="Smaller">
                                        </asp:Label>
                                    </td>
                                    <td style="text-align: right; padding-left: 3px; width: 45px;">
                                        <asp:Label Text="<%$ Resources:Resource, lblMissingFirstAiders %>" Font-Bold="true" runat="server" Font-Size="Smaller">
                                        </asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <table cellpadding="0" cellspacing="0" style="text-align: left; width: 100%;">
                                <tr>
                                    <td>
                                        <asp:Label ID="CompanyName" Text='<%# Eval("CompanyName") %>' ToolTip='<%# Eval("CompanyName") %>' runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="text-align: right; padding-left: 3px; width: 45px;" nowrap="nowrap">
                                        <asp:Label ID="EmployeesPresent1" Text='<%# Eval("EmployeesPresent") %>' runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="text-align: right; padding-left: 3px; width: 45px;" nowrap="nowrap">
                                        <asp:Label ID="MinAiders" Text='<%# Eval("MinAiders") %>' runat="server">
                                        </asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </ItemTemplate>
                    </telerik:RadListBox>
                </asp:Panel>
            </td>
        </tr>
        
        <tr>
            <td colspan ="4">
                <!-- Anwesende Ersthelfer -->
                <asp:Panel runat="server" ID="PanelAnwesendeErsthelfer" CssClass="TilePanelWide2 ResizeOnHover Wide2 LiftOnHover">
                    <table cellpadding="1" cellspacing="1" style="text-align: left; width: 100%; border-top-left-radius: 5px; border-top-right-radius: 5px;">
                        <tr>
                            <td style="padding-left: 5px;">
                                <asp:Label ID="Label4" runat="server" Text="Anwesende Ersthelfer" Font-Bold="true" ForeColor="#5D686D"></asp:Label>
                            </td>
                        </tr>
                    </table>
                    <telerik:RadListBox ID="lstAvailableFirstAiders" runat="server" Culture="de-DE" >
                        <HeaderTemplate>
                            <table cellpadding="0" cellspacing="0" style="text-align: left; width: 100%;">
                                <tr>
                                    <td style="width: 240px; vertical-align: bottom;" nowrap="nowrap">
                                        <asp:Label Text="<%$ Resources:Resource, lblEmployer %>" Font-Bold="true" runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="padding-left: 3px; width: 120px;">
                                        <asp:Label Text="<%$ Resources:Resource, lblLastName %>" Font-Bold="true" runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="padding-left: 3px; width: 120px;">
                                        <asp:Label Text="<%$ Resources:Resource, lblFirstName %>" Font-Bold="true" runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="padding-left: 3px; width: 120px;">
                                        <asp:Label Text="<%$ Resources:Resource, lblAddrPhone %>" Font-Bold="true" runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="width: 100px;  padding-left: 3px;" >
                                        <asp:Label Text="<%$ Resources:Resource, lblAccessArea %>" Font-Bold="true" runat="server">
                                        </asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <table cellpadding="0" cellspacing="0" style="text-align: left; width: 100%;">
                                <tr>
                                    <td style="width: 240px; padding-left: 3px;">
                                        <asp:Label Text='<%#Eval("CompanyName")%>' runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="width: 120px; padding-left: 3px;">
                                        <asp:Label Text='<%#Eval("LastName")%>' runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="width: 120px; padding-left: 3px;">
                                        <asp:Label Text='<%#Eval("FirstName")%>' runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="width: 120px; padding-left: 3px;">
                                        <asp:Label Text='<%#Eval("Mobile")%>' runat="server">
                                        </asp:Label>
                                    </td>
                                    <td style="width: 100px; padding-left: 3px;">
                                        <asp:Label Text='<%#Eval("AccessArea")%>' runat="server">
                                        </asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </ItemTemplate>
                    </telerik:RadListBox>
                </asp:Panel>
            </td>
        </tr>

        <tr>
            <td>
                <!-- Benutzer -->
                <asp:Panel runat="server" ID="PanelUser" CssClass="TilePanelWide">
                    <table style="width: 100%;">
                        <tr>
                            <td style="padding-left: 5px;">
                                <asp:Label runat="server" Text="<%$ Resources:Resource, lblUser %>" Font-Bold="true" ForeColor="#5D686D"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; color: gray;">
                            <%= String.Concat(Resources.Resource.lblLoggedOnUser, ":") %>
                            </td>
                            <td>
                                <asp:Label ID="Username" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; color: gray;">
                            <%= String.Concat(Resources.Resource.lblCompany, ":") %>
                            </td>
                            <td>
                                <asp:Label ID="Company" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; color: gray;">
                            <%= String.Concat(Resources.Resource.lblBuildingProject, ":") %>
                            </td>
                            <td>
                                <asp:Label ID="BuildingProject" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; color: gray;">
                            <%= String.Concat(Resources.Resource.lblRole, ":") %>
                            </td>
                            <td>
                                <asp:Label ID="Role" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="padding-left: 5px;">
                                <%= Resources.Resource.msgQuestions %>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>

            <td colspan="2">
                <!-- App Info -->
                <asp:Panel runat="server" ID="PanelAppInfo" CssClass="TilePanelWide" Visible="false">
                    <table style="width: 100%; padding-right: 5px;">
                        <tr>
                            <td style="padding-left: 5px;">
                                <asp:Label runat="server" Text="<%$ Resources:Resource, appName %>" Font-Bold="true" ForeColor="#5D686D"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; color: gray;">
                            <%= String.Concat(Resources.Resource.lblVersion, ":") %>
                            </td>
                            <td style="vertical-align: bottom;" nowrap="nowrap">
                                <asp:Label ID="AppVersion" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; color: gray;">
                            <%= String.Concat(Resources.Resource.lblLastBackup, ":") %>
                            </td>
                            <td style="vertical-align: bottom;" nowrap="nowrap">
                                <asp:Label ID="LastBackup" runat="server" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; color: gray;">
                            <%= String.Concat(Resources.Resource.lblLastCompress, ":") %>
                            </td>
                            <td style="vertical-align: bottom;" nowrap="nowrap">

                                <asp:Label ID="LastCompress" runat="server" Text="">

                                </asp:Label>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>

            <td>

            </td>
        </tr>
    </table>
</asp:Content>
