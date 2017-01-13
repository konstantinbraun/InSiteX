<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CompanyDetails.ascx.cs" Inherits="InSite.App.Controls.CompanyDetails" %>

<asp:FormView ID="CompanyDetailsFormView" DataKeyNames="CompanyID" runat="server" BackColor="Transparent" BorderColor="Transparent">
    <ItemTemplate>
        <telerik:RadTabStrip ID="RadTabStrip1" runat="server" MultiPageID="RadMultiPage1" Align="Left" AutoPostBack="false" CausesValidation="false">
            <Tabs>
                <telerik:RadTab PageViewID="RadPageView1" ImageUrl="~/Resources/Icons/factory.png" Text="<%# Resources.Resource.lblGenerally %>" Selected="true" Font-Bold="true" Value="1" />
                <telerik:RadTab PageViewID="RadPageView2" ImageUrl="~/Resources/Icons/list-add-5.png" Text="<%# Resources.Resource.lblAdvanced %>" Font-Bold="true" Value="2" />
                <telerik:RadTab PageViewID="RadPageView3" ImageUrl="~/Resources/Icons/info.png" Text="<%# Resources.Resource.lblInfo %>" Font-Bold="true" Value="3" />
                <telerik:RadTab PageViewID="RadPageView4" ImageUrl="~/Resources/Icons/Contract.png" Text="<%# Resources.Resource.lblTariffContracts %>" Font-Bold="true" Value="4" />
                <telerik:RadTab PageViewID="RadPageView5" ImageUrl="~/Resources/Icons/emblem-development.png" Text="<%# Resources.Resource.lblTrades %>" Font-Bold="true" Value="5" />
                <telerik:RadTab PageViewID="RadPageView6" ImageUrl="~/Resources/Icons/criteria.png" Text="<%# Resources.Resource.lblOtherCriterias %>" Font-Bold="true" Value="6" />
            </Tabs>
        </telerik:RadTabStrip>

        <telerik:RadMultiPage ID="RadMultiPage1" runat="server" RenderSelectedPageOnly="false">
            <%-- Generally --%>
            <telerik:RadPageView ID="RadPageView1" runat="server" Selected="true">
                <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                    <table id="Table2" cellspacing="0" cellpadding="2" border="0" rules="none" style="vertical-align: top; border-style: none;">
                        <tr>
                            <td style="vertical-align: top;">
                                <table id="Table3" cellspacing="0" cellpadding="2" border="0" style="vertical-align: top; border-style: none;">
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label1" Text='<%# String.Concat(Resources.Resource.lblID, ":") %>'
                                                       ></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="CompanyID" Text='<%# Eval("CompanyID") %>'
                                                       ></asp:Label>
                                            <asp:HiddenField ID="StatusID" runat="server" Value='<%# Eval("StatusID") %>'></asp:HiddenField>
                                            <asp:HiddenField runat="server" ID="ParentID" Value="0"></asp:HiddenField>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label15" Text='<%# String.Concat(Resources.Resource.lblNameVisible, ":") %>'
                                                       ></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="NameVisible" Text='<%# Eval("NameVisible") %>'
                                                       ></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label16" Text='<%# String.Concat(Resources.Resource.lblNameAdditional, ":") %>'
                                                       ></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="NameAdditional" Text='<%# Eval("NameAdditional") %>'
                                                       ></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td>
                                            <asp:HiddenField ID="AddressID" runat="server" Value='<%# Eval("AddressID") %>'></asp:HiddenField>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label17" Text='<%# String.Concat(Resources.Resource.lblAddress1, ":") %>'
                                                       ></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="Address1" Text='<%# Eval("Address1") %>'
                                                       ></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label18" Text='<%# String.Concat(Resources.Resource.lblAddress2, ":") %>'
                                                       ></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="Address2" Text='<%# Eval("Address2") %>'
                                                       ></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label19" Text='<%# String.Concat(Resources.Resource.lblAddrZip, ":") %>'
                                                       ></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="Zip" Text='<%# Eval("Zip") %>'
                                                       ></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label20" Text='<%# String.Concat(Resources.Resource.lblAddrCity, ":") %>'
                                                       ></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="City" Text='<%# Eval("City") %>'
                                                       ></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label21" Text='<%# String.Concat(Resources.Resource.lblAddrState, ":") %>'
                                                       ></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="State" Text='<%# Eval("State") %>'
                                                       ></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label22" Text='<%# String.Concat(Resources.Resource.lblCountry, ":") %>'
                                                       ></asp:Label>
                                        </td>
                                        <td>
                                            <telerik:RadComboBox runat="server" ID="CountryID" EmptyMessage="<%= Resources.Resource.msgPleaseTypeHere %>" DataSourceID="SqlDataSource_Countries"
                                                                 DataValueField="CountryID" DataTextField="CountryName" Width="300" Filter="Contains" SelectedValue='<%# Eval("CountryID") %>'
                                                                 AppendDataBoundItems="true" DropDownAutoWidth="Enabled" Enabled="false"
                                                                 >
                                                <ItemTemplate>
                                                    <table cellpadding="5px" style="text-align: left;">
                                                        <tr>
                                                            <td style="background-color: #EFEFEF; text-align: left;">
                                                                <asp:Image ID="ItemImage" ImageUrl='<%# String.Format("~/Resources/Icons/Flags/{0}", Eval("FlagName"))%>' runat="server" />
                                                            </td>
                                                            <td style="text-align: left;">
                                                                <asp:Label ID="ItemName" Text='<%# Eval("CountryID") %>' runat="server">
                                                                </asp:Label>
                                                            </td>
                                                            <td style="text-align: left;">
                                                                <asp:Label ID="ItemDescr" Text='<%# Eval("CountryName") %>' runat="server">
                                                                </asp:Label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ItemTemplate>
                                                <Items>
                                                    <telerik:RadComboBoxItem Text="<%= Resources.Resource.selNoSelection %>" Value="0"/>
                                                </Items>
                                            </telerik:RadComboBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label23" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ":") %>'
                                                       ></asp:Label>
                                        </td>
                                        <td>
                                        <asp:Label runat="server" ID="Phone1" Text='<%# Eval("Phone") %>'
                                                   ></asp:Label>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label24" Text='<%# String.Concat(Resources.Resource.lblAddrEmail, ":") %>'
                                                       ></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="Email1" Text='<%# Eval("Email") %>'
                                                       ></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label25" Text='<%# String.Concat(Resources.Resource.lblAddrWWW, ":") %>'
                                                       ></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="WWW" Text='<%# Eval("WWW") %>'
                                                       ></asp:Label>
                                        </td>
                                    </tr>

                                </table>
                            </td>
                            <td style="vertical-align: top;">&nbsp; </td>
                        </tr>
                    </table>
                </div>
            </telerik:RadPageView>

            <%-- Advanced --%>
            <telerik:RadPageView ID="RadPageView2" runat="server">
                <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                    <table id="Table4" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top; text-align: left;">
                        <tr>
                            <td style="vertical-align: top;">
                                <table id="Table5" cellspacing="2" cellpadding="2" border="0" style="vertical-align: top; text-align: left;">
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label26" Text='<%# String.Concat(Resources.Resource.lblNameVisible, ":") %>'
                                                       ></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="RadTextBox1" Text='<%# Eval("NameVisible") %>' Width="300px"
                                                       ></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label27" Text='<%# String.Concat(Resources.Resource.lblNameAdditional, ":") %>'
                                                       ></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="Label1NameAdditional" Text='<%# Eval("NameAdditional") %>' Width="300px"
                                                       ></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td>&nbsp; </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap">
                                            <asp:Label runat="server" ID="LabelDescription" Text='<%# String.Concat(Resources.Resource.lblRemarks, ":") %>'></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="Description" Text='<%# Eval("Description") %>' Width="100%" Height="60px" Wrap="true"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap">
                                            <asp:Label runat="server" ID="LabelTradeAssociation" Text='<%# String.Concat(Resources.Resource.lblTradeAssociation, ":") %>'></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" ID="TradeAssociation" Text='<%# Eval("TradeAssociation") %>' Width="300px"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap">
                                            <asp:Label runat="server" ID="LabelIsPartner" Text='<%# String.Concat(Resources.Resource.lblIsPartner, ":") %>'></asp:Label>
                                        </td>
                                        <td >
                                            <asp:CheckBox CssClass="cb" runat="server" ID="IsPartner" Enabled="false" Checked='<%# Eval("IsPartner") %>'></asp:CheckBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap">
                                            <asp:Label runat="server" ID="LabelBlnSOKA" Text='<%# String.Concat(Resources.Resource.lblBlnSOKA, ":") %>'></asp:Label>
                                        </td>
                                        <td>
                                            <asp:CheckBox CssClass="cb" runat="server" ID="BlnSOKA" Enabled="false" Checked='<%# Eval("BlnSOKA") %>'></asp:CheckBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap">
                                            <asp:Label runat="server" ID="LabelMinWageAttestation" Text='<%# String.Concat(Resources.Resource.lblMinWageAttestation, ":") %>'></asp:Label>
                                        </td>
                                        <td>
                                            <asp:CheckBox CssClass="cb" runat="server" ID="MinWageAttestation" Enabled="false" Checked='<%# Eval("MinWageAttestation") %>' ></asp:CheckBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap">
                                            <asp:Label runat="server" ID="LabelAllowSubcontractorEdit" Text='<%# String.Concat(Resources.Resource.lblAllowSubcontractorEdit, ":") %>' 
                                                ToolTip="<%# Resources.Resource.ttAllowSubcontractorEdit %>"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:CheckBox CssClass="cb" runat="server" ID="AllowSubcontractorEdit" ToolTip="<%# Resources.Resource.ttAllowSubcontractorEdit %>" 
                                                Checked='<%# Eval("AllowSubcontractorEdit") %>' Enabled="false"></asp:CheckBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap">
                                            <asp:Label runat="server" ID="LabelRegistrationCode" Text='<%# String.Concat(Resources.Resource.lblRegistrationCode, ":") %>' 
                                                       ></asp:Label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <asp:Label runat="server" ID="RegistrationCode" Text='<%# Eval("RegistrationCode") %>' Width="124px"></asp:Label>&nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap">
                                            <asp:Label runat="server" ID="LabelCodeValidUntil" Text='<%# String.Concat(Resources.Resource.lblCodeValidUntil, ":") %>' 
                                                       ></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="CodeValidUntil" runat="server" Text='<%# Eval("CodeValidUntil") %>'>
                                            </asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap">
                                            <asp:Label runat="server" ID="LabelPassBudget" Text='<%# String.Concat(Resources.Resource.lblPassBudget, ":") %>'></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="PassBudget" runat="server" Text='<%# Eval("PassBudget", "{0:#,##0.00}") %>'>
                                            </asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td>&nbsp; </td>
                                    </tr>

                                </table>
                            </td>
                            <td style="vertical-align: top;">&nbsp; </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap" align="left" colspan="2">
                                <asp:Label runat="server" ID="LabelRadGridContacts" Text='<%# String.Concat(Resources.Resource.lblContact, ":") %>' ></asp:Label>
                                <telerik:RadGrid ID="RadGridContacts" runat="server" DataSourceID="SqlDataSourceContacts"
                                                 CssClass="RadGrid" AllowAutomaticDeletes="false" AllowAutomaticInserts="false" AllowAutomaticUpdates="false">

                                    <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false">
                                        <Resizing AllowColumnResize="true"></Resizing>
                                        <Selecting AllowRowSelect="True" />
                                        <ClientEvents OnRowClick="OnRowClick" />
                                    </ClientSettings>

        <SortingSettings SortedBackColor="Transparent" />

                                    <MasterTableView DataKeyNames="SystemID,BpID,CompanyID,ContactID" DataSourceID="SqlDataSourceContacts" AutoGenerateColumns="False" 
                                                     EditMode="EditForms" CssClass="MasterClass" CommandItemDisplay="None" AllowPaging="true" AllowSorting="true" 
                                                     AllowMultiColumnSorting="true" PageSize="5">

                                        <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="false" PageSizes="5,10,50" />

                                        <SortExpressions>
                                            <telerik:GridSortExpression FieldName="LastName" SortOrder="Ascending"></telerik:GridSortExpression>
                                            <telerik:GridSortExpression FieldName="FirstName" SortOrder="Ascending"></telerik:GridSortExpression>
                                        </SortExpressions>

                                        <Columns>
                                            <telerik:GridTemplateColumn DataField="ContactID" Visible="false" DataType="System.Int32" FilterControlAltText="Filter ContactID column" 
                                                                        HeaderText="<%= Resources.Resource.lblID %>" SortExpression="ContactID" UniqueName="ContactID" 
                                                                        GroupByExpression="ContactID ContactID GROUP BY ContactID" HeaderStyle-HorizontalAlign="Right">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="ContactID" Text='<%# Eval("ContactID") %>'></asp:Label>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>

                                            <telerik:GridTemplateColumn DataField="DescriptionShort" FilterControlAltText="Filter DescriptionShort column" HeaderText="<%= Resources.Resource.lblTopic %>"
                                                                        SortExpression="DescriptionShort" UniqueName="DescriptionShort" GroupByExpression="DescriptionShort DescriptionShort GROUP BY DescriptionShort">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="LabelDescriptionShort" Text='<%# Eval("DescriptionShort") %>'></asp:Label>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>

                                            <telerik:GridTemplateColumn DataField="Salutation" HeaderText="<%= Resources.Resource.lblAddrSalutation %>" SortExpression="Salutation" UniqueName="Salutation"
                                                                        GroupByExpression="Salutation Salutation GROUP BY Salutation" Visible="false">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="Salutation" Text='<%# Eval("Salutation") %>'></asp:Label>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>

                                            <telerik:GridTemplateColumn DataField="LastName" HeaderText="<%= Resources.Resource.lblAddrLastName %>" SortExpression="LastName" UniqueName="LastName"
                                                                        GroupByExpression="LastName LastName GROUP BY LastName">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="LastName" Text='<%# Eval("LastName") %>'></asp:Label>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>

                                            <telerik:GridTemplateColumn DataField="FirstName" HeaderText="<%= Resources.Resource.lblAddrFirstName %>" SortExpression="FirstName" UniqueName="FirstName"
                                                                        GroupByExpression="FirstName FirstName GROUP BY FirstName">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="FirstName" Text='<%# Eval("FirstName") %>'></asp:Label>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>

                                            <telerik:GridTemplateColumn DataField="Phone" HeaderText="<%= Resources.Resource.lblAddrPhone %>" SortExpression="Phone" UniqueName="Phone"
                                                                        GroupByExpression="Phone Phone GROUP BY Phone">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="Phone" Text='<%# Eval("Phone") %>'></asp:Label>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>

                                            <telerik:GridTemplateColumn DataField="Mobile" HeaderText="<%= Resources.Resource.lblAddrMobile %>" SortExpression="Mobile" UniqueName="Mobile"
                                                                        GroupByExpression="Mobile Mobile GROUP BY Mobile">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="Mobile" Text='<%# Eval("Mobile") %>'></asp:Label>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>

                                            <telerik:GridTemplateColumn DataField="Email" HeaderText="<%= Resources.Resource.lblAddrEmail %>" SortExpression="Email" UniqueName="Email"
                                                                        GroupByExpression="LastName LastName GROUP BY LastName">
                                                <EditItemTemplate>
                                                    <telerik:RadTextBox runat="server" ID="Email" Text='<%# Eval("Email") %>' Width="300px"></telerik:RadTextBox>
                                                </EditItemTemplate>
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="Email" Text='<%# Eval("Email") %>'></asp:Label>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>

                                            <telerik:GridTemplateColumn DataField="CreatedFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedFrom column" 
                                                                        HeaderText="<%= Resources.Resource.lblCreatedFrom %>" SortExpression="CreatedFrom" UniqueName="CreatedFrom" Visible="False">
                                                <ItemTemplate>
                                                    <asp:Label ID="CreatedFromLabel" runat="server" Text='<%# Eval("CreatedFrom")%>'></asp:Label>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>

                                            <telerik:GridTemplateColumn DataField="CreatedOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedOn column" 
                                                                        HeaderText="<%= Resources.Resource.lblCreatedOn %>" SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="False">
                                                <ItemTemplate>
                                                    <asp:Label ID="CreatedOnLabel" runat="server" Text='<%# Eval("CreatedOn")%>'></asp:Label>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>

                                            <telerik:GridTemplateColumn DataField="EditFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditFrom column" 
                                                                        HeaderText="<%= Resources.Resource.lblEditFrom %>" SortExpression="EditFrom" UniqueName="EditFrom" Visible="False">
                                                <ItemTemplate>
                                                    <asp:Label ID="EditFromLabel" runat="server" Text='<%# Eval("EditFrom")%>'></asp:Label>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>

                                            <telerik:GridTemplateColumn DataField="EditOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditOn column" 
                                                                        HeaderText="<%= Resources.Resource.lblEditOn %>" SortExpression="EditOn" UniqueName="EditOn" Visible="False">
                                                <ItemTemplate>
                                                    <asp:Label ID="EditOnLabel" runat="server" Text='<%# Eval("EditOn") %>'></asp:Label>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>

                <telerik:GridButtonColumn UniqueName="deleteColumn" Visible="true" ConfirmText="<%= Resources.Resource.qstDeleteRow %>" Text="<%= Resources.Resource.lblActionDelete %>" 
                                          ConfirmDialogType="RadWindow"
                                          ConfirmTitle="<%= Resources.Resource.lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                    <ItemStyle BackColor="Control" />
                </telerik:GridButtonColumn>
                                        </Columns>
                                    </MasterTableView>
                                </telerik:RadGrid>
                            </td>
                        </tr>
                    </table>
                </div>

                <asp:SqlDataSource ID="SqlDataSourceContacts" runat="server" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                                   SelectCommand="SELECT * FROM [Master_CompanyContacts] WHERE (([SystemID] = @SystemID) AND ([BpID] = @BpID) AND ([CompanyID] = @CompanyID)) ORDER BY [LastName], [FirstName]" >
                    <SelectParameters>
                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
                        <asp:ControlParameter ControlID="CompanyID" PropertyName="Text" DefaultValue="0" Name="CompanyID" Type="Int32"></asp:ControlParameter>
                    </SelectParameters>
                </asp:SqlDataSource>
            </telerik:RadPageView>

            <%-- Info --%>
            <telerik:RadPageView ID="RadPageView3" runat="server">
                <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                    <table id="Table10" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="Label2" Text='<%# String.Concat(Resources.Resource.lblNameVisible, ":") %>'
                                           ></asp:Label>
                            </td>
                            <td>
                                <asp:Label runat="server" ID="Label3" Text='<%# Eval("NameVisible") %>' Width="300px"
                                           ></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="Label28" Text='<%# String.Concat(Resources.Resource.lblNameAdditional, ":") %>'
                                           ></asp:Label>
                            </td>
                            <td>
                                <asp:Label runat="server" ID="Label29" Text='<%# Eval("NameAdditional") %>' Width="300px"
                                           ></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp; </td>
                            <td>&nbsp; </td>
                        </tr>
                        <tr>
                            <td>
                                <%# Resources.Resource.lblClient %>:
                            </td>
                            <td>
                                <asp:Label runat="server" ID="Client" Text='<%# Eval("ParentNameVisible") %>' Width="300px"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <%# Resources.Resource.lblAddition %>:
                            </td>
                            <td>
                                <asp:Label runat="server" ID="Addition" Text='<%# Eval("ParentNameAdditional") %>' Width="300px"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <%# Resources.Resource.lblSubcontratorDirect %>:
                            </td>
                            <td>
                                <asp:Label runat="server" ID="SubcontratorDirect" Text="0"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <%# Resources.Resource.lblSubcontractorTotal %>:
                            </td>
                            <td>
                                <asp:Label runat="server" ID="SubcontractorTotal" Text="0"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <%# Resources.Resource.lblEmployeesDirect %>:
                            </td>
                            <td>
                                <asp:Label runat="server" ID="EmployeesDirect" Text="0"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <%# Resources.Resource.lblEmployeesTotal %>:
                            </td>
                            <td>
                                <asp:Label runat="server" ID="EmployeesTotal" Text="0"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp; </td>
                            <td>&nbsp; </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server"  Text='<%# String.Concat(Resources.Resource.lblCreatedFrom, ":") %>'></asp:Label>
                            </td>
                            <td>
                                <asp:Label runat="server"  Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server"  Text='<%# String.Concat(Resources.Resource.lblCreatedOn, ":") %>'></asp:Label>
                            </td>
                            <td>
                                <asp:Label runat="server"  Text='<%# Eval("CreatedOn") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server"  Text='<%# String.Concat(Resources.Resource.lblEditFrom, ":") %>'></asp:Label>
                            </td>
                            <td>
                                <asp:Label runat="server"  Text='<%# Eval("EditFrom")%>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server"  Text='<%# String.Concat(Resources.Resource.lblEditOn, ":") %>'></asp:Label>
                            </td>
                            <td>
                                <asp:Label runat="server"  Text='<%# Eval("EditOn")%>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td><%= Resources.Resource.lblRequestFrom %>: </td>
                            <td>
                                <asp:Label Text='<%# Eval("RequestFrom") %>' runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td><%= Resources.Resource.lblRequestOn %>: </td>
                            <td>
                                <asp:Label Text='<%# Eval("RequestOn") %>' runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td><%= Resources.Resource.lblReleaseFrom %>: </td>
                            <td>
                                <asp:Label ID="ReleaseFrom" Text='<%# Eval("ReleaseFrom") %>' runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td><%= Resources.Resource.lblReleaseOn %>: </td>
                            <td>
                                <asp:Label ID="ReleaseOn" Text='<%# Eval("ReleaseOn") %>' runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td><%= Resources.Resource.lblLockedFrom %>: </td>
                            <td>
                                <asp:Label ID="LockedFrom" Text='<%# Eval("LockedFrom") %>' runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td><%= Resources.Resource.lblLockedOn %>: </td>
                            <td>
                                <asp:Label ID="LockedOn" Text='<%# Eval("LockedOn") %>' runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap">
                                <asp:Label runat="server" ID="LabelLockSubContractors" Text='<%# String.Concat(Resources.Resource.lblLockSubContractors, ":") %>'></asp:Label>
                            </td>
                            <td>
                                <asp:CheckBox ID="LockSubContractors" runat="server" CssClass="cb" Checked='<%# Eval("LockSubContractors") %>' Enabled="false" />
                            </td>
                        </tr>
                    </table>
                </div>
            </telerik:RadPageView>

            <%-- Tariff Contracts --%>
            <telerik:RadPageView ID="RadPageView4" runat="server">
                <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                    <table id="Table6" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                        <tr>
                            <td>
                                <asp:HiddenField ID="CompanyID1" runat="server" Value='<%# Eval("CompanyID") %>'></asp:HiddenField>
                                <%# Resources.Resource.lblNameVisible %>:
                            </td>
                            <td>
                                <asp:Label runat="server" ID="Label4" Text='<%# Eval("NameVisible") %>' Width="300px"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <%# Resources.Resource.lblNameAdditional %>:
                            </td>
                            <td>
                                <asp:Label runat="server" ID="Label5" Text='<%# Eval("NameAdditional") %>' Width="300px"></asp:Label>
                            </td>
                        </tr>
                    </table>

                    <br />
                    <asp:Label runat="server" ID="LabelRadGridTariffs" Text='<%# String.Concat(Resources.Resource.lblTariffContracts, ":") %>'></asp:Label>
                    <br />
                    <telerik:RadGrid ID="RadGridTariffs" runat="server" DataSourceID="SqlDataSource_CompanyTariffs" EnableLinqExpressions="false" EnableHierarchyExpandAll="true"
                                     CssClass="RadGrid" AllowAutomaticDeletes="false" AllowAutomaticInserts="false" AllowAutomaticUpdates="false">

                        <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false">
                            <Resizing AllowColumnResize="true"></Resizing>
                            <Selecting AllowRowSelect="True" />
                            <ClientEvents OnRowClick="OnRowClick" />
                        </ClientSettings>

        <SortingSettings SortedBackColor="Transparent" />

                        <MasterTableView DataSourceID="SqlDataSource_CompanyTariffs" DataKeyNames="SystemID,BpID,TariffScopeID,CompanyID" EnableHierarchyExpandAll="true" 
                                         AutoGenerateColumns="False" CommandItemDisplay="None" HierarchyLoadMode="Conditional" AllowMultiColumnSorting="true" AllowPaging="true" 
                                         CssClass="MasterClass" EditMode="EditForms">

                            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="false" PageSizes="10,20,50" />

                            <%-- Tariff Scope Details--%>
                            <NestedViewTemplate>
                                <fieldset style="padding: 10px; width: 500px; margin-left: 10px; margin-bottom: 10px;">
                                    <legend style="padding: 5px; background-color: transparent;">
                                        <b><%= Resources.Resource.lblDetailsFor%> <%# Eval("NameVisible") %></b>
                                    </legend>
                                    <table style="width: 100%;">
                                        <tr>
                                            <td><%= Resources.Resource.lblTariff%>: </td>
                                            <td>
                                                <asp:Label Text='<%#Eval("NameVisibleTariff")%>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><%= Resources.Resource.lblTariffContract%>: </td>
                                            <td>
                                                <asp:Label Text='<%#Eval("NameVisibleContract")%>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><%= Resources.Resource.lblTariffScope%>: </td>
                                            <td>
                                                <asp:Label Text='<%#Eval("NameVisible")%>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><%= Resources.Resource.lblDescriptionShort%>: </td>
                                            <td>
                                                <asp:Label Text='<%#Eval("DescriptionShort")%>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><%= Resources.Resource.lblValidFrom%>: </td>
                                            <td>
                                                <asp:Label Text='<%#Eval("ValidFrom")%>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td><%= Resources.Resource.lblCreatedFrom%>: </td>
                                            <td>
                                                <asp:Label Text='<%#Eval("CreatedFrom")%>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><%= Resources.Resource.lblCreatedOn%>: </td>
                                            <td>
                                                <asp:Label Text='<%#Eval("CreatedOn")%>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><%= Resources.Resource.lblEditFrom%>: </td>
                                            <td>
                                                <asp:Label Text='<%#Eval("EditFrom")%>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><%= Resources.Resource.lblEditOn%>: </td>
                                            <td>
                                                <asp:Label Text='<%#Eval("EditOn")%>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </NestedViewTemplate>

                            <%-- Scope Columns --%>
                            <Columns>
                                <telerik:GridTemplateColumn DataField="TariffScopeID" DataType="System.Int32" Visible="false" FilterControlAltText="Filter TariffScopeID column" HeaderText="<%= Resources.Resource.lblTariffScope %>"
                                                            SortExpression="TariffScopeID" UniqueName="TariffScopeID" InsertVisiblityMode="AlwaysVisible">
                                    <ItemTemplate>
                                        <telerik:RadDropDownList ID="RadDropDownList4" runat="server" SelectedValue='<%# Eval("TariffScopeID") %>' DataSourceID="SqlDataSource_TariffScopes"
                                                                 DataTextField="NameVisible" DataValueField="TariffScopeID" DropDownHeight="400px" EnableVirtualScrolling="false"
                                                                 DropDownWidth="700px" Width="300px">
                                            <ItemTemplate>
                                                <table cellpadding="5px" style="text-align: left;">
                                                    <tr>
                                                        <td style="text-align: left;">
                                                            <asp:Label ID="Label10" Text='<%# Eval("TariffNameVisible") %>' runat="server">
                                                            </asp:Label>
                                                        </td>
                                                        <td style="text-align: left;">
                                                            <asp:Label ID="Label11" Text='<%# Eval("ContractNameVisible") %>' runat="server">
                                                            </asp:Label>
                                                        </td>
                                                        <td style="text-align: left;">
                                                            <asp:Label ID="Label12" Text='<%# Eval("ValidFrom", "{0:d}") %>' runat="server">
                                                            </asp:Label>
                                                        </td>
                                                        <td style="text-align: left;">
                                                            <asp:Label ID="Label13" Text='<%# Eval("ValidTo", "{0:d}") %>' runat="server">
                                                            </asp:Label>
                                                        </td>
                                                        <td style="text-align: left;">
                                                            <asp:Label ID="ItemNameVisible" Text='<%# Eval("NameVisible") %>' runat="server">
                                                            </asp:Label>
                                                        </td>
                                                        <td style="text-align: left;">
                                                            <asp:Label ID="ItemDescriptionShort" Text='<%# Eval("DescriptionShort") %>' runat="server">
                                                            </asp:Label>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </ItemTemplate>
                                            <Items>
                                                <telerik:DropDownListItem Text="<%= Resources.Resource.selNoSelection %>" Value="0"/>
                                            </Items>
                                        </telerik:RadDropDownList>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>

                                <telerik:GridTemplateColumn DataField="NameVisibleTariff" HeaderText="<%= Resources.Resource.lblTariff %>" SortExpression="NameVisibleTariff"
                                                            UniqueName="NameVisibleTariff" GroupByExpression="NameVisibleTariff NameVisibleTariff GROUP BY NameVisibleTariff" InsertVisiblityMode="AlwaysHidden">
                                    <ItemTemplate>
                                        <asp:Label runat="server" ID="NameVisibleTariff" Text='<%# Eval("NameVisibleTariff") %>'></asp:Label>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>

                                <telerik:GridTemplateColumn DataField="NameVisibleContract" HeaderText="<%= Resources.Resource.lblTariffContract %>" SortExpression="NameVisibleContract"
                                                            UniqueName="NameVisibleContract" GroupByExpression="NameVisibleContract NameVisibleContract GROUP BY NameVisibleContract" InsertVisiblityMode="AlwaysHidden">
                                    <ItemTemplate>
                                        <asp:Label runat="server" ID="NameVisibleContract" Text='<%# Eval("NameVisibleContract") %>'></asp:Label>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>

                                <telerik:GridTemplateColumn DataField="NameVisible" HeaderText="<%= Resources.Resource.lblTariffScope %>" SortExpression="NameVisible" UniqueName="NameVisible1"
                                                            GroupByExpression="NameVisible NameVisible GROUP BY NameVisible" InsertVisiblityMode="AlwaysHidden">
                                    <ItemTemplate>
                                        <asp:Label runat="server" ID="NameVisible1" Text='<%# Eval("NameVisible") %>'></asp:Label>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>

                                <telerik:GridTemplateColumn DataField="DescriptionShort" FilterControlAltText="Filter DescriptionShort column" HeaderText="<%= Resources.Resource.lblDescriptionShort %>"
                                                            SortExpression="DescriptionShort" UniqueName="DescriptionShort" InsertVisiblityMode="AlwaysHidden"
                                                            GroupByExpression="DescriptionShort DescriptionShort GROUP BY DescriptionShort">
                                    <ItemTemplate>
                                        <asp:Label runat="server" ID="LabelDescriptionShort1" Text='<%# Eval("DescriptionShort") %>'></asp:Label>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>

                                <telerik:GridTemplateColumn DataField="ValidFrom" DataType="System.DateTime" FilterControlAltText="Filter ValidFrom column" HeaderText="<%= Resources.Resource.lblValidFrom %>"
                                                            SortExpression="ValidFrom" UniqueName="ValidFrom" GroupByExpression="ValidFrom ValidFrom GROUP BY ValidFrom">
                                    <ItemTemplate>
                                        <asp:Label runat="server" ID="LabelValidFrom" Text='<%# Eval("ValidFrom", "{0:d}") %>'></asp:Label>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>

                                <telerik:GridTemplateColumn DataField="CreatedFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedFrom column"
                                                            HeaderText="<%= Resources.Resource.lblCreatedFrom %>" SortExpression="CreatedFrom" UniqueName="CreatedFrom" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="CreatedFromLabel1" runat="server" Text='<%# Eval("CreatedFrom")%>'></asp:Label>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>

                                <telerik:GridTemplateColumn DataField="CreatedOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedOn column"
                                                            HeaderText="<%= Resources.Resource.lblCreatedOn %>" SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="CreatedOnLabel1" runat="server" Text='<%# Eval("CreatedOn")%>'></asp:Label>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>

                                <telerik:GridTemplateColumn DataField="EditFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditFrom column"
                                                            HeaderText="<%= Resources.Resource.lblEditFrom %>" SortExpression="EditFrom" UniqueName="EditFrom" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="EditFromLabel1" runat="server" Text='<%# Eval("EditFrom")%>'></asp:Label>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>

                                <telerik:GridTemplateColumn DataField="EditOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditOn column"
                                                            HeaderText="<%= Resources.Resource.lblEditOn %>" SortExpression="EditOn" UniqueName="EditOn" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="EditOnLabel1" runat="server" Text='<%# Eval("EditOn") %>'></asp:Label>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                            </Columns>

                        </MasterTableView>

                    </telerik:RadGrid>

                    <asp:SqlDataSource ID="SqlDataSource_TariffScopes" runat="server" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                                       SelectCommand="SELECT t.NameVisible AS TariffNameVisible, c.NameVisible AS ContractNameVisible, c.ValidFrom, c.ValidTo, s.NameVisible, s.DescriptionShort, s.TariffScopeID FROM System_Tariffs AS t INNER JOIN System_TariffContracts AS c ON t.SystemID = c.SystemID AND t.TariffID = c.TariffID INNER JOIN System_TariffScopes AS s ON c.SystemID = s.SystemID AND c.TariffID = s.TariffID AND c.TariffContractID = s.TariffContractID WHERE t.SystemID = @SystemID ORDER BY TariffNameVisible, ContractNameVisible, s.NameVisible">
                        <SelectParameters>
                            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                        </SelectParameters>
                    </asp:SqlDataSource>

                    <asp:SqlDataSource runat="server" ID="SqlDataSource_CompanyTariffs" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                                       SelectCommand="SELECT ct.SystemID, ct.BpID, ct.TariffScopeID, ct.CompanyID, ct.ValidFrom, ct.CreatedFrom, ct.CreatedOn, ct.EditFrom, ct.EditOn, s.NameVisible, s.DescriptionShort, c.NameVisible AS NameVisibleContract, t.NameVisible AS NameVisibleTariff FROM Master_CompanyTariffs AS ct INNER JOIN System_TariffScopes AS s ON ct.SystemID = s.SystemID AND ct.TariffScopeID = s.TariffScopeID INNER JOIN System_TariffContracts AS c ON s.SystemID = c.SystemID AND s.TariffID = c.TariffID AND s.TariffContractID = c.TariffContractID INNER JOIN System_Tariffs AS t ON c.SystemID = t.SystemID AND c.TariffID = t.TariffID WHERE (ct.SystemID = @SystemID) AND (ct.BpID = @BpID) AND (ct.CompanyID = @CompanyID) ORDER BY ct.ValidFrom DESC">
                        <SelectParameters>
                            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
                            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
                            <asp:ControlParameter ControlID="CompanyID1" PropertyName="Value" DefaultValue="0" Name="CompanyID" Type="Int32"></asp:ControlParameter>
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
            </telerik:RadPageView>

            <%-- Statistical Trades --%>
            <telerik:RadPageView ID="RadPageView5" runat="server">
                <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                    <table id="Table8" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                        <tr>
                            <td>
                                <asp:HiddenField runat="server" ID="CompanyID3" Value='<%# Eval("CompanyID")%>' />
                                <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server">
                                    <table>
                                        <tr>
                                            <td colspan="2">
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <%# Resources.Resource.lblNameVisible %>:
                                                        </td>
                                                        <td>
                                                            <asp:Label runat="server" ID="Label6" Text='<%# Eval("NameVisible") %>' Width="300px"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <%# Resources.Resource.lblNameAdditional %>:
                                                        </td>
                                                        <td>
                                                            <asp:Label runat="server" ID="Label7" Text='<%# Eval("NameAdditional") %>' Width="300px"></asp:Label>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelAssignedTrades" Text='<%# String.Concat(Resources.Resource.lblAssignedTrades, ":") %>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <telerik:RadListBox ID="AssignedTrades" runat="server" DataSourceID="SqlDataSource_CompanyTrades" DataValueField="TradeID"
                                                                    DataKeyField="TradeID" DataTextField="NameVisible" Width="300px" Height="300px" SelectionMode="Single" EnableDragAndDrop="false">
                                                </telerik:RadListBox>
                                            </td>
                                        </tr>
                                    </table>
                                </telerik:RadAjaxPanel>
                            </td>
                        </tr>
                    </table>
                </div>

                <asp:SqlDataSource ID="SqlDataSource_CompanyTrades" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                   SelectCommand="SELECT t1.SystemID, t1.BpID, t1.TradeGroupID, t1.TradeID, t1.CompanyID, t1.CreatedFrom, t1.CreatedOn, t1.EditFrom, t1.EditOn, Master_Trades.NameVisible, Master_Trades.DescriptionShort FROM Master_CompanyTrades AS t1 INNER JOIN Master_Trades ON t1.SystemID = Master_Trades.SystemID AND t1.BpID = Master_Trades.BpID AND t1.TradeGroupID = Master_Trades.TradeGroupID AND t1.TradeID = Master_Trades.TradeID WHERE (t1.SystemID = @SystemID) AND (t1.BpID = @BpID) AND (t1.CompanyID = @CompanyID) ORDER BY Master_Trades.NameVisible">
                    <SelectParameters>
                        <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" />
                        <asp:SessionParameter DefaultValue="0" Name="BpID" SessionField="BpID" />
                        <asp:ControlParameter ControlID="CompanyID3" PropertyName="Value" Type="Int32" Name="CompanyID"></asp:ControlParameter>
                    </SelectParameters>
                </asp:SqlDataSource>
            </telerik:RadPageView>

            <%-- Other Criterias --%>
            <telerik:RadPageView ID="RadPageView6" runat="server">
                <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                    <table id="Table12" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="Label8" Text='<%# String.Concat(Resources.Resource.lblNameVisible, ":") %>'
                                           ></asp:Label>
                            </td>
                            <td>
                                <asp:Label runat="server" ID="Label9" Text='<%# Eval("NameVisible") %>' Width="300px"
                                           ></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="Label30" Text='<%# String.Concat(Resources.Resource.lblNameAdditional, ":") %>'
                                           ></asp:Label>
                            </td>
                            <td>
                                <asp:Label runat="server" ID="Label31" Text='<%# Eval("NameAdditional") %>' Width="300px"
                                           ></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp; </td>
                            <td>&nbsp; </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="LabelUserString1" Text='<%# String.Concat(Resources.Resource.lblUserDefinedString, " 1:") %>'></asp:Label>
                            </td>
                            <td>
                                <asp:Label runat="server" ID="UserString1" Text='<%# Eval("UserString1") %>' Width="300px"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="LabelUserString2" Text='<%# String.Concat(Resources.Resource.lblUserDefinedString, " 2:") %>'></asp:Label>
                            </td>
                            <td>
                                <asp:Label runat="server" ID="UserString2" Text='<%# Eval("UserString2") %>' Width="300px"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="LabelUserString3" Text='<%# String.Concat(Resources.Resource.lblUserDefinedString, " 3:") %>'></asp:Label>
                            </td>
                            <td>
                                <asp:Label runat="server" ID="UserString3" Text='<%# Eval("UserString3") %>' Width="300px"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="LabelUserString4" Text='<%# String.Concat(Resources.Resource.lblUserDefinedString, " 4:") %>'></asp:Label>
                            </td>
                            <td>
                                <asp:Label runat="server" ID="UserString4" Text='<%# Eval("UserString4") %>' Width="300px"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="LabelUserBit1" Text='<%# String.Concat(Resources.Resource.lblUserDefinedBit, " 1:") %>'></asp:Label>
                            </td>
                            <td>
                                <asp:CheckBox runat="server" CssClass="cb" ID="UserBit1" Enabled="false"></asp:CheckBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="LabelUserBit2" Text='<%# String.Concat(Resources.Resource.lblUserDefinedBit, " 2:") %>'></asp:Label>
                            </td>
                            <td>
                                <asp:CheckBox runat="server" CssClass="cb" ID="UserBit2" Enabled="false"></asp:CheckBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="LabelUserBit3" Text='<%# String.Concat(Resources.Resource.lblUserDefinedBit, " 3:") %>'></asp:Label>
                            </td>
                            <td>
                                <asp:CheckBox runat="server" CssClass="cb" ID="UserBit3" Enabled="false"></asp:CheckBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label runat="server" ID="LabelUserBit4" Text='<%# String.Concat(Resources.Resource.lblUserDefinedBit, " 4:") %>'></asp:Label>
                            </td>
                            <td>
                                <asp:CheckBox runat="server" CssClass="cb" ID="UserBit4" Enabled="false"></asp:CheckBox>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp; </td>
                            <td>&nbsp; </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="LabelAssignedAttributes" Text='<%# String.Concat(Resources.Resource.lblAssignedAttributes, ":") %>'></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <telerik:RadListBox ID="AssignedAttributes" runat="server" DataSourceID="SqlDataSource_AssignedAttributes" DataValueField="AttributeID"
                                                                DataKeyField="AttributeID" DataTextField="NameVisible" Width="300px" Height="100px" SelectionMode="Single" EnableDragAndDrop="false">
                                            </telerik:RadListBox>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>

                <asp:SqlDataSource ID="SqlDataSource_AvailableAttributes" runat="server" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                                   SelectCommand="SELECT SystemID, BpID, AttributeID, NameVisible, DescriptionShort, PassColor, TemplateID, CreatedFrom, CreatedOn, EditFrom, EditOn FROM Master_AttributesBuildingProject AS ab WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (NOT EXISTS (SELECT 1 AS Expr1 FROM Master_AttributesCompany WHERE (SystemID = ab.SystemID) AND (BpID = ab.BpID) AND (AttributeID = ab.AttributeID) AND (CompanyID = @CompanyID)))">
                    <SelectParameters>
                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
                        <asp:ControlParameter ControlID="CompanyID" PropertyName="Text" DefaultValue="0" Name="CompanyID"></asp:ControlParameter>
                    </SelectParameters>
                </asp:SqlDataSource>

                <asp:SqlDataSource ID="SqlDataSource_AssignedAttributes" runat="server" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                                   SelectCommand="SELECT ac.SystemID, ac.BpID, ac.AttributeID, ab.NameVisible, ab.DescriptionShort, ac.CreatedFrom, ac.CreatedOn, ac.EditFrom, ac.EditOn, ac.CompanyID FROM Master_AttributesCompany AS ac INNER JOIN Master_AttributesBuildingProject AS ab ON ac.SystemID = ab.SystemID AND ac.BpID = ab.BpID AND ac.AttributeID = ab.AttributeID WHERE (ac.SystemID = @SystemID) AND (ac.BpID = @BpID) AND (ac.CompanyID = @CompanyID)">
                    <SelectParameters>
                        <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
                        <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
                        <asp:ControlParameter ControlID="CompanyID" PropertyName="Text" DefaultValue="0" Name="CompanyID"></asp:ControlParameter>
                    </SelectParameters>
                </asp:SqlDataSource>
            </telerik:RadPageView>

        </telerik:RadMultiPage>
    </ItemTemplate>
</asp:FormView>
