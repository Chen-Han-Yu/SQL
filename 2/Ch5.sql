/*Live Query Statistics*/
/*
Live Query Statistics
Include Actual Execution Plan
*/
USE 邦邦量販店
GO

SELECT A.*,B.*,C.*
FROM dbo.GMC_Profile A
LEFT JOIN dbo.GMC_TransDetail B
ON A.MemberID=B.MemberID
LEFT JOIN dbo.Product_Detail C
ON B.ProductID = C.ProductID
WHERE A.Sex = 'F'
AND A.Occupation LIKE '%人員%'
AND A.Channel LIKE '%V%'
GO

/*
Dynamic Data Masking
*/
--#1產生空白資料表
IF OBJECT_ID(N'[邦邦量販店].dbo.Customers_MaskingTest') IS NOT NULL
DROP TABLE [邦邦量販店].dbo.Customers_MaskingTest;

CREATE TABLE [邦邦量販店].dbo.Customers_MaskingTest(
    [Name] [nvarchar](5) NOT NULL, --姓名
    [NameID] [varchar](10) NOT NULL, --身分證
    [Email] [varchar](50) NOT NULL, --Email
    [MOBILE] [varchar](20) NOT NULL, --手機
    [Address] [nvarchar](50) NOT NULL, --地址
    [Salary] [money] NOT NULL, --薪資
    [CreditCard] [varchar](19) NOT NULL -- 信用卡號
)
GO

--#2匯入空白資料
INSERT INTO [邦邦量販店].dbo.Customers_MaskingTest
([Name],[NameID],[Email],[MOBILE],[Address],[Salary],[CreditCard])
VALUES
(N'中頭獎','A123456789','A01@gmail.com','0901234567',N'新北市新莊區自立街',100000000,'5520-001-1234-1234'),
(N'很有錢','A223456789','A02@gmail.com','0901234567',N'新北市三重區興德路',100000000,'5520-001-1234-1234')

SELECT * FROM [邦邦量販店].dbo.Customers_MaskingTest

--#3動態遮罩資料事先執行設定語法
DBCC TRACEON(209,219,-1)
--執行後出現
--DBCC 的執行已經完成。如果 DBCC 印出錯誤訊息，請連絡您的系統管理員。

--#4
--#4.1案例一：請針對[Name]資料行建立custom遮罩，輸出效果(結果)顯示，中間的字元以「X」取代
--#4.1.1動態資料遮罩功能設定
USE [邦邦量販店]
GO

ALTER TABLE [dbo].[Customers_MaskingTest]
ALTER COLUMN [Name]
ADD MASKED WITH (FUNCTION='PARTIAL(1,"X",1)')
GO

--#4.1.2查詢已設定的遮罩資料行
SELECT C.name,
       D.name as table_name,
       C.is_masked,
       C.masking_function
FROM sys.masked_columns AS C
JOIN sys.tables AS D
ON C.[object_id] = D.[object_id]
WHERE is_masked = 1

--#4.1.3建立新的使用者，授予資料表的SELECT權限，以便檢視遮罩資料並執行查詢
--DROP USER UserMask
CREATE USER UserMask WITHOUT LOGIN;
GRANT SELECT ON [dbo].[Customers_MaskingTest] TO UserMask;

--UserMask可以看的資料
EXECUTE AS USER = 'UserMask';
SELECT * FROM [dbo].[Customers_MaskingTest];
--恢復使用的帳號
REVERT;

--#4.2案例二：請針對[NameID]資料行建立custom遮罩，輸出效果(結果)顯示，中間的字元以「OOOOOO」取代
--#4.2.1動態資料遮罩功能設定
USE [邦邦量販店]
GO

ALTER TABLE [dbo].[Customers_MaskingTest]
ALTER COLUMN [NameID]
ADD MASKED WITH (FUNCTION='PARTIAL(2,"OOOOOO",2)')
GO

--#4.2.2查詢已設定的遮罩資料行
SELECT C.name,
       D.name as table_name,
       C.is_masked,
       C.masking_function
FROM sys.masked_columns AS C
JOIN sys.tables AS D
ON C.[object_id] = D.[object_id]
WHERE is_masked = 1

--#4.2.3建立新的使用者，授予資料表的SELECT權限，以便檢視遮罩資料並執行查詢
DROP USER UserMask
CREATE USER UserMask WITHOUT LOGIN;
GRANT SELECT ON [dbo].[Customers_MaskingTest] TO UserMask;

