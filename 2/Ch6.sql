/*TOP的使用*/
SELECT TOP 100 [MemberID],[Occupation],[Location],[Start_date]
FROM [邦邦量販店].[dbo].[GMC_Profile]
ORDER BY [Start_date]
GO
/*
TABLESAMPLE使用
在某些情況下需要撈取一定數量的資料筆數，來做取樣資料集
*/
--取樣1000筆
SELECT * 
FROM [邦邦量販店].[dbo].[GMC_Profile]
TABLESAMPLE(1000ROWS)
ORDER BY [Start_date]
GO
--使用百分比
--取樣1000筆
SELECT * 
FROM [邦邦量販店].[dbo].[GMC_Profile]
TABLESAMPLE(10 PERCENT)
ORDER BY [Start_date]
GO
/*時間函數*/
--比較不同的時間差異
SELECT SYSDATETIME() [現在時間],
       SYSUTCDATETIME() [現在國際標準時間],
       SYSDATETIMEOFFSET() [現在時間與時區]
GO
--計算不同時區的現在時間
SELECT SWITCHOFFSET(SYSDATETIMEOFFSET(), '-07:00') [加州當地時間],
       SWITCHOFFSET(SYSDATETIMEOFFSET(), '+08:00') [台灣當地時間]
GO
--作業系統中時間差異
SELECT CURRENT_TIMESTAMP [目前日期和時間],
       GETDATE() [目前日期和時間],
       GETUTCDATE() [國際標準日期和時間]
GO
--時間區間調整
SELECT DATEADD(DD,12,'2025-01-01') [增加12天數],
       DATEADD(MM,12,'2025-01-01') [增加12個月],
       DATEADD(YY,12,'2025-01-01') [增加12個年]
GO
--時間差
/*
月跟年的會是以月和年的角度取整數，不會把天考慮
*/
SELECT DATEDIFF(DAY,'2024-12-01','2025-01-01') [兩個日期天數差],
       DATEDIFF(MONTH,'2024-12-31','2025-01-01') [兩個日期月數差],
       DATEDIFF(YEAR,'2024-12-01','2025-01-01') [兩個日期年數差]
GO
--回傳設定或參數
SELECT DATEPART(DW,'2025-01-01')[星期幾_數字],
       --星期日數字=1開始，星期六數字=7結束
       DATENAME(DW,'2025-01-01')[星期幾_文字],
       YEAR('2025-01-01')[年],
       MONTH('2025-01-01')[月],
       DAY('2025-01-01')[日]
GO
/*
轉換函數CONVERT/CAST
*/
--時間轉換
SELECT CONVERT(VARCHAR(12), GETDATE(),100)
GO
SELECT CONVERT(VARCHAR(12), GETDATE(),101)
GO
SELECT CONVERT(VARCHAR(12), GETDATE(),102)
GO
SELECT CONVERT(VARCHAR(12), GETDATE(),103)
GO
SELECT CONVERT(VARCHAR(12), GETDATE(),104)
GO
SELECT CONVERT(VARCHAR(12), GETDATE(),105)
GO
SELECT CONVERT(VARCHAR(12), GETDATE(),106)
GO
SELECT CONVERT(VARCHAR(12), GETDATE(),107)
GO
SELECT CONVERT(VARCHAR(12), GETDATE(),108)
GO
SELECT CONVERT(VARCHAR(12), GETDATE(),109)
GO
SELECT CONVERT(VARCHAR(12), GETDATE(),110)
GO
SELECT CONVERT(VARCHAR(12), GETDATE(),111)
GO
SELECT CONVERT(VARCHAR(12), GETDATE(),112)
GO
SELECT CONVERT(VARCHAR(12), GETDATE(),113)
GO
SELECT CONVERT(VARCHAR(12), GETDATE(),114)
GO
SELECT CONVERT(VARCHAR(12), GETDATE(),121)
GO
--CAST截字
SELECT [MemberID],
       CAST([MemberID] AS CHAR(5)) [MemberID_CHAR(5)_TYPE], --截斷
       CAST([MemberID] AS VARBINARY(MAX)) [MemberID_VARBINARY(MAX)_TYPE]
FROM [邦邦量販店].[dbo].[GMC_Profile]

/*
排序
*/
--ROW_NUBMER
--順序排序同樣的金額會按順序排，但排序不會相同
SELECT [MemberID],
       [TTL_Price],
       ROW_NUMBER() OVER (ORDER BY [TTL_Price]) AS TTL_Price_Rank
FROM ( SELECT [MemberID],
             SUM([Money]) [TTL_Price] --所花的錢
       FROM [邦邦量販店].[dbo].[GMC_TransDetail]
       GROUP BY [MemberID]) AA
