<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Info.aspx.cs" Inherits="InSite.App.Views.Help.Info" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title></title>
        <style type="text/css">
            .auto-style1 {
                font-family: Arial, Helvetica, Sans-Serif;
            }
        </style>
    </head>

    <body>
        <form id="form1" runat="server">
            <table style="text-align: center; padding-right: 10px;">
                <tr>
                    <td>
                        <img src="../../Resources/Images/zeppelin_logo_transparent_150x56.png" />
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td nowrap="nowrap">
                        <asp:Label runat="server" ID="AppName" Font-Bold="true" Font-Size="Large" CssClass="auto-style1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td nowrap="nowrap">
                        <asp:Label runat="server" ID="AppVersion" Font-Size="Small" CssClass="auto-style1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style1">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td nowrap="nowrap">
                        <asp:Label runat="server" ID="CopyRight" Font-Size="Smaller" CssClass="auto-style1"></asp:Label>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
