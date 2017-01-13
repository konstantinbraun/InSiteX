<%@ Page Title="<%$ Resources:Resource, lblContainermanagement%>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ContainerManagement.aspx.cs" Inherits="InSite.App.Views.Costumization.ContainerManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">

    <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="EmployeeExecute">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="LastResult" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="CompanyExecute">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="LastResult" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="TradeExecute">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="LastResult" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <table>
        <tr>
            <td>
                <strong><%= Resources.Resource.lblEmployee %></strong>
            </td>
        </tr>
        <tr>
            <td>
                <telerik:RadComboBox runat="server" ID="EmployeeID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                     DataValueField="EmployeeID" DataTextField="EmployeeName" Width="300" DataSourceID="SqlDataSource_Employees"
                                     Filter="Contains" AppendDataBoundItems="true" EnableLoadOnDemand="true" DropDownAutoWidth="Enabled">
                    <Items>
                        <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0" />
                    </Items>
                </telerik:RadComboBox>
            </td>
            <td>
                <asp:RadioButtonList ID="EmployeeAction" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table">
                    <asp:ListItem runat="server" Text="Insert" Value="16"></asp:ListItem>
                    <asp:ListItem runat="server" Text="Update" Value="17"></asp:ListItem>
                    <asp:ListItem runat="server" Text="Delete" Value="4"></asp:ListItem>
                </asp:RadioButtonList>
            </td>
            <td>
                <telerik:RadButton ID="EmployeeExecute" runat="server" Text="Execute" OnClick="EmployeeExecute_Click"></telerik:RadButton>
            </td>
        </tr>
        <tr>
            <td>

            </td>
        </tr>

        <tr>
            <td>
                <strong><%= Resources.Resource.lblCompany %></strong>
            </td>
        </tr>
        <tr>
            <td>
                <telerik:RadDropDownTree runat="server" ID="CompanyID" DataFieldParentID="ParentID" DataFieldID="CompanyID" 
                                         DataValueField="CompanyID" EnableFiltering="true" DataTextField="CompanyName" Width="300px" 
                                         DefaultMessage="<%$ Resources:Resource, msgPleaseSelect %>"
                                         DropDownSettings-AutoWidth="Enabled" 
                                         DataSourceID="SqlDataSource_Companies">
                    <ButtonSettings ShowClear="true" />
                    <FilterSettings Highlight="Matches" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" Filter="Contains" />
                    <DropDownSettings OpenDropDownOnLoad="false" CloseDropDownOnSelection="true" />
                </telerik:RadDropDownTree>
            </td>
            <td>
                <asp:RadioButtonList ID="CompanyAction" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table">
                    <asp:ListItem runat="server" Text="Insert" Value="16"></asp:ListItem>
                    <asp:ListItem runat="server" Text="Update" Value="17"></asp:ListItem>
                    <asp:ListItem runat="server" Text="Delete" Value="4"></asp:ListItem>
                </asp:RadioButtonList>
            </td>
            <td>
                <telerik:RadButton ID="CompanyExecute" runat="server" Text="Execute" OnClick="CompanyExecute_Click"></telerik:RadButton>
            </td>
        </tr>
        <tr>
            <td>

            </td>
        </tr>

        <tr>
            <td colspan="3">
                <strong><%= Resources.Resource.lblTrade %></strong>
            </td>
        </tr>
        <tr>
            <td>
                <telerik:RadComboBox runat="server" ID="TradeID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>"
                                     DataValueField="TradeID" DataTextField="TradeName" Width="300" DataSourceID="SqlDataSource_Trades"
                                     Filter="Contains" AppendDataBoundItems="true" EnableLoadOnDemand="true" DropDownAutoWidth="Enabled">
                    <Items>
                        <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0" />
                    </Items>
                </telerik:RadComboBox>
            </td>
            <td>
                <asp:RadioButtonList ID="TradeAction" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table">
                    <asp:ListItem runat="server" Text="Insert" Value="16"></asp:ListItem>
                    <asp:ListItem runat="server" Text="Update" Value="17"></asp:ListItem>
                    <asp:ListItem runat="server" Text="Delete" Value="4"></asp:ListItem>
                </asp:RadioButtonList>
            </td>
            <td>
                <telerik:RadButton ID="TradeExecute" runat="server" Text="Execute" OnClick="TradeExecute_Click"></telerik:RadButton>
            </td>
        </tr>
        <tr>
            <td>

            </td>
        </tr>

        <tr>
            <td colspan="3">
                <strong><%= Resources.Resource.lblLastResult %></strong>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <asp:Panel runat="server" ID="PanelLastResult">
                    <asp:Label runat="server" ID="LastResult"></asp:Label>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
                <telerik:RadButton runat="server" ID="TestGetAccessRights" OnClick="TestGetAccessRights_Click"></telerik:RadButton>
            </td>
        </tr>
    </table>

    <asp:SqlDataSource ID="SqlDataSource_Companies" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT c.SystemID, c.BpID, c.CompanyID, (CASE WHEN c.ParentID = 0 THEN NULL ELSE c.ParentID END) AS ParentID, c.NameVisible, c.NameAdditional, c.Description, c.AddressID, c.IsVisible, c.IsValid, c.TradeAssociation, c.BlnSOKA, c.CreatedFrom, c.CreatedOn, c.EditFrom, c.EditOn, a.Address1, a.Address2, a.Zip, a.City, a.State, a.CountryID, a.Phone, a.Email, a.WWW, c.NameVisible + (CASE WHEN c.NameAdditional IS NULL THEN '' ELSE ', ' + c.NameAdditional END) + (CASE WHEN a.City IS NULL THEN '' ELSE ', ' + a.City END) AS CompanyName FROM Master_Companies AS c LEFT OUTER JOIN System_Addresses AS a ON c.SystemID = a.SystemID AND c.AddressID = a.AddressID WHERE (c.SystemID = @SystemID) AND (c.BpID = @BpID) AND (c.ReleaseOn IS NOT NULL) AND (dbo.HasLockedMainContractor(c.SystemID, c.BpID, c.CompanyID) = 0) ORDER BY c.NameVisible">
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Trades" runat="server" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>' SelectCommand="SELECT t.TradeGroupID, t.TradeID, t.TradeNumber, t.NameVisible, t.DescriptionShort, m_tg.NameVisible + ' : ' + t.NameVisible AS TradeName FROM Master_Trades AS t INNER JOIN Master_TradeGroups AS m_tg ON t.SystemID = m_tg.SystemID AND t.BpID = m_tg.BpID AND t.TradeGroupID = m_tg.TradeGroupID WHERE (t.SystemID = @SystemID) AND (t.BpID = @BpID) ORDER BY m_tg.NameVisible, t.NameVisible">
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Employees" runat="server" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>' SelectCommand="SELECT Master_Employees.SystemID, Master_Employees.BpID, Master_Employees.EmployeeID, Master_Addresses.LastName + ', ' + Master_Addresses.FirstName + ' (' + Master_Companies.NameVisible + ')' AS EmployeeName FROM Master_Employees INNER JOIN Master_Addresses ON Master_Employees.SystemID = Master_Addresses.SystemID AND Master_Employees.BpID = Master_Addresses.BpID AND Master_Employees.AddressID = Master_Addresses.AddressID INNER JOIN Master_Companies ON Master_Employees.SystemID = Master_Companies.SystemID AND Master_Employees.BpID = Master_Companies.BpID AND Master_Employees.CompanyID = Master_Companies.CompanyID WHERE (Master_Employees.SystemID = @SystemID) AND (Master_Employees.BpID = @BpID) ORDER BY EmployeeName">
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

