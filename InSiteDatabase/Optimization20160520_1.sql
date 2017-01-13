use [Insite_Dev]
go

CREATE NONCLUSTERED INDEX [_dta_index_Data_AccessEvents_7_377104434__K2_K4_K13_K8_K20_K1_K5_12] ON [dbo].[Data_AccessEvents]
(
	[SystemID] ASC,
	[BpID] ASC,
	[AccessResult] ASC,
	[OwnerID] ASC,
	[PassType] ASC,
	[AccessEventID] ASC,
	[AccessAreaID] ASC
)
INCLUDE ( 	[AccessType]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_377104434_20_1] ON [dbo].[Data_AccessEvents]([PassType], [AccessEventID])
go

CREATE STATISTICS [_dta_stat_377104434_13_2] ON [dbo].[Data_AccessEvents]([AccessResult], [SystemID])
go

CREATE STATISTICS [_dta_stat_377104434_5_20_1_2_4_13] ON [dbo].[Data_AccessEvents]([AccessAreaID], [PassType], [AccessEventID], [SystemID], [BpID], [AccessResult])
go

CREATE STATISTICS [_dta_stat_377104434_1_2_4_13_8_20] ON [dbo].[Data_AccessEvents]([AccessEventID], [SystemID], [BpID], [AccessResult], [OwnerID], [PassType])
go

CREATE STATISTICS [_dta_stat_377104434_1_5_2_4_13_8_20] ON [dbo].[Data_AccessEvents]([AccessEventID], [AccessAreaID], [SystemID], [BpID], [AccessResult], [OwnerID], [PassType])
go

