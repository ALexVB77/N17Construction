DELETE FROM [Bonava-Test].[dbo].[Real Estate$Projects Budget Entry$2944687f-9cf8-4134-a24c-e21fb70a8b1a];

--Projects Budget Entry
INSERT INTO [Bonava-Test].[dbo].[Real Estate$Projects Budget Entry$2944687f-9cf8-4134-a24c-e21fb70a8b1a]
(
	[Project Code],
	[Analysis Type],
	[Version Code],
	[Line No_],
	[Entry No_],
	[Project Turn Code],
	[Temp Line No_],
	[Entry Type],
	[Description],
	[Description 2],
	[Amount],
	[Curency],
	[Currency Factor],
	[Amount (LCY)],
	[Date],
	[Transaction Type],
	[Create User],
	[Create Date],
	[Create Time],
	[Parent Entry],
	[Code],
	[Contragent No_],
	[Agreement No_],
	[Without VAT],
	[Including VAT],
	[Contragent Name],
	[External Agreement No_],
	[Contragent Type],
	[Close],
	[Shortcut Dimension 1 Code],
	[Shortcut Dimension 2 Code],
	[Building Turn],
	[Cost Code],
	[New Lines],
	[Not Run OnInsert],
	[Work Version],
	[Reserve],
	[Building Turn All],
	[Date Plan],
	[Write Off Amount],
	[NotVisible],
	[Reversed],
	[ID],
	[Reversed Without Entry],
	[Reversed ID],
	[Without VAT (LCY)],
	[Problem Pmt_ Document],
	[Currency Rate],
	[Close Date],
	[Payment Description]
)
SELECT
	ProjectsBudgetEntry.[Project Code],
	ProjectsBudgetEntry.[Analysis Type],
	ProjectsBudgetEntry.[Version Code],
	ProjectsBudgetEntry.[Line No_],
	ProjectsBudgetEntry.[Entry No_],
	ProjectsBudgetEntry.[Project Turn Code],
	ProjectsBudgetEntry.[Temp Line No_],
	ProjectsBudgetEntry.[Entry Type],
	ProjectsBudgetEntry.[Description],
	ProjectsBudgetEntry.[Description 2],
	ProjectsBudgetEntry.[Amount],
	ProjectsBudgetEntry.[Curency],
	ProjectsBudgetEntry.[Currency Factor],
	ProjectsBudgetEntry.[Amount (LCY)],
	ProjectsBudgetEntry.[Date],
	ProjectsBudgetEntry.[Transaction Type],
	ProjectsBudgetEntry.[Create User],
	ProjectsBudgetEntry.[Create Date],
	ProjectsBudgetEntry.[Create Time],
	ProjectsBudgetEntry.[Parent Entry],
	ProjectsBudgetEntry.[Code],
	ProjectsBudgetEntry.[Contragent No_],
	ProjectsBudgetEntry.[Agreement No_],
	ProjectsBudgetEntry.[Without VAT],
	ProjectsBudgetEntry.[Including VAT],
	ProjectsBudgetEntry.[Contragent Name],
	ProjectsBudgetEntry.[External Agreement No_],
	ProjectsBudgetEntry.[Contragent Type],
	ProjectsBudgetEntry.[Close],
	ISNULL(DimensionMapping.[New Dimension Value Code], '') AS [Shortcut Dimension 1 Code],
    ISNULL(DimensionValue.[Code], '') AS [Shortcut Dimension 2 Code],
	ProjectsBudgetEntry.[Building Turn],
	ProjectsBudgetEntry.[Cost Code],
	ProjectsBudgetEntry.[New Lines],
	ProjectsBudgetEntry.[Not Run OnInsert],
	ProjectsBudgetEntry.[Work Version],
	ProjectsBudgetEntry.[Reserve],
	ProjectsBudgetEntry.[Building Turn All],
	ProjectsBudgetEntry.[Date Plan],
	ProjectsBudgetEntry.[Write Off Amount],
	ProjectsBudgetEntry.[NotVisible],
	ProjectsBudgetEntry.[Reversed],
	ProjectsBudgetEntry.[ID],
	ProjectsBudgetEntry.[Reversed Without Entry],
	ProjectsBudgetEntry.[Reversed ID],
	ProjectsBudgetEntry.[Without VAT (LCY)],
	ProjectsBudgetEntry.[Problem Pmt_ Document],
	ProjectsBudgetEntry.[Currency Rate],
	'' AS [Close Date],
	'' AS [Payment Description]
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[NCC Real Estate$Projects Budget Entry] AS ProjectsBudgetEntry
LEFT JOIN [Bonava-Test].[dbo].[Real Estate$Dimension Mapping$2944687f-9cf8-4134-a24c-e21fb70a8b1a] DimensionMapping
ON DimensionMapping.[Old Dimension Value Code] = ProjectsBudgetEntry.[Shortcut Dimension 1 Code] collate Cyrillic_General_100_CI_AS
LEFT JOIN [Bonava-Test].[dbo].[Real Estate$Dimension Value$437dbf0e-84ff-417a-965d-ed2bb9650972] DimensionValue
ON DimensionValue.[Code] = ProjectsBudgetEntry.[Shortcut Dimension 2 Code] collate Cyrillic_General_100_CI_AS
WHERE ProjectsBudgetEntry.[Close] = '0' AND ProjectsBudgetEntry.[Problem Pmt_ Document] = '0';