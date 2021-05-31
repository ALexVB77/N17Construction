USE [Bonava Objects]
GO

INSERT INTO [Bonava-Dev].[dbo].[Bonava$G_L Account$437dbf0e-84ff-417a-965d-ed2bb9650972]
(
	[No_],
	[Name],
	[Account Type],
	[Global Dimension 1 Code],
	[Global Dimension 2 Code],
	[Account Category],
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
FROM [dbo].[test$G_L Account]
INNER JOIN [Bonava-Dev].[dbo].[Bonava$G_L Account Mapping$2944687f-9cf8-4134-a24c-e21fb70a8b1a] GLAccMapping
ON GLAccMapping.[Old No_] = [No_];