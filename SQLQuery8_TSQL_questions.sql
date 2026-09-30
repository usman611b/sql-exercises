select * from DimSalesTerritory
select * from FactInternetSales

create procedure nth_salarys 
		@SalesRank int
as 
begin

WITH Total_sale_CTE AS (
    SELECT
        s.SalesTerritoryCountry, 
        SUM(extendedAmount) AS Totalsaleamount
    FROM FactInternetSales t
    JOIN DimSalesTerritory s ON t.SalesTerritoryKey = s.SalesTerritoryKey
    GROUP BY s.SalesTerritoryCountry
),
Ranked_Sales AS (
    SELECT 
        SalesTerritoryCountry, 
        Totalsaleamount, 
        DENSE_RANK() OVER (ORDER BY Totalsaleamount DESC) AS SalesRank 
    FROM Total_sale_CTE
) 
SELECT SalesTerritoryCountry, Totalsaleamount 
FROM Ranked_Sales 
WHERE SalesRank = @SalesRank;  
end

exec nth_salarys @SalesRank = 5;


create or alter view vwSalesTerritorySummary 
as
with sale_Amount_CTE as (
select dim.SalesTerritoryRegion , sum(ExtendedAmount) as TotalSale from DimSalesTerritory dim
join  FactInternetSales ft on dim.SalesTerritoryKey = ft.SalesTerritoryKey
group by dim.SalesTerritoryRegion
),
Total_sale_cte as (
select SalesTerritoryRegion , TotalSale , sum(TotalSale) over() as TotalAmount  from sale_Amount_CTE 
),
Percentage_each_cte as (
select SalesTerritoryRegion , TotalSale , TotalAmount , TotalSale*100.0/TotalAmount as Percentage_value from Total_sale_cte
)
select
0 as sortorder,
'Result' as SalesTerritoryRegion,
cast(0 as varchar(20)) as  TotalSale, 
'' as Millions,
'' as Percentages,
'' as Statuss,
'' as Descriptions

union all

select 1,
SalesTerritoryRegion,
concat(cast(TotalSale as decimal(18,3) ) , 'US-Dollar'),
concat(cast(TotalSale / 1000000.0 as decimal(18,3) ) , 'M'),
concat(cast(Percentage_value as decimal(10,2)),'%'),

case 
when Percentage_value > 10 then 'HIGH ' else 'LOW ' end,
concat( SalesTerritoryRegion , ' Sale is ' , case when Percentage_value > 10 then ' HIGH ' else ' LOW ' end )
from Percentage_each_cte

union all

select 2 ,
'Grand Total ',
CONCAT(CAST(MAX(TotalAmount) AS DECIMAL(18,3)),' US-Dollar'),
concat(cast(SUM(TotalSale) / 1000000.0 as decimal(18,3))  , 'M'),
concat(cast(sum(Percentage_value) as decimal(10,2)),'%'),
'',
''
 from Percentage_each_cte;

 SELECT
    SalesTerritoryRegion,
    TotalSale,
    Millions,
    Percentages,
    Statuss,
    Descriptions
FROM dbo.vwSalesTerritorySummary
ORDER BY SortOrder, SalesTerritoryRegion;

create procedure SpSalesTerritoryHierarchySummary
as 
begin

With North_American_CTE as (
select
dim.salesTerritoryGroup ,'' AS SalesTerritoryRegion , sum(ExtendedAmount) as TotalSale from DimSalesTerritory dim
join  FactInternetSales ft on dim.SalesTerritoryKey = ft.SalesTerritoryKey where salesTerritoryGroup = 'North America'
group by dim.salesTerritoryGroup
),
North_America_Regions_CTE as (
select '' as salesTerritoryGroup ,dim.SalesTerritoryRegion , sum(ExtendedAmount) as TotalSale from DimSalesTerritory dim
join  FactInternetSales ft on dim.SalesTerritoryKey = ft.SalesTerritoryKey where salesTerritoryGroup = 'North America'
group by dim.salesTerritoryGroup, dim.SalesTerritoryRegion
),
Europe_CTE as (
select dim.salesTerritoryGroup ,'' AS SalesTerritoryRegion, sum(ExtendedAmount) as TotalSale from DimSalesTerritory dim
join  FactInternetSales ft on dim.SalesTerritoryKey = ft.SalesTerritoryKey where salesTerritoryGroup = 'Europe'
group by dim.salesTerritoryGroup
),
Europe_Regions_CTE as (
select '' as salesTerritoryGroup ,dim.SalesTerritoryRegion , sum(ExtendedAmount) as TotalSale from DimSalesTerritory dim
join  FactInternetSales ft on dim.SalesTerritoryKey = ft.SalesTerritoryKey where salesTerritoryGroup = 'Europe'
group by dim.salesTerritoryGroup, dim.SalesTerritoryRegion
),
Pacific_CTE as (
select dim.salesTerritoryGroup ,'' AS SalesTerritoryRegion, sum(ExtendedAmount) as TotalSale from DimSalesTerritory dim
join  FactInternetSales ft on dim.SalesTerritoryKey = ft.SalesTerritoryKey where salesTerritoryGroup = 'Pacific'
group by dim.salesTerritoryGroup
),
Pacific_Regions_CTE as (
select '' as salesTerritoryGroup , dim.SalesTerritoryRegion , sum(ExtendedAmount) as TotalSale from DimSalesTerritory dim
join  FactInternetSales ft on dim.SalesTerritoryKey = ft.SalesTerritoryKey where salesTerritoryGroup = 'Pacific'
group by dim.salesTerritoryGroup, dim.SalesTerritoryRegion
)

SELECT * FROM North_American_CTE
UNION ALL
SELECT * FROM  North_America_Regions_CTE
UNION ALL
SELECT * FROM Europe_CTE
UNION ALL
SELECT * FROM Europe_Regions_CTE
UNION ALL
SELECT * FROM Pacific_CTE
UNION ALL
SELECT * FROM Pacific_Regions_CTE

end

exec SpSalesTerritoryHierarchySummary


SELECT  DueDateKey, * FROM    FactInternetSales WHERE    LEFT(DueDateKey, 6) = '200507' AND SalesTerritoryKey = 1 

SELECT l.DueDateKey, * FROM    FactInternetSales l left join   FactInternetSales r on l.DueDateKey = r.DueDateKey 
WHERE    LEFT(l.DueDateKey, 6) = '200507' AND l.SalesTerritoryKey = 1 





















