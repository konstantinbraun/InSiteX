<%@ Page Title="<%$ Resources:Resource, lblUsers %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="InSite.App.Views.Central.Users" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">
    <telerik:RadScriptBlock runat="server" ID="ScriptBlock1">
        <script type="text/javascript">
            function openRadWindow(sender, args, UserID) {
                var oWnd = radopen("UserChangePassword.aspx?UserID=" + UserID, "RadWindow1");
                oWnd.center();
            }
        </script>
    </telerik:RadScriptBlock>

    <telerik:RadPersistenceManagerProxy ID="RadPersistenceManagerProxy1" runat="server">
        <PersistenceSettings>
            <telerik:PersistenceSetting ControlID="RadGrid1" />
        </PersistenceSettings>
    </telerik:RadPersistenceManagerProxy>

    <telerik:RadAjaxManagerProxy ID="AjaxManagerProxy1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGrid1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="SelectBp">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" LoadingPanelID="RadAjaxLoadingPanelMaster" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RadGridBP">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGridBP" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <div style="background-color: InactiveBorder;">
        <table>
            <tr>
                <td style="padding: 5px; vertical-align: top; width: 200px;">
                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblLimitView %>" Font-Bold="true"></asp:Label>
                    <br />
                    <asp:Label runat="server" Text="<%$ Resources:Resource, msgLimitView %>"></asp:Label>
                </td>
                <td style="padding: 5px; vertical-align: top;">
                    <telerik:RadComboBox runat="server" ID="SelectBp" OnSelectedIndexChanged="SelectBp_SelectedIndexChanged" AutoPostBack="true" DataSourceID="SqlDataSource_UserBuildingProjects" 
                                         DataValueField="BpID" DataTextField="NameVisible" DropDownAutoWidth="Enabled" AppendDataBoundItems="true">
                        <Items>
                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selShowAll %>" Value="0" Selected="true"/>
                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selAllBuildingProjects %>" Value="-1"/>
                            <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoBPAssigned %>" Value="-2"/>
                            <telerik:RadComboBoxItem IsSeparator="true" Height="5px" Text="——————————————"></telerik:RadComboBoxItem>
                        </Items>
                    </telerik:RadComboBox>
                </td>
                <td style="border-right-color: ActiveBorder; border-right-style: solid; border-right-width: 1px;">&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
        </table>
    </div>

    <telerik:RadGrid ID="RadGrid1" runat="server" AllowFilteringByColumn="True" CssClass="MainGrid" GroupPanelPosition="BeforeHeader"
                     AllowPaging="True" AllowSorting="True" ShowGroupPanel="True" EnableHeaderContextFilterMenu="True" EnableHeaderContextMenu="True"
                     GroupPanel-Text="<%$ Resources:Resource, msgGroupPanel %>" EnableLinqExpressions="false"
                     OnPreRender="RadGrid1_PreRender" OnInsertCommand="RadGrid1_InsertCommand" OnUpdateCommand="RadGrid1_UpdateCommand"
                     OnItemDataBound="RadGrid1_ItemDataBound" OnItemCommand="RadGrid1_ItemCommand" OnDeleteCommand="RadGrid1_DeleteCommand"
                     OnGroupsChanging="RadGrid1_GroupsChanging" OnNeedDataSource="RadGrid1_NeedDataSource"
                     OnItemCreated="RadGrid1_ItemCreated">

        <GroupingSettings ShowUnGroupButton="True" CaseSensitive="false" />

        <ExportSettings ExportOnlyData="True" IgnorePaging="True">
            <Pdf PaperSize="A4">
            </Pdf>
            <Excel Format="ExcelML" />
        </ExportSettings>

        <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false">
            <Resizing AllowColumnResize="true"></Resizing>
            <Selecting AllowRowSelect="True" />
            <ClientEvents OnRowClick="OnRowClick" OnKeyPress="GridKeyPress" />
        </ClientSettings>

        <SortingSettings SortedBackColor="Transparent" />

        <MasterTableView EnableHierarchyExpandAll="true" EditMode="PopUp" AutoGenerateColumns="False" DataKeyNames="SystemID,UserID"
                         CommandItemDisplay="Top" HierarchyLoadMode="ServerOnDemand" EnableHeaderContextMenu="true" AllowMultiColumnSorting="true" TableLayout="Auto">

            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

            <GroupByExpressions>
                <telerik:GridGroupByExpression>
                    <SelectFields>
                        <telerik:GridGroupByField FieldAlias="FirstChar" FieldName="FirstChar" HeaderText=" " FormatString="<b>{0}</b>" HeaderValueSeparator=""></telerik:GridGroupByField>
                    </SelectFields>
                    <GroupByFields>
                        <telerik:GridGroupByField FieldName="FirstChar" FormatString="{0}"></telerik:GridGroupByField>
                    </GroupByFields>
                </telerik:GridGroupByExpression>
            </GroupByExpressions>

            <CommandItemTemplate>
                <div style="margin: 3px; height: 20px;">
                    <telerik:RadButton ID="btnInitInsert" runat="server" CommandName="InitInsert" Visible="true" Text='<%# Resources.Resource.lblActionNew %>'
                                       Icon-PrimaryIconCssClass="rbAdd" ButtonType="SkinnedButton" BorderStyle="None" BackColor="Transparent">
                    </telerik:RadButton>

                    <asp:PlaceHolder runat="server" ID="AlphaFilter"></asp:PlaceHolder>

                    <telerik:RadButton ID="btnExportCsv" runat="server" Text="" ToolTip='<%# Resources.Resource.lblExportToCsv %>' CssClass="rgExpCSV FloatRight" CommandName="ExportToCSV"
                                       ButtonType="LinkButton" Visible="false" BackColor="Transparent">
                    </telerik:RadButton>
                    &nbsp;&nbsp;

                    <telerik:RadButton ID="btnExportExcel" runat="server" Text="" ToolTip='<%# Resources.Resource.lblExportToExcel %>' CssClass="rgExpXLS FloatRight" CommandName="ExportToExcel"
                                       ButtonType="SkinnedButton" Visible="true" BorderStyle="None" BackColor="Transparent" Width="30px" Height="20px">
                        <Icon PrimaryIconUrl="../../Resources/Icons/export_xlsx_16.png" />
                    </telerik:RadButton>

                    <telerik:RadButton ID="btnExportPdf" runat="server" Text="" ToolTip='<%# Resources.Resource.lblExportToPdf %>' CssClass="rgExpPDF FloatRight" CommandName="ExportToPdf"
                                       ButtonType="LinkButton" Visible="false" BackColor="Transparent">
                    </telerik:RadButton>

                    <div class="vertical-line"></div>

                    <telerik:RadButton ID="btnRefresh" runat="server" CommandName="RebindGrid" Text='<%# Resources.Resource.lblActionRefresh %>'
                                       Icon-PrimaryIconCssClass="rbRefresh" ButtonType="SkinnedButton" BorderStyle="None" CssClass="FloatRight" BackColor="Transparent">
                    </telerik:RadButton>
                </div>
            </CommandItemTemplate>

            <EditFormSettings EditFormType="Template" CaptionDataField="UserName" CaptionFormatString="<%$ Resources:Resource, lblUsers %>">
                <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                <FormTemplate>
                    <table id="Table1" cellspacing="2" cellpadding="2" border="0" rules="none" class="EditFormTable">
                        <tr>
                            <td style="vertical-align: top;">
                                <table id="Table2" cellspacing="2" cellpadding="2" border="0" class="module" style="vertical-align: top;">
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="LabelUserID" Text='<%# String.Concat(Resources.Resource.lblUserID, ":") %>'></asp:Label>
                                        </td>
                                        <td>
                                            <asp:HiddenField runat="server" ID="CompanyStatusID" Value='<%# Eval("CompanyStatusID") %>' />
                                            <asp:HiddenField runat="server" ID="StatusID" Value='<%# Eval("StatusID") %>' />
                                            <asp:Label runat="server" ID="UserID" Text='<%# Eval("UserID") %>'></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td>&nbsp; </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="LabelSalutation" Text='<%# String.Concat(Resources.Resource.lblAddrSalutation, ":") %>' Font-Bold="true"></asp:Label>
                                        </td>
                                        <td>
                                            <telerik:RadComboBox runat="server" ID="Salutation" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                 DataSourceID="SqlDataSource_Salutations" DataValueField="Salutation" DataTextField="Salutation" Width="300" 
                                                                 AppendDataBoundItems="true" Filter="Contains" AllowCustomText="false"
                                                                 SelectedValue='<%# Bind("Salutation") %>' DropDownAutoWidth="Enabled">
                                            </telerik:RadComboBox>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="Salutation" ForeColor="Red" ValidationGroup="User" 
                                                                        ErrorMessage='<%# String.Concat(Resources.Resource.lblAddrSalutation, " ", Resources.Resource.lblRequired) %>' Text=" *">
                                            </asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="LabelLastName" Text='<%# String.Concat(Resources.Resource.lblAddrLastName, ":") %>' Font-Bold="true"></asp:Label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <telerik:RadTextBox runat="server" ID="LastName" Text='<%# Bind("LastName") %>' Width="300px"></telerik:RadTextBox>&nbsp;
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="LastName" ForeColor="Red" ValidationGroup="User" 
                                                                        ErrorMessage='<%# String.Concat(Resources.Resource.lblAddrLastName, " ", Resources.Resource.lblRequired) %>' Text="*">
                                            </asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="LabelFirstName" Text='<%# String.Concat(Resources.Resource.lblAddrFirstName, ":") %>' Font-Bold="true"></asp:Label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <telerik:RadTextBox runat="server" ID="FirstName" Text='<%# Bind("FirstName") %>' Width="300px"></telerik:RadTextBox>&nbsp;
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="FirstName" ForeColor="Red" ValidationGroup="User" 
                                                                        ErrorMessage='<%# String.Concat(Resources.Resource.lblAddrFirstName, " ", Resources.Resource.lblRequired) %>' Text="*">
                                            </asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="LabelCompanyID" Text='<%# String.Concat(Resources.Resource.lblCompany, ":") %>'></asp:Label>
                                        </td>
                                        <td>
                                            <telerik:RadComboBox runat="server" ID="CompanyID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                 DataSourceID="SqlDataSource_Companies" DataValueField="CompanyID" DataTextField="CompanyName" Width="300" 
                                                                 AppendDataBoundItems="true" Filter="Contains" OnSelectedIndexChanged="CompanyID_SelectedIndexChanged" 
                                                                 SelectedValue='<%# Bind("CompanyID") %>' DropDownAutoWidth="Enabled" AutoPostBack="true"
                                                                 Enabled='<%# (Container is GridEditFormInsertItem) ? true : false %>'>
                                                <Items>
                                                    <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                                                </Items>
                                            </telerik:RadComboBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td>&nbsp; </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="LabelLoginName" Text='<%# String.Concat(Resources.Resource.lblUserName, ":") %>' Font-Bold="true"></asp:Label>
                                        </td>
                                        <td>
                                            <telerik:RadTextBox runat="server" ID="LoginName" Text='<%# Bind("LoginName") %>' Width="300px"></telerik:RadTextBox>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="LoginName" ErrorMessage="<%$ Resources:Resource, msgUserNameObligate %>" Text="*" 
                                                                        SetFocusOnError="true" ForeColor="Red" ValidationGroup="User">
                                            </asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="LabelPassword" Text='<%# String.Concat(Resources.Resource.lblPassword, ":") %>' 
                                                       Visible='<%# (Container is GridEditFormInsertItem) ? true : false %>' Font-Bold="true"></asp:Label>
                                        </td>
                                        <td>
                                            <telerik:RadTextBox runat="server" ID="Password" Text='<%# Bind("Password") %>' TextMode="Password" AutoCompleteType="Disabled" Width="300px" 
                                                                Visible='<%# (Container is GridEditFormInsertItem) ? true : false %>'>
                                            </telerik:RadTextBox>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="Password" ErrorMessage="<%$ Resources:Resource, msgPasswordObligate %>" Text="*" 
                                                                        SetFocusOnError="true" ForeColor="Red" ValidationGroup="User" 
                                                                        Visible='<%# (Container is GridEditFormInsertItem) ? true : false %>'>
                                            </asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator runat="server" ControlToValidate="Password" Text="*" SetFocusOnError="true" 
                                                                            ErrorMessage='<%# string.Format(Resources.Resource.msgPwdLength, Session["MinPwdLength"].ToString()) %>' 
                                                                            ValidationExpression='.{6}.*' ForeColor="Red" ValidationGroup="User" 
                                                                            Visible='<%# (Container is GridEditFormInsertItem) ? true : false %>' />

                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="Label1" Text='<%# String.Concat(Resources.Resource.lblPassword, " (", Resources.Resource.lblPleaseRepeat, "):") %>' 
                                                       Visible='<%# (Container is GridEditFormInsertItem) ? true : false %>' Font-Bold="true"></asp:Label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <asp:TextBox ID="Password1" runat="server" Width="300px" TextMode="Password" AutoCompleteType="Disabled" 
                                                         Visible='<%# (Container is GridEditFormInsertItem) ? true : false %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="Password1" ErrorMessage="<%$ Resources:Resource, msgPasswordObligate %>" Text="*" 
                                                                        SetFocusOnError="true" ForeColor="Red" ValidationGroup="User"
                                                                        Visible='<%# (Container is GridEditFormInsertItem) ? true : false %>'>
                                            </asp:RequiredFieldValidator>
                                            <asp:CompareValidator runat="server" ControlToValidate="Password1" ControlToCompare="Password" Operator="Equal" ForeColor="Red" Text="*"
                                                                  ErrorMessage="<%$ Resources:Resource, msgPwdNotEqual %>" SetFocusOnError="true" ></asp:CompareValidator>
                                            <asp:RegularExpressionValidator runat="server" ControlToValidate="Password1" Text="*" SetFocusOnError="true" 
                                                                            ErrorMessage='<%# string.Format(Resources.Resource.msgPwdLength, Session["MinPwdLength"].ToString()) %>' 
                                                                            ValidationExpression='.{6}.*' ForeColor="Red" ValidationGroup="User" 
                                                                            Visible='<%# (Container is GridEditFormInsertItem) ? true : false %>' />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td>&nbsp; </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="LabelLanguageID" Text='<%# String.Concat(Resources.Resource.lblLanguage, ":") %>' Font-Bold="true"></asp:Label>
                                        </td>
                                        <td>
                                            <telerik:RadComboBox runat="server" ID="LanguageID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" DataSourceID="SqlDataSource_Languages"
                                                                 DataValueField="LanguageID" DataTextField="LanguageName" Width="300" Filter="Contains" SelectedValue='<%# Bind("LanguageID") %>'
                                                                 AppendDataBoundItems="true" DropDownAutoWidth="Enabled">
                                                <ItemTemplate>
                                                    <table cellpadding="5px" style="text-align: left;">
                                                        <tr>
                                                            <td style="text-align: left;">
                                                                <asp:Label ID="ItemName" Text='<%# Eval("LanguageID") %>' runat="server">
                                                                </asp:Label>
                                                            </td>
                                                            <td style="text-align: left;">
                                                                <asp:Label ID="ItemDescr" Text='<%# Eval("LanguageName") %>' runat="server">
                                                                </asp:Label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </ItemTemplate>
                                                <Items>
                                                    <telerik:RadComboBoxItem Text="<%$ Resources:Resource, selNoSelection %>" Value="0"/>
                                                </Items>
                                            </telerik:RadComboBox>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="LanguageID" ErrorMessage="<%$ Resources:Resource, msgLanguageObligate %>" Text="*" 
                                                                        SetFocusOnError="true" ForeColor="Red" ValidationGroup="User">
                                            </asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <%--                                            <tr>
                                    <td>
                                    <asp:Label runat="server" ID="LabelSkinName" Text='<%# String.Concat(Resources.Resource.lblSkin, ":") %>'></asp:Label>
                                    </td>
                                    <td>
                                    <telerik:RadComboBox runat="server" ID="SkinName" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                    Width="300" 
                                    AppendDataBoundItems="true" Filter="Contains" 
                                    SelectedValue='<%# Bind("SkinName") %>' DropDownAutoWidth="Enabled">
                                    <Items>
                                    <telerik:RadComboBoxItem runat="server" Text="Default" Value="Default" />
                                    <telerik:RadComboBoxItem runat="server" Text="Metro" Value="Metro" />
                                    <telerik:RadComboBoxItem runat="server" Text="Office2007" Value="Office2007" />
                                    <telerik:RadComboBoxItem runat="server" Text="Office2010Blue" Value="Office2010Blue" />
                                    <telerik:RadComboBoxItem runat="server" Text="Office2010Silver" Value="Office2010Silver" Selected="true" />
                                    <telerik:RadComboBoxItem runat="server" Text="Outlook" Value="Outlook" />
                                    <telerik:RadComboBoxItem runat="server" Text="Silk" Value="Silk" />
                                    <telerik:RadComboBoxItem runat="server" Text="Simple" Value="Simple" />
                                    <telerik:RadComboBoxItem runat="server" Text="Sunset" Value="Sunset" />
                                    <telerik:RadComboBoxItem runat="server" Text="Telerik" Value="Telerik" />
                                    <telerik:RadComboBoxItem runat="server" Text="Vista" Value="Vista" />
                                    <telerik:RadComboBoxItem runat="server" Text="Web20" Value="Web20" />
                                    <telerik:RadComboBoxItem runat="server" Text="WebBlue" Value="WebBlue" />
                                    <telerik:RadComboBoxItem runat="server" Text="Windows7" Value="Windows7" />
                                    </Items>
                                    </telerik:RadComboBox>
                                    </td>
                                    </tr>--%>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="LabelPhone" Text='<%# String.Concat(Resources.Resource.lblAddrPhone, ":") %>' Font-Bold="true"></asp:Label>
                                        </td>
                                        <td>
                                            <telerik:RadTextBox runat="server" ID="Phone" Text='<%# Bind("Phone") %>' Width="300px"></telerik:RadTextBox>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="Phone" ErrorMessage="<%$ Resources:Resource, msgPhoneObligate %>" Text="*" 
                                                                        SetFocusOnError="true" ForeColor="Red" ValidationGroup="User">
                                            </asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="LabelEmail" Text='<%# String.Concat(Resources.Resource.lblAddrEmail, ":") %>' Font-Bold="true"></asp:Label>
                                        </td>
                                        <td>
                                            <telerik:RadTextBox runat="server" ID="Email" Text='<%# Bind("Email") %>' Width="300px"></telerik:RadTextBox>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="Email" ErrorMessage="<%$ Resources:Resource, msgEmailObligate %>" Text="*" 
                                                                        SetFocusOnError="true" ForeColor="Red" ValidationGroup="User">
                                            </asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="LabelUseEmail" Text='<%# String.Concat(Resources.Resource.lblEmailOnProcessEvent, ":") %>' Width="150px" ></asp:Label>
                                        </td>
                                        <td>
                                            <asp:CheckBox runat="server" ID="UseEmail" Checked='<%# Bind("UseEmail") %>'></asp:CheckBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td>&nbsp; </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblReleaseFrom, ":") %>'></asp:Label>
                                        </td>
                                        <td>
                                            <telerik:RadTextBox runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' ID="ReleaseFrom" Text='<%# Bind("ReleaseFrom")%>' Enabled="false"></telerik:RadTextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblReleaseOn, ":") %>'></asp:Label>
                                        </td>
                                        <td>
                                            <telerik:RadTextBox runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' ID="ReleaseOn" Text='<%# Bind("ReleaseOn")%>' Enabled="false"></telerik:RadTextBox>

                                            <telerik:RadButton ID="ReleaseIt" runat="server" Text="<%$ Resources:Resource, lblActionRelease %>" CommandName="ReleaseIt" CausesValidation="false"
                                                               CommandArgument='<%# Eval("UserID") %>' Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></telerik:RadButton>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblLockedFrom, ":") %>'></asp:Label>
                                        </td>
                                        <td>
                                            <telerik:RadTextBox runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' ID="LockedFrom" Text='<%# Bind("LockedFrom")%>' Enabled="false"></telerik:RadTextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblLockedOn, ":") %>'></asp:Label>
                                        </td>
                                        <td>
                                            <telerik:RadTextBox runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' ID="LockedOn" Text='<%# Bind("LockedOn")%>' Enabled="false"></telerik:RadTextBox>

                                            <telerik:RadButton ID="LockIt" runat="server" Text="<%$ Resources:Resource, lblActionLock %>" CommandName="LockIt" CausesValidation="false" 
                                                               CommandArgument='<%# Eval("UserID") %>' Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>'></telerik:RadButton>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblCreatedFrom, ":") %>'></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblCreatedOn, ":") %>'></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("CreatedOn") %>'></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblEditFrom, ":") %>'></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("EditFrom")%>'></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# String.Concat(Resources.Resource.lblEditOn, ":") %>'></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label runat="server" Visible='<%# (Container is GridEditFormInsertItem) ? false : true%>' Text='<%# Eval("EditOn")%>'></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="padding-right: 12px;">
                                            <asp:ValidationSummary ID="ValidationSummary2" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' 
                                                                   ShowMessageBox="false" ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true" ValidationGroup="User" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td>&nbsp; </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="vertical-align: top;">
                                <table id="Table3" cellspacing="2" cellpadding="2" border="0">
                                    <tr>
                                        <td>

                                            <asp:Label ID="LabelRadGridBP" Text='<%# String.Concat(Resources.Resource.lblReleaseForBP, ":") %>' runat="server"></asp:Label>
                                            <br />
                                            <telerik:RadGrid runat="server" ID="RadGridBP"
                                                             OnNeedDataSource="RadGridBP_NeedDataSource" OnInsertCommand="RadGridBP_InsertCommand" OnUpdateCommand="RadGridBP_UpdateCommand"
                                                             OnItemDataBound="RadGridBP_ItemDataBound" OnItemCommand="RadGridBP_ItemCommand" OnItemCreated="RadGridBP_ItemCreated"
                                                             OnDeleteCommand="RadGridBP_DeleteCommand">

                                                <ValidationSettings ValidationGroup="BpRelease" EnableValidation="false" />

                                                <ClientSettings>
                                                    <Selecting AllowRowSelect="True"></Selecting>
                                                </ClientSettings>

                                                <MasterTableView PageSize="5" AllowAutomaticDeletes="true" AllowAutomaticInserts="false" 
                                                                 CommandItemDisplay="Top" DataKeyNames="SystemID,UserID,BpID" AutoGenerateColumns="False" AllowPaging="True" 
                                                                 AllowAutomaticUpdates="false" EditMode="EditForms">

                                                    <EditFormSettings EditFormType="AutoGenerated">
                                                        <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                                                        <EditColumn ButtonType="ImageButton" UniqueName="EditColumn2" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                                                                    EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                                                        <FormTableStyle CellPadding="3" CellSpacing="3" />
                                                    </EditFormSettings>

                                                    <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" 
                                                                         RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                                                    <Columns>

                                                        <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                                                                       UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                                                            <ItemStyle BackColor="Control" Width="30px" />
                                                            <HeaderStyle Width="30px" />
                                                        </telerik:GridEditCommandColumn>

                                                        <telerik:GridTemplateColumn DataField="BpID" HeaderText="<%$ Resources:Resource, lblBuildingProject %>">
                                                            <InsertItemTemplate>
                                                                <telerik:RadComboBox runat="server" ID="BpID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                                     DataValueField="BpID" DataTextField="NameVisible" Width="300" 
                                                                                     Filter="Contains" OnSelectedIndexChanged="BpID_SelectedIndexChanged" AutoPostBack="true" 
                                                                                     DropDownAutoWidth="Enabled">
                                                                </telerik:RadComboBox>
                                                            </InsertItemTemplate>
                                                            <EditItemTemplate>
                                                                <asp:HiddenField runat="server" ID="BpID" Value='<%# Eval("BpID") %>' />
                                                                <asp:Label runat="server" ID ="NameBP" Text='<%# Eval("NameBP") %>'></asp:Label>
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <asp:HiddenField runat="server" ID="BpID" Value='<%# Eval("BpID") %>' />
                                                                <asp:Label runat="server" ID ="NameBP" Text='<%# Eval("NameBP") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </telerik:GridTemplateColumn>

                                                        <telerik:GridTemplateColumn DataField="RoleID" HeaderText="<%$ Resources:Resource, lblRole %>">
                                                            <EditItemTemplate>
                                                                <asp:HiddenField runat="server" ID="RoleID1" Value='<%# Eval("RoleID") %>' />
                                                                <telerik:RadComboBox runat="server" ID="RoleID" EmptyMessage="<%$ Resources:Resource, msgPleaseTypeHere %>" 
                                                                                     DataValueField="RoleID" DataTextField="NameVisible" Width="300" 
                                                                                     Filter="Contains" 
                                                                                     DropDownAutoWidth="Enabled">
                                                                </telerik:RadComboBox>
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <asp:Label runat="server" ID ="NameRole" Text='<%# Eval("NameRole") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </telerik:GridTemplateColumn>

                                                        <telerik:GridButtonColumn UniqueName="deleteColumn1" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                                                                  ConfirmDialogType="RadWindow"
                                                                                  ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                                                            <ItemStyle BackColor="Control" />
                                                        </telerik:GridButtonColumn>

                                                    </Columns>
                                                </MasterTableView>
                                            </telerik:RadGrid>

                                            <asp:SqlDataSource ID="SqlDataSource_UserBP" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                                               OldValuesParameterFormatString="original_{0}"
                                                               SelectCommand="SELECT Master_BuildingProjects.NameVisible AS NameBp, Master_Roles.NameVisible AS NameRole, Master_UserBuildingProjects.SystemID, Master_UserBuildingProjects.UserID, Master_UserBuildingProjects.BpID, Master_UserBuildingProjects.RoleID FROM Master_UserBuildingProjects INNER JOIN Master_BuildingProjects ON Master_UserBuildingProjects.SystemID = Master_BuildingProjects.SystemID AND Master_UserBuildingProjects.BpID = Master_BuildingProjects.BpID INNER JOIN Master_Roles ON Master_UserBuildingProjects.SystemID = Master_Roles.SystemID AND Master_UserBuildingProjects.BpID = Master_Roles.BpID AND Master_UserBuildingProjects.RoleID = Master_Roles.RoleID WHERE (Master_UserBuildingProjects.SystemID = @SystemID) AND (Master_UserBuildingProjects.UserID = @UserID)"
                                                               UpdateCommand="UPDATE Master_UserBuildingProjects SET RoleID = @RoleID, EditFrom = @UserName, EditOn = SYSDATETIME() WHERE SystemID = @original_SystemID AND UserID = @original_UserID AND BpID = @original_BpID"
                                                               DeleteCommand="DELETE FROM Master_UserBuildingProjects WHERE SystemID = @original_SystemID AND UserID = @original_UserID AND BpID = @original_BpID">
                                                <DeleteParameters>
                                                    <asp:Parameter Name="original_SystemID"></asp:Parameter>
                                                    <asp:Parameter Name="original_UserID"></asp:Parameter>
                                                    <asp:Parameter Name="original_BpID"></asp:Parameter>
                                                </DeleteParameters>
                                                <SelectParameters>
                                                    <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                                    <asp:ControlParameter ControlID="UserID" PropertyName="Text" DefaultValue="0" Name="UserID"></asp:ControlParameter>
                                                </SelectParameters>
                                                <UpdateParameters>
                                                    <asp:Parameter Name="RoleID"></asp:Parameter>
                                                    <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
                                                    <asp:Parameter Name="original_SystemID"></asp:Parameter>
                                                    <asp:Parameter Name="original_UserID"></asp:Parameter>
                                                    <asp:Parameter Name="original_BpID"></asp:Parameter>
                                                </UpdateParameters>
                                            </asp:SqlDataSource>

                                            <asp:SqlDataSource ID="SqlDataSource_BuildingProjects" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                                               SelectCommand="SELECT DISTINCT bp.SystemID, bp.BpID, bp.NameVisible, bp.DescriptionShort, bp.TypeID, bp.BasedOn, bp.IsVisible, bp.CountryID, bp.BuilderName, bp.PresentType, bp.MWCheck, bp.MWHours, bp.MWDeadline, bp.Address, bp.CreatedFrom, bp.CreatedOn, bp.EditFrom, bp.EditOn FROM Master_BuildingProjects AS bp INNER JOIN Master_UserBuildingProjects AS ubp1 ON bp.SystemID = ubp1.SystemID AND bp.BpID = ubp1.BpID INNER JOIN Master_Companies AS mco ON bp.SystemID = mco.SystemID AND bp.BpID = mco.BpID WHERE (bp.SystemID = @SystemID) AND (ubp1.UserID = @EditingUserID) AND (NOT EXISTS (SELECT 1 AS Expr1 FROM Master_UserBuildingProjects AS ubp2 WHERE (SystemID = bp.SystemID) AND (BpID = bp.BpID) AND (UserID = @UserID))) AND (mco.CompanyCentralID = (CASE WHEN @CompanyID = 0 OR @CompanyID IS NULL THEN mco.CompanyCentralID ELSE @CompanyID END)) ORDER BY bp.NameVisible">
                                                <SelectParameters>
                                                    <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
                                                    <asp:SessionParameter DefaultValue="0" Name="EditingUserID" SessionField="UserID" Type="Int32" />
                                                    <asp:ControlParameter ControlID="UserID" PropertyName="Text" DefaultValue="0" Name="UserID"></asp:ControlParameter>
                                                    <asp:ControlParameter ControlID="CompanyID" PropertyName="SelectedValue" DefaultValue="0" Name="CompanyID"></asp:ControlParameter>
                                                </SelectParameters>
                                            </asp:SqlDataSource>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp; </td>
                                        <td>&nbsp; </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" colspan="2">
                                <telerik:RadButton ID="btnUpdate" Text='<%# (Container is GridEditFormInsertItem) ? Resources.Resource.lblActionInsert : Resources.Resource.lblActionUpdate%>'
                                                   runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update"%>' Icon-PrimaryIconCssClass="rbOk"
                                                   ValidationGroup="User">
                                </telerik:RadButton>
                                <telerik:RadButton ID="btnCancel" Text='<%# Resources.Resource.lblActionCancel %>' runat="server" CausesValidation="False"
                                                   CommandName="Cancel" Icon-PrimaryIconCssClass="rbCancel">
                                </telerik:RadButton>
                                <telerik:RadButton ID="btnChangePwd" Text='<%# Resources.Resource.lblChangePwd %>' runat="server" CausesValidation="False" AutoPostBack="false" 
                                                   Visible='<%# (Container is GridEditFormInsertItem) ? false : true %>'>
                                </telerik:RadButton>
                                <telerik:RadButton ID="ResetPwd" Text='<%# Resources.Resource.lblResetPassword %>' runat="server" CausesValidation="False" AutoPostBack="true" 
                                                   Visible="false" OnClick="ResetPwd_Click">
                                </telerik:RadButton>
                            </td>
                        </tr>
                    </table>
                </FormTemplate>
            </EditFormSettings>

            <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="False" ShowExportToExcelButton="True" ShowExportToPdfButton="False"
                                 AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

            <Columns>
                <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                               UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                    <ItemStyle BackColor="Control" Width="30px" />
                    <HeaderStyle Width="30px" />
                </telerik:GridEditCommandColumn>

                <telerik:GridTemplateColumn DataField="FirstChar" HeaderText="<%$ Resources:Resource, lblInitial %>" SortExpression="FirstChar" UniqueName="FirstChar"
                                            GroupByExpression="FirstChar FirstChar GROUP BY FirstChar" ForceExtractValue="Always" ItemStyle-Width="50px" HeaderStyle-Width="50px" 
                                            AllowFiltering="false" Display="false">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="FirstChar" Text='<%# Eval("FirstChar") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="StatusID" HeaderText="<%$ Resources:Resource, lblStatus %>" SortExpression="StatusID" UniqueName="StatusID" ItemStyle-HorizontalAlign="Center"
                                            GroupByExpression="StatusID StatusID GROUP BY StatusID" Visible="true" ForceExtractValue="Always" ItemStyle-Width="70px" HeaderStyle-Width="70px"
                                            HeaderStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <asp:HiddenField runat="server" ID="StatusID" Value='<%# Eval("StatusID") %>' />
                        <asp:HiddenField runat="server" ID="CompanyStatusID" Value='<%# Eval("CompanyStatusID") %>' />
                        <asp:ImageButton runat="server" ID="ReleaseButton" />
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="StatusID" DataValueField="StatusID" Height="200px" AppendDataBoundItems="true" 
                                             SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("StatusID").CurrentFilterValue %>'
                                             runat="server" OnClientSelectedIndexChanged="StatusIDIndexChanged" DropDownAutoWidth="Enabled" Width="50px">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" Selected="true" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statCreated %>" Value="0" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statLocked %>" Value="-10" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statCreatedNotConfirmed %>" Value="5" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statWaitRelease %>" Value="10" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, statReleased %>" Value="20" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock10" runat="server">
                            <script type="text/javascript">
                                function StatusIDIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    tableView.filter("StatusID", args.get_item().get_value(), "EqualTo");
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="IsOnline" HeaderText="<%$ Resources:Resource, lblOnline %>" SortExpression="IsOnline" UniqueName="IsOnline"
                                            GroupByExpression="IsOnline IsOnline GROUP BY IsOnline" Visible="true" ForceExtractValue="Always" CurrentFilterFunction="EqualTo" 
                                            ItemStyle-Width="70px" HeaderStyle-Width="70px" AutoPostBackOnFilter="true" ItemStyle-HorizontalAlign="Center" DataType="System.Boolean"
                                            HeaderStyle-HorizontalAlign="Center">
                    <ItemTemplate>
                        <div style="margin-left: -2px; margin-top: 2px;">
                            <asp:Image ImageUrl='<%# (Convert.ToInt32(Eval("IsOnline")) == 1) ? "/InSiteApp/Resources/Icons/Online_24.png" : "/InSiteApp/Resources/Icons/Offline_24.png"  %>' 
                                       Visible='<%# (Convert.ToInt32(Eval("IsOnline")) == 1) ? true : false %>'
                                       runat="server" Width="22px" Height="22px" ToolTip='<%# ((Convert.ToInt32(Eval("IsOnline")) == 1) ? Resources.Resource.lblOnline : Resources.Resource.lblOffline) %>' />
                        </div>
                    </ItemTemplate>
                    <FilterTemplate>
                        <telerik:RadComboBox ID="PresentFilter" runat="server" OnClientSelectedIndexChanged="IsOnlineFilterSelectedIndexChanged"
                                             SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("IsOnline").CurrentFilterValue %>'
                                             AppendDataBoundItems="true" DropDownAutoWidth="Enabled" Width="50px">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" Value="" Selected="true" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblOnline %>" Value="1" />
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblOffline %>" Value="0" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock22" runat="server">
                            <script type="text/javascript">
                                function IsOnlineFilterSelectedIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    var filterVal = args.get_item().get_value();
                                    if (filterVal === "") {
                                        tableView.filter("IsOnline", filterVal, "NoFilter");
                                    } else if (filterVal === "1" || filterVal === "0") {
                                        tableView.filter("IsOnline", filterVal, "EqualTo");
                                    }
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="UserID" DataType="System.Int32" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter UserID column" 
                                            HeaderText="<%$ Resources:Resource, lblUserID %>" SortExpression="UserID" UniqueName="UserID" Visible="False" ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:Label ID="UserID" runat="server" Text='<%# Eval("UserID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Salutation" HeaderText="<%$ Resources:Resource, lblAddrSalutation %>" SortExpression="Salutation" UniqueName="Salutation" 
                                            GroupByExpression="Salutation Salutation GROUP BY Salutation" FilterControlWidth="80px" ForceExtractValue="Always" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" Visible="false">
                    <ItemTemplate>
                        <asp:Label ID="Salutation" runat="server" Text='<%# Eval("Salutation") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="LastName" HeaderText="<%$ Resources:Resource, lblLastName %>" SortExpression="LastName" UniqueName="LastName" 
                                            GroupByExpression="LastName LastName GROUP BY LastName" FilterControlWidth="80px" ForceExtractValue="Always" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label ID="LastName" runat="server" Text='<%# Eval("LastName") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="FirstName" HeaderText="<%$ Resources:Resource, lblFirstName %>" SortExpression="FirstName" UniqueName="FirstName" 
                                            GroupByExpression="FirstName FirstName GROUP BY FirstName" FilterControlWidth="80px" ForceExtractValue="Always" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label ID="FirstName" runat="server" Text='<%# Eval("FirstName") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Company" HeaderText="<%$ Resources:Resource, lblCompany %>" SortExpression="Company" UniqueName="Company" 
                                            GroupByExpression="Company Company GROUP BY Company" InsertVisiblityMode="AlwaysVisible" FilterControlWidth="80px" 
                                            ForceExtractValue="Always" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label ID="Company" runat="server" Text='<%# Eval("Company") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="CompanyID" HeaderText="<%$ Resources:Resource, lblCompany %>" SortExpression="CompanyID" UniqueName="CompanyID" 
                                            GroupByExpression="CompanyID CompanyID GROUP BY CompanyID" InsertVisiblityMode="AlwaysVisible" FilterControlWidth="80px" 
                                            ForceExtractValue="Always" CurrentFilterFunction="Contains" AutoPostBackOnFilter="true" Visible="false" DefaultInsertValue="0">
                    <ItemTemplate>
                        <asp:Label ID="CompanyID" runat="server" Text='<%# Eval("CompanyID") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="LoginName" HeaderText="<%$ Resources:Resource, lblUserName %>" SortExpression="LoginName" UniqueName="LoginName" 
                                            GroupByExpression="LoginName LoginName GROUP BY LoginName" FilterControlWidth="80px" ForceExtractValue="Always" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label ID="LoginName" runat="server" Text='<%# Eval("LoginName") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Password" FilterControlAltText="Filter Password column" HeaderText="<%$ Resources:Resource, lblPassword %>" SortExpression="Password" 
                                            UniqueName="Password" Visible="False" InsertVisiblityMode="AlwaysVisible" ReadOnly="True" ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:Label ID="Password" runat="server" Text='<%# Eval("Password") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridDropDownColumn DataField="LanguageID" DataSourceID="SqlDataSource_Languages" HeaderText="<%$ Resources:Resource, lblLanguage %>" ListTextField="LanguageName"
                                            ListValueField="LanguageID" UniqueName="LanguageID" DropDownControlType="RadComboBox" 
                                            ItemStyle-Width="300px" FilterControlWidth="80px" ForceExtractValue="Always">
                    <FilterTemplate>
                        <telerik:RadComboBox ID="RadComboBoxLanguageID" DataSourceID="SqlDataSource_Languages" DataTextField="LanguageName"
                                             DataValueField="LanguageID" Height="200px" AppendDataBoundItems="true" SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("LanguageID").CurrentFilterValue %>'
                                             runat="server" OnClientSelectedIndexChanged="LanguageIDIndexChanged" Width="110px">
                            <Items>
                                <telerik:RadComboBoxItem Text="<%$ Resources:Resource, lblAll %>" />
                            </Items>
                        </telerik:RadComboBox>
                        <telerik:RadScriptBlock ID="RadScriptBlock3" runat="server">
                            <script type="text/javascript">
                                function LanguageIDIndexChanged(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    tableView.filter("LanguageID", args.get_item().get_value(), "EqualTo");
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridDropDownColumn>

                <telerik:GridTemplateColumn DataField="SkinName" FilterControlAltText="Filter SkinName column" HeaderText="<%$ Resources:Resource, lblSkin %>" DefaultInsertValue="Office2010Silver"
                                            SortExpression="SkinName" UniqueName="SkinName" GroupByExpression="SkinName SkinName GROUP BY SkinName" Visible="false" InsertVisiblityMode="AlwaysVisible"
                                            ItemStyle-Width="300px" ForceExtractValue="Always">
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Email" HeaderText="<%$ Resources:Resource, lblEmail %>" SortExpression="Email" UniqueName="Email" 
                                            GroupByExpression="Email Email GROUP BY Email" FilterControlWidth="80px" ForceExtractValue="Always" 
                                            CurrentFilterFunction="Contains" AutoPostBackOnFilter="true">
                    <ItemTemplate>
                        <asp:Label ID="Email" runat="server" Text='<%# Eval("Email") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridCheckBoxColumn DataField="IsVisible" DataType="System.Boolean" FilterControlAltText="Filter IsVisible column" HeaderText="<%$ Resources:Resource, lblVisible %>" 
                                            SortExpression="IsVisible" UniqueName="IsVisible" Visible="False" DefaultInsertValue="True">
                </telerik:GridCheckBoxColumn>

                <telerik:GridCheckBoxColumn DataField="UseEmail" DataType="System.Boolean" FilterControlAltText="Filter UseEmail column" 
                                            SortExpression="UseEmail" UniqueName="UseEmail" Visible="False" DefaultInsertValue="False">
                </telerik:GridCheckBoxColumn>

                <telerik:GridTemplateColumn DataField="CreatedFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedFrom column" HeaderText="<%$ Resources:Resource, lblCreatedFrom %>" 
                                            SortExpression="CreatedFrom" UniqueName="CreatedFrom" Visible="False" ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:Label ID="CreatedFromLabel" runat="server" Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="CreatedOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedOn column" HeaderText="<%$ Resources:Resource, lblCreatedOn %>" 
                                            SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="False" ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:Label ID="CreatedOnLabel" runat="server" Text='<%# Eval("CreatedOn") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="EditFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditFrom column" HeaderText="<%$ Resources:Resource, lblEditFrom %>" 
                                            SortExpression="EditFrom" UniqueName="EditFrom" Visible="False" ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:Label ID="EditFromLabel" runat="server" Text='<%# Eval("EditFrom") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridBoundColumn DataField="EditOn" HeaderText="<%$ Resources:Resource, lblEditOn %>" SortExpression="EditOn" UniqueName="EditOn" 
                                         HeaderStyle-Width="170px" ItemStyle-Width="170px" DataType="System.DateTime" DataFormatString="{0:G}" HeaderStyle-HorizontalAlign="Right" 
                                         ItemStyle-HorizontalAlign="Right">
                    <FilterTemplate>
                        <table>
                            <tr>
                                <td align="right">
                                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblFrom %>"></asp:Label>
                                </td>
                                <td>
                                    <telerik:RadDatePicker ID="FromDatePicker" runat="server" Width="100px" ClientEvents-OnDateSelected="FromDateSelected" MaxDate="<%# DateTime.Now %>" 
                                                           EnableShadows="true" ShowPopupOnFocus="true" DbSelectedDate='<%# GetFilterDate(((GridItem)Container).OwnerTableView.GetColumn("EditOn").CurrentFilterValue, 0) %>'>
                                    </telerik:RadDatePicker>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    <asp:Label runat="server" Text="<%$ Resources:Resource, lblUntil %>"></asp:Label>
                                </td>
                                <td>
                                    <telerik:RadDatePicker ID="ToDatePicker" runat="server" Width="100px" ClientEvents-OnDateSelected="ToDateSelected" MaxDate="<%# DateTime.Now %>" 
                                                           EnableShadows="true" ShowPopupOnFocus="true" DbSelectedDate='<%# GetFilterDate(((GridItem)Container).OwnerTableView.GetColumn("EditOn").CurrentFilterValue, 1) %>'>
                                    </telerik:RadDatePicker>
                                </td>
                                <td>
                                    <telerik:RadButton ID="BtnClear" runat="server" OnClientClicked="OnClientClicked" ToolTip="<%$ Resources:Resource, ttRemoveFilter %>"  
                                                       ButtonType="SkinnedButton" BorderStyle="None" BackColor="Transparent" Width="20px" Icon-PrimaryIconCssClass="rbRemove" >
                                    </telerik:RadButton>
                                </td>
                            </tr>
                        </table>
                        <telerik:RadScriptBlock ID="RadScriptBlock4" runat="server">
                            <script type="text/javascript">
                                function FromDateSelected(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    var ToPicker = $find('<%# ((GridItem)Container).FindControl("ToDatePicker").ClientID %>');

                                    var fromDate = FormatSelectedDate(sender);
                                    var toDate = FormatSelectedDate(ToPicker);

                                    if (fromDate !== '' && toDate !== '') {
                                        tableView.filter("EditOn", fromDate + ",00:00:00 " + toDate + ",23:59:59", "Between");
                                    }
                                }

                                function ToDateSelected(sender, args) {
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    var FromPicker = $find('<%# ((GridItem)Container).FindControl("FromDatePicker").ClientID %>');
                                
                                    var fromDate = FormatSelectedDate(FromPicker);
                                    var toDate = FormatSelectedDate(sender);
                                
                                    if (fromDate !== '' && toDate !== '') {
                                        tableView.filter("EditOn", fromDate + ",00:00:00 " + toDate + ",23:59:59", "Between");
                                    }
                                }

                                function FormatSelectedDate(picker) {
                                    var date = picker.get_selectedDate();
                                    var dateInput = picker.get_dateInput();
                                    var formattedDate = dateInput.get_dateFormatInfo().FormatDate(date, "MM/dd/yyyy");
                                    return formattedDate;
                                }

                                function OnClientClicked(sender, args) {
                                    var FromPicker = $find('<%# ((GridItem)Container).FindControl("FromDatePicker").ClientID %>');
                                    var ToPicker = $find('<%# ((GridItem)Container).FindControl("ToDatePicker").ClientID %>');
                                    FromPicker.clear();
                                    FromPicker.hidePopup();
                                    ToPicker.clear();
                                    ToPicker.hidePopup();
                                    var tableView = $find("<%# ((GridItem)Container).OwnerTableView.ClientID %>");
                                    tableView.filter("EditOn", "", "NoFilter");
                                }
                            </script>
                        </telerik:RadScriptBlock>
                    </FilterTemplate>
                </telerik:GridBoundColumn>

                <telerik:GridTemplateColumn DataField="ReleaseFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter ReleaseFrom column" 
                                            HeaderText="<%$ Resources:Resource, lblReleaseFrom %>" SortExpression="ReleaseFrom" UniqueName="ReleaseFrom" Visible="False" ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:Label ID="ReleaseFrom" runat="server" Text='<%# Eval("ReleaseFrom") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="ReleaseOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter ReleaseOn column" 
                                            HeaderText="<%$ Resources:Resource, lblReleaseOn %>" SortExpression="ReleaseOn" UniqueName="ReleaseOn" Visible="False" ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:Label ID="ReleaseOn" runat="server" Text='<%# Eval("ReleaseOn") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="LockedFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter LockedFrom column" 
                                            HeaderText="<%$ Resources:Resource, lblLockedFrom %>" SortExpression="LockedFrom" UniqueName="LockedFrom" Visible="False" ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:Label ID="LockedFrom" runat="server" Text='<%# Eval("LockedFrom") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="LockedOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter LockedOn column" 
                                            HeaderText="<%$ Resources:Resource, lblLockedOn %>" SortExpression="LockedOn" UniqueName="LockedOn" Visible="False" ForceExtractValue="Always">
                    <ItemTemplate>
                        <asp:Label ID="LockedOn" runat="server" Text='<%# Eval("LockedOn") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="Duplicates" HeaderText="<%$ Resources:Resource, lblDuplicates %>" SortExpression="Duplicates" UniqueName="Duplicates"
                                            GroupByExpression="Duplicates Duplicates GROUP BY Duplicates" ForceExtractValue="Always" AllowFiltering="false" Display="false">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="Duplicates" Text='<%# Eval("Duplicates") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridButtonColumn UniqueName="deleteColumn" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                          ConfirmDialogType="RadWindow"
                                          ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                    <ItemStyle BackColor="Control" />
                </telerik:GridButtonColumn>
            </Columns>

            <SortExpressions>
                <telerik:GridSortExpression FieldName="LastName" SortOrder="Ascending"></telerik:GridSortExpression>
                <telerik:GridSortExpression FieldName="FirstName" SortOrder="Ascending"></telerik:GridSortExpression>
            </SortExpressions>

            <NestedViewTemplate>
                <asp:Panel ID="NestedViewPanel" runat="server">
                    <div>
                        <fieldset style="padding: 10px; margin-left: 5px; margin-bottom: 5px">
                            <legend style="padding: 5px;">
                                <b><%= Resources.Resource.lblDetailsFor %> <%#Eval("FirstName") %> <%#Eval("LastName") %></b>
                            </legend>
                            <table>
                                <tr>
                                    <td>
                                        <table>
                                            <tr>
                                                <td><%= Resources.Resource.lblUserID %>: </td>
                                                <td>
                                                    <asp:Label ID="UserID" Text='<%#Eval("UserID") %>' runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblFirstName %>: </td>
                                                <td>
                                                    <asp:Label Text='<%#Eval("FirstName") %>' runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblLastName %>: </td>
                                                <td>
                                                    <asp:Label Text='<%#Eval("LastName") %>' runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblCompany %>: </td>
                                                <td>
                                                    <asp:Label Text='<%#Eval("Company") %>' runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblUserName %>: </td>
                                                <td>
                                                    <asp:Label Text='<%#Eval("LoginName") %>' runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <%--                                    <tr>
                                            <td><%= Resources.Resource.lblRole %>: </td>
                                            <td>
                                            <telerik:RadComboBox ID="RadComboBoxRoleID1" DataSourceID="SqlDataSource_Roles" DataTextField="NameVisible"
                                            DataValueField="RoleID" Height="200px" SelectedValue='<%# Eval("RoleID") %>' runat="server" Enabled="false">
                                            </telerik:RadComboBox>
                                            </td>
                                            </tr>--%>
                                            <tr>
                                                <td><%= Resources.Resource.lblLanguage %>: </td>
                                                <td>
                                                    <telerik:RadComboBox ID="RadComboBoxLanguageID" DataSourceID="SqlDataSource_Languages" DataTextField="LanguageName"
                                                                         DataValueField="LanguageID" Height="200px" SelectedValue='<%# Eval("LanguageID") %>' runat="server" Enabled="false">
                                                    </telerik:RadComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblSkin %>: </td>
                                                <td>
                                                    <asp:Label Text='<%#Eval("SkinName") %>' runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblEmail %>: </td>
                                                <td>
                                                    <asp:Label Text='<%#Eval("Email") %>' runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp; </td>
                                                <td>&nbsp; </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblCreatedFrom %>: </td>
                                                <td>
                                                    <asp:Label Text='<%#Eval("CreatedFrom") %>' runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblCreatedOn %>: </td>
                                                <td>
                                                    <asp:Label Text='<%#Eval("CreatedOn") %>' runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblEditFrom %>: </td>
                                                <td>
                                                    <asp:Label Text='<%#Eval("EditFrom") %>' runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%= Resources.Resource.lblEditOn %>: </td>
                                                <td>
                                                    <asp:Label Text='<%#Eval("EditOn") %>' runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td style="vertical-align: top;">
                                        <table id="Table3" cellspacing="2" cellpadding="2" border="0">
                                            <tr>
                                                <td>
                                                    <asp:Label ID="LabelRadGridBP" Text='<%# String.Concat(Resources.Resource.lblReleaseForBP, ":") %>' runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Panel runat="server" ID="PanelUserBP2">

                                                        <telerik:RadGrid runat="server" ID="RadGridBP2" DataSourceID="SqlDataSource_UserBP2">

                                                            <ClientSettings>
                                                                <Selecting AllowRowSelect="True"></Selecting>
                                                            </ClientSettings>

                                                            <MasterTableView DataSourceID="SqlDataSource_UserBP2" PageSize="5" CommandItemDisplay="None" 
                                                                             AutoGenerateColumns="False" AllowPaging="True">

                                                                <Columns>

                                                                    <telerik:GridTemplateColumn DataField="NameBP" HeaderText="<%$ Resources:Resource, lblBuildingProject %>">
                                                                        <ItemTemplate>
                                                                            <asp:Label runat="server" ID ="NameBP" Text='<%# Eval("NameBP") %>'></asp:Label>
                                                                        </ItemTemplate>
                                                                    </telerik:GridTemplateColumn>

                                                                    <telerik:GridTemplateColumn DataField="NameRole" HeaderText="<%$ Resources:Resource, lblRole %>">
                                                                        <ItemTemplate>
                                                                            <asp:Label runat="server" ID ="NameRole" Text='<%# Eval("NameRole") %>'></asp:Label>
                                                                        </ItemTemplate>
                                                                    </telerik:GridTemplateColumn>

                                                                </Columns>
                                                            </MasterTableView>
                                                        </telerik:RadGrid>

                                                        <asp:SqlDataSource ID="SqlDataSource_UserBP2" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                                                                           SelectCommand="SELECT Master_BuildingProjects.NameVisible AS NameBp, Master_Roles.NameVisible AS NameRole FROM Master_UserBuildingProjects INNER JOIN Master_BuildingProjects ON Master_UserBuildingProjects.SystemID = Master_BuildingProjects.SystemID AND Master_UserBuildingProjects.BpID = Master_BuildingProjects.BpID INNER JOIN Master_Roles ON Master_UserBuildingProjects.SystemID = Master_Roles.SystemID AND Master_UserBuildingProjects.BpID = Master_Roles.BpID AND Master_UserBuildingProjects.RoleID = Master_Roles.RoleID WHERE (Master_UserBuildingProjects.SystemID = @SystemID) AND (Master_UserBuildingProjects.UserID = @UserID)">
                                                            <SelectParameters>
                                                                <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID"></asp:SessionParameter>
                                                                <asp:ControlParameter ControlID="UserID" PropertyName="Text" DefaultValue="0" Name="UserID"></asp:ControlParameter>
                                                            </SelectParameters>
                                                        </asp:SqlDataSource>

                                                    </asp:Panel>

                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                    </div>
                </asp:Panel>
            </NestedViewTemplate>
        </MasterTableView>
    </telerik:RadGrid>

    <asp:SqlDataSource ID="SqlDataSource_Languages" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT LanguageID, LanguageName, FlagName FROM View_Languages ORDER BY LanguageName">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Companies" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT c.SystemID, c.CompanyID, c.NameVisible, c.NameAdditional, c.Description, c.AddressID, c.IsVisible, c.IsValid, c.TradeAssociation, c.BlnSOKA, c.CreatedFrom, c.CreatedOn, c.EditFrom, c.EditOn, a.Address1, a.Address2, a.Zip, a.City, a.State, a.CountryID, a.Phone, a.Email, a.WWW, c.NameVisible + (CASE WHEN c.NameAdditional IS NULL THEN '' ELSE ', ' + c.NameAdditional END) + (CASE WHEN a.City IS NULL THEN '' ELSE ', ' + a.City END) AS CompanyName FROM System_Companies AS c INNER JOIN System_Addresses AS a ON c.SystemID = a.SystemID AND c.AddressID = a.AddressID WHERE (c.SystemID = @SystemID) ORDER BY c.NameVisible">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_UserBuildingProjects" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT Master_UserBuildingProjects.BpID, Master_BuildingProjects.NameVisible FROM Master_UserBuildingProjects INNER JOIN Master_BuildingProjects ON Master_UserBuildingProjects.SystemID = Master_BuildingProjects.SystemID AND Master_UserBuildingProjects.BpID = Master_BuildingProjects.BpID WHERE (Master_UserBuildingProjects.SystemID = @SystemID) AND (Master_UserBuildingProjects.UserID = @UserID)">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="SystemID" SessionField="SystemID" Type="Int32" />
            <asp:SessionParameter SessionField="UserID" DefaultValue="0" Name="UserID"></asp:SessionParameter>
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSource_Salutations" runat="server" ConnectionString="<%$ ConnectionStrings:Insite_Dev_ConnectionString %>"
                       SelectCommand="SELECT * FROM System_Salutations ">
    </asp:SqlDataSource>
</asp:Content>
