DELETE FROM [Bonava-Test].[dbo].[Real Estate$Dimension Combination$437dbf0e-84ff-417a-965d-ed2bb9650972];

-- Dimension Combination
INSERT INTO [Bonava-Test].[dbo].[Real Estate$Dimension Combination$437dbf0e-84ff-417a-965d-ed2bb9650972]
(
	[Dimension 1 Code],
	[Dimension 2 Code],
	[Combination Restriction]
)
SELECT
	[Dimension 1 Code],
	[Dimension 2 Code],
	[Combination Restriction]
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[Dimension Combination];