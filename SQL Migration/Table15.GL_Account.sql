-- G\L Account
INSERT INTO [Bonava-Test].[dbo].[Bonava$G_L Account$437dbf0e-84ff-417a-965d-ed2bb9650972]
(
	[No_],
	[Name],
	[Search Name],
	[Account Type],
	[Global Dimension 1 Code],
	[Global Dimension 2 Code],
	[Income_Balance],
	[Debit_Credit],
	[No_ 2],
	[Blocked],
	[Direct Posting],
	[Reconciliation Account],
	[New Page],
	[No_ of Blank Lines],
	[Indentation],
	[Last Date Modified],
	[Totaling],
	[Consol_ Translation Method],
	[Consol_ Debit Acc_],
	[Consol_ Credit Acc_],
	[Gen_ Posting Type],
	[Gen_ Bus_ Posting Group],
	[Gen_ Prod_ Posting Group],
	[Picture],
	[Automatic Ext_ Texts],
	[Tax Area Code],
	[Tax Liable],
	[Tax Group Code],
	[VAT Bus_ Posting Group],
	[VAT Prod_ Posting Group],
	[Exchange Rate Adjustment],
	[Default IC Partner G_L Acc_ No],
	[Source Type],
	[Currency Code],
	[Balance in Currency],
	[Adjust Debit Acc_],
	[Adjust Credit Acc_]
)
SELECT
	GLAccMapping.[New No_],
	[Name],
	[Search Name],
	[Account Type],
	[Global Dimension 1 Code],
	[Global Dimension 2 Code],
	[Income_Balance],
	[Debit_Credit],
	[No_ 2],
	[Blocked],
	[Direct Posting],
	[Reconciliation Account],
	[New Page],
	[No_ of Blank Lines],
	[Indentation],
	[Last Date Modified],
	[Totaling],
	[Consol_ Translation Method],
	[Consol_ Debit Acc_],
	[Consol_ Credit Acc_],
	[Gen_ Posting Type],
	[Gen_ Bus_ Posting Group],
	[Gen_ Prod_ Posting Group],
	[Picture],
	[Automatic Ext_ Texts],
	[Tax Area Code],
	[Tax Liable],
	[Tax Group Code],
	[VAT Bus_ Posting Group],
	[VAT Prod_ Posting Group],
	[Exchange Rate Adjustment],
	[Default IC Partner G_L Acc_ No],
	[Source Type],
	[Currency Code],
	[Balance in Currency],
	[Adjust Debit Acc_],
	[Adjust Credit Acc_]
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[Bonava$G_L Account]
INNER JOIN [Bonava-Test].[dbo].[Bonava$G_L Account Mapping$2944687f-9cf8-4134-a24c-e21fb70a8b1a] GLAccMapping
ON GLAccMapping.[Old No_] = [No_] collate Cyrillic_General_100_CI_AS;

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
	GLAccMapping.[New No_] AS [No_],
	[Dimension Code],
	[Dimension Value Code],
	[Value Posting],
	[Multi Selection Action]
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[Bonava$Default Dimension] 
INNER JOIN [Bonava-Test].[dbo].[Bonava$G_L Account Mapping$2944687f-9cf8-4134-a24c-e21fb70a8b1a] GLAccMapping
ON GLAccMapping.[Old No_] = [No_] collate Cyrillic_General_100_CI_AS
WHERE [Table ID] = '15' AND [Dimension Code] = 'CC';