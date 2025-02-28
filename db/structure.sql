SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: heroku_ext; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA heroku_ext;


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activity_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activity_types (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: activity_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activity_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activity_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activity_types_id_seq OWNED BY public.activity_types.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    system_id integer NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: committee_committee_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.committee_committee_types (
    id integer NOT NULL,
    committee_id integer NOT NULL,
    committee_type_id integer NOT NULL
);


--
-- Name: committee_committee_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.committee_committee_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: committee_committee_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.committee_committee_types_id_seq OWNED BY public.committee_committee_types.id;


--
-- Name: committee_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.committee_events (
    id integer NOT NULL,
    committee_id integer NOT NULL,
    event_id integer NOT NULL
);


--
-- Name: committee_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.committee_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: committee_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.committee_events_id_seq OWNED BY public.committee_events.id;


--
-- Name: committee_houses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.committee_houses (
    id integer NOT NULL,
    committee_id integer NOT NULL,
    parliamentary_house_id integer NOT NULL
);


--
-- Name: committee_houses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.committee_houses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: committee_houses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.committee_houses_id_seq OWNED BY public.committee_houses.id;


--
-- Name: committee_oral_evidence_transcripts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.committee_oral_evidence_transcripts (
    id integer NOT NULL,
    committee_id integer NOT NULL,
    oral_evidence_transcript_id integer NOT NULL
);


--
-- Name: committee_oral_evidence_transcripts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.committee_oral_evidence_transcripts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: committee_oral_evidence_transcripts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.committee_oral_evidence_transcripts_id_seq OWNED BY public.committee_oral_evidence_transcripts.id;


--
-- Name: committee_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.committee_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    system_id integer NOT NULL,
    category_id integer NOT NULL
);


--
-- Name: committee_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.committee_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: committee_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.committee_types_id_seq OWNED BY public.committee_types.id;


--
-- Name: committee_work_packages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.committee_work_packages (
    id integer NOT NULL,
    committee_id integer NOT NULL,
    work_package_id integer NOT NULL
);


--
-- Name: committee_work_packages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.committee_work_packages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: committee_work_packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.committee_work_packages_id_seq OWNED BY public.committee_work_packages.id;


--
-- Name: committee_written_evidence_publications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.committee_written_evidence_publications (
    id integer NOT NULL,
    committee_id integer NOT NULL,
    written_evidence_publication_id integer NOT NULL
);


--
-- Name: committee_written_evidence_publications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.committee_written_evidence_publications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: committee_written_evidence_publications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.committee_written_evidence_publications_id_seq OWNED BY public.committee_written_evidence_publications.id;


--
-- Name: committees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.committees (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    start_on date,
    end_on date,
    commons_appointed_on date,
    lords_appointed_on date,
    lead_parliamentary_house_id integer,
    address character varying(500),
    phone character varying(500),
    email character varying(500),
    contact_disclaimer character varying(500),
    is_shown_on_website boolean DEFAULT false,
    legacy_url character varying(500),
    is_redirect_enabled boolean DEFAULT false,
    is_lead_committee boolean DEFAULT false,
    system_id integer NOT NULL,
    parent_committee_id integer
);


--
-- Name: committees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.committees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: committees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.committees_id_seq OWNED BY public.committees.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.departments (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    system_id integer NOT NULL
);


--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.departments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- Name: event_segments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_segments (
    id integer NOT NULL,
    name character varying(255),
    start_at timestamp without time zone NOT NULL,
    end_at timestamp without time zone,
    is_private boolean DEFAULT false,
    system_id integer NOT NULL,
    event_id integer NOT NULL,
    activity_type_id integer NOT NULL
);


--
-- Name: event_segments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_segments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_segments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_segments_id_seq OWNED BY public.event_segments.id;


--
-- Name: event_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_types (
    id integer NOT NULL,
    name character varying(255),
    is_visit boolean DEFAULT false,
    description character varying(5000) NOT NULL,
    system_id integer NOT NULL
);


