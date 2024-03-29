SELECT
RC.CLICODIGO,
CL.CLINOMEFANT,
GCL.GCLCODIGO,
GCL.GCLNOME,
RC.RECCODIGO,
RC.RECNRDOC,
RC.RECDTDOC,
RC.RECDTEMISSAO,
RC.RECDTVENCTO,
RC.RECVALOR,
RC.RECVRDESCONTO,
RC.RECVALORABERTO,
RC.CUSCODIGO,
CC.CUSDESCRICAO,
RC.BCOCODIGO,
RC.RECNSNUMERO,
RC.COBCODIGO,
CL.CLIRAZSOCIAL,
CL.CLIRAZSOCIAL,
CL.CLICNPJCPF,
RC.RECPARCELA,
RC.RECHISTORICO,
S.STSTATUS,

DATEDIFF(DAY,CAST(RC.RECDTVENCTO AS DATE), CURRENT_DATE) DIAS_VENCIMENTO,
CASE
            WHEN DATEDIFF(DAY,CAST(RC.RECDTVENCTO AS DATE), CURRENT_DATE) > 0 THEN 'VENCIDO'
            WHEN DATEDIFF(DAY,CAST(RC.RECDTVENCTO AS DATE), CURRENT_DATE) <= 0 THEN ' A VENCER'
            END AS SITUACAO,
' '  COLUNA3,

RC.RECPARCELA,
EXTRACT(MONTH FROM RC.RECDTVENCTO)  MES,
EXTRACT(YEAR FROM RC.RECDTVENCTO) ANO


FROM RECEB RC
LEFT JOIN CLIEN CL ON RC.CLICODIGO =CL.CLICODIGO
LEFT JOIN STATUSTIT S ON RC.STCODIGO = S.STCODIGO
LEFT JOIN CCUST CC ON RC.CUSCODIGO = CC.CUSCODIGO
LEFT JOIN GRUPOCLI GCL ON CL.GCLCODIGO = GCL.GCLCODIGO
WHERE RC.RECDTVENCTO BETWEEN '23.01.2024'  AND '23.01.2024'
AND RC.RECSITUACAO ='N'
AND RC.RECVALORABERTO > 0.001
AND S.STCODIGO <> 'Z'