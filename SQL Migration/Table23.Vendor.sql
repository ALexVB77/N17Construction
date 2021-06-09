-- Base Table
INSERT INTO [Bonava-Test].[dbo].[Bonava$Vendor$437dbf0e-84ff-417a-965d-ed2bb9650972]
(
	 [No_],
     [Name],
     [Search Name],
     [Name 2],
     [Address],
	 [Address 2],
     [City],
     [Phone No_],
     --[Vendor Posting Group],
     [Currency Code],
	 [Purchaser Code],
	 [Invoice Disc_ Code],
	 [Blocked],
	 [Last Date Modified],
	 --[VAT Registration No_],
	 [Gen_ Bus_ Posting Group],
	 [Post Code],
	 [E-Mail],
	 [No_ Series],
	 [VAT Bus_ Posting Group],
	 [Location Code],
	 [OKPO Code],
	 [Customer No_],
	 [Employee No_],
	 [Full Name],
	 [VAT Agent],
	 --[VAT Agent Prod_ Posting Group],
	 [VAT Agent Type],
	 [Tax Authority No_],
	 [Vendor Type],
	 [KPP Code],
	 [Agreement Posting],
	 [Agreement Nos_]	
)
SELECT
	 [No_],
     [Name],
     [Search Name],
     [Name 2],
     [Address],
	 [Address 2],
     [City],
     [Phone No_],
     --[Vendor Posting Group],
     [Currency Code],
	 [Purchaser Code],
	 [Invoice Disc_ Code],
	 [Blocked],
	 [Last Date Modified],
	 --[VAT Registration No_],
	 [Gen_ Bus_ Posting Group],
	 [Post Code],
	 [E-Mail],
	 [No_ Series],
	 [VAT Bus_ Posting Group],
	 [Location Code],
	 [OKPO Code],
	 [Customer No_],
	 [Employee No_],
	 [Full Name],
	 [VAT Agent],
	 --[VAT Agent Prod_ Posting Group],
	 [VAT Agent Type],
	 [Tax Authority No_],
	 [Vendor Type],
	 [KPP Code],
	 [Agreement Posting],
	 [Agreement Nos_]
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[Bonava$Vendor]
WHERE [Blocked] <> '2';

-- Table Extension
INSERT INTO [Bonava-Test].[dbo].[Bonava$Vendor$2944687f-9cf8-4134-a24c-e21fb70a8b1a]
(
	[No_],
    --[Vat Agent Posting Group],
    [Giv_ Manuf_ Location Code],
    [Giv_ Manuf_ Bin Code]
)
SELECT 
	[No_],
	--[Vat Agent Posting Group],
    [Giv_ Manuf_ Location Code],
    [Giv_ Manuf_ Bin Code]
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[Bonava$Vendor]
WHERE [Blocked] <> '2';