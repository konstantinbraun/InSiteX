use [Insite_Dev]
go

SET ANSI_PADDING ON

go

CREATE NONCLUSTERED INDEX [_dta_index_Data_AccessEvents_7_377104434__K2_K4_K20_K8_K9_K5_K1_K15_K11_K12_K13_K22_K16_K19_K23_K24_6_10_18_21_25] ON [dbo].[Data_AccessEvents]
(
	[SystemID] ASC,
	[BpID] ASC,
	[PassType] ASC,
	[OwnerID] ASC,
	[InternalID] ASC,
	[AccessAreaID] ASC,
	[AccessEventID] ASC,
	[DenialReason] ASC,
	[AccessOn] ASC,
	[AccessType] ASC,
	[AccessResult] ASC,
	[CreatedOn] ASC,
	[IsManualEntry] ASC,
	[Remark] ASC,
	[CreatedFrom] ASC,
	[EditOn] ASC
)
INCLUDE ( 	[EntryID],
	[IsOnlineAccessEvent],
	[CountIt],
	[AccessEventLinkedID],
	[EditFrom]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

SET ANSI_PADDING ON

go

CREATE NONCLUSTERED INDEX [_dta_index_Data_AccessEvents_7_377104434__K2_K4_K20_K8_K5_K1_K11_K12_K13_K15_K9_K22_K16_K19_K23_K24_6_10_18_21_25] ON [dbo].[Data_AccessEvents]
(
	[SystemID] ASC,
	[BpID] ASC,
	[PassType] ASC,
	[OwnerID] ASC,
	[AccessAreaID] ASC,
	[AccessEventID] ASC,
	[AccessOn] ASC,
	[AccessType] ASC,
	[AccessResult] ASC,
	[DenialReason] ASC,
	[InternalID] ASC,
	[CreatedOn] ASC,
	[IsManualEntry] ASC,
	[Remark] ASC,
	[CreatedFrom] ASC,
	[EditOn] ASC
)
INCLUDE ( 	[EntryID],
	[IsOnlineAccessEvent],
	[CountIt],
	[AccessEventLinkedID],
	[EditFrom]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_377104434_15_9] ON [dbo].[Data_AccessEvents]([DenialReason], [InternalID])
go

CREATE STATISTICS [_dta_stat_377104434_1_15] ON [dbo].[Data_AccessEvents]([AccessEventID], [DenialReason])
go

CREATE STATISTICS [_dta_stat_377104434_2_4_8] ON [dbo].[Data_AccessEvents]([SystemID], [BpID], [OwnerID])
go

CREATE STATISTICS [_dta_stat_377104434_5_4_8_20] ON [dbo].[Data_AccessEvents]([AccessAreaID], [BpID], [OwnerID], [PassType])
go

CREATE STATISTICS [_dta_stat_377104434_8_5_2_4] ON [dbo].[Data_AccessEvents]([OwnerID], [AccessAreaID], [SystemID], [BpID])
go

CREATE STATISTICS [_dta_stat_377104434_2_5_4_20] ON [dbo].[Data_AccessEvents]([SystemID], [AccessAreaID], [BpID], [PassType])
go

CREATE STATISTICS [_dta_stat_377104434_5_1_15_2_4] ON [dbo].[Data_AccessEvents]([AccessAreaID], [AccessEventID], [DenialReason], [SystemID], [BpID])
go

CREATE STATISTICS [_dta_stat_377104434_1_9_5_2_4_20] ON [dbo].[Data_AccessEvents]([AccessEventID], [InternalID], [AccessAreaID], [SystemID], [BpID], [PassType])
go

CREATE STATISTICS [_dta_stat_377104434_15_20_1_5_2_4] ON [dbo].[Data_AccessEvents]([DenialReason], [PassType], [AccessEventID], [AccessAreaID], [SystemID], [BpID])
go

CREATE STATISTICS [_dta_stat_377104434_1_2_4_9_12_13] ON [dbo].[Data_AccessEvents]([AccessEventID], [SystemID], [BpID], [InternalID], [AccessType], [AccessResult])
go

CREATE STATISTICS [_dta_stat_377104434_4_8_20_2_1_5_15] ON [dbo].[Data_AccessEvents]([BpID], [OwnerID], [PassType], [SystemID], [AccessEventID], [AccessAreaID], [DenialReason])
go

CREATE STATISTICS [_dta_stat_377104434_1_2_4_9_8_5_20] ON [dbo].[Data_AccessEvents]([AccessEventID], [SystemID], [BpID], [InternalID], [OwnerID], [AccessAreaID], [PassType])
go

CREATE STATISTICS [_dta_stat_377104434_1_9_22_16_19_23_24_25_10_6] ON [dbo].[Data_AccessEvents]([AccessEventID], [InternalID], [CreatedOn], [IsManualEntry], [Remark], [CreatedFrom], [EditOn], [EditFrom], [IsOnlineAccessEvent], [EntryID])
go

CREATE STATISTICS [_dta_stat_377104434_1_2_4_8_9_12_13_5_20_15] ON [dbo].[Data_AccessEvents]([AccessEventID], [SystemID], [BpID], [OwnerID], [InternalID], [AccessType], [AccessResult], [AccessAreaID], [PassType], [DenialReason])
go

CREATE STATISTICS [_dta_stat_377104434_1_11_22_16_19_23_24_25_10_20_6_15_21_18] ON [dbo].[Data_AccessEvents]([AccessEventID], [AccessOn], [CreatedOn], [IsManualEntry], [Remark], [CreatedFrom], [EditOn], [EditFrom], [IsOnlineAccessEvent], [PassType], [EntryID], [DenialReason], [AccessEventLinkedID], [CountIt])
go

CREATE STATISTICS [_dta_stat_377104434_5_1_15_20_11_22_16_19_23_24_25_10_6_21_18] ON [dbo].[Data_AccessEvents]([AccessAreaID], [AccessEventID], [DenialReason], [PassType], [AccessOn], [CreatedOn], [IsManualEntry], [Remark], [CreatedFrom], [EditOn], [EditFrom], [IsOnlineAccessEvent], [EntryID], [AccessEventLinkedID], [CountIt])
go

CREATE STATISTICS [_dta_stat_377104434_1_2_4_11_9_12_13_22_8_16_19_23_24_25_10_20] ON [dbo].[Data_AccessEvents]([AccessEventID], [SystemID], [BpID], [AccessOn], [InternalID], [AccessType], [AccessResult], [CreatedOn], [OwnerID], [IsManualEntry], [Remark], [CreatedFrom], [EditOn], [EditFrom], [IsOnlineAccessEvent], [PassType])
go

CREATE STATISTICS [_dta_stat_377104434_1_2_4_11_12_13_8_20_15_9_22_16_19_23_24_25] ON [dbo].[Data_AccessEvents]([AccessEventID], [SystemID], [BpID], [AccessOn], [AccessType], [AccessResult], [OwnerID], [PassType], [DenialReason], [InternalID], [CreatedOn], [IsManualEntry], [Remark], [CreatedFrom], [EditOn], [EditFrom])
go

CREATE STATISTICS [_dta_stat_377104434_9_1_15_22_16_19_23_24_25_10_6_21_18_2_4_8] ON [dbo].[Data_AccessEvents]([InternalID], [AccessEventID], [DenialReason], [CreatedOn], [IsManualEntry], [Remark], [CreatedFrom], [EditOn], [EditFrom], [IsOnlineAccessEvent], [EntryID], [AccessEventLinkedID], [CountIt], [SystemID], [BpID], [OwnerID])
go

CREATE STATISTICS [_dta_stat_377104434_9_1_15_5_2_4_20_8_11_12_13_22_16_19_23_24] ON [dbo].[Data_AccessEvents]([InternalID], [AccessEventID], [DenialReason], [AccessAreaID], [SystemID], [BpID], [PassType], [OwnerID], [AccessOn], [AccessType], [AccessResult], [CreatedOn], [IsManualEntry], [Remark], [CreatedFrom], [EditOn])
go

CREATE NONCLUSTERED INDEX [_dta_index_Data_PassHistory_7_1405248061__K4] ON [dbo].[Data_PassHistory]
(
	[EmployeeID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_1405248061_1_4] ON [dbo].[Data_PassHistory]([SystemID], [EmployeeID])
go

CREATE STATISTICS [_dta_stat_1405248061_4_2_1] ON [dbo].[Data_PassHistory]([EmployeeID], [BpID], [SystemID])
go

CREATE NONCLUSTERED INDEX [_dta_index_Master_Users_7_972582553__K1_K3] ON [dbo].[Master_Users]
(
	[SystemID] ASC,
	[UserID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_972582553_3_1] ON [dbo].[Master_Users]([UserID], [SystemID])
go

CREATE STATISTICS [_dta_stat_972582553_21_1_3] ON [dbo].[Master_Users]([NeedsPwdChange], [SystemID], [UserID])
go

CREATE STATISTICS [_dta_stat_1856061698_4_2_9] ON [dbo].[Master_Companies]([CompanyCentralID], [BpID], [ParentID])
go

CREATE STATISTICS [_dta_stat_1856061698_9_1_2_4_3] ON [dbo].[Master_Companies]([ParentID], [SystemID], [BpID], [CompanyCentralID], [CompanyID])
go

CREATE STATISTICS [_dta_stat_1504060444_3_1] ON [dbo].[Master_Roles]([RoleID], [SystemID])
go

CREATE STATISTICS [_dta_stat_777105859_3_1] ON [dbo].[Master_Addresses]([AddressID], [SystemID])
go

CREATE STATISTICS [_dta_stat_617769258_3_1] ON [dbo].[Master_UserBuildingProjects]([BpID], [SystemID])
go

CREATE STATISTICS [_dta_stat_617769258_2_3] ON [dbo].[Master_UserBuildingProjects]([UserID], [BpID])
go

CREATE STATISTICS [_dta_stat_617769258_4_2_3] ON [dbo].[Master_UserBuildingProjects]([RoleID], [UserID], [BpID])
go

CREATE STATISTICS [_dta_stat_617769258_4_1_2_3] ON [dbo].[Master_UserBuildingProjects]([RoleID], [SystemID], [UserID], [BpID])
go

CREATE STATISTICS [_dta_stat_796581926_3_4_2] ON [dbo].[System_Companies]([NameVisible], [NameAdditional], [CompanyID])
go

CREATE STATISTICS [_dta_stat_796581926_2_1_3_4] ON [dbo].[System_Companies]([CompanyID], [SystemID], [NameVisible], [NameAdditional])
go

