--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5 (Debian 10.5-2.pgdg90+1)
-- Dumped by pg_dump version 11.3

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

ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
ALTER TABLE ONLY public.magasin_sale_orders DROP CONSTRAINT magasin_sale_orders_pkey;
ALTER TABLE ONLY public.magasin_inventory_stock_items DROP CONSTRAINT magasin_inventory_stock_items_pkey;
DROP TABLE public.schema_migrations;
DROP TABLE public.magasin_sale_orders;
DROP TABLE public.magasin_inventory_stock_items;
SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: magasin_inventory_stock_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.magasin_inventory_stock_items (
    id uuid NOT NULL,
    product_id uuid NOT NULL,
    count_on_hand integer NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.magasin_inventory_stock_items OWNER TO postgres;

--
-- Name: magasin_sale_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.magasin_sale_orders (
    id uuid NOT NULL,
    email character varying(255) NOT NULL,
    product_id uuid NOT NULL,
    quantity integer NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.magasin_sale_orders OWNER TO postgres;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Data for Name: magasin_inventory_stock_items; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: magasin_sale_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.schema_migrations VALUES (20180430195550, '2019-05-31 20:06:00');
INSERT INTO public.schema_migrations VALUES (20180501193645, '2019-05-31 20:06:01');


--
-- Name: magasin_inventory_stock_items magasin_inventory_stock_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.magasin_inventory_stock_items
    ADD CONSTRAINT magasin_inventory_stock_items_pkey PRIMARY KEY (id, product_id);


--
-- Name: magasin_sale_orders magasin_sale_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.magasin_sale_orders
    ADD CONSTRAINT magasin_sale_orders_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- PostgreSQL database dump complete
--

