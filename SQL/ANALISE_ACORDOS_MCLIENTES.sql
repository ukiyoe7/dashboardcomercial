
WITH TB AS (SELECT TBPCODIGO FROM TABPRECO 
WHERE TBPSITUACAO='A' AND (TBPDTVALIDADE >='TODAY' OR TBPDTVALIDADE IS NULL))



SELECT TP.TBPCODIGO,
        PROCODIGO,
         TBPPCOVENDA,
          TBPPCDESCTO2,
           TBPPCOVENDA2,
            TBPPCDESCTO
        FROM TBPPRODU TP
 INNER JOIN TB ON TP.TBPCODIGO=TB.TBPCODIGO
  WHERE 
   RIGHT(TRIM(PROCODIGO),3)='307'