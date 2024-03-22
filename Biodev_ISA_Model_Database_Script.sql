-- Table: public.Assay

-- DROP TABLE IF EXISTS public."Assay";

CREATE TABLE IF NOT EXISTS public."Assay"
(
    id bigserial NOT NULL,
    study_id bigint NOT NULL,
    measurement_type_annotation_id integer NOT NULL,
    technology_type_annotation_id integer NOT NULL,
    technology_platform_id integer NOT NULL,
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    sample_name character varying(100) COLLATE pg_catalog."default" NOT NULL,
	file_name text, 
    CONSTRAINT "Assay_pkey" PRIMARY KEY (id),
    CONSTRAINT "Assay_measurement_type_annotation_id_fkey" FOREIGN KEY (measurement_type_annotation_id)
        REFERENCES public."OntologyAnnotation" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT "Assay_study_id_fkey" FOREIGN KEY (study_id)
        REFERENCES public."Study" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT "Assay_technology_platform_id_fkey" FOREIGN KEY (technology_platform_id)
        REFERENCES public."TechnologyPlatform" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT "Assay_technology_type_annotation_id_fkey" FOREIGN KEY (technology_type_annotation_id)
        REFERENCES public."OntologyAnnotation" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Assay"
    OWNER to postgres;
	

-- Table: public.AssayDetail

-- DROP TABLE IF EXISTS public."AssayDetail";

CREATE TABLE IF NOT EXISTS public."AssayDetail"
(
    id bigserial NOT NULL,
    assay_id bigint NOT NULL,
    protocol_ref character varying(100) COLLATE pg_catalog."default" NOT NULL,
    data_file character varying(500) COLLATE pg_catalog."default",
    data_file_type character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT "AssayDetail_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."AssayDetail"
    OWNER to postgres;


-- Table: public.AssayProtocol

-- DROP TABLE IF EXISTS public."AssayProtocol";

CREATE TABLE IF NOT EXISTS public."AssayProtocol"
(
    id bigserial NOT NULL ,
    Assay_id bigint NOT NULL,
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    type character varying(100) COLLATE pg_catalog."default" NOT NULL,
    term_source_ref character varying(50) COLLATE pg_catalog."default",
    term_accession_number character varying(100) COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default" NOT NULL,
    uri character varying(400) COLLATE pg_catalog."default",
    version character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT "AssayProtocol_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."AssayProtocol"
    OWNER to postgres;

-- Table: public.AssayMeasurements

-- DROP TABLE IF EXISTS public."AssayMeasurements";

CREATE TABLE IF NOT EXISTS public."AssayMeasurements"
(
    id bigserial NOT NULL,
    assay_id bigint NOT NULL,
    compound_id bigint NOT NULL,
    intensity numeric(14,4),
    CONSTRAINT "AssayMeasurements_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."AssayMeasurements"
    OWNER to postgres;
	
-- Table: public.Author

-- DROP TABLE IF EXISTS public."Author";

CREATE TABLE IF NOT EXISTS public."Author"
(
    id bigserial NOT NULL,
    name text COLLATE pg_catalog."default" NOT NULL,
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    CONSTRAINT "Author_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Author"
    OWNER to postgres;
	
-- Table: public.AuthorOrganization

-- DROP TABLE IF EXISTS public."AuthorOrganization";

CREATE TABLE IF NOT EXISTS public."AuthorOrganization"
(
    id bigserial NOT NULL,
    author_id bigint NOT NULL,
    organization_id bigint NOT NULL,
    active character(1) COLLATE pg_catalog."default" DEFAULT 'Y'::bpchar,
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    CONSTRAINT "AuthorOrganization_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."AuthorOrganization"
    OWNER to postgres;

-- Table: public.Compound

-- DROP TABLE IF EXISTS public."Compound";

CREATE TABLE IF NOT EXISTS public."Compound"
(
    id bigserial NOT NULL,
    name text COLLATE pg_catalog."default" NOT NULL,
    name_corrected text COLLATE pg_catalog."default" NOT NULL DEFAULT ''::text,
    mass_spec_polarity text COLLATE pg_catalog."default" NOT NULL,
    molecular_formula text COLLATE pg_catalog."default" NOT NULL,
    mono_molecule_mass numeric(22,16) NOT NULL,
    has_adduct_h character(1) COLLATE pg_catalog."default",
    has_adduct_na character(1) COLLATE pg_catalog."default",
    has_adduct_k character(1) COLLATE pg_catalog."default",
    has_adduct_fa character(1) COLLATE pg_catalog."default",
    has_fragment_loss_h2o character(1) COLLATE pg_catalog."default",
    has_fragment_loss_hcooh character(1) COLLATE pg_catalog."default",
    pubchem_id text COLLATE pg_catalog."default",
    pubchem_url text COLLATE pg_catalog."default",
    pubchem_sid text COLLATE pg_catalog."default",
    cas_id text COLLATE pg_catalog."default",
    kegg_id_csid text COLLATE pg_catalog."default",
    hmdb_ymdb_id text COLLATE pg_catalog."default",
    metlin_id text COLLATE pg_catalog."default",
    chebi text COLLATE pg_catalog."default",
    smiles text COLLATE pg_catalog."default",
    inchi_key text COLLATE pg_catalog."default",
    class_chemical_taxonomy text COLLATE pg_catalog."default",
    subclass_chemical_taxonomy text COLLATE pg_catalog."default",
    supplier_cat_no text COLLATE pg_catalog."default",
    supplier_product_name text COLLATE pg_catalog."default",
    biospecimen_locations text COLLATE pg_catalog."default",
    tissue_locations text COLLATE pg_catalog."default",
    extra_pc_cid text COLLATE pg_catalog."default",
    has_fragment_loss_fa character(1) COLLATE pg_catalog."default",
    canonical_smiles text COLLATE pg_catalog."default",
    CONSTRAINT "Compound_pkey" PRIMARY KEY (id),
    CONSTRAINT compound_name UNIQUE (name)
        INCLUDE(name)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Compound"
    OWNER to postgres;

COMMENT ON TABLE public."Compound"
    IS 'Compounds used for research';


-- Table: public.Configs

-- DROP TABLE IF EXISTS public."Configs";

CREATE TABLE IF NOT EXISTS public."Configs"
(
    id serial NOT NULL,
    name character varying(50) COLLATE pg_catalog."default",
    type character varying(50) COLLATE pg_catalog."default" NOT NULL,
    config json NOT NULL,
    active boolean,
    created_by integer,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by integer,
    updated_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Configs_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Configs"
    OWNER to postgres;

-- Table: public.Contact

-- DROP TABLE IF EXISTS public."Contact";

CREATE TABLE IF NOT EXISTS public."Contact"
(
    id bigserial NOT NULL,
    email_id text COLLATE pg_catalog."default" NOT NULL,
    name text COLLATE pg_catalog."default" NOT NULL,
    phone text COLLATE pg_catalog."default" NOT NULL,
    address text COLLATE pg_catalog."default" NOT NULL,
    organization_id integer NOT NULL,
    type character(1) COLLATE pg_catalog."default" NOT NULL,
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    CONSTRAINT "Contact_pkey" PRIMARY KEY (id),
    CONSTRAINT "Contact_organization_id_fkey" FOREIGN KEY (organization_id)
        REFERENCES public."Organization" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Contact"
    OWNER to postgres;
	
-- Table: public.ContactRole

-- DROP TABLE IF EXISTS public."ContactRole";

CREATE TABLE IF NOT EXISTS public."ContactRole"
(
    id bigserial NOT NULL,
    contact_id bigint NOT NULL,
    role_annotation_id integer NOT NULL,
    active character(1) COLLATE pg_catalog."default" NOT NULL DEFAULT 'Y'::bpchar,
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    CONSTRAINT "ContactRole_pkey" PRIMARY KEY (id),
    CONSTRAINT "ContactRole_contact_id_fkey" FOREIGN KEY (contact_id)
        REFERENCES public."Contact" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT "ContactRole_role_annotation_id_fkey" FOREIGN KEY (role_annotation_id)
        REFERENCES public."OntologyAnnotation" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."ContactRole"
    OWNER to postgres;
	

-- Table: public.Investigation

-- DROP TABLE IF EXISTS public."Investigation";

CREATE TABLE IF NOT EXISTS public."Investigation"
(
    id bigserial NOT NULL,
    title text COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default" NOT NULL,
    submission_date timestamp without time zone NOT NULL,
    public_release_date timestamp without time zone NOT NULL,
    pub_list text COLLATE pg_catalog."default",
    contact_list text COLLATE pg_catalog."default",
    contact_role_list text COLLATE pg_catalog."default",
    created_by_user integer NOT NULL,
    created_on time without time zone NOT NULL,
    updated_by_user integer,
    updated_on time without time zone,
    CONSTRAINT "Investigation_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Investigation"
    OWNER to postgres;
	
-- Table: public.InvestigationComment

-- DROP TABLE IF EXISTS public."InvestigationComment";

CREATE TABLE IF NOT EXISTS public."InvestigationComment"
(
    id bigserial NOT NULL,
    investigation_id bigint NOT NULL,
    parameter character varying(200) COLLATE pg_catalog."default" NOT NULL,
    value character varying(200) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "InvestigationComment_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."InvestigationComment"
    OWNER to postgres;
	
-- Table: public.OntologyAnnotation

-- DROP TABLE IF EXISTS public."OntologyAnnotation";

CREATE TABLE IF NOT EXISTS public."OntologyAnnotation"
(
    id bigserial NOT NULL,
    type text COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default" NOT NULL,
    source_accession_number bigint NOT NULL,
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    source_ref character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT "OntologyAnnotation_pkey" PRIMARY KEY (id),
    CONSTRAINT "OntologyAnnotation_source_accession_number_fkey" FOREIGN KEY (source_accession_number)
        REFERENCES public."OntologySource" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."OntologyAnnotation"
    OWNER to postgres;
	
-- Table: public.OntologyList

-- DROP TABLE IF EXISTS public."OntologyList";

CREATE TABLE IF NOT EXISTS public."OntologyList"
(
    code character varying(30) COLLATE pg_catalog."default" NOT NULL,
    name text COLLATE pg_catalog."default",
    created_by_user integer,
    created_on timestamp without time zone,
    updated_by_user integer,
    updated_on timestamp without time zone,
    CONSTRAINT "OntologyList_pkey" PRIMARY KEY (code)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."OntologyList"
    OWNER to postgres;
	

-- Table: public.OntologySource

-- DROP TABLE IF EXISTS public."OntologySource";

CREATE TABLE IF NOT EXISTS public."OntologySource"
(
    id integer NOT NULL,
    name text COLLATE pg_catalog."default" NOT NULL,
    file text COLLATE pg_catalog."default" NOT NULL,
    accession_number text COLLATE pg_catalog."default" NOT NULL,
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    CONSTRAINT "OntologySource_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."OntologySource"
    OWNER to postgres;
	

-- Table: public.Organization

-- DROP TABLE IF EXISTS public."Organization";

CREATE TABLE IF NOT EXISTS public."Organization"
(
    id integer NOT NULL,
    name text COLLATE pg_catalog."default" NOT NULL,
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    CONSTRAINT "Organization_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Organization"
    OWNER to postgres;
	

-- Table: public.Publication

-- DROP TABLE IF EXISTS public."Publication";

CREATE TABLE IF NOT EXISTS public."Publication"
(
    pub_med_id bigint NOT NULL,
    title text COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default" NOT NULL,
    author_list text COLLATE pg_catalog."default",
    status_annotation_id integer NOT NULL,
    type character(1) COLLATE pg_catalog."default" NOT NULL,
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    doi date NOT NULL,
    status_term_source_ref character varying(100) COLLATE pg_catalog."default",
    status_accession_number character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT "Publication_pkey" PRIMARY KEY (pub_med_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Publication"
    OWNER to postgres;
	

-- Table: public.Study

-- DROP TABLE IF EXISTS public."Study";

CREATE TABLE IF NOT EXISTS public."Study"
(
    id bigserial NOT NULL,
    title text COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default" NOT NULL,
    submission_date timestamp without time zone,
    public_release_date timestamp without time zone,
    design_type_annotation_id integer NOT NULL,
    contact_list text COLLATE pg_catalog."default",
    contact_role_list text COLLATE pg_catalog."default",
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    investigation_id bigint NOT NULL,
    sample_name character varying(100) COLLATE pg_catalog."default",
    pub_list text COLLATE pg_catalog."default",
	file_name text, 
    CONSTRAINT "Study_pkey" PRIMARY KEY (id),
    CONSTRAINT "Study_investigation_id_fkey" FOREIGN KEY (investigation_id)
        REFERENCES public."Investigation" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Study"
    OWNER to postgres;
	
-- Table: public.StudyCharacteristic

-- DROP TABLE IF EXISTS public."StudyCharacteristic";

CREATE TABLE IF NOT EXISTS public."StudyCharacteristic"
(
    id bigserial NOT NULL,
    study_id bigint NOT NULL,
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    value character varying(100) COLLATE pg_catalog."default" NOT NULL,
    term_source_ref character varying(50) COLLATE pg_catalog."default",
    term_accession_number character varying(300) COLLATE pg_catalog."default",
    CONSTRAINT "StudyCharacteristic_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."StudyCharacteristic"
    OWNER to postgres;
	
-- Table: public.StudyComment

-- DROP TABLE IF EXISTS public."StudyComment";

CREATE TABLE IF NOT EXISTS public."StudyComment"
(
    id bigserial NOT NULL,
    study_id bigint NOT NULL,
    parameter character varying(200) COLLATE pg_catalog."default" NOT NULL,
    value character varying(200) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "StudyComment_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."StudyComment"
    OWNER to postgres;
	
-- Table: public.StudyFactor

-- DROP TABLE IF EXISTS public."StudyFactor";

CREATE TABLE IF NOT EXISTS public."StudyFactor"
(
    id bigserial NOT NULL,
    study_id bigint NOT NULL,
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    type character varying(200) COLLATE pg_catalog."default" NOT NULL,
    unit character varying(50) COLLATE pg_catalog."default",
    term_source_ref character varying(100) COLLATE pg_catalog."default",
    "term-accession_number" character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT "StudyFactor_pkey" PRIMARY KEY (id, study_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."StudyFactor"
    OWNER to postgres;
	
-- Table: public.StudyFactorDetails

-- DROP TABLE IF EXISTS public."StudyFactorDetails";

CREATE TABLE IF NOT EXISTS public."StudyFactorDetails"
(
    id bigserial NOT NULL,
    study_id bigint NOT NULL,
    study_factor_id bigint NOT NULL,
    value character varying(100) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "StudyFactorDetails_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."StudyFactorDetails"
    OWNER to postgres;
	

-- Table: public.StudyProtocol

-- DROP TABLE IF EXISTS public."StudyProtocol";

CREATE TABLE IF NOT EXISTS public."StudyProtocol"
(
    id bigserial NOT NULL,
    study_id bigint NOT NULL,
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    type character varying(100) COLLATE pg_catalog."default" NOT NULL,
    term_source_ref character varying(50) COLLATE pg_catalog."default",
    term_accession_number character varying(100) COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default" NOT NULL,
    uri character varying(400) COLLATE pg_catalog."default",
    version character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT "StudyProtocol_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."StudyProtocol"
    OWNER to postgres;
	
-- Table: public.StudyProtocolComponent

-- DROP TABLE IF EXISTS public."StudyProtocolComponent";

CREATE TABLE IF NOT EXISTS public."StudyProtocolComponent"
(
    id bigserial NOT NULL,
    study_protocol_id bigint NOT NULL,
    name character varying(100) COLLATE pg_catalog."default",
    type character varying(100) COLLATE pg_catalog."default",
    term_source_ref character varying(50) COLLATE pg_catalog."default",
    "term-accession_number" character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT "StudyProtocolComponent_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."StudyProtocolComponent"
    OWNER to postgres;
	
-- Table: public.StudyProtocolParameter

-- DROP TABLE IF EXISTS public."StudyProtocolParameter";

CREATE TABLE IF NOT EXISTS public."StudyProtocolParameter"
(
    id bigserial NOT NULL,
    study_protocol_id bigint NOT NULL,
    parameter character varying(100) COLLATE pg_catalog."default",
    type character varying(100) COLLATE pg_catalog."default",
    term_source_ref character varying(100) COLLATE pg_catalog."default",
    term_accession_number character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT "StudyProtocolParameter_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."StudyProtocolParameter"
    OWNER to postgres;
	
-- Table: public.TechnologyPlatform

-- DROP TABLE IF EXISTS public."TechnologyPlatform";

CREATE TABLE IF NOT EXISTS public."TechnologyPlatform"
(
    id serial NOT NULL,
    description text COLLATE pg_catalog."default" NOT NULL,
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    CONSTRAINT "TechnologyPlatform_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."TechnologyPlatform"
    OWNER to postgres;
	