--
-- Name: event_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_types_id_seq OWNED BY public.event_types.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id integer NOT NULL,
    name character varying(255),
    start_at timestamp without time zone NOT NULL,
    end_at timestamp without time zone NOT NULL,
    cancelled_at timestamp without time zone,
    location_name character varying(255),
    originating_system character varying(255) NOT NULL,
    system_id integer NOT NULL,
    location_id integer,
    event_type_id integer NOT NULL
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id integer NOT NULL,
    name character varying(255),
    system_id integer NOT NULL
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.memberships (
    id integer NOT NULL,
    start_on date NOT NULL,
    end_on date,
    is_lay_member boolean DEFAULT false,
    is_ex_officio boolean DEFAULT false,
    is_alternate boolean DEFAULT false,
    is_co_opted boolean DEFAULT false,
    system_id integer NOT NULL,
    person_id integer NOT NULL,
    committee_id integer NOT NULL,
    role_id integer NOT NULL
);


--
-- Name: memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.memberships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.memberships_id_seq OWNED BY public.memberships.id;


--
-- Name: oral_evidence_transcript_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oral_evidence_transcript_files (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    size integer NOT NULL,
    format character varying(255) NOT NULL,
    url character varying(1000),
    oral_evidence_transcript_id integer NOT NULL
);


--
-- Name: oral_evidence_transcript_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oral_evidence_transcript_files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oral_evidence_transcript_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oral_evidence_transcript_files_id_seq OWNED BY public.oral_evidence_transcript_files.id;


--
-- Name: oral_evidence_transcripts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oral_evidence_transcripts (
    id integer NOT NULL,
    start_on date NOT NULL,
    meeting_on date,
    published_on date NOT NULL,
    legacy_html_url character varying(255),
    legacy_pdf_url character varying(255),
    document_id integer,
    system_id integer NOT NULL,
    event_segment_id integer
);


--
-- Name: oral_evidence_transcripts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oral_evidence_transcripts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oral_evidence_transcripts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oral_evidence_transcripts_id_seq OWNED BY public.oral_evidence_transcripts.id;


--
-- Name: organisations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organisations (
    id integer NOT NULL,
    name character varying(1000) NOT NULL,
    idms_id character varying(255),
    system_id integer NOT NULL
);


--
-- Name: organisations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organisations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organisations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organisations_id_seq OWNED BY public.organisations.id;


--
-- Name: paper_series_numbers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.paper_series_numbers (
    id integer NOT NULL,
    number character varying(255) NOT NULL,
    session_id integer NOT NULL,
    parliamentary_house_id integer NOT NULL,
    oral_evidence_transcript_id integer,
    publication_id integer,
    written_evidence_publication_id integer
);


--
-- Name: paper_series_numbers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.paper_series_numbers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: paper_series_numbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.paper_series_numbers_id_seq OWNED BY public.paper_series_numbers.id;


--
-- Name: parliamentary_houses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.parliamentary_houses (
    id integer NOT NULL,
    short_label character varying(255) NOT NULL,
    label character varying(255) NOT NULL
);


--
-- Name: parliamentary_houses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.parliamentary_houses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: parliamentary_houses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.parliamentary_houses_id_seq OWNED BY public.parliamentary_houses.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.people (
    id integer NOT NULL,
    name character varying(1000) NOT NULL,
    system_id integer,
    mnis_id integer
);


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.people_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.people_id_seq OWNED BY public.people.id;


--
-- Name: positions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.positions (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    organisation_id integer NOT NULL
);


--
-- Name: positions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.positions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.positions_id_seq OWNED BY public.positions.id;


--
-- Name: publication_document_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publication_document_files (
    id integer NOT NULL,
    name text NOT NULL,
    size integer NOT NULL,
    format character varying(255) NOT NULL,
    url character varying(1000),
    publication_document_id integer NOT NULL
);


--
-- Name: publication_document_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.publication_document_files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publication_document_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.publication_document_files_id_seq OWNED BY public.publication_document_files.id;


--
-- Name: publication_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publication_documents (
    id integer NOT NULL,
    publication_id integer NOT NULL,
    system_id integer NOT NULL
);


--
-- Name: publication_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.publication_documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publication_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.publication_documents_id_seq OWNED BY public.publication_documents.id;


--
-- Name: publication_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publication_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    plural_name character varying(255) NOT NULL,
    description text NOT NULL,
    government_can_respond boolean DEFAULT false,
    can_be_response boolean DEFAULT false,
    icon_key character varying(255),
    system_id integer NOT NULL
);


