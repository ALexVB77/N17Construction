--Inventory Posting Setup
INSERT INTO [Bonava-Test].[dbo].[Real Estate$Inventory Posting Setup$437dbf0e-84ff-417a-965d-ed2bb9650972]
(
	[Location Code],
	[Invt_ Posting Group Code],
	[Inventory Account],
	[Description],
    [View All Accounts on Lookup],
    [Inventory Account (Interim)],
    [Purch_ PD Gains Acc_],
    [Purch_ PD Losses Acc_],
    [WIP Account],
    [Material Variance Account],
    [Capacity Variance Account],
    [Mfg_ Overhead Variance Account],
    [Cap_ Overhead Variance Account],
    [Subcontracted Variance Account]
)
SELECT
	[Location Code],
	GLAccMapping.[New No_] AS [Invt_ Posting Group Code],
	GLAccMapping.[New No_] AS [Inventory Account],
	'' AS [Description],
	0 AS [View All Accounts on Lookup],
	'' AS [Inventory Account (Interim)],
	'' AS [Purch_ PD Gains Acc_],
	'' AS [Purch_ PD Losses Acc_],
	'' AS [WIP Account],
	'' AS [Material Variance Account],
	'' AS [Capacity Variance Account],
	'' AS [Mfg_ Overhead Variance Account],
	'' AS [Cap_ Overhead Variance Account],
	'' AS [Subcontracted Variance Account]
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[NCC Real Estate$Inventory Posting Setup]
INNER JOIN [Bonava-Test].[dbo].[Real Estate$G_L Account Mapping$2944687f-9cf8-4134-a24c-e21fb70a8b1a] GLAccMapping
ON GLAccMapping.[Old No_] = [Invt_ Posting Group Code] collate Cyrillic_General_100_CI_AS
INNER JOIN [Bonava-Test].[dbo].[Real Estate$Location$2944687f-9cf8-4134-a24c-e21fb70a8b1a] Location
ON Location.[Code] = [Location Code] collate Cyrillic_General_100_CI_AS
WHERE Location.Blocked = 0;