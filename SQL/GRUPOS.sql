WITH 

FIS AS (SELECT FISCODIGO FROM TBFIS WHERE FISTPNATOP IN ('V','R','SR')),

 CLI AS (SELECT DISTINCT C.CLICODIGO,C.GCLCODIGO,GCLNOME FROM CLIEN C
              INNER JOIN (SELECT CLICODIGO,
                            E.ZOCODIGO FROM ENDCLI E
                              INNER JOIN (SELECT ZOCODIGO FROM ZONA WHERE ZOCODIGO IN (20))Z ON 
                               E.ZOCODIGO=Z.ZOCODIGO WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
                                LEFT JOIN GRUPOCLI G ON C.GCLCODIGO=G.GCLCODIGO
                                                   WHERE CLICLIENTE='S' AND C.GCLCODIGO IS NOT NULL) 
                
        SELECT DISTINCT GCLCODIGO,GCLNOME
         FROM PEDID P
          INNER JOIN FIS F ON P.FISCODIGO1=F.FISCODIGO
           INNER JOIN CLI C ON P.CLICODIGO=C.CLICODIGO
             WHERE
(PEDDTBAIXA BETWEEN CAST(EXTRACT(YEAR FROM CURRENT_DATE) || '-01-01' AS DATE) AND'YESTERDAY' OR
 PEDDTBAIXA BETWEEN DATEADD(YEAR, -1, CAST(EXTRACT(YEAR FROM CURRENT_DATE) || '  -01-01' AS DATE)) AND DATEADD(YEAR, -1, CURRENT_DATE-1) OR
 PEDDTBAIXA BETWEEN DATEADD(MONTH, -6, CURRENT_DATE - EXTRACT(DAY FROM CURRENT_DATE) + 1) AND CURRENT_DATE - EXTRACT(DAY FROM CURRENT_DATE) OR
 PEDDTBAIXA BETWEEN DATEADD(MONTH, -6,DATEADD(YEAR, -1, CURRENT_DATE) - EXTRACT(DAY FROM CURRENT_DATE-1) + 1) AND DATEADD(YEAR, -1, CURRENT_DATE - EXTRACT(DAY FROM CURRENT_DATE))) AND
             PEDSITPED<>'C' AND PEDLCFINANC IN ('S', 'L','N') ORDER BY GCLCODIGO ASC