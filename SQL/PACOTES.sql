
WITH CLI AS (SELECT DISTINCT C.CLICODIGO,GCLCODIGO FROM CLIEN C
              INNER JOIN (SELECT CLICODIGO,E.ZOCODIGO FROM ENDCLI E
               INNER JOIN (SELECT ZOCODIGO FROM ZONA WHERE ZOCODIGO IN (20))Z ON 
                E.ZOCODIGO=Z.ZOCODIGO WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
                 WHERE CLICLIENTE='S'),
                 
PCLI AS (SELECT PCTNUMERO,P.CLICODIGO,GCLCODIGO,PCTDTCAD,PCTDTFIM FROM PCTCLI P
              INNER JOIN CLI C ON C.CLICODIGO=P.CLICODIGO),                 

PROD AS (SELECT P.PROCODIGO,PRODESCRICAO,TPLDESCRICAO FROM PRODU P
                  INNER JOIN TPLENTE T ON T.TPLCODIGO=P.TPLCODIGO
                   WHERE PROSITUACAO='A'),

PCT AS (
SELECT PCT.PCTNUMERO,
        CLICODIGO,
         GCLCODIGO,
          PCTDTCAD,
           PCTDTFIM,
            PCT.PROCODIGO,
             PRODESCRICAO,
              TPLDESCRICAO,
               PCPQTDADE,
                PCPSALDO
                 FROM PCTPRO PCT
                  INNER JOIN PCLI PC ON PCT.PCTNUMERO=PC.PCTNUMERO
                   LEFT JOIN PROD P ON PCT.PROCODIGO=P.PROCODIGO
                    ORDER BY PCTDTCAD DESC)
                   
  SELECT * FROM PCT WHERE PCPSALDO>0   
  
  
  
  
                  