DELETE FROM [Bonava-Test].[dbo].[Real Estate$Customer Bank Account$437dbf0e-84ff-417a-965d-ed2bb9650972];

--Customer Bank Account
INSERT INTO [Bonava-Test].[dbo].[Real Estate$Customer Bank Account$437dbf0e-84ff-417a-965d-ed2bb9650972]
(
	[Customer No_],
	[Code],
	[Name],
	[Name 2],
	[Address],
	[Address 2],
	[City],
	[Post Code],
	[Contact],
	[Phone No_],
	[Telex No_],
	[Bank Account No_],
	[Transit No_],
	[Currency Code],
	[Country_Region Code],
	[County],
	[Fax No_],
	[Telex Answer Back],
	[Language Code],
	[E-Mail],
	[Home Page],
	[IBAN],
	[SWIFT Code],
	[BIC],
	[Abbr_ City],
	[Bank Corresp_ Account No_]
)
SELECT
	[Customer No_],
	[Code],
	[Name],
	[Name 2],
	[Address],
	[Address 2],
	[City],
	[Post Code],
	[Contact],
	[Phone No_],
	[Telex No_],
	[Bank Account No_],
	[Transit No_],
	[Currency Code],
	[Country_Region Code],
	[County],
	[Fax No_],
	[Telex Answer Back],
	[Language Code],
	[E-Mail],
	[Home Page],
	[IBAN],
	[SWIFT Code],
	[BIC],
	[Abbr_ City],
	[Bank Corresp_ Account No_]
FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[NCC Real Estate$Customer Bank Account];