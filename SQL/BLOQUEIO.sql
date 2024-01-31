WITH CLI AS (SELECT DISTINCT C.CLICODIGO,GCLCODIGO FROM CLIEN C
                       INNER JOIN (SELECT CLICODIGO,E.ZOCODIGO FROM ENDCLI E
                        INNER JOIN (SELECT ZOCODIGO FROM ZONA 
                         WHERE ZOCODIGO IN (20))Z ON 
                          E.ZOCODIGO=Z.ZOCODIGO WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
                           WHERE CLICLIENTE='S'),


BLOQ AS(
SELECT 
       RECCODIGO 
     , CLICODIGO 
     , CTCNUMERO 
     , BCOCODIGO 
     , ENDFAT 
     , ENDCOB 
     , COBCODIGO 
     , RECNRDOC 
     , RECDTDOC 
     , RECPARCELA 
     , CUSCODIGO 
     , FUNCODIGO 
     , Cast(RECPCCOMISSAO as Numeric(14,2)) RECPCCOMISSAO 
     , RECDTEMISSAO 
     , RECDTVENCTO 
     , RECDTPREVIS 
     , RECVALOR 
     , RECVALORABERTO 
     , RECDTREMESSA 
     , RECDTRETORNO 
     , RECHISTORICO 
     , RECCOMANDO 
     , RECPRZPROT 
     , STCODIGO 
     , RECSITUACAO 
     , RECORIGEM 
     , RECNSNUMERO 
     , RECTIPODOCTO 
     , RECDTIMPBOLETO 
     , COBSEQ 
     , Receb.EMPCODIGO 
  FROM Receb 
 WHERE recsituacao   <> 'C'
   AND recValorAberto > 0.009 
   AND recdtVencto    < DATEADD(-7 DAY TO CURRENT_DATE)            

 UNION 
 SELECT
       RECCODIGO 
      , CLICODIGO 
      , CTCNUMERO 
      , BCOCODIGO 
      , ENDFAT 
      , ENDCOB 
      , COBCODIGO 
      , RECNRDOC 
      , RECDTDOC 
      , RECPARCELA 
      , CUSCODIGO 
      , FUNCODIGO 
      , Cast(RECPCCOMISSAO as Numeric(14,2)) 
      , RECDTEMISSAO 
      , RECDTVENCTO 
      , RECDTPREVIS 
      , RECVALOR 
      , RECVALORABERTO 
      , RECDTREMESSA 
      , RECDTRETORNO 
      , RECHISTORICO 
      , RECCOMANDO 
      , RECPRZPROT 
      , STCODIGO 
      , RECSITUACAO 
      , RECORIGEM 
      , RECNSNUMERO 
      , RECTIPODOCTO 
      , RECDTIMPBOLETO 
      , COBSEQ 
      , RecebP.EmpCodigo 
   FROM RecebP 
  WHERE recsituacao   <> 'C'
    AND recValorAberto > 0.009 
   AND recdtVencto < DATEADD(-7 DAY TO CURRENT_DATE)           

 ORDER BY 16 DESC)
 
 SELECT DISTINCT B.CLICODIGO 
   FROM BLOQ B
    INNER JOIN CLI C ON B.CLICODIGO=C.CLICODIGO