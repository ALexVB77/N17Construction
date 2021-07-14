-- Dimension Value
-- Base Table
DELETE FROM [Bonava-Test].[dbo].[Real Estate$Dimension Value$437dbf0e-84ff-417a-965d-ed2bb9650972]
WHERE [Dimension Code] = 'ИНЖСЕТЬ';

INSERT INTO [Bonava-Test].[dbo].[Real Estate$Dimension Value$437dbf0e-84ff-417a-965d-ed2bb9650972]
(
	[Dimension Code],
	[Code],
	[Name],
	[Dimension Value Type],
	[Totaling],
	[Blocked],
	[Consolidation Code],
	[Indentation],
	[Global Dimension No_],
	[Map-to IC Dimension Code],
	[Map-to IC Dimension Value Code],
	[Name 2]
)
SELECT
	[Dimension Code],
	[Code],
	[Name],
	[Dimension Value Type],
	[Totaling],
	[Blocked],
	[Consolidation Code],
	[Indentation],
	[Global Dimension No_],
	[Map-to IC Dimension Code],
	[Map-to IC Dimension Value Code],
	[Name 2]
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[Dimension Value]
WHERE [Dimension Code] = 'ИНЖСЕТЬ';

-- Table Extension
DELETE FROM [Bonava-Test].[dbo].[Real Estate$Dimension Value$2944687f-9cf8-4134-a24c-e21fb70a8b1a]
WHERE [Dimension Code] = 'ИНЖСЕТЬ';

INSERT INTO [Bonava-Test].[dbo].[Real Estate$Dimension Value$2944687f-9cf8-4134-a24c-e21fb70a8b1a]
(
	[Dimension Code],
	[Code],
	[Check CF Forecast],
	[Cost Holder]
)
SELECT
	[Dimension Code],
	[Code],
	[Check CF Forecast],
	[Cost Holder]
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[Dimension Value]
WHERE [Dimension Code] = 'ИНЖСЕТЬ';