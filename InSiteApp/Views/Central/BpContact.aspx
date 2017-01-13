<%@ Page Title="<%$ Resources:Resource, lblContact %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BpContact.aspx.cs" Inherits="InSite.App.Views.Central.BpContact" %>

<%@ Register Src="~/CustomControls/wcBpContact.ascx" TagPrefix="uc1" TagName="wcBpContact" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <div style ="padding: 10px">
        <asp:HyperLink ID="HyperLink1" runat="server" Text ="<%$ Resources:Resource, lblBuildingProject %>" NavigateUrl ="~/Views/Central/BuildingProjects.aspx" Font-Size ="Large"></asp:HyperLink> 
        <asp:Label ID="Label1" runat="server" Text="/" Font-Size ="Large"></asp:Label>
        <asp:Repeater ID="Repeater1" runat="server" DataSourceID="BuildingProjectDataSource">
            <ItemTemplate>
                <asp:Label ID="Label1" runat="server" Text='<%#Eval("NameVisible")%>' Font-Size ="X-Large"></asp:Label>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <div>
        <uc1:wcBpContact runat="server" ID="wcBpContact" />
    </div>
    <asp:ObjectDataSource ID="BuildingProjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetById" TypeName="InSite.App.BLL.dtoBuildingProject">
        <SelectParameters>
            <asp:QueryStringParameter Name="bpId" QueryStringField="id" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>
