
## LIBS -----------------------

library(DBI)
library(dplyr)
library(readr)
library(lubridate)

con2 <- dbConnect(odbc::odbc(), "repro",encoding="Latin1")



# ANALISE MONTAGEM

mont <- 
  dbGetQuery(con2,"
           WITH CLI AS (SELECT DISTINCT C.CLICODIGO,GCLCODIGO FROM CLIEN C
                       INNER JOIN (SELECT CLICODIGO,E.ZOCODIGO FROM ENDCLI E
                        INNER JOIN (SELECT ZOCODIGO FROM ZONA 
                         WHERE ZOCODIGO IN (20))Z ON 
                          E.ZOCODIGO=Z.ZOCODIGO WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
                           WHERE CLICLIENTE='S'),
                           
                MONT AS (SELECT PROCODIGO,PRODESCRICAO FROM PRODU WHERE PROCODIGO IN ('MOVS','MOMF','MOBF','MOPA')),             
           
                  CJ AS (SELECT CLICODIGO,
                                 GCLCODIGO,
                                  PROCODIGO FROM CLI
                                   CROSS JOIN MONT)
               
                     SELECT * FROM CJ") 


View(mont)



mont2 <- 
 dbGetQuery(con2,"
           WITH CLI AS (SELECT DISTINCT C.CLICODIGO,GCLCODIGO,CLIPCDESCPRODU FROM CLIEN C
                       INNER JOIN (SELECT CLICODIGO,E.ZOCODIGO FROM ENDCLI E
                        INNER JOIN (SELECT ZOCODIGO FROM ZONA 
                         WHERE ZOCODIGO IN (20))Z ON 
                          E.ZOCODIGO=Z.ZOCODIGO WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
                           WHERE CLICLIENTE='S'),
                           
            CLITB AS (SELECT CT.CLICODIGO,
                              CLIPCDESCPRODU,
                               TBPCODIGO 
                                FROM CLITBP CT
                                 INNER JOIN CLI C ON C.CLICODIGO=CT.CLICODIGO),
                          
             TBPRECO AS (SELECT TBPCODIGO FROM TABPRECO WHERE (TBPDTVALIDADE>='TODAY' OR TBPDTVALIDADE IS NULL) AND TBPSITUACAO='A'),              
           
               MONT AS (SELECT PROCODIGO,PRODESCRICAO FROM PRODU WHERE PROCODIGO IN ('MOVS','MOMF','MOBF','MOPA')),
               
                PRECO AS (SELECT P.PROCODIGO,
                                  PREPCOVENDA2 FROM PREMP P
                                    WHERE EMPCODIGO=1 AND PROCODIGO IN ('MOVS','MOMF','MOBF','MOPA')),
           
             NEG_MONT AS(SELECT T.*,
                 CLICODIGO,
                   CASE 
                    WHEN TBPPCOVENDA2 IS NOT NULL THEN ROUND(TBPPCOVENDA2*(1-(CLIPCDESCPRODU/100)),2)
                     ELSE ROUND(PREPCOVENDA2*(1-(TBPPCDESCTO2/100)),2) END VALOR 
                      FROM TBPPRODU T
                       INNER JOIN TBPRECO P ON T.TBPCODIGO=P.TBPCODIGO
                        INNER JOIN MONT M ON M.PROCODIGO=T.PROCODIGO
                         INNER JOIN CLITB CT ON T.TBPCODIGO=CT.TBPCODIGO
                          INNER JOIN PRECO PC ON T.PROCODIGO=PC.PROCODIGO),
            
            NEG_MONT2 AS(
            SELECT * FROM NEG_MONT WHERE VALOR IS NOT NULL)
            
            SELECT CLICODIGO,PROCODIGO,MIN(VALOR)
            FROM NEG_MONT2 
            GROUP BY 1,2
            ") 


View(mont2)


mont3 <- 
  dbGetQuery(con2,"
WITH CLI AS (SELECT DISTINCT C.CLICODIGO,
                              GCLCODIGO,
                               CLIPCDESCPRODU 
                                FROM CLIEN C
                                 INNER JOIN (SELECT CLICODIGO,E.ZOCODIGO FROM ENDCLI E
                                  INNER JOIN (SELECT ZOCODIGO FROM ZONA 
                                   WHERE ZOCODIGO IN (20))Z ON E.ZOCODIGO=Z.ZOCODIGO WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
                                    LEFT OUTER JOIN (SELECT DISTINCT SITCLI.CLICODIGO,SITCODIGO FROM SITCLI
    INNER JOIN (SELECT DISTINCT SITCLI.CLICODIGO,MAX(SITDATA)ULTIMA FROM SITCLI
    GROUP BY 1)A ON SITCLI.CLICODIGO=A.CLICODIGO AND A.ULTIMA=SITCLI.SITDATA 
    INNER JOIN (SELECT DISTINCT SITCLI.CLICODIGO,SITDATA,MAX(SITSEQ)USEQ FROM SITCLI
    GROUP BY 1,2)MSEQ ON A.CLICODIGO=MSEQ.CLICODIGO AND MSEQ.SITDATA=A.ULTIMA 
    AND MSEQ.USEQ=SITCLI.SITSEQ WHERE SITCODIGO=4) IT ON C.CLICODIGO=IT.CLICODIGO
                                    WHERE CLICLIENTE='S' AND IT.CLICODIGO IS NULL),
                           
            CLITB AS (SELECT CT.CLICODIGO,
                              CLIPCDESCPRODU,
                               TBPCODIGO 
                                FROM CLITBP CT
                                 INNER JOIN CLI C ON C.CLICODIGO=CT.CLICODIGO),
                          
             TBPRECO AS (SELECT TBPCODIGO 
                                 FROM TABPRECO WHERE (TBPDTVALIDADE>='TODAY' OR TBPDTVALIDADE IS NULL) AND TBPSITUACAO='A'),              
           
               MONT AS (SELECT PROCODIGO,
                                PRODESCRICAO 
                                 FROM PRODU 
                                  WHERE PROCODIGO IN ('MOVS','MOMF','MOBF','MOPA')),
               
                PRECO AS (SELECT P.PROCODIGO,
                                  PREPCOVENDA2 FROM PREMP P
                                    WHERE EMPCODIGO=1 AND PROCODIGO IN ('MOVS','MOMF','MOBF','MOPA')),
           
                  NEG_MONT AS(SELECT T.*,
                               CLICODIGO,
                   CASE 
                    WHEN TBPPCOVENDA2 IS NOT NULL THEN ROUND(TBPPCOVENDA2*(1-(CLIPCDESCPRODU/100)),2)
                     ELSE ROUND(PREPCOVENDA2*(1-(TBPPCDESCTO2/100)),2) END VALOR 
                      FROM TBPPRODU T
                       INNER JOIN TBPRECO P ON T.TBPCODIGO=P.TBPCODIGO
                        INNER JOIN MONT M ON M.PROCODIGO=T.PROCODIGO
                         INNER JOIN CLITB CT ON T.TBPCODIGO=CT.TBPCODIGO
                          INNER JOIN PRECO PC ON T.PROCODIGO=PC.PROCODIGO),
            
            NEG_MONT2 AS(SELECT * FROM NEG_MONT WHERE VALOR IS NOT NULL),
            
            NEG_MONT3 AS (SELECT CLICODIGO,
                                  PROCODIGO,
                                   MIN(VALOR) VALOR
                                    FROM NEG_MONT2 
                                     GROUP BY 1,2),
            
            CJ AS (SELECT CLICODIGO,
                           PROCODIGO 
                            FROM CLI
                             CROSS JOIN MONT), 
            
            NEG_MONT4 AS (SELECT C.CLICODIGO,
                                  C.PROCODIGO,
                                   VALOR FROM CJ C
                                    LEFT JOIN NEG_MONT3 M3 ON M3.CLICODIGO=C.CLICODIGO AND M3.PROCODIGO=C.PROCODIGO),
              
             
              CJ2 AS(SELECT CLICODIGO,
                     M.PROCODIGO,
                        IIF(CLIPCDESCPRODU IS NULL,PREPCOVENDA2,PREPCOVENDA2*(1-CLIPCDESCPRODU/100)) VALOR
                        FROM CLI
                         CROSS JOIN MONT M
                          LEFT JOIN PRECO P ON M.PROCODIGO=P.PROCODIGO)
                          
                          
                SELECT M4.CLICODIGO,
                        M4.PROCODIGO,
                         COALESCE(M4.VALOR, CJ2.VALOR) AS VALOR
                          FROM NEG_MONT4 M4
                           LEFT JOIN CJ2 ON CJ2.CLICODIGO=M4.CLICODIGO AND CJ2.PROCODIGO=M4.PROCODIGO
             
            ") 


View(mont3)
  








  