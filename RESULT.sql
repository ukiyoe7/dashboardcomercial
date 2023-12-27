-- RESULT REPRO

WITH  CLI AS (SELECT DISTINCT C.CLICODIGO,GCLCODIGO FROM CLIEN C
                       INNER JOIN (SELECT CLICODIGO,E.ZOCODIGO,ENDCODIGO FROM ENDCLI E
                        INNER JOIN (SELECT ZOCODIGO,ZODESCRICAO FROM ZONA 
                         WHERE ZOCODIGO IN (20))Z ON 
                          E.ZOCODIGO=Z.ZOCODIGO WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
                           WHERE CLICLIENTE='S'),  

  --  FILTRA CFOPS DE VENDA  

FIS AS (SELECT FISCODIGO FROM TBFIS WHERE FISTPNATOP IN ('V','R','SR')),
                  
      PED AS (SELECT P.ID_PEDIDO,
                      PEDDTBAIXA,
                       P.CLICODIGO,
                        GCLCODIGO
        FROM PEDID P
          INNER JOIN CLI C ON C.CLICODIGO=P.CLICODIGO
           WHERE  PEDSITPED<>'C' AND PEDLCFINANC IN ('S', 'L','N') AND PEDDTBAIXA BETWEEN
             DATEADD(MONTH, -11, CURRENT_DATE - EXTRACT(DAY FROM CURRENT_DATE) + 1) AND
              'TODAY' OR  PEDDTBAIXA BETWEEN DATEADD(MONTH, -11,DATEADD(YEAR, -1, CURRENT_DATE) - EXTRACT(DAY FROM CURRENT_DATE) + 1) AND DATEADD(YEAR, -1, CURRENT_DATE))
        
    
  
-- SELECT FINAL

SELECT EXTRACT(MONTH  FROM PEDDTBAIXA) MES,
        EXTRACT(YEAR  FROM PEDDTBAIXA) ANO,
         P.CLICODIGO,
          GCLCODIGO,
           SUM(PDPUNITLIQUIDO*PDPQTDADE) VRVENDA
            FROM PDPRD PD
             INNER JOIN PED P ON P.ID_PEDIDO=PD.ID_PEDIDO
              INNER JOIN FIS F ON F.FISCODIGO=PD.FISCODIGO
                GROUP BY 1,2,3,4