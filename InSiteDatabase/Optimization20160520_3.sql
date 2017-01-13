use [Insite_Dev]
go

CREATE NONCLUSTERED INDEX [_dta_index_Data_AccessEvents_7_377104434__K5_K8_K4_K13_K20_K2_K1_K11_12] ON [dbo].[Data_AccessEvents]
(
	[AccessAreaID] ASC,
	[OwnerID] ASC,
	[BpID] ASC,
	[AccessResult] ASC,
	[PassType] ASC,
	[SystemID] ASC,
	[AccessEventID] ASC,
	[AccessOn] ASC
)
INCLUDE ( 	[AccessType]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_377104434_13_1_2] ON [dbo].[Data_AccessEvents]([AccessResult], [AccessEventID], [SystemID])
go

CREATE STATISTICS [_dta_stat_377104434_8_4_13_20] ON [dbo].[Data_AccessEvents]([OwnerID], [BpID], [AccessResult], [PassType])
go

CREATE STATISTICS [_dta_stat_377104434_20_1_2_4_13] ON [dbo].[Data_AccessEvents]([PassType], [AccessEventID], [SystemID], [BpID], [AccessResult])
go

CREATE STATISTICS [_dta_stat_377104434_1_2_4_13_8_11] ON [dbo].[Data_AccessEvents]([AccessEventID], [SystemID], [BpID], [AccessResult], [OwnerID], [AccessOn])
go

CREATE STATISTICS [_dta_stat_377104434_11_8_4_13_20_2] ON [dbo].[Data_AccessEvents]([AccessOn], [OwnerID], [BpID], [AccessResult], [PassType], [SystemID])
go

CREATE STATISTICS [_dta_stat_377104434_2_4_13_8_20_1_5_11] ON [dbo].[Data_AccessEvents]([SystemID], [BpID], [AccessResult], [OwnerID], [PassType], [AccessEventID], [AccessAreaID], [AccessOn])
go

