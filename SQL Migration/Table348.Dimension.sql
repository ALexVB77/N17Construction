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
WHERE [Code] = 'CC' OR 
	  [Code] = 'CP' OR
	  [Code] = 'НП' OR
	  [Code] = 'НУ-ВИД' OR
	  [Code] = 'НУ-ОБЪЕКТ' OR
	  [Code] = 'НУ-РАЗНИЦА' OR
	  [Code] = 'ПРИБ_УБ_ПРОШ_ЛЕТ'