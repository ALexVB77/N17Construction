USE [Bonava Objects]
GO

INSERT INTO [Bonava-Dev].[dbo].[CRONUS Россия ЗАО$Vendor Agreement$437dbf0e-84ff-417a-965d-ed2bb9650972]
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
	[Contact],
	[Phone No_],
	[Global Dimension 1 Code],
	[Global Dimension 2 Code],
	[Vendor Posting Group],
	[Currency Code],
	[Language Code],
	[Payment Terms Code],
	[Purchaser Code],
	[Prices Including VAT],
	[Blocked],
	[Priority],
	[Payment Method Code],
	[Gen_ Bus_ Posting Group],
	[Order Address Code],
	[E-Mail],
	[No_ Series],
	[VAT Bus_ Posting Group],
	[Responsibility Center],
	[Location Code],
	[Default Bank Code],
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
	[Contact],
	[Phone No_],
	[Global Dimension 1 Code],
	[Global Dimension 2 Code],
	[Vendor Posting Group],
	[Currency Code],
	[Language Code],
	[Payment Terms Code],
	[Purchaser Code],
	[Prices Including VAT],
	[Blocked],
	[Priority],
	[Payment Method Code],
	[Gen_ Bus_ Posting Group],
	[Order Address Code],
	[E-Mail],
	[No_ Series],
	[VAT Bus_ Posting Group],
	[Responsibility Center],
	[Location Code],
	[Default Bank Code],
	[VAT Agent Prod_ Posting Group],
	[VAT Payment Source Type],
	[Tax Authority No_]
FROM [dbo].[test$Vendor Agreement];

INSERT INTO [Bonava-Dev].[dbo].[CRONUS Россия ЗАО$Comment Line$437dbf0e-84ff-417a-965d-ed2bb9650972]
(
	[Table Name],
	[No_],
	[Line No_]
)
SELECT
	[Table Name],
	[No_],
	[Line No_]
FROM [dbo].[test$Comment Line];

INSERT INTO [Bonava-Dev].[dbo].[CRONUS Россия ЗАО$Vendor Agreement$2944687f-9cf8-4134-a24c-e21fb70a8b1a]
(
	[Vendor No_],
	[No_],
	[Vat Agent Posting Group],
	[Original No_],
	[Original Company],
	[Agreement Amount],
	[Project Dimension Code],
	[VAT Amount],
	[Amount Without VAT],
	[WithOut], 
	[Unbound Cost],
	[Don_t Check CashFlow]
)
SELECT
	[Vendor No_],
	[No_],
	[Vat Agent Posting Group],
	[Original No_],
	[Original Company],
	[Agreement Amount],
	[Project Dimension Code],
	[VAT Amount],
	[Amount Without VAT],
	[WithOut],
	[Unbound Cost],
	[Don_t Check CashFlow]
FROM [dbo].[test$Vendor Agreement];

/*
INSERT INTO [Bonava-Dev].[dbo].[CRONUS Россия ЗАО$Dimension Value$437dbf0e-84ff-417a-965d-ed2bb9650972]
(
	[Dimension Code],
	[Code],
	[Name],
	[Dimension Value Type],
	[Totaling],
	[Blocked],
	[Consolidation Code],
	[Global Dimension No_],
	[Project is Finished],
	[Post Without Forecast]
)
SELECT
	[Dimension Code],
	[Code],
	[Name],
	[Dimension Value Type],
	[Totaling],
	[Blocked],
	[Consolidation Code],
	[Global Dimension No_],
	[Project is Finished],
	[Post Without Forecast]
FROM [dbo].[Dimension Value] WHERE [Dimension Code] = 'CP' AND [Project is Finished] = '0' AND [Post Without Forecast] = '0';
*/

INSERT INTO [Bonava-Dev].[dbo].[CRONUS Россия ЗАО$Default Dimension$437dbf0e-84ff-417a-965d-ed2bb9650972]
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
FROM [dbo].[test$Default Dimension] WHERE [Table ID] = '14901';