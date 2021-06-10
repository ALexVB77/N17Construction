-- Vendor Agreement Table
INSERT INTO [Bonava-Test].[dbo].[Bonava$Vendor Agreement$437dbf0e-84ff-417a-965d-ed2bb9650972]
(
	[Vendor No_],
	[No_],
	[Agreement Group],
	[Description],
	[External Agreement No_],
	[Agreement Date],
	[Active],
	[Starting Date],
	[Expire Date],
	[Phone No_],
	[Global Dimension 1 Code],
	[Global Dimension 2 Code],
	[Vendor Posting Group],
	[Currency Code],
	[Purchaser Code],
	[Blocked],
	[Gen_ Bus_ Posting Group],
	[E-Mail],
	[No_ Series],
	[VAT Bus_ Posting Group],
	[Location Code],
	[VAT Agent Prod_ Posting Group],
	[VAT Payment Source Type],
	[Tax Authority No_]
)
SELECT 
	[Vendor No_],
	[No_],
	[Agreement Group],
	[Description],
	[External Agreement No_],
	[Agreement Date],
	[Active],
	[Starting Date],
	[Expire Date],
	[Phone No_],
	[Global Dimension 1 Code],
	[Global Dimension 2 Code],
	ISNULL(GLAccMapping.[New No_], '') AS [Vendor Posting Group],
	[Currency Code],
	[Purchaser Code],
	[Blocked],
	[Gen_ Bus_ Posting Group],
	[E-Mail],
	[No_ Series],
	[VAT Bus_ Posting Group],
	[Location Code],
	[VAT Agent Prod_ Posting Group],
	[VAT Payment Source Type],
	[Tax Authority No_]
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[Bonava$Vendor Agreement]
LEFT JOIN [Bonava-Test].[dbo].[Bonava$G_L Account Mapping$2944687f-9cf8-4134-a24c-e21fb70a8b1a] GLAccMapping
ON GLAccMapping.[Old No_] = [Vendor Posting Group] collate Cyrillic_General_100_CI_AS
WHERE [Blocked] <> '2';

-- Vendor Agreement Table Extension
INSERT INTO [Bonava-Test].[dbo].[Bonava$Vendor Agreement$2944687f-9cf8-4134-a24c-e21fb70a8b1a]
(
	[Vendor No_],
	[No_],
	[Vat Agent Posting Group],
	[Agreement Amount],
	[VAT Amount],
	[Amount Without VAT],
	[WithOut],
	[Unbound Cost],
	[Check Limit Starting Date],
	[Check Limit Ending Date],
	[Check Limit Amount (LCY)],
	[Don_t Check CashFlow]
)
SELECT
	[Vendor No_],
	[No_],
	ISNULL(GLAccMapping.[New No_], '') AS [Vat Agent Posting Group],
	[Agreement Amount],
	[VAT Amount],
	[Amount Without VAT],
	[WithOut],
	[Unbound Cost],
	[Check Limit Starting Date],
	[Check Limit Ending Date],
	[Check Limit Amount (LCY)],
	[Don_t Check CashFlow]
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[Bonava$Vendor Agreement]
LEFT JOIN [Bonava-Test].[dbo].[Bonava$G_L Account Mapping$2944687f-9cf8-4134-a24c-e21fb70a8b1a] GLAccMapping
ON GLAccMapping.[Old No_] = [Vendor Posting Group] collate Cyrillic_General_100_CI_AS
WHERE [Blocked] <> '2';

-- Comment Line
INSERT INTO [Bonava-Test].[dbo].[Bonava$Comment Line$437dbf0e-84ff-417a-965d-ed2bb9650972]
(
	[Table Name],
	[No_],
	[Line No_],
	[Date],
	[Comment]
)
SELECT
	[Table Name],
	[No_],
	[Line No_],
	[Date],
	[Comment]
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[Bonava$Comment Line];

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
WHERE [Table ID] = '14901'
AND [Dimension Value Code] <> '28012-107D'
AND [Dimension Value Code] <> '28012-106D'
AND ([Dimension Code] = 'CP' OR
	 [Dimension Code] = 'CC' OR
	 [Dimension Code] = 'НП' OR
	 [Dimension Code] = 'НУ-ВИД' OR
	 [Dimension Code] = 'НУ-ОБЪЕКТ' OR
	 [Dimension Code] = 'НУ-РАЗНИЦА' OR
	 [Dimension Code] = 'ПРИБ_УБ_ПРОШ_ЛЕТ');