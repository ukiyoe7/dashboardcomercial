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
           WITH CLI AS (SELECT DISTINCT C.CLICODIGO,GCLCODIGO FROM CLIEN C
                       INNER JOIN (SELECT CLICODIGO,E.ZOCODIGO FROM ENDCLI E
                        INNER JOIN (SELECT ZOCODIGO FROM ZONA 
                         WHERE ZOCODIGO IN (20))Z ON 
                          E.ZOCODIGO=Z.ZOCODIGO WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
                           WHERE CLICLIENTE='S'),
                           
            CLITB AS (SELECT CT.CLICODIGO,
                               TBPCODIGO 
                                FROM CLITBP CT
                                 INNER JOIN CLI C ON C.CLICODIGO=CT.CLICODIGO),
                          
             TBPRECO AS (SELECT TBPCODIGO FROM TABPRECO WHERE (TBPDTVALIDADE>='TODAY' OR TBPDTVALIDADE IS NULL)),              
           
               MONT AS (SELECT PROCODIGO,PRODESCRICAO FROM PRODU WHERE PROCODIGO IN ('MOVS','MOMF','MOBF','MOPA')),
               
                PRECO AS (SELECT P.PROCODIGO,
                                  PREPCOVENDA2 FROM PREMP P
                                    WHERE EMPCODIGO=1 AND PROCODIGO IN ('MOVS','MOMF','MOBF','MOPA'))
           
               SELECT T.*,
                 CLICODIGO,
                   CASE 
                    WHEN TBPPCOVENDA2 IS NOT NULL THEN TBPPCOVENDA2
                     ELSE ROUND(PREPCOVENDA2*(1-(TBPPCDESCTO2/100)),2) END VALOR 
                      FROM TBPPRODU T
                       INNER JOIN TBPRECO P ON T.TBPCODIGO=P.TBPCODIGO
                        INNER JOIN MONT M ON M.PROCODIGO=T.PROCODIGO
                         INNER JOIN CLITB CT ON T.TBPCODIGO=CT.TBPCODIGO
                          INNER JOIN PRECO PC ON T.PROCODIGO=PC.PROCODIGO") 


View(mont2)
  
  
  
  