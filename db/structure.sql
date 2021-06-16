--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2
-- Dumped by pg_dump version 13.2

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

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: tablefunc; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS tablefunc WITH SCHEMA public;


--
-- Name: EXTENSION tablefunc; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION tablefunc IS 'functions that manipulate whole tables, including crosstab';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: about_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.about_users (
    id integer NOT NULL,
    user_id integer,
    name character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size bigint,
    image_updated_at timestamp without time zone,
    is_alumni boolean
);


--
-- Name: about_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.about_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: about_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.about_users_id_seq OWNED BY public.about_users.id;


--
-- Name: colors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.colors (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: colors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.colors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: colors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.colors_id_seq OWNED BY public.colors.id;


--
-- Name: contests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contests (
    id integer NOT NULL,
    name character varying NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    problem_pdf_file_name character varying,
    problem_pdf_content_type character varying,
    problem_pdf_file_size integer,
    problem_pdf_updated_at timestamp without time zone,
    rule text DEFAULT ''::text,
    result_time timestamp without time zone NOT NULL,
    feedback_time timestamp without time zone NOT NULL,
    gold_cutoff integer DEFAULT 0 NOT NULL,
    silver_cutoff integer DEFAULT 0 NOT NULL,
    bronze_cutoff integer DEFAULT 0 NOT NULL,
    result_released boolean DEFAULT false NOT NULL,
    problem_tex_file_name character varying,
    problem_tex_content_type character varying,
    problem_tex_file_size integer,
    problem_tex_updated_at timestamp without time zone,
    marking_scheme_file_name character varying,
    marking_scheme_content_type character varying,
    marking_scheme_file_size integer,
    marking_scheme_updated_at timestamp without time zone,
    book_promo character varying,
    timer interval hour to second
);


--
-- Name: contests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contests_id_seq OWNED BY public.contests.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    handler text NOT NULL,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying,
    queue character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delayed_jobs_id_seq OWNED BY public.delayed_jobs.id;


--
-- Name: feedback_answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feedback_answers (
    id integer NOT NULL,
    feedback_question_id integer NOT NULL,
    answer text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_contest_id integer NOT NULL
);


--
-- Name: feedback_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feedback_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedback_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feedback_answers_id_seq OWNED BY public.feedback_answers.id;


--
-- Name: feedback_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feedback_questions (
    id integer NOT NULL,
    question text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    contest_id integer NOT NULL
);


--
-- Name: feedback_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feedback_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedback_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feedback_questions_id_seq OWNED BY public.feedback_questions.id;


--
-- Name: long_problems; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.long_problems (
    id integer NOT NULL,
    contest_id integer NOT NULL,
    problem_no integer NOT NULL,
    statement text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    report_file_name character varying,
    report_content_type character varying,
    report_file_size integer,
    report_updated_at timestamp without time zone,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    max_score integer DEFAULT 7
);


--
-- Name: long_problems_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.long_problems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: long_problems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.long_problems_id_seq OWNED BY public.long_problems.id;


--
-- Name: long_submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.long_submissions (
    id integer NOT NULL,
    long_problem_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    score integer,
    feedback character varying DEFAULT ''::character varying NOT NULL,
    user_contest_id integer NOT NULL
);


--
-- Name: long_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.long_submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: long_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.long_submissions_id_seq OWNED BY public.long_submissions.id;


--
-- Name: migration_validators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.migration_validators (
    id integer NOT NULL,
    table_name character varying NOT NULL,
    column_name character varying NOT NULL,
    validation_type character varying NOT NULL,
    options character varying
);


--
-- Name: migration_validators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.migration_validators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: migration_validators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.migration_validators_id_seq OWNED BY public.migration_validators.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    event character varying NOT NULL,
    time_text character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description character varying NOT NULL,
    seconds integer
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: point_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.point_transactions (
    id integer NOT NULL,
    point integer NOT NULL,
    description character varying NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: point_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.point_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: point_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.point_transactions_id_seq OWNED BY public.point_transactions.id;


--
-- Name: provinces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.provinces (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    timezone character varying NOT NULL
);


--
-- Name: provinces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.provinces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: provinces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.provinces_id_seq OWNED BY public.provinces.id;


--
-- Name: referrers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.referrers (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: referrers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.referrers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: referrers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.referrers_id_seq OWNED BY public.referrers.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying,
    resource_id integer,
    resource_type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_id_seq
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
-- Name: short_problems; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.short_problems (
    id integer NOT NULL,
    contest_id integer NOT NULL,
    problem_no integer NOT NULL,
    statement character varying DEFAULT ''::character varying NOT NULL,
    answer character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    correct_score integer DEFAULT 1,
    wrong_score integer DEFAULT 0,
    empty_score integer DEFAULT 0
);


--
-- Name: short_problems_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.short_problems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: short_problems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.short_problems_id_seq OWNED BY public.short_problems.id;


--
-- Name: short_submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.short_submissions (
    id integer NOT NULL,
    short_problem_id integer NOT NULL,
    answer character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_contest_id integer NOT NULL
);


--
-- Name: short_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.short_submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: short_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.short_submissions_id_seq OWNED BY public.short_submissions.id;


--
-- Name: statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.statuses (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT chk_mv_statuses_name CHECK (((name IS NOT NULL) AND (length(btrim((name)::text)) > 0)))
);


--
-- Name: statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.statuses_id_seq OWNED BY public.statuses.id;


--
-- Name: submission_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.submission_pages (
    id integer NOT NULL,
    page_number integer NOT NULL,
    long_submission_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    submission_file_name character varying,
    submission_content_type character varying,
    submission_file_size integer,
    submission_updated_at timestamp without time zone
);


--
-- Name: submission_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.submission_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submission_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.submission_pages_id_seq OWNED BY public.submission_pages.id;


--
-- Name: temporary_markings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.temporary_markings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    long_submission_id integer NOT NULL,
    mark integer,
    tags character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: temporary_markings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.temporary_markings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temporary_markings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.temporary_markings_id_seq OWNED BY public.temporary_markings.id;


--
-- Name: user_contests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_contests (
    id integer NOT NULL,
    user_id integer NOT NULL,
    contest_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    certificate_sent boolean DEFAULT false NOT NULL,
    end_time timestamp without time zone
);


--
-- Name: user_contests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_contests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_contests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_contests_id_seq OWNED BY public.user_contests.id;


--
-- Name: user_notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_notifications (
    id integer NOT NULL,
    user_id integer NOT NULL,
    notification_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_notifications_id_seq OWNED BY public.user_notifications.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying NOT NULL,
    email character varying NOT NULL,
    hashed_password character varying NOT NULL,
    fullname character varying NOT NULL,
    school character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    salt character varying NOT NULL,
    auth_token character varying NOT NULL,
    province_id integer,
    status_id integer,
    color_id integer DEFAULT 1 NOT NULL,
    timezone character varying DEFAULT 'WIB'::character varying NOT NULL,
    verification character varying,
    enabled boolean DEFAULT false NOT NULL,
    tries integer DEFAULT 0 NOT NULL,
    referrer_id integer,
    CONSTRAINT users_username_lowercase_check CHECK (((username)::text = lower((username)::text)))
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: users_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_roles (
    user_id integer,
    role_id integer
);


--
-- Name: version_associations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.version_associations (
    id integer NOT NULL,
    version_id integer,
    foreign_key_name character varying NOT NULL,
    foreign_key_id integer
);


--
-- Name: version_associations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.version_associations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: version_associations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.version_associations_id_seq OWNED BY public.version_associations.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object text,
    created_at timestamp without time zone,
    object_changes text,
    transaction_id integer
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;


--
-- Name: about_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.about_users ALTER COLUMN id SET DEFAULT nextval('public.about_users_id_seq'::regclass);


--
-- Name: colors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.colors ALTER COLUMN id SET DEFAULT nextval('public.colors_id_seq'::regclass);


--
-- Name: contests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contests ALTER COLUMN id SET DEFAULT nextval('public.contests_id_seq'::regclass);


--
-- Name: delayed_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delayed_jobs ALTER COLUMN id SET DEFAULT nextval('public.delayed_jobs_id_seq'::regclass);


--
-- Name: feedback_answers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_answers ALTER COLUMN id SET DEFAULT nextval('public.feedback_answers_id_seq'::regclass);


--
-- Name: feedback_questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_questions ALTER COLUMN id SET DEFAULT nextval('public.feedback_questions_id_seq'::regclass);


--
-- Name: long_problems id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.long_problems ALTER COLUMN id SET DEFAULT nextval('public.long_problems_id_seq'::regclass);


--
-- Name: long_submissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.long_submissions ALTER COLUMN id SET DEFAULT nextval('public.long_submissions_id_seq'::regclass);


--
-- Name: migration_validators id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migration_validators ALTER COLUMN id SET DEFAULT nextval('public.migration_validators_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: point_transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_transactions ALTER COLUMN id SET DEFAULT nextval('public.point_transactions_id_seq'::regclass);


--
-- Name: provinces id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provinces ALTER COLUMN id SET DEFAULT nextval('public.provinces_id_seq'::regclass);


--
-- Name: referrers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.referrers ALTER COLUMN id SET DEFAULT nextval('public.referrers_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: short_problems id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.short_problems ALTER COLUMN id SET DEFAULT nextval('public.short_problems_id_seq'::regclass);


--
-- Name: short_submissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.short_submissions ALTER COLUMN id SET DEFAULT nextval('public.short_submissions_id_seq'::regclass);


--
-- Name: statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statuses ALTER COLUMN id SET DEFAULT nextval('public.statuses_id_seq'::regclass);


--
-- Name: submission_pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_pages ALTER COLUMN id SET DEFAULT nextval('public.submission_pages_id_seq'::regclass);


--
-- Name: temporary_markings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temporary_markings ALTER COLUMN id SET DEFAULT nextval('public.temporary_markings_id_seq'::regclass);


--
-- Name: user_contests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_contests ALTER COLUMN id SET DEFAULT nextval('public.user_contests_id_seq'::regclass);


--
-- Name: user_notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_notifications ALTER COLUMN id SET DEFAULT nextval('public.user_notifications_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: version_associations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.version_associations ALTER COLUMN id SET DEFAULT nextval('public.version_associations_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: about_users about_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.about_users
    ADD CONSTRAINT about_users_pkey PRIMARY KEY (id);


--
-- Name: colors colors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.colors
    ADD CONSTRAINT colors_pkey PRIMARY KEY (id);


--
-- Name: contests contests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contests
    ADD CONSTRAINT contests_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: feedback_answers feedback_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_answers
    ADD CONSTRAINT feedback_answers_pkey PRIMARY KEY (id);


--
-- Name: feedback_questions feedback_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_questions
    ADD CONSTRAINT feedback_questions_pkey PRIMARY KEY (id);


--
-- Name: long_problems long_problems_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.long_problems
    ADD CONSTRAINT long_problems_pkey PRIMARY KEY (id);


--
-- Name: long_submissions long_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.long_submissions
    ADD CONSTRAINT long_submissions_pkey PRIMARY KEY (id);


--
-- Name: migration_validators migration_validators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migration_validators
    ADD CONSTRAINT migration_validators_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: point_transactions point_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_transactions
    ADD CONSTRAINT point_transactions_pkey PRIMARY KEY (id);


--
-- Name: provinces provinces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provinces
    ADD CONSTRAINT provinces_pkey PRIMARY KEY (id);


--
-- Name: referrers referrers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.referrers
    ADD CONSTRAINT referrers_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: short_problems short_problems_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.short_problems
    ADD CONSTRAINT short_problems_pkey PRIMARY KEY (id);


--
-- Name: short_submissions short_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.short_submissions
    ADD CONSTRAINT short_submissions_pkey PRIMARY KEY (id);


--
-- Name: statuses statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statuses
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);


--
-- Name: submission_pages submission_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_pages
    ADD CONSTRAINT submission_pages_pkey PRIMARY KEY (id);


--
-- Name: temporary_markings temporary_markings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temporary_markings
    ADD CONSTRAINT temporary_markings_pkey PRIMARY KEY (id);


--
-- Name: user_contests user_contests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_contests
    ADD CONSTRAINT user_contests_pkey PRIMARY KEY (id);


--
-- Name: user_notifications user_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_notifications
    ADD CONSTRAINT user_notifications_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: version_associations version_associations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.version_associations
    ADD CONSTRAINT version_associations_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX delayed_jobs_priority ON public.delayed_jobs USING btree (priority, run_at);


--
-- Name: feedback_question_and_user_contest_unique_pair; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX feedback_question_and_user_contest_unique_pair ON public.feedback_answers USING btree (feedback_question_id, user_contest_id);


--
-- Name: index_colors_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_colors_on_name ON public.colors USING btree (name);


--
-- Name: index_contests_on_end_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contests_on_end_time ON public.contests USING btree (end_time);


--
-- Name: index_contests_on_feedback_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contests_on_feedback_time ON public.contests USING btree (feedback_time);


--
-- Name: index_contests_on_result_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contests_on_result_time ON public.contests USING btree (result_time);


--
-- Name: index_contests_on_start_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contests_on_start_time ON public.contests USING btree (start_time);


--
-- Name: index_feedback_questions_on_contest_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_feedback_questions_on_contest_id ON public.feedback_questions USING btree (contest_id);


--
-- Name: index_long_problems_on_contest_id_and_problem_no; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_long_problems_on_contest_id_and_problem_no ON public.long_problems USING btree (contest_id, problem_no);


--
-- Name: index_long_submissions_on_long_problem_id_and_user_contest_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_long_submissions_on_long_problem_id_and_user_contest_id ON public.long_submissions USING btree (long_problem_id, user_contest_id);


--
-- Name: index_point_transactions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_point_transactions_on_user_id ON public.point_transactions USING btree (user_id);


--
-- Name: index_provinces_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_provinces_on_name ON public.provinces USING btree (name);


--
-- Name: index_referrers_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_referrers_on_name ON public.referrers USING btree (name);


--
-- Name: index_roles_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_roles_on_name ON public.roles USING btree (name);


--
-- Name: index_roles_on_name_and_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_roles_on_name_and_resource_type_and_resource_id ON public.roles USING btree (name, resource_type, resource_id);


--
-- Name: index_roles_on_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_roles_on_resource_id ON public.roles USING btree (resource_id);


--
-- Name: index_short_problems_on_contest_id_and_problem_no; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_short_problems_on_contest_id_and_problem_no ON public.short_problems USING btree (contest_id, problem_no);


--
-- Name: index_short_submissions_on_short_problem_id_and_user_contest_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_short_submissions_on_short_problem_id_and_user_contest_id ON public.short_submissions USING btree (short_problem_id, user_contest_id);


--
-- Name: index_statuses_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_statuses_on_name ON public.statuses USING btree (name);


--
-- Name: index_submission_pages_on_page_number_and_long_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_submission_pages_on_page_number_and_long_submission_id ON public.submission_pages USING btree (page_number, long_submission_id);


--
-- Name: index_temporary_markings_on_user_id_and_long_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_temporary_markings_on_user_id_and_long_submission_id ON public.temporary_markings USING btree (user_id, long_submission_id);


--
-- Name: index_user_contests_on_user_id_and_contest_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_contests_on_user_id_and_contest_id ON public.user_contests USING btree (user_id, contest_id);


--
-- Name: index_user_notifications_on_user_id_and_notification_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_notifications_on_user_id_and_notification_id ON public.user_notifications USING btree (user_id, notification_id);


--
-- Name: index_users_on_auth_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_auth_token ON public.users USING btree (auth_token);


--
-- Name: index_users_on_color_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_color_id ON public.users USING btree (color_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_province_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_province_id ON public.users USING btree (province_id);


--
-- Name: index_users_on_referrer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_referrer_id ON public.users USING btree (referrer_id);


--
-- Name: index_users_on_status_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_status_id ON public.users USING btree (status_id);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_username ON public.users USING btree (username);


--
-- Name: index_users_on_username_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_username_gin ON public.users USING gin (username public.gin_trgm_ops);


--
-- Name: index_users_on_verification; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_verification ON public.users USING btree (verification);


--
-- Name: index_users_roles_on_user_id_and_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_roles_on_user_id_and_role_id ON public.users_roles USING btree (user_id, role_id);


--
-- Name: index_version_associations_on_foreign_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_version_associations_on_foreign_key ON public.version_associations USING btree (foreign_key_name, foreign_key_id);


--
-- Name: index_version_associations_on_version_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_version_associations_on_version_id ON public.version_associations USING btree (version_id);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON public.versions USING btree (item_type, item_id);


--
-- Name: index_versions_on_transaction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_transaction_id ON public.versions USING btree (transaction_id);


--
-- Name: unique_idx_on_migration_validators; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX unique_idx_on_migration_validators ON public.migration_validators USING btree (table_name, column_name, validation_type);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- Name: feedback_answers fk_rails_0615442e63; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_answers
    ADD CONSTRAINT fk_rails_0615442e63 FOREIGN KEY (feedback_question_id) REFERENCES public.feedback_questions(id) ON DELETE CASCADE;


--
-- Name: long_problems fk_rails_116a6ecec7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.long_problems
    ADD CONSTRAINT fk_rails_116a6ecec7 FOREIGN KEY (contest_id) REFERENCES public.contests(id) ON DELETE CASCADE;


--
-- Name: short_submissions fk_rails_117485e784; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.short_submissions
    ADD CONSTRAINT fk_rails_117485e784 FOREIGN KEY (user_contest_id) REFERENCES public.user_contests(id) ON DELETE CASCADE;


--
-- Name: short_submissions fk_rails_1467c5d84d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.short_submissions
    ADD CONSTRAINT fk_rails_1467c5d84d FOREIGN KEY (short_problem_id) REFERENCES public.short_problems(id) ON DELETE CASCADE;


--
-- Name: temporary_markings fk_rails_349a6ecb7e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temporary_markings
    ADD CONSTRAINT fk_rails_349a6ecb7e FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: feedback_answers fk_rails_374404a088; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_answers
    ADD CONSTRAINT fk_rails_374404a088 FOREIGN KEY (user_contest_id) REFERENCES public.user_contests(id) ON DELETE CASCADE;


--
-- Name: feedback_questions fk_rails_38d13509cf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback_questions
    ADD CONSTRAINT fk_rails_38d13509cf FOREIGN KEY (contest_id) REFERENCES public.contests(id) ON DELETE CASCADE;


--
-- Name: user_contests fk_rails_418fd0bbd0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_contests
    ADD CONSTRAINT fk_rails_418fd0bbd0 FOREIGN KEY (contest_id) REFERENCES public.contests(id) ON DELETE CASCADE;


--
-- Name: users fk_rails_560da4bd54; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_560da4bd54 FOREIGN KEY (province_id) REFERENCES public.provinces(id) ON DELETE SET NULL;


--
-- Name: short_problems fk_rails_60f1de2193; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.short_problems
    ADD CONSTRAINT fk_rails_60f1de2193 FOREIGN KEY (contest_id) REFERENCES public.contests(id) ON DELETE CASCADE;


--
-- Name: submission_pages fk_rails_62bec7c828; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submission_pages
    ADD CONSTRAINT fk_rails_62bec7c828 FOREIGN KEY (long_submission_id) REFERENCES public.long_submissions(id) ON DELETE CASCADE;


--
-- Name: temporary_markings fk_rails_7dcab47693; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temporary_markings
    ADD CONSTRAINT fk_rails_7dcab47693 FOREIGN KEY (long_submission_id) REFERENCES public.long_submissions(id) ON DELETE CASCADE;


--
-- Name: users fk_rails_87f75b7957; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_87f75b7957 FOREIGN KEY (color_id) REFERENCES public.colors(id) ON DELETE SET NULL;


--
-- Name: long_submissions fk_rails_ab0e9f9d12; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.long_submissions
    ADD CONSTRAINT fk_rails_ab0e9f9d12 FOREIGN KEY (user_contest_id) REFERENCES public.user_contests(id) ON DELETE CASCADE;


--
-- Name: user_notifications fk_rails_cdbff2ee9e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_notifications
    ADD CONSTRAINT fk_rails_cdbff2ee9e FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users fk_rails_ce4a327a04; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_ce4a327a04 FOREIGN KEY (status_id) REFERENCES public.statuses(id) ON DELETE SET NULL;


--
-- Name: user_notifications fk_rails_d238d8ef07; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_notifications
    ADD CONSTRAINT fk_rails_d238d8ef07 FOREIGN KEY (notification_id) REFERENCES public.notifications(id) ON DELETE CASCADE;


--
-- Name: user_contests fk_rails_ee078c9177; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_contests
    ADD CONSTRAINT fk_rails_ee078c9177 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: long_submissions fk_rails_f4fee8fddd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.long_submissions
    ADD CONSTRAINT fk_rails_f4fee8fddd FOREIGN KEY (long_problem_id) REFERENCES public.long_problems(id) ON DELETE CASCADE;


--
-- Name: point_transactions fk_rails_fc956f9f03; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.point_transactions
    ADD CONSTRAINT fk_rails_fc956f9f03 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20160215163631');

INSERT INTO schema_migrations (version) VALUES ('20160216110237');

INSERT INTO schema_migrations (version) VALUES ('20160216114412');

INSERT INTO schema_migrations (version) VALUES ('20160326180041');

INSERT INTO schema_migrations (version) VALUES ('20160404090458');

INSERT INTO schema_migrations (version) VALUES ('20160428202525');

INSERT INTO schema_migrations (version) VALUES ('20160502194650');

INSERT INTO schema_migrations (version) VALUES ('20160502195254');

INSERT INTO schema_migrations (version) VALUES ('20160502201402');

INSERT INTO schema_migrations (version) VALUES ('20160502201418');

INSERT INTO schema_migrations (version) VALUES ('20160502230426');

INSERT INTO schema_migrations (version) VALUES ('20160502231622');

INSERT INTO schema_migrations (version) VALUES ('20160507185159');

INSERT INTO schema_migrations (version) VALUES ('20160507220530');

INSERT INTO schema_migrations (version) VALUES ('20160522071340');

INSERT INTO schema_migrations (version) VALUES ('20160522090953');

INSERT INTO schema_migrations (version) VALUES ('20160522091423');

INSERT INTO schema_migrations (version) VALUES ('20160522100000');

INSERT INTO schema_migrations (version) VALUES ('20160522110000');

INSERT INTO schema_migrations (version) VALUES ('20160522152016');

INSERT INTO schema_migrations (version) VALUES ('20160522173347');

INSERT INTO schema_migrations (version) VALUES ('20160522173630');

INSERT INTO schema_migrations (version) VALUES ('20160522174618');

INSERT INTO schema_migrations (version) VALUES ('20160522180330');

INSERT INTO schema_migrations (version) VALUES ('20160522180331');

INSERT INTO schema_migrations (version) VALUES ('20160522180332');

INSERT INTO schema_migrations (version) VALUES ('20160522180333');

INSERT INTO schema_migrations (version) VALUES ('20160522180424');

INSERT INTO schema_migrations (version) VALUES ('20160529071200');

INSERT INTO schema_migrations (version) VALUES ('20160529151359');

INSERT INTO schema_migrations (version) VALUES ('20160529152106');

INSERT INTO schema_migrations (version) VALUES ('20160612082425');

INSERT INTO schema_migrations (version) VALUES ('20160613165643');

INSERT INTO schema_migrations (version) VALUES ('20160613170017');

INSERT INTO schema_migrations (version) VALUES ('20160614060706');

INSERT INTO schema_migrations (version) VALUES ('20160614060717');

INSERT INTO schema_migrations (version) VALUES ('20160614065545');

INSERT INTO schema_migrations (version) VALUES ('20160614073120');

INSERT INTO schema_migrations (version) VALUES ('20160618143907');

INSERT INTO schema_migrations (version) VALUES ('20160619083225');

INSERT INTO schema_migrations (version) VALUES ('20160619083243');

INSERT INTO schema_migrations (version) VALUES ('20160619113034');

INSERT INTO schema_migrations (version) VALUES ('20160619113128');

INSERT INTO schema_migrations (version) VALUES ('20160702092127');

INSERT INTO schema_migrations (version) VALUES ('20160702095227');

INSERT INTO schema_migrations (version) VALUES ('20160702095353');

INSERT INTO schema_migrations (version) VALUES ('20160702100530');

INSERT INTO schema_migrations (version) VALUES ('20160702100736');

INSERT INTO schema_migrations (version) VALUES ('20160702101103');

INSERT INTO schema_migrations (version) VALUES ('20160702102022');

INSERT INTO schema_migrations (version) VALUES ('20160702102040');

INSERT INTO schema_migrations (version) VALUES ('20160702102335');

INSERT INTO schema_migrations (version) VALUES ('20160703090048');

INSERT INTO schema_migrations (version) VALUES ('20160703160846');

INSERT INTO schema_migrations (version) VALUES ('20160703185043');

INSERT INTO schema_migrations (version) VALUES ('20160705122134');

INSERT INTO schema_migrations (version) VALUES ('20160705122941');

INSERT INTO schema_migrations (version) VALUES ('20160706113410');

INSERT INTO schema_migrations (version) VALUES ('20160706120600');

INSERT INTO schema_migrations (version) VALUES ('20160706120738');

INSERT INTO schema_migrations (version) VALUES ('20160706121308');

INSERT INTO schema_migrations (version) VALUES ('20160707152010');

INSERT INTO schema_migrations (version) VALUES ('20160709150245');

INSERT INTO schema_migrations (version) VALUES ('20160710154832');

INSERT INTO schema_migrations (version) VALUES ('20160710154849');

INSERT INTO schema_migrations (version) VALUES ('20160710173756');

INSERT INTO schema_migrations (version) VALUES ('20160710182003');

INSERT INTO schema_migrations (version) VALUES ('20160712051842');

INSERT INTO schema_migrations (version) VALUES ('20160712154745');

INSERT INTO schema_migrations (version) VALUES ('20160712180553');

INSERT INTO schema_migrations (version) VALUES ('20160713052032');

INSERT INTO schema_migrations (version) VALUES ('20160714041253');

INSERT INTO schema_migrations (version) VALUES ('20160714154105');

INSERT INTO schema_migrations (version) VALUES ('20160714174434');

INSERT INTO schema_migrations (version) VALUES ('20160716000155');

INSERT INTO schema_migrations (version) VALUES ('20160720081651');

INSERT INTO schema_migrations (version) VALUES ('20160720082711');

INSERT INTO schema_migrations (version) VALUES ('20160720155458');

INSERT INTO schema_migrations (version) VALUES ('20160726085657');

INSERT INTO schema_migrations (version) VALUES ('20160730035813');

INSERT INTO schema_migrations (version) VALUES ('20160730161813');

INSERT INTO schema_migrations (version) VALUES ('20160730173851');

INSERT INTO schema_migrations (version) VALUES ('20160804110128');

INSERT INTO schema_migrations (version) VALUES ('20160809150225');

INSERT INTO schema_migrations (version) VALUES ('20160818025113');

INSERT INTO schema_migrations (version) VALUES ('20160831112025');

INSERT INTO schema_migrations (version) VALUES ('20160831124049');

INSERT INTO schema_migrations (version) VALUES ('20160918043247');

INSERT INTO schema_migrations (version) VALUES ('20160918044056');

INSERT INTO schema_migrations (version) VALUES ('20161006012803');

INSERT INTO schema_migrations (version) VALUES ('20161006191146');

INSERT INTO schema_migrations (version) VALUES ('20161006191442');

INSERT INTO schema_migrations (version) VALUES ('20161006192548');

INSERT INTO schema_migrations (version) VALUES ('20161014091434');

INSERT INTO schema_migrations (version) VALUES ('20161102163618');

INSERT INTO schema_migrations (version) VALUES ('20161102163917');

INSERT INTO schema_migrations (version) VALUES ('20161103010922');

INSERT INTO schema_migrations (version) VALUES ('20161103011624');

INSERT INTO schema_migrations (version) VALUES ('20161218180745');

INSERT INTO schema_migrations (version) VALUES ('20161227160540');

INSERT INTO schema_migrations (version) VALUES ('20161227164831');

INSERT INTO schema_migrations (version) VALUES ('20161231035149');

INSERT INTO schema_migrations (version) VALUES ('20161231043448');

INSERT INTO schema_migrations (version) VALUES ('20170321042305');

INSERT INTO schema_migrations (version) VALUES ('20170321044226');

INSERT INTO schema_migrations (version) VALUES ('20170321044422');

INSERT INTO schema_migrations (version) VALUES ('20170525065802');

INSERT INTO schema_migrations (version) VALUES ('20180105121032');

INSERT INTO schema_migrations (version) VALUES ('20180124142305');

INSERT INTO schema_migrations (version) VALUES ('20180124151412');

INSERT INTO schema_migrations (version) VALUES ('20180124153301');

INSERT INTO schema_migrations (version) VALUES ('20180226033248');

INSERT INTO schema_migrations (version) VALUES ('20210119090413');

INSERT INTO schema_migrations (version) VALUES ('20210122183013');

INSERT INTO schema_migrations (version) VALUES ('20210203093153');

INSERT INTO schema_migrations (version) VALUES ('20210203093232');

INSERT INTO schema_migrations (version) VALUES ('20210203093336');

INSERT INTO schema_migrations (version) VALUES ('20210217071002');

INSERT INTO schema_migrations (version) VALUES ('20210303071859');

INSERT INTO schema_migrations (version) VALUES ('20210303072630');

INSERT INTO schema_migrations (version) VALUES ('20210303073140');

INSERT INTO schema_migrations (version) VALUES ('20210317051727');

