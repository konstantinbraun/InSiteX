<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Support.aspx.cs" Inherits="InSite.App.Views.Help.Support" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title></title>

        <telerik:RadCodeBlock ID="RadCodeBlock23" runat="server">
            <script src="https://showmypc.com/js/jquery-1.11.2.min.js" type="text/javascript"></script>
            <script src="https://showmypc.com/js/jquery.client.js" type="text/javascript"></script>
            <script type="text/javascript">
                $(document).ready(function () {
                    if ($.client.os !== "Windows") {
                        $("#downlink").html("<%= Resources.Resource.lblRequestNow %>");
                        $("#downlink").click(function () {
                            window.open('https://showmypc.com/mac/java-client.html?ci=trippeberatung&sh=0', 'window_name', 'width=550,height=350');
                            return false;
                        });
                    } else {
                        $("#downlink").html("<%= Resources.Resource.lblRequestNow %>");
                        $("#downlink").attr("href", "https://showmypc.com/users/appbuilder/showmypcauto.php?at=&ci=trippeberatung&pr=1&tk=cbbf0d5f1a28");
                    }
                });
            </script>
        </telerik:RadCodeBlock>
        
        <style type="text/css">
            .auto-style1 {
            font-family: Arial, Helvetica, Sans-Serif;
            }
            .auto-style2 {
            font-size: small;
            }
            .auto-style3 {
            font-family: Arial, Helvetica, Sans-Serif;
            font-size: small;
            }
        </style>
    </head>
    
    <body>
        <form id="form1" runat="server">
            <table>
                <tr>
                    <td>
                        <div style="width: 300px;">
                            <img src="../../Resources/Images/logo_pco.png" />
                            <p>
                                <span class="auto-style3"> <strong>pco Personal Computer Organisation</strong></span>
                                <br class="auto-style3" />
                                <span class="auto-style3">GmbH & Co. KG</span> <br class="auto-style3" />
                                <span class="auto-style3">Hafenstrasse 11</span><br class="auto-style3" />
                                <span class="auto-style3">49090 Osnabrück</span><br class="auto-style3" />
                                <span class="auto-style3">Deutschland </span>
                            </p>
                            <table border="0" cellspacing="0" width="100%">
                                <tbody>
                                    <tr>
                                        <td align="left" class="auto-style3"><%= Resources.Resource.lblAddrPhone %></td>
                                        <td align="left" class="auto-style3">+49 541 6051501</td>
                                    </tr>
                                    <tr>
                                        <td class="auto-style3"><%= Resources.Resource.lblAddrEmail %></td>
                                        <td align="left" class="auto-style1">
                                            <a href="mailto:support@zbl-insite.com">
                                                <span class="auto-style2">Support</span>
                                            </a><span class="auto-style2"> </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <hr />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="auto-style3">
                                            <label style="font-weight: bold;"><%= Resources.Resource.lblRequestRemoteSupport %></label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="auto-style3">
                                            <label style="width: 300px;"><%= Resources.Resource.msgRequestRemoteSupport %></label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="auto-style3">
                                            <label>Download</label>
                                        </td>
                                        <td>
                                            <table style="background: url('http://showmypc.com/images/buttons/s2.png') no-repeat;width:154px;height:48px;">
                                                <tr>
                                                    <td align="center">
                                                        <a id="downlink" href="#" style="position:relative; left:22px; font-size: 12px; font-weight: normal; font-family: Tahoma; color: black; 
                                                           text-decoration:none; text-align:center;">
                                                            <label><%= Resources.Resource.lblRequestNow %></label>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="auto-style3">
                                            <label>Java</label>
                                        </td>
                                        <td>
                                            <a href="https://showmypc.com/mac/java-client.html?ci=trippeberatung&sh=0" onclick="window.open(this.href, 'window_name', 'width=550,height=350'); return false;">
                                                <div style="height:48px; width:155px; background-image: url(http://showmypc.com/images/buttons/s2.png);background-repeat: no-repeat;">
                                                    <div style="position: relative; top: 15px; left: 22px; font-size: 12px; font-weight: normal;
                                                         font-family: Tahoma; color: #000000; text-decoration:none; text-align:center;">
                                                        <label><%= Resources.Resource.lblRequestNow %></label>
                                                    </div>
                                                </div>
                                            </a>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        &nbsp;
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
