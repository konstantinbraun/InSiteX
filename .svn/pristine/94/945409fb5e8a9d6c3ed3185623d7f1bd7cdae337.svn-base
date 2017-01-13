<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShortTermPassActions.aspx.cs" Inherits="InSite.App.Views.Main.ShortTermPassActions" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server" id="Header">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="/InSiteApp/Styles/DefaultStyleSheet.css" rel="stylesheet" type="text/css" />
    <link rel="shortcut icon" href="/InSiteApp/Resources/Images/favicon.ico" />

    <title></title>

    <telerik:RadCodeBlock runat="server">
        <script type="text/javascript">
            function OnClientKeyPressing(sender, args) {
                sender.showDropDown();
            }

            function cancelAndClose() {
<%--                    var manager = $find('<%= RadAjaxManager.GetCurrent(Page).ClientID %>');
                    document.body.style.cursor = "default";
                    manager.set_enableAJAX(true);--%>
                parent.cardReader.unregister(shortTermPassActions);
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

                function getValueFromApplet(myParam, myParam2) {
                    var theForm = document.getElementById("myform");
                    var myID = document.getElementById("IDInternal");
                    myID.value = myParam;
                    myID = document.getElementById("TAGID");
                    myID.value = myParam;
                    if (myParam2 = "submit") {
                        // theForm.submit();
                    }
                    document.getElementById('BtnCheck').click();
                }

                function showAlert() {
                    var myVersion = document.myApplet.GetVersion();
                    var versionTag = document.getElementById("idFromCard");
                    versionTag.innerHTML = myVersion;
                }

                function OnRowDblClick(sender, args) {
                    document.getElementById("BtnOK").click(sender, args);
                }

                var shortTermPassActions = {
                    name: "ShortTermPassActions",
                    uuid: "1A63F49A-B75F-4FC3-A289-ECF802ACE8DC",
                    onmessage: function (cardState) {
                        if (cardState.online == true) {
                            if (typeof cardState.cardId !== "undefined") {
                                var theForm = document.getElementById("myform");
                                var myID = document.getElementById("IDInternal");
                                myID.value = cardState.cardId;
                                myID = document.getElementById("TAGID");
                                myID.value = cardState.cardId;
                                document.getElementById('BtnCheck').click();
                            }
                        }
                    }
                }

                document.addEventListener("DOMContentLoaded", function (event) {
                    parent.cardStateColors.setStyleElement(document.getElementById("cardState"));
                    parent.cardReader.register(shortTermPassActions);
                });
        </script>
    </telerik:RadCodeBlock>
</head>

<body>
    <form id="form1" runat="server">

        <telerik:RadCodeBlock ID="RadCodeBlock2" runat="server">
            <script type="text/javascript">
                function suspendAJAX(sender, args) {
                    var manager = $find('<%= RadAjaxManager.GetCurrent(Page).ClientID %>');
                        document.body.style.cursor = "wait";
                        manager.set_enableAJAX(false);

                        setTimeout(function () {
                            manager.set_enableAJAX(true);
                            document.body.style.cursor = "default";
                        }, 5000);
                    }
            </script>
        </telerik:RadCodeBlock>

        <telerik:RadScriptManager ID="RadScriptManager2" runat="server">
        </telerik:RadScriptManager>

        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
            <AjaxSettings>
                <telerik:AjaxSetting AjaxControlID="RadGrid1">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanel1" />
                    </UpdatedControls>
                </telerik:AjaxSetting>
                <telerik:AjaxSetting AjaxControlID="BtnOK">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanel1" />
                    </UpdatedControls>
                </telerik:AjaxSetting>
                <telerik:AjaxSetting AjaxControlID="RadGrid1">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="BtnOK" />
                    </UpdatedControls>
                </telerik:AjaxSetting>
            </AjaxSettings>
        </telerik:RadAjaxManager>

        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" Height="100px" Width="100px" Transparency="15" EnableTheming="true" InitialDelayTime="500" MinDisplayTime="500">
        </telerik:RadAjaxLoadingPanel>

        <telerik:RadNotification ID="Notification1" runat="server" TitleIcon="~/Resources/Icons/TitleIcon.png" Animation="Slide" LoadContentOn="EveryShow"
            AutoCloseDelay="2000" EnableRoundedCorners="True" EnableShadow="True" Position="Center" VisibleOnPageLoad="False"
            CloseButtonToolTip="<%$ Resources:Resource, lblActionClose %>" ContentIcon="info" KeepOnMouseOver="true" Height="100px">
        </telerik:RadNotification>

        <table>
            <tr>
                <td>

                    <asp:Panel runat="server" ID="PanelPrint" Visible="false">
                        <fieldset runat="server" style="border-radius: 10px; border-style: solid; border-width: 1px; border-color: ActiveBorder; padding: 5px;">

                            <table cellpadding="3px">
                                <tr>
                                    <td nowrap="nowrap">
                                        <asp:Label runat="server" ID="LabelShortTermPassTypeID" Text='<%$ Resources:Resource, lblShortTermPassType %>'></asp:Label>
                                    </td>
                                    <td>
                                        <telerik:RadComboBox runat="server" ID="ShortTermPassTypeID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" OpenDropDownOnLoad="true"
                                            DataSourceID="SqlDataSource_ShortTermPassTypes" DataValueField="ShortTermPassTypeID" DataTextField="NameVisible" Width="300"
                                            AppendDataBoundItems="true" Filter="Contains">
                                        </telerik:RadComboBox>
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="ShortTermPassTypeID"
                                            ErrorMessage='<%$ Resources:Resource, msgShortTermPassTypeObligate %>'
                                            Text="*" SetFocusOnError="true" ForeColor="Red" ValidationGroup="Print">
                                        </asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="LabelPassCount" runat="server" Text="<%$ Resources:Resource, lblCount %>"></asp:Label>
                                    </td>
                                    <td style="text-align: left; vertical-align: bottom">
                                        <telerik:RadTextBox runat="server" InputType="Number" Text="1" ID="PassCount" Width="300px"></telerik:RadTextBox>
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="PassCount"
                                            ErrorMessage='<%$ Resources:Resource, msgPassCountObligate %>'
                                            Text="*" SetFocusOnError="true" ForeColor="Red" ValidationGroup="Print">
                                        </asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:ValidationSummary runat="server" DisplayMode="BulletList" ShowMessageBox="true" ShowSummary="true" BorderStyle="None"
                                            ValidationGroup="Print" ForeColor="Red" />
                                    </td>
                                    <td>&nbsp; </td>
                                </tr>
                            </table>

                        </fieldset>
                    </asp:Panel>

                    <asp:Panel runat="server" ID="PanelAssign" Visible="false">
                        <fieldset runat="server" style="border-radius: 10px; border-style: solid; border-width: 1px; border-color: ActiveBorder; padding: 5px;">

                            <table cellpadding="3px">
                                <tr>
                                    <td nowrap="nowrap">
                                        <asp:Label ID="LabelIDInternal" runat="server" Text="<%$ Resources:Resource, lblChipID %>"></asp:Label>
                                    </td>
                                    <td nowrap="nowrap" style="text-align: left; vertical-align: bottom">
                                        <telerik:RadTextBox runat="server" ID="IDInternal"></telerik:RadTextBox>
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="IDInternal"
                                            ErrorMessage='<%$ Resources:Resource, msgInternalIDObligate %>'
                                            Text="*" SetFocusOnError="true" ForeColor="Red" ValidationGroup="Assign">
                                        </asp:RequiredFieldValidator>
                                        <telerik:RadButton ID="BtnCheck" runat="server" Text="<%$ Resources:Resource, lblCheckChipID %>" OnClick="BtnCheck_Click" Icon-PrimaryIconCssClass="rbSearch"></telerik:RadButton>
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp; </td>
                                    <td>&nbsp; </td>
                                </tr>
                                <tr>
                                    <td nowrap="nowrap">
                                        <asp:Label ID="LabelReaderState" runat="server" Text="<%$ Resources:Resource, lblReaderState %>"></asp:Label>

                                    </td>
                                    <td>
                                        <asp:Panel runat="server" ID="ReaderStatePanel">
	                                        <applet id="ReaderState" width="160" height="20" archive="/InSiteApp/Controls/InSite3Reader.jar" name="myApplet" code="ChipReader.ChipReaderApp.class">
	                                            <%--  <param name="logger" value='<%= String.Concat(ConfigurationManager.AppSettings["LogRoot"].ToString(), "RFIDReader.log") %>' />--%>
	                                            <param name="logger" value="off" />
	                                            <param name="scripting" value="enabled" />
	                                            <param name="scriptName" value="getValueFromApplet" />
	                                            <param name="doSubmit" value= "false" />
	                                            <param name="ReaderName" value='<%= ConfigurationManager.AppSettings["ReaderName"].ToString() %>' />
                                                <div id="cardState" style="width: 160px; height: 20px;"></div>
	                                        </applet>
                                            <div id="idFromCard"></div>
                                            <label id="TAGID"></label>
                                        </asp:Panel>
                                    </td>
                                </tr>
                                <%--                                    <tr>
                                    <td colspan="2">
                                    <asp:Label ID="LabelShortTermPasses" runat="server" Text="<%$ Resources:Resource, lblShortTermPasses %>"></asp:Label>
                                    <br />
                                    <telerik:RadGrid ID="ShortTermPassPrint" runat="server" DataSourceID="SqlDataSource_ShortTermPassPrint"
                                    AllowPaging="True" AllowSorting="True" AllowFilteringByColumn="True" AutoGenerateColumns="False"
                                    OnItemCommand="ShortTermPassPrint_ItemCommand">

                                    <MasterTableView DataSourceID="SqlDataSource_ShortTermPassPrint" DataKeyNames="SystemID, BpID, PrintID">
                                    <PagerStyle AlwaysVisible="True"></PagerStyle>

                                    <CommandItemSettings ShowAddNewRecordButton="false" ShowRefreshButton="true" />

                                    <Columns>
                                    <telerik:GridBoundColumn DataField="PrintedFrom" HeaderText="<%$ Resources:Resource, lblCreatedFrom %>" SortExpression="PrintedFrom" UniqueName="PrintedFrom" Visible="true">
                                    </telerik:GridBoundColumn>

                                    <telerik:GridBoundColumn DataField="PrintedOn" HeaderText="<%$ Resources:Resource, lblCreatedOn %>" SortExpression="PrintedOn" UniqueName="PrintedOn" DataType="System.DateTime" 
                                    Visible="true" ItemStyle-Wrap="false">
                                    </telerik:GridBoundColumn>

                                    <telerik:GridTemplateColumn DataField="FileName" HeaderText="<%$ Resources:Resource, lblAttachment %>" SortExpression="FileName" UniqueName="FileName"
                                    GroupByExpression="DocumentName FileName GROUP BY FileName">
                                    <ItemTemplate>
                                    <telerik:RadButton runat="server" ID="FileName" Text='<%# Eval("FileName") %>' ToolTip="<%$ Resources:Resource, msgClickToDownload %>" 
                                    CommandName="DocDownloadCmd" CommandArgument='<%# Eval("PrintID") %>' 
                                    OnClientClicked="suspendAJAX" ButtonType="SkinnedButton" Height="24px" Visible="true">
                                    <Icon PrimaryIconUrl="/InSiteApp/Resources/Icons/export_pdf_16.png" PrimaryIconWidth="22px" PrimaryIconHeight="22px" />
                                    </telerik:RadButton>
                                    </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                    </Columns>
                                    </MasterTableView>
                                    </telerik:RadGrid>
                                    </td>
                                    </tr>--%>
                                <tr>
                                    <td>
                                        <asp:ValidationSummary runat="server" DisplayMode="BulletList" ShowMessageBox="true" ShowSummary="true" BorderStyle="None"
                                            ValidationGroup="Assign" ForeColor="Red" />
                                    </td>
                                    <td>&nbsp; </td>
                                </tr>
                            </table>
                        </fieldset>
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Panel runat="server" ID="PanelGrid" Visible="false">
                        <telerik:RadGrid ID="RadGrid1" runat="server" DataSourceID="SqlDataSource_ShortTermPasses" CssClass="RadGrid"
                            AllowPaging="True" AllowSorting="True" AllowFilteringByColumn="True"
                            AutoGenerateColumns="False" OnSelectedIndexChanged="RadGrid1_SelectedIndexChanged">
                            <ExportSettings>
                                <Pdf PageWidth=""></Pdf>
                            </ExportSettings>

                            <ClientSettings EnablePostBackOnRowClick="true">
                                <Selecting AllowRowSelect="True" CellSelectionMode="SingleCell"></Selecting>
                                <ClientEvents OnRowDblClick="OnRowDblClick" />
                            </ClientSettings>

                            <SortingSettings SortedBackColor="Transparent" />

                            <MasterTableView DataSourceID="SqlDataSource_ShortTermPasses" DataKeyNames="ShortTermPassID" AllowMultiColumnSorting="true">

                                <SortExpressions>
                                    <telerik:GridSortExpression FieldName="StatusID" SortOrder="Ascending"></telerik:GridSortExpression>
                                    <telerik:GridSortExpression FieldName="ShortTermPassID" SortOrder="Descending"></telerik:GridSortExpression>
                                </SortExpressions>

                                <Columns>
                                    <telerik:GridBoundColumn DataField="TypeName" HeaderText="<%$ Resources:Resource, lblShortTermPassType %>" SortExpression="TypeName" UniqueName="TypeName" FilterControlAltText="Filter TypeName column">
                                    </telerik:GridBoundColumn>

                                    <telerik:GridTemplateColumn DataField="StatusID" HeaderText="<%$ Resources:Resource, lblStatus %>" SortExpression="StatusID"
                                        UniqueName="StatusID" DataType="System.Int32" FilterControlAltText="Filter StatusID column" ForceExtractValue="Always" FilterControlWidth="80px"
                                        CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                                        <ItemTemplate>
                                            <asp:Label runat="server" ID="StatusID" Text='<%# InSite.App.Constants.Status.GetStatusString(Convert.ToInt32(Eval("StatusID"))) %>'></asp:Label>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>

                                    <telerik:GridBoundColumn DataField="ShortTermPassID" HeaderText="<%$ Resources:Resource, lblPassID %>" SortExpression="ShortTermPassID" UniqueName="ShortTermPassID" FilterControlAltText="Filter ShortTermPassID column">
                                    </telerik:GridBoundColumn>

                                    <telerik:GridBoundColumn DataField="InternalID" HeaderText="<%$ Resources:Resource, lblChipID %>" SortExpression="InternalID" UniqueName="InternalID" FilterControlAltText="Filter InternalID column">
                                    </telerik:GridBoundColumn>

                                    <telerik:GridBoundColumn DataField="PrintedFrom" HeaderText="PrintedFrom" SortExpression="PrintedFrom" UniqueName="PrintedFrom"
                                        FilterControlAltText="Filter PrintedFrom column" Visible="false">
                                    </telerik:GridBoundColumn>

                                    <telerik:GridBoundColumn DataField="PrintedOn" HeaderText="PrintedOn" SortExpression="PrintedOn" UniqueName="PrintedOn" DataType="System.DateTime"
                                        FilterControlAltText="Filter PrintedOn column" Visible="false">
                                    </telerik:GridBoundColumn>

                                    <telerik:GridBoundColumn DataField="ActivatedFrom" HeaderText="ActivatedFrom" SortExpression="ActivatedFrom" UniqueName="ActivatedFrom"
                                        FilterControlAltText="Filter ActivatedFrom column" Visible="false">
                                    </telerik:GridBoundColumn>

                                    <telerik:GridBoundColumn DataField="ActivatedOn" HeaderText="ActivatedOn" SortExpression="ActivatedOn" UniqueName="ActivatedOn" DataType="System.DateTime"
                                        FilterControlAltText="Filter ActivatedOn column" Visible="false">
                                    </telerik:GridBoundColumn>

                                    <telerik:GridBoundColumn DataField="DeactivatedFrom" HeaderText="DeactivatedFrom" SortExpression="DeactivatedFrom" UniqueName="DeactivatedFrom"
                                        FilterControlAltText="Filter DeactivatedFrom column" Visible="false">
                                    </telerik:GridBoundColumn>

                                    <telerik:GridBoundColumn DataField="DeactivatedOn" HeaderText="DeactivatedOn" SortExpression="DeactivatedOn" UniqueName="DeactivatedOn" DataType="System.DateTime"
                                        FilterControlAltText="Filter DeactivatedOn column" Visible="false">
                                    </telerik:GridBoundColumn>

                                    <telerik:GridBoundColumn DataField="LockedFrom" HeaderText="LockedFrom" SortExpression="LockedFrom" UniqueName="LockedFrom"
                                        FilterControlAltText="Filter LockedFrom column" Visible="false">
                                    </telerik:GridBoundColumn>

                                    <telerik:GridBoundColumn DataField="LockedOn" HeaderText="LockedOn" SortExpression="LockedOn" UniqueName="LockedOn" DataType="System.DateTime"
                                        FilterControlAltText="Filter LockedOn column" Visible="false">
                                    </telerik:GridBoundColumn>

                                    <telerik:GridBoundColumn DataField="CreatedFrom" HeaderText="CreatedFrom" SortExpression="CreatedFrom" UniqueName="CreatedFrom"
                                        FilterControlAltText="Filter CreatedFrom column" Visible="false">
                                    </telerik:GridBoundColumn>

                                    <telerik:GridBoundColumn DataField="CreatedOn" HeaderText="CreatedOn" SortExpression="CreatedOn" UniqueName="CreatedOn" DataType="System.DateTime"
                                        FilterControlAltText="Filter CreatedOn column" Visible="false">
                                    </telerik:GridBoundColumn>

                                    <telerik:GridBoundColumn DataField="EditFrom" HeaderText="EditFrom" SortExpression="EditFrom" UniqueName="EditFrom"
                                        FilterControlAltText="Filter EditFrom column" Visible="false">
                                    </telerik:GridBoundColumn>

                                    <telerik:GridBoundColumn DataField="EditOn" HeaderText="EditOn" SortExpression="EditOn" UniqueName="EditOn" DataType="System.DateTime"
                                        FilterControlAltText="Filter EditOn column" Visible="false">
                                    </telerik:GridBoundColumn>

                                </Columns>
                                <PagerStyle AlwaysVisible="True"></PagerStyle>
                            </MasterTableView>
                            <PagerStyle AlwaysVisible="True"></PagerStyle>
                        </telerik:RadGrid>
                        <asp:SqlDataSource runat="server" ID="SqlDataSource_ShortTermPasses" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                            SelectCommand="SELECT Data_ShortTermPasses.ShortTermPassID, Master_ShortTermPassTypes.NameVisible AS TypeName, Data_ShortTermPasses.StatusID, Data_ShortTermPasses.InternalID, Data_ShortTermPasses.PrintedFrom, Data_ShortTermPasses.PrintedOn, Data_ShortTermPasses.CreatedFrom, Data_ShortTermPasses.CreatedOn, Data_ShortTermPasses.EditFrom, Data_ShortTermPasses.EditOn FROM Data_ShortTermPasses INNER JOIN Master_ShortTermPassTypes ON Data_ShortTermPasses.SystemID = Master_ShortTermPassTypes.SystemID AND Data_ShortTermPasses.BpID = Master_ShortTermPassTypes.BpID AND Data_ShortTermPasses.ShortTermPassTypeID = Master_ShortTermPassTypes.ShortTermPassTypeID WHERE (Data_ShortTermPasses.SystemID = @SystemID) AND (Data_ShortTermPasses.BpID = @BpID) AND (Data_ShortTermPasses.ActivatedOn IS NULL) AND (Data_ShortTermPasses.DeactivatedOn IS NULL) AND (Data_ShortTermPasses.LockedOn IS NULL) ORDER BY Data_ShortTermPasses.InternalID, Data_ShortTermPasses.PrintedOn">
                            <SelectParameters>
                                <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td>&nbsp; </td>
            </tr>
            <tr>
                <td style="text-align: right;" nowrap="nowrap">
                    <table cellpadding="0px" cellspacing="0px" style="text-align: right; width: 100%;">
                        <tr style="text-align: right;">
                            <td style="text-align: right;">
                                <telerik:RadButton runat="server" Text="<%$ Resources:Resource, lblCancel %>" ID="BtnCancel" OnClick="BtnCancel_Click" />
                            </td>
                            <td style="text-align: right; width: 80px;">
                                <telerik:RadButton runat="server" Text="<%$ Resources:Resource, lblActionChange %>" ID="BtnOK" OnClick="BtnOK_Click" Enabled="false" Width="80px" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>

        <asp:SqlDataSource ID="SqlDataSource_ShortTermPassTypes" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
            SelectCommand="SELECT ShortTermPassTypeID, NameVisible FROM Master_ShortTermPassTypes WHERE SystemID = @SystemID AND BpID = @BpID ORDER BY NameVisible">
            <SelectParameters>
                <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
                <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="SqlDataSource_ShortTermPassPrint" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
            SelectCommand="SELECT SystemID, BpID, PrintID, FileName, FileType, PrintedFrom, PrintedOn FROM Data_ShortTermPassesPrint WHERE SystemID = @SystemID AND BpID = @BpID ORDER BY PrintID DESC">
            <SelectParameters>
                <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
                <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    </form>
</body>
</html>
