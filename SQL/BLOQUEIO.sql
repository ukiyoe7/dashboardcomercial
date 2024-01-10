WITH BLOQ AS(
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
   AND recdtVencto    < '03.01.2024'           

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
   AND recdtVencto < '03.01.2024'            

 ORDER BY 16 DESC)
 
 SELECT DISTINCT CLICODIGO FROM BLOQ