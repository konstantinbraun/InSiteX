<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebCamTest.aspx.cs" Inherits="InSite.App.Views.Main.WebCamTest" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link href="/InSiteApp/Styles/DefaultStyleSheet.css" rel="stylesheet" type="text/css" />
        <link rel="shortcut icon" href="/InSiteApp/Resources/Images/favicon.ico" />
        <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%--        <script src="/InSiteApp/scripts.js" type="text/javascript"></script>--%>

        <title></title>

        <telerik:RadScriptBlock runat="server">
            <script type="text/javascript" src="ScriptCam/jquery.min.js"></script>
            <script type="text/javascript" src="ScriptCam/jquery.swfobject.1-1-1.min.js"></script>
            <script type="text/javascript" src="ScriptCam/scriptcam.js"></script>
            <!-- This is where we start customizing our webcam plugin -->
            <script type="text/javascript">
                $(document).ready(function () {
                    $("#webcam").scriptcam({
                                               appID: 'BB6EA93A-66',
                                               setVolume: 0,
                                               width: 320, //These are default values, you don't need to define unless you're not going to change,
                                               height: 240, //Thought decreasing width value too much may cause problems on work. I tried 240 min.
                                               showMicrophoneErrors: false,
                                               useMicrophone: false,
                                               onWebcamReady: onWebcamReady,
                                               noFlashFound: '<p><a href="http://www.adobe.com/go/getflashplayer">\nAdobe Flash Player</a> 11.7 or greater is needed to use your webcam.</p>'
                                           });
                    //This line helps us to hide the binary code text box.
                });
                
                function base64_tofield() {
                    $('#formfield').val($.scriptcam.getFrameAsBase64());
                };

                function base64_toimage() {
                    <%--                    document.getElementById('<%= imgBinary.ClientID %>').src = "data:image/png;base64," + $.scriptcam.getFrameAsBase64();--%>
                    document.getElementById('<%= txtImgBinary.ClientID %>').value = $.scriptcam.getFrameAsBase64();
                    document.getElementById('EditImage').click();
                    //var object = new ActiveXObject("Scripting.FileSystemObject");
                    //var file = object.CreateTextFile("C:\\Hello.txt", false);
                    //file.WriteLine($.scriptcam.getFrameAsBase64());
                    //file.Close();
                };
                
                function changeCamera() {
                    $.scriptcam.changeCamera($('#cameraNames').val());
                }
                
                function onWebcamReady(cameraNames, camera, microphoneNames, microphone, volume) {
                    $.each(cameraNames, function (index, text) {
                        $('#cameraNames').append($('<option></option>').val(index).html(text))
                    });
                    $('#cameraNames').val(camera);
                }
                
                function hideTheTextBox() {
                    document.getElementById('<%= txtImgBinary.ClientID %>').style.display = 'none';
                }
                
                function showTheTextBox() {
                    document.getElementById('<%= txtImgBinary.ClientID %>').style.display = 'none';
                }

                function cancelAndClose() {
                    if (document.getElementById('<%= txtImgBinary.ClientID %>').value !== '') {
                        GetRadWindow().close(document.getElementById('<%= txtImgBinary.ClientID %>').value);
                    } else {
                        GetRadWindow().close();
                    }
                }

                function GetRadWindow() {
                    var oWindow = null;
                    if (window.radWindow)
                        oWindow = window.radWindow;
                    else if (window.frameElement.radWindow)
                        oWindow = window.frameElement.radWindow;
                    return oWindow;
                }

                function AdjustRadWindow() {
                    var oWindow = GetRadWindow();
                    setTimeout(function () {
                        oWindow.autoSize(true);
                    }, 320);
                }

                function modifyCommand(imageEditor, args) {
                    if (args.get_commandName()) {
                        waitForCommand(imageEditor, args.get_commandName(), function (widget) {
                            var width = 187;
                            var height = 240;
                            var ratio = width / height;

                            //stop the aspect ratio constraint
                            widget._constraintBtn.set_checked(false); 
                            widget._setCropBoxRatio(null);
                            widget._sizeRatio = null;

                            widget._setCropBoxRatio(ratio);
                            widget._sizeRatio = ratio;
                            widget.set_width(width);
                            widget.set_height(height);
                            widget._constraintBtn.set_enabled(false);
                            widget._updateCropBoxFromControls();
                        });
                    }
                }

                function waitForCommand(imageEditor, commandName, callback) {
                    var timer = setInterval(function () {
                        var widget = imageEditor.get_currentToolWidget();
                        if (widget && widget.get_name() == commandName) {
                            clearInterval(timer);
                            callback(widget);
                        }
                    }, 100);
                }

                function OnClientLoad(sender, eventArgs) {
                    //executer la commende Crop
                    var imageEditor = $telerik.toImageEditor(sender);
                    imageEditor.fire("Crop", eventArgs);
                    var imageEditorId = imageEditor.get_id();
                    $('#' + imageEditorId + '_ToolsPanel').hide();
                }

                function applyModifications() {
                    var x = $find("<%=RadImageEditor1.ClientID %>");
                    var txtx = $("#<%=RadImageEditor1.ClientID %>_ToolsPanel_C_txtX").val();
                    var txty = $("#<%=RadImageEditor1.ClientID %>_ToolsPanel_C_txtY").val();
                    var txtWidth = $("#<%=RadImageEditor1.ClientID %>_ToolsPanel_C_txtWidth").val();
                    var txtHeight = $("#<%=RadImageEditor1.ClientID %>_ToolsPanel_C_txtHeight").val();
                    var xy = new Sys.UI.Bounds(
                        parseInt(txtx),
                        parseInt(txty),
                        parseInt(txtWidth),
                        parseInt(txtHeight));
                
                    x._cropImage(xy);
                    x.applyChangesOnServer();
                }

                (function () {
                    var $;
                    var demo = window.demo = window.demo || {};

                    demo.initialize = function () {
                        $ = $telerik.$;
                    };

                    window.validationFailed = function (radAsyncUpload, args) {
                        var $row = $(args.get_row());
                        var erorMessage = getErrorMessage(radAsyncUpload, args);
                        var span = createError(erorMessage);
                        $row.addClass("ruError");
                        $row.append(span);
                        var button = $find("<%= ButtonOK.ClientID %>");
                        button.set_enabled(false);
                        AdjustRadWindow();
                    }

                    function getErrorMessage(sender, args) {
                        var fileExtention = args.get_fileName().substring(args.get_fileName().lastIndexOf('.') + 1, args.get_fileName().length);
                        if (args.get_fileName().lastIndexOf('.') !== -1) {
                            if (sender.get_allowedFileExtensions().indexOf(fileExtention) === -1) {
                                return ("<%= Resources.Resource.msgFileTypeNotSupported %>");
                            } else {
                                return ('<%= String.Format(Resources.Resource.msgMaxFileLength, "2") %>');
                            }
                        } else {
                            return ("<%= Resources.Resource.msgFileExtensionIncorrect %>");
                        }
                    }
                
                    function createError(erorMessage) {
                        var input = '<br/><span class="ruErrorMessage">' + erorMessage + ' </span>';
                        return input;
                    }
                })();
                
                function OnClientFilesUploaded(sender, args) {
                    var button = $find("<%= ButtonOK.ClientID %>");
                    button.set_enabled(true);
                    document.getElementById("<%= ButtonDummy.ClientID %>").click();
                }
            </script>
            <!-- Here it ends -->
        </telerik:RadScriptBlock>
    </head>

    <body>
        <form id="form1" runat="server">

            <telerik:RadScriptManager ID="RadScriptManager2" runat="server" EnablePageMethods="false">
            </telerik:RadScriptManager>

            <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" EnablePageHeadUpdate="false">
                <AjaxSettings>
                    <telerik:AjaxSetting AjaxControlID="RadAjaxManager1">
                        <UpdatedControls>
                            <telerik:AjaxUpdatedControl ControlID="RadImageEditor1" />
                            <telerik:AjaxUpdatedControl ControlID="AsyncUpload1" />
                        </UpdatedControls>
                    </telerik:AjaxSetting>
                </AjaxSettings>
            </telerik:RadAjaxManager>

            <div>
                <table>
                    <tr>
                        <td>
                            <asp:Label runat="server" Text="<%$ Resources:Resource, lblLiveImage %>"></asp:Label>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            <asp:Label runat="server" Text="<%$ Resources:Resource, lblPhoto %>"></asp:Label>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr style="vertical-align: top;">
                        <td>
                            <div id="webcam"></div>
                            <br />
                            <div style="display:none;">
                                <asp:Button ID="EditImage" runat="server" OnClick="EditImage_Click" UseSubmitBehavior="false" />
                            </div>
                            <asp:Button ID="TakeSnapshot" runat="server" Text="<%$ Resources:Resource, lblActionCapture %>" OnClientClick="base64_toimage();
                                
                                        return false;" UseSubmitBehavior="false" />
                            <br />
                            <br />
                            <asp:Label runat="server" Text="<%$ Resources:Resource, lblInputDeviceSelect %>"></asp:Label>
                            <br />
                            <select id="cameraNames" name="D1" onchange="$.scriptcam.changeCamera($('#cameraNames').val());" size="1"></select>
                            <div style="display:none;">
                                <asp:TextBox ID="txtImgBinary" TextMode="MultiLine" runat="server"></asp:TextBox>
                            </div>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            <table>
                                <tr>
                                    <td>
                                        <asp:Panel runat="server" ID="EditPanel">
                                            <telerik:RadImageEditor ID="RadImageEditor1" runat="server" OnClientLoad="AdjustRadWindow" OnClientResizeEnd="AdjustRadWindow" 
                                                                    OnClientCommandExecuted="modifyCommand" AllowedSavingLocation="Server" CanvasMode="No" StatusBarMode="Bottom"
                                                                    OnClientImageLoad="OnClientLoad" OnImageLoading="RadImageEditor1_ImageLoading">
                                                <Tools>
                                                    <telerik:ImageEditorToolGroup>
                                                        <telerik:ImageEditorTool CommandName="Undo"></telerik:ImageEditorTool>
                                                        <telerik:ImageEditorTool CommandName="Redo"></telerik:ImageEditorTool>
                                                        <telerik:ImageEditorToolSeparator></telerik:ImageEditorToolSeparator>
                                                        <telerik:ImageEditorTool CommandName="Crop"></telerik:ImageEditorTool>
                                                    </telerik:ImageEditorToolGroup>
                                                </Tools>
                                            </telerik:RadImageEditor>
                                        </asp:Panel>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <telerik:RadAsyncUpload runat="server" ID="AsyncUpload1"
                                                                AllowedFileExtensions="JPG,PNG,GIF,jpg,jpeg,png,gif" MaxFileSize="2097152" MultipleFileSelection="Disabled" HideFileInput="true"
                                                                Localization-Select="<%$ Resources:Resource, lblLoadPhoto %>" MaxFileInputsCount="1" 
                                                                OnClientFileUploaded="OnClientFilesUploaded" OnClientValidationFailed="validationFailed">
                                            <FileFilters>
                                                <telerik:FileFilter Extensions="JPG,PNG,GIF,jpg,jpeg,png,gif" Description="<%$ Resources:Resource, lblImageFiles %>" />
                                            </FileFilters>
                                        </telerik:RadAsyncUpload>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Button ID="Crop" runat="server" Text="<%$ Resources:Resource, lblActionCut %>" OnClientClick="applyModifications();
                                        
                                                    return false;" UseSubmitBehavior="false"
                                                    Width="120px" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;
                        </td>
                        <td>
                            &nbsp;
                        </td>
                        <td align="right">
                            <telerik:RadButton ID="ButtonOK" Text="<%$ Resources:Resource, lblActionAccept %>" runat="server" Icon-PrimaryIconCssClass="rbOk" OnClick="OK_Click">
                            </telerik:RadButton>
                            <telerik:RadButton ID="ButtonCancel" Text="<%$ Resources:Resource, lblActionCancel %>" runat="server" CausesValidation="False" OnClick="Cancel_Click" 
                                               CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                            </telerik:RadButton>
                            <asp:Button ID="ButtonDummy" runat="server" onclick="ButtonDummy_Click" style="display: none;" />
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </div>

            <telerik:RadScriptBlock runat="server">
                <script type="text/javascript">
                    serverID("ajaxManagerID", "<%= RadAjaxManager1.ClientID %>");

                    Sys.Application.add_load(function () {
                        demo.initialize();
                    });
                </script>
            </telerik:RadScriptBlock>
        </form>
    </body>
</html>
