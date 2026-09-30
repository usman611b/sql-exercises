select * from INFORMATION_SCHEMA.TABLES
 
 drop table #temp_fact_sales;
 Select * from #temp_fact_sales
 Select * from DimSalesTerritory
 select * into #temp_fact_sales from dbo.FactInternetSales where ProductKey < 220
 
 ---Distinct , Group by concepts in details , Joins  ,  Aggregations 
 select s.SalesTerritoryCountry,count(*)[count], sum(extendedAmount) [sum] from #temp_fact_sales t
 join DimSalesTerritory s ON s.SalesTerritoryKey = t.SalesTerritoryKey
 group by s.SalesTerritoryCountry 
 having count(*) > 1000

 select s.SalesTerritoryCountry,count(*)[count], sum(extendedAmount) [sum] from #temp_fact_sales t
 join DimSalesTerritory s ON s.SalesTerritoryKey = t.SalesTerritoryKey
 --where ProductKey != 217 ---where usage in case if we use  (it use as a filter )
 group by s.SalesTerritoryCountry 
 having count(*) > 1000

 --Differnce btw where and having

 select * from #temp_fact_sales
 
 select distinct  ProductKey from #temp_fact_sales

 SELECT 
    COUNT(*) AS TotalRows,
    SUM(ExtendedAmount) AS TotalSales,
    AVG(ExtendedAmount) AS AverageSales
FROM #temp_fact_sales;

SELECT
    SalesTerritoryKey,
    COUNT(*) AS TotalSales
FROM #temp_fact_sales
GROUP BY SalesTerritoryKey;

SELECT
    SalesTerritoryKey,
    COUNT(*) AS TotalSales
FROM #temp_fact_sales
WHERE ProductKey != 217
GROUP BY SalesTerritoryKey;

SELECT
    SalesTerritoryKey,
    COUNT(*) AS TotalSales
FROM #temp_fact_sales
GROUP BY SalesTerritoryKey
HAVING COUNT(*) > 500;



With Total_sale_CTE as (
SELECT
    s.SalesTerritoryCountry,
    COUNT(*) AS TotalSales, 
	Sum(extendedAmount)  As Totalsaleamount
FROM #temp_fact_sales t
JOIN DimSalesTerritory s
    ON t.SalesTerritoryKey = s.SalesTerritoryKey
GROUP BY s.SalesTerritoryCountry)
select Max(Totalsaleamount) from Total_sale_CTE as second_high where Totalsaleamount <(select Max(Totalsaleamount) from Total_sale_CTE );



create procedure nth_salary 
		@SalesRank int
as 
begin

WITH Total_sale_CTE AS (
    SELECT
        s.SalesTerritoryCountry, 
        SUM(extendedAmount) AS Totalsaleamount
    FROM #temp_fact_sales t
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

exec nth_salary @SalesRank = 1;











(select 


SELECT
    s.SalesTerritoryCountry,
    t.ProductKey
FROM DimSalesTerritory s
LEFT JOIN #temp_fact_sales t
    ON s.SalesTerritoryKey = t.SalesTerritoryKey;

SELECT
    s.SalesTerritoryCountry,
    t.ProductKey
FROM DimSalesTerritory s
RIGHT JOIN #temp_fact_sales t
    ON s.SalesTerritoryKey = t.SalesTerritoryKey;


 select * from DimSalesTerritory
 select * from #temp_fact_sales

 Select SalesTerritoryKey 

