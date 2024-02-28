
WITH  CLI AS (SELECT DISTINCT C.CLICODIGO,GCLCODIGO FROM CLIEN C
                       INNER JOIN (SELECT CLICODIGO,E.ZOCODIGO FROM ENDCLI E
                        INNER JOIN (SELECT ZOCODIGO FROM ZONA 
                         WHERE ZOCODIGO IN (20))Z ON 
                          E.ZOCODIGO=Z.ZOCODIGO WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
                           WHERE CLICLIENTE='S'),  


PED AS (
 SELECT 
  DISTINCT P.ID_PEDIDO, 
   P.CLICODIGO, 
    CAST(P.PEDPZETGSIS AS DATE) AS ENTREGA,
     SUBSTR(CAST(COALESCE(P.PEDHRETGSIS, CURRENT_TIMESTAMP) AS TIME), 1, 5) AS HRENTREGA, 
      CAST( CAST(P.PEDPZETGSIS AS DATE)  ||' '|| Substr(cast( coalesce(p.PedHrETGSIS, current_timestamp) as time),1,5) AS TIMESTAMP) AS ENTREGA_DATETIME,
       CAST(P.PEDDTSAIDA AS DATE) AS SAIDA,
        SUBSTR(CAST(COALESCE(P.PEDHRSAIDA, CURRENT_TIMESTAMP) AS TIME), 1, 5) AS HRSAIDA,
         CAST( CAST(P.PEDDTSAIDA AS DATE)  ||' '|| Substr(cast( coalesce(p.PEDHRSAIDA, current_timestamp) as time),1,5) AS TIMESTAMP) AS SAIDA_DATETIME
          FROM PEDID P
  INNER JOIN CLI C ON C.CLICODIGO=P.CLICODIGO        
   INNER JOIN ACOPED ACP ON ACP.ID_PEDIDO = P.ID_PEDIDO
     WHERE NOT EXISTS (SELECT 1 FROM ACOPED ACP1 WHERE 
      ACP1.LPCODIGO IN (1810,50,151,167,173,19,248) AND ACP1.ID_PEDIDO = P.ID_PEDIDO)
       AND P.PEDSITPED IN ('A','F') AND P.PEDORIGEM IN ('D','E','M','W','X','P')
        AND P.TPCODIGO IN (1,2,3,5,7,10,12,14)
          AND P.PEDPZETGSIS BETWEEN DATEADD(-30 DAY TO CURRENT_DATE) AND 'YESTERDAY'
           AND P.PEDDTAPROVADO IS NOT NULL ORDER BY 6)
          
SELECT 
 ID_PEDIDO,
  CLICODIGO,
   ENTREGA,
    HRENTREGA, 
     ENTREGA_DATETIME,
      SAIDA,
       HRSAIDA,
        SAIDA_DATETIME,
         IIF(DATEDIFF(MINUTE FROM SAIDA_DATETIME TO ENTREGA_DATETIME)<0,1,0) DIF
          FROM PED