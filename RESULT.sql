
--  FILTRA DATAS

WITH DATE_PED AS (SELECT ID_PEDIDO 
                      FROM PEDID WHERE
                       PEDDTBAIXA BETWEEN '01.08.2023' AND '31.08.2023'),

--  FILTRA CFOPS DE VENDA  

  FIS AS (SELECT FISCODIGO FROM TBFIS WHERE FISTPNATOP IN ('V','R','SR')),
 
-- CLIENTES FILTRA SOMENTE CLIENTES COM SETORES DE CARTEIRAS

  CLI AS (SELECT C.CLICODIGO,
                  CLINOMEFANT,
                   GCLCODIGO CODGRUPO,
                      SETOR
                       FROM CLIEN C
                        INNER JOIN (SELECT CLICODIGO, ZODESCRICAO SETOR FROM ENDCLI E
                         INNER JOIN (SELECT ZOCODIGO,ZODESCRICAO FROM ZONA WHERE ZOCODIGO IN(20,21,22,23,24,25,26,28))Z ON E.ZOCODIGO=Z.ZOCODIGO
                          WHERE ENDFAT='S') ED ON C.CLICODIGO=ED.CLICODIGO
                            WHERE CLICLIENTE='S'),
  
-- LISTA PEDIDOS

  PED AS (SELECT P.ID_PEDIDO,
                   PEDDTBAIXA,
                    P.CLICODIGO,
                     CLINOMEFANT,
                      CODGRUPO,
                       SETOR
                          FROM PEDID P
                           INNER JOIN DATE_PED DT ON P.ID_PEDIDO=DT.ID_PEDIDO
                            INNER JOIN CLI C ON P.CLICODIGO=C.CLICODIGO WHERE  PEDSITPED<>'C' AND PEDLCFINANC IN ('S', 'L','N')),
    
-- LISTA PILARES    

     VARILUX AS (SELECT PROCODIGO FROM PRODU WHERE MARCODIGO=57),
      
      KODAK AS (SELECT PROCODIGO FROM PRODU WHERE MARCODIGO IN (24,93)),
       
       CRIZAL AS (SELECT PROCODIGO FROM PRODU WHERE PRODESCRICAO LIKE '%CRIZAL%' AND PROTIPO='T'),
            
        CRIZALVS AS (SELECT PROCODIGO FROM PRODU WHERE (PRODESCRICAO LIKE '%CRIZAL%')  AND GR1CODIGO=2),      

         MREPRO AS (SELECT PROCODIGO FROM PRODU WHERE MARCODIGO IN (106,128,135,158,159,189) AND PROTIPO<>'T'),
         
          MCLIENTE AS (SELECT PROCODIGO FROM PRODU WHERE PROCODIGO IN (SELECT PROCODIGO FROM NGRUPOS WHERE GRCODIGO=162) AND PROTIPO<>'T'), 
          
           TRANSITIONS AS (SELECT PROCODIGO FROM PRODU WHERE (PRODESCRICAO LIKE '%TGEN8%' OR PRODESCRICAO LIKE '%TRANS%') ), 
           
            PROD AS (SELECT PROCODIGO,PROTIPO FROM PRODU WHERE PROSITUACAO='A' ) 
  
-- SELECT FINAL
  
  SELECT   PEDDTBAIXA DATA,
               CLICODIGO,
                CLINOMEFANT,
                 CODGRUPO,
                  SETOR,
                   PD.PROCODIGO,
                    PDPDESCRICAO,
                     PROTIPO,
                    CASE 
                     WHEN VLX.PROCODIGO IS NOT NULL THEN 'VARILUX'
                      WHEN KDK.PROCODIGO IS NOT NULL THEN 'KODAK'
                       WHEN CZL.PROCODIGO IS NOT NULL THEN 'CRIZAL TRAT'
                        WHEN CVS.PROCODIGO IS NOT NULL THEN 'CRIZAL VS'
                         WHEN MRP.PROCODIGO IS NOT NULL THEN 'MARCAS REPRO'
                          WHEN MRCL.PROCODIGO IS NOT NULL THEN 'MARCAS CLIENTE'
                           ELSE 'OUTROS' END PILARES,
                            IIF(TRS.PROCODIGO IS NOT NULL, 1,0) TRANSITIONS,
                             SUM(PDPQTDADE) QTD,
                              SUM(PDPUNITLIQUIDO*PDPQTDADE) VRVENDA 
                              
                             
   FROM PDPRD PD
    INNER JOIN PED P ON P.ID_PEDIDO=PD.ID_PEDIDO
     INNER JOIN FIS F ON F.FISCODIGO=PD.FISCODIGO

       LEFT JOIN VARILUX VLX ON VLX.PROCODIGO=PD.PROCODIGO
        LEFT JOIN KODAK KDK ON KDK.PROCODIGO=PD.PROCODIGO
         LEFT JOIN CRIZAL CZL ON CZL.PROCODIGO=PD.PROCODIGO
          LEFT JOIN CRIZALVS CVS ON CVS.PROCODIGO=PD.PROCODIGO
           LEFT JOIN MREPRO MRP ON MRP.PROCODIGO=PD.PROCODIGO
            LEFT JOIN MCLIENTE MRCL ON MRCL.PROCODIGO=PD.PROCODIGO
             LEFT JOIN TRANSITIONS TRS ON TRS.PROCODIGO=PD.PROCODIGO
              LEFT JOIN PROD PR ON PR.PROCODIGO=PD.PROCODIGO
               GROUP BY 1,2,3,4,5,6,7,8,9,10




