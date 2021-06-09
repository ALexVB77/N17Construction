INSERT INTO [Bonava-Test].[dbo].[Bonava$Inventory Posting Setup$437dbf0e-84ff-417a-965d-ed2bb9650972]
(
	[Location Code],
	[Invt_ Posting Group Code],
	[Inventory Account]
)
SELECT
	[Location Code],
	GLAccMapping.[New No_] AS [Invt_ Posting Group Code],
	GLAccMapping.[New No_] AS [Inventory Account]
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[Bonava$Inventory Posting Setup]
INNER JOIN [Bonava-Test].[dbo].[Bonava$G_L Account Mapping$2944687f-9cf8-4134-a24c-e21fb70a8b1a] GLAccMapping
ON GLAccMapping.[Old No_] = [Invt_ Posting Group Code] collate Cyrillic_General_100_CI_AS
INNER JOIN [Bonava-Test].[dbo].[Bonava$Location$2944687f-9cf8-4134-a24c-e21fb70a8b1a] Location
ON Location.[Code] = [Location Code] collate Cyrillic_General_100_CI_AS
WHERE Location.Blocked = 0;