--
-- Name: publication_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.publication_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publication_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.publication_types_id_seq OWNED BY public.publication_types.id;


--
-- Name: publications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publications (
    id integer NOT NULL,
    description text NOT NULL,
    start_at timestamp without time zone NOT NULL,
    end_at timestamp without time zone,
    additional_content_url character varying(500),
    additional_content_url_2 character varying(500),
    system_id integer NOT NULL,
    committee_id integer NOT NULL,
    publication_type_id integer NOT NULL,
    responded_to_publication_id integer,
    department_id integer
);


--
-- Name: publications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.publications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.publications_id_seq OWNED BY public.publications.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(255),
    is_chair boolean DEFAULT false,
    system_id integer NOT NULL
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: scrutinisings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scrutinisings (
    id integer NOT NULL,
    committee_id integer NOT NULL,
    department_id integer NOT NULL
);


--
-- Name: scrutinisings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scrutinisings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scrutinisings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scrutinisings_id_seq OWNED BY public.scrutinisings.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id integer NOT NULL,
    label character varying(255),
    system_id integer NOT NULL
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: witness_positions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.witness_positions (
    id integer NOT NULL,
    witness_id integer NOT NULL,
    position_id integer NOT NULL
);


--
-- Name: witness_positions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.witness_positions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: witness_positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.witness_positions_id_seq OWNED BY public.witness_positions.id;


--
-- Name: witnesses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.witnesses (
    id integer NOT NULL,
    person_name character varying(3000),
    system_id integer,
    person_id integer,
    oral_evidence_transcript_id integer NOT NULL
);


--
-- Name: witnesses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.witnesses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: witnesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.witnesses_id_seq OWNED BY public.witnesses.id;


--
-- Name: work_package_oral_evidence_transcripts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.work_package_oral_evidence_transcripts (
    id integer NOT NULL,
    work_package_id integer NOT NULL,
    oral_evidence_transcript_id integer NOT NULL
);


--
-- Name: work_package_oral_evidence_transcripts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.work_package_oral_evidence_transcripts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: work_package_oral_evidence_transcripts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.work_package_oral_evidence_transcripts_id_seq OWNED BY public.work_package_oral_evidence_transcripts.id;


--
-- Name: work_package_publications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.work_package_publications (
    id integer NOT NULL,
    work_package_id integer NOT NULL,
    publication_id integer NOT NULL
);


--
-- Name: work_package_publications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.work_package_publications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: work_package_publications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.work_package_publications_id_seq OWNED BY public.work_package_publications.id;


--
-- Name: work_package_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.work_package_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(1000) NOT NULL,
    is_inquiry boolean DEFAULT false,
    system_id integer NOT NULL
);


--
-- Name: work_package_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.work_package_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: work_package_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.work_package_types_id_seq OWNED BY public.work_package_types.id;


--
-- Name: work_packages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.work_packages (
    id integer NOT NULL,
    title character varying(1000) NOT NULL,
    open_on date NOT NULL,
    close_on date,
    system_id integer NOT NULL,
    work_package_type_id integer NOT NULL
);


--
-- Name: work_packages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.work_packages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: work_packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.work_packages_id_seq OWNED BY public.work_packages.id;


--
-- Name: written_evidence_publications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.written_evidence_publications (
    id integer NOT NULL,
    submission_id character varying(255) NOT NULL,
    internal_reference character varying(255) NOT NULL,
    published_at timestamp without time zone NOT NULL,
    legacy_html_url character varying(255),
    legacy_pdf_url character varying(255),
    is_anonymous boolean DEFAULT false,
    anonymous_witness_text character varying(255),
    work_package_id integer NOT NULL,
    system_id integer NOT NULL
);


--
-- Name: written_evidence_publications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.written_evidence_publications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: written_evidence_publications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.written_evidence_publications_id_seq OWNED BY public.written_evidence_publications.id;


