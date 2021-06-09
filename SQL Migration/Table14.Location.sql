-- Base Table
INSERT INTO [Bonava-Test].[dbo].[Bonava$Location$437dbf0e-84ff-417a-965d-ed2bb9650972]
(
	[Code],
    [Name],
	[Name 2],
	[Use As In-Transit],
	[Bin Mandatory],
	[Default Bin Selection],
	[Last Goods Report Date]
)
SELECT
	[Code],
    [Name],
	[Name 2],
	[Use As In-Transit],
	[Bin Mandatory],
	[Default Bin Selection],
	[Last Goods Report Date]
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[Bonava$Location];

-- Table Extension
INSERT INTO [Bonava-Test].[dbo].[Bonava$Location$2944687f-9cf8-4134-a24c-e21fb70a8b1a]
(
	[Code],
	[Blocked],
	[Def_ Gen_ Bus_ Posting Group]
)
SELECT 
	[Code],
	[Blocked],
	[Def_ Gen_ Bus_ Posting Group]
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[Bonava$Location];