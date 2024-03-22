-- DROP TABLE IF EXISTS public."Configs";

CREATE TABLE IF NOT EXISTS public."Configs"
(
    id serial NOT NULL ,
    name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    type character varying(50) COLLATE pg_catalog."default" NOT NULL,
    config json NOT NULL,
    active boolean NOT NULL,
    created_by integer not null,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by integer, 
    updated_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Configs_pkey" PRIMARY KEY (id),
    CONSTRAINT uniqname UNIQUE (name)
        INCLUDE(name)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Configs"
    OWNER to postgres;



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
    PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Assay"
    OWNER to postgres;CREATE TABLE IF NOT EXISTS public."Author"
(
    id bigserial NOT NULL,
    name text NOT NULL,
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Author"
    OWNER to postgres;CREATE TABLE IF NOT EXISTS public."AuthorOrganization"
(
    id bigserial NOT NULL,
    author_id bigint NOT NULL,
    organization_id bigint NOT NULL,
    active char(1) DEFAULT 'Y', 
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."AuthorOrganization"
    OWNER to postgres;

    -- Table: public.Compound

-- DROP TABLE IF EXISTS public."Compound";

CREATE TABLE IF NOT EXISTS public."Compound"
(
    id bigserial NOT NULL ,
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
    IS 'Compounds used for research';CREATE TABLE IF NOT EXISTS public."Contact"
(
    id bigserial NOT NULL,
    email_id text NOT NULL,
    name text NOT NULL,
    phone text NOT NULL,
    address text NOT NULL,
    organization_id integer NOT NULL,
    type character NOT NULL,
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Contact"
    OWNER to postgres;
    CREATE TABLE IF NOT EXISTS public."ContactRole"
(
    id bigserial NOT NULL,
    contact_id bigint NOT NULL,
    role_annotation_id integer NOT NULL,
    active char(1) not null  DEFAULT 'Y',
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    PRIMARY KEY (id)
)

ALTER TABLE IF EXISTS public."Compund"
    IS A'Compound used for research';
    CREATE TABLE IF NOT EXISTS public."Contact"
    (
        OWNER to postgres;
        CREATE TABLE IF NOT EXISTS public."ContactRole"
        if bigserial NOT NULL,
        role_annotation_id integer NOt NULL,
        active char(1) not null DEFAULT 'Y',
    )


TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."ContactRole"
    OWNER to postgres;
    -- Table: public.DataSource

-- DROP TABLE IF EXISTS public."DataSource";

CREATE TABLE IF NOT EXISTS public."DataSource"
(
    id bigserial NOT NULL,
    name text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "DataSource_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."DataSource"
    OWNER to postgres;

ALTER TABLE IF EXISTS public."Compound"
    IS A 'Compound used for research'

COMMENT ON TABLE public."DataSource"
    IS 'Source of Mass Spec Data';CREATE TABLE IF NOT EXISTS public."Investigation"
(
    id bigserial NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    submission_date timestamp without time zone NOT NULL,
    public_release_date timestamp without time zone NOT NULL,
    pub_list  text, 
    contact_list text, 
    contact_role_list text, 
    created_by_user integer NOT NULL,
    created_on time without time zone NOT NULL,
    updated_by_user integer,
    updated_on time without time zone,
    PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Investigation"
    OWNER to postgres;-- Table: public.MassSpecType

-- DROP TABLE IF EXISTS public."MassSpecType";

CREATE TABLE IF NOT EXISTS public."MassSpecType"
(
    id bigserial NOT NULL,
    name text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "MassSpecType_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."MassSpecType"
    OWNER to postgres;

COMMENT ON TABLE public."MassSpecType"
    IS 'TYpes of Mass Spectrometry';-- Table: public.MS1Mst

-- DROP TABLE IF EXISTS public."MS1Mst";

CREATE TABLE IF NOT EXISTS public."MS1Mst"
(
    id bigserial NOT NULL ,
    file_name text COLLATE pg_catalog."default" NOT NULL,
    import_date timestamp without time zone NOT NULL,
    user_id integer,
    CONSTRAINT "MS1Mast_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."MS1Mst"
    OWNER to postgres;-- Table: public.MS1Dets

-- DROP TABLE IF EXISTS public."MS1Dets";

CREATE TABLE IF NOT EXISTS public."MS1Dets"
(
    id bigserial NOT NULL ,
    compound_id bigint NOT NULL,
    ion text COLLATE pg_catalog."default" NOT NULL,
    peak_note text COLLATE pg_catalog."default",
    large_peak text COLLATE pg_catalog."default",
    mass_diff_ppm text COLLATE pg_catalog."default",
    spectra_confirmation text COLLATE pg_catalog."default",
    remarks text COLLATE pg_catalog."default",
    ms1_mst_id bigint NOT NULL,
    library_rt_rf1 numeric(20,16),
    library_rt_hillic1 numeric(20,16),
    library_mz numeric(22,16),
    measured_mz numeric(22,16),
    mass_diff numeric(22,16),
    ms2_available character(1) COLLATE pg_catalog."default",
    library_name text COLLATE pg_catalog."default",
    project_name character varying(200) COLLATE pg_catalog."default",
    data_file_name character varying(200) COLLATE pg_catalog."default",
    library_rt_rf_updated numeric(20,16),
    CONSTRAINT "MS1Dets_pkey" PRIMARY KEY (id),
    CONSTRAINT compound_id FOREIGN KEY (compound_id)
        REFERENCES public."Compound" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."MS1Dets"
    OWNER to postgres;-- Table: public.MS2Mst

-- Table: public.MS1Dets

-- DROP TABLE IF EXISTS public."MS1DetsImportLog";

CREATE TABLE IF NOT EXISTS public."MS1DetsImportLog"
(
    id bigserial NOT NULL ,
    compound_id bigint NOT NULL,
    ion text COLLATE pg_catalog."default" NOT NULL,
    peak_note text COLLATE pg_catalog."default",
    large_peak text COLLATE pg_catalog."default",
    mass_diff_ppm text COLLATE pg_catalog."default",
    spectra_confirmation text COLLATE pg_catalog."default",
    remarks text COLLATE pg_catalog."default",
    ms1_mst_id bigint NOT NULL,
    library_rt_rf1 numeric(20,16),
    library_rt_hillic1 numeric(20,16),
    library_mz numeric(22,16),
    measured_mz numeric(22,16),
    mass_diff numeric(22,16),
    ms2_available character(1) COLLATE pg_catalog."default",
    library_name text COLLATE pg_catalog."default",
    project_name character varying(200) COLLATE pg_catalog."default",
    data_file_name character varying(200) COLLATE pg_catalog."default",
    library_rt_rf_updated numeric(20,16),
    CONSTRAINT "MS1DetsImportLog_pkey" PRIMARY KEY (id),
    CONSTRAINT compound_id FOREIGN KEY (compound_id)
        REFERENCES public."Compound" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."MS1DetsImportLog"
    OWNER to postgres;
	

-- Table: public.MS2Mst

-- DROP TABLE IF EXISTS public."MS2Mst";

CREATE TABLE IF NOT EXISTS public."MS2Mst"
(
    id bigserial NOT NULL ,
    data_source_id smallint NOT NULL,
    predicted_experimental "char" NOT NULL,
    mass_spec_type_id smallint NOT NULL,
    spectrum_id integer NOT NULL,
    file_format text COLLATE pg_catalog."default" NOT NULL,
    file_name character varying COLLATE pg_catalog."default",
    import_date timestamp without time zone,
    num_spectra_in_file integer  NOT NULL,
    CONSTRAINT "MS2Mst_pkey" PRIMARY KEY (id),
    CONSTRAINT "MS2Mst_data_source_id_fkey" FOREIGN KEY (data_source_id)
        REFERENCES public."DataSource" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "MS2Mst_mass_spec_type_id_fkey" FOREIGN KEY (mass_spec_type_id)
        REFERENCES public."MassSpecType" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."MS2Mst"
    OWNER to postgres;

COMMENT ON TABLE public."MS2Mst"
    IS 'Master for Ms2 data of mass spec experiments';    
-- Table: public.MS2Dets

-- DROP TABLE IF EXISTS public."MS2Dets";

CREATE TABLE IF NOT EXISTS public."MS2Dets"
(
    id bigserial NOT NULL ,
    ms2mst_id bigint NOT NULL,
    spec_scan_num integer NOT NULL,
    ms_level smallint NOT NULL,
    retention_time_secs numeric(12,6) NOT NULL,
    centroided boolean,
    polarity bit(1),
    prec_scan_num integer,
    precursor_mass numeric(14,7) NOT NULL,
    precursor_intensity integer NOT NULL,
    precursor_charge text COLLATE pg_catalog."default",
    collision_energy integer NOT NULL,
    from_file text COLLATE pg_catalog."default",
    original_peaks_count integer,
    total_ion_current integer,
    base_peak_mz numeric(14,7),
    base_peak_intensity integer,
    ionisation_energy integer,
    low_mz numeric(14,7),
    high_mz numeric(14,7),
    injection_time_secs integer,
    peak_index bigint,
    peak_id character varying(10) COLLATE pg_catalog."default",
    scan_index integer,
    spectrum_id character varying(20) COLLATE pg_catalog."default",
    compound_id bigint NOT NULL,
    CONSTRAINT "MS2Dets_pkey" PRIMARY KEY (id),
    CONSTRAINT "MS2Dets_spec_scan_id_fkey" FOREIGN KEY (ms2mst_id)
        REFERENCES public."MS2Mst" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT compoundid FOREIGN KEY (compound_id)
        REFERENCES public."Compound" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."MS2Dets"
    OWNER to postgres;

COMMENT ON TABLE public."MS2Dets"
    IS 'Details of Scan';
-- Index: ms2mst_id1

-- DROP INDEX IF EXISTS public.ms2mst_id1;

CREATE INDEX IF NOT EXISTS ms2mst_id1
    ON public."MS2Dets" USING btree
    (ms2mst_id ASC NULLS LAST)
    TABLESPACE pg_default;
    
-- DROP TABLE IF EXISTS public."MS2Peak";


CREATE TABLE IF NOT EXISTS public."MS2DetsImportLog"
(
    id bigserial NOT NULL ,
    ms2mst_id bigint NOT NULL,
    spec_scan_num integer NOT NULL,
    ms_level smallint NOT NULL,
    retention_time_secs numeric(12,6) NOT NULL,
    centroided boolean,
    polarity bit(1),
    prec_scan_num integer,
    precursor_mass numeric(14,7) NOT NULL,
    precursor_intensity integer NOT NULL,
    precursor_charge text COLLATE pg_catalog."default",
    collision_energy integer NOT NULL,
    from_file text COLLATE pg_catalog."default",
    original_peaks_count integer,
    total_ion_current integer,
    base_peak_mz numeric(14,7),
    base_peak_intensity integer,
    ionisation_energy integer,
    low_mz numeric(14,7),
    high_mz numeric(14,7),
    injection_time_secs integer,
    peak_index bigint,
    peak_id character varying(10) COLLATE pg_catalog."default",
    scan_index integer,
    spectrum_id character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT "MS2DetsImportLog_pkey" PRIMARY KEY (id),
    CONSTRAINT "MS2DetsImportLog_spec_scan_id_fkey" FOREIGN KEY (ms2mst_id)
        REFERENCES public."MS2Mst" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."MS2DetsImportLog"
    OWNER to postgres;

COMMENT ON TABLE public."MS2DetsImportLog"
    IS 'Details of Scan';
-- Index: ms2mst_id1

-- DROP INDEX IF EXISTS public.ms2mst_id1;

CREATE INDEX IF NOT EXISTS ms2mst_id2
    ON public."MS2DetsImportLog" USING btree
    (ms2mst_id ASC NULLS LAST)
    TABLESPACE pg_default;

-- DROP TABLE IF EXISTS public."MS2Mst";



CREATE TABLE IF NOT EXISTS public."MS2Peak"
(
    id bigserial NOT NULL, 
    ms2_det_id bigint NOT NULL,
    mz numeric(14,7) NOT NULL,
    intensity integer NOT NULL,
    CONSTRAINT "Peak_pkey1" PRIMARY KEY (id),
    CONSTRAINT "Peak_ms2dets_id_fkey" FOREIGN KEY (ms2_det_id)
        REFERENCES public."MS2Dets" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."MS2Peak"
    OWNER to postgres;

COMMENT ON TABLE public."MS2Peak"
    IS 'MS2 peak data';
-- Index: ms2dets_id

-- DROP INDEX IF EXISTS public.ms2dets_id;

CREATE INDEX IF NOT EXISTS ms2dets_id
    ON public."MS2Peak" USING btree
    (ms2_det_id ASC NULLS LAST)
    TABLESPACE pg_default;
    

-- Table: public.MS2Peak

-- DROP TABLE IF EXISTS public."MS2PeakImportLog";

CREATE TABLE IF NOT EXISTS public."MS2PeakImportLog"
(
    id bigserial NOT NULL ,
    ms2_det_id bigint NOT NULL,
    mz numeric(14,7) NOT NULL,
    intensity integer NOT NULL,
    CONSTRAINT "Peak_pkey2" PRIMARY KEY (id),
    CONSTRAINT "Peak_ms2detsimportlog_id_fkey" FOREIGN KEY (ms2_det_id)
        REFERENCES public."MS2DetsImportLog" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."MS2PeakImportLog"
    OWNER to postgres;

COMMENT ON TABLE public."MS2PeakImportLog"
    IS 'MS2 peak data';
-- Index: ms2dets_id

-- DROP INDEX IF EXISTS public.ms2dets_id;

CREATE INDEX IF NOT EXISTS ms2dets_id1
    ON public."MS2PeakImportLog" USING btree
    (ms2_det_id ASC NULLS LAST)
    TABLESPACE pg_default;


CREATE TABLE IF NOT EXISTS public."OntologyAnnotation"
(
    id bigserial NOT NULL,
    type text NOT NULL,
    description text NOT NULL,
    source_accession_number bigint NOT NULL,
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."OntologyAnnotation"
    OWNER to postgres;
    CREATE TABLE IF NOT EXISTS public."OntologyList"
(
    code  varchar(30),
    name   text,
    created_by_user integer NULL,
    created_on timestamp without time zone NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    PRIMARY KEY (code)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."OntologyList"
    OWNER to postgres;
    
INSERT INTo public."OntologyList" (
    code, name 
) VALUES (
    'DESIGN_TYPE', 'Design Type'
) ;

INSERT INTo public."OntologyList" (
    code, name 
) VALUES (
    'DESIGN_FACTOR_TYPE', 'Design Factor Type'
) ;

INSERT INTo public."OntologyList" (
    code, name 
) VALUES (
    'CONTACT_ROLE', 'Contact Role'
) ;

INSERT INTo public."OntologyList" (
    code, name 
) VALUES (
    'PUB_STATUS', 'Publication Status'
) ;

INSERT INTo public."OntologyList" (
    code, name 
) VALUES (
    'TECH_TYPE', 'Technology Type'
) ;

CREATE TABLE IF NOT EXISTS public."OntologySource"
(
    id integer NOT NULL,
    name text NOT NULL,
    file text NOT NULL,
    accession_number text NOT NULL,
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."OntologySource"
    OWNER to postgres;
    CREATE TABLE IF NOT EXISTS public."Organization"
(
    id integer NOT NULL,
    name text NOT NULL,
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Organization"
    OWNER to postgres;

CREATE TABLE IF NOT EXISTS public."Publication"
(
    pub_med_id bigint NOT NULL,
    doi_id bigint,
    title text NOT NULL,
    description text NOT NULL,
    author_list text, 
    status_annotation_id integer NOT NULL,
    type character NOT NULL,
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    PRIMARY KEY (pub_med_id)
)


TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Publication"
    OWNER to postgres;CREATE TABLE IF NOT EXISTS public."Study"
(
    id bigserial NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    submission_date timestamp without time zone,
    public_release_date timestamp without time zone,
    design_type_annotation_id integer NOT NULL,
    pub_list text,
    contact_list text, 
    contact_role_list text, 
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    investigation_id bigint NOT NULL,
    PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Study"
    OWNER to postgres;CREATE TABLE IF NOT EXISTS public."TechnologyPlatform"
(
    id integer NOT NULL,
    description text NOT NULL,
    created_by_user integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_by_user integer,
    updated_on timestamp without time zone,
    PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."TechnologyPlatform"
    OWNER to postgres;

-- Table: public.UnknownMS2Mst

-- DROP TABLE IF EXISTS public."UnknownMS2Mst";

CREATE TABLE IF NOT EXISTS public."UnknownMS2Mst"
(
    id bigserial NOT NULL ,
    data_source_id smallint NOT NULL,
    predicted_experimental "char" NOT NULL,
    mass_spec_type_id smallint NOT NULL,
    spectrum_id integer NOT NULL,
    file_format text COLLATE pg_catalog."default" NOT NULL,
    file_name character varying COLLATE pg_catalog."default",
    import_date timestamp without time zone,
    peak_prefilter_hist_url text COLLATE pg_catalog."default",
    peak_postfilter_hist_url text COLLATE pg_catalog."default",
    num_spectra_in_file integer  NOT NULL,
    CONSTRAINT "UnknownMS2Mst_pkey" PRIMARY KEY (id),
    CONSTRAINT "UnknownMS2Mst_data_source_id_fkey" FOREIGN KEY (data_source_id)
        REFERENCES public."DataSource" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "UnknownMS2Mst_mass_spec_type_id_fkey" FOREIGN KEY (mass_spec_type_id)
        REFERENCES public."MassSpecType" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."UnknownMS2Mst"
    OWNER to postgres;

COMMENT ON TABLE public."UnknownMS2Mst"
    IS 'Master for Ms2 data of unknown compounds';

-- Table: public.UnknownMS2Dets

-- DROP TABLE IF EXISTS public."UnknownMS2Dets";

CREATE TABLE IF NOT EXISTS public."UnknownMS2Dets"
(
    id bigserial NOT NULL ,
    ms2mst_id bigint NOT NULL,
    spec_scan_num integer NOT NULL,
    ms_level smallint NOT NULL,
    retention_time_secs numeric(12,6) NOT NULL,
    centroided boolean,
    polarity bit(1),
    prec_scan_num integer,
    precursor_mass numeric(14,7) NOT NULL,
    precursor_intensity integer NOT NULL,
    precursor_charge text COLLATE pg_catalog."default",
    collision_energy integer NOT NULL,
    from_file text COLLATE pg_catalog."default",
    original_peaks_count integer,
    total_ion_current integer,
    base_peak_mz numeric(14,7),
    base_peak_intensity integer,
    ionisation_energy integer,
    low_mz numeric(14,7),
    high_mz numeric(14,7),
    injection_time_secs integer,
    peak_index bigint,
    peak_id character varying(10) COLLATE pg_catalog."default",
    scan_index integer,
    spectrum_id character varying(20) COLLATE pg_catalog."default",
    mz_peak_hist_url text COLLATE pg_catalog."default",
    mz_intensity_plot_url text COLLATE pg_catalog."default",
    compound_id bigint,
    CONSTRAINT "UnknownMS2Dets_pkey" PRIMARY KEY (id),
    CONSTRAINT "UMS2Dets_spec_scan_id_fkey" FOREIGN KEY (ms2mst_id)
        REFERENCES public."UnknownMS2Mst" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."UnknownMS2Dets"
    OWNER to postgres;

-- Table: public.UnknownMS2Peak

-- DROP TABLE IF EXISTS public."UnknownMS2Peak";

CREATE TABLE IF NOT EXISTS public."UnknownMS2Peak"
(
    id bigserial NOT NULL ,
    ms2_det_id bigint NOT NULL,
    mz numeric(14,7) NOT NULL,
    intensity integer NOT NULL,
    CONSTRAINT "UPeak_pkey1" PRIMARY KEY (id),
    CONSTRAINT "UPeak_ms2dets_id_fkey" FOREIGN KEY (ms2_det_id)
        REFERENCES public."UnknownMS2Dets" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."UnknownMS2Peak"
    OWNER to postgres;

COMMENT ON TABLE public."UnknownMS2Peak"
    IS 'MS2 peak data';-- Table: public.UnknownDetectionResults

-- DROP TABLE IF EXISTS public."UnknownDetectionResults";

CREATE TABLE IF NOT EXISTS public."UnknownDetectionResults"
(
    id bigserial NOT NULL ,
    ms2det_id bigint NOT NULL,
    ref_compound_id bigint NOT NULL,
    ref_retention_time numeric(16,12) NOT NULL,
    ref_collision_energy integer NOT NULL,
    matching_peaks smallint NOT NULL,
    score numeric(11,10) NOT NULL,
    ref_precursor_mass numeric(12,7) NOT NULL,
    qry_compound_id bigint,
    qry_retention_time numeric(16,12) NOT NULL,
    qry_collision_energy smallint NOT NULL,
    qry_precursor_mass numeric(12,7) NOT NULL,
    match_method character varying(50) COLLATE pg_catalog."default" NOT NULL,
    ref_scan_number integer,
    qry_scan_number integer,
    instrument_used character varying(300) COLLATE pg_catalog."default",
    ref_qry_mz_plot_url text COLLATE pg_catalog."default",
    ref_structure_url text COLLATE pg_catalog."default",
    over_threshold boolean,
    CONSTRAINT "UnknownDetectionResults_pkey" PRIMARY KEY (id),
    CONSTRAINT ms2det_id FOREIGN KEY (ms2det_id)
        REFERENCES public."UnknownMS2Dets" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."UnknownDetectionResults"
    OWNER to postgres;
    
CREATE TABLE IF NOT EXISTS public."UnknownComparisonMisc"
(
    id bigserial NOT NULL ,
    ms2mst_id bigint NOT NULL,
    matching_peak_threshold integer NOT NULL,
    matching_score_threshold double precision NOT NULL,
    pep_mass_tolerance_from integer NOT NULL,
    pep_mass_tolerance_to integer NOT NULL,
    num_rows_processed integer NOT NULL,
    num_unique_compounds integer NOT NULL,
    num_rows_over_threshold integer NOT NULL,
    CONSTRAINT "UnknownComparisonMisc_pkey" PRIMARY KEY (id, ms2mst_id),
    CONSTRAINT ms2mstid FOREIGN KEY (ms2mst_id)
        REFERENCES public."UnknownMS2Mst" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID    
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."UnknownComparisonMisc"
    OWNER to postgres;    
BEGIN;


ALTER TABLE IF EXISTS public."Assay"
    ADD FOREIGN KEY (study_id)
    REFERENCES public."Study" (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

ALTER TABLE IF EXISTS public."Assay"
    ADD FOREIGN KEY (technology_platform_id)
    REFERENCES public."TechnologyPlatform" (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public."Assay"
    ADD FOREIGN KEY (measurement_type_annotation_id)
    REFERENCES public."OntologyAnnotation" (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public."Assay"
    ADD FOREIGN KEY (technology_type_annotation_id)
    REFERENCES public."OntologyAnnotation" (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;ALTER TABLE IF EXISTS public."Contact"
    ADD FOREIGN KEY (organization_id)
    REFERENCES public."Organization" (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;
    BEGIN;
ALTER TABLE IF EXISTS public."ContactRole"
    ADD FOREIGN KEY (contact_id)
    REFERENCES public."Contact" (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public."ContactRole"
    ADD FOREIGN KEY (role_annotation_id)
    REFERENCES public."OntologyAnnotation" (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;
END;
ALTER TABLE IF EXISTS public."OntologyAnnotation"
    ADD FOREIGN KEY (source_accession_number)
    REFERENCES public."OntologySource" (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;ALTER TABLE IF EXISTS public."Study"
    ADD FOREIGN KEY (investigation_id)
    REFERENCES public."Investigation" (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

CREATE TABLE IF NOT EXISTS public."User"
(
    id bigserial NOT NULL,
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    email_id character varying(100) COLLATE pg_catalog."default" NOT NULL,
    pwd text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "User_pkey" PRIMARY KEY (id),
    CONSTRAINT unique_email UNIQUE (email_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."User"
    OWNER to postgres;

-- FUNCTION: public.GetLast3MS1Files()

-- DROP FUNCTION IF EXISTS public."GetLast3MS1Files"();

CREATE OR REPLACE FUNCTION public."GetLast3MS1Files"(
	)
    RETURNS TABLE(tag character varying, tag_data character varying, srno smallint) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

select 'LAST_THREE_MS1_LIST' as tag, string_agg(concat(cast(id as varchar),  ':', file_name), ',') as tag_data,  1
from (select file_name, id from "MS1Mst" ms1 
order by import_date desc
LIMIT 3 ) last_three_ms1
union all 
select 'LAST_THREE_MS1_LIST', '', 2 
order by 3
limit 1
$BODY$;

ALTER FUNCTION public."GetLast3MS1Files"()
    OWNER TO postgres;

-- FUNCTION: public.GetLast3MS2Files()

-- DROP FUNCTION IF EXISTS public."GetLast3MS2Files"();

CREATE OR REPLACE FUNCTION public."GetLast3MS2Files"(
	)
    RETURNS TABLE(tag character varying, tag_data character varying, srno smallint) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

select 'LAST_THREE_MS2_LIST' as tag, string_agg(concat(cast(id as varchar),  ':', file_name), ',') as tag_data,  1
from (select file_name, id from "MS2Mst" ms1 
order by import_date desc
LIMIT 3 ) last_three_ms2
union all 
select 'LAST_THREE_MS1_LIST', '', 2 
order by 3
limit 1
$BODY$;

ALTER FUNCTION public."GetLast3MS2Files"()
    OWNER TO postgres;

-- FUNCTION: public.GetLatestCompoundDetectionResults()

-- DROP FUNCTION IF EXISTS public."GetLatestCompoundDetectionResults"();

CREATE OR REPLACE FUNCTION public."GetLatestCompoundDetectionResults"(
	)
    RETURNS TABLE(tag character varying, tag_data character varying, id bigint, srno smallint) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
select 'GRAPH_MZ_INTENSITY_COMPARISON' tag , ref_qry_mz_plot_url,  ms2det_id id , 1 as srno
from 
(select ref_qry_mz_plot_url,  ms2det_id from "UnknownDetectionResults" udr 
	join "UnknownMS2Dets" udt on udr.ms2det_id = udt.id
	join "UnknownMS2Mst" um on udt.ms2mst_id = um.id 
order  by um.import_date desc 
LIMIT 1) matching_mass
UNION ALL
SELECT 'GRAPH_MZ_INTENSITY', mz_intensity_plot_url, id, 2  
from (
select mz_intensity_plot_url, umdt.id 
	from "UnknownMS2Dets" umdt 
		left join "UnknownDetectionResults" udr 
			on umdt.id = udr.ms2det_id 
		join "UnknownMS2Mst" um 
			on umdt.ms2mst_id = um.id 
	order by um.import_date desc
	limit 1
)  no_matching_mass
UNION ALL
select 'GRAPH', '', 0,  3  -- if not data is found for compound detection, the api requires a blank node
order by 4
limit 1
$BODY$;

ALTER FUNCTION public."GetLatestCompoundDetectionResults"()
    OWNER TO postgres;

-- FUNCTION: public.GetDashboardDisplayData()

-- DROP FUNCTION IF EXISTS public."GetDashboardDisplayData"();

CREATE OR REPLACE FUNCTION public."GetDashboardDisplayData"(
	)
    RETURNS TABLE(category character varying, tag character varying, tag_data character varying, srno smallint) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
select 'STATS' as category, 'TOTAL_COMPOUNDS' as tag, cast( count(*)  as VARCHAR) as tag_data, 1 as srno
from "Compound"  
UNION ALL
select 'STATS', 'TOTAL_MS1', cast( count(*)  as VARCHAR),  2  from "MS1Mst" ms1 
UNION ALL
select 'STATS', 'TOTAL_MS2', cast( count(*)  as VARCHAR),  3  from "MS2Mst" ms2 
UNION ALL
select 'MISSING_DATA', 'MISSING_INCHIKEY' as tag, cast( count(*)  as VARCHAR)  as tag_data, 4
from "Compound"  
where inchi_key is null or inchi_key = 'nan' or inchi_key = ''
UNION ALL
select 'MISSING_DATA', 'MISSING_SMILES' as tag, cast( count(*)  as VARCHAR) as tag_data , 5
from "Compound"  
where smiles is null or smiles = 'nan' or smiles = ''
UNION ALL 
select 'MISSING_DATA', 'MISSING_MS2', cast( count(*)  as VARCHAR), 6
from "MS1Dets" ms1 
where ms2_available = 'N'
UNION ALL
select 'MISSING_DATA', 'MISSING_CHEBIKEY', cast( count(*)  as VARCHAR), 7
from "Compound" 
where chebi = ''
UNION ALL
select 'MISSING_DATA', 'MISSING_URL', cast( count(*)  as VARCHAR), 8
from "Compound" 
where pubchem_url = ''
UNION ALL
select 'HISTORY', tag, tag_data, 9
from "GetLast3MS1Files"()

UNION ALL 
SELECT 'HISTORY', tag, tag_data, 10 from 
"GetLast3MS2Files"()
UNION ALL
select 'GRAPH', tag, concat(cast(id as character varying), ':', tag_data), 11
	from "GetLatestCompoundDetectionResults"() 
order by 4 
$BODY$;

ALTER FUNCTION public."GetDashboardDisplayData"()
    OWNER TO postgres;
-- PROCEDURE: public.SaveCompound(bigint, text, text, text, numeric, character, character, character, character, character, character, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, character, text)

-- DROP PROCEDURE IF EXISTS public."SaveCompound"(bigint, text, text, text, numeric, character, character, character, character, character, character, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, character, text);

CREATE OR REPLACE PROCEDURE public."SaveCompound"(
	INOUT pcompound_id bigint,
	IN pcompound_name text,
	IN ppolarity text,
	IN pmolecular_formula text,
	IN pmono_isotopic_mass numeric,
	IN phas_adduct_h character,
	IN phas_adduct_na character,
	IN phas_adduct_k character,
	IN phas_adduct_fa character,
	IN phas_fragment_loss_h2o character,
	IN phas_fragment_loss_hcooh character,
	IN ppubchem_id text,
	IN ppubchem_url text,
	IN ppubchem_sid text,
	IN pcas_id text,
	IN pkegg_id_csid text,
	IN phmdb_ymdb_id text,
	IN pmetlin_id text,
	IN pchebi text,
	IN psmiles text,
	IN pinchi_key text,
	IN pclass_chemical_taxonomy text,
	IN psubclass_chemical_taxonomy text,
	IN psupplier_cat_no text,
	IN psupplier_product_name text,
	IN pbiospecimen_locations text,
	IN ptissue_locations text,
	IN pextra_pc_cid text,
	IN phas_fragment_loss_fa character,
	IN pcanonical_smiles text)
LANGUAGE 'plpgsql'
AS $BODY$

BEGIN
IF pcompound_id = 0 then 
	INSERT INTO public."Compound"(
		name, mass_spec_polarity, molecular_formula, mono_molecule_mass,  
				has_adduct_h, has_adduct_na, has_adduct_k, has_adduct_fa, 
				has_fragment_loss_h2o, has_fragment_loss_hcooh, 
				pubchem_id, pubchem_url, pubchem_sid, cas_id, kegg_id_csid, 
				hmdb_ymdb_id, metlin_id, chebi, smiles, inchi_key, 
				class_chemical_taxonomy, subclass_chemical_taxonomy, 
				supplier_cat_no, supplier_product_name, biospecimen_locations, tissue_locations, 
				extra_pc_cid, has_fragment_loss_fa, canonical_smiles)
	VALUES (pcompound_name, ppolarity, pmolecular_formula, pmono_isotopic_mass, 				
				phas_adduct_h, phas_adduct_na, phas_adduct_k, phas_adduct_fa, 
				phas_fragment_loss_h2o, phas_fragment_loss_hcooh, 
				ppubchem_id, ppubchem_url, ppubchem_sid, pcas_id, pkegg_id_csid, 
				phmdb_ymdb_id, pmetlin_id, pchebi, psmiles, pinchi_key, 
				pclass_chemical_taxonomy, psubclass_chemical_taxonomy, 
				psupplier_cat_no, psupplier_product_name, pbiospecimen_locations, ptissue_locations, 
		   		pextra_pc_cid, phas_fragment_loss_fa, pcanonical_smiles)
		    returning id into pcompound_id ;
else
    update "Compound" set name= pcompound_name,
		mass_spec_polarity = ppolarity, 
		molecular_formula = pmolecular_formula,  
		mono_molecule_mass = pmono_isotopic_mass,
		has_adduct_h = phas_adduct_h, 
		has_adduct_na = phas_adduct_na, 
		has_adduct_k = phas_adduct_k, 
		has_adduct_fa = phas_adduct_fa, 
		has_fragment_loss_h2o = phas_fragment_loss_h2o, 
		has_fragment_loss_hcooh = phas_fragment_loss_hcooh, 
		pubchem_id = ppubchem_id, 
		pubchem_url = ppubchem_url, 
		pubchem_sid = ppubchem_sid, 
		cas_id = pcas_id, 
		kegg_id_csid = pkegg_id_csid, 
		hmdb_ymdb_id = phmdb_ymdb_id,
		metlin_id = pmetlin_id, 
		chebi = pchebi, 
		smiles = psmiles,
		inchi_key = pinchi_key, 
		class_chemical_taxonomy = pclass_chemical_taxonomy, 
		subclass_chemical_taxonomy = psubclass_chemical_taxonomy, 
		supplier_cat_no = psupplier_cat_no, 
		supplier_product_name = psupplier_product_name, 
		biospecimen_locations = pbiospecimen_locations, 
		tissue_locations = ptissue_locations, 
		extra_pc_cid = pextra_pc_cid, 
		has_fragment_loss_fa = phas_fragment_loss_fa, 
		canonical_smiles = pcanonical_smiles
	where id = pcompound_id ;
end if;
END ;
$BODY$;
ALTER PROCEDURE public."SaveCompound"(bigint, text, text, text, numeric, character, character, character, character, character, character, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, character, text)
    OWNER TO postgres;
-- PROCEDURE: public.SaveCompound(integer, text, text, text, numeric, character, character, character, character, character, character, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, character, text)

-- DROP PROCEDURE IF EXISTS public."SaveCompound"(integer, text, text, text, numeric, character, character, character, character, character, character, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, character, text);

CREATE OR REPLACE PROCEDURE public."SaveCompound"(
	INOUT pcompound_id integer,
	IN pcompound_name text,
	IN ppolarity text,
	IN pmolecular_formula text,
	IN pmono_isotopic_mass numeric,
	IN phas_adduct_h character,
	IN phas_adduct_na character,
	IN phas_adduct_k character,
	IN phas_adduct_fa character,
	IN phas_fragment_loss_h2o character,
	IN phas_fragment_loss_hcooh character,
	IN ppubchem_id text,
	IN ppubchem_url text,
	IN ppubchem_sid text,
	IN pcas_id text,
	IN pkegg_id_csid text,
	IN phmdb_ymdb_id text,
	IN pmetlin_id text,
	IN pchebi text,
	IN psmiles text,
	IN pinchi_key text,
	IN pclass_chemical_taxonomy text,
	IN psubclass_chemical_taxonomy text,
	IN psupplier_cat_no text,
	IN psupplier_product_name text,
	IN pbiospecimen_locations text,
	IN ptissue_locations text,
	IN pextra_pc_cid text,
	IN phas_fragment_loss_fa character,
	IN pcanonical_smiles text)
LANGUAGE 'plpgsql'
AS $BODY$

BEGIN
IF pcompound_id = 0 then 
	INSERT INTO public."Compound"(
		name, mass_spec_polarity, molecular_formula, mono_molecule_mass,  
				has_adduct_h, has_adduct_na, has_adduct_k, has_adduct_fa, 
				has_fragment_loss_h2o, has_fragment_loss_hcooh, 
				pubchem_id, pubchem_url, pubchem_sid, cas_id, kegg_id_csid, 
				hmdb_ymdb_id, metlin_id, chebi, smiles, inchi_key, 
				class_chemical_taxonomy, subclass_chemical_taxonomy, 
				supplier_cat_no, supplier_product_name, biospecimen_locations, tissue_locations, 
				extra_pc_cid, has_fragment_loss_fa, canonical_smiles)
	VALUES (pcompound_name, ppolarity, pmolecular_formula, pmono_isotopic_mass, 				
				phas_adduct_h, phas_adduct_na, phas_adduct_k, phas_adduct_fa, 
				phas_fragment_loss_h2o, phas_fragment_loss_hcooh, 
				ppubchem_id, ppubchem_url, ppubchem_sid, pcas_id, pkegg_id_csid, 
				phmdb_ymdb_id, pmetlin_id, pchebi, psmiles, pinchi_key, 
				pclass_chemical_taxonomy, psubclass_chemical_taxonomy, 
				psupplier_cat_no, psupplier_product_name, pbiospecimen_locations, ptissue_locations, 
		   		pextra_pc_cid, phas_fragment_loss_fa, pcanonical_smiles)
		    returning id into pcompound_id ;
else
    update "Compound" set name= pcompound_name,
		mass_spec_polarity = ppolarity, 
		molecular_formula = pmolecular_formula,  
		mono_molecule_mass = pmono_isotopic_mass,
		has_adduct_h = phas_adduct_h, 
		has_adduct_na = phas_adduct_na, 
		has_adduct_k = phas_adduct_k, 
		has_adduct_fa = phas_adduct_fa, 
		has_fragment_loss_h2o = phas_fragment_loss_h2o, 
		has_fragment_loss_hcooh = phas_fragment_loss_hcooh, 
		pubchem_id = ppubchem_id, 
		pubchem_url = ppubchem_url, 
		pubchem_sid = ppubchem_sid, 
		cas_id = pcas_id, 
		kegg_id_csid = pkegg_id_csid, 
		hmdb_ymdb_id = phmdb_ymdb_id,
		metlin_id = pmetlin_id, 
		chebi = pchebi, 
		smiles = psmiles,
		inchi_key = pinchi_key, 
		class_chemical_taxonomy = pclass_chemical_taxonomy, 
		subclass_chemical_taxonomy = psubclass_chemical_taxonomy, 
		supplier_cat_no = psupplier_cat_no, 
		supplier_product_name = psupplier_product_name, 
		biospecimen_locations = pbiospecimen_locations, 
		tissue_locations = ptissue_locations, 
		extra_pc_cid = pextra_pc_cid, 
		has_fragment_loss_fa = phas_fragment_loss_fa, 
		canonical_smiles = pcanonical_smiles
	where id = pcompound_id ;
end if;
END ;
$BODY$;
ALTER PROCEDURE public."SaveCompound"(integer, text, text, text, numeric, character, character, character, character, character, character, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, text, character, text)
    OWNER TO postgres;

insert into "Configs" (name, type, config, active, created_by) values('default', 'DEFAULT', '{"matching_peaks":"1", "matching_score":"0.75", "pep_mass_tolerance":[-1,1]}', true,1) ;

insert into "DataSource" (name) values('NA');
insert into "MassSpecType" (name) values('MS/MS') ;
insert into "User" (name, email_id, pwd) values ('Lawrence Egyir', 'lawegyir@yahoo.com', 'biodevs')