ORDER BY 3
GO
--RANK
--順序排序同樣的金額會同個排序，下個級距的會跳過相同的排序
SELECT [MemberID],
       [TTL_Price],
       RANK() OVER (ORDER BY [TTL_Price]) AS TTL_Price_Rank
FROM ( SELECT [MemberID],
              SUM([Money]) [TTL_Price] --所花的錢
       FROM [邦邦量販店].[dbo].[GMC_TransDetail]
       GROUP BY [MemberID]) AA
ORDER BY 3
GO
--DENSE_RANK
--順序排序同樣的金額會同個排序，下個級距的會跳過相同的排序
SELECT [MemberID],
       [TTL_Price],
       DENSE_RANK() OVER (ORDER BY [TTL_Price]) AS TTL_Price_Rank
FROM ( SELECT [MemberID],
              SUM([Money]) [TTL_Price] --所花的錢
       FROM [邦邦量販店].[dbo].[GMC_TransDetail]
       GROUP BY [MemberID]) AA
ORDER BY 3
GO
--NTILE
--順序排序同樣的金額會同個排序，下個級距的會跳過相同的排序
SELECT [MemberID],
       [TTL_Price],
       NTILE(5) OVER (ORDER BY [TTL_Price]) AS TTL_Price_Rank
FROM ( SELECT [MemberID],
              SUM([Money]) [TTL_Price] --所花的錢
       FROM [邦邦量販店].[dbo].[GMC_TransDetail]
       GROUP BY [MemberID]) AA
WHERE TTL_Price >=150000
ORDER BY 3
GO
--一次比較排序
SELECT [TTL_Price],
       ROW_NUMBER() OVER (ORDER BY [TTL_Price]) AS TTL_Price_ROW_NUMBER,
       RANK() OVER (ORDER BY [TTL_Price]) AS TTL_Price_Rank,
       DENSE_RANK() OVER (ORDER BY [TTL_Price]) AS TTL_Price_DENSE_RANK,
       NTILE(5) OVER (ORDER BY [TTL_Price]) AS TTL_Price_NTITLE
FROM (
       SELECT [MemberID],
              SUM([Money]) [TTL_Price]
       FROM [邦邦量販店].[dbo].[GMC_TransDetail]
       GROUP BY [MemberID]) AA
WHERE TTL_Price BETWEEN 60000 AND 80000
ORDER BY 1

--排序函數加上PARTITION BY
SELECT [MemberID],
       [Productname],
       ROW_NUMBER() OVER (PARTITION BY [MemberID] ORDER BY [Productname]) AS Product_Seq,
       [TTL_Price]
FROM ( SELECT [MemberID],
              [Productname],
              SUM([Money]) [TTL_Price]
       FROM [邦邦量販店].[dbo].[GMC_TransDetail]
       GROUP BY [MemberID],[Productname])AA
ORDER BY 1,3
GO
SELECT [MemberID],
       [Productname],
       RANK() OVER (PARTITION BY [MemberID] ORDER BY [Productname]) AS Product_Seq,
       [TTL_Price]
FROM ( SELECT [MemberID],
              [Productname],
              SUM([Money]) [TTL_Price]
       FROM [邦邦量販店].[dbo].[GMC_TransDetail]
       GROUP BY [MemberID],[Productname])AA
ORDER BY 1,3
GO
SELECT [MemberID],
       [Productname],
       DENSE_RANK() OVER (PARTITION BY [MemberID] ORDER BY [Productname]) AS Product_Seq,
       [TTL_Price]
FROM ( SELECT [MemberID],
              [Productname],
              SUM([Money]) [TTL_Price]
       FROM [邦邦量販店].[dbo].[GMC_TransDetail]
       GROUP BY [MemberID],[Productname])AA
ORDER BY 1,3
GO
SELECT [MemberID],
       [Productname],
       NTILE(5) OVER (PARTITION BY [MemberID] ORDER BY [Productname]) AS Product_Seq,
       [TTL_Price]
FROM ( SELECT [MemberID],
              [Productname],
              SUM([Money]) [TTL_Price]
       FROM [邦邦量販店].[dbo].[GMC_TransDetail]
       GROUP BY [MemberID],[Productname])AA
ORDER BY 1,3
GO
--彙總後篩選條件
USE [邦邦量販店]
GO
SELECT [Productname],
       COUNT([TransactionID]) [訂單數量],
       SUM([Money]) [訂單總額],
       AVG([Money]) [平均單筆金額訂單],
       MAX([Money]) [最大單筆訂單金額],
       MIN([Money]) [最小單筆訂單金額]
FROM [dbo].[GMC_TransDetail]
GROUP BY [Productname]
HAVING COUNT(TransactionID) >= 10000
GO
