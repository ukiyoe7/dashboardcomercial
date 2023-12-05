-- RESULT REPRO

WITH DATE_PED AS (SELECT ID_PEDIDO 
                  FROM PEDID WHERE
                  PEDDTBAIXA BETWEEN '27.09.2023' AND 'TODAY'),
                  
  --  FILTRA CFOPS DE VENDA  

FIS AS (SELECT FISCODIGO FROM TBFIS WHERE FISTPNATOP IN ('V','R','SR')),
                
                  
      PED AS (SELECT P.ID_PEDIDO,
                      PEDDTBAIXA,
                       P.CLICODIGO
        FROM PEDID P
        INNER JOIN DATE_PED DT ON P.ID_PEDIDO=DT.ID_PEDIDO
        WHERE  PEDSITPED<>'C' AND PEDLCFINANC IN ('S', 'L','N'))
        
  
-- SELECT FINAL

SELECT PEDDTBAIXA DATA,
        CLICODIGO,
         SUM(PDPQTDADE) QTD,
          SUM(PDPUNITLIQUIDO*PDPQTDADE) VRVENDA
           FROM PDPRD PD
            INNER JOIN PED P ON P.ID_PEDIDO=PD.ID_PEDIDO
             INNER JOIN FIS F ON F.FISCODIGO=PD.FISCODIGO
              GROUP BY 1,2      
                  
                  