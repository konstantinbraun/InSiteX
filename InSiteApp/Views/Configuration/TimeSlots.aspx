<%@ Page Title="<%$ Resources:Resource, lblTimeGroupsTimeSlots %>" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TimeSlots.aspx.cs" Inherits="InSite.App.Views.Configuration.TimeSlots" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="BodyContent" runat="server">

    <telerik:RadPersistenceManagerProxy ID="RadPersistenceManagerProxy1" runat="server" >
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
        </AjaxSettings>
    </telerik:RadAjaxManagerProxy>

    <%-- Time Slot Groups Grid --%>
    <telerik:RadGrid ID="RadGrid1" runat="server" DataSourceID="SqlDataSource_TimeSlotGroups" AllowPaging="True" AllowSorting="True" AllowFilteringByColumn="True" 
                     ShowGroupPanel="false" AllowAutomaticDeletes="true" AllowAutomaticUpdates="true" CssClass="MainGrid" EnableAjaxSkinRendering="true" AllowAutomaticInserts="false" 
                     EnableLinqExpressions="false" 
                     OnItemInserted="RadGrid1_ItemInserted" OnItemUpdated="RadGrid1_ItemUpdated" OnItemCommand="RadGrid1_ItemCommand" OnItemCreated="RadGrid1_ItemCreated" 
                     OnPreRender="RadGrid1_PreRender" OnItemDeleted="RadGrid1_ItemDeleted" OnInsertCommand="RadGrid1_InsertCommand" OnGroupsChanging="RadGrid1_GroupsChanging">

        <ClientSettings AllowColumnsReorder="True" AllowDragToGroup="True" EnableRowHoverStyle="True" EnablePostBackOnRowClick="false">
            <Resizing AllowColumnResize="true"></Resizing>
            <Selecting AllowRowSelect="True" />
            <ClientEvents OnRowClick="OnRowClick" OnGridCreated="OnGridCreated" OnKeyPress="GridKeyPress" />
        </ClientSettings>

        <ExportSettings ExportOnlyData="True" IgnorePaging="True">
            <Pdf PaperSize="A4">
            </Pdf>
            <Excel Format="ExcelML" />
        </ExportSettings>

        <%-- Time Slot Groups Master --%>
        <SortingSettings SortedBackColor="Transparent" />

        <MasterTableView Name="TimeSlotGroups" DataKeyNames="SystemID,BpID,TimeSlotGroupID" DataSourceID="SqlDataSource_TimeSlotGroups" CommandItemDisplay="Top" EditMode="PopUp" 
                         ShowHeader="true" HierarchyLoadMode="ServerOnDemand" Caption="<%$ Resources:Resource, lblTimeGroups %>" AutoGenerateColumns="false" CssClass="MasterClass" 
                         EnableHierarchyExpandAll="true">

            <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="False" ShowExportToExcelButton="True" ShowExportToPdfButton="False"
                                 AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

            <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

            <SortExpressions>
                <telerik:GridSortExpression FieldName="NameVisible" SortOrder="Ascending"></telerik:GridSortExpression>
            </SortExpressions>

            <EditFormSettings CaptionDataField="NameVisible" CaptionFormatString="{0}">
                <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                <EditColumn ButtonType="ImageButton" UniqueName="EditColumn1" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                            EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                <FormTableStyle CellPadding="3" CellSpacing="3" />
            </EditFormSettings>

            <%-- Time Slot Groups Details --%>
            <DetailTables>

                <%-- Time Slots GridTableView --%>
                <telerik:GridTableView Name="TimeSlots" DataSourceID="SqlDataSource_TimeSlots" HierarchyLoadMode="ServerOnDemand" EnableHierarchyExpandAll="true"
                                       CssClass="MasterClass" AutoGenerateColumns="False" ShowHeader="true" Caption="<%$ Resources:Resource, lblTimeSlots %>"
                                       DataKeyNames="SystemID,BpID,TimeSlotGroupID,TimeSlotID" EditMode="PopUp" AllowAutomaticInserts="false"
                                       CommandItemDisplay="Top" AllowFilteringByColumn="false" AllowPaging="false">

                    <CommandItemSettings ShowRefreshButton="true" ShowAddNewRecordButton="true" ShowExportToCsvButton="False" ShowExportToExcelButton="True" ShowExportToPdfButton="False"
                                         AddNewRecordText="<%$ Resources:Resource, lblActionNew %>" RefreshText="<%$ Resources:Resource, lblActionRefresh %>" />

                    <PagerStyle Mode="NextPrevAndNumeric" AlwaysVisible="true" />

                    <SortExpressions>
                        <telerik:GridSortExpression FieldName="NameVisible" SortOrder="Ascending"></telerik:GridSortExpression>
                    </SortExpressions>

                    <ParentTableRelation>
                        <telerik:GridRelationFields DetailKeyField="TimeSlotGroupID" MasterKeyField="TimeSlotGroupID"></telerik:GridRelationFields>
                    </ParentTableRelation>

                    <EditFormSettings EditFormType="AutoGenerated" CaptionDataField="NameVisible" CaptionFormatString="{0}">
                        <PopUpSettings Modal="true" ShowCaptionInEditForm="false" ScrollBars="Auto" />
                        <EditColumn ButtonType="ImageButton" UniqueName="EditColumn2" CancelText="<%$ Resources:Resource, lblActionCancel %>"
                                    EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" />
                        <FormTableStyle CellPadding="3" CellSpacing="3" />
                    </EditFormSettings>

                    <Columns>
                        <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn" CancelText="<%$ Resources:Resource, lblActionCancel %>" 
                                                       EditText="<%$ Resources:Resource, lblActionEdit %>" UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" 
                                                       Resizable="false">
                            <ItemStyle BackColor="Control" Width="30px" />
                            <HeaderStyle Width="30px" />
                        </telerik:GridEditCommandColumn>

                        <telerik:GridTemplateColumn DataField="TimeSlotID" Visible="false" InsertVisiblityMode="AlwaysHidden" DataType="System.Int32" 
                                                    FilterControlAltText="Filter TimeSlotID column" HeaderText="<%$ Resources:Resource, lblID %>" ForceExtractValue="Always"
                                                    SortExpression="TimeSlotID" UniqueName="TimeSlotID" GroupByExpression="TimeSlotID TimeSlotID GROUP BY TimeSlotID">
                            <EditItemTemplate>
                                <asp:Label runat="server" ID="TimeSlotID" Text='<%# Eval("TimeSlotID") %>'></asp:Label>
                            </EditItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn DataField="NameVisible" HeaderText="<%$ Resources:Resource, lblNameVisible %>" SortExpression="NameVisible" UniqueName="NameVisible"
                                                    GroupByExpression="NameVisible NameVisible GROUP BY NameVisible">
                            <EditItemTemplate>
                                <telerik:RadTextBox runat="server" ID="NameVisible" Text='<%# Bind("NameVisible") %>'></telerik:RadTextBox>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="NameVisible" Text="*" SetFocusOnError="true" ForeColor="Red"
                                                            ErrorMessage='<%# String.Concat(Resources.Resource.lblNameVisible, " ", Resources.Resource.lblRequired) %>'>
                                </asp:RequiredFieldValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label runat="server" ID="NameVisible1" Text='<%# Eval("NameVisible") %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn DataField="DescriptionShort" FilterControlAltText="Filter DescriptionShort column" HeaderText="<%$ Resources:Resource, lblDescriptionShort %>"
                                                    SortExpression="DescriptionShort" UniqueName="DescriptionShort" GroupByExpression="DescriptionShort DescriptionShort GROUP BY DescriptionShort">
                            <EditItemTemplate>
                                <telerik:RadTextBox runat="server" ID="DescriptionShort" Text='<%# Bind("DescriptionShort") %>' Width="300px"></telerik:RadTextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label runat="server" ID="LabelDescriptionShort" Text='<%# Eval("DescriptionShort") %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn DataField="ValidFrom" HeaderText="<%$ Resources:Resource, lblValidFrom %>" SortExpression="ValidFrom" UniqueName="ValidFrom"
                                                    GroupByExpression="ValidFrom ValidFrom GROUP BY ValidFrom">
                            <EditItemTemplate>
                                <telerik:RadDateTimePicker ID="ValidFrom" runat="server" DbSelectedDate='<%# Bind("ValidFrom") %>' MinDate="1900/1/1" MaxDate="2100/1/1" EnableShadows="true"
                                                           ShowPopupOnFocus="true" Width="200px">
                                    <DateInput runat="server" DateFormat="G" DisplayDateFormat="G"></DateInput>
                                    <Calendar runat="server">
                                        <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                                TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                        </FastNavigationSettings>
                                    </Calendar>
                                    <TimeView runat="server" ShowHeader="true" HeaderText="<%$ Resources:Resource, lblValidFrom %>" StartTime="00:00:00" Interval="01:00:00" EndTime="23:59:59" 
                                              Columns="4" TimeFormat="T">
                                    </TimeView>
                                </telerik:RadDateTimePicker>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="ValidFrom" Text="*" SetFocusOnError="true" ForeColor="Red"
                                                            ErrorMessage='<%# String.Concat(Resources.Resource.lblValidFrom, " ", Resources.Resource.lblRequired) %>'>
                                </asp:RequiredFieldValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label runat="server" ID="LabelValidFrom" Text='<%# Eval("ValidFrom", "{0:G}") %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn DataField="ValidUntil" HeaderText="<%$ Resources:Resource, lblValidTo %>" SortExpression="ValidUntil" UniqueName="ValidUntil"
                                                    GroupByExpression="ValidUntil ValidUntil GROUP BY ValidUntil">
                            <EditItemTemplate>
                                <telerik:RadDateTimePicker ID="ValidUntil" runat="server" DbSelectedDate='<%# Bind("ValidUntil") %>' MinDate="<%# DateTime.Now.AddDays(-1).Date %>" MaxDate="2100/1/1" EnableShadows="true"
                                                           ShowPopupOnFocus="true" Width="200px">
                                    <DateInput runat="server" DateFormat="G" DisplayDateFormat="G"></DateInput>
                                    <Calendar runat="server">
                                        <FastNavigationSettings CancelButtonCaption="<%$ Resources:Resource, lblActionCancel %>" OkButtonCaption="<%$ Resources:Resource, lblOK %>"
                                                                TodayButtonCaption="<%$ Resources:Resource, lblToday %>">
                                        </FastNavigationSettings>
                                    </Calendar>
                                    <TimeView runat="server" ShowHeader="true" HeaderText="<%$ Resources:Resource, lblValidTo %>" StartTime="00:00:00" Interval="01:00:00" EndTime="23:59:59" 
                                              Columns="4" TimeFormat="T">
                                    </TimeView>
                                </telerik:RadDateTimePicker>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="ValidUntil" Text="*" SetFocusOnError="true" ForeColor="Red"
                                                            ErrorMessage='<%# String.Concat(Resources.Resource.lblValidTo, " ", Resources.Resource.lblRequired) %>'>
                                </asp:RequiredFieldValidator>
                                <asp:CompareValidator runat="server" ControlToValidate="ValidUntil" ControlToCompare="ValidFrom" ValueToCompare="SelectedDate" Operator="GreaterThan"
                                                      Text="*" SetFocusOnError="true" ForeColor="Red" ErrorMessage="<%$ Resources:Resource, msgDateFromLargerDateUntil %>">
                                </asp:CompareValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label runat="server" ID="LabelValidUntil" Text='<%# Eval("ValidUntil", "{0:G}") %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn DataField="ValidDays" HeaderText="<%$ Resources:Resource, lblValidDays %>" SortExpression="ValidDays" UniqueName="ValidDays"
                                                    GroupByExpression="ValidDays ValidDays GROUP BY ValidDays" DefaultInsertValue="1111100">
                            <EditItemTemplate>
                                <telerik:RadAjaxPanel runat="server">
                                    <telerik:RadTextBox runat="server" ID="ValidDays" Text='<%# Bind("ValidDays") %>' Visible="false"></telerik:RadTextBox>
                                    <table>
                                        <tr>
                                            <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                <asp:Label runat="server" Text="<%$ Resources:Resource, dayMo %>"></asp:Label>
                                            </td>
                                            <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                <asp:Label runat="server" Text="<%$ Resources:Resource, dayTu %>"></asp:Label>
                                            </td>
                                            <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                <asp:Label runat="server" Text="<%$ Resources:Resource, dayWe %>"></asp:Label>
                                            </td>
                                            <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                <asp:Label runat="server" Text="<%$ Resources:Resource, dayTh %>"></asp:Label>
                                            </td>
                                            <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                <asp:Label runat="server" Text="<%$ Resources:Resource, dayFr %>"></asp:Label>
                                            </td>
                                            <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                <asp:Label runat="server" Text="<%$ Resources:Resource, daySa %>" ForeColor="Red"></asp:Label>
                                            </td>
                                            <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                <asp:Label runat="server" Text="<%$ Resources:Resource, daySu %>" ForeColor="Red"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                <asp:CheckBox runat="server" ID="DayMo" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 0) %>' OnCheckedChanged="DayMo_CheckedChanged" 
                                                              AutoPostBack="true" CausesValidation="false" />
                                            </td>
                                            <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                <asp:CheckBox runat="server" ID="DayTu" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 1) %>' OnCheckedChanged="DayTu_CheckedChanged" 
                                                              AutoPostBack="true" CausesValidation="false" />
                                            </td>
                                            <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                <asp:CheckBox runat="server" ID="DayWe" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 2) %>' OnCheckedChanged="DayWe_CheckedChanged" 
                                                              AutoPostBack="true" CausesValidation="false" />
                                            </td>
                                            <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                <asp:CheckBox runat="server" ID="DayTh" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 3) %>' OnCheckedChanged="DayTh_CheckedChanged" 
                                                              AutoPostBack="true" CausesValidation="false" />
                                            </td>
                                            <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                <asp:CheckBox runat="server" ID="DayFr" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 4) %>' OnCheckedChanged="DayFr_CheckedChanged" 
                                                              AutoPostBack="true" CausesValidation="false" />
                                            </td>
                                            <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                <asp:CheckBox runat="server" ID="DaySa" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 5) %>' OnCheckedChanged="DaySa_CheckedChanged" 
                                                              AutoPostBack="true" CausesValidation="false" />
                                            </td>
                                            <td style="padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                                <asp:CheckBox runat="server" ID="DaySu" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 6) %>' OnCheckedChanged="DaySu_CheckedChanged" 
                                                              AutoPostBack="true" CausesValidation="false" />
                                            </td>
                                        </tr>
                                    </table>
                                </telerik:RadAjaxPanel>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label runat="server" ID="ValidDays" Text='<%# Eval("ValidDays") %>' Visible="false"></asp:Label>
                                <table cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                            <asp:Label runat="server" Text="<%$ Resources:Resource, dayMo %>"></asp:Label>
                                        </td>
                                        <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                            <asp:Label runat="server" Text="<%$ Resources:Resource, dayTu %>"></asp:Label>
                                        </td>
                                        <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                            <asp:Label runat="server" Text="<%$ Resources:Resource, dayWe %>"></asp:Label>
                                        </td>
                                        <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                            <asp:Label runat="server" Text="<%$ Resources:Resource, dayTh %>"></asp:Label>
                                        </td>
                                        <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                            <asp:Label runat="server" Text="<%$ Resources:Resource, dayFr %>"></asp:Label>
                                        </td>
                                        <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                            <asp:Label runat="server" Text="<%$ Resources:Resource, daySa %>" ForeColor="Red"></asp:Label>
                                        </td>
                                        <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                            <asp:Label runat="server" Text="<%$ Resources:Resource, daySu %>" ForeColor="Red"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                            <asp:CheckBox runat="server" ID="DayMo" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 0) %>' Enabled="false" 
                                                          Width="20px" Height="15px"/>
                                        </td>
                                        <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                            <asp:CheckBox runat="server" ID="DayTu" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 1) %>' Enabled="false" 
                                                          Width="20px" Height="15px"/>
                                        </td>
                                        <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                            <asp:CheckBox runat="server" ID="DayWe" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 2) %>' Enabled="false" 
                                                          Width="20px" Height="15px"/>
                                        </td>
                                        <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                            <asp:CheckBox runat="server" ID="DayTh" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 3) %>' Enabled="false" 
                                                          Width="20px" Height="15px"/>
                                        </td>
                                        <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                            <asp:CheckBox runat="server" ID="DayFr" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 4) %>' Enabled="false" 
                                                          Width="20px" Height="15px"/>
                                        </td>
                                        <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                            <asp:CheckBox runat="server" ID="DaySa" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 5) %>' Enabled="false" 
                                                          Width="20px" Height="15px"/>
                                        </td>
                                        <td style="height: 15px !important;padding: 0px; margin: 0px; border: none; width:20px; text-align: center;">
                                            <asp:CheckBox runat="server" ID="DaySu" Checked='<%# GetValidForDay(Eval("ValidDays").ToString(), 6) %>' Enabled="false" 
                                                          Width="20px" Height="15px"/>
                                        </td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn DataField="TimeFrom" HeaderText="<%$ Resources:Resource, lblTimeFrom %>" SortExpression="TimeFrom" UniqueName="TimeFrom"
                                                    GroupByExpression="TimeFrom TimeFrom GROUP BY TimeFrom">
                            <EditItemTemplate>
                                <telerik:RadTimePicker ID="TimeFrom" runat="server" DbSelectedDate='<%# Bind("TimeFrom") %>' EnableShadows="true" DateInput-DisplayDateFormat="T" DateInput-DateFormat="T"
                                                       ShowPopupOnFocus="true">
                                    <TimeView runat="server" ShowHeader="true" HeaderText="<%$ Resources:Resource, lblTimeFrom %>" StartTime="00:00:00" Interval="01:00:00" EndTime="23:59:59" 
                                              Columns="4" TimeFormat="T">
                                    </TimeView>
                                </telerik:RadTimePicker>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="TimeFrom" Text="*" SetFocusOnError="true" ForeColor="Red"
                                                            ErrorMessage='<%# String.Concat(Resources.Resource.lblTimeFrom, " ", Resources.Resource.lblRequired) %>'>
                                </asp:RequiredFieldValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label runat="server" ID="LabelTimeFrom" Text='<%# Eval("TimeFrom", "{0:T}") %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn DataField="TimeUntil" HeaderText="<%$ Resources:Resource, lblTimeUntil %>" SortExpression="TimeUntil" UniqueName="TimeUntil"
                                                    GroupByExpression="TimeUntil TimeUntil GROUP BY TimeUntil">
                            <EditItemTemplate>
                                <telerik:RadTimePicker ID="TimeUntil" runat="server" DbSelectedDate='<%# Bind("TimeUntil") %>' EnableShadows="true" DateInput-DisplayDateFormat="T" DateInput-DateFormat="T"
                                                       ShowPopupOnFocus="true" >
                                    <TimeView runat="server" ShowHeader="true" HeaderText="<%$ Resources:Resource, lblTimeUntil %>" StartTime="00:00:00" Interval="01:00:00" EndTime="23:59:59" 
                                              Columns="4" TimeFormat="T">
                                    </TimeView>
                                </telerik:RadTimePicker>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="TimeUntil" Text="*" SetFocusOnError="true" ForeColor="Red"
                                                            ErrorMessage='<%# String.Concat(Resources.Resource.lblTimeUntil, " ", Resources.Resource.lblRequired) %>'>
                                </asp:RequiredFieldValidator>
                                <asp:CompareValidator runat="server" ControlToValidate="TimeUntil" ControlToCompare="TimeFrom" ValueToCompare="SelectedTime" Operator="GreaterThan"
                                                      Text="*" SetFocusOnError="true" ForeColor="Red" ErrorMessage="<%$ Resources:Resource, msgTimeFromLargerTimeUntil %>">
                                </asp:CompareValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label runat="server" ID="LabelTimeUntil" Text='<%# Eval("TimeUntil", "{0:T}") %>'></asp:Label>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn DataField="CreatedFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedFrom column"
                                                    HeaderText="<%$ Resources:Resource, lblCreatedFrom %>" SortExpression="CreatedFrom" UniqueName="CreatedFrom" Visible="False">
                            <EditItemTemplate>
                                <asp:Label ID="CreatedFrom" runat="server" Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                            </InsertItemTemplate>
                            <ItemTemplate>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn DataField="CreatedOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedOn column" 
                                                    HeaderText="<%$ Resources:Resource, lblCreatedOn %>" SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="False">
                            <EditItemTemplate>
                                <asp:Label ID="CreatedOn" runat="server" Text='<%# Eval("CreatedOn") %>'></asp:Label>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                            </InsertItemTemplate>
                            <ItemTemplate>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn DataField="EditFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditFrom column" 
                                                    HeaderText="<%$ Resources:Resource, lblEditFrom %>" SortExpression="EditFrom" UniqueName="EditFrom" Visible="False">
                            <EditItemTemplate>
                                <asp:Label ID="EditFrom" runat="server" Text='<%# Eval("EditFrom") %>'></asp:Label>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                            </InsertItemTemplate>
                            <ItemTemplate>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn DataField="EditOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditOn column" 
                                                    HeaderText="<%$ Resources:Resource, lblEditOn %>" SortExpression="EditOn" UniqueName="EditOn" Visible="False">
                            <EditItemTemplate>
                                <asp:Label ID="EditOn" runat="server" Text='<%# Eval("EditOn") %>'></asp:Label>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                            </InsertItemTemplate>
                            <ItemTemplate>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridTemplateColumn UniqueName="ValidationSummary1" HeaderText="<%$ Resources:Resource, lblHint %>" Visible="false">
                            <EditItemTemplate>
                                <asp:ValidationSummary ID="ValidationSummary1" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' 
                                                       ShowMessageBox="true" ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true" />
                            </EditItemTemplate>
                            <ItemTemplate></ItemTemplate>
                        </telerik:GridTemplateColumn>

                        <telerik:GridButtonColumn UniqueName="deleteColumn1" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                                  ConfirmDialogType="RadWindow"
                                                  ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                            <ItemStyle BackColor="Control" />
                        </telerik:GridButtonColumn>
                    </Columns>

                </telerik:GridTableView>
            </DetailTables>

            <Columns>
                <telerik:GridEditCommandColumn ButtonType="ImageButton" UniqueName="EditCommandColumn1" CancelText="<%$ Resources:Resource, lblActionCancel %>" EditText="<%$ Resources:Resource, lblActionEdit %>"
                                               UpdateText="<%$ Resources:Resource, lblActionUpdate %>" Reorderable="false" Resizable="false">
                    <ItemStyle BackColor="Control" Width="30px" />
                    <HeaderStyle Width="30px" />
                </telerik:GridEditCommandColumn>

                <telerik:GridTemplateColumn DataField="TimeSlotGroupID" Visible="false" InsertVisiblityMode="AlwaysHidden" DataType="System.Int32" 
                                            FilterControlAltText="Filter TimeSlotGroupID column" HeaderText="<%$ Resources:Resource, lblID %>" ForceExtractValue="InEditMode"
                                            SortExpression="TimeSlotGroupID" UniqueName="TimeSlotGroupID" GroupByExpression="TimeSlotGroupID TimeSlotGroupID GROUP BY TimeSlotGroupID">
                    <EditItemTemplate>
                        <asp:Label runat="server" ID="TimeSlotGroupID" Text='<%# Eval("TimeSlotGroupID") %>'></asp:Label>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                    </InsertItemTemplate>
                    <ItemTemplate>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="NameVisible" HeaderText="<%$ Resources:Resource, lblNameVisible %>" SortExpression="NameVisible" UniqueName="NameVisible"
                                            GroupByExpression="NameVisible NameVisible GROUP BY NameVisible">
                    <EditItemTemplate>
                        <telerik:RadTextBox runat="server" ID="NameVisible" Text='<%# Bind("NameVisible") %>'></telerik:RadTextBox>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="NameVisible" Text="*" SetFocusOnError="true" ForeColor="Red"
                                                    ErrorMessage='<%# String.Concat(Resources.Resource.lblNameVisible, " ", Resources.Resource.lblRequired) %>'>
                        </asp:RequiredFieldValidator>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" ID="NameVisible1" Text='<%# Eval("NameVisible") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="DescriptionShort" FilterControlAltText="Filter DescriptionShort column" HeaderText="<%$ Resources:Resource, lblDescriptionShort %>"
                                            SortExpression="DescriptionShort" UniqueName="DescriptionShort" GroupByExpression="DescriptionShort DescriptionShort GROUP BY DescriptionShort">
                    <EditItemTemplate>
                        <telerik:RadTextBox runat="server" ID="DescriptionShort" Text='<%# Bind("DescriptionShort") %>' Width="300px"></telerik:RadTextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label runat="server" ID="LabelDescriptionShort" Text='<%# Eval("DescriptionShort") %>'></asp:Label>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="CreatedFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedFrom column"
                                            HeaderText="<%$ Resources:Resource, lblCreatedFrom %>" SortExpression="CreatedFrom" UniqueName="CreatedFrom" Visible="False">
                    <EditItemTemplate>
                        <asp:Label ID="CreatedFrom" runat="server" Text='<%# Eval("CreatedFrom") %>'></asp:Label>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                    </InsertItemTemplate>
                    <ItemTemplate>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="CreatedOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter CreatedOn column" 
                                            HeaderText="<%$ Resources:Resource, lblCreatedOn %>" SortExpression="CreatedOn" UniqueName="CreatedOn" Visible="False">
                    <EditItemTemplate>
                        <asp:Label ID="CreatedOn" runat="server" Text='<%# Eval("CreatedOn") %>'></asp:Label>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                    </InsertItemTemplate>
                    <ItemTemplate>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="EditFrom" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditFrom column" 
                                            HeaderText="<%$ Resources:Resource, lblEditFrom %>" SortExpression="EditFrom" UniqueName="EditFrom" Visible="False">
                    <EditItemTemplate>
                        <asp:Label ID="EditFrom" runat="server" Text='<%# Eval("EditFrom") %>'></asp:Label>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                    </InsertItemTemplate>
                    <ItemTemplate>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn DataField="EditOn" InsertVisiblityMode="AlwaysHidden" FilterControlAltText="Filter EditOn column" 
                                            HeaderText="<%$ Resources:Resource, lblEditOn %>" SortExpression="EditOn" UniqueName="EditOn" Visible="False">
                    <EditItemTemplate>
                        <asp:Label ID="EditOn" runat="server" Text='<%# Eval("EditOn") %>'></asp:Label>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                    </InsertItemTemplate>
                    <ItemTemplate>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridTemplateColumn UniqueName="ValidationSummary1" HeaderText="<%$ Resources:Resource, lblHint %>" Visible="false">
                    <EditItemTemplate>
                        <asp:ValidationSummary ID="ValidationSummary1" runat="server" HeaderText='<%# String.Concat(Resources.Resource.msgPleaseNoteFollowing, ":") %>' 
                                               ShowMessageBox="true" ShowSummary="true" DisplayMode="BulletList" EnableClientScript="true" />
                    </EditItemTemplate>
                    <ItemTemplate></ItemTemplate>
                </telerik:GridTemplateColumn>

                <telerik:GridButtonColumn UniqueName="deleteColumn" Visible="true" ConfirmText="<%$ Resources:Resource, qstDeleteRow %>" Text="<%$ Resources:Resource, lblActionDelete %>" 
                                          ConfirmDialogType="RadWindow"
                                          ConfirmTitle="<%$ Resources:Resource, lblActionDelete %>" ButtonType="ImageButton" CommandName="Delete" HeaderStyle-Width="30px" ItemStyle-Width="30px">
                    <ItemStyle BackColor="Control" />
                </telerik:GridButtonColumn>
            </Columns>
        </MasterTableView>
    </telerik:RadGrid>

    <asp:SqlDataSource runat="server" ID="SqlDataSource_TimeSlotGroups" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>' 
                       OldValuesParameterFormatString="original_{0}" 
                       DeleteCommand="INSERT INTO History_TimeSlotGroups SELECT * FROM Master_TimeSlotGroups WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [TimeSlotGroupID] = @original_TimeSlotGroupID; 
                       DELETE FROM [Master_TimeSlotGroups] WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [TimeSlotGroupID] = @original_TimeSlotGroupID" 
                       SelectCommand="SELECT * FROM [Master_TimeSlotGroups] WHERE (([SystemID] = @SystemID) AND ([BpID] = @BpID)) ORDER BY [NameVisible]" 
                       UpdateCommand="INSERT INTO History_TimeSlotGroups SELECT * FROM Master_TimeSlotGroups WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [TimeSlotGroupID] = @original_TimeSlotGroupID; 
                       UPDATE [Master_TimeSlotGroups] SET [NameVisible] = @NameVisible, [DescriptionShort] = @DescriptionShort, [EditFrom] = @UserName, [EditOn] = SYSDATETIME() WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [TimeSlotGroupID] = @original_TimeSlotGroupID">
        <DeleteParameters>
            <asp:Parameter Name="original_SystemID"></asp:Parameter>
            <asp:Parameter Name="original_BpID"></asp:Parameter>
            <asp:Parameter Name="original_TimeSlotGroupID"></asp:Parameter>
        </DeleteParameters>
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="NameVisible" Type="String"></asp:Parameter>
            <asp:Parameter Name="DescriptionShort" Type="String"></asp:Parameter>
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
            <asp:Parameter Name="original_SystemID"></asp:Parameter>
            <asp:Parameter Name="original_BpID"></asp:Parameter>
            <asp:Parameter Name="original_TimeSlotGroupID"></asp:Parameter>
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource runat="server" ID="SqlDataSource_TimeSlots" ConnectionString='<%$ ConnectionStrings:Insite_Dev_ConnectionString %>'
                       OldValuesParameterFormatString="original_{0}"
                       DeleteCommand="INSERT INTO History_TimeSlots SELECT * FROM Master_TimeSlots WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [TimeSlotGroupID] = @original_TimeSlotGroupID AND [TimeSlotID] = @original_TimeSlotID; 
                       DELETE FROM [Master_TimeSlots] WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [TimeSlotGroupID] = @original_TimeSlotGroupID AND [TimeSlotID] = @original_TimeSlotID"
                       SelectCommand="SELECT SystemID, BpID, TimeSlotGroupID, TimeSlotID, NameVisible, DescriptionShort, ValidFrom, ValidUntil, ValidDays, TimeFrom, TimeUntil, CreatedFrom, CreatedOn, EditFrom, EditOn FROM Master_TimeSlots WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (TimeSlotGroupID = @TimeSlotGroupID) ORDER BY NameVisible"
                       UpdateCommand="INSERT INTO History_TimeSlots SELECT * FROM Master_TimeSlots WHERE [SystemID] = @original_SystemID AND [BpID] = @original_BpID AND [TimeSlotGroupID] = @original_TimeSlotGroupID AND [TimeSlotID] = @original_TimeSlotID; 
                       UPDATE Master_TimeSlots SET NameVisible = @NameVisible, DescriptionShort = @DescriptionShort, EditFrom = @UserName, EditOn = SYSDATETIME(), ValidFrom =@ValidFrom, ValidUntil =@ValidUntil, ValidDays =@ValidDays, TimeFrom =@TimeFrom, TimeUntil =@TimeUntil WHERE (SystemID = @original_SystemID) AND (BpID = @original_BpID) AND (TimeSlotGroupID = @original_TimeSlotGroupID) AND (TimeSlotID = @original_TimeSlotID)" InsertCommand="INSERT INTO Master_TimeSlots(SystemID, BpID, TimeSlotGroupID, NameVisible, DescriptionShort, ValidFrom, ValidUntil, ValidDays, TimeFrom, TimeUntil, CreatedFrom, CreatedOn, EditFrom, EditOn) VALUES (@SystemID, @BpID, @TimeSlotGroupID, @NameVisible, @DescriptionShort, @ValidFrom, @ValidUntil, @ValidDays, @TimeFrom, @TimeUntil, @UserName, SYSDATETIME(), @UserName, SYSDATETIME())">
        <DeleteParameters>
            <asp:Parameter Name="original_SystemID"></asp:Parameter>
            <asp:Parameter Name="original_BpID"></asp:Parameter>
            <asp:Parameter Name="original_TimeSlotGroupID"></asp:Parameter>
            <asp:Parameter Name="original_TimeSlotID"></asp:Parameter>
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="SystemID"></asp:Parameter>
            <asp:Parameter Name="BpID"></asp:Parameter>
            <asp:Parameter Name="TimeSlotGroupID"></asp:Parameter>
            <asp:Parameter Name="NameVisible"></asp:Parameter>
            <asp:Parameter Name="DescriptionShort"></asp:Parameter>
            <asp:Parameter Name="ValidFrom"></asp:Parameter>
            <asp:Parameter Name="ValidUntil"></asp:Parameter>
            <asp:Parameter Name="ValidDays"></asp:Parameter>
            <asp:Parameter Name="TimeFrom"></asp:Parameter>
            <asp:Parameter Name="TimeUntil"></asp:Parameter>
            <asp:Parameter Name="UserName"></asp:Parameter>
        </InsertParameters>
        <SelectParameters>
            <asp:SessionParameter SessionField="SystemID" DefaultValue="0" Name="SystemID" Type="Int32"></asp:SessionParameter>
            <asp:SessionParameter SessionField="BpID" DefaultValue="0" Name="BpID" Type="Int32"></asp:SessionParameter>
            <asp:Parameter Name="TimeSlotGroupID" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="NameVisible" Type="String"></asp:Parameter>
            <asp:Parameter Name="DescriptionShort" Type="String"></asp:Parameter>
            <asp:SessionParameter DefaultValue="" Name="UserName" SessionField="LoginName" Type="String" />
            <asp:Parameter Name="ValidFrom"></asp:Parameter>
            <asp:Parameter Name="ValidUntil"></asp:Parameter>
            <asp:Parameter Name="ValidDays"></asp:Parameter>
            <asp:Parameter Name="TimeFrom"></asp:Parameter>
            <asp:Parameter Name="TimeUntil"></asp:Parameter>
            <asp:Parameter Name="original_SystemID"></asp:Parameter>
            <asp:Parameter Name="original_BpID"></asp:Parameter>
            <asp:Parameter Name="original_TimeSlotGroupID"></asp:Parameter>
            <asp:Parameter Name="original_TimeSlotID"></asp:Parameter>
        </UpdateParameters>
    </asp:SqlDataSource>
</asp:Content>
