-- Salesperson\Purchaser
INSERT INTO [Bonava-Test].[dbo].[Bonava$Salesperson_Purchaser$437dbf0e-84ff-417a-965d-ed2bb9650972] 
(
	[Code],
	[Name],
	[Global Dimension 1 Code],
	[Global Dimension 2 Code],
	[E-Mail],
	[Job Title],
	[Search E-Mail],
	[E-Mail 2]
)
SELECT
	[Code],
	[Name],
	[Global Dimension 1 Code],
	[Global Dimension 2 Code],
	[E-Mail],
	[Job Title],
	[Search E-Mail],
	[E-Mail 2]
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[Bonava$Salesperson_Purchaser];

-- Default Dimension
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