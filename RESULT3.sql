WITH 

FIS AS (SELECT FISCODIGO FROM TBFIS WHERE FISTPNATOP IN ('V','R','SR')),

 CLI AS (SELECT DISTINCT C.CLICODIGO,GCLCODIGO FROM CLIEN C
              INNER JOIN (SELECT CLICODIGO,E.ZOCODIGO FROM ENDCLI E
                                               INNER JOIN (SELECT ZOCODIGO FROM ZONA WHERE ZOCODIGO IN (20))Z ON 
                                                E.ZOCODIGO=Z.ZOCODIGO WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
                                                   WHERE CLICLIENTE='S' AND GCLCODIGO IS NOT NULL) 
                
        SELECT DISTINCT GCLCODIGO
         FROM PEDID P
          INNER JOIN FIS F ON P.FISCODIGO1=F.FISCODIGO
           INNER JOIN CLI C ON P.CLICODIGO=C.CLICODIGO
             WHERE
              PEDDTBAIXA BETWEEN
               DATEADD(MONTH, -5, CURRENT_DATE - EXTRACT(DAY FROM CURRENT_DATE) + 1) AND
                                 'YESTERDAY' OR  PEDDTBAIXA 
                                 BETWEEN DATEADD(MONTH, -5,DATEADD(YEAR, -1, CURRENT_DATE) - EXTRACT(DAY FROM CURRENT_DATE) + 1) 
                                 AND DATEADD(YEAR, -1, CURRENT_DATE) AND
             PEDSITPED<>'C' AND PEDLCFINANC IN ('S', 'L','N') 
        

                  