USE [Bonava Objects]
GO

-- Base Table
INSERT INTO [Bonava-Dev].[dbo].[CRONUS Россия ЗАО$Bin$437dbf0e-84ff-417a-965d-ed2bb9650972]
(
	 [Location Code]
      ,[Code]
      ,[Description]
      ,[Zone Code]
      ,[Bin Type Code]
      ,[Warehouse Class Code]
      ,[Block Movement]
      ,[Special Equipment Code]
      ,[Bin Ranking]
      ,[Maximum Cubage]
      ,[Maximum Weight]
      ,[Empty]
      ,[Cross-Dock Bin]
      ,[Dedicated]
)
SELECT
	 [Location Code]
      ,[Code]
      ,NULL --[Description]
      ,NULL --[Zone Code]
      ,NULL --[Bin Type Code]
      ,NULL --[Warehouse Class Code]
      ,NULL --[Block Movement]
      ,NULL --[Special Equipment Code]
      ,NULL --[Bin Ranking]
      ,NULL --[Maximum Cubage]
      ,NULL --[Maximum Weight]
      ,NULL --[Empty]
      ,NULL --[Cross-Dock Bin]
      ,NULL --[Dedicated]
FROM [dbo].[test$Bin];

-- Table Extension
INSERT INTO [Bonava-Dev].[dbo].[CRONUS Россия ЗАО$Bin$2944687f-9cf8-4134-a24c-e21fb70a8b1a]
           ([Location Code]
           ,[Code]
           ,[Givened Manuf_])
SELECT 
       [Location Code]
      ,[Code]
      ,[Givened Manuf_]
FROM [dbo].[test$Bin]