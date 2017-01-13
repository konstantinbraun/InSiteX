use [Insite_Dev]
go

SET ANSI_PADDING ON

go

CREATE NONCLUSTERED INDEX [_dta_index_Data_AccessEvents_7_377104434__K11_K19_K4_K1_K16_K10_K2] ON [dbo].[Data_AccessEvents]
(
	[AccessOn] ASC,
	[Remark] ASC,
	[BpID] ASC,
	[AccessEventID] ASC,
	[IsManualEntry] ASC,
	[IsOnlineAccessEvent] ASC,
	[SystemID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_377104434_4_1] ON [dbo].[Data_AccessEvents]([BpID], [AccessEventID])
go

CREATE STATISTICS [_dta_stat_377104434_10_1_2_4] ON [dbo].[Data_AccessEvents]([IsOnlineAccessEvent], [AccessEventID], [SystemID], [BpID])
go

CREATE STATISTICS [_dta_stat_377104434_16_1_2_4_11] ON [dbo].[Data_AccessEvents]([IsManualEntry], [AccessEventID], [SystemID], [BpID], [AccessOn])
go

CREATE STATISTICS [_dta_stat_377104434_19_4_11_1_16_10] ON [dbo].[Data_AccessEvents]([Remark], [BpID], [AccessOn], [AccessEventID], [IsManualEntry], [IsOnlineAccessEvent])
go

CREATE STATISTICS [_dta_stat_377104434_1_2_4_11_10_16_19] ON [dbo].[Data_AccessEvents]([AccessEventID], [SystemID], [BpID], [AccessOn], [IsOnlineAccessEvent], [IsManualEntry], [Remark])
go

