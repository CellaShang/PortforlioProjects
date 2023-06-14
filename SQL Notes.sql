--Appear firstname where there is A. (% is the stakeholder sign)
SELECT FirstName
FROM Person.Person
WHERE FirstName LIKE '%A%';


--Variable
DECLARE @Counter INT = 1;
DECLARE @Product INT = 710;
WHILE @Counter <= 3
	BEGIN 
		SELECT ProductID
			,Name
			,ProductNumber
			,Color
			,ListPrice
		FROM Production.Product
		WHERE ProductID = @Product
		SET @Counter += 1
		SET @Product += 10
	END;


-- Create a pivot table version of the above results
SELECT Accessories, Bikes, Clothing, Components
FROM (SELECT ProductCategory.Name AS [Category Name]
    , Product.ProductID AS [Product IDs]
FROM Production.ProductCategory
    INNER JOIN Production.ProductSubcategory
        ON ProductCategory.ProductCategoryID = ProductSubcategory.ProductCategoryID
    INNER JOIN Production.Product
        ON ProductSubcategory.ProductSubcategoryID = Product.ProductSubcategoryID
) AS SourceData
PIVOT (COUNT([Product IDs]) FOR [Category Name] IN (Accessories, Bikes, Clothing, Components)) AS PivotTable;


--Correlated subqueries
SELECT BusinessEntityID
	,FirstName
	,LastName
	,(SELECT JobTitle
		FROM HumanResources.Employee
		WHERE BusinessEntityID = MyPerson.BusinessEntityID) AS JobTitle
FROM Person.Person AS MyPerson
WHERE EXISTS (SELECT JobTitle
		FROM HumanResources.Employee
		WHERE BusinessEntityID = MyPerson.BusinessEntityID);


--Use subquery in a HAVING Clause
SELECT SalesOrderID
	,SUM(LineTotal) AS OrderTotal
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(LineTotal) > 20000;


--Subquery/Inner query
SELECT BusinessEntityID
	,SalesYTD
	,(SELECT MAX(SalesYTD)
		FROM Sales.SalesPerson) AS HighestSalesYTD
	,(SELECT MAX(SalesYTD)
		FROM Sales.SalesPerson) - SalesYTD AS SalesGap
FROM Sales.SalesPerson
ORDER BY SalesYTD DESC;


--CASE Statament
SELECT BusinessEntityID
	,MaritalStatus
	,CASE MaritalStatus
		WHEN 'S' THEN 'Single'
		WHEN 'M' THEN 'Married'
	END AS MaritalStatusText
	,SalariedFlag	
	,CASE SalariedFlag
		WHEN 0 THEN 'Paid Hourly WAGE'
		WHEN 1 THEN 'Paid Annual Salary'
	END AS PaymentDescription
FROM HumanResources.Employee


--IIF Function
SELECT BusinessEntityID
	,SalesYTD
	,IIF(SalesYTD > 2000000, 'Met Sales Goal', 'Has not met goal') AS Status
FROM Sales.SalesPerson


--Set variable to create a list from 0.0 to 1.0 incrementing by 0.1
DECLARE @start decimal(2, 1) = 0.0;
DECLARE @stop decimal(2, 1) = 1.0;
DECLARE @increment decimal(2, 1) = 0.1;
SELECT value
FROM generate_series(@start, @stop, @increment);


--NEWID(): select random rows from data table, to ensure no selection bias
SELECT TOP 10 WorkOrderID
	,NEWID() AS NewID
FROM Production.WorkOrder
ORDER BY NewID;


--DATE_BUCKET():shows the first week/month/year of the hiredate
SELECT BusinessEntityID
	,HireDate
	,FORMAT(HireDate, 'dddd') AS HireDay
	,DATE_BUCKET(WEEK, 1, HireDate) AS WeekBucketDate
	,FORMAT(DATE_BUCKET(WEEK, 1, HireDate), 'dddd') AS WeekBucketDay
	,DATE_BUCKET(MONTH, 1,Hiredate) AS MonthBucketDate
	,DATE_BUCKET(YEAR, 1, HireDate) AS YearBucketDate
FROM HumanResources.Employee;


--Date functions
--DATEIFF calculate the days/years/months between hiredate and today¡¯s date
--DATEADD calculate the days/months/years plus the number from today¡¯s date
SELECT BusinessEntityID
	,HireDate
	,YEAR(HireDate) AS YEARS
	,MONTH(HireDate) AS MONTHS
	,DAY(HireDate) AS DAYS
	,DATEDIFF(day, HireDate, GETDATE()) AS DaysSinceHire
	,DATEDIFF(year, HireDate, GETDATE()) AS YearsSinceHire
	,DATEADD(year, 10, HireDate) AS Anniversary
FROM HumanResources.Employee;


--Round with Mathematical Functions 
SELECT BusinessEntityID
	,SalesYTD
	,ROUND(SalesYTD,3) AS Round2
	,ROUND(SalesYTD,-1) AS RoundHundreds
	,CEILING(SalesYTD) AS CEILINGS
	,FLOOR(SalesYTD) AS FLOORS
FROM Sales.SalesPerson



--String Function
SELECT FirstName
	,LastName
	,UPPER(FirstName) AS UpperCase
	,LOWER(LastName) AS LowerCase
	,LEN(FirstName) AS LengthOfFirstName
	,LEFT(LastName,3) AS FirstThreeLetters
	,RIGHT(LastName, 3) AS LastThreeLetters
FROM Person.Person