--UserMask可以看的資料
EXECUTE AS USER = 'UserMask';
SELECT * FROM [dbo].[Customers_MaskingTest];
--恢復使用的帳號
REVERT;

--#4.3案例三：請針對[Email]建立遮罩
--#4.3.1動態資料遮罩功能設定
USE [邦邦量販店]
GO

ALTER TABLE [dbo].[Customers_MaskingTest]
ALTER COLUMN [Email]
ADD MASKED WITH (FUNCTION='email()')
GO

--#4.3.2查詢已設定的遮罩資料行
SELECT C.name,
       D.name as table_name,
       C.is_masked,
       C.masking_function
FROM sys.masked_columns AS C
JOIN sys.tables AS D
ON C.[object_id] = D.[object_id]
WHERE is_masked = 1

--#4.3.3建立新的使用者，授予資料表的SELECT權限，以便檢視遮罩資料並執行查詢
DROP USER UserMask
CREATE USER UserMask WITHOUT LOGIN;
GRANT SELECT ON [dbo].[Customers_MaskingTest] TO UserMask;

--UserMask可以看的資料
EXECUTE AS USER = 'UserMask';
SELECT * FROM [dbo].[Customers_MaskingTest];
--恢復使用的帳號
REVERT;

--#4.4案例四：請針對[MOBILE]資料行建立custom遮罩，varchar型態，以「XXXX」來當作輸出效果(結果)取代
--#4.4.1動態資料遮罩功能設定
USE [邦邦量販店]
GO

ALTER TABLE [dbo].[Customers_MaskingTest]
ALTER COLUMN [MOBILE]
ADD MASKED WITH (FUNCTION='default()')
GO

--#4.4.2查詢已設定的遮罩資料行
SELECT C.name,
       D.name as table_name,
       C.is_masked,
       C.masking_function
FROM sys.masked_columns AS C
JOIN sys.tables AS D
ON C.[object_id] = D.[object_id]
WHERE is_masked = 1

--#4.4.3建立新的使用者，授予資料表的SELECT權限，以便檢視遮罩資料並執行查詢
DROP USER UserMask
CREATE USER UserMask WITHOUT LOGIN;
GRANT SELECT ON [dbo].[Customers_MaskingTest] TO UserMask;

--UserMask可以看的資料
EXECUTE AS USER = 'UserMask';
SELECT * FROM [dbo].[Customers_MaskingTest];
--恢復使用的帳號
REVERT;

--#4.5案例五：請針對[Address]資料行建立custom遮罩，帶出前面6個字元，其餘以「OOOOO」來當作輸出效果(結果)取代
--#4.5.1動態資料遮罩功能設定
USE [邦邦量販店]
GO

ALTER TABLE [dbo].[Customers_MaskingTest]
ALTER COLUMN [Address]
ADD MASKED WITH (FUNCTION='PARTIAL(6,"OOOOOO",0)')
GO

--#4.5.2查詢已設定的遮罩資料行
SELECT C.name,
       D.name as table_name,
       C.is_masked,
       C.masking_function
FROM sys.masked_columns AS C
JOIN sys.tables AS D
ON C.[object_id] = D.[object_id]
WHERE is_masked = 1

--#4.5.3建立新的使用者，授予資料表的SELECT權限，以便檢視遮罩資料並執行查詢
DROP USER UserMask
CREATE USER UserMask WITHOUT LOGIN;
GRANT SELECT ON [dbo].[Customers_MaskingTest] TO UserMask;

--UserMask可以看的資料
EXECUTE AS USER = 'UserMask';
SELECT * FROM [dbo].[Customers_MaskingTest];
--恢復使用的帳號
REVERT;

--#4.6案例六：請針對[Salary]資料行建立default遮罩，型態是money，0當作輸出效果(結果)取代
--#4.6.1動態資料遮罩功能設定
USE [邦邦量販店]
GO

ALTER TABLE [dbo].[Customers_MaskingTest]
ALTER COLUMN [Salary]
ADD MASKED WITH (FUNCTION='default()')
GO

--#4.6.2查詢已設定的遮罩資料行
SELECT C.name,
       D.name as table_name,
       C.is_masked,
       C.masking_function
FROM sys.masked_columns AS C
JOIN sys.tables AS D
ON C.[object_id] = D.[object_id]
WHERE is_masked = 1