--
-- Name: activity_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_types ALTER COLUMN id SET DEFAULT nextval('public.activity_types_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: committee_committee_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_committee_types ALTER COLUMN id SET DEFAULT nextval('public.committee_committee_types_id_seq'::regclass);


--
-- Name: committee_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_events ALTER COLUMN id SET DEFAULT nextval('public.committee_events_id_seq'::regclass);


--
-- Name: committee_houses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_houses ALTER COLUMN id SET DEFAULT nextval('public.committee_houses_id_seq'::regclass);


--
-- Name: committee_oral_evidence_transcripts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_oral_evidence_transcripts ALTER COLUMN id SET DEFAULT nextval('public.committee_oral_evidence_transcripts_id_seq'::regclass);


--
-- Name: committee_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_types ALTER COLUMN id SET DEFAULT nextval('public.committee_types_id_seq'::regclass);


--
-- Name: committee_work_packages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_work_packages ALTER COLUMN id SET DEFAULT nextval('public.committee_work_packages_id_seq'::regclass);


--
-- Name: committee_written_evidence_publications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_written_evidence_publications ALTER COLUMN id SET DEFAULT nextval('public.committee_written_evidence_publications_id_seq'::regclass);


--
-- Name: committees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committees ALTER COLUMN id SET DEFAULT nextval('public.committees_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: event_segments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_segments ALTER COLUMN id SET DEFAULT nextval('public.event_segments_id_seq'::regclass);


--
-- Name: event_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_types ALTER COLUMN id SET DEFAULT nextval('public.event_types_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: memberships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships ALTER COLUMN id SET DEFAULT nextval('public.memberships_id_seq'::regclass);


--
-- Name: oral_evidence_transcript_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oral_evidence_transcript_files ALTER COLUMN id SET DEFAULT nextval('public.oral_evidence_transcript_files_id_seq'::regclass);


--
-- Name: oral_evidence_transcripts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oral_evidence_transcripts ALTER COLUMN id SET DEFAULT nextval('public.oral_evidence_transcripts_id_seq'::regclass);


--
-- Name: organisations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organisations ALTER COLUMN id SET DEFAULT nextval('public.organisations_id_seq'::regclass);


--
-- Name: paper_series_numbers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paper_series_numbers ALTER COLUMN id SET DEFAULT nextval('public.paper_series_numbers_id_seq'::regclass);


--
-- Name: parliamentary_houses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parliamentary_houses ALTER COLUMN id SET DEFAULT nextval('public.parliamentary_houses_id_seq'::regclass);


--
-- Name: people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people ALTER COLUMN id SET DEFAULT nextval('public.people_id_seq'::regclass);


--
-- Name: positions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.positions ALTER COLUMN id SET DEFAULT nextval('public.positions_id_seq'::regclass);


--
-- Name: publication_document_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publication_document_files ALTER COLUMN id SET DEFAULT nextval('public.publication_document_files_id_seq'::regclass);


--
-- Name: publication_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publication_documents ALTER COLUMN id SET DEFAULT nextval('public.publication_documents_id_seq'::regclass);


--
-- Name: publication_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publication_types ALTER COLUMN id SET DEFAULT nextval('public.publication_types_id_seq'::regclass);


--
-- Name: publications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publications ALTER COLUMN id SET DEFAULT nextval('public.publications_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: scrutinisings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scrutinisings ALTER COLUMN id SET DEFAULT nextval('public.scrutinisings_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: witness_positions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.witness_positions ALTER COLUMN id SET DEFAULT nextval('public.witness_positions_id_seq'::regclass);


--
-- Name: witnesses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.witnesses ALTER COLUMN id SET DEFAULT nextval('public.witnesses_id_seq'::regclass);


--
-- Name: work_package_oral_evidence_transcripts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_package_oral_evidence_transcripts ALTER COLUMN id SET DEFAULT nextval('public.work_package_oral_evidence_transcripts_id_seq'::regclass);


--
-- Name: work_package_publications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_package_publications ALTER COLUMN id SET DEFAULT nextval('public.work_package_publications_id_seq'::regclass);


--
-- Name: work_package_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_package_types ALTER COLUMN id SET DEFAULT nextval('public.work_package_types_id_seq'::regclass);


--
-- Name: work_packages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_packages ALTER COLUMN id SET DEFAULT nextval('public.work_packages_id_seq'::regclass);


--
-- Name: written_evidence_publications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.written_evidence_publications ALTER COLUMN id SET DEFAULT nextval('public.written_evidence_publications_id_seq'::regclass);


--
-- Name: activity_types activity_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_types
    ADD CONSTRAINT activity_types_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: committee_committee_types committee_committee_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_committee_types
    ADD CONSTRAINT committee_committee_types_pkey PRIMARY KEY (id);


--
-- Name: committee_events committee_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_events
    ADD CONSTRAINT committee_events_pkey PRIMARY KEY (id);


--
-- Name: committee_houses committee_houses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_houses
    ADD CONSTRAINT committee_houses_pkey PRIMARY KEY (id);


--
-- Name: committee_oral_evidence_transcripts committee_oral_evidence_transcripts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_oral_evidence_transcripts
    ADD CONSTRAINT committee_oral_evidence_transcripts_pkey PRIMARY KEY (id);


--
-- Name: committee_types committee_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_types
    ADD CONSTRAINT committee_types_pkey PRIMARY KEY (id);


--
-- Name: committee_work_packages committee_work_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_work_packages
    ADD CONSTRAINT committee_work_packages_pkey PRIMARY KEY (id);


--
-- Name: committee_written_evidence_publications committee_written_evidence_publications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_written_evidence_publications
    ADD CONSTRAINT committee_written_evidence_publications_pkey PRIMARY KEY (id);


--
-- Name: committees committees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committees
    ADD CONSTRAINT committees_pkey PRIMARY KEY (id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: event_segments event_segments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_segments
    ADD CONSTRAINT event_segments_pkey PRIMARY KEY (id);


--
-- Name: event_types event_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_types
    ADD CONSTRAINT event_types_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: memberships memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


--
-- Name: oral_evidence_transcript_files oral_evidence_transcript_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oral_evidence_transcript_files
    ADD CONSTRAINT oral_evidence_transcript_files_pkey PRIMARY KEY (id);


--
-- Name: oral_evidence_transcripts oral_evidence_transcripts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oral_evidence_transcripts
    ADD CONSTRAINT oral_evidence_transcripts_pkey PRIMARY KEY (id);


--
-- Name: organisations organisations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organisations
    ADD CONSTRAINT organisations_pkey PRIMARY KEY (id);


--
-- Name: paper_series_numbers paper_series_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paper_series_numbers
    ADD CONSTRAINT paper_series_numbers_pkey PRIMARY KEY (id);


--
-- Name: parliamentary_houses parliamentary_houses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parliamentary_houses
    ADD CONSTRAINT parliamentary_houses_pkey PRIMARY KEY (id);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (id);


--
-- Name: publication_document_files publication_document_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publication_document_files
    ADD CONSTRAINT publication_document_files_pkey PRIMARY KEY (id);


--
-- Name: publication_documents publication_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publication_documents
    ADD CONSTRAINT publication_documents_pkey PRIMARY KEY (id);


--
-- Name: publication_types publication_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publication_types
    ADD CONSTRAINT publication_types_pkey PRIMARY KEY (id);


--
-- Name: publications publications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publications
    ADD CONSTRAINT publications_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: scrutinisings scrutinisings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scrutinisings
    ADD CONSTRAINT scrutinisings_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: witness_positions witness_positions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.witness_positions
    ADD CONSTRAINT witness_positions_pkey PRIMARY KEY (id);


--
-- Name: witnesses witnesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.witnesses
    ADD CONSTRAINT witnesses_pkey PRIMARY KEY (id);


--
-- Name: work_package_oral_evidence_transcripts work_package_oral_evidence_transcripts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_package_oral_evidence_transcripts
    ADD CONSTRAINT work_package_oral_evidence_transcripts_pkey PRIMARY KEY (id);


--
-- Name: work_package_publications work_package_publications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_package_publications
    ADD CONSTRAINT work_package_publications_pkey PRIMARY KEY (id);


--
-- Name: work_package_types work_package_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_package_types
    ADD CONSTRAINT work_package_types_pkey PRIMARY KEY (id);


--
-- Name: work_packages work_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_packages
    ADD CONSTRAINT work_packages_pkey PRIMARY KEY (id);


--
-- Name: written_evidence_publications written_evidence_publications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.written_evidence_publications
    ADD CONSTRAINT written_evidence_publications_pkey PRIMARY KEY (id);


--
-- Name: event_segments fk_activity_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_segments
    ADD CONSTRAINT fk_activity_type FOREIGN KEY (activity_type_id) REFERENCES public.activity_types(id);


--
-- Name: committee_types fk_category; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_types
    ADD CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: committee_houses fk_committee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_houses
    ADD CONSTRAINT fk_committee FOREIGN KEY (committee_id) REFERENCES public.committees(id);


--
-- Name: committee_committee_types fk_committee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_committee_types
    ADD CONSTRAINT fk_committee FOREIGN KEY (committee_id) REFERENCES public.committees(id);


--
-- Name: scrutinisings fk_committee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scrutinisings
    ADD CONSTRAINT fk_committee FOREIGN KEY (committee_id) REFERENCES public.committees(id);


--
-- Name: committee_work_packages fk_committee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_work_packages
    ADD CONSTRAINT fk_committee FOREIGN KEY (committee_id) REFERENCES public.committees(id);


--
-- Name: committee_events fk_committee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_events
    ADD CONSTRAINT fk_committee FOREIGN KEY (committee_id) REFERENCES public.committees(id);


--
-- Name: committee_oral_evidence_transcripts fk_committee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_oral_evidence_transcripts
    ADD CONSTRAINT fk_committee FOREIGN KEY (committee_id) REFERENCES public.committees(id);


--
-- Name: memberships fk_committee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT fk_committee FOREIGN KEY (committee_id) REFERENCES public.committees(id);


--
-- Name: publications fk_committee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publications
    ADD CONSTRAINT fk_committee FOREIGN KEY (committee_id) REFERENCES public.committees(id);


--
-- Name: committee_written_evidence_publications fk_committee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_written_evidence_publications
    ADD CONSTRAINT fk_committee FOREIGN KEY (committee_id) REFERENCES public.committees(id);


--
-- Name: committee_committee_types fk_committee_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_committee_types
    ADD CONSTRAINT fk_committee_type FOREIGN KEY (committee_type_id) REFERENCES public.committee_types(id);


--
-- Name: scrutinisings fk_department; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scrutinisings
    ADD CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: publications fk_department; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publications
    ADD CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: committee_events fk_event; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_events
    ADD CONSTRAINT fk_event FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: event_segments fk_event; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_segments
    ADD CONSTRAINT fk_event FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: oral_evidence_transcripts fk_event_segment; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oral_evidence_transcripts
    ADD CONSTRAINT fk_event_segment FOREIGN KEY (event_segment_id) REFERENCES public.event_segments(id);


--
-- Name: events fk_event_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_event_type FOREIGN KEY (event_type_id) REFERENCES public.event_types(id);


--
-- Name: committees fk_lead_parliamentary_house; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committees
    ADD CONSTRAINT fk_lead_parliamentary_house FOREIGN KEY (lead_parliamentary_house_id) REFERENCES public.parliamentary_houses(id);


--
-- Name: events fk_location; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_location FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: committee_oral_evidence_transcripts fk_oral_evidence_transcript; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_oral_evidence_transcripts
    ADD CONSTRAINT fk_oral_evidence_transcript FOREIGN KEY (oral_evidence_transcript_id) REFERENCES public.oral_evidence_transcripts(id);


--
-- Name: work_package_oral_evidence_transcripts fk_oral_evidence_transcript; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_package_oral_evidence_transcripts
    ADD CONSTRAINT fk_oral_evidence_transcript FOREIGN KEY (oral_evidence_transcript_id) REFERENCES public.oral_evidence_transcripts(id);


--
-- Name: oral_evidence_transcript_files fk_oral_evidence_transcript; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oral_evidence_transcript_files
    ADD CONSTRAINT fk_oral_evidence_transcript FOREIGN KEY (oral_evidence_transcript_id) REFERENCES public.oral_evidence_transcripts(id);


--
-- Name: witnesses fk_oral_evidence_transcript; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.witnesses
    ADD CONSTRAINT fk_oral_evidence_transcript FOREIGN KEY (oral_evidence_transcript_id) REFERENCES public.oral_evidence_transcripts(id);


--
-- Name: paper_series_numbers fk_oral_evidence_transcript; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paper_series_numbers
    ADD CONSTRAINT fk_oral_evidence_transcript FOREIGN KEY (oral_evidence_transcript_id) REFERENCES public.oral_evidence_transcripts(id);


--
-- Name: positions fk_organisation; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT fk_organisation FOREIGN KEY (organisation_id) REFERENCES public.organisations(id);


--
-- Name: committees fk_parent_committee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committees
    ADD CONSTRAINT fk_parent_committee FOREIGN KEY (parent_committee_id) REFERENCES public.committees(id);


--
-- Name: committee_houses fk_parliamentary_house; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_houses
    ADD CONSTRAINT fk_parliamentary_house FOREIGN KEY (parliamentary_house_id) REFERENCES public.parliamentary_houses(id);


--
-- Name: paper_series_numbers fk_parliamentary_house; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paper_series_numbers
    ADD CONSTRAINT fk_parliamentary_house FOREIGN KEY (parliamentary_house_id) REFERENCES public.parliamentary_houses(id);


--
-- Name: witnesses fk_person; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.witnesses
    ADD CONSTRAINT fk_person FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: memberships fk_person; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT fk_person FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: witness_positions fk_position; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.witness_positions
    ADD CONSTRAINT fk_position FOREIGN KEY (position_id) REFERENCES public.positions(id);


--
-- Name: publication_documents fk_publication; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publication_documents
    ADD CONSTRAINT fk_publication FOREIGN KEY (publication_id) REFERENCES public.publications(id);


--
-- Name: paper_series_numbers fk_publication; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paper_series_numbers
    ADD CONSTRAINT fk_publication FOREIGN KEY (publication_id) REFERENCES public.publications(id);


--
-- Name: work_package_publications fk_publication; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_package_publications
    ADD CONSTRAINT fk_publication FOREIGN KEY (publication_id) REFERENCES public.publications(id);


--
-- Name: publication_document_files fk_publication_document; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publication_document_files
    ADD CONSTRAINT fk_publication_document FOREIGN KEY (publication_document_id) REFERENCES public.publication_documents(id);


--
-- Name: publications fk_publication_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publications
    ADD CONSTRAINT fk_publication_type FOREIGN KEY (publication_type_id) REFERENCES public.publication_types(id);


--
-- Name: publications fk_responded_to_publication_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publications
    ADD CONSTRAINT fk_responded_to_publication_type FOREIGN KEY (responded_to_publication_id) REFERENCES public.publication_types(id);


--
-- Name: memberships fk_role; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT fk_role FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: paper_series_numbers fk_session; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paper_series_numbers
    ADD CONSTRAINT fk_session FOREIGN KEY (session_id) REFERENCES public.sessions(id);


--
-- Name: witness_positions fk_witness; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.witness_positions
    ADD CONSTRAINT fk_witness FOREIGN KEY (witness_id) REFERENCES public.witnesses(id);


--
-- Name: committee_work_packages fk_work_package; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_work_packages
    ADD CONSTRAINT fk_work_package FOREIGN KEY (work_package_id) REFERENCES public.work_packages(id);


--
-- Name: work_package_oral_evidence_transcripts fk_work_package; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_package_oral_evidence_transcripts
    ADD CONSTRAINT fk_work_package FOREIGN KEY (work_package_id) REFERENCES public.work_packages(id);


--
-- Name: written_evidence_publications fk_work_package; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.written_evidence_publications
    ADD CONSTRAINT fk_work_package FOREIGN KEY (work_package_id) REFERENCES public.work_packages(id);


--
-- Name: work_package_publications fk_work_package; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_package_publications
    ADD CONSTRAINT fk_work_package FOREIGN KEY (work_package_id) REFERENCES public.work_packages(id);


--
-- Name: work_packages fk_work_package_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.work_packages
    ADD CONSTRAINT fk_work_package_type FOREIGN KEY (work_package_type_id) REFERENCES public.work_packages(id);


--
-- Name: paper_series_numbers fk_written_evidence_publication; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paper_series_numbers
    ADD CONSTRAINT fk_written_evidence_publication FOREIGN KEY (oral_evidence_transcript_id) REFERENCES public.oral_evidence_transcripts(id);


--
-- Name: committee_written_evidence_publications fk_written_evidence_publication; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_written_evidence_publications
    ADD CONSTRAINT fk_written_evidence_publication FOREIGN KEY (written_evidence_publication_id) REFERENCES public.written_evidence_publications(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20250228110609');

