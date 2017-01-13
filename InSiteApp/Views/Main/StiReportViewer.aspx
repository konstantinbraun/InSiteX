<%@ Page Title="<%$ Resources:Resource, lblReports %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="StiReportViewer.aspx.cs" Inherits="InSite.App.Views.Main.StiReportViewer" %>

<%@ Register Assembly="Stimulsoft.Report.Web, Version=2016.2.0.0, Culture=neutral, PublicKeyToken=ebe6666cba19647a" Namespace="Stimulsoft.Report.Web" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <div style="margin:10px;">
        <fieldset style="margin-bottom: 10px; padding: 10px;">
            <legend><asp:Label ID="lblReportGroup" runat="server" Text="<%$ Resources:Resource, lblReports %>"></asp:Label></legend>
            <span style="margin-right: 60px;">
                <asp:Label ID="lblName" runat="server" Text="<%$ Resources:Resource, lblCostLocationNameVisible %>"></asp:Label>
            </span>
            <telerik:RadComboBox ID="RadComboBox1" runat="server" DataSourceID="ReportsDataSource" DataTextField="Name" DataValueField="Id" OnSelectedIndexChanged="RadComboBox1_SelectedIndexChanged" AutoPostBack ="true" AppendDataBoundItems="True" Width="220px">
                <Items>
                    <telerik:RadComboBoxItem  Value="0" Text="" />
                </Items>
            </telerik:RadComboBox>
        </fieldset>
        <asp:ObjectDataSource ID="ReportsDataSource" runat="server" DataObjectTypeName="InSite.App.Models.clsReport" DeleteMethod="Delete" InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" SelectMethod="GetReportsForProject" TypeName="InSite.App.BLL.dtoReport" UpdateMethod="Update" OnSelecting="ReportsDataSource_Selecting">
            <SelectParameters>
                <asp:SessionParameter Name="bpId" SessionField="BpId" Type="Int32" />
                <asp:Parameter Name="reportRoleId" Type="Int32" />
                <asp:Parameter Name="isAdmin" Type="Boolean" />
            </SelectParameters>
        </asp:ObjectDataSource>
        <fieldset style="padding-top: 10px;">
            <asp:Label ID="lblInfo" runat="server" Font-Bold="true"></asp:Label>
            <cc1:StiWebViewer ID="StiWebViewer1" runat="server" Visible ="false"  BorderStyle="Solid" BorderColor="#999999"  BorderWidth="1" />
        </fieldset>
    </div>
</asp:Content>
