INSERT INTO [Bonava-Test].[dbo].[Bonava$Default Dimension$437dbf0e-84ff-417a-965d-ed2bb9650972]
(
	[Table ID],
	[No_],
	[Dimension Code],
	[Dimension Value Code],
	[Value Posting],
	[Multi Selection Action]
)
SELECT
	[Table ID],
	[No_],
	[Dimension Code],
	[Dimension Value Code],
	[Value Posting],
	[Multi Selection Action]
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[Bonava$Default Dimension]
WHERE [Table ID] = '13'
OR ([Table ID] = '14' AND [Dimension Code] <> 'CP')
OR [Table ID] = '15'
OR ([Table ID] = '14901' AND [Dimension Value Code] <> '28012-107D' AND [Dimension Value Code] <> '28012-106D');