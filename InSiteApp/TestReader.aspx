<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TestReader.aspx.cs" Inherits="InSiteApp.TestReader" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
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

            function getValueFromApplet(myParam, myParam2) {
                var theForm = document.getElementById("myform");
                var myID = document.getElementById("cardID");
                myID.value = myParam;
                var myID = document.getElementById("TAGID");
                myID.value = myParam;
                if (myParam2 = "submit") {
                    // theForm.submit();
                }
            }

            function showAlert() {
                var myVersion = document.myApplet.GetVersion();
                var versionTag = document.getElementById("idFromCard");
                versionTag.innerHTML = myVersion;
            }
        </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <h2>ChipReader - Test</h2>
        <hr />

        <%--        <div>
        <!--[if !IE]>-->
        <object classid="java:ChipReader.ChipReaderApp.class" type="application/x-java-applet" archive="InSite3Reader.jar" height="100" width="400" >
        <param name="logger" value="E:\logs\appbrowser.txt" />
        <param name="scripting" value="enabled" />
        <param name="scriptName" value="getValueFromApplet" />
        <param name="doSubmit" value= "false" />
        <param name="ReaderName" value="Identive CLOUD 4710 F Contactless Reader 1" />
        <!--<![endif]-->
        <object classid="clsid:8AD9C840-044E-11D1-B3E9-00805F499D93" height="100" width="400" >
        <param name="codebase" value="InSiteApp/Views/Main" />
        <param name="archive" value="InSite3Reader.jar" />
        <param name="code" value="ChipReaderApp" />
        <param name="logger" value="E:\logs\appbrowser.txt" />
        <param name="scripting" value="enabled" />
        <param name="scriptName" value="getValueFromApplet" />
        <param name="doSubmit" value= "false" />
        <param name="ReaderName" value="Identive CLOUD 4710 F Contactless Reader 1" />
        </object>
        <!--[if !IE]>-->
        </object>
        <!--<![endif]-->
        </div>--%>

        <applet id="myApplet" width="400" height="100" mayscript="mayscript" archive="/InSiteApp/Views/InSite3Reader.jar" name="myApplet" code="ChipReader.ChipReaderApp.class">
            <param name="logger" value="E:\logs\appbrowser.txt" />
            <param name="scripting" value="enabled" />
            <param name="scriptName" value="getValueFromApplet" />
            <param name="doSubmit" value= "false" />
            <param name="ReaderName" value="Identive CLOUD 4710 F Contactless Reader 1" />
        </applet>
        <hr />
        <input type="text" name="cardID" id="cardID" />
        <div id="idFromCard"></div>
        <br />
        <input type="button" value="Applet Version" onclick="showAlert()" />
        <label id="TAGID"></label>
    </div>
    </form>
</body>
</html>
