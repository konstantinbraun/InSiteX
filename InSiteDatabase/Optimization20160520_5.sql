use [Insite_Dev]
go

SET ANSI_PADDING ON

go

CREATE NONCLUSTERED INDEX [_dta_index_Master_Translations_7_200387783__K5_K1_K2_K3_K4_K6_8] ON [dbo].[Master_Translations]
(
	[ForeignID] ASC,
	[SystemID] ASC,
	[BpID] ASC,
	[DialogID] ASC,
	[FieldID] ASC,
	[LanguageID] ASC
)
INCLUDE ( 	[DescriptionTranslated]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_200387783_2_5] ON [dbo].[Master_Translations]([BpID], [ForeignID])
go

CREATE STATISTICS [_dta_stat_200387783_3_5_1] ON [dbo].[Master_Translations]([DialogID], [ForeignID], [SystemID])
go

CREATE STATISTICS [_dta_stat_200387783_4_5_1_2] ON [dbo].[Master_Translations]([FieldID], [ForeignID], [SystemID], [BpID])
go

SET ANSI_PADDING ON

go

CREATE NONCLUSTERED INDEX [_dta_index_Master_EmployeeRelevantDocuments_7_1709249144__K2_K1_K3_K5_4_6_7_8] ON [dbo].[Master_EmployeeRelevantDocuments]
(
	[BpID] ASC,
	[SystemID] ASC,
	[EmployeeID] ASC,
	[RelevantDocumentID] ASC
)
INCLUDE ( 	[RelevantFor],
	[DocumentReceived],
	[ExpirationDate],
	[IDNumber]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_1709249144_3_2_1] ON [dbo].[Master_EmployeeRelevantDocuments]([EmployeeID], [BpID], [SystemID])
go

CREATE STATISTICS [_dta_stat_1709249144_5_1_2] ON [dbo].[Master_EmployeeRelevantDocuments]([RelevantDocumentID], [SystemID], [BpID])
go

CREATE STATISTICS [_dta_stat_1709249144_5_3_2_1] ON [dbo].[Master_EmployeeRelevantDocuments]([RelevantDocumentID], [EmployeeID], [BpID], [SystemID])
go

CREATE STATISTICS [_dta_stat_1355151873_3_2] ON [dbo].[Master_RelevantDocuments]([RelevantDocumentID], [BpID])
go

