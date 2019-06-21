--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5 (Debian 10.5-2.pgdg90+1)
-- Dumped by pg_dump version 10.8

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

ALTER TABLE ONLY public.stream_events DROP CONSTRAINT stream_events_stream_id_fkey;
ALTER TABLE ONLY public.stream_events DROP CONSTRAINT stream_events_original_stream_id_fkey;
ALTER TABLE ONLY public.stream_events DROP CONSTRAINT stream_events_event_id_fkey;
DROP TRIGGER event_notification ON public.streams;
DROP RULE no_update_stream_events ON public.stream_events;
DROP RULE no_update_events ON public.events;
DROP RULE no_delete_stream_events ON public.stream_events;
DROP RULE no_delete_events ON public.events;
DROP INDEX public.ix_subscriptions_stream_uuid_subscription_name;
DROP INDEX public.ix_streams_stream_uuid;
DROP INDEX public.ix_stream_events;
ALTER TABLE ONLY public.subscriptions DROP CONSTRAINT subscriptions_pkey;
ALTER TABLE ONLY public.streams DROP CONSTRAINT streams_pkey;
ALTER TABLE ONLY public.stream_events DROP CONSTRAINT stream_events_pkey;
ALTER TABLE ONLY public.snapshots DROP CONSTRAINT snapshots_pkey;
ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
ALTER TABLE ONLY public.magasin_sale_orders DROP CONSTRAINT magasin_sale_orders_pkey;
ALTER TABLE ONLY public.magasin_inventory_stock_items DROP CONSTRAINT magasin_inventory_stock_items_pkey;
ALTER TABLE ONLY public.events DROP CONSTRAINT events_pkey;
ALTER TABLE ONLY public.ecto_schema_migrations DROP CONSTRAINT ecto_schema_migrations_pkey;
ALTER TABLE public.subscriptions ALTER COLUMN subscription_id DROP DEFAULT;
ALTER TABLE public.streams ALTER COLUMN stream_id DROP DEFAULT;
DROP SEQUENCE public.subscriptions_subscription_id_seq;
DROP TABLE public.subscriptions;
DROP SEQUENCE public.streams_stream_id_seq;
DROP TABLE public.streams;
DROP TABLE public.stream_events;
DROP TABLE public.snapshots;
DROP TABLE public.schema_migrations;
DROP TABLE public.magasin_sale_orders;
DROP TABLE public.magasin_inventory_stock_items;
DROP TABLE public.events;
DROP TABLE public.ecto_schema_migrations;
DROP FUNCTION public.notify_events();
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: notify_events(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_events() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  payload text;
BEGIN
    -- Payload text contains:
    --  * `stream_uuid`
    --  * `stream_id`
    --  * first `stream_version`
    --  * last `stream_version`
    -- Each separated by a comma (e.g. 'stream-12345,1,1,5')

    payload := NEW.stream_uuid || ',' || NEW.stream_id || ',' || (OLD.stream_version + 1) || ',' || NEW.stream_version;

    -- Notify events to listeners
    PERFORM pg_notify('events', payload);

    RETURN NULL;
END;
$$;


ALTER FUNCTION public.notify_events() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ecto_schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ecto_schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE public.ecto_schema_migrations OWNER TO postgres;

--
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    event_id uuid NOT NULL,
    event_type text NOT NULL,
    causation_id uuid,
    correlation_id uuid,
    data bytea NOT NULL,
    metadata bytea,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE public.events OWNER TO postgres;

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
-- Name: snapshots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.snapshots (
    source_uuid text NOT NULL,
    source_version bigint NOT NULL,
    source_type text NOT NULL,
    data bytea NOT NULL,
    metadata bytea,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE public.snapshots OWNER TO postgres;

--
-- Name: stream_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stream_events (
    event_id uuid NOT NULL,
    stream_id bigint NOT NULL,
    stream_version bigint NOT NULL,
    original_stream_id bigint,
    original_stream_version bigint
);


ALTER TABLE public.stream_events OWNER TO postgres;

--
-- Name: streams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.streams (
    stream_id bigint NOT NULL,
    stream_uuid text NOT NULL,
    stream_version bigint DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE public.streams OWNER TO postgres;

--
-- Name: streams_stream_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.streams_stream_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.streams_stream_id_seq OWNER TO postgres;

--
-- Name: streams_stream_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.streams_stream_id_seq OWNED BY public.streams.stream_id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscriptions (
    subscription_id bigint NOT NULL,
    stream_uuid text NOT NULL,
    subscription_name text NOT NULL,
    last_seen bigint,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE public.subscriptions OWNER TO postgres;

--
-- Name: subscriptions_subscription_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subscriptions_subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscriptions_subscription_id_seq OWNER TO postgres;

--
-- Name: subscriptions_subscription_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subscriptions_subscription_id_seq OWNED BY public.subscriptions.subscription_id;


--
-- Name: streams stream_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.streams ALTER COLUMN stream_id SET DEFAULT nextval('public.streams_stream_id_seq'::regclass);


--
-- Name: subscriptions subscription_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN subscription_id SET DEFAULT nextval('public.subscriptions_subscription_id_seq'::regclass);


--
-- Data for Name: ecto_schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: magasin_inventory_stock_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.magasin_inventory_stock_items VALUES ('2edefe71-e13c-40e4-952d-b236df40f3cf', '6f4dc1d7-03ee-4eaa-8aa0-478a1a1935b6', 31440, '1986-12-04 02:06:22', '2017-11-23 18:36:57');
INSERT INTO public.magasin_inventory_stock_items VALUES ('d191b3ad-ec32-40d8-b1a4-b5e3d3e6cbac', 'e86bd46d-09b6-43ad-b3d3-e07ee85a1144', 12469, '1989-08-30 08:01:27', '2008-01-13 11:19:32');
INSERT INTO public.magasin_inventory_stock_items VALUES ('83acb4da-935f-420d-b21f-1346aefdc6b3', '59e96762-ce29-4e85-b066-151eed980b79', 20430, '1985-09-04 02:35:01', '2017-06-22 03:58:22');
INSERT INTO public.magasin_inventory_stock_items VALUES ('c7e914ea-5fa8-4072-8a35-9146c7160342', 'ad130cc5-ac01-42fd-81ee-850e5107e749', 8275, '2008-10-29 20:51:04', '1986-03-01 13:40:01');
INSERT INTO public.magasin_inventory_stock_items VALUES ('b793c7d5-16f5-4b00-9ab7-3f5755b1f5b1', '8e9dc529-21e5-4151-aa03-0973467866e0', 2691, '1981-02-07 08:56:54', '1988-07-25 07:39:50');
INSERT INTO public.magasin_inventory_stock_items VALUES ('da3808d1-a775-4e9d-acfb-48ff21786dd4', '68cbf320-1cb9-4ce1-b015-09a320281b0a', 20245, '1991-12-09 13:00:30', '2012-10-26 00:10:56');
INSERT INTO public.magasin_inventory_stock_items VALUES ('b0978432-8f90-4912-a266-75353a9d039f', 'aa0e3cfa-1e3f-4e8a-9653-18f2f50a6dff', 241, '2017-07-18 05:16:39', '1987-01-12 20:35:57');
INSERT INTO public.magasin_inventory_stock_items VALUES ('94e8335c-f21e-4f97-8bc2-57648dbc550d', '9c8a0141-bda2-43a6-b9d2-00d83cf7e741', 24936, '1996-07-19 07:36:01', '2016-07-19 18:29:29');
INSERT INTO public.magasin_inventory_stock_items VALUES ('4f570e07-abbf-4e64-b1ab-741484d2c41f', '31fee607-26c4-475c-97c8-d170c4ffeb36', 462, '2016-07-06 10:44:26', '2017-10-16 12:52:52');
INSERT INTO public.magasin_inventory_stock_items VALUES ('9a191cc3-5e18-4f2f-8f70-ccf1754e846e', '28469e08-c392-4c62-8c8a-f18df81d0c65', 28508, '2008-08-21 03:52:02', '2010-01-19 05:27:44');
INSERT INTO public.magasin_inventory_stock_items VALUES ('50703c59-fccd-4e49-b9e1-4b9ea4175fe0', '634f96fc-27a6-4e0c-9b64-a6dee1eeac48', 10813, '2008-06-23 03:51:59', '1984-10-10 09:15:18');
INSERT INTO public.magasin_inventory_stock_items VALUES ('f7a901bb-8c90-4ceb-88a0-20824d921dbc', '6cbde11d-fbc7-4155-bf2f-6d9d898d0460', 13332, '1998-11-30 12:17:39', '1984-01-27 05:14:31');
INSERT INTO public.magasin_inventory_stock_items VALUES ('80ed3079-58e2-4a54-826d-4c4974876e99', '524351a1-62ac-49c2-bc00-09e711e78522', 22268, '2015-09-25 07:13:41', '1999-02-23 23:01:04');
INSERT INTO public.magasin_inventory_stock_items VALUES ('41ffd85a-f279-496a-bd51-8d1b19996a5a', '87ad07b9-401e-469a-ab25-d28a53bd01ca', 2206, '1994-03-22 08:38:51', '2013-04-28 20:43:24');
INSERT INTO public.magasin_inventory_stock_items VALUES ('9ae9d23b-af2a-4e81-ba82-52f21f118781', '274af368-98f8-47ba-9969-b055f51135d0', 29678, '1996-03-30 17:07:23', '1990-10-29 19:57:00');
INSERT INTO public.magasin_inventory_stock_items VALUES ('780d6559-08e1-4e2f-8d2d-4f06d62fa34e', 'a1dd709b-6736-473a-9330-34d33352988d', 27826, '2013-09-20 21:01:06', '2016-06-25 08:53:06');
INSERT INTO public.magasin_inventory_stock_items VALUES ('4bb9f0f3-696c-43c1-9fe5-32c06b57766c', '013d05c2-a6e0-4f8d-9bdf-eb1c969cd89a', 24529, '2012-10-22 14:31:48', '1990-09-06 06:42:17');
INSERT INTO public.magasin_inventory_stock_items VALUES ('829e36d9-ee7a-42a2-bb69-4fbe261cd355', 'a2a66a72-e4b8-400a-9e74-cc897fa76dbb', 14552, '2019-04-17 09:52:37', '1989-02-13 16:00:01');
INSERT INTO public.magasin_inventory_stock_items VALUES ('d9555642-b65f-4fc5-b3b5-254ab5949a3c', '9c2063ec-61ea-4087-af26-270adb413735', 17289, '2016-02-23 02:08:37', '2013-05-11 23:52:48');
INSERT INTO public.magasin_inventory_stock_items VALUES ('4cd261ee-b9e1-4017-ba9d-9beb3686d115', '1bedd7c6-a82a-4f90-b729-16a1ffaff9a6', 27556, '1993-12-28 06:53:24', '2017-08-08 22:33:23');
INSERT INTO public.magasin_inventory_stock_items VALUES ('5656ae79-79d2-498d-bb49-c9e49da944e6', '7246ed6b-4e5f-4919-a23a-c4d920f1b22e', 26543, '1985-11-23 22:50:06', '1995-01-07 18:44:57');
INSERT INTO public.magasin_inventory_stock_items VALUES ('423a254f-d791-41bc-a192-dbcbb1f8210c', '04a48663-7d35-4b90-9571-c8f529c3f9ba', 24699, '2001-04-23 22:43:50', '2019-07-28 16:35:48');
INSERT INTO public.magasin_inventory_stock_items VALUES ('6a41de93-aaa0-4422-9669-7bf3a3ffe4f0', 'b7dccd04-51a6-4c92-8339-813ff457965c', 18502, '1989-11-04 08:34:48', '2002-09-03 10:42:25');
INSERT INTO public.magasin_inventory_stock_items VALUES ('61b95fee-a120-4277-963a-55728e3ed200', '94af4323-0782-42f5-86db-03b3b1991c4e', 32436, '1987-09-13 00:58:08', '1988-01-14 10:08:04');
INSERT INTO public.magasin_inventory_stock_items VALUES ('0b5560ed-2b6d-4faa-9c01-45ede58ada82', '818f544d-332c-43ab-90a8-b2c79593014b', 29612, '1985-12-31 08:49:53', '1994-08-23 02:54:28');
INSERT INTO public.magasin_inventory_stock_items VALUES ('bc0ee150-80b8-45d8-bf34-fbdf0882c0d1', '28f2867e-6fb0-43c5-a05b-cee71ef95b39', 6312, '2016-09-23 12:34:34', '2004-08-19 06:59:09');
INSERT INTO public.magasin_inventory_stock_items VALUES ('2b253e39-18fb-4566-8b71-be5d83f046c4', '5efd4c05-944b-4399-a1de-dc3b0788357e', 6019, '2002-10-10 08:59:40', '2016-04-11 21:41:26');
INSERT INTO public.magasin_inventory_stock_items VALUES ('ec604653-704a-4d50-895b-49bcebaef6e7', 'ae41984b-af17-43f0-8caa-d9eb38b8a3f5', 4238, '2017-12-16 08:07:58', '2008-10-02 09:59:42');
INSERT INTO public.magasin_inventory_stock_items VALUES ('3cc6f10c-b60c-4ca9-aa52-a9debfddf0c0', 'b13333c6-2602-4993-9009-a3750c706696', 25546, '1984-05-06 06:13:58', '1985-04-09 17:27:22');
INSERT INTO public.magasin_inventory_stock_items VALUES ('a83732d5-62ef-4b1c-b5c8-57100330e24f', '5d117a00-c746-4b31-9b8d-e9f05ba868af', 19166, '1988-10-17 09:15:58', '2001-04-18 00:54:32');
INSERT INTO public.magasin_inventory_stock_items VALUES ('8982c233-e38c-405b-b460-0ab361a78269', '18b9cffe-038a-4b29-acfe-0b2f55f053d0', 8421, '2017-07-15 18:08:51', '2000-10-13 19:33:41');
INSERT INTO public.magasin_inventory_stock_items VALUES ('c525eadd-fdb0-4d7b-86b5-0f6dd13f5e0e', '156aeb52-4997-404c-a14e-60b20bd7da5e', 948, '1988-01-01 14:24:56', '2015-10-21 20:37:54');
INSERT INTO public.magasin_inventory_stock_items VALUES ('bf738511-37fa-42c8-a55e-7802f27d375f', 'd0560496-cc73-4b3d-b7bf-11e62f529d71', 2496, '2014-09-24 05:22:29', '2004-04-07 15:08:52');
INSERT INTO public.magasin_inventory_stock_items VALUES ('a43531ec-be02-422d-9723-ae176039efa8', '97f30df5-1da9-45ef-a87d-7a74ef2a2bd5', 17647, '1986-04-27 03:56:26', '2009-02-28 00:53:36');
INSERT INTO public.magasin_inventory_stock_items VALUES ('7a10a47a-a949-47e7-9711-acd2581e079d', '48ec582c-d18d-4f97-97c7-5d2debfee8a1', 25360, '2004-01-05 15:48:40', '1996-01-28 23:55:13');
INSERT INTO public.magasin_inventory_stock_items VALUES ('1df85d47-c9c9-4329-95c0-0bf770e31768', '3cdcd863-c0df-4af3-babc-46a61afc90f8', 26574, '1993-07-29 02:23:27', '1995-03-06 12:48:24');
INSERT INTO public.magasin_inventory_stock_items VALUES ('5719b6f7-5f09-4605-ba30-c57252055510', '1a339511-1cd3-4d1d-bc78-2e21e47afbd4', 20767, '1980-02-14 09:24:53', '2008-06-18 17:11:54');
INSERT INTO public.magasin_inventory_stock_items VALUES ('45b021f6-4f70-485e-9b13-4500c64f961f', 'e46909f9-55b6-457c-a356-63f83aa05ef8', 5576, '2010-09-25 04:33:11', '2003-02-04 19:32:05');
INSERT INTO public.magasin_inventory_stock_items VALUES ('6d49db54-f140-4e6a-b221-2f9db56206b6', '5b6421f0-e628-4ac9-a903-87b066cf6444', 2425, '1991-06-14 17:16:57', '1995-11-27 00:00:17');
INSERT INTO public.magasin_inventory_stock_items VALUES ('37a26c2d-6def-4c63-a3e9-11cd73cf024d', 'af36365b-0738-46e2-ae57-a367cb16dc88', 14509, '1982-07-09 03:44:00', '1992-09-13 21:03:31');
INSERT INTO public.magasin_inventory_stock_items VALUES ('89924010-f6ce-44a0-a115-c7ca28d50b96', '5e3349a6-4eb3-4ab0-9001-2f304c1843d6', 13606, '2000-03-20 08:03:32', '1988-10-31 16:29:37');
INSERT INTO public.magasin_inventory_stock_items VALUES ('272eb06a-9d5a-4e7a-ae05-d49f271791d9', 'c04759a8-89d6-487f-b252-7114017b035c', 6806, '2017-02-04 23:37:29', '1993-03-12 12:22:07');
INSERT INTO public.magasin_inventory_stock_items VALUES ('25594b03-b280-42fc-8b17-3422c7665a1d', '0094a3b4-dfec-495c-a74f-d8dc211e8c85', 13910, '2006-04-03 09:43:57', '2013-06-30 13:32:46');
INSERT INTO public.magasin_inventory_stock_items VALUES ('48584871-ad98-4e97-8c46-e5ce1dd34181', '67660a65-ab82-42a3-bc5b-60f3536c0762', 5711, '2007-03-27 05:45:32', '1994-03-09 20:13:42');
INSERT INTO public.magasin_inventory_stock_items VALUES ('fed62cbf-acd0-40a4-9373-044378926cf4', '172b62d1-91a8-4b61-a702-d1fd443ecbdd', 7274, '1993-05-19 16:59:22', '1980-06-23 19:27:30');
INSERT INTO public.magasin_inventory_stock_items VALUES ('0719c290-9a10-41b1-a405-be5f20709889', '5496e789-c169-446e-b5e7-ebcf11f29b8c', 17570, '1985-04-19 10:01:53', '1984-04-11 16:03:44');
INSERT INTO public.magasin_inventory_stock_items VALUES ('4ee70ca7-4bbd-443f-b6f3-1965579dbd92', '8f581709-d11c-4f3b-9401-67a586ff096c', 6227, '1993-02-07 14:18:00', '1994-06-21 02:36:05');
INSERT INTO public.magasin_inventory_stock_items VALUES ('20425fd0-f5fb-4610-a181-3edf3915eda0', '0d3a7fb0-1dda-4d4f-988d-9d2beb8ba3e2', 22120, '1994-07-02 00:11:03', '2007-05-06 03:24:32');
INSERT INTO public.magasin_inventory_stock_items VALUES ('645ae072-eb3c-4d86-963d-4beadaafa29b', '7a519f6a-7c44-4288-b911-726e2115a5c9', 8447, '2000-07-23 00:23:27', '2001-04-15 04:45:27');
INSERT INTO public.magasin_inventory_stock_items VALUES ('42854e73-2915-44f6-982f-74c47d0cd5c7', 'a6cc6a6b-7f89-4917-bdb2-d827827388a2', 22109, '2017-06-02 18:10:42', '1996-06-10 13:30:36');
INSERT INTO public.magasin_inventory_stock_items VALUES ('2d1f7743-48c6-404c-8d50-0a31be9d472c', 'f91b5bd1-24b7-489b-a452-d101afced0f8', 14805, '1986-06-01 06:19:06', '1990-05-30 20:11:02');
INSERT INTO public.magasin_inventory_stock_items VALUES ('2418c8bd-3bda-489b-8239-661ca77e56bc', '95e081bd-fd94-40be-b6fa-8c1066e58cc4', 26278, '1990-09-16 23:57:39', '1981-09-07 03:43:35');
INSERT INTO public.magasin_inventory_stock_items VALUES ('c5a5098a-3b42-4e19-8c9b-7f6db2db11a0', 'ccce77b9-373b-4953-af29-8a6f76528fc7', 32409, '1994-08-20 09:05:24', '1992-05-24 17:43:55');
INSERT INTO public.magasin_inventory_stock_items VALUES ('56bcf7f3-91c6-43b5-8bab-2715f5d85c19', '8b6e67c6-703c-475b-a182-f8924632ee7a', 627, '1986-09-23 23:14:19', '1995-08-23 18:09:50');
INSERT INTO public.magasin_inventory_stock_items VALUES ('11acc2db-2a2b-4cb3-9fd2-8f499d763b6a', 'a221e636-2708-4427-af83-0095cded09cc', 21384, '1983-10-15 10:33:14', '2008-09-29 23:33:08');
INSERT INTO public.magasin_inventory_stock_items VALUES ('2b306525-3def-4fb1-97d5-dafe97817507', '5017eb1f-9053-4443-ae2d-f2ee4ccedc85', 18746, '2000-06-14 19:40:43', '1981-08-08 12:33:12');
INSERT INTO public.magasin_inventory_stock_items VALUES ('eb3d6386-a233-47b8-8aad-d7340a1293db', '82c36c2e-4d1b-4474-b9b6-7551edcbe67d', 772, '2010-09-04 16:42:07', '2001-05-15 07:30:10');
INSERT INTO public.magasin_inventory_stock_items VALUES ('0deac991-b25b-4d0b-a04a-0dc13083c41b', '48ca0c58-f221-4dbf-849d-3bbe6ed885e9', 19876, '2013-08-24 16:07:35', '2000-08-25 10:41:22');
INSERT INTO public.magasin_inventory_stock_items VALUES ('e02f0dc2-4f97-428f-ad03-634ee7f90d14', '4c90df88-80e1-4903-a7d9-26662d655fbf', 30904, '1997-04-01 01:33:13', '2009-09-17 02:58:00');
INSERT INTO public.magasin_inventory_stock_items VALUES ('e7896ffe-8b45-4a44-a811-c1a2e6159bab', '630587cc-f5b6-4663-ab42-db721b6b5c26', 23412, '1984-05-21 17:26:36', '2014-09-07 13:13:02');
INSERT INTO public.magasin_inventory_stock_items VALUES ('fe7175e0-48ff-4430-b4d7-7df32eef15e3', '14f7d5f4-64f8-4467-990e-c31303aafbdb', 13715, '2012-02-13 04:27:55', '2000-04-16 16:05:45');
INSERT INTO public.magasin_inventory_stock_items VALUES ('e8bde4fe-f92a-4a51-919e-676a78feed29', '0b80ca12-d604-49ea-bde3-ade62736bb0c', 14485, '2000-10-15 18:20:30', '1986-08-18 23:06:07');
INSERT INTO public.magasin_inventory_stock_items VALUES ('1ef36dfa-e6c0-4c62-a47d-8b5772dff513', '0104d68a-12c3-4d8e-9a57-d9429a485403', 331, '1997-02-14 19:16:16', '2016-06-04 20:55:20');
INSERT INTO public.magasin_inventory_stock_items VALUES ('ca0c11bd-3b20-4dfe-a4cd-d27a0d8317f3', '5501bfe7-0120-4600-b103-ee8a2aa778c8', 18982, '1994-10-03 20:14:55', '1990-08-22 00:03:44');
INSERT INTO public.magasin_inventory_stock_items VALUES ('07fc1d65-0c95-4d1e-82a7-57d62ab3684e', '4f9cd254-4886-4119-8e7a-ec90f5c6110d', 30761, '2000-04-25 09:46:39', '1999-08-03 15:01:54');
INSERT INTO public.magasin_inventory_stock_items VALUES ('7a643a61-5557-4905-a641-06b6676b5cb0', 'b4ad7aa7-c4c4-411f-b037-75769d940fa2', 8384, '2016-01-14 21:25:23', '1984-01-22 22:28:33');
INSERT INTO public.magasin_inventory_stock_items VALUES ('60dabfd2-ff2b-41ba-8654-23092fe730f2', '213a24ef-34d6-42a5-82aa-d8999372bcae', 15136, '2013-04-22 20:20:54', '1993-06-13 15:52:34');
INSERT INTO public.magasin_inventory_stock_items VALUES ('a279b86d-c692-4b9b-9e17-339a8335e33e', '9db51402-d7e4-4b7a-aed4-7d923158c719', 21885, '2008-08-27 10:35:58', '2012-10-21 20:35:26');
INSERT INTO public.magasin_inventory_stock_items VALUES ('079a3293-8644-4e39-a0a4-c422b2989841', '91d4228f-ad12-4694-aada-9e81ec0fe81b', 127, '2017-04-08 20:36:10', '1988-03-03 20:06:32');
INSERT INTO public.magasin_inventory_stock_items VALUES ('8047e7c9-7821-456f-8602-9cbae114749d', '3b70f33a-6968-46ab-9bb4-e334daa255c4', 24802, '2010-04-20 05:56:14', '2019-04-28 08:00:00');
INSERT INTO public.magasin_inventory_stock_items VALUES ('d9a8d5fb-8f3b-4159-b58c-638cab0c547f', '00738905-0272-46f9-bd05-261c61846c12', 11817, '2016-10-26 12:26:12', '1984-05-21 15:02:06');
INSERT INTO public.magasin_inventory_stock_items VALUES ('65bb7832-247b-4695-85d3-6ccaedcde83a', '56a6515b-8972-4f90-82c4-b99d2e5bf099', 11342, '1992-10-08 23:45:56', '1982-06-02 10:38:18');
INSERT INTO public.magasin_inventory_stock_items VALUES ('87fa43f9-800a-418a-89f4-99d415079b20', 'fec872f9-af64-463a-a34d-397c5de623d3', 1982, '2010-03-13 03:19:24', '2016-06-24 07:59:01');
INSERT INTO public.magasin_inventory_stock_items VALUES ('8e46ff94-0d70-4f48-974a-adabe5d5397f', 'a2406563-60ed-4d72-b22f-b33ff7e3d035', 23523, '1981-10-28 01:39:57', '2016-11-27 07:04:03');
INSERT INTO public.magasin_inventory_stock_items VALUES ('9d330a30-3ae1-49e8-b69b-18bcaa77c7ee', 'cad166f5-50f1-4896-a4be-f53e2c7f80b8', 10183, '2005-10-04 11:07:17', '1990-08-11 10:57:36');
INSERT INTO public.magasin_inventory_stock_items VALUES ('df796814-dff7-47a6-877e-faa4ceb62a82', '98cb912b-8df3-4608-ba0b-5e8b2863832a', 21770, '2003-11-10 00:25:19', '2017-04-19 04:24:17');
INSERT INTO public.magasin_inventory_stock_items VALUES ('ff418e78-614b-4f68-897b-0c3e16712cef', 'f81f9f7e-b5dd-4956-88c3-4784fdeb06f7', 23898, '1989-10-21 14:05:50', '1999-02-16 23:26:26');
INSERT INTO public.magasin_inventory_stock_items VALUES ('711a4909-e3d9-4156-923d-4e6d5f01ccd3', '06a6d20d-a230-4ed3-a3c2-422c5f66a489', 14167, '1991-09-01 05:43:23', '1981-02-14 05:18:15');
INSERT INTO public.magasin_inventory_stock_items VALUES ('9f1d2e3e-2b81-400b-b89d-441e99efdff3', 'f7394394-afab-4c0e-b35c-3e682a8dc71b', 2650, '1993-12-07 11:49:33', '1981-09-18 19:14:59');
INSERT INTO public.magasin_inventory_stock_items VALUES ('57804c72-0f01-4843-bdc1-5966cd3cf4a2', '4477a787-7222-4c11-a2a0-bacfb95a6b4b', 21386, '1987-04-29 15:13:00', '1983-07-26 00:39:59');
INSERT INTO public.magasin_inventory_stock_items VALUES ('cfd0f68d-14ac-4d10-948d-334e1308d428', 'dba88a91-739b-4af2-8d92-acdd5e856f7c', 20719, '1981-12-01 06:49:17', '2011-12-08 06:32:48');
INSERT INTO public.magasin_inventory_stock_items VALUES ('78cd88dc-158f-493a-882a-ece9a836ad0d', 'ab87bef9-ade3-4c39-ba38-d76d893bdd2a', 15043, '2009-09-29 08:07:16', '1980-02-02 12:45:32');
INSERT INTO public.magasin_inventory_stock_items VALUES ('8b3d040a-70b8-4303-bca3-5ca92497fc49', '4fbc40fc-c62f-4dd3-a8c7-856c00d0bf9a', 1315, '2001-02-17 02:58:16', '2005-01-09 17:41:10');
INSERT INTO public.magasin_inventory_stock_items VALUES ('18263045-1d83-486a-8755-d9f1471de009', 'f89bb25f-8abd-42d0-b38a-507200494053', 512, '2006-08-09 03:15:53', '2017-03-14 13:28:33');
INSERT INTO public.magasin_inventory_stock_items VALUES ('d6542bf5-7e58-480d-a36b-e544da021d29', '52ae0d09-8526-4113-b9f4-ac89a12d0595', 10014, '2019-08-21 02:15:10', '2000-03-09 17:43:50');
INSERT INTO public.magasin_inventory_stock_items VALUES ('5afa9155-fe97-4805-b704-83328ceeed85', '1be5923d-e390-49f3-a373-444dc55feeea', 106, '2009-09-30 22:24:40', '1996-05-15 08:23:06');
INSERT INTO public.magasin_inventory_stock_items VALUES ('dc44a606-20a8-4e0c-aaca-d166583d652a', 'ac41ecf3-ec31-4bcc-a05d-07eac21b35c8', 18953, '1995-02-09 20:40:01', '2011-07-11 19:59:59');
INSERT INTO public.magasin_inventory_stock_items VALUES ('85913c6f-0f4e-40ea-bf30-4b67ca46aa59', '123aacac-c174-44ad-9033-da7097273f55', 3939, '2019-08-22 05:22:38', '2013-01-29 22:49:25');
INSERT INTO public.magasin_inventory_stock_items VALUES ('fba565cb-2356-4538-ba88-f163144773fe', 'bdabecbb-16d7-4041-beea-d4f893f63175', 637, '2002-08-22 13:20:43', '1980-04-03 19:35:08');
INSERT INTO public.magasin_inventory_stock_items VALUES ('d2f33b85-fa43-487e-b058-d3524f16e6b8', 'b2414b3f-a288-4c4b-a6b6-14cb98f04f67', 17955, '1989-02-05 17:42:43', '2016-05-27 12:00:19');
INSERT INTO public.magasin_inventory_stock_items VALUES ('4620de07-c137-4248-bce1-af85519d1cbd', '7d7102b8-5579-4ee5-a753-ddd94277d91f', 1702, '1989-05-05 07:00:20', '2012-07-11 15:43:02');
INSERT INTO public.magasin_inventory_stock_items VALUES ('3be43ddf-c0a8-47a8-94c1-a6d6e705722c', 'ae1741e3-f9e1-4655-84cf-53508acd834f', 11882, '2015-11-27 16:12:35', '2016-01-06 08:43:09');
INSERT INTO public.magasin_inventory_stock_items VALUES ('0eb37d92-6fd5-4266-a9f5-bf7e1b99b649', '70743109-5b77-498a-bea8-dacc376746a6', 26993, '1987-02-24 14:54:32', '2015-04-02 10:28:51');
INSERT INTO public.magasin_inventory_stock_items VALUES ('9363ed8c-1085-4645-bf1e-4a849050ef6b', '9d9ce965-9b1d-40e1-b78f-7edc20683432', 11878, '1999-06-30 03:28:56', '2000-09-07 21:27:07');
INSERT INTO public.magasin_inventory_stock_items VALUES ('17c63925-d751-451c-896b-9b0764caf905', '318c905a-12f2-458c-92cf-da0f4b465f69', 29449, '2004-07-07 22:05:10', '1985-06-17 16:37:48');
INSERT INTO public.magasin_inventory_stock_items VALUES ('a75c3a6f-e575-4a89-bea2-efd7c48df6f6', '10676fa1-6d8c-48c0-9fda-6e6770aa381c', 32647, '1980-09-25 04:37:47', '2002-08-20 21:28:14');
INSERT INTO public.magasin_inventory_stock_items VALUES ('930e752c-d472-4d3c-bb92-9d8ac61c2a35', '4402e8e3-81f3-4819-9a72-c330c8582239', 11205, '2006-12-05 03:41:23', '1990-01-01 09:42:30');
INSERT INTO public.magasin_inventory_stock_items VALUES ('b2504d30-f8d7-4385-951d-47fba3fa6412', '82c9231f-2fd0-4569-9a8c-cca79c212540', 18887, '1997-08-07 06:15:27', '1998-01-21 18:29:30');
INSERT INTO public.magasin_inventory_stock_items VALUES ('6a157334-fe38-49f3-a4a1-b176f3349799', '04aeb187-d04f-4604-bb3f-bd3ca70a4f3c', 7013, '1996-01-12 01:27:14', '1991-01-11 03:47:13');
INSERT INTO public.magasin_inventory_stock_items VALUES ('c52b4a75-eee0-4f8f-9caa-a2747d833d14', '0fac8951-eb8d-49d0-978a-10f56240ef3e', 29490, '2018-01-26 06:32:53', '1985-06-08 09:41:07');
INSERT INTO public.magasin_inventory_stock_items VALUES ('b15598d6-a37e-4193-b66a-598df6ce1c78', '61a9eb2a-3926-4994-a820-5ccc06d54611', 2178, '2017-04-29 13:01:36', '2005-11-27 02:55:43');
INSERT INTO public.magasin_inventory_stock_items VALUES ('031ef299-9516-4b2e-9e78-510adb37de62', '22876e2e-f341-4b4a-b41c-eb336da6ee34', 18741, '1992-08-22 16:59:57', '1980-09-29 20:33:14');
INSERT INTO public.magasin_inventory_stock_items VALUES ('eea865b3-d206-4dfa-9bd8-8e8609489151', '7968a7c5-6066-497e-950a-ee1c4c665420', 29987, '2001-11-27 09:22:50', '2007-05-27 06:29:47');
INSERT INTO public.magasin_inventory_stock_items VALUES ('62525581-60c6-4d1b-874d-b5a8edfc4f7c', '3a4cac75-7060-4c50-851f-417b0d535730', 13622, '2010-02-17 04:43:59', '2001-02-25 05:56:41');
INSERT INTO public.magasin_inventory_stock_items VALUES ('4e9e9456-a3ee-4f75-bb3f-6ceda23de848', '20dc4ef0-bc8d-40b2-9fa3-ae7a61508f21', 14878, '1984-01-23 08:25:29', '1982-04-16 19:10:50');
INSERT INTO public.magasin_inventory_stock_items VALUES ('944a97f6-5756-4d48-9424-622545c689a5', '28bac176-058a-4e76-b412-9d831cf50042', 11311, '1987-07-21 03:16:00', '1998-02-08 06:15:13');
INSERT INTO public.magasin_inventory_stock_items VALUES ('0174468f-e6f4-4cf3-8d7f-669e296a5d6c', '9b28ea7f-27d5-46b5-9890-ba1ba8939d6b', 12319, '2014-03-27 01:25:18', '1987-12-18 23:00:28');
INSERT INTO public.magasin_inventory_stock_items VALUES ('f64f459e-d2bc-4a17-a455-dcfdc44f9640', '2757c5b8-cbcc-4857-9379-022399881304', 22267, '1993-08-31 14:38:51', '1991-12-17 13:33:55');
INSERT INTO public.magasin_inventory_stock_items VALUES ('8880f62c-3781-438c-a618-23c7fbd373f3', '5886c176-c5c9-44c5-abee-cddb50713585', 14631, '2016-04-16 16:06:15', '2013-06-03 13:30:01');
INSERT INTO public.magasin_inventory_stock_items VALUES ('993d70c5-776a-4252-81a9-005507371620', 'cc3600dc-9931-4234-ba0b-44937abd6d9b', 6450, '2017-05-20 20:48:48', '1993-06-01 05:46:45');
INSERT INTO public.magasin_inventory_stock_items VALUES ('cdd6917c-e18d-4458-90c8-33ebf90dafb1', 'c2ac55cc-740b-4ba3-a534-7d829d1c5a30', 4260, '2000-08-17 20:26:53', '1991-03-04 16:11:38');
INSERT INTO public.magasin_inventory_stock_items VALUES ('cc2c57b9-ad4d-477c-a94f-d5a676ce87ee', 'cb7a0818-4f5b-4f0c-9d5c-f59d460c9f1a', 30450, '2010-08-17 18:00:00', '1997-03-18 23:18:03');
INSERT INTO public.magasin_inventory_stock_items VALUES ('9633a7e6-ad74-47cd-a9c6-d53da32aa78e', '27016046-8d11-4cc5-9b13-bdb591df7df8', 3318, '2012-06-07 03:25:01', '1995-01-28 06:24:15');
INSERT INTO public.magasin_inventory_stock_items VALUES ('9d2164c0-2b80-431c-90e8-04c89dd6849d', '596cf2ce-c316-4250-9e89-7f3e0397ad05', 215, '1991-09-07 01:23:21', '1981-11-19 10:56:29');
INSERT INTO public.magasin_inventory_stock_items VALUES ('cda05cf9-6348-40e9-a7ab-82d80555a13c', '7dfd58e4-36f1-4cb0-a2c3-c4689a018010', 18213, '2009-05-08 22:46:42', '2005-05-06 23:03:50');
INSERT INTO public.magasin_inventory_stock_items VALUES ('6c3abb85-cefc-47c0-b7b8-7fb28739b615', '8a1f69bf-77b5-4663-a2f2-88d3f7ebc8f2', 8985, '2007-06-01 20:46:39', '2002-06-17 09:43:26');
INSERT INTO public.magasin_inventory_stock_items VALUES ('5cd7aae1-fba6-47e2-84b9-cd8895d296fc', 'cb3d682f-de7c-4ac3-b6a3-65eb3872fd88', 14142, '2018-05-15 14:37:03', '2017-09-24 13:47:10');
INSERT INTO public.magasin_inventory_stock_items VALUES ('fac648e6-c756-45f1-b001-3d768fbffb9f', '67c71a91-bfa5-4d7f-8c26-559c0e81c293', 13992, '2017-12-31 04:03:07', '2007-06-16 14:01:21');
INSERT INTO public.magasin_inventory_stock_items VALUES ('3a0f16f7-ed49-4795-9fa7-e6dc24eddc2c', '7d35a5f7-697d-4fc6-a1e7-2cd09e3d0364', 27038, '1990-03-29 04:46:29', '2001-06-08 13:35:46');
INSERT INTO public.magasin_inventory_stock_items VALUES ('90968410-334e-468b-b0d5-8d61be51becf', 'c3fa74e9-6ecd-4c9f-9840-1b7084f6c1d7', 25154, '2011-12-10 22:41:27', '1986-04-21 18:38:45');
INSERT INTO public.magasin_inventory_stock_items VALUES ('b5597999-3a90-4352-816f-386f5c73a481', 'd7b6c471-ea6a-477f-a6be-7db1e2879e40', 30441, '1981-05-22 19:29:31', '1995-01-06 07:23:57');
INSERT INTO public.magasin_inventory_stock_items VALUES ('aeb88f53-ecf7-442f-8e8a-1ce59012adbf', '40e965b8-6d31-4e72-bd40-214777ae9154', 16546, '2010-09-03 09:41:58', '2010-11-09 21:43:49');
INSERT INTO public.magasin_inventory_stock_items VALUES ('bcb2bf1b-7a4e-41ec-b419-1705d82655d7', '4c98813d-9181-42f4-8e02-52c8b6988238', 11615, '2010-10-12 09:44:22', '1996-09-11 11:48:47');
INSERT INTO public.magasin_inventory_stock_items VALUES ('6d28b30a-2143-48d0-b607-f2ee5919eb82', '210c68c2-2b36-4425-93d6-da48ebf66b12', 8923, '1990-01-20 18:09:02', '2014-05-12 09:22:21');
INSERT INTO public.magasin_inventory_stock_items VALUES ('af125ca2-b3bb-4b6a-a06b-8015531add40', 'fef5432b-afcb-4fae-8888-b17816d839fe', 11674, '1987-12-04 14:10:20', '2012-03-18 09:15:14');
INSERT INTO public.magasin_inventory_stock_items VALUES ('af4d415f-88f5-453b-bbc1-a397e77d65b4', '74da7e2c-a72a-4f06-9b93-23b8753f5fba', 17637, '1980-07-19 08:39:37', '2014-02-03 23:24:00');
INSERT INTO public.magasin_inventory_stock_items VALUES ('fc836191-e47f-4c74-b5a9-677d86e64f3e', '3221fdd4-68b5-46cc-b0fc-e088b7435702', 13515, '2016-02-27 06:40:41', '1998-04-29 07:15:05');
INSERT INTO public.magasin_inventory_stock_items VALUES ('85fdfaa4-92ca-41ac-bd8a-211d06245ac9', '762720f7-6fe0-4966-9e6e-7ae7cce0e97b', 8462, '1988-08-30 20:57:49', '2000-07-25 15:10:14');
INSERT INTO public.magasin_inventory_stock_items VALUES ('aa0ae1ac-25a8-419f-ba0c-76238466b8dc', '512ccb6e-08fd-4566-bdaa-319fc46fd2da', 16780, '2005-04-11 08:00:50', '2013-06-16 07:32:10');
INSERT INTO public.magasin_inventory_stock_items VALUES ('0a2279a0-9bee-4b0c-b7a9-5292421a78a7', '554c0a79-f00e-4453-8cba-cc1d95e97085', 27504, '2000-06-26 10:04:00', '2016-11-11 03:17:32');
INSERT INTO public.magasin_inventory_stock_items VALUES ('09232a59-f3db-471f-bb26-014f20f9620e', 'b6ceec29-64e1-4918-a38e-242b9c32bcca', 27683, '1992-08-04 03:33:43', '1989-07-06 11:07:57');
INSERT INTO public.magasin_inventory_stock_items VALUES ('ecd47cf3-5a2f-47d5-9572-b7cf39e54d8b', 'dd6ae1c1-08a9-4a7b-a623-4554712df558', 1397, '2004-01-05 21:16:23', '2009-11-09 07:03:57');
INSERT INTO public.magasin_inventory_stock_items VALUES ('b56f4d83-dd9f-4470-b2fd-c431015b9c35', 'cedef0b7-9d20-408f-94e9-3ca8c13eeebf', 23726, '1993-02-12 16:03:59', '2010-12-08 02:04:35');
INSERT INTO public.magasin_inventory_stock_items VALUES ('befe9972-4040-409a-83af-9b0e97f4fceb', '575fb67a-b52a-4c55-a93d-52c2bef97ae9', 18609, '1999-02-12 23:14:55', '1986-12-15 18:05:17');
INSERT INTO public.magasin_inventory_stock_items VALUES ('6c95030f-6bec-4aa2-b89f-8288c9a5f81b', '65cda570-211d-4328-8ba1-1255454565dd', 11697, '1990-02-21 04:02:20', '2008-06-17 10:20:52');
INSERT INTO public.magasin_inventory_stock_items VALUES ('161afd19-50f0-4694-9e85-38534b35fb03', '1dd68c8f-b0cb-4e19-8ca6-349e02d2a6b8', 1675, '2005-03-07 11:30:59', '1994-10-27 10:11:29');
INSERT INTO public.magasin_inventory_stock_items VALUES ('687b0aef-7947-4d02-bb56-eb3f3e797eaa', '08af77b7-160a-47be-8545-e47a0b0e653d', 23889, '1990-11-13 22:34:24', '2019-03-24 10:52:58');
INSERT INTO public.magasin_inventory_stock_items VALUES ('2611ca56-4088-48b1-b97a-5d14aae10dfe', '554cd892-6bbb-44d4-b96b-5d3b5f089ec6', 28868, '2014-09-29 20:06:50', '2019-07-01 22:01:23');
INSERT INTO public.magasin_inventory_stock_items VALUES ('d46d7fa5-563f-48da-bd81-8630ab9545b2', 'fa4e13d1-a6fe-480c-a16a-85ee0437b28c', 25706, '2009-06-28 03:08:42', '1994-03-29 01:38:43');
INSERT INTO public.magasin_inventory_stock_items VALUES ('0a01866c-9a50-41af-8fc7-6dd420f1648e', '901f7b2a-fd17-4413-b2b9-25c62cf195d2', 31450, '1984-09-21 06:50:51', '2016-05-16 00:58:40');
INSERT INTO public.magasin_inventory_stock_items VALUES ('9dd84190-efec-4e58-93ef-ec2f6d42e371', '088d97ac-408f-4cb5-b9a4-e986ad6d83b8', 15014, '1993-06-07 18:20:31', '1982-04-18 16:10:38');
INSERT INTO public.magasin_inventory_stock_items VALUES ('41451634-83bd-45cc-9bad-9b56278ff4b2', '0e3164f7-5311-454b-9abf-f7ee9eef9481', 14176, '2002-06-27 17:17:16', '2014-11-05 15:29:22');
INSERT INTO public.magasin_inventory_stock_items VALUES ('52b54148-7a95-4e53-9b40-242751ff92e4', '83ad35b4-d06c-48af-a41b-0b1cb097528c', 31820, '1998-09-03 16:32:10', '2017-08-04 22:20:42');
INSERT INTO public.magasin_inventory_stock_items VALUES ('c5a4d0b6-3838-4125-8018-fb017b655528', '63aafd08-ec41-4fd1-a7ec-2d5ade843e0a', 10662, '2000-01-06 12:41:56', '2008-03-10 16:26:05');
INSERT INTO public.magasin_inventory_stock_items VALUES ('20a65a18-c464-4e65-8550-a6fc1316dd7d', '79db4308-20a2-41dd-afed-4a4d872d151e', 20112, '2010-10-30 01:25:02', '1988-01-31 23:56:52');
INSERT INTO public.magasin_inventory_stock_items VALUES ('f6ba84b4-c601-4680-a6df-1f9371b0c039', 'd4927d4a-9184-4e15-885a-f36e6185170f', 7332, '2003-12-12 13:30:05', '1995-08-03 21:03:41');
INSERT INTO public.magasin_inventory_stock_items VALUES ('f176ee86-51f7-449e-b827-59a0012153c6', '511e68f6-4b5c-4901-b71c-613cb0c63d21', 16465, '1992-05-12 18:55:38', '2005-03-17 23:33:58');
INSERT INTO public.magasin_inventory_stock_items VALUES ('918b24cc-d6a0-45d6-911a-2c13f90a0358', '911d4a62-78bc-4dd4-a4c9-690de917354d', 26673, '1989-07-20 01:22:20', '2006-10-24 15:35:42');
INSERT INTO public.magasin_inventory_stock_items VALUES ('c6dace81-c8ed-4a57-9165-b15cbbf1ef5c', '54e21701-51a9-4a52-945f-8b384f177030', 2355, '2013-11-10 06:05:19', '2007-11-13 00:16:23');
INSERT INTO public.magasin_inventory_stock_items VALUES ('b347629d-0a45-4331-b788-bbbe8f3a6353', '1e7837b1-91aa-405f-87cd-0e7223c34896', 3212, '2010-10-10 09:01:48', '2009-11-22 07:01:00');
INSERT INTO public.magasin_inventory_stock_items VALUES ('3b47dcb4-82ba-4b54-8549-6be5258525d2', 'b2ebc9d7-05dd-444c-923c-93b488c98e16', 23316, '1981-07-19 04:00:35', '1983-06-25 11:03:10');
INSERT INTO public.magasin_inventory_stock_items VALUES ('8a7ed601-97f8-4fa5-8cec-3c4cfb1e11b7', 'c8722e5f-9071-43d2-b05d-c59ea5ec6da9', 30992, '2017-01-13 07:35:28', '1983-05-29 08:42:25');
INSERT INTO public.magasin_inventory_stock_items VALUES ('04e61d7e-5991-42ba-82f9-8b0972035400', '77272c03-9a3d-48dc-acce-8f157ad292f7', 9298, '2009-08-02 11:08:31', '2005-10-13 10:59:44');
INSERT INTO public.magasin_inventory_stock_items VALUES ('cc440c47-fdc6-48b0-b47c-33b3f2fcddf3', '1b331113-fa0e-449e-a97e-9be883a8ff7d', 26880, '2013-06-03 00:45:39', '1986-02-01 02:02:47');
INSERT INTO public.magasin_inventory_stock_items VALUES ('3b8eb125-df3f-465e-9bea-50568564f534', 'd7cb419c-1ce8-4e78-b592-2e77e6fe8e14', 7341, '1987-08-30 05:09:20', '2003-02-19 23:21:08');
INSERT INTO public.magasin_inventory_stock_items VALUES ('66fb6af1-f45f-4c3c-b134-02a3c67a2719', '39bcf684-250f-4893-be44-58fa00d97491', 14445, '2000-12-30 15:35:22', '2014-02-05 22:23:50');
INSERT INTO public.magasin_inventory_stock_items VALUES ('2382c8aa-4590-454d-82df-5e4f2b6d4d1a', 'b54fb1fb-e99e-4ace-b287-baebd430d61f', 13076, '1987-05-06 19:54:28', '1993-09-11 04:52:31');
INSERT INTO public.magasin_inventory_stock_items VALUES ('1da86533-4389-475e-8f49-2376285e06d3', '89560cc8-89b4-4ab0-84d4-c682ef742097', 27108, '1998-01-09 18:42:08', '1987-06-25 13:53:22');
INSERT INTO public.magasin_inventory_stock_items VALUES ('a29fbe91-4e5f-45b9-8474-b68e74401bbb', '9a537746-b8ca-457d-9961-407b907a7845', 11474, '2002-01-11 05:15:25', '1995-02-17 23:17:04');
INSERT INTO public.magasin_inventory_stock_items VALUES ('4b579dfc-4908-405a-9a2c-7af6cee62354', '3978a89e-ca5d-4474-9806-114dcac5b0c8', 20248, '1984-07-25 06:08:10', '1991-05-24 19:33:19');
INSERT INTO public.magasin_inventory_stock_items VALUES ('c1c850d4-5dd3-4b48-8d74-dc37023aca49', '0172defb-4edf-4a5e-a2fd-0a15763e5cdb', 21799, '1991-05-27 06:25:33', '2016-11-20 08:38:55');
INSERT INTO public.magasin_inventory_stock_items VALUES ('5e5efd8e-dcbb-47a7-8e28-736b1aa6f372', 'b6414b2a-10b4-4e18-9798-380d85f95a5b', 31479, '2019-11-27 18:10:35', '1984-01-25 03:18:22');
INSERT INTO public.magasin_inventory_stock_items VALUES ('985f515e-1868-4f3e-a188-56b151210572', '912e5e50-258c-42da-b671-5467cd64e12a', 29932, '2003-06-25 23:54:58', '1982-09-28 08:02:33');
INSERT INTO public.magasin_inventory_stock_items VALUES ('a892daad-9a7e-4755-b909-1cfaa2cefc0f', '3ca2db3a-f394-468e-b82e-45af530a13f5', 23017, '2012-10-18 04:41:24', '1980-09-28 22:05:19');
INSERT INTO public.magasin_inventory_stock_items VALUES ('c2878911-c5ea-4a1a-a62e-2c2646564056', 'bd5daaba-6c88-4a83-b94c-d5acb984c870', 11496, '2005-11-26 14:01:00', '2008-07-08 13:41:11');
INSERT INTO public.magasin_inventory_stock_items VALUES ('53fb6fd0-8cc2-449a-93f0-c68919453c90', '8325abf5-045e-4acd-88e8-d44629b8b07f', 32117, '2016-05-27 05:39:50', '1997-07-24 18:31:06');
INSERT INTO public.magasin_inventory_stock_items VALUES ('987f93a1-574f-429e-9ea4-6aa4610128b5', 'a8cc0401-aa4f-46d0-9fdf-7ae6b12995b8', 17535, '1991-06-19 11:36:07', '2006-09-10 15:44:29');
INSERT INTO public.magasin_inventory_stock_items VALUES ('e3b4a5eb-7324-4049-8299-34f2faadd5d3', 'ec3f587d-3e3b-498e-b5da-cfa229b2c136', 14758, '1990-09-16 22:18:33', '2016-11-25 01:11:40');
INSERT INTO public.magasin_inventory_stock_items VALUES ('e0632b21-1903-4edd-838a-f75b4f99d265', '20545fa3-72af-4133-bad3-a05eba69e4a0', 16876, '1991-07-18 05:57:27', '1983-07-07 18:20:07');
INSERT INTO public.magasin_inventory_stock_items VALUES ('a11c604b-4ae1-494f-b591-09bbc34f0c87', 'b6231a60-2ab0-4139-988a-e64614212ede', 15982, '1996-06-26 11:01:54', '1991-05-13 14:06:54');
INSERT INTO public.magasin_inventory_stock_items VALUES ('17162aaf-7968-49b4-bc94-cd48cae36ed1', '9f3e1c0b-f7a7-4612-866e-e46ed8f17411', 30783, '2017-01-23 17:43:26', '1990-11-10 20:01:23');
INSERT INTO public.magasin_inventory_stock_items VALUES ('9ce37edc-77c6-492b-a63e-0da8e89950e6', 'bf939824-e953-4052-94dd-10bee762752c', 27115, '1989-11-14 20:38:58', '2008-06-07 22:35:40');
INSERT INTO public.magasin_inventory_stock_items VALUES ('a4e34675-0b0e-40e0-9935-ef5402b82322', '88ca872b-f4b0-4bef-99af-41a8635da602', 4728, '2011-06-06 18:07:08', '2011-09-16 21:01:49');
INSERT INTO public.magasin_inventory_stock_items VALUES ('a7a656fd-fdb6-4ed8-bbf5-b9a9163e7112', 'd03562be-676d-442f-a2d9-a9f3d814ddd3', 10230, '2003-02-27 10:17:14', '2009-12-20 21:51:21');
INSERT INTO public.magasin_inventory_stock_items VALUES ('e5a83236-be53-4c5e-a3d6-d9020796a1b6', '2924bb42-07a3-4988-a309-7617309df611', 26567, '2017-11-30 15:17:13', '2004-11-27 22:39:22');
INSERT INTO public.magasin_inventory_stock_items VALUES ('6c49ca8e-193b-4c1e-81fe-e4ac898cd210', 'ed747305-f4af-43f6-86ae-c9fd5ef96e6a', 31985, '2000-01-16 02:33:37', '1988-12-17 22:24:34');
INSERT INTO public.magasin_inventory_stock_items VALUES ('731a25a5-48bd-4a97-9a5c-a46551798f97', '0ee5c6a9-6e72-461d-9ab5-b3007d064414', 22023, '1988-01-08 06:09:25', '1990-11-10 08:48:06');
INSERT INTO public.magasin_inventory_stock_items VALUES ('938d8611-34f7-4973-8475-6e78ab4426f9', '88f1cb05-5bca-492a-9808-efb88d19f114', 435, '1985-05-29 15:07:49', '2018-08-26 18:11:11');
INSERT INTO public.magasin_inventory_stock_items VALUES ('4a1b92c5-7956-480d-9a43-f3701d89faa5', '8a5ed478-dfa5-42a0-83c2-d4a8aacb8c61', 32650, '1988-01-05 12:15:33', '1987-01-10 06:36:28');
INSERT INTO public.magasin_inventory_stock_items VALUES ('6d092897-6da5-4b18-9e57-2e593b01aee5', 'b6499410-c082-4c1d-8eb1-63c1ad0c173f', 25358, '2004-04-20 03:01:59', '1988-08-15 04:27:04');
INSERT INTO public.magasin_inventory_stock_items VALUES ('31ec3020-78ca-4cf7-9e38-0cc874d25203', '5496ad12-16ee-4632-b16c-0a2f0e08680e', 19287, '2001-11-17 09:58:54', '2006-10-09 08:12:09');
INSERT INTO public.magasin_inventory_stock_items VALUES ('587e5c68-09db-423f-937c-f72fa1dcf624', '044daa80-9fe8-482b-9dc0-8bd5b2c35ad3', 7640, '2018-09-04 12:27:52', '1990-03-01 17:59:33');
INSERT INTO public.magasin_inventory_stock_items VALUES ('24a8ebe5-6826-414f-9ab1-8af2822b0f72', '96f7295f-eb70-40e1-bcf2-eefe7f18bf41', 4010, '2010-10-18 21:17:01', '1997-11-19 10:51:09');
INSERT INTO public.magasin_inventory_stock_items VALUES ('72412525-6759-4e1b-aad7-459d3f746720', '9cc3bbe4-a762-4d35-a975-417174fd7d19', 19815, '2001-06-18 17:17:54', '2013-07-24 22:24:33');
INSERT INTO public.magasin_inventory_stock_items VALUES ('05640a8d-b660-4bde-b3f5-b31d97bc6709', '25c0aa79-41b1-4a09-ac01-82f4209fd309', 18488, '2002-10-12 19:50:44', '2018-09-07 18:09:12');
INSERT INTO public.magasin_inventory_stock_items VALUES ('b64f2581-f915-4b57-a779-4a83233e7446', '8bb03b1e-3012-4bda-9122-3092c14aa819', 9697, '1980-10-11 16:19:51', '2004-09-06 20:32:15');
INSERT INTO public.magasin_inventory_stock_items VALUES ('1b2a7fae-92e9-434c-a811-aac424a2b4c8', 'c1240f86-cef4-419b-b07b-f9867016410b', 24661, '1980-12-09 06:35:20', '2012-05-06 01:16:48');
INSERT INTO public.magasin_inventory_stock_items VALUES ('c9f87442-2749-4465-81e2-30f61e6d161e', '6935ef4c-c1c9-4e6d-98cd-267e274a6043', 23492, '1986-08-16 13:06:50', '2019-01-30 13:56:48');
INSERT INTO public.magasin_inventory_stock_items VALUES ('8ee4d877-06b9-4435-b35e-867a8949a229', '0d122d88-3b59-4ee2-b76e-00c4413559d9', 10064, '2017-04-30 07:22:05', '1986-07-19 15:30:50');
INSERT INTO public.magasin_inventory_stock_items VALUES ('38593ac2-fd6b-415a-8d23-3d142eee2e16', 'a6f57c04-b6ef-4495-85b8-f9f4ffa569f4', 742, '2015-05-26 14:34:56', '2019-06-06 01:41:18');
INSERT INTO public.magasin_inventory_stock_items VALUES ('a12ec772-a175-4d1d-8cc3-489be325a6cf', 'e25a580d-2c5a-44f2-b100-18e02f301af3', 6427, '2001-01-17 15:47:43', '2010-10-14 05:28:27');
INSERT INTO public.magasin_inventory_stock_items VALUES ('9431b399-2459-44b2-96c4-4507ad106b19', '760d52ae-93f5-4aac-b8c4-2e196ca935ea', 22405, '2000-11-04 17:08:19', '2011-02-05 19:51:40');
INSERT INTO public.magasin_inventory_stock_items VALUES ('8cfeedbf-07fd-4b0f-a486-fade6ed43469', '459dfa45-9748-47d6-ab7d-a04dcd93d265', 24267, '1996-11-29 17:22:00', '2009-06-18 09:20:38');
INSERT INTO public.magasin_inventory_stock_items VALUES ('aa0be8d8-037f-451b-baee-be899f4b800b', '5bfba72c-7b1d-475c-baf9-078bcd54f75a', 28643, '1984-04-16 06:04:04', '1985-04-07 19:49:19');
INSERT INTO public.magasin_inventory_stock_items VALUES ('b08c69f7-5852-4eac-8505-f23a52363c39', '4bfcd82f-e964-434d-8cc5-f0062667ccde', 20869, '2015-08-08 12:06:32', '2012-09-27 05:49:56');
INSERT INTO public.magasin_inventory_stock_items VALUES ('58d1e830-c1ee-43c3-8213-68dbd721afbc', 'f6523bf4-98a9-4f53-93ef-24e91967496b', 32314, '1989-06-07 20:04:44', '2019-11-02 12:22:15');
INSERT INTO public.magasin_inventory_stock_items VALUES ('6d01338c-8c8c-48a1-b0f6-10d3f34b47a7', '4984552d-e6a1-46fa-a79a-2b2788cbed0d', 7331, '1986-01-18 08:38:12', '2006-10-02 10:03:07');
INSERT INTO public.magasin_inventory_stock_items VALUES ('d4e35f67-5354-4374-bcea-0d9369196ba0', '6131597a-65cf-4e47-9733-d60a7f06c9fe', 18782, '1992-07-25 16:35:49', '2013-11-30 22:03:56');
INSERT INTO public.magasin_inventory_stock_items VALUES ('89c0eee9-9621-4c5b-8d3a-9b905a0e305c', '08fee793-e220-48dc-b3a4-646a4f029fca', 31325, '1993-03-24 23:34:39', '1997-11-04 18:42:28');
INSERT INTO public.magasin_inventory_stock_items VALUES ('4a43f285-8de0-46ec-8dfc-a0bf09fed3d1', '95a2fade-8e39-4b8b-b1eb-65b12f2c92eb', 27278, '2015-07-08 02:02:38', '2014-12-22 08:14:53');


--
-- Data for Name: magasin_sale_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.schema_migrations VALUES (20180430195550, '2019-05-31 20:06:00');
INSERT INTO public.schema_migrations VALUES (20180501193645, '2019-05-31 20:06:01');


--
-- Data for Name: snapshots; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: stream_events; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: streams; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.streams VALUES (0, '$all', 0, '2019-06-21 20:46:17.133704');


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: streams_stream_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.streams_stream_id_seq', 1, false);


--
-- Name: subscriptions_subscription_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subscriptions_subscription_id_seq', 1, false);


--
-- Name: ecto_schema_migrations ecto_schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ecto_schema_migrations
    ADD CONSTRAINT ecto_schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (event_id);


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
-- Name: snapshots snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.snapshots
    ADD CONSTRAINT snapshots_pkey PRIMARY KEY (source_uuid);


--
-- Name: stream_events stream_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_events
    ADD CONSTRAINT stream_events_pkey PRIMARY KEY (event_id, stream_id);


--
-- Name: streams streams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.streams
    ADD CONSTRAINT streams_pkey PRIMARY KEY (stream_id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (subscription_id);


--
-- Name: ix_stream_events; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_stream_events ON public.stream_events USING btree (stream_id, stream_version);


--
-- Name: ix_streams_stream_uuid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_streams_stream_uuid ON public.streams USING btree (stream_uuid);


--
-- Name: ix_subscriptions_stream_uuid_subscription_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_subscriptions_stream_uuid_subscription_name ON public.subscriptions USING btree (stream_uuid, subscription_name);


--
-- Name: events no_delete_events; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE no_delete_events AS
    ON DELETE TO public.events DO INSTEAD NOTHING;


--
-- Name: stream_events no_delete_stream_events; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE no_delete_stream_events AS
    ON DELETE TO public.stream_events DO INSTEAD NOTHING;


--
-- Name: events no_update_events; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE no_update_events AS
    ON UPDATE TO public.events DO INSTEAD NOTHING;


--
-- Name: stream_events no_update_stream_events; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE no_update_stream_events AS
    ON UPDATE TO public.stream_events DO INSTEAD NOTHING;


--
-- Name: streams event_notification; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER event_notification AFTER UPDATE ON public.streams FOR EACH ROW EXECUTE PROCEDURE public.notify_events();


--
-- Name: stream_events stream_events_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_events
    ADD CONSTRAINT stream_events_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(event_id);


--
-- Name: stream_events stream_events_original_stream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_events
    ADD CONSTRAINT stream_events_original_stream_id_fkey FOREIGN KEY (original_stream_id) REFERENCES public.streams(stream_id);


--
-- Name: stream_events stream_events_stream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_events
    ADD CONSTRAINT stream_events_stream_id_fkey FOREIGN KEY (stream_id) REFERENCES public.streams(stream_id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

