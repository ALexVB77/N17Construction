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
OR [Table ID] = '14' AND (([Dimension Code] <> 'CP') OR ([Dimension Code] = 'CP'
AND ([Dimension Value Code] = '98070'
OR [Dimension Value Code] = '98020'
OR [Dimension Value Code] = '28004-203'
OR [Dimension Value Code] = '28900-000'
OR [Dimension Value Code] = '97001'
OR [Dimension Value Code] = '97002'
OR [Dimension Value Code] = '97010'
OR [Dimension Value Code] = '97004'
OR [Dimension Value Code] = '97020'
OR [Dimension Value Code] = '97022'
OR [Dimension Value Code] = '98010'
OR [Dimension Value Code] = '98020'
OR [Dimension Value Code] = '98030'
OR [Dimension Value Code] = '98040'
OR [Dimension Value Code] = '98051'
OR [Dimension Value Code] = '98053'
OR [Dimension Value Code] = '98055'
OR [Dimension Value Code] = '98070'
OR [Dimension Value Code] = '98080'
OR [Dimension Value Code] = '99010'
OR [Dimension Value Code] = '99020'
OR [Dimension Value Code] = '99030'
OR [Dimension Value Code] = '99040'
OR [Dimension Value Code] = '28001-202')))
OR ([Table ID] = '14901' AND [Dimension Value Code] <> '28012-107D' AND [Dimension Value Code] <> '28012-106D');


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
	GLAccMapping.[New No_] AS [No_],
	[Dimension Code],
	[Dimension Value Code],
	[Value Posting],
	[Multi Selection Action]
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[Bonava$Default Dimension]
INNER JOIN [Bonava-Test].[dbo].[Bonava$G_L Account Mapping$2944687f-9cf8-4134-a24c-e21fb70a8b1a] GLAccMapping
ON GLAccMapping.[Old No_] = [No_] collate Cyrillic_General_100_CI_AS
WHERE [Table ID] = '15';