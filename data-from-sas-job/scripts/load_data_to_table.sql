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
    sr."acc_from",
    sr."acc_to",
    coalesce(sr."clfio_d", vcl_1."CLIENT_FIO"),
    coalesce(sr."clfio_c", vcl_2."CLIENT_FIO"),
    sr."trnx_cur",
    sr."trnx_sr",
    sr."trnx_dttm",
    sr."trnx_empl"
from etl_stg.scoring_result sr
left join etl_stg.vi_client vcl_1
    on sr.cli_id_d = vcl_1."CLIENT_ID"
left join etl_stg.vi_client vcl_2
    on sr.cli_id_c = vcl_2."CLIENT_ID"
where fraud_flag = 0