/*Pivot*/
SELECT 
    Channel [會員來源管道人數],
    [2000], [2001], [2002], [2003],
    [2004], [2005], [2006], [2007]
FROM (
    SELECT 
        Channel,
        MemberID,
        DATEPART(YEAR, Start_date) AS [YEAR]
    FROM [邦邦量販店].[dbo].[GMC_Profile]
) AS SourceTable
PIVOT (
    COUNT(MemberID)
    FOR [YEAR] IN ([2000], [2001], [2002], [2003], [2004], [2005], [2006], [2007])
) AS PivotTable;

SELECT Channel [會員來源管道人數],
       COUNT(CASE WHEN DATEPART(YEAR,[Start_date])=2000
        THEN [MemberID] ELSE NULL END) [2000],
       COUNT(CASE WHEN DATEPART(YEAR,[Start_date])=2001
        THEN [MemberID] ELSE NULL END) [2001],        
       COUNT(CASE WHEN DATEPART(YEAR,[Start_date])=2002
        THEN [MemberID] ELSE NULL END) [2002],
       COUNT(CASE WHEN DATEPART(YEAR,[Start_date])=2003
        THEN [MemberID] ELSE NULL END) [2003],
       COUNT(CASE WHEN DATEPART(YEAR,[Start_date])=2004
        THEN [MemberID] ELSE NULL END) [2004],        
       COUNT(CASE WHEN DATEPART(YEAR,[Start_date])=2005
        THEN [MemberID] ELSE NULL END) [2005],
       COUNT(CASE WHEN DATEPART(YEAR,[Start_date])=2006
        THEN [MemberID] ELSE NULL END) [2006],
       COUNT(CASE WHEN DATEPART(YEAR,[Start_date])=2007
        THEN [MemberID] ELSE NULL END) [2007]      
FROM [邦邦量販店].[dbo].[GMC_Profile]
GROUP BY Channel
ORDER BY 1
/*Unpiovt*/
USE [邦邦量販店]
GO
CREATE TABLE [dbo].[UNPIVOT_SQL]
(
  ID INT, --編號,
  ITEM_NAME NVARCHAR(20), --名稱
  DATE_NAME CHAR(8), --保存期限
  PRICE MONEY
)
INSERT INTO [邦邦量販店].[dbo].[UNPIVOT_SQL]
VALUES(1,'舒跑','20140514',20)
INSERT INTO [邦邦量販店].[dbo].[UNPIVOT_SQL]
VALUES(2,'舒跑','20140506',20)
INSERT INTO [邦邦量販店].[dbo].[UNPIVOT_SQL]
VALUES(3,'黑松沙士','20170120',30)
INSERT INTO [邦邦量販店].[dbo].[UNPIVOT_SQL]
VALUES(4,'黑松沙士','20170220',20)

SELECT * FROM [邦邦量販店].[dbo].[UNPIVOT_SQL]
GO

SELECT ID,ATTRIBUTE [COLUMN_NAME],VALUE[VALUES]
FROM
(
SELECT [ID],
       CAST(ITEM_NAME AS SQL_VARIANT) [飲料名稱],
       CAST(DATE_NAME AS SQL_VARIANT) [保存期限],
       CAST(PRICE AS SQL_VARIANT)[價錢]
FROM [邦邦量販店].[dbo].[UNPIVOT_SQL]) AA
UNPIVOT
(
    VALUE FOR ATTRIBUTE IN([飲料名稱],[保存期限],[價錢])
)BB
ORDER BY [ID]
GO
