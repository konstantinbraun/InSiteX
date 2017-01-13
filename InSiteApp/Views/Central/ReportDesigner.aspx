<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportDesigner.aspx.cs" Inherits="InSite.App.Views.Central.ReportDesigner" %>
<%@ Register assembly="Stimulsoft.Report.WebDesign, Version=2016.2.0.0, Culture=neutral, PublicKeyToken=ebe6666cba19647a" namespace="Stimulsoft.Report.Web" tagprefix="cc1" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <cc1:StiWebDesigner ID="StiWebDesigner1" runat="server" OnExit="StiWebDesigner1_Exit" 
            OnSaveReport="StiWebDesigner1_SaveReport" 
            OnPreInit="StiWebDesigner1_PreInit" 
            SaveAsMode="Hidden"/>
    </div>
    </form>
</body>
</html>
