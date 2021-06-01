USE [Bonava Objects]
GO

INSERT INTO [Bonava-Dev].[dbo].[Bonava$Inventory Posting Setup$437dbf0e-84ff-417a-965d-ed2bb9650972]
(
	[Location Code],
	[Invt_ Posting Group Code],
	[Inventory Account]
)
SELECT
	[Location Code],
	(SELECT GLAccMapping.[New No_]
	 FROM [dbo].[test$Inventory Posting Setup]
	 INNER JOIN [Bonava-Dev].[dbo].[Bonava$G_L Account Mapping$2944687f-9cf8-4134-a24c-e21fb70a8b1a] GLAccMapping
	 ON GLAccMapping.[Old No_] = [Invt_ Posting Group Code]),
	(SELECT GLAccMapping.[New No_]
	 FROM [dbo].[test$Inventory Posting Setup]
	 INNER JOIN [Bonava-Dev].[dbo].[Bonava$G_L Account Mapping$2944687f-9cf8-4134-a24c-e21fb70a8b1a] GLAccMapping
	 ON GLAccMapping.[Old No_] = [Inventory Account])
FROM [dbo].[test$Inventory Posting Setup]
INNER JOIN [Bonava-Dev].[dbo].[Bonava$Location$2944687f-9cf8-4134-a24c-e21fb70a8b1a] Location
ON Location.[Code] = [Location Code]
WHERE Location.Blocked = 0;