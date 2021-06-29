-- Salesperson\Purchaser
INSERT INTO [Bonava-Test].[dbo].[Real Estate$Salesperson_Purchaser$437dbf0e-84ff-417a-965d-ed2bb9650972] 
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
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[NCC Real Estate$Salesperson_Purchaser];