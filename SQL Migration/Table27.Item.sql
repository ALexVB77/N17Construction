/*
,getdate() --[Last DateTime Modified]
,convert(date,getdate())--[Last Date Modified]
,convert(time,getdate())--[Last Time Modified]
'1753-01-01 0:00:00.000'-- [Next Counting End Date]
,newid()--[Id]
,'00000000-0000-0000-0000-000000000000'--[Unit of Measure Id]
*/
delete from [dbo].[Bonava$Item$437dbf0e-84ff-417a-965d-ed2bb9650972]

insert into [dbo].[Bonava$Item$437dbf0e-84ff-417a-965d-ed2bb9650972]
(
      [No_]
      ,[No_ 2]
      ,[Description]
      ,[Search Description]
      ,[Description 2]
      ,[Base Unit of Measure]
      ,[Price Unit Conversion]
      ,[Type]
      ,[Inventory Posting Group]
      ,[Shelf No_]
      ,[Item Disc_ Group]
      ,[Allow Invoice Disc_]
      ,[Statistics Group]
      ,[Commission Group]
      ,[Unit Price]
      ,[Price_Profit Calculation]
      ,[Profit _]
      ,[Costing Method]
      ,[Unit Cost]
      ,[Standard Cost]
      ,[Last Direct Cost]
      ,[Indirect Cost _]
      ,[Cost is Adjusted]
      ,[Allow Online Adjustment]
      ,[Vendor No_]
      ,[Vendor Item No_]
      ,[Lead Time Calculation]
      ,[Reorder Point]
      ,[Maximum Inventory]
      ,[Reorder Quantity]
      ,[Alternative Item No_]
      ,[Unit List Price]
      ,[Duty Due _]
      ,[Duty Code]
      ,[Gross Weight]
      ,[Net Weight]
      ,[Units per Parcel]
      ,[Unit Volume]
      ,[Durability]
      ,[Freight Type]
      ,[Tariff No_]
      ,[Duty Unit Conversion]
      ,[Country_Region Purchased Code]
      ,[Budget Quantity]
      ,[Budgeted Amount]
      ,[Budget Profit]
      ,[Blocked]
      ,[Block Reason]
      ,[Last DateTime Modified]
      ,[Last Date Modified]
      ,[Last Time Modified]
      ,[Price Includes VAT]
      ,[VAT Bus_ Posting Gr_ (Price)]
      ,[Gen_ Prod_ Posting Group]
      ,[Picture]
      ,[Country_Region of Origin Code]
      ,[Automatic Ext_ Texts]
      ,[No_ Series]
      ,[Tax Group Code]
      ,[VAT Prod_ Posting Group]
      ,[Reserve]
      ,[Global Dimension 1 Code]
      ,[Global Dimension 2 Code]
      ,[Stockout Warning]
      ,[Prevent Negative Inventory]
      ,[Application Wksh_ User ID]
      ,[Assembly Policy]
      ,[GTIN]
      ,[Default Deferral Template Code]
      ,[Low-Level Code]
      ,[Lot Size]
      ,[Serial Nos_]
      ,[Last Unit Cost Calc_ Date]
      ,[Rolled-up Material Cost]
      ,[Rolled-up Capacity Cost]
      ,[Scrap _]
      ,[Inventory Value Zero]
      ,[Discrete Order Quantity]
      ,[Minimum Order Quantity]
      ,[Maximum Order Quantity]
      ,[Safety Stock Quantity]
      ,[Order Multiple]
      ,[Safety Lead Time]
      ,[Flushing Method]
      ,[Replenishment System]
      ,[Rounding Precision]
      ,[Sales Unit of Measure]
      ,[Purch_ Unit of Measure]
      ,[Time Bucket]
      ,[Reordering Policy]
      ,[Include Inventory]
      ,[Manufacturing Policy]
      ,[Rescheduling Period]
      ,[Lot Accumulation Period]
      ,[Dampener Period]
      ,[Dampener Quantity]
      ,[Overflow Level]
      ,[Manufacturer Code]
      ,[Item Category Code]
      ,[Created From Nonstock Item]
      ,[Product Group Code]
      ,[Purchasing Code]
      ,[Service Item Group]
      ,[Item Tracking Code]
      ,[Lot Nos_]
      ,[Expiration Calculation]
      ,[Warehouse Class Code]
      ,[Special Equipment Code]
      ,[Put-away Template Code]
      ,[Put-away Unit of Measure Code]
      ,[Phys Invt Counting Period Code]
      ,[Last Counting Period Update]
      ,[Use Cross-Docking]
      ,[Next Counting Start Date]
      ,[Next Counting End Date]
      ,[Id]
      ,[Unit of Measure Id]
      ,[Tax Group Id]
      ,[Sales Blocked]
      ,[Purchasing Blocked]
      ,[Item Category Id]
      ,[Over-Receipt Code]
      ,[CD Specific Tracking]
      ,[Gross Weight Mandatory]
      ,[Unit Volume Mandatory]
      ,[Routing No_]
      ,[Production BOM No_]
      ,[Single-Level Material Cost]
      ,[Single-Level Capacity Cost]
      ,[Single-Level Subcontrd_ Cost]
      ,[Single-Level Cap_ Ovhd Cost]
      ,[Single-Level Mfg_ Ovhd Cost]
      ,[Overhead Rate]
      ,[Rolled-up Subcontracted Cost]
      ,[Rolled-up Mfg_ Ovhd Cost]
      ,[Rolled-up Cap_ Overhead Cost]
      ,[Order Tracking Policy]
      ,[Critical]
      ,[Common Item No_]
)
select 
      [No_]
      ,[No_ 2]
      ,[Description]
      ,[Search Description]
      ,[Description 2]
      ,[Base Unit of Measure]
      ,[Price Unit Conversion]
      ,0 --[Type]
      ,[Inventory Posting Group]
      ,[Shelf No_]
      ,[Item Disc_ Group]
      ,[Allow Invoice Disc_]
      ,[Statistics Group]
      ,[Commission Group]
      ,[Unit Price]
      ,[Price_Profit Calculation]
      ,[Profit %]
      ,[Costing Method]
      ,[Unit Cost]
      ,[Standard Cost]
      ,[Last Direct Cost]
      ,[Indirect Cost %]
      ,[Cost is Adjusted]
      ,[Allow Online Adjustment]
      ,[Vendor No_]
      ,[Vendor Item No_]
      ,[Lead Time Calculation]
      ,[Reorder Point]
      ,[Maximum Inventory]
      ,[Reorder Quantity]
      ,[Alternative Item No_]
      ,[Unit List Price]
      ,[Duty Due %]
      ,[Duty Code]
      ,[Gross Weight]
      ,[Net Weight]
      ,[Units per Parcel]
      ,[Unit Volume]
      ,[Durability]
      ,[Freight Type]
      ,[Tariff No_]
      ,[Duty Unit Conversion]
      ,[Country_Region Purchased Code]
      ,[Budget Quantity]
      ,[Budgeted Amount]
      ,[Budget Profit]
      ,[Blocked]
      ,'' --[Block Reason]
      ,getdate() --[Last DateTime Modified]
      ,convert(date,getdate())--[Last Date Modified]
      ,convert(time,getdate())--[Last Time Modified]
      ,[Price Includes VAT]
      ,[VAT Bus_ Posting Gr_ (Price)]
      ,[Gen_ Prod_ Posting Group]
      ,'00000000-0000-0000-0000-000000000000'--[Picture]
      ,[Country_Region of Origin Code]
      ,[Automatic Ext_ Texts]
      ,[No_ Series]
      ,[Tax Group Code]
      ,[VAT Prod_ Posting Group]
      ,[Reserve]
      ,[Global Dimension 1 Code]
      ,[Global Dimension 2 Code]
      ,0 --[Stockout Warning]
      ,0 --[Prevent Negative Inventory]
      ,''--[Application Wksh_ User ID]
      ,0--[Assembly Policy]
      ,''--[GTIN]
      ,''--[Default Deferral Template Code]
      ,[Low-Level Code]
      ,[Lot Size]
      ,[Serial Nos_]
      ,[Last Unit Cost Calc_ Date]
      ,[Rolled-up Material Cost]
      ,[Rolled-up Capacity Cost]
      ,[Scrap %]
      ,[Inventory Value Zero]
      ,[Discrete Order Quantity]
      ,[Minimum Order Quantity]
      ,[Maximum Order Quantity]
      ,[Safety Stock Quantity]
      ,[Order Multiple]
      ,[Safety Lead Time]
      ,[Flushing Method]
      ,[Replenishment System]
      ,[Rounding Precision]
      ,[Sales Unit of Measure]
      ,[Purch_ Unit of Measure]
      ,'' --[Time Bucket]
      ,[Reordering Policy]
      ,[Include Inventory]
      ,[Manufacturing Policy]
      ,''--[Rescheduling Period]
      ,''--[Lot Accumulation Period]
      ,''--[Dampener Period]
      ,0--[Dampener Quantity]
      ,0--[Overflow Level]
      ,[Manufacturer Code]
      ,[Item Category Code]
      ,[Created From Nonstock Item]
      ,[Product Group Code]
      ,''--[Purchasing Code]
      ,[Service Item Group]
      ,[Item Tracking Code]
      ,[Lot Nos_]
      ,[Expiration Calculation]
      ,''--[Warehouse Class Code]
      ,[Special Equipment Code]
      ,[Put-away Template Code]
      ,[Put-away Unit of Measure Code]
      ,[Phys Invt Counting Period Code]
      ,[Last Counting Period Update]
      ,[Use Cross-Docking]
      ,'1753-01-01 0:00:00.000'--[Next Counting Start Date]
      ,'1753-01-01 0:00:00.000'-- [Next Counting End Date]
      ,newid()--[Id]
      ,'00000000-0000-0000-0000-000000000000'--[Unit of Measure Id]
      ,'00000000-0000-0000-0000-000000000000'--[Tax Group Id]
      ,0--[Sales Blocked]
      ,0--[Purchasing Blocked]
      ,'00000000-0000-0000-0000-000000000000'--[Item Category Id]
      ,''--[Over-Receipt Code]
      ,[CD Specific Tracking]
      ,[Gross Weight Mandatory]
      ,[Unit Volume Mandatory]
      ,[Routing No_]
      ,[Production BOM No_]
      ,[Single-Level Material Cost]
      ,[Single-Level Capacity Cost]
      ,[Single-Level Subcontrd_ Cost]
      ,[Single-Level Cap_ Ovhd Cost]
      ,[Single-Level Mfg_ Ovhd Cost]
      ,[Overhead Rate]
      ,[Rolled-up Subcontracted Cost]
      ,[Rolled-up Mfg_ Ovhd Cost]
      ,[Rolled-up Cap_ Overhead Cost]
      ,[Order Tracking Policy]
      ,[Critical]
      ,[Common Item No_]


FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[Bonava$Item]

delete from [dbo].[Bonava$Item$c526b3e9-b8ca-4683-81ba-fcd5f6b1472a]

insert into [dbo].[Bonava$Item$c526b3e9-b8ca-4683-81ba-fcd5f6b1472a]
(
      [No_],[Has Sales Forecast]
)
select [No_],0
 FROM [VM-PRO-SQL007\NAV].[NAV_for_Developers].[dbo].[Bonava$Item]