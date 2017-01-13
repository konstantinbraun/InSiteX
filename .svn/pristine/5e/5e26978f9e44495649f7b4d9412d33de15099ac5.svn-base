<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="wcBpSwitcher.ascx.cs" Inherits="InSite.App.CustomControls.wcBpSwitcher" %>
      
<telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server">
    <fieldset style="margin:10px">
        <legend><asp:Label ID="lblCaption" runat="server"></asp:Label></legend>
        <telerik:RadListBox RenderMode="Lightweight" ID="RadListBoxAll" runat="server" Width="400px" Height="200px"
            SelectionMode="Multiple" AllowTransfer="True" TransferToID="RadListBoxSelected" AutoPostBackOnTransfer="True"
            DataKeyField="Key" DataValueField ="Key" DataTextField="Value" 
            AutoPostBackOnReorder="True" EnableDragAndDrop="True" OnTransferring="RadListBoxAll_Transferring">
        </telerik:RadListBox>
        <telerik:RadListBox RenderMode="Lightweight" ID="RadListBoxSelected" runat="server" Width="400px" Height="200px"
            SelectionMode="Multiple" AllowReorder="false" AutoPostBackOnReorder="true" EnableDragAndDrop="true"
            DataKeyField="Key" DataValueField ="Key" DataTextField="Value" OnTransferring="RadListBoxAll_Transferring" >
        </telerik:RadListBox>
    </fieldset>
</telerik:RadAjaxPanel>