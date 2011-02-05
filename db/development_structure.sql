--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: rubygems; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rubygems (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: rubygems_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rubygems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: rubygems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rubygems_id_seq OWNED BY rubygems.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: test_results; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE test_results (
    id integer NOT NULL,
    result boolean NOT NULL,
    test_output text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    version_id integer NOT NULL,
    rubygem_id integer NOT NULL,
    operating_system character varying(255),
    architecture character varying(255),
    machine_architecture character varying(255),
    vendor character varying(255),
    ruby_version character varying(255),
    platform character varying(255)
);


--
-- Name: test_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE test_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: test_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE test_results_id_seq OWNED BY test_results.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE versions (
    id integer NOT NULL,
    number character varying(255) NOT NULL,
    rubygem_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    prerelease boolean
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE rubygems ALTER COLUMN id SET DEFAULT nextval('rubygems_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE test_results ALTER COLUMN id SET DEFAULT nextval('test_results_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: rubygems_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rubygems
    ADD CONSTRAINT rubygems_pkey PRIMARY KEY (id);


--
-- Name: test_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY test_results
    ADD CONSTRAINT test_results_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: index_rubygems_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_rubygems_on_name ON rubygems USING btree (name);


--
-- Name: index_versions_on_rubygem_id_and_number; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_versions_on_rubygem_id_and_number ON versions USING btree (rubygem_id, number);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20101111043525');

INSERT INTO schema_migrations (version) VALUES ('20101112011142');

INSERT INTO schema_migrations (version) VALUES ('20101112011230');

INSERT INTO schema_migrations (version) VALUES ('20101112011750');

INSERT INTO schema_migrations (version) VALUES ('20101112012038');

INSERT INTO schema_migrations (version) VALUES ('20101112022856');

INSERT INTO schema_migrations (version) VALUES ('20101112024413');

INSERT INTO schema_migrations (version) VALUES ('20101112044711');

INSERT INTO schema_migrations (version) VALUES ('20101114031341');

INSERT INTO schema_migrations (version) VALUES ('20101217081912');

INSERT INTO schema_migrations (version) VALUES ('20110103015306');

INSERT INTO schema_migrations (version) VALUES ('20110103015542');

INSERT INTO schema_migrations (version) VALUES ('20110108030608');