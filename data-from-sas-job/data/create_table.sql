CREATE TABLE public.transactions
(
  "ACCOUNT_FROM" character varying(20),
  "ACCOUNT_TO" character varying(20),
  "CLIENT_FIO_FROM" character varying(50),
  "CLIENT_FIO_TO" character varying(50),
	"CURRENCY" character varying(3),
	"PAYMENT_RUB" numeric,
	"TRANSACTION_DTTM" timestamp with time zone,
	"EMP_NUM" character varying(10) 
)