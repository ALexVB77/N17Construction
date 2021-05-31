USE [Bonava Objects]
GO

INSERT INTO [Bonava-Dev].[dbo].[Bonava$Dimension$437dbf0e-84ff-417a-965d-ed2bb9650972]
(
	[Code],
	[Name],
	[Code Caption],
	[Filter Caption],
	[Description],
	[Blocked],
	[Consolidation Code],
	[Map-to IC Dimension Code]
)
SELECT
	[Name],
	[Code Caption],
	[Filter Caption],
	[Description],
	[Blocked],
	[Consolidation Code],
	[Map-to IC Dimension Code]
FROM [dbo].[Dimension]
WHERE [Code] = 'яп' OR 
	  [Code] = 'яя' OR
	  [Code] = 'мо' OR
	  [Code] = 'мс-бхд' OR
	  [Code] = 'мс-наейр' OR
	  [Code] = 'мс-пюгмхжю' OR
	  [Code] = 'опха_са_опнь_кер'