--#4.6.3建立新的使用者，授予資料表的SELECT權限，以便檢視遮罩資料並執行查詢
DROP USER UserMask
CREATE USER UserMask WITHOUT LOGIN;
GRANT SELECT ON [dbo].[Customers_MaskingTest] TO UserMask;

--UserMask可以看的資料
EXECUTE AS USER = 'UserMask';
SELECT * FROM [dbo].[Customers_MaskingTest];
--恢復使用的帳號
REVERT;

--#4.7案例七：請針對[CreditCard]資料行建立以「XXXX-XXXX-XXXX-」輸出效果(結果)取代前面，只留後面四個
--#4.7.1動態資料遮罩功能設定
USE [邦邦量販店]
GO

ALTER TABLE [dbo].[Customers_MaskingTest]
ALTER COLUMN [CreditCard]
ADD MASKED WITH (FUNCTION='PARTIAL(0,"xxxx-xxxx-xxxx-",4)')
GO

--#4.7.2查詢已設定的遮罩資料行
SELECT C.name,
       D.name as table_name,
       C.is_masked,
       C.masking_function
FROM sys.masked_columns AS C
JOIN sys.tables AS D
ON C.[object_id] = D.[object_id]
WHERE is_masked = 1

--#4.7.3建立新的使用者，授予資料表的SELECT權限，以便檢視遮罩資料並執行查詢
DROP USER UserMask
CREATE USER UserMask WITHOUT LOGIN;
GRANT SELECT ON [dbo].[Customers_MaskingTest] TO UserMask;

--UserMask可以看的資料
EXECUTE AS USER = 'UserMask';
SELECT * FROM [dbo].[Customers_MaskingTest];
--恢復使用的帳號
REVERT;

--#4.7.4修正已設定的遮罩資料行
ALTER TABLE [dbo].[Customers_MaskingTest]
ALTER COLUMN [CreditCard]
ADD MASKED WITH (FUNCTION='PARTIAL(0,"xxxx-xxxx-????-",4)')
GO

--UserMask可以看的資料
EXECUTE AS USER = 'UserMask';
SELECT * FROM [dbo].[Customers_MaskingTest];
--恢復使用的帳號
REVERT;

--建立新的User可以新增檢視權限
CREATE USER UserMaskNon WITHOUT LOGIN
GO

GRANT SELECT ON [dbo].[Customers_MaskingTest] TO UserMaskNon
GO

EXECUTE AS USER = 'UserMaskNon';
SELECT * FROM [dbo].Customers_MaskingTest;
REVERT
GO

GRANT UNMASK TO UserMaskNon
GO

EXECUTE AS USER = 'UserMaskNon';
SELECT * FROM [dbo].Customers_MaskingTest;
REVERT
GO

--#4.8.1遮罩失敗的字串轉換，在2019年已可以用
EXECUTE AS USER = 'UserMask';
SELECT * FROM [dbo].[Customers_MaskingTest]
/*資料類型轉換*/
SELECT CAST([Name] AS NCHAR(10)),CAST([Salary] AS VARCHAR(MAX))
FROM [dbo].[Customers_MaskingTest]
REVERT
GO


--#5.JSON
--#5.1 JSON AUTO 函式輸出JSON格式
SELECT * FROM [邦邦量販店].dbo.GMC_Profile FOR JSON AUTO
GO
--#5.2 Root Key
SELECT *  FROM [邦邦量販店].[dbo].[GMC_Profile]
FOR JSON AUTO,ROOT('Retaildata')
GO
--#5.3 JSON PATH
SELECT [ProductID],[Productname],[Product_Combine1],[ProdQuantity_Combine1],
[Product_Combine2],[ProdQuantity_Combine2],
[Product_Combine3],[ProdQuantity_Combine3],
[Product_Combine4],[ProdQuantity_Combine4],
[Price]
FROM [邦邦量販店].dbo.Product_Detail
WHERE [Product_Combine4] IS NULL
--JSON AUTO NULL會不見
FOR JSON AUTO
GO

SELECT [ProductID],[Productname],[Product_Combine1],[ProdQuantity_Combine1],
[Product_Combine2],[ProdQuantity_Combine2],
[Product_Combine3],[ProdQuantity_Combine3],
[Product_Combine4],[ProdQuantity_Combine4],
[Price]
FROM [邦邦量販店].dbo.Product_Detail
WHERE [Product_Combine4] IS NULL
--加上JSON PATH 可以出現NULL
FOR JSON PATH, INCLUDE_NULL_VALUES
GO


