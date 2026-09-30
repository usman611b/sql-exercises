 /* =========================================================
   0. SEE ALL TABLES IN THE DATABASE
   ========================================================= */

SELECT *
FROM INFORMATION_SCHEMA.TABLES;



/* =========================================================
   1. CREATE OUR TEMPORARY SALES TABLE
   ========================================================= */

DROP TABLE IF EXISTS #temp_fact_sales;

SELECT *
INTO #temp_fact_sales
FROM dbo.FactInternetSales
WHERE ProductKey < 220;


/* Check the temporary table */

SELECT *
FROM #temp_fact_sales;



/* =========================================================
   2. DISTINCT
   ========================================================= */

/* Show unique ProductKeys */

SELECT DISTINCT ProductKey
FROM #temp_fact_sales;


/* Show unique territory keys */

SELECT DISTINCT SalesTerritoryKey
FROM #temp_fact_sales;


/* Unique Product + Territory combinations */

SELECT DISTINCT
    ProductKey,
    SalesTerritoryKey
FROM #temp_fact_sales;



/* =========================================================
   3. AGGREGATION FUNCTIONS
   COUNT, SUM, AVG, MIN, MAX
   ========================================================= */

SELECT
    COUNT(*) AS TotalRows,
    SUM(ExtendedAmount) AS TotalSalesAmount,
    AVG(ExtendedAmount) AS AverageSalesAmount,
    MIN(ExtendedAmount) AS MinimumSalesAmount,
    MAX(ExtendedAmount) AS MaximumSalesAmount
FROM #temp_fact_sales;



/* =========================================================
   4. GROUP BY
   ========================================================= */

/* Number of sales for every ProductKey */

SELECT
    ProductKey,
    COUNT(*) AS TotalSales
FROM #temp_fact_sales
GROUP BY ProductKey;


/* Total amount for every ProductKey */

SELECT
    ProductKey,
    COUNT(*) AS TotalSales,
    SUM(ExtendedAmount) AS TotalAmount,
    AVG(ExtendedAmount) AS AverageAmount
FROM #temp_fact_sales
GROUP BY ProductKey;


/* Group sales according to territory */

SELECT
    SalesTerritoryKey,
    COUNT(*) AS TotalSales,
    SUM(ExtendedAmount) AS TotalAmount
FROM #temp_fact_sales
GROUP BY SalesTerritoryKey;



/* =========================================================
   5. WHERE
   WHERE FILTERS ROWS BEFORE GROUPING
   ========================================================= */

/* Remove ProductKey 217 */

SELECT *
FROM #temp_fact_sales
WHERE ProductKey != 217;


/* Then group remaining rows */

SELECT
    SalesTerritoryKey,
    COUNT(*) AS TotalSales
FROM #temp_fact_sales
WHERE ProductKey != 217
GROUP BY SalesTerritoryKey;



/* =========================================================
   6. HAVING
   HAVING FILTERS GROUPS AFTER GROUP BY
   ========================================================= */

SELECT
    SalesTerritoryKey,
    COUNT(*) AS TotalSales
FROM #temp_fact_sales
GROUP BY SalesTerritoryKey
HAVING COUNT(*) > 1000;


/* WHERE + GROUP BY + HAVING together */

SELECT
    SalesTerritoryKey,
    COUNT(*) AS TotalSales,
    SUM(ExtendedAmount) AS TotalAmount
FROM #temp_fact_sales
WHERE ProductKey != 217
GROUP BY SalesTerritoryKey
HAVING COUNT(*) > 1000;



/* =========================================================
   7. CHECK TERRITORY TABLE
   ========================================================= */

SELECT *
FROM dbo.DimSalesTerritory;



/* =========================================================
   8. INNER JOIN
   ONLY MATCHING ROWS FROM BOTH TABLES
   ========================================================= */

SELECT
    t.ProductKey,
    t.SalesTerritoryKey,
    s.SalesTerritoryCountry,
    t.ExtendedAmount
FROM #temp_fact_sales t
INNER JOIN dbo.DimSalesTerritory s
    ON t.SalesTerritoryKey = s.SalesTerritoryKey;


/*
   JOIN = INNER JOIN

   So this is also valid:
*/

SELECT
    t.ProductKey,
    s.SalesTerritoryCountry,
    t.ExtendedAmount
FROM #temp_fact_sales t
JOIN dbo.DimSalesTerritory s
    ON t.SalesTerritoryKey = s.SalesTerritoryKey;



/* =========================================================
   9. JOIN + GROUP BY
   THIS IS CLOSE TO YOUR TEACHER'S QUERY
   ========================================================= */

