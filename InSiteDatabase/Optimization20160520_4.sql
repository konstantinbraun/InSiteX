use [Insite_Dev]
go

SET ANSI_PADDING ON

go

CREATE NONCLUSTERED INDEX [_dta_index_Master_Addresses_7_777105859__K3_K2_K1_K17] ON [dbo].[Master_Addresses]
(
	[AddressID] ASC,
	[BpID] ASC,
	[SystemID] ASC,
	[NationalityID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_777105859_17_2] ON [dbo].[Master_Addresses]([NationalityID], [BpID])
go

CREATE STATISTICS [_dta_stat_777105859_2_1_17] ON [dbo].[Master_Addresses]([BpID], [SystemID], [NationalityID])
go

CREATE STATISTICS [_dta_stat_777105859_3_17_1_2] ON [dbo].[Master_Addresses]([AddressID], [NationalityID], [SystemID], [BpID])
go

CREATE NONCLUSTERED INDEX [_dta_index_Master_DocumentCheckingRules_7_1865773704__K1_K2_K5_K3_K4_6] ON [dbo].[Master_DocumentCheckingRules]
(
	[SystemID] ASC,
	[BpID] ASC,
	[EmploymentStatusID] ASC,
	[CountryGroupIDEmployer] ASC,
	[CountryGroupIDEmployee] ASC
)
INCLUDE ( 	[CheckingRuleID]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_1865773704_1_5] ON [dbo].[Master_DocumentCheckingRules]([SystemID], [EmploymentStatusID])
go

CREATE STATISTICS [_dta_stat_1865773704_5_2] ON [dbo].[Master_DocumentCheckingRules]([EmploymentStatusID], [BpID])
go

CREATE STATISTICS [_dta_stat_1865773704_3_4_2] ON [dbo].[Master_DocumentCheckingRules]([CountryGroupIDEmployer], [CountryGroupIDEmployee], [BpID])
go

CREATE STATISTICS [_dta_stat_1865773704_5_3_4_1] ON [dbo].[Master_DocumentCheckingRules]([EmploymentStatusID], [CountryGroupIDEmployer], [CountryGroupIDEmployee], [SystemID])
go

SET ANSI_PADDING ON

go

CREATE NONCLUSTERED INDEX [_dta_index_Master_Countries_7_1483152329__K3_K2_K1_K4] ON [dbo].[Master_Countries]
(
	[CountryID] ASC,
	[BpID] ASC,
	[SystemID] ASC,
	[CountryGroupID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE NONCLUSTERED INDEX [_dta_index_Master_Countries_7_1483152329__K4] ON [dbo].[Master_Countries]
(
	[CountryGroupID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE NONCLUSTERED INDEX [_dta_index_Master_Companies_7_1856061698__K3_K2_K1_K4] ON [dbo].[Master_Companies]
(
	[CompanyID] ASC,
	[BpID] ASC,
	[SystemID] ASC,
	[CompanyCentralID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_1856061698_4_2] ON [dbo].[Master_Companies]([CompanyCentralID], [BpID])
go

CREATE STATISTICS [_dta_stat_1856061698_2_1_4] ON [dbo].[Master_Companies]([BpID], [SystemID], [CompanyCentralID])
go

CREATE STATISTICS [_dta_stat_1856061698_3_4_1] ON [dbo].[Master_Companies]([CompanyID], [CompanyCentralID], [SystemID])
go

CREATE STATISTICS [_dta_stat_1856061698_2_1_3_4] ON [dbo].[Master_Companies]([BpID], [SystemID], [CompanyID], [CompanyCentralID])
go

SET ANSI_PADDING ON

go

CREATE NONCLUSTERED INDEX [_dta_index_System_Addresses_7_636581356__K14_K1_K2] ON [dbo].[System_Addresses]
(
	[CountryID] ASC,
	[SystemID] ASC,
	[AddressID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_636581356_1_14] ON [dbo].[System_Addresses]([SystemID], [CountryID])
go

CREATE STATISTICS [_dta_stat_636581356_2_14] ON [dbo].[System_Addresses]([AddressID], [CountryID])
go

CREATE STATISTICS [_dta_stat_636581356_2_1_14] ON [dbo].[System_Addresses]([AddressID], [SystemID], [CountryID])
go

CREATE NONCLUSTERED INDEX [_dta_index_System_Companies_7_796581926__K2_K1_K6] ON [dbo].[System_Companies]
(
	[CompanyID] ASC,
	[SystemID] ASC,
	[AddressID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_796581926_6_1] ON [dbo].[System_Companies]([AddressID], [SystemID])
go

CREATE STATISTICS [_dta_stat_796581926_2_6] ON [dbo].[System_Companies]([CompanyID], [AddressID])
go

CREATE STATISTICS [_dta_stat_1619536853_1_9] ON [dbo].[Master_Employees]([SystemID], [EmploymentStatusID])
go

CREATE STATISTICS [_dta_stat_1619536853_6_3_2] ON [dbo].[Master_Employees]([CompanyID], [EmployeeID], [BpID])
go

CREATE STATISTICS [_dta_stat_1619536853_2_9_1] ON [dbo].[Master_Employees]([BpID], [EmploymentStatusID], [SystemID])
go

CREATE STATISTICS [_dta_stat_1619536853_5_3_2_1_9] ON [dbo].[Master_Employees]([AddressID], [EmployeeID], [BpID], [SystemID], [EmploymentStatusID])
go

CREATE STATISTICS [_dta_stat_1619536853_9_6_5_1_2] ON [dbo].[Master_Employees]([EmploymentStatusID], [CompanyID], [AddressID], [SystemID], [BpID])
go

CREATE STATISTICS [_dta_stat_1619536853_9_3_2_1_6_5] ON [dbo].[Master_Employees]([EmploymentStatusID], [EmployeeID], [BpID], [SystemID], [CompanyID], [AddressID])
go

