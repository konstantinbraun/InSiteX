<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EmployeeDetails.ascx.cs" Inherits="InSite.App.Controls.EmployeeDetails" %>

<asp:FormView ID="EmployeeDetailsFormView" DataKeyNames="EmployeeID" runat="server" BackColor="Transparent" BorderColor="Transparent">
    <ItemTemplate>
        <telerik:RadAjaxPanel runat="server" ID="PanelDetails">
            <telerik:RadTabStrip ID="RadTabStrip1" runat="server" MultiPageID="RadMultiPage1" Align="Left" AutoPostBack="false" CausesValidation="false">
                <Tabs>
                    <telerik:RadTab PageViewID="RadPageView1" ImageUrl="~/Resources/Icons/factory.png" Text="<%# Resources.Resource.lblGenerally %>" Selected="true" Font-Bold="true" Value="1" />
                    <telerik:RadTab PageViewID="RadPageView2" ImageUrl="~/Resources/Icons/list-add-5.png" Text="<%# Resources.Resource.lblAdvanced %>" Font-Bold="true" Value="2" />
                    <telerik:RadTab PageViewID="RadPageView3" ImageUrl="~/Resources/Icons/info.png" Text="<%# Resources.Resource.lblInfo %>" Font-Bold="true" Value="3" />
                    <telerik:RadTab PageViewID="RadPageView4" ImageUrl="~/Resources/Icons/Money.png" Text="<%# Resources.Resource.lblMinimumWage %>" Font-Bold="true" Value="4" />
                    <telerik:RadTab PageViewID="RadPageView5" ImageUrl="~/Resources/Icons/emblem-paragraph.png" Text="<%# Resources.Resource.lblDocumentsRules %>" Font-Bold="true" Value="5" />
                    <telerik:RadTab PageViewID="RadPageView6" ImageUrl="~/Resources/Icons/Access.png" Text="<%# Resources.Resource.lblAccessControl %>" Font-Bold="true" Value="6" />
                    <telerik:RadTab PageViewID="RadPageView7" ImageUrl="~/Resources/Icons/criteria.png" Text="<%# Resources.Resource.lblOtherCriterias %>" Font-Bold="true" Value="7" />
                </Tabs>
            </telerik:RadTabStrip>

            <telerik:RadMultiPage ID="RadMultiPage1" runat="server" RenderSelectedPageOnly="false">

                <%-- Generally --%>
                <telerik:RadPageView ID="RadPageView1" runat="server" Selected="true">
                    <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                        <table id="Table1" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                            <tr>
                                <td style="vertical-align: top;">
                                    <table id="Table2" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="Label1" Text='<%# String.Concat(Resources.Resource.lblID, ":") %>'
                                                           >
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="EmployeeID" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).EmployeeID %>'
                                                           >
                                                </asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelCompanyName" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:HiddenField ID="CompanyID" runat="server" Value='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).CompanyID %>'></asp:HiddenField>
                                                <asp:Label runat="server" ID="CompanyName" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameVisible %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelSalutation" Text='<%# String.Concat(Resources.Resource.lblAddrSalutation, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:HiddenField ID="AddressID" runat="server" Value='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).AddressID %>'></asp:HiddenField>
                                                <asp:Label runat="server" ID="Salutation" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Salutation %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelLastName" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="LastName" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LastName %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelFirstName" Text='<%# String.Concat(Resources.Resource.lblAddrFirstName, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="FirstName" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).FirstName %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelAddress1" Text='<%# String.Concat(Resources.Resource.lblAddress1, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="Address1" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Address1 %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelAddress2" Text='<%# String.Concat(Resources.Resource.lblAddress2, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="Address2" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Address2 %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelZip" Text='<%# String.Concat(Resources.Resource.lblAddrZip, ", ", Resources.Resource.lblAddrCity, ":") %>'>
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="Zip" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Zip %>' Width="60px"></asp:Label>
                                                <asp:Label runat="server" ID="City" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).City %>' Width="224px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelState" Text='<%# String.Concat(Resources.Resource.lblAddrState, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="State" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).State %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelCountryName" Text='<%# String.Concat(Resources.Resource.lblCountry, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="CountryName" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).CountryID %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelPhone" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="Phone" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Phone %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelEmail" Text='<%# String.Concat(Resources.Resource.lblAddrEmail, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="Email" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Email %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelBirthDate" Text='<%# String.Concat(Resources.Resource.lblAddrBirthDate, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="BirthDate" Text='<%# Eval("BirthDate", "{0:d}") %>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelNationalityID" Text='<%# String.Concat(Resources.Resource.lblNationality, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="NationalityName" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NationalityName %>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelLanguageID" Text='<%# String.Concat(Resources.Resource.lblLanguage, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="LanguageID" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LanguageID %>'></asp:Label>
                                            </td>
                                        </tr>

                                    </table>
                                </td>
                                <td style="vertical-align: top;">
                                    <asp:Panel runat="server" ID="PanelPhoto">
                                        <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin-top: 6px; margin-left: 10px; width: 300px;">
                                            <table id="Table3" cellspacing="2" cellpadding="2" border="0">
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="LabelPhotoData" Text='<%# String.Concat(Resources.Resource.lblPhoto, ":") %>'></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp; </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <telerik:RadBinaryImage runat="server" ID="PhotoData"
                                                                                DataValue='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).ThumbnailData %>'
                                                                                AutoAdjustImageControlSize="false" Height="45px" ToolTip='<%#Eval("LastName", Resources.Resource.lblImageFor) %>'
                                                                                AlternateText='<%#Eval("LastName", Resources.Resource.lblImageFor) %>'>
                                                        </telerik:RadBinaryImage>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label runat="server" ID="PhotoFileName" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).PhotoFileName %>'></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </asp:Panel>
                                </td>
                            </tr>
                        </table>
                    </div>
                </telerik:RadPageView>

                <%-- Advanced --%>
                <telerik:RadPageView ID="RadPageView2" runat="server">
                    <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                        <table id="Table4" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                            <tr>
                                <td style="vertical-align: top;">
                                    <table id="Table5" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ", ", Resources.Resource.lblAddrFirstName, ":") %>'
                                                           ></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LastName, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).FirstName) %>'
                                                           ></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ", ", Resources.Resource.lblAddrEmail, ":") %>'
                                                           ></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Phone, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Email) %>'
                                                           ></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'
                                                           ></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameVisible, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameAdditional) %>'
                                                           ></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelTradeID" Text='<%# String.Concat(Resources.Resource.lblTrade, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <telerik:RadComboBox runat="server" ID="TradeID" EmptyMessage="<%= Resources.Resource.msgPleaseTypeHere %>"
                                                                     DataValueField="TradeID" DataTextField="NameVisible" Width="300"
                                                                     Filter="Contains" AppendDataBoundItems="true" EnableLoadOnDemand="true" DropDownAutoWidth="Enabled" Enabled="false">
                                                    <ItemTemplate>
                                                        <table cellpadding="5px" style="text-align: left;">
                                                            <tr>
                                                                <td style="text-align: left;">
                                                                    <asp:Label ID="ItemID" Text='<%# Eval("TradeNumber") %>' runat="server">
                                                                    </asp:Label>
                                                                </td>
                                                                <td style="text-align: left;">
                                                                    <asp:Label ID="ItemName" Text='<%# Eval("NameVisible") %>' runat="server">
                                                                    </asp:Label>
                                                                </td>
                                                                <td style="text-align: left;">
                                                                    <asp:Label ID="ItemDescr" Text='<%# Eval("DescriptionShort") %>' runat="server">
                                                                    </asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </ItemTemplate>
                                                    <Items>
                                                        <telerik:RadComboBoxItem Text="<%= Resources.Resource.selNoSelection %>" Value="0" />
                                                    </Items>
                                                </telerik:RadComboBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelStaffFunction" Text='<%# String.Concat(Resources.Resource.lblFunction, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="StaffFunction" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).StaffFunction %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelEmploymentStatusID" Text='<%# String.Concat(Resources.Resource.lblEmploymentStatus, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <telerik:RadComboBox runat="server" ID="EmploymentStatusID" EmptyMessage="<%= Resources.Resource.msgPleaseTypeHere %>" DataSourceID="SqlDataSource_EmploymentStatus" AppendDataBoundItems="true"
                                                                     DataValueField="EmploymentStatusID" DataTextField="NameVisible" Width="300" Filter="Contains"
                                                                     SelectedValue='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).EmploymentStatusID %>' DropDownAutoWidth="Enabled" Enabled="false">
                                                    <Items>
                                                        <telerik:RadComboBoxItem Text="<%= Resources.Resource.selNoSelection %>" Value="0" />
                                                    </Items>
                                                </telerik:RadComboBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelDescription" Text='<%# String.Concat(Resources.Resource.lblRemarks, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="Description" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Description %>' Width="300px" TextMode="MultiLine" Rows="3" Wrap="true"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
                                        </tr>

                                        <tr>
                                            <td colspan="2">
                                                <telerik:RadAjaxPanel runat="server" ID="QualificationPanel">
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <asp:Label runat="server" ID="LabelAvailableQualifications" Text='<%# String.Concat(Resources.Resource.lblAvailableQualifications, ":") %>'></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <telerik:RadListBox ID="AssignedQualifications" runat="server" DataSourceID="SqlDataSource_EmployeeQualification1" DataValueField="StaffRoleID"
                                                                                    DataKeyField="StaffRoleID" DataTextField="NameVisible" Width="211px" Height="150px" SelectionMode="Multiple"
                                                                                    Enabled="false">
                                                                </telerik:RadListBox>

                                                            </td>
                                                        </tr>
                                                    </table>
                                                </telerik:RadAjaxPanel>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>

                    <asp:SqlDataSource ID="SqlDataSource_StaffRoles1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                       SelectCommand="SELECT * FROM Master_StaffRoles sr WHERE sr.SystemID = @SystemID AND sr.BpID = @BpID AND NOT EXISTS (SELECT 1 FROM Master_EmployeeQualification eq WHERE eq.SystemID = @SystemID AND eq.BpID = @BpID AND eq.EmployeeID = @EmployeeID AND eq.StaffRoleID = sr.StaffRoleID)">
                        <SelectParameters>
                            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                            <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                        </SelectParameters>
                    </asp:SqlDataSource>

                    <asp:SqlDataSource ID="SqlDataSource_EmployeeQualification1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                       SelectCommand="SELECT Master_EmployeeQualification.StaffRoleID, Master_StaffRoles.NameVisible, Master_StaffRoles.DescriptionShort FROM Master_EmployeeQualification INNER JOIN Master_StaffRoles ON Master_EmployeeQualification.SystemID = Master_StaffRoles.SystemID AND Master_EmployeeQualification.BpID = Master_StaffRoles.BpID AND Master_EmployeeQualification.StaffRoleID = Master_StaffRoles.StaffRoleID WHERE (Master_EmployeeQualification.SystemID = @SystemID) AND (Master_EmployeeQualification.BpID = @BpID) AND (Master_EmployeeQualification.EmployeeID = @EmployeeID)">
                        <SelectParameters>
                            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                            <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                        </SelectParameters>
                    </asp:SqlDataSource>
                </telerik:RadPageView>

                <%-- Info --%>
                <telerik:RadPageView ID="RadPageView3" runat="server">
                    <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                        <table id="Table7" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                            <tr>
                                <td style="vertical-align: top;">
                                    <table id="Table8" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ", ", Resources.Resource.lblAddrFirstName, ":") %>'
                                                           ></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LastName, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).FirstName) %>'
                                                           ></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ", ", Resources.Resource.lblAddrEmail, ":") %>'
                                                           ></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Phone, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Email) %>'
                                                           ></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'
                                                           ></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameVisible, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameAdditional) %>'
                                                           ></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="LabelReleaseCFrom" Text='<%# String.Concat(Resources.Resource.lblReleaseC, " ", Resources.Resource.lblFrom, ":") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="ReleaseCFrom" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).ReleaseCFrom %>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="LabelReleaseCOn" Text='<%# String.Concat(Resources.Resource.lblReleaseC, " ", Resources.Resource.lblOn, ":") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="ReleaseCOn" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).ReleaseCOn %>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="LabelReleaseBFrom" Text='<%# String.Concat(Resources.Resource.lblReleaseB, " ", Resources.Resource.lblFrom, ":") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="ReleaseBFrom" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).ReleaseBFrom %>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="LabelReleaseBOn" Text='<%# String.Concat(Resources.Resource.lblReleaseB, " ", Resources.Resource.lblOn, ":") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="ReleaseBOn" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).ReleaseBOn %>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="LabelLockedFrom" Text='<%# String.Concat(Resources.Resource.lblLockedFrom, ":") %>' runat="server">
                                                </asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="LockedFrom" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LockedFrom %>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="LabelLockedOn" Text='<%# String.Concat(Resources.Resource.lblLockedOn, ":") %>' runat="server"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="LockedOn" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LockedOn %>' runat="server"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server"  Text='<%# String.Concat(Resources.Resource.lblCreatedFrom, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server"  Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).CreatedFrom %>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server"  Text='<%# String.Concat(Resources.Resource.lblCreatedOn, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server"  Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).CreatedOn %>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server"  Text='<%# String.Concat(Resources.Resource.lblEditFrom, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server"  Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).EditFrom %>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server"  Text='<%# String.Concat(Resources.Resource.lblEditOn, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server"  Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).EditOn %>'></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>

                </telerik:RadPageView>

                <%-- Minimum wage --%>
                <telerik:RadPageView ID="RadPageView4" runat="server">
                    <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                        <table id="Table11" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                            <tr>
                                <td style="vertical-align: top;">
                                    <table id="Table12" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                        <tr>
                                            <td>
                                                <asp:HiddenField ID="CompanyID1" runat="server" Value='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).CompanyID %>'></asp:HiddenField>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ", ", Resources.Resource.lblAddrFirstName, ":") %>'
                                                           ></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LastName, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).FirstName) %>'
                                                           ></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ", ", Resources.Resource.lblAddrEmail, ":") %>'
                                                           ></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Phone, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Email) %>'
                                                           ></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'
                                                           ></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameVisible, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameAdditional) %>'
                                                           ></asp:Label>
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
                                                            <asp:Label ID="LabelRadGridMinWage1" Text='<%# String.Concat(Resources.Resource.lblEmplMinWage1, ":") %>' runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <telerik:RadGrid runat="server" ID="RadGridMinWage1" DataSourceID="SqlDataSource_CompanyTariffs1" Enabled="false">
                                                                <MasterTableView DataSourceID="SqlDataSource_CompanyTariffs1" AutoGenerateColumns="false" AllowPaging="true" PageSize="5">
                                                                    <Columns>
                                                                        <telerik:GridBoundColumn DataField="ValidFrom" HeaderText="<%= Resources.Resource.lblValidFrom %>" DataFormatString="{0:d}">
                                                                        </telerik:GridBoundColumn>
                                                                        <telerik:GridBoundColumn DataField="TariffName" HeaderText="<%= Resources.Resource.lblTariff %>"></telerik:GridBoundColumn>
                                                                        <telerik:GridBoundColumn DataField="ScopeName" HeaderText="<%= Resources.Resource.lblTariffScope %>"></telerik:GridBoundColumn>
                                                                    </Columns>
                                                                </MasterTableView>
                                                            </telerik:RadGrid>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp; </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="LabelRadGridMinWage2" Text='<%# String.Concat(Resources.Resource.lblEmplMinWage2, ":") %>' runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <telerik:RadGrid runat="server" ID="RadGridMinWage2" DataSourceID="SqlDataSource_WageGroupAssignment1" ValidateRequestMode="Disabled" Enabled="false">
                                                                <MasterTableView DataSourceID="SqlDataSource_WageGroupAssignment1" AutoGenerateColumns="false" AllowPaging="true" PageSize="5"
                                                                                 AllowAutomaticDeletes="false" AllowAutomaticInserts="false" CommandItemDisplay="None">

                                                                    <Columns>

                                                                        <telerik:GridTemplateColumn DataField="ValidFrom" FilterControlAltText="Filter ValidFrom column"
                                                                                                    HeaderText="<%= Resources.Resource.lblValidFrom %>" SortExpression="ValidFrom" UniqueName="ValidFrom" Visible="true">
                                                                            <ItemTemplate>
                                                                                <asp:Label ID="ValidFrom" runat="server" Text='<%# Eval("ValidFrom", "{0:d}") %>'></asp:Label>
                                                                            </ItemTemplate>
                                                                        </telerik:GridTemplateColumn>

                                                                        <telerik:GridDropDownColumn DataField="TariffWageGroupID" DataSourceID="SqlDataSource_TariffWageGroups1"
                                                                                                    HeaderText="<%= Resources.Resource.lblTariffWageGroup %>" ListTextField="NameVisible"
                                                                                                    ListValueField="TariffWageGroupID" UniqueName="TariffWageGroupID" DropDownControlType="RadComboBox"
                                                                                                    CurrentFilterFunction="Contains" AllowFiltering="true">
                                                                            <ItemStyle Width="300px" />
                                                                        </telerik:GridDropDownColumn>

                                                                        <telerik:GridTemplateColumn DataField="CreatedFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedFrom column"
                                                                                                    HeaderText="<%= Resources.Resource.lblCreatedFrom %>" SortExpression="CreatedFrom" UniqueName="CreatedFrom" Visible="False">
                                                                            <ItemTemplate>
                                                                                <asp:Label ID="CreatedFromLabel" runat="server" Text='<%# ((System.Data.DataRowView)Container.DataItem)["CreatedFrom"] %>'></asp:Label>
                                                                            </ItemTemplate>
                                                                        </telerik:GridTemplateColumn>

                                                                        <telerik:GridTemplateColumn DataField="CreatedOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedOn column"
                                                                                                    HeaderText="<%= Resources.Resource.lblCreatedOn %>" SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="False">
                                                                            <ItemTemplate>
                                                                                <asp:Label ID="CreatedOnLabel" runat="server" Text='<%# ((System.Data.DataRowView)Container.DataItem)["CreatedOn"] %>'></asp:Label>
                                                                            </ItemTemplate>
                                                                        </telerik:GridTemplateColumn>

                                                                        <telerik:GridTemplateColumn DataField="EditFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditFrom column"
                                                                                                    HeaderText="<%= Resources.Resource.lblEditFrom %>" SortExpression="EditFrom" UniqueName="EditFrom" Visible="False">
                                                                            <ItemTemplate>
                                                                                <asp:Label ID="EditFromLabel" runat="server" Text='<%# ((System.Data.DataRowView)Container.DataItem)["EditFrom"] %>'></asp:Label>
                                                                            </ItemTemplate>
                                                                        </telerik:GridTemplateColumn>

                                                                        <telerik:GridTemplateColumn DataField="EditOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditOn column"
                                                                                                    HeaderText="<%= Resources.Resource.lblEditOn %>" SortExpression="EditOn" UniqueName="EditOn" Visible="False">
                                                                            <ItemTemplate>
                                                                                <asp:Label ID="EditOnLabel" runat="server" Text='<%# ((System.Data.DataRowView)Container.DataItem)["EditOn"] %>'></asp:Label>
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
                                                    <tr>
                                                        <td>&nbsp; </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="LabelRadGridMinWage3" Text='<%# String.Concat(Resources.Resource.lblEmplMinWage3, ":") %>' runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <telerik:RadGrid runat="server" ID="RadGridMinWage3" DataSourceID="SqlDataSource_TariffHistorie1" Enabled="false">
                                                                <MasterTableView DataSourceID="SqlDataSource_TariffHistorie1" AutoGenerateColumns="false" AllowPaging="true" PageSize="5">
                                                                    <Columns>
                                                                        <telerik:GridBoundColumn DataField="ValidFrom" HeaderText="<%= Resources.Resource.lblValidFrom %>" DataFormatString="{0:d}">
                                                                        </telerik:GridBoundColumn>
                                                                        <telerik:GridBoundColumn DataField="TariffName" HeaderText="<%= Resources.Resource.lblTariff %>"></telerik:GridBoundColumn>
                                                                        <telerik:GridBoundColumn DataField="ScopeName" HeaderText="<%= Resources.Resource.lblTariffScope %>"></telerik:GridBoundColumn>
                                                                        <telerik:GridBoundColumn DataField="WageGroupName" HeaderText="<%= Resources.Resource.lblTariffWageGroup %>"></telerik:GridBoundColumn>
                                                                        <telerik:GridBoundColumn DataField="MinWage" HeaderText="<%= Resources.Resource.lblTariffWage %>"></telerik:GridBoundColumn>
                                                                    </Columns>
                                                                </MasterTableView>
                                                            </telerik:RadGrid>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp; </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="LabelRadGridMinWage4" Text='<%# String.Concat(Resources.Resource.lblEmplMinWage4, ":") %>' runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <telerik:RadGrid runat="server" ID="RadGridMinWage4" DataSourceID="SqlDataSource_MinWageAttestation1" Enabled="false">
                                                                <MasterTableView DataSourceID="SqlDataSource_MinWageAttestation1" AutoGenerateColumns="false" AllowPaging="true" PageSize="5"
                                                                                 AllowAutomaticUpdates="true">

                                                                    <Columns>
                                                                        <telerik:GridBoundColumn DataField="ForMonth" HeaderText="<%= Resources.Resource.lblForMonth %>" DataType="System.DateTime"
                                                                                                 FilterControlAltText="Filter ForMonth column" SortExpression="ForMonth" UniqueName="ForMonth">
                                                                        </telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="Amount" HeaderText="<%= Resources.Resource.lblTariffWage %>" DataType="System.Decimal"
                                                                                                 FilterControlAltText="Filter Amount column" SortExpression="Amount" UniqueName="Amount">
                                                                        </telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="WageGroupName" HeaderText="<%= Resources.Resource.lblTariffWageGroup %>" DataType="System.Int32"
                                                                                                 FilterControlAltText="Filter WageGroupID column" SortExpression="WageGroupName" UniqueName="WageGroupName">
                                                                        </telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="Status" HeaderText="<%= Resources.Resource.lblStatus %>" SortExpression="Status" UniqueName="Status"
                                                                                                 DataType="System.Int32" FilterControlAltText="Filter Status column">
                                                                        </telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="ReceivedBy" HeaderText="<%= Resources.Resource.lblReceivedFrom %>" SortExpression="ReceivedBy"
                                                                                                 UniqueName="ReceivedBy" FilterControlAltText="Filter ReceivedBy column">
                                                                        </telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="ReceivedOn" HeaderText="<%= Resources.Resource.lblReceivedOn %>" SortExpression="ReceivedOn"
                                                                                                 UniqueName="ReceivedOn" DataType="System.DateTime" FilterControlAltText="Filter ReceivedOn column">
                                                                        </telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="RequestBy" HeaderText="<%= Resources.Resource.lblRequestFrom %>" SortExpression="RequestBy"
                                                                                                 UniqueName="RequestBy" FilterControlAltText="Filter RequestBy column">
                                                                        </telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="RequestOn" HeaderText="<%= Resources.Resource.lblRequestOn %>" SortExpression="RequestOn"
                                                                                                 UniqueName="RequestOn" DataType="System.DateTime" FilterControlAltText="Filter RequestOn column">
                                                                        </telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="DocumentID" HeaderText="<%= Resources.Resource.lblDocumentID %>" SortExpression="DocumentID"
                                                                                                 UniqueName="DocumentID" FilterControlAltText="Filter DocumentID column">
                                                                        </telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="CreatedFrom" HeaderText="CreatedFrom" SortExpression="CreatedFrom" UniqueName="CreatedFrom"
                                                                                                 FilterControlAltText="Filter CreatedFrom column" Visible="false" InsertVisiblityMode="AlwaysHidden">
                                                                        </telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="CreatedOn" HeaderText="CreatedOn" SortExpression="CreatedOn" UniqueName="CreatedOn" DataType="System.DateTime"
                                                                                                 FilterControlAltText="Filter CreatedOn column" Visible="false" InsertVisiblityMode="AlwaysHidden">
                                                                        </telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="EditFrom" HeaderText="EditFrom" SortExpression="EditFrom" UniqueName="EditFrom"
                                                                                                 FilterControlAltText="Filter EditFrom column" Visible="false" InsertVisiblityMode="AlwaysHidden">
                                                                        </telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="EditOn" HeaderText="EditOn" SortExpression="EditOn" UniqueName="EditOn" DataType="System.DateTime"
                                                                                                 FilterControlAltText="Filter EditOn column" Visible="false" InsertVisiblityMode="AlwaysHidden">
                                                                        </telerik:GridBoundColumn>
                                                                    </Columns>
                                                                </MasterTableView>
                                                            </telerik:RadGrid>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>

                    <asp:SqlDataSource ID="SqlDataSource_CompanyTariffs1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                       SelectCommand="SELECT System_Tariffs.TariffID, System_TariffScopes.TariffContractID, Master_CompanyTariffs.TariffScopeID, Master_CompanyTariffs.ValidFrom, System_Tariffs.NameVisible AS TariffName, System_TariffScopes.NameVisible AS ScopeName FROM Master_CompanyTariffs INNER JOIN System_TariffScopes ON Master_CompanyTariffs.SystemID = System_TariffScopes.SystemID AND Master_CompanyTariffs.TariffScopeID = System_TariffScopes.TariffScopeID INNER JOIN System_Tariffs ON System_TariffScopes.SystemID = System_Tariffs.SystemID AND System_TariffScopes.TariffID = System_Tariffs.TariffID WHERE (Master_CompanyTariffs.SystemID = @SystemID) AND (Master_CompanyTariffs.BpID = @BpID) AND (Master_CompanyTariffs.CompanyID = @CompanyID)">
                        <SelectParameters>
                            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                            <asp:ControlParameter ControlID="CompanyID1" PropertyName="Value" DefaultValue="0" Name="CompanyID" Type="Int32"></asp:ControlParameter>
                        </SelectParameters>
                    </asp:SqlDataSource>

                    <asp:SqlDataSource ID="SqlDataSource_WageGroupAssignment1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                       SelectCommand="SELECT ewga.SystemID, ewga.BpID, ewga.EmployeeID, ewga.TariffWageGroupID, twg.NameVisible, ewga.ValidFrom, ewga.CreatedFrom, ewga.CreatedOn, ewga.EditFrom, ewga.EditOn FROM Master_EmployeeWageGroupAssignment AS ewga INNER JOIN System_TariffWageGroups AS twg ON ewga.SystemID = twg.SystemID AND ewga.TariffWageGroupID = twg.TariffWageGroupID WHERE (ewga.SystemID = @SystemID) AND (ewga.BpID = @BpID) AND (ewga.EmployeeID = @EmployeeID)">
                        <SelectParameters>
                            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                            <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID" Type="Int32"></asp:ControlParameter>
                        </SelectParameters>
                    </asp:SqlDataSource>

                    <asp:SqlDataSource ID="SqlDataSource_TariffWageGroups1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                       SelectCommand="SELECT twg.TariffWageGroupID, twg.NameVisible, twg.DescriptionShort FROM System_TariffWageGroups AS twg INNER JOIN Master_CompanyTariffs AS ct ON twg.SystemID = ct.SystemID AND twg.TariffScopeID = ct.TariffScopeID WHERE (ct.SystemID = @SystemID) AND (ct.BpID = @BpID) AND (ct.CompanyID = @CompanyID) ORDER BY twg.NameVisible">
                        <SelectParameters>
                            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                            <asp:ControlParameter ControlID="CompanyID1" PropertyName="Value" DefaultValue="0" Name="CompanyID" Type="Int32"></asp:ControlParameter>
                        </SelectParameters>
                    </asp:SqlDataSource>

                    <asp:SqlDataSource ID="SqlDataSource_TariffHistorie1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                       SelectCommand="SELECT System_Tariffs.TariffID, System_TariffScopes.TariffContractID, Master_CompanyTariffs.TariffScopeID, Master_CompanyTariffs.ValidFrom, System_Tariffs.NameVisible AS TariffName, System_TariffScopes.NameVisible AS ScopeName, MIN(System_TariffWages.Wage), System_TariffWageGroups.NameVisible AS WageGroupName FROM Master_CompanyTariffs INNER JOIN System_TariffScopes ON Master_CompanyTariffs.SystemID = System_TariffScopes.SystemID AND Master_CompanyTariffs.TariffScopeID = System_TariffScopes.TariffScopeID INNER JOIN System_Tariffs ON System_TariffScopes.SystemID = System_Tariffs.SystemID AND System_TariffScopes.TariffID = System_Tariffs.TariffID INNER JOIN System_TariffWageGroups ON System_TariffScopes.SystemID = System_TariffWageGroups.SystemID AND System_TariffScopes.TariffID = System_TariffWageGroups.TariffID AND System_TariffScopes.TariffContractID = System_TariffWageGroups.TariffContractID AND System_TariffScopes.TariffScopeID = System_TariffWageGroups.TariffScopeID INNER JOIN System_TariffWages ON System_TariffWageGroups.SystemID = System_TariffWages.SystemID AND System_TariffWageGroups.TariffID = System_TariffWages.TariffID AND System_TariffWageGroups.TariffContractID = System_TariffWages.TariffContractID AND System_TariffWageGroups.TariffScopeID = System_TariffWages.TariffScopeID AND System_TariffWageGroups.TariffWageGroupID = System_TariffWages.TariffWageGroupID WHERE (Master_CompanyTariffs.SystemID = @SystemID) AND (Master_CompanyTariffs.BpID = @BpID) AND (Master_CompanyTariffs.CompanyID = @CompanyID) GROUP BY System_Tariffs.TariffID, System_TariffScopes.TariffContractID, Master_CompanyTariffs.TariffScopeID, Master_CompanyTariffs.ValidFrom, System_Tariffs.NameVisible, System_TariffScopes.NameVisible, System_TariffWageGroups.NameVisible">
                        <SelectParameters>
                            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                            <asp:ControlParameter ControlID="CompanyID1" PropertyName="Value" DefaultValue="0" Name="CompanyID" Type="Int32"></asp:ControlParameter>
                        </SelectParameters>
                    </asp:SqlDataSource>

                    <asp:SqlDataSource ID="SqlDataSource_MinWageAttestation1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                       SelectCommand="SELECT Master_EmployeeMinWageAttestation.ForMonth, Master_EmployeeMinWageAttestation.Amount, Master_EmployeeMinWageAttestation.WageGroupID, Master_EmployeeMinWageAttestation.Status, Master_EmployeeMinWageAttestation.ReceivedBy, Master_EmployeeMinWageAttestation.ReceivedOn, Master_EmployeeMinWageAttestation.RequestBy, Master_EmployeeMinWageAttestation.RequestOn, Master_EmployeeMinWageAttestation.DocumentID, Master_EmployeeMinWageAttestation.CreatedFrom, Master_EmployeeMinWageAttestation.CreatedOn, Master_EmployeeMinWageAttestation.EditFrom, Master_EmployeeMinWageAttestation.EditOn, System_TariffWageGroups.NameVisible AS WageGroupName FROM Master_EmployeeMinWageAttestation INNER JOIN System_TariffWageGroups ON Master_EmployeeMinWageAttestation.SystemID = System_TariffWageGroups.SystemID AND Master_EmployeeMinWageAttestation.WageGroupID = System_TariffWageGroups.TariffWageGroupID WHERE (Master_EmployeeMinWageAttestation.SystemID = @SystemID) AND (Master_EmployeeMinWageAttestation.BpID = @BpID) AND (Master_EmployeeMinWageAttestation.EmployeeID = @EmployeeID)" UpdateCommand="UPDATE Master_EmployeeMinWageAttestation SET ForMonth = @ForMonth, Amount = @Amount, WageGroupID = @WageGroupID, Status = @Status, ReceivedBy = @ReceivedBy, ReceivedOn = @ReceivedOn, RequestBy = @RequestBy, RequestOn = @RequestOn, DocumentID = @DocumentID, CreatedFrom = @UserName, CreatedOn = SYSDATETIME(), EditFrom = @UserName, EditOn = SYSDATETIME() WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (EmployeeID = @EmployeeID)">
                        <SelectParameters>
                            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                            <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                        </SelectParameters>
                    </asp:SqlDataSource>

                </telerik:RadPageView>

                <%-- Document rules --%>
                <telerik:RadPageView ID="RadPageView5" runat="server">
                    <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                        <table id="Table13" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                            <tr>
                                <td style="vertical-align: top;">
                                    <table id="Table14" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ", ", Resources.Resource.lblAddrFirstName, ":") %>'
                                                           ></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LastName, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).FirstName) %>'
                                                           ></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ", ", Resources.Resource.lblAddrEmail, ":") %>'
                                                           ></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Phone, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Email) %>'
                                                           ></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'
                                                           ></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameVisible, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameAdditional) %>'
                                                           ></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelMaxHrsPerMonth" Text='<%# String.Concat(Resources.Resource.lblMaxHrsPerMonth, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="MaxHrsPerMonth" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).MaxHrsPerMonth %>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelAppliedRule" Text='<%# String.Concat(Resources.Resource.lblAppliedRule, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="AppliedRule"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="LabelRadGridDocumentRules" Text='<%# String.Concat(Resources.Resource.lblDocumentRules, ":") %>' runat="server"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <telerik:RadGrid runat="server" ID="RadGridDocumentRules" DataSourceID="SqlDataSource_DocumentRules1" Enabled="false"
                                                                             AllowAutomaticUpdates="false">
                                                                <MasterTableView DataSourceID="SqlDataSource_DocumentRules1" AutoGenerateColumns="false" AllowPaging="true" PageSize="5">

                                                                    <Columns>
                                                                        <telerik:GridTemplateColumn DataField="RelevantFor" DataType="System.Int16"
                                                                                                    HeaderText="<%= Resources.Resource.lblRelevantFor %>" SortExpression="RelevantFor" UniqueName="RelevantFor">
                                                                            <ItemTemplate>
                                                                                <asp:Label runat="server" ID="RelevantFor" Text='<%# GetRelevantFor(Convert.ToInt16(((System.Data.DataRowView)Container.DataItem)["RelevantFor"])) %>'></asp:Label>
                                                                            </ItemTemplate>
                                                                        </telerik:GridTemplateColumn>

                                                                        <telerik:GridTemplateColumn DataField="RelevantDocumentID" DataType="System.Int32"
                                                                                                    HeaderText="<%= Resources.Resource.lblDocument %>" SortExpression="RelevantDocumentID" UniqueName="RelevantDocumentID">
                                                                            <ItemTemplate>
                                                                                <asp:Label runat="server" ID="RelevantDocumentID1" Text='<%# ((System.Data.DataRowView)Container.DataItem)["NameVisible"] %>'></asp:Label>
                                                                            </ItemTemplate>
                                                                        </telerik:GridTemplateColumn>

                                                                        <telerik:GridCheckBoxColumn DataField="IsAccessRelevant" HeaderText="<%= Resources.Resource.lblAccessRelevant %>" SortExpression="IsAccessRelevant" UniqueName="IsAccessRelevant" DataType="System.Boolean" FilterControlAltText="Filter IsAccessRelevant column"></telerik:GridCheckBoxColumn>

                                                                        <telerik:GridCheckBoxColumn DataField="DocumentReceived" HeaderText="<%= Resources.Resource.lblIsPresent %>" SortExpression="DocumentReceived" UniqueName="DocumentReceived" DataType="System.Boolean" FilterControlAltText="Filter DocumentReceived column"></telerik:GridCheckBoxColumn>

                                                                        <telerik:GridTemplateColumn DataField="ExpirationDate" DataType="System.DateTime" FilterControlAltText="Filter ExpirationDate column"
                                                                                                    HeaderText="<%= Resources.Resource.lblExpirationDate %>" SortExpression="ExpirationDate" UniqueName="ExpirationDate">
                                                                            <ItemTemplate>
                                                                                <asp:Label runat="server" ID="ExpirationDate" Text='<%# ((System.Data.DataRowView)Container.DataItem)["ExpirationDate"] %>'></asp:Label>
                                                                            </ItemTemplate>
                                                                        </telerik:GridTemplateColumn>

                                                                        <telerik:GridTemplateColumn DataField="IDNumber" DataType="System.String" FilterControlAltText="Filter IDNumber column"
                                                                                                    HeaderText="<%= Resources.Resource.lblDocumentID %>" SortExpression="IDNumber" UniqueName="IDNumber">
                                                                            <ItemTemplate>
                                                                                <asp:Label runat="server" ID="IDNumber" Text='<%# ((System.Data.DataRowView)Container.DataItem)["IDNumber"] %>'></asp:Label>
                                                                            </ItemTemplate>
                                                                        </telerik:GridTemplateColumn>
                                                                    </Columns>
                                                                </MasterTableView>
                                                            </telerik:RadGrid>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>

                    <asp:SqlDataSource ID="SqlDataSource_DocumentRules1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                       SelectCommand="SELECT erd.SystemID, erd.BpID, erd.EmployeeID, erd.RelevantFor, erd.RelevantDocumentID, rd.NameVisible, erd.DocumentReceived, erd.ExpirationDate, erd.IDNumber, tr1.DescriptionTranslated AS ToolTipExpiration, tr2.DescriptionTranslated AS ToolTipDocumentID, rd.IsAccessRelevant FROM Master_Translations AS tr2 RIGHT OUTER JOIN Master_RelevantDocuments AS rd ON tr2.SystemID = rd.SystemID AND tr2.BpID = rd.BpID AND tr2.ForeignID = rd.RelevantDocumentID LEFT OUTER JOIN Master_Translations AS tr1 ON rd.SystemID = tr1.SystemID AND rd.BpID = tr1.BpID AND rd.RelevantDocumentID = tr1.ForeignID RIGHT OUTER JOIN Master_EmployeeRelevantDocuments AS erd ON rd.SystemID = erd.SystemID AND rd.BpID = erd.BpID AND rd.RelevantDocumentID = erd.RelevantDocumentID WHERE (tr1.DialogID = 6) AND (tr1.FieldID = 13) AND (tr2.DialogID = 6) AND (tr2.FieldID = 14) AND (tr1.LanguageID = @LanguageID) AND (tr2.LanguageID = @LanguageID) AND (erd.SystemID = @SystemID) AND (erd.BpID = @BpID) AND (erd.EmployeeID = @EmployeeID) OR (tr1.DialogID IS NULL) AND (tr1.FieldID IS NULL) AND (tr2.DialogID IS NULL) AND (tr2.FieldID IS NULL) AND (tr1.LanguageID IS NULL) AND (tr2.LanguageID IS NULL) AND (erd.SystemID = @SystemID) AND (erd.BpID = @BpID) AND (erd.EmployeeID = @EmployeeID)">
                        <SelectParameters>
                            <asp:SessionParameter SessionField="LanguageID" DefaultValue="en" Name="LanguageID"></asp:SessionParameter>
                            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                            <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                        </SelectParameters>
                    </asp:SqlDataSource>
                </telerik:RadPageView>

                <%-- Access control --%>
                <telerik:RadPageView ID="RadPageView6" runat="server">
                    <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                        <table id="Table15" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                            <tr>
                                <td style="vertical-align: top;">
                                    <table id="Table16" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ", ", Resources.Resource.lblAddrFirstName, ":") %>'
                                                           ></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LastName, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).FirstName) %>'
                                                           ></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ", ", Resources.Resource.lblAddrEmail, ":") %>'
                                                           ></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Phone, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Email) %>'
                                                           ></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'
                                                           ></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameVisible, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameAdditional) %>'
                                                           ></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelAttributeID" Text='<%# String.Concat(Resources.Resource.lblAttributeForPrintPass, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <telerik:RadComboBox runat="server" ID="AttributeID" EmptyMessage="<%= Resources.Resource.msgPleaseTypeHere %>"
                                                                     DataValueField="AttributeID" DataTextField="NameVisible" Width="300" DataSourceID="SqlDataSource_AssignedAttributes1"
                                                                     Filter="Contains" AppendDataBoundItems="true" DropDownAutoWidth="Enabled" SelectedValue='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).AttributeID %>' Enabled="false">
                                                    <Items>
                                                        <telerik:RadComboBoxItem Text="<%= Resources.Resource.selNoSelection %>" Value="0" />
                                                    </Items>
                                                </telerik:RadComboBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelExternalPassID" Text='<%# String.Concat(Resources.Resource.lblExternalPassID, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="ExternalPassID" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).ExternalPassID %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelAccessRightValidUntil" Text='<%# String.Concat(Resources.Resource.lblAccessRightValidUntil, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="AccessRightValidUntil" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).AccessRightValidUntil %>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
                                        </tr>
                                        <tr>
                                            <td style="vertical-align: top;">
                                                <asp:Label runat="server" ID="LabelAccessDenialTimeStamp" Text='<%# String.Concat(Resources.Resource.lblAccessRightTimeStamp, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="AccessDenialTimeStamp" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).AccessDenialTimeStamp %>'></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="vertical-align: top;">
                                                <asp:Label runat="server" ID="LabelAccessDenialReason" Text='<%# String.Concat(Resources.Resource.lblEmplAccess4, ":") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="AccessDenialReason"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp; </td>
                                            <td>&nbsp; </td>
                                        </tr>

                                        <tr>
                                            <td>
                                                <table style="vertical-align: top;">
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelAssignedAreas" Text='<%# String.Concat(Resources.Resource.lblAssignedAreas, ":") %>'></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <telerik:RadGrid runat="server" ID="AssignedAreas" DataSourceID="SqlDataSource_EmployeeAccessAreas2" CssClass="RadGrid"
                                                                             AllowAutomaticDeletes="false" AllowAutomaticInserts="false" AllowAutomaticUpdates="false">
                                                                <MasterTableView DataSourceID="SqlDataSource_EmployeeAccessAreas2" AutoGenerateColumns="false" AllowPaging="true" PageSize="5"
                                                                                 CommandItemDisplay="None" CssClass="MasterClass" DataKeyNames="SystemID,BpID,EmployeeID,AccessAreaID,TimeSlotGroupID">

                                                                    <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="false" />

                                                                    <Columns>
                                                                        <telerik:GridBoundColumn DataField="AccessAreaID" UniqueName="AccessAreaID" ForceExtractValue="Always" Visible="false">
                                                                        </telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="TimeSlotGroupID" UniqueName="TimeSlotGroupID" ForceExtractValue="Always" Visible="false">
                                                                        </telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="AccessAreaName" HeaderText="<%= Resources.Resource.lblAccessArea %>">
                                                                        </telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="TimeSlotGroupName" HeaderText="<%= Resources.Resource.lblTimeSlotGroup %>">
                                                                        </telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="CreatedFrom" UniqueName="CreatedFrom" ForceExtractValue="Always" Visible="false">
                                                                        </telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="CreatedOn" UniqueName="CreatedOn" ForceExtractValue="Always" Visible="false">
                                                                        </telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="EditFrom" UniqueName="EditFrom" ForceExtractValue="Always" Visible="false">
                                                                        </telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="EditOn" UniqueName="EditOn" ForceExtractValue="Always" Visible="false">
                                                                        </telerik:GridBoundColumn>
                                                                    </Columns>
                                                                </MasterTableView>
                                                            </telerik:RadGrid>
                                                            <asp:SqlDataSource ID="SqlDataSource_EmployeeAccessAreas2" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                                                               SelectCommand="SELECT Master_EmployeeAccessAreas.AccessAreaID, Master_AccessAreas.NameVisible AS AccessAreaName, Master_AccessAreas.DescriptionShort, Master_EmployeeAccessAreas.BpID, Master_TimeSlotGroups.NameVisible AS TimeSlotGroupName, Master_EmployeeAccessAreas.TimeSlotGroupID, Master_EmployeeAccessAreas.CreatedFrom, Master_EmployeeAccessAreas.CreatedOn, Master_EmployeeAccessAreas.EditFrom, Master_EmployeeAccessAreas.EditOn, Master_EmployeeAccessAreas.EmployeeID, Master_EmployeeAccessAreas.SystemID FROM Master_EmployeeAccessAreas INNER JOIN Master_AccessAreas ON Master_EmployeeAccessAreas.SystemID = Master_AccessAreas.SystemID AND Master_EmployeeAccessAreas.BpID = Master_AccessAreas.BpID AND Master_EmployeeAccessAreas.AccessAreaID = Master_AccessAreas.AccessAreaID LEFT OUTER JOIN Master_TimeSlotGroups ON Master_EmployeeAccessAreas.SystemID = Master_TimeSlotGroups.SystemID AND Master_EmployeeAccessAreas.BpID = Master_TimeSlotGroups.BpID AND Master_EmployeeAccessAreas.TimeSlotGroupID = Master_TimeSlotGroups.TimeSlotGroupID WHERE (Master_EmployeeAccessAreas.SystemID = @SystemID) AND (Master_EmployeeAccessAreas.BpID = @BpID) AND (Master_EmployeeAccessAreas.EmployeeID = @EmployeeID)">
                                                                <SelectParameters>
                                                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                                                    <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                                                    <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                                                                </SelectParameters>
                                                            </asp:SqlDataSource>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp; </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelRadGridEmplAccess3" Text='<%# String.Concat(Resources.Resource.lblEmplAccess3, ":") %>'></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <telerik:RadGrid runat="server" ID="RadGridEmplAccess3" DataSourceID="SqlDataSource_StatusID1">
                                                                <MasterTableView DataSourceID="SqlDataSource_StatusID1" AutoGenerateColumns="false" AllowPaging="true" PageSize="5">
                                                                    <Columns>
                                                                        <telerik:GridTemplateColumn DataField="ResourceID" HeaderText="<%= Resources.Resource.lblAction %>">
                                                                            <ItemTemplate>
                                                                                <asp:Label runat="server" ID="ResourceID" Text='<%# GetResource(((System.Data.DataRowView)Container.DataItem)["ResourceID"].ToString()) %>'></asp:Label>
                                                                            </ItemTemplate>
                                                                        </telerik:GridTemplateColumn>
                                                                        <telerik:GridBoundColumn DataField="InternalID" HeaderText="<%= Resources.Resource.lblIDInternal %>"></telerik:GridBoundColumn>
                                                                        <telerik:GridBoundColumn DataField="ExternalID" HeaderText="<%= Resources.Resource.lblIDExternal %>"></telerik:GridBoundColumn>
                                                                        <telerik:GridBoundColumn DataField="Timestamp" HeaderText="<%= Resources.Resource.lblTimeStamp %>"></telerik:GridBoundColumn>
                                                                        <telerik:GridBoundColumn DataField="Reason" HeaderText="<%= Resources.Resource.lblReason %>"></telerik:GridBoundColumn>
                                                                    </Columns>
                                                                </MasterTableView>
                                                            </telerik:RadGrid>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp; </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelRadGridEmplAccess1" Text='<%# String.Concat(Resources.Resource.lblEmplAccess1, ":") %>'></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <telerik:RadGrid runat="server" ID="RadGridEmplAccess1" DataSourceID="SqlDataSource_AccessLog3">
                                                                <MasterTableView DataSourceID="SqlDataSource_AccessLog3" AutoGenerateColumns="false" AllowPaging="true" PageSize="5"
                                                                                 CommandItemDisplay="Top">

                                                                    <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="false" ShowExportToCsvButton="false"
                                                                                         ShowExportToExcelButton="false" ShowExportToPdfButton="false"
                                                                                         AddNewRecordText="<%= Resources.Resource.lblActionNew %>"
                                                                                         RefreshText="<%= Resources.Resource.lblActionRefresh %>" />

                                                                    <Columns>
                                                                        <telerik:GridBoundColumn DataField="NameVisible" HeaderText="<%= Resources.Resource.lblAccessArea %>"></telerik:GridBoundColumn>
                                                                        <telerik:GridTemplateColumn DataField="AccessState" HeaderText="<%= Resources.Resource.lblStatus %>">
                                                                            <ItemTemplate>
                                                                                <asp:Label ID="AccessState" runat="server" Text='<%# GetAccessState(Convert.ToInt32(((System.Data.DataRowView)Container.DataItem)["AccessState"])) %>'>
                                                                                </asp:Label>
                                                                            </ItemTemplate>
                                                                        </telerik:GridTemplateColumn>
                                                                    </Columns>
                                                                </MasterTableView>
                                                            </telerik:RadGrid>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp; </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label runat="server" ID="LabelRadGridEmplAccess2" Text='<%# String.Concat(Resources.Resource.lblEmplAccess2, ":") %>'></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <telerik:RadGrid runat="server" ID="RadGridEmplAccess2" DataSourceID="SqlDataSource_AccessLog4" GroupPanelPosition="Top" CellSpacing="-1" Culture="de-DE" GridLines="Both">
                                                                <MasterTableView DataSourceID="SqlDataSource_AccessLog4" AutoGenerateColumns="false" AllowPaging="true" PageSize="5"
                                                                                 CommandItemDisplay="Top">

                                                                    <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="false" ShowExportToCsvButton="false"
                                                                                         ShowExportToExcelButton="false" ShowExportToPdfButton="false"
                                                                                         AddNewRecordText="<%= Resources.Resource.lblActionNew %>"
                                                                                         RefreshText="<%= Resources.Resource.lblActionRefresh %>" />

                                                                    <Columns>
                                                                        <telerik:GridBoundColumn DataField="Timestamp" HeaderText="<%= Resources.Resource.lblTimeStamp %>"></telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="AccessAreaID" Visible="false"></telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="EmployeeID" UniqueName="EmployeeID2" Visible="false"></telerik:GridBoundColumn>

                                                                        <telerik:GridBoundColumn DataField="NameVisible" HeaderText="<%= Resources.Resource.lblAccessArea %>"></telerik:GridBoundColumn>

                                                                        <telerik:GridTemplateColumn DataField="AccessTypeID" HeaderText="<%= Resources.Resource.lblAction %>" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                                            <ItemTemplate>
                                                                                <asp:Image runat="server" ImageUrl='<%# (Convert.ToInt32(Eval("AccessTypeID")) == 1) ? "~/Resources/Icons/enter-16.png" : "~/Resources/Icons/exit-16.png" %>' 
                                                                                           Width="16px" Height="16px" ToolTip='<%# GetAccessType(Convert.ToInt32(((System.Data.DataRowView)Container.DataItem)["AccessTypeID"])) %>' />
                                                                            </ItemTemplate>
                                                                        </telerik:GridTemplateColumn>

                                                                        <telerik:GridTemplateColumn DataField="Result" HeaderText="<%= Resources.Resource.lblResult %>">
                                                                            <ItemTemplate>
                                                                                <asp:Label runat="server" Text='<%# Eval("Result").ToString().Equals("1") ? Resources.Resource.lblOK : Resources.Resource.lblFault %>' 
                                                                                           ForeColor='<%# Eval("Result").ToString().Equals("1") ? System.Drawing.Color.DarkGreen : System.Drawing.Color.Red %>'></asp:Label>
                                                                            </ItemTemplate>
                                                                        </telerik:GridTemplateColumn>

                                                                        <telerik:GridTemplateColumn DataField="IsOnlineAccessEvent" HeaderText="<%= Resources.Resource.lblStatus %>" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                                            <ItemTemplate>
                                                                                <asp:Image runat="server" ImageUrl='<%# Convert.ToBoolean(Eval("IsOnlineAccessEvent")) ? "~/Resources/Icons/Online_16.png" : "~/Resources/Icons/Offline_16.png" %>' 
                                                                                           Width="16px" Height="16px" ToolTip='<%# Convert.ToBoolean(Eval("IsOnlineAccessEvent")) ? Resources.Resource.lblOnline : Resources.Resource.lblOffline %>' />
                                                                            </ItemTemplate>
                                                                        </telerik:GridTemplateColumn>

                                                                        <telerik:GridTemplateColumn DataField="IsManualEntry" HeaderText="<%= Resources.Resource.lblManual %>">
                                                                            <ItemTemplate>
                                                                                <asp:Label runat="server" Text='<%# Convert.ToBoolean(Eval("IsManualEntry")) ? Resources.Resource.lblYes : Resources.Resource.lblNo %>'></asp:Label>
                                                                            </ItemTemplate>
                                                                        </telerik:GridTemplateColumn>

                                                                        <telerik:GridTemplateColumn DataField="OriginalMessage" HeaderText="<%$ Resources:Resource, lblDenialReason %>" ForceExtractValue="Always" SortExpression="OriginalMessage" 
                                                                                                    UniqueName="OriginalMessage" AutoPostBackOnFilter="true" CurrentFilterFunction="Contains" FilterControlWidth="80px" GroupByExpression="OriginalMessage Group By OriginalMessage">
                                                                            <ItemTemplate>
                                                                                <asp:Label runat="server" ID="OriginalMessage" Text='<%# Eval("OriginalMessage") %>'></asp:Label>
                                                                            </ItemTemplate>
                                                                        </telerik:GridTemplateColumn>
                                                                    </Columns>
                                                                </MasterTableView>
                                                            </telerik:RadGrid>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>&nbsp; </td>
                                                    </tr>
                                                </table>
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
                                <td align="left" colspan="2">
                                    <telerik:RadButton runat="server" ID="AccessRightInfo" Text="<%# Resources.Resource.lblAccessRightsInfo %>" AutoPostBack="false"
                                                       ButtonType="StandardButton" BorderStyle="None" CausesValidation="false">
                                        <Icon PrimaryIconUrl="../../Resources/Icons/info_16.png" PrimaryIconHeight="16px" PrimaryIconWidth="16px" />
                                    </telerik:RadButton>
                                </td>
                            </tr>
                        </table>

                        <asp:SqlDataSource ID="SqlDataSource_AssignedAttributes1" runat="server" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                                           SelectCommand="SELECT ac.SystemID, ac.BpID, ac.AttributeID, ab.NameVisible, ab.DescriptionShort, ac.CreatedFrom, ac.CreatedOn, ac.EditFrom, ac.EditOn, ac.CompanyID FROM Master_AttributesCompany AS ac INNER JOIN Master_AttributesBuildingProject AS ab ON ac.SystemID = ab.SystemID AND ac.BpID = ab.BpID AND ac.AttributeID = ab.AttributeID WHERE (ac.SystemID = @SystemID) AND (ac.BpID = @BpID) AND (ac.CompanyID = @CompanyID)">
                            <SelectParameters>
                                <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
                                <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
                                <asp:ControlParameter ControlID="CompanyID" PropertyName="Value" DefaultValue="0" Name="CompanyID"></asp:ControlParameter>
                            </SelectParameters>
                        </asp:SqlDataSource>

                        <asp:SqlDataSource ID="SqlDataSource_AccessAreas1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                           SelectCommand="SELECT * FROM Master_AccessAreas aa WHERE aa.SystemID = @SystemID AND aa.BpID = @BpID AND NOT EXISTS (SELECT 1 FROM Master_EmployeeAccessAreas eaa WHERE  eaa.SystemID = @SystemID AND eaa.BpID = @BpID AND eaa.EmployeeID = @EmployeeID AND eaa.AccessAreaID = aa.AccessAreaID)">
                            <SelectParameters>
                                <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                            </SelectParameters>
                        </asp:SqlDataSource>

                        <asp:SqlDataSource ID="SqlDataSource_EmployeeAccessAreas1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                           SelectCommand="SELECT Master_EmployeeAccessAreas.AccessAreaID, Master_AccessAreas.NameVisible, Master_AccessAreas.DescriptionShort FROM Master_EmployeeAccessAreas INNER JOIN Master_AccessAreas ON Master_EmployeeAccessAreas.SystemID = Master_AccessAreas.SystemID AND Master_EmployeeAccessAreas.BpID = Master_AccessAreas.BpID AND Master_EmployeeAccessAreas.AccessAreaID = Master_AccessAreas.AccessAreaID WHERE (Master_EmployeeAccessAreas.SystemID = @SystemID) AND (Master_EmployeeAccessAreas.BpID = @BpID) AND (Master_EmployeeAccessAreas.EmployeeID = @EmployeeID)">
                            <SelectParameters>
                                <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                            </SelectParameters>
                        </asp:SqlDataSource>

                        <asp:SqlDataSource ID="SqlDataSource_AccessLog3" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                           SelectCommand="SELECT Master_AccessAreas.NameVisible, SUM(ISNULL(Data_AccessEvents.AccessType, 0)) AS AccessState FROM Master_AccessAreas INNER JOIN Master_EmployeeAccessAreas ON Master_AccessAreas.SystemID = Master_EmployeeAccessAreas.SystemID AND Master_AccessAreas.BpID = Master_EmployeeAccessAreas.BpID AND Master_AccessAreas.AccessAreaID = Master_EmployeeAccessAreas.AccessAreaID LEFT OUTER JOIN Data_AccessEvents ON Master_EmployeeAccessAreas.EmployeeID = Data_AccessEvents.OwnerID AND Master_EmployeeAccessAreas.AccessAreaID = Data_AccessEvents.AccessAreaID AND Master_EmployeeAccessAreas.SystemID = Data_AccessEvents.SystemID AND Master_EmployeeAccessAreas.BpID = Data_AccessEvents.BpID WHERE (Master_EmployeeAccessAreas.SystemID = @SystemID) AND (Master_EmployeeAccessAreas.BpID = @BpID) AND (Master_EmployeeAccessAreas.EmployeeID = @EmployeeID) GROUP BY Master_AccessAreas.NameVisible">
                            <SelectParameters>
                                <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                            </SelectParameters>
                        </asp:SqlDataSource>

                        <asp:SqlDataSource ID="SqlDataSource_AccessLog4" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                            SelectCommand="SELECT d_ae.AccessEventID, d_ae.AccessOn AS Timestamp, m_aa.NameVisible, d_ae.AccessType AS AccessTypeID, d_ae.AccessResult AS Result, m_aa.AccessAreaID, d_ae.CreatedOn, d_ae.OwnerID AS EmployeeID, d_ae.IsManualEntry, d_ae.Remark, d_ae.CreatedFrom, d_ae.EditOn, d_ae.EditFrom, d_ae.IsOnlineAccessEvent, d_ae.DenialReason, System_ReturnCodes.OriginalMessage FROM Master_AccessAreas AS m_aa INNER JOIN Data_AccessEvents AS d_ae ON m_aa.SystemID = d_ae.SystemID AND m_aa.BpID = d_ae.BpID AND m_aa.AccessAreaID = d_ae.AccessAreaID LEFT OUTER JOIN System_ReturnCodes ON d_ae.SystemID = System_ReturnCodes.SystemID AND d_ae.DenialReason = System_ReturnCodes.ReturnCodeID WHERE (d_ae.SystemID = @SystemID) AND (d_ae.BpID = @BpID) AND (d_ae.OwnerID = @EmployeeID) AND (d_ae.PassType = 1) ORDER BY Timestamp DESC">
                            <SelectParameters>
                                <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                            </SelectParameters>
                        </asp:SqlDataSource>

                        <asp:SqlDataSource ID="SqlDataSource_StatusID1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                           SelectCommand="SELECT Data_PassHistory.ActionID, Master_Passes.InternalID, Master_Passes.ExternalID, Data_PassHistory.Timestamp, Data_PassHistory.Reason, System_Actions.NameVisible, System_Actions.ResourceID FROM Data_PassHistory INNER JOIN Master_Passes ON Data_PassHistory.SystemID = Master_Passes.SystemID AND Data_PassHistory.BpID = Master_Passes.BpID AND Data_PassHistory.PassID = Master_Passes.PassID INNER JOIN System_Actions ON Data_PassHistory.SystemID = System_Actions.SystemID AND Data_PassHistory.ActionID = System_Actions.ActionID WHERE (Data_PassHistory.SystemID = @SystemID) AND (Data_PassHistory.BpID = @BpID) AND (Data_PassHistory.EmployeeID = @EmployeeID) ORDER BY Data_PassHistory.Timestamp DESC">
                            <SelectParameters>
                                <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                            </SelectParameters>
                        </asp:SqlDataSource>

                        <asp:SqlDataSource ID="SqlDataSource_DenyReasons1" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                           SelectCommand="SELECT AccessDenialReason AS Reason, CreatedOn AS TimeStamp FROM Data_AccessRightEvents WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (OwnerID = @EmployeeID) AND (PassType = 1) AND (AccessAllowed = 0) AND (IsNewest = 1) AND (HasSubstitute = 0)">
                            <SelectParameters>
                                <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID"></asp:SessionParameter>
                                <asp:ControlParameter ControlID="EmployeeID" PropertyName="Text" DefaultValue="0" Name="EmployeeID"></asp:ControlParameter>
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>

                </telerik:RadPageView>

                <%-- Other criterias --%>
                <telerik:RadPageView ID="RadPageView7" runat="server">
                    <div style="border-color: ActiveBorder; border-width: 1px; border-style: solid; border-radius: 5px; padding: 5px; margin: 5px;">
                        <table id="Table9" cellspacing="2" cellpadding="2" border="0" rules="none" style="border-collapse: collapse; vertical-align: top;">
                            <tr>
                                <td style="vertical-align: top;">
                                    <table id="Table10" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ", ", Resources.Resource.lblAddrFirstName, ":") %>'
                                                           ></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).LastName, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).FirstName) %>'
                                                           ></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ", ", Resources.Resource.lblAddrEmail, ":") %>'
                                                           ></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Phone, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).Email) %>'
                                                           ></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(Resources.Resource.lblEmployer, ":") %>'
                                                           ></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" Text='<%# String.Concat(((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameVisible, ", ", ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).NameAdditional) %>'
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
                                                <asp:Label runat="server" ID="UserString1" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).UserString1 %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelUserString2" Text='<%# String.Concat(Resources.Resource.lblUserDefinedString, " 2:") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="UserString2" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).UserString2 %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelUserString3" Text='<%# String.Concat(Resources.Resource.lblUserDefinedString, " 3:") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="UserString3" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).UserString3 %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelUserString4" Text='<%# String.Concat(Resources.Resource.lblUserDefinedString, " 4:") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label runat="server" ID="UserString4" Text='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).UserString4 %>' Width="300px"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelUserBit1" Text='<%# String.Concat(Resources.Resource.lblUserDefinedBit, " 1:") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:CheckBox runat="server" CssClass="cb" ID="UserBit1" Checked='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).UserBit1 %>'></asp:CheckBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelUserBit2" Text='<%# String.Concat(Resources.Resource.lblUserDefinedBit, " 2:") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:CheckBox runat="server" CssClass="cb" ID="UserBit2" Checked='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).UserBit2 %>'></asp:CheckBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelUserBit3" Text='<%# String.Concat(Resources.Resource.lblUserDefinedBit, " 3:") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:CheckBox runat="server" CssClass="cb" ID="UserBit3" Checked='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).UserBit3 %>'></asp:CheckBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label runat="server" ID="LabelUserBit4" Text='<%# String.Concat(Resources.Resource.lblUserDefinedBit, " 4:") %>'></asp:Label>
                                            </td>
                                            <td>
                                                <asp:CheckBox runat="server" CssClass="cb" ID="UserBit4" Checked='<%# ((InSite.App.UserServices.GetEmployees_Result)Container.DataItem).UserBit4 %>'></asp:CheckBox>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>

                </telerik:RadPageView>

            </telerik:RadMultiPage>
        </telerik:RadAjaxPanel>
    </ItemTemplate>
</asp:FormView>