SELECT
    s.SalesTerritoryCountry,
    COUNT(*) AS TotalSales,
    SUM(t.ExtendedAmount) AS TotalAmount
FROM #temp_fact_sales t
JOIN dbo.DimSalesTerritory s
    ON s.SalesTerritoryKey = t.SalesTerritoryKey
GROUP BY s.SalesTerritoryCountry;



/* =========================================================
   10. FULL TEACHER-STYLE QUERY
   JOIN + WHERE + GROUP BY + HAVING
   ========================================================= */

SELECT
    s.SalesTerritoryCountry,
    COUNT(*) AS TotalSales,
    SUM(t.ExtendedAmount) AS TotalAmount
FROM #temp_fact_sales t
JOIN dbo.DimSalesTerritory s
    ON s.SalesTerritoryKey = t.SalesTerritoryKey
WHERE t.ProductKey != 217
GROUP BY s.SalesTerritoryCountry
HAVING COUNT(*) > 1000;


/*
LOGICAL THINKING:

FROM + JOIN
     ↓
WHERE
     ↓
GROUP BY
     ↓
COUNT / SUM
     ↓
HAVING
     ↓
SELECT
*/



/* =========================================================
   11. LEFT JOIN
   KEEP EVERYTHING FROM LEFT TABLE
   ========================================================= */

SELECT
    s.SalesTerritoryKey,
    s.SalesTerritoryCountry,
    t.ProductKey,
    t.ExtendedAmount
FROM dbo.DimSalesTerritory s
LEFT JOIN #temp_fact_sales t
    ON s.SalesTerritoryKey = t.SalesTerritoryKey;


/*
This keeps ALL territories.

If a territory has no matching sale:

ProductKey     = NULL
ExtendedAmount = NULL
*/



/* =========================================================
   12. FIND TERRITORIES WITH NO SALES
   LEFT JOIN + IS NULL
   ========================================================= */

SELECT
    s.SalesTerritoryKey,
    s.SalesTerritoryCountry
FROM dbo.DimSalesTerritory s
LEFT JOIN #temp_fact_sales t
    ON s.SalesTerritoryKey = t.SalesTerritoryKey
WHERE t.SalesTerritoryKey IS NULL;



/* =========================================================
   13. RIGHT JOIN
   KEEP EVERYTHING FROM RIGHT TABLE
   ========================================================= */

SELECT
    t.ProductKey,
    s.SalesTerritoryCountry
FROM dbo.DimSalesTerritory s
RIGHT JOIN #temp_fact_sales t
    ON s.SalesTerritoryKey = t.SalesTerritoryKey;


/*
Here #temp_fact_sales is on RIGHT,
so all sales rows remain.

Usually we prefer rewriting RIGHT JOIN as LEFT JOIN.
*/



/* =========================================================
   ================== SUBQUERIES ============================
   ========================================================= */



/* =========================================================
   14. SCALAR SUBQUERY
   SALES ABOVE AVERAGE
   ========================================================= */

SELECT *
FROM #temp_fact_sales
WHERE ExtendedAmount >
(
    SELECT AVG(ExtendedAmount)
    FROM #temp_fact_sales
);


/*
Inner query:
AVG(ExtendedAmount)
→ one value

Outer query:
show rows greater than that value
*/



/* =========================================================
   15. FIND HIGHEST SALE USING SUBQUERY
   ========================================================= */

SELECT *
FROM #temp_fact_sales
WHERE ExtendedAmount =
(
    SELECT MAX(ExtendedAmount)
    FROM #temp_fact_sales
);



/* =========================================================
   16. FIND LOWEST SALE
   ========================================================= */

SELECT *
FROM #temp_fact_sales
WHERE ExtendedAmount =
(
    SELECT MIN(ExtendedAmount)
    FROM #temp_fact_sales
);



/* =========================================================
   17. FIND SMALLEST PRODUCTKEY USING SUBQUERY
   ========================================================= */

SELECT *
FROM #temp_fact_sales
WHERE ProductKey =
(
    SELECT MIN(ProductKey)
    FROM #temp_fact_sales
);



/* =========================================================
   18. MULTI-ROW SUBQUERY USING IN
   ========================================================= */

/*
Find all sales belonging to Canada or Australia.
*/

SELECT *
FROM #temp_fact_sales
WHERE SalesTerritoryKey IN
(
    SELECT SalesTerritoryKey
    FROM dbo.DimSalesTerritory
    WHERE SalesTerritoryCountry IN ('Canada', 'Australia')
);



