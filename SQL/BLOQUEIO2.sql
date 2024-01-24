
WITH CLI AS (SELECT DISTINCT C.CLICODIGO,GCLCODIGO,C.PCFCODIGO,PCFDESCRICAO,CLIDIASATRASO FROM CLIEN C
                         INNER JOIN (SELECT CLICODIGO,E.ZOCODIGO,ENDCODIGO FROM ENDCLI E
                          INNER JOIN (SELECT ZOCODIGO,ZODESCRICAO FROM ZONA 
                           WHERE ZOCODIGO IN (20))Z ON 
                            E.ZOCODIGO=Z.ZOCODIGO WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
                             LEFT JOIN PLTCTRFIN P ON C.PCFCODIGO=P.PCFCODIGO
                              WHERE CLICLIENTE='S'),
        


REC AS (SELECT 
         R.CLICODIGO,
          RECNRDOC,
           POSITION('AC' IN RIGHT(RECNRDOC,3)) ACORDO,
            PCFCODIGO,
             PCFDESCRICAO,
              CLIDIASATRASO,
               RECDTVENCTO,
                RECVALORABERTO,
                 DATEDIFF(DAY,CAST(RECDTVENCTO AS DATE), CURRENT_DATE) DIAS_VENCIMENTO,
                  IIF(DATEDIFF(DAY,CAST(RECDTVENCTO AS DATE), CURRENT_DATE)>CLIDIASATRASO AND POSITION('AC' IN RIGHT(RECNRDOC,3))<>1,1,0) ALERTA
                   FROM 
                    RECEB R
                     INNER JOIN CLI C ON R.CLICODIGO=C.CLICODIGO
                      WHERE 
                       RECDTVENCTO >=DATEADD(-365 DAY TO CURRENT_DATE) AND 
                        RECVALORABERTO>0.01 AND
                         RECSITUACAO<>'C')
                          
                          SELECT DISTINCT CLICODIGO 
                           FROM REC
                            WHERE ALERTA=1
         
         

                      