
WITH  CLI AS (SELECT DISTINCT C.CLICODIGO,GCLCODIGO,CLINOMEFANT FROM CLIEN C
                       INNER JOIN (SELECT CLICODIGO,E.ZOCODIGO FROM ENDCLI E
                        INNER JOIN (SELECT ZOCODIGO FROM ZONA 
                         WHERE ZOCODIGO IN (20,21,22,23,24,25,26,27,28))Z ON 
                          E.ZOCODIGO=Z.ZOCODIGO WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
                           WHERE CLICLIENTE='S')

SELECT CT.CLICODIGO,
        TBPCODIGO,
         CLINOMEFANT FROM CLITBP CT
          INNER JOIN CLI C ON CT.CLICODIGO=C.CLICODIGO