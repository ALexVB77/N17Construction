USE [Bonava Objects]
GO

INSERT INTO [Bonava-Dev].[dbo].[CRONUS Россия ЗАО$Vendor Agreement Details$2944687f-9cf8-4134-a24c-e21fb70a8b1a]
(
	[Vendor No_],
	[Agreement No_],
	[Line No_],
	[Building Turn All],
	[Project Code],
	[Cost Code],
	[Global Dimension 1 Code],
	[Global Dimension 2 Code],
	[Description],
	[Cost Type],
	[Amount],
	[Agreement Description],
	[Agreement Date],
	[Agreement Amount],
	[VAT Amount],
	[Amount Without VAT],
	[Project Line No_],
	[Original Amount],
	[ByOrder],
	[Close Commitment],
	[Close Ordered],
	[AmountLCY],
	[Currency Code]
)
SELECT
	[Vendor No_],
	[Agreement No_],
	[Line No_],
	[Building Turn All],
	[Project Code],
	[Cost Code],
	[Global Dimension 1 Code],
	[Global Dimension 2 Code],
	[Description],
	[Cost Type],
	[Amount],
	[Agreement Description],
	[Agreement Date],
	[Agreement Amount],
	[VAT Amount],
	[Amount Without VAT],
	[Project Line No_],
	[Original Amount],
	[ByOrder],
	[Close Commitment],
	[Close Ordered],
	[AmountLCY],
	[Currency Code]
FROM [dbo].[test$Vendor Agreement Details];