/* =========================================================
   19. NOT IN
   EXCLUDE CANADA AND AUSTRALIA SALES
   ========================================================= */

SELECT *
FROM #temp_fact_sales
WHERE SalesTerritoryKey NOT IN
(
    SELECT SalesTerritoryKey
    FROM dbo.DimSalesTerritory
    WHERE SalesTerritoryCountry IN ('Canada', 'Australia')
);



/* =========================================================
   20. EXISTS
   SHOW TERRITORIES THAT HAVE AT LEAST ONE SALE
   ========================================================= */

SELECT *
FROM dbo.DimSalesTerritory s
WHERE EXISTS
(
    SELECT 1
    FROM #temp_fact_sales t
    WHERE t.SalesTerritoryKey = s.SalesTerritoryKey
);



/* =========================================================
   21. NOT EXISTS
   SHOW TERRITORIES HAVING NO SALES
   ========================================================= */

SELECT *
FROM dbo.DimSalesTerritory s
WHERE NOT EXISTS
(
    SELECT 1
    FROM #temp_fact_sales t
    WHERE t.SalesTerritoryKey = s.SalesTerritoryKey
);



/* =========================================================
   22. SUBQUERY INSIDE FROM
   ALSO CALLED A DERIVED TABLE
   ========================================================= */

SELECT *
FROM
(
    SELECT
        SalesTerritoryKey,
        COUNT(*) AS TotalSales,
        SUM(ExtendedAmount) AS TotalAmount
    FROM #temp_fact_sales
    GROUP BY SalesTerritoryKey
) AS TerritorySummary
WHERE TotalSales > 1000;


/*
Inner query creates:

TerritoryKey | TotalSales | TotalAmount

Outer query then filters that temporary result.
*/



/* =========================================================
   23. SUBQUERY INSIDE SELECT
   ========================================================= */

SELECT
    ProductKey,
    ExtendedAmount,

    (
        SELECT AVG(ExtendedAmount)
        FROM #temp_fact_sales
    ) AS OverallAverage

FROM #temp_fact_sales;


/*
Example:

Product    Amount    OverallAverage
210        500       600
211        800       600
212        300       600
*/



/* =========================================================
   24. SUBQUERY + CALCULATE DIFFERENCE FROM AVERAGE
   ========================================================= */

SELECT
    ProductKey,
    ExtendedAmount,

    (
        SELECT AVG(ExtendedAmount)
        FROM #temp_fact_sales
    ) AS AverageAmount,

    ExtendedAmount -
    (
        SELECT AVG(ExtendedAmount)
        FROM #temp_fact_sales
    ) AS DifferenceFromAverage

FROM #temp_fact_sales;



/* =========================================================
   ======================= CTE ==============================
   ========================================================= */



/* =========================================================
   25. BASIC CTE
   ========================================================= */

WITH ProductSummary AS
(
    SELECT
        ProductKey,
        COUNT(*) AS TotalSales,
        SUM(ExtendedAmount) AS TotalAmount
    FROM #temp_fact_sales
    GROUP BY ProductKey
)
SELECT *
FROM ProductSummary;



/* =========================================================
   26. CTE + WHERE
   ========================================================= */

WITH ProductSummary AS
(
    SELECT
        ProductKey,
        COUNT(*) AS TotalSales,
        SUM(ExtendedAmount) AS TotalAmount
    FROM #temp_fact_sales
    GROUP BY ProductKey
)
SELECT *
FROM ProductSummary
WHERE TotalSales > 500;



/* =========================================================
   27. TERRITORY CTE
   ========================================================= */

WITH TerritorySummary AS
(
    SELECT
        SalesTerritoryKey,
        COUNT(*) AS TotalSales,
        SUM(ExtendedAmount) AS TotalAmount,
        AVG(ExtendedAmount) AS AverageAmount
    FROM #temp_fact_sales
    GROUP BY SalesTerritoryKey
)
SELECT *
FROM TerritorySummary;



/* =========================================================
   28. CTE + JOIN
   ========================================================= */

WITH TerritorySummary AS
(
    SELECT
        SalesTerritoryKey,
        COUNT(*) AS TotalSales,
        SUM(ExtendedAmount) AS TotalAmount
    FROM #temp_fact_sales
    GROUP BY SalesTerritoryKey
)

SELECT
    s.SalesTerritoryCountry,
    ts.TotalSales,
    ts.TotalAmount

FROM TerritorySummary ts

JOIN dbo.DimSalesTerritory s
    ON ts.SalesTerritoryKey = s.SalesTerritoryKey;



