--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5
-- Dumped by pg_dump version 12.3

-- Started on 2020-09-08 10:48:33

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

--
-- TOC entry 1302 (class 1259 OID 136984)
-- Name: transactions; Type: TABLE; Schema: public; Owner: dbmsowner
--

CREATE TABLE public.transactions (
    "ACCOUNT_FROM" character varying(20),
    "ACCOUNT_TO" character varying(20),
    "CLIENT_FIO_FROM" character varying(50),
    "CLIENT_FIO_TO" character varying(50),
    "CURRENCY" character varying(3),
    "PAYMENT_RUB" numeric,
    "TRANSACTION_DTTM" timestamp with time zone,
    "EMP_NUM" character varying(10)
);


ALTER TABLE public.transactions OWNER TO dbmsowner;

--
-- TOC entry 6648 (class 0 OID 136984)
-- Dependencies: 1302
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: dbmsowner
--

COPY public.transactions ("ACCOUNT_FROM", "ACCOUNT_TO", "CLIENT_FIO_FROM", "CLIENT_FIO_TO", "CURRENCY", "PAYMENT_RUB", "TRANSACTION_DTTM", "EMP_NUM") FROM stdin;
40817810987870008924	40817810287870008925	Петя	Вася	RUR	200	2020-09-03 15:36:54.224338+03	RB0001
40817810287870008925	40817810987870008924	Вася	Петя	RUR	100	2020-09-03 15:36:54.224338+03	RB0001
\.


-- Completed on 2020-09-08 10:48:35

--
-- PostgreSQL database dump complete
--

