-- Os valores entre {} serão utilizados no script em Python como variáveis
--ENTRADAS NA TROCA

       SELECT

       A.NROEMPRESA,
       A.DTAENTRADASAIDA,
       --TO_DATE(C.DATA_COLETA, 'dd/mm/yyyy') AS DATA_COLETA,
       --C.DATA_COLETA,
       A.SEQPRODUTO,
       A.CODGERALOPER,
       B.DESCRICAO,
       ROUND(SUM(A.QTDENTRADAOUTRAS), 2) AS QTD,
       ROUND(SUM(A.VLRENTRADAOUTRAS), 2) AS VLR,
       -- MAX(A.DESCRICAOLOCAL),
       COALESCE(
                (SELECT MAX(C.TIPLANCTO) FROM BIGMAIS.CGESMOV_PRODUTOS_COLETADOS C WHERE A.NROEMPRESA = C.NROEMPRESA AND A.SEQPRODUTO = C.SEQPRODUTO AND TO_DATE(A.DTAENTRADASAIDA, 'dd/mm/yyyy') = TO_DATE(C.DATA_COLETA, 'dd/mm/yyyy')),
                        A.MOTIVOMOVTO) AS TIPLANCTO,
       A.USULANCTO,
       'E' AS NATMOVTO

              FROM CONSINCO.MAXV_ABCMOVTOBASE_PROD A
              LEFT JOIN CONSINCO.GE_CGO B ON A.CODGERALOPER = B.CGO

       WHERE A.DTAENTRADASAIDA BETWEEN TO_DATE('{StartDate}', 'yyyy-mm-dd') AND TO_DATE('{EndDate}', 'yyyy-mm-dd')
       AND A.DESCRICAOLOCAL = 'TROCA'
       AND A.TIPLANCTO = 'E'

       GROUP BY A.DTAENTRADASAIDA, A.NROEMPRESA, A.SEQPRODUTO, A.DTAENTRADASAIDA, A.CODGERALOPER, A.USULANCTO, B.DESCRICAO, A.MOTIVOMOVTO

-- COMBINAÇÃO

UNION

--SAIDAS DA TROCA

SELECT

A.NROEMPRESA,
A.DTAENTRADASAIDA,
--TO_DATE(C.DATA_COLETA, 'dd/mm/yyyy') AS DATA_COLETA,
--C.DATA_COLETA,
A.SEQPRODUTO,
A.CODGERALOPER,
B.DESCRICAO,
ROUND(SUM(A.QTDSAIDAOUTRAS), 2) AS QTD,
ROUND(SUM(A.VLRSAIDAOUTRAS), 2) AS VLR,
-- MAX(A.DESCRICAOLOCAL),
COALESCE(
         (SELECT MAX(C.TIPLANCTO) FROM BIGMAIS.CGESMOV_PRODUTOS_COLETADOS C WHERE A.NROEMPRESA = C.NROEMPRESA AND A.SEQPRODUTO = C.SEQPRODUTO AND TO_DATE(A.DTAENTRADASAIDA, 'dd/mm/yyyy') = TO_DATE(C.DATA_COLETA, 'dd/mm/yyyy')),
         A.MOTIVOMOVTO) AS TIPLANCTO,
A.USULANCTO,
'S' AS NATMOVTO

       FROM CONSINCO.MAXV_ABCMOVTOBASE_PROD A
       LEFT JOIN CONSINCO.GE_CGO B ON A.CODGERALOPER = B.CGO

WHERE A.DTAENTRADASAIDA BETWEEN TO_DATE('{StartDate}', 'yyyy-mm-dd') AND TO_DATE('{EndDate}', 'yyyy-mm-dd')
AND A.DESCRICAOLOCAL = 'TROCA'
AND A.TIPLANCTO = 'S'

GROUP BY A.DTAENTRADASAIDA, A.NROEMPRESA, A.SEQPRODUTO, A.DTAENTRADASAIDA, A.CODGERALOPER, A.USULANCTO, B.DESCRICAO, A.MOTIVOMOVTO