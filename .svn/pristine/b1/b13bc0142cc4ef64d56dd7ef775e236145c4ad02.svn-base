<%@ Page Title="<%$ Resources:Resource, lblTerminal %>" Language="C#" AutoEventWireup="true" CodeBehind="Speedy.aspx.cs" Inherits="InSite.App.Views.Main.Speedy" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
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

                function AdjustRadWindow() {
                    var oWindow = GetRadWindow();
                    setTimeout(function () {
                        oWindow.autoSize(true);
                    }, 320);
                }

                function getValueFromApplet(myParam, myParam2) {
                }
            </script>
        </telerik:RadScriptBlock>
    </head>
    
    <body>
        <form id="form1" runat="server">
            <telerik:RadScriptManager ID="RadScriptManager2" runat="server">
            </telerik:RadScriptManager>
            
            <telerik:RadNotification ID="Notification1" runat="server" TitleIcon="~/Resources/Icons/TitleIcon.png" Animation="Slide" 
                                     AutoCloseDelay="2000" EnableRoundedCorners="True" EnableShadow="True" Position="Center" VisibleOnPageLoad="False"
                                     CloseButtonToolTip="<%$ Resources:Resource, lblActionClose %>" ContentIcon="info" KeepOnMouseOver="true">
            </telerik:RadNotification>
            
            <div style="width: 520px; height: 743px; margin: -8px; padding: 0px; background-image: url('/InSiteApp/Resources/Images/speedy_white.jpg')">
                <telerik:RadScriptBlock ID="RadScriptBlock2" runat="server">
                    <div style="float:right; margin-top: 65px; margin-right: 25px;">
                        <applet id="ReaderState" width="20" height="20" archive="/InSiteApp/Controls/InSite3Reader.jar" name="myApplet" code="ChipReader.ChipReaderApp.class" 
                                alt="n.a.">
                            <%--  <param name="logger" value='<%= String.Concat(ConfigurationManager.AppSettings["LogRoot"].ToString(), "RFIDReader.log") %>' />--%>
                            <param name="logger" value="off" />
                            <param name="scripting" value="enabled" />
                            <param name="scriptName" value="getValueFromApplet" />
                            <param name="doSubmit" value= "false" />
                            <param name="ReaderName" value='<%= ConfigurationManager.AppSettings["ReaderName"].ToString() %>' />
                            <div id="cardState" style="width:20px; height:20px;"></div>
                            <script id="cardStateScript" socket-uri="<%= ConfigurationManager.AppSettings["WebSocketUri"].ToString() %>" src="../../Scripts/CardSocket.js" type="text/javascript"></script>
                        </applet>
                        <div id="idFromCard"></div>
                        <label id="TAGID"></label>
                    </div>
                </telerik:RadScriptBlock>

                <div style="position: absolute; margin-left: 76px; margin-top: 14px; border-style: none; background-color: red; background-image:none; height: 34px; width: 371px;">

                </div>

                <div style="position: absolute; margin-left: 82px; margin-top: 95px; border-style: solid; border-color: gray; border-radius: 5px; 
                        background-color: white; background-image:none; height: 470px; width: 352px;">

                </div>
                
            </div>
        </form>
    </body>
</html>
