--
-- PostgreSQL database dump
--

-- Started on 2009-09-08 08:45:53 BRT

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- TOC entry 1477 (class 1259 OID 36019)
-- Dependencies: 3
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE comments_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.comments_id_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 1478 (class 1259 OID 36021)
-- Dependencies: 1753 3
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE comments (
    id integer DEFAULT nextval('comments_id_seq'::regclass) NOT NULL,
    post_id integer NOT NULL,
    user_id integer NOT NULL,
    body text NOT NULL
);


ALTER TABLE public.comments OWNER TO postgres;

--
-- TOC entry 1479 (class 1259 OID 36030)
-- Dependencies: 3
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE posts_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.posts_id_seq OWNER TO postgres;

--
-- TOC entry 1480 (class 1259 OID 36032)
-- Dependencies: 1754 3
-- Name: posts; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE posts (
    id integer DEFAULT nextval('posts_id_seq'::regclass) NOT NULL,
    user_id integer NOT NULL,
    title character varying(50) NOT NULL,
    body text NOT NULL,
    created timestamp without time zone,
    modified timestamp without time zone
);


ALTER TABLE public.posts OWNER TO postgres;

--
-- TOC entry 1481 (class 1259 OID 36041)
-- Dependencies: 3
-- Name: posts_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE posts_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.posts_tags_id_seq OWNER TO postgres;

--
-- TOC entry 1482 (class 1259 OID 36043)
-- Dependencies: 1755 3
-- Name: posts_tags; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE posts_tags (
    id integer DEFAULT nextval('posts_tags_id_seq'::regclass) NOT NULL,
    post_id integer NOT NULL,
    tag_id integer NOT NULL
);


ALTER TABLE public.posts_tags OWNER TO postgres;

--
-- TOC entry 1483 (class 1259 OID 36049)
-- Dependencies: 3
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tags_id_seq OWNER TO postgres;

--
-- TOC entry 1484 (class 1259 OID 36051)
-- Dependencies: 1756 3
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tags (
    id integer DEFAULT nextval('tags_id_seq'::regclass) NOT NULL,
    name character varying(20) NOT NULL
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- TOC entry 1485 (class 1259 OID 36057)
-- Dependencies: 3
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 1486 (class 1259 OID 36059)
-- Dependencies: 1757 3
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    id integer DEFAULT nextval('users_id_seq'::regclass) NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(50) NOT NULL,
    email character varying(200) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 1759 (class 2606 OID 36029)
-- Dependencies: 1478 1478
-- Name: pkcomments; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT pkcomments PRIMARY KEY (id);


--
-- TOC entry 1761 (class 2606 OID 36040)
-- Dependencies: 1480 1480
-- Name: pkposts; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT pkposts PRIMARY KEY (id);


--
-- TOC entry 1763 (class 2606 OID 36048)
-- Dependencies: 1482 1482
-- Name: pkposts_tags; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY posts_tags
    ADD CONSTRAINT pkposts_tags PRIMARY KEY (id);


--
-- TOC entry 1765 (class 2606 OID 36056)
-- Dependencies: 1484 1484
-- Name: pktags; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT pktags PRIMARY KEY (id);


--
-- TOC entry 1767 (class 2606 OID 36064)
-- Dependencies: 1486 1486
-- Name: pkusers; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT pkusers PRIMARY KEY (id);


--
-- TOC entry 1768 (class 2606 OID 36065)
-- Dependencies: 1478 1480 1760
-- Name: fk_comments_posts; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT fk_comments_posts FOREIGN KEY (post_id) REFERENCES posts(id);


--
-- TOC entry 1769 (class 2606 OID 36070)
-- Dependencies: 1478 1486 1766
-- Name: fk_comments_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT fk_comments_users FOREIGN KEY (user_id) REFERENCES users(id);


--
-- TOC entry 1771 (class 2606 OID 36080)
-- Dependencies: 1760 1480 1482
-- Name: fk_posts_tags_posts; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY posts_tags
    ADD CONSTRAINT fk_posts_tags_posts FOREIGN KEY (post_id) REFERENCES posts(id);


--
-- TOC entry 1772 (class 2606 OID 36085)
-- Dependencies: 1764 1482 1484
-- Name: fk_posts_tags_tags; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY posts_tags
    ADD CONSTRAINT fk_posts_tags_tags FOREIGN KEY (tag_id) REFERENCES tags(id);


--
-- TOC entry 1770 (class 2606 OID 36075)
-- Dependencies: 1486 1480 1766
-- Name: fk_posts_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT fk_posts_users FOREIGN KEY (user_id) REFERENCES users(id);


--
-- TOC entry 1776 (class 0 OID 0)
-- Dependencies: 3
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2009-09-08 08:45:54 BRT

--
-- PostgreSQL database dump complete
--

