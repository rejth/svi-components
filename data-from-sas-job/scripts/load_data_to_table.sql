insert into etl_stg.not_fraud_transactions (
    "ACCOUNT_FROM",
    "ACCOUNT_TO",
    "CLIENT_FIO_FROM",
    "CLIENT_FIO_TO",
    "CURRENCY",
    "PAYMENT_RUB",
    "TRANSACTION_DTTM",
    "EMP_NUM"
)
select
    sr."ACC_FROM",
    sr."ACC_TO",
    coalesce(sr."CLFIO_D", vcl_1."CLIENT_FIO"),
    coalesce(sr."CLFIO_C", vcl_2."CLIENT_FIO"),
    sr."TRNX_CUR",
    sr."TRNX_SR",
    sr."TRNX_DTTM",
    sr."TRNX_EMPL",
from etl_stg.scoring_result sr
left join etl_stg.vi_client vcl_1
    on sr."CLI_ID_D" = vcl_1."CLIENT_ID"
left join etl_stg.vi_client vcl_2
    on sr."CLI_ID_C" = vcl_2."CLIENT_ID"
where fraud_flag = 0