/* =========================================================
   29. CTE WITH JOIN ALREADY INSIDE
   ========================================================= */

WITH CountrySales AS
(
    SELECT
        s.SalesTerritoryCountry,
        COUNT(*) AS TotalSales,
        SUM(t.ExtendedAmount) AS TotalAmount
    FROM #temp_fact_sales t

    JOIN dbo.DimSalesTerritory s
        ON t.SalesTerritoryKey = s.SalesTerritoryKey

    GROUP BY s.SalesTerritoryCountry
)

SELECT *
FROM CountrySales;



/* =========================================================
   30. CTE + FILTER RESULT
   ========================================================= */

WITH CountrySales AS
(
    SELECT
        s.SalesTerritoryCountry,
        COUNT(*) AS TotalSales,
        SUM(t.ExtendedAmount) AS TotalAmount
    FROM #temp_fact_sales t

    JOIN dbo.DimSalesTerritory s
        ON t.SalesTerritoryKey = s.SalesTerritoryKey

    GROUP BY s.SalesTerritoryCountry
)

SELECT *
FROM CountrySales
WHERE TotalSales > 1000;



/* =========================================================
   31. MULTIPLE CTEs
   ========================================================= */

WITH TerritorySummary AS
(
    SELECT
        SalesTerritoryKey,
        COUNT(*) AS TotalSales,
        SUM(ExtendedAmount) AS TotalAmount
    FROM #temp_fact_sales
    GROUP BY SalesTerritoryKey
),

HighSalesTerritories AS
(
    SELECT *
    FROM TerritorySummary
    WHERE TotalSales > 1000
)

SELECT
    s.SalesTerritoryCountry,
    h.TotalSales,
    h.TotalAmount

FROM HighSalesTerritories h

JOIN dbo.DimSalesTerritory s
    ON h.SalesTerritoryKey = s.SalesTerritoryKey;



/* =========================================================
   32. SAME PROBLEM:
   SUBQUERY VERSION
   ========================================================= */

SELECT *
FROM
(
    SELECT
        SalesTerritoryKey,
        COUNT(*) AS TotalSales,
        SUM(ExtendedAmount) AS TotalAmount
    FROM #temp_fact_sales
    GROUP BY SalesTerritoryKey
) AS TerritorySummary

WHERE TotalSales > 1000;



/* =========================================================
   33. SAME PROBLEM:
   CTE VERSION
   ========================================================= */

WITH TerritorySummary AS
(
    SELECT
        SalesTerritoryKey,
        COUNT(*) AS TotalSales,
        SUM(ExtendedAmount) AS TotalAmount
    FROM #temp_fact_sales
    GROUP BY SalesTerritoryKey
)

SELECT *
FROM TerritorySummary
WHERE TotalSales > 1000;


/*
Subquery:
query inside another query

CTE:
name intermediate result first
then use it
*/



/* =========================================================
   ================= RECURSIVE CTE ==========================
   ========================================================= */


/* =========================================================
   34. SIMPLE RECURSIVE CTE
   GENERATE NUMBERS 1 TO 10
   ========================================================= */

WITH Numbers AS
(
    /* ANCHOR / START */

    SELECT 1 AS Num

    UNION ALL

    /* RECURSIVE PART */

    SELECT Num + 1
    FROM Numbers
    WHERE Num < 10
)

SELECT *
FROM Numbers;


/*
START:
1

REPEAT:
Num + 1

STOP:
when Num reaches 10
*/



/* =========================================================
   35. RECURSIVE CTE: 10,20,30,40,50
   ========================================================= */

WITH Numbers AS
(
    SELECT 10 AS Num

    UNION ALL

    SELECT Num + 10
    FROM Numbers
    WHERE Num < 50
)

SELECT *
FROM Numbers;

SELECT *
FROM #temp_fact_sales
WHERE ProductKey =
(
    SELECT MAX(ProductKey)
    FROM #temp_fact_sales
);

SELECT *
FROM #temp_fact_sales
WHERE CustomerKey =
(
    SELECT MAX(CustomerKey)
    FROM #temp_fact_sales
);

SELECT MAX(CustomerKey) AS PreviousCustomer
FROM #temp_fact_sales
WHERE CustomerKey <
(
    SELECT MAX(CustomerKey)
    FROM #temp_fact_sales
);
select  CustomerKey = (select MAX(CustomerKey) from #temp_fact_sales);

with large_Cus as 
(
     select Max(CustomerKey) as lar_Cus
	 from #temp_fact_sales

)
select t.* from #temp_fact_sales t join large_Cus l on t.CustomerKey  = l.lar_Cus



