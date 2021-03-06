use [Insite_Dev]
go

CREATE NONCLUSTERED INDEX [_dta_index_Master_EmployeeAccessAreas_7_1875537765__K1_K4_K2_K3] ON [dbo].[Master_EmployeeAccessAreas]
(
	[SystemID] ASC,
	[AccessAreaID] ASC,
	[BpID] ASC,
	[EmployeeID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_1875537765_4_3_1] ON [dbo].[Master_EmployeeAccessAreas]([AccessAreaID], [EmployeeID], [SystemID])
go

CREATE STATISTICS [_dta_stat_1875537765_4_2_1] ON [dbo].[Master_EmployeeAccessAreas]([AccessAreaID], [BpID], [SystemID])
go

CREATE NONCLUSTERED INDEX [_dta_index_Data_ShortTermVisitors_7_431340601__K2_K1_K23_K25_K3_K16] ON [dbo].[Data_ShortTermVisitors]
(
	[BpID] ASC,
	[SystemID] ASC,
	[PassDeactivatedOn] ASC,
	[PassLockedOn] ASC,
	[ShortTermVisitorID] ASC,
	[ShortTermPassID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_431340601_23_1] ON [dbo].[Data_ShortTermVisitors]([PassDeactivatedOn], [SystemID])
go

CREATE STATISTICS [_dta_stat_431340601_3_2_1_23] ON [dbo].[Data_ShortTermVisitors]([ShortTermVisitorID], [BpID], [SystemID], [PassDeactivatedOn])
go

CREATE STATISTICS [_dta_stat_431340601_25_1_2_3] ON [dbo].[Data_ShortTermVisitors]([PassLockedOn], [SystemID], [BpID], [ShortTermVisitorID])
go

CREATE STATISTICS [_dta_stat_431340601_16_2_1_23_25] ON [dbo].[Data_ShortTermVisitors]([ShortTermPassID], [BpID], [SystemID], [PassDeactivatedOn], [PassLockedOn])
go

CREATE STATISTICS [_dta_stat_431340601_3_16_1_2_23] ON [dbo].[Data_ShortTermVisitors]([ShortTermVisitorID], [ShortTermPassID], [SystemID], [BpID], [PassDeactivatedOn])
go

CREATE STATISTICS [_dta_stat_431340601_1_2_23_25_3_16] ON [dbo].[Data_ShortTermVisitors]([SystemID], [BpID], [PassDeactivatedOn], [PassLockedOn], [ShortTermVisitorID], [ShortTermPassID])
go

CREATE NONCLUSTERED INDEX [_dta_index_Data_ShortTermAccessAreas_7_880058221__K1_K4_K2_K3] ON [dbo].[Data_ShortTermAccessAreas]
(
	[SystemID] ASC,
	[AccessAreaID] ASC,
	[BpID] ASC,
	[ShortTermVisitorID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_880058221_4_2] ON [dbo].[Data_ShortTermAccessAreas]([AccessAreaID], [BpID])
go

CREATE STATISTICS [_dta_stat_880058221_4_3_1] ON [dbo].[Data_ShortTermAccessAreas]([AccessAreaID], [ShortTermVisitorID], [SystemID])
go

CREATE STATISTICS [_dta_stat_1146487163_5_2_1_3] ON [dbo].[Data_ShortTermPasses]([StatusID], [BpID], [SystemID], [ShortTermPassID])
go

CREATE STATISTICS [_dta_stat_1066486878_2_1_21] ON [dbo].[Master_Passes]([BpID], [SystemID], [DeactivatedOn])
go

CREATE STATISTICS [_dta_stat_1066486878_21_10_2] ON [dbo].[Master_Passes]([DeactivatedOn], [EmployeeID], [BpID])
go

CREATE STATISTICS [_dta_stat_1066486878_23_10_2_1] ON [dbo].[Master_Passes]([LockedOn], [EmployeeID], [BpID], [SystemID])
go

CREATE STATISTICS [_dta_stat_1066486878_2_1_23_21] ON [dbo].[Master_Passes]([BpID], [SystemID], [LockedOn], [DeactivatedOn])
go

CREATE STATISTICS [_dta_stat_1066486878_1_10_2_21_23] ON [dbo].[Master_Passes]([SystemID], [EmployeeID], [BpID], [DeactivatedOn], [LockedOn])
go

