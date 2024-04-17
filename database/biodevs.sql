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


-- Table: public.Method
CREATE TABLE IF NOT EXISTS public."Method"
(
    id smallserial NOT NULL ,
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    method character varying(10) COLLATE pg_catalog."default" NOT NULL,
    lc_time numeric(6,2)  NULL,
    lc_temp numeric(6,2) NULL,
    name_sop character varying(100) COLLATE pg_catalog."default"  NULL,
    instrument_name character varying(100) COLLATE pg_catalog."default"  NULL,
    active boolean DEFAULT true,
    solvents json,
    CONSTRAINT "Methods_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Method"
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

COMMENT ON TABLE public."DataSource"
    IS 'Source of Mass Spec Data';
    
-- Table: public.MassSpecType

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
    method_id smallint,
    CONSTRAINT "MS1Mast_pkey" PRIMARY KEY (id),
    CONSTRAINT method_id FOREIGN KEY (method_id)
        REFERENCES public."Method" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID

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
    method_id smallint,
    CONSTRAINT "MS2Mst_pkey" PRIMARY KEY (id),
    CONSTRAINT "MS2Mst_data_source_id_fkey" FOREIGN KEY (data_source_id)
        REFERENCES public."DataSource" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "MS2Mst_mass_spec_type_id_fkey" FOREIGN KEY (mass_spec_type_id)
        REFERENCES public."MassSpecType" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT method_id FOREIGN KEY (method_id)
        REFERENCES public."Method" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID

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
    method_id smallint,
    CONSTRAINT "UnknownMS2Mst_pkey" PRIMARY KEY (id),
    CONSTRAINT "UnknownMS2Mst_data_source_id_fkey" FOREIGN KEY (data_source_id)
        REFERENCES public."DataSource" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "UnknownMS2Mst_mass_spec_type_id_fkey" FOREIGN KEY (mass_spec_type_id)
        REFERENCES public."MassSpecType" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT method_id FOREIGN KEY (method_id)
        REFERENCES public."Method" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID

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

-- TOC entry 304 (class 1259 OID 35319)
-- Name: PeakTableMerge; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PeakTableMerge" (
    id bigint NOT NULL,
    compound_id bigint,
    intensity bigint NOT NULL,
    compound_name character varying NOT NULL,
    data_file_id character varying NOT NULL,
    assay_id bigint NOT NULL,
    date_time timestamp without time zone,
    a_sample_id bigint NOT NULL,
    sample_id bigint
);


ALTER TABLE public."PeakTableMerge" OWNER TO postgres;

--
-- TOC entry 305 (class 1259 OID 35976)
-- Name: PeakTableMerge_a_sample_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PeakTableMerge_a_sample_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PeakTableMerge_a_sample_id_seq" OWNER TO postgres;

--
-- TOC entry 3924 (class 0 OID 0)
-- Dependencies: 305
-- Name: PeakTableMerge_a_sample_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."PeakTableMerge_a_sample_id_seq" OWNED BY public."PeakTableMerge".a_sample_id;


--
-- TOC entry 303 (class 1259 OID 35318)
-- Name: PeakTableMerge_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PeakTableMerge_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PeakTableMerge_id_seq" OWNER TO postgres;

--
-- TOC entry 3925 (class 0 OID 0)
-- Dependencies: 303
-- Name: PeakTableMerge_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."PeakTableMerge_id_seq" OWNED BY public."PeakTableMerge".id;




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


CREATE TABLE public.assay (
    assay_id integer NOT NULL,
    filename character varying,
    technology_platform character varying,
    measurement_type_id character varying,
    technology_type_id character varying
);


ALTER TABLE public.assay OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 33613)
-- Name: assay_assay_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assay_assay_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assay_assay_id_seq OWNER TO postgres;

--
-- TOC entry 3934 (class 0 OID 0)
-- Dependencies: 237
-- Name: assay_assay_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assay_assay_id_seq OWNED BY public.assay.assay_id;


--
-- TOC entry 245 (class 1259 OID 33732)
-- Name: assay_characteristic_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assay_characteristic_categories (
    assay_id integer NOT NULL,
    ontology_annotation_id character varying NOT NULL
);


ALTER TABLE public.assay_characteristic_categories OWNER TO postgres;

--
-- TOC entry 3935 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE assay_characteristic_categories; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.assay_characteristic_categories IS 'Many to many relationship between Assays and characteristic categories (Ontology Annotations)';


--
-- TOC entry 248 (class 1259 OID 33783)
-- Name: assay_data_files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assay_data_files (
    assay_id integer NOT NULL,
    data_file_id character varying NOT NULL
);


ALTER TABLE public.assay_data_files OWNER TO postgres;

--
-- TOC entry 3936 (class 0 OID 0)
-- Dependencies: 248
-- Name: TABLE assay_data_files; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.assay_data_files IS 'Many to many relationship between Assays and Data Files';


--
-- TOC entry 247 (class 1259 OID 33766)
-- Name: assay_materials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assay_materials (
    assay_id integer NOT NULL,
    material_id character varying NOT NULL
);


ALTER TABLE public.assay_materials OWNER TO postgres;

--
-- TOC entry 3937 (class 0 OID 0)
-- Dependencies: 247
-- Name: TABLE assay_materials; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.assay_materials IS 'Many to many relationship between Assays and Materials';


--
-- TOC entry 246 (class 1259 OID 33749)
-- Name: assay_samples; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assay_samples (
    assay_id integer NOT NULL,
    sample_id character varying NOT NULL
);


ALTER TABLE public.assay_samples OWNER TO postgres;

--
-- TOC entry 3938 (class 0 OID 0)
-- Dependencies: 246
-- Name: TABLE assay_samples; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.assay_samples IS 'Many to many relationship between Assays and Samples';


--
-- TOC entry 244 (class 1259 OID 33715)
-- Name: assay_unit_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assay_unit_categories (
    assay_id integer NOT NULL,
    ontology_annotation_id character varying NOT NULL
);


ALTER TABLE public.assay_unit_categories OWNER TO postgres;

--
-- TOC entry 3939 (class 0 OID 0)
-- Dependencies: 244
-- Name: TABLE assay_unit_categories; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.assay_unit_categories IS 'Many to many relationship between Assays and unit categories (Ontology Annotations)';


--
-- TOC entry 235 (class 1259 OID 33575)
-- Name: characteristic; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.characteristic (
    characteristic_id integer NOT NULL,
    value_int double precision,
    unit_str character varying,
    category_str character varying,
    value_id character varying,
    unit_id character varying,
    category_id character varying,
    CONSTRAINT characteristic_cant_have_more_than_one_unit CHECK ((NOT ((unit_str IS NOT NULL) AND (unit_id IS NOT NULL)))),
    CONSTRAINT "characteristic_cant_have_unit_if_value_is_OA" CHECK ((NOT ((value_id IS NOT NULL) AND ((unit_str IS NOT NULL) OR (unit_id IS NOT NULL))))),
    CONSTRAINT characteristic_must_have_one_value_only CHECK ((NOT ((value_int IS NOT NULL) AND (value_id IS NOT NULL))))
);


ALTER TABLE public.characteristic OWNER TO postgres;

--
-- TOC entry 3940 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE characteristic; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.characteristic IS 'Characteristic table';


--
-- TOC entry 3941 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN characteristic.value_int; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.characteristic.value_int IS 'Characteristic value as a float';


--
-- TOC entry 3942 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN characteristic.unit_str; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.characteristic.unit_str IS 'Characteristic unit as a string';


--
-- TOC entry 3943 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN characteristic.category_str; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.characteristic.category_str IS 'Characteristic category as a string';


--
-- TOC entry 3944 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN characteristic.value_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.characteristic.value_id IS 'Value of the characteristic as an OntologyAnnotation';


--
-- TOC entry 3945 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN characteristic.unit_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.characteristic.unit_id IS 'Characteristic unit as an ontology annotation';


--
-- TOC entry 3946 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN characteristic.category_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.characteristic.category_id IS 'Characteristic category as an ontology annotation';


--
-- TOC entry 234 (class 1259 OID 33574)
-- Name: characteristic_characteristic_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.characteristic_characteristic_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.characteristic_characteristic_id_seq OWNER TO postgres;

--
-- TOC entry 3947 (class 0 OID 0)
-- Dependencies: 234
-- Name: characteristic_characteristic_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.characteristic_characteristic_id_seq OWNED BY public.characteristic.characteristic_id;


--
-- TOC entry 260 (class 1259 OID 33967)
-- Name: comment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comment (
    comment_id integer NOT NULL,
    name character varying,
    value character varying,
    assay_id integer,
    characteristic_id integer,
    datafile_id character varying,
    factor_value_id integer,
    investigation_id integer,
    material_id character varying,
    ontology_source_id character varying,
    ontology_annotation_id character varying,
    person_id integer,
    process_id character varying,
    protocol_id character varying,
    publication_id character varying,
    sample_id character varying,
    source_id character varying,
    study_factor_id character varying,
    study_id integer,
    CONSTRAINT comment_must_have_one_source_only CHECK (((NOT ((investigation_id IS NOT NULL) AND (study_id IS NOT NULL) AND (person_id IS NOT NULL) AND (process_id IS NOT NULL) AND (publication_id IS NOT NULL) AND (ontology_source_id IS NOT NULL) AND (ontology_annotation_id IS NOT NULL) AND (protocol_id IS NOT NULL) AND (source_id IS NOT NULL) AND (characteristic_id IS NOT NULL) AND (study_factor_id IS NOT NULL) AND (sample_id IS NOT NULL) AND (factor_value_id IS NOT NULL) AND (material_id IS NOT NULL) AND (assay_id IS NOT NULL) AND (datafile_id IS NOT NULL))) AND ((investigation_id IS NOT NULL) OR (study_id IS NOT NULL) OR (person_id IS NOT NULL) OR (process_id IS NOT NULL) OR (publication_id IS NOT NULL) OR (ontology_source_id IS NOT NULL) OR (ontology_annotation_id IS NOT NULL) OR (protocol_id IS NOT NULL) OR (source_id IS NOT NULL) OR (characteristic_id IS NOT NULL) OR (study_factor_id IS NOT NULL) OR (sample_id IS NOT NULL) OR (factor_value_id IS NOT NULL) OR (material_id IS NOT NULL) OR (assay_id IS NOT NULL) OR (datafile_id IS NOT NULL))))
);


ALTER TABLE public.comment OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 33966)
-- Name: comment_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comment_comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comment_comment_id_seq OWNER TO postgres;

--
-- TOC entry 3948 (class 0 OID 0)
-- Dependencies: 259
-- Name: comment_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comment_comment_id_seq OWNED BY public.comment.comment_id;


--
-- TOC entry 217 (class 1259 OID 33350)
-- Name: datafile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.datafile (
    datafile_id character varying NOT NULL,
    filename character varying,
    label character varying
);


ALTER TABLE public.datafile OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 33601)
-- Name: factor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.factor (
    factor_id character varying NOT NULL,
    name character varying,
    factor_type_id character varying
);


ALTER TABLE public.factor OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 33918)
-- Name: factor_value; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.factor_value (
    factor_value_id integer NOT NULL,
    value_int integer,
    value_str character varying,
    factor_name_id character varying,
    value_oa_id character varying,
    factor_unit_id character varying,
    CONSTRAINT factor_value_must_have_one_value_only CHECK ((NOT ((value_int IS NOT NULL) AND (value_oa_id IS NOT NULL) AND (value_str IS NOT NULL))))
);


ALTER TABLE public.factor_value OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 33917)
-- Name: factor_value_factor_value_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.factor_value_factor_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.factor_value_factor_value_id_seq OWNER TO postgres;

--
-- TOC entry 3949 (class 0 OID 0)
-- Dependencies: 255
-- Name: factor_value_factor_value_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.factor_value_factor_value_id_seq OWNED BY public.factor_value.factor_value_id;


--
-- TOC entry 213 (class 1259 OID 33320)
-- Name: input_output; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.input_output (
    id_ integer NOT NULL,
    io_id character varying,
    io_type character varying
);


ALTER TABLE public.input_output OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 33319)
-- Name: input_output_id__seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.input_output_id__seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.input_output_id__seq OWNER TO postgres;

--
-- TOC entry 3950 (class 0 OID 0)
-- Dependencies: 212
-- Name: input_output_id__seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.input_output_id__seq OWNED BY public.input_output.id_;


--
-- TOC entry 210 (class 1259 OID 33304)
-- Name: investigation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.investigation (
    investigation_id integer NOT NULL,
    isa_identifier character varying NOT NULL,
    identifier character varying NOT NULL,
    title character varying,
    description character varying,
    submission_date date,
    public_release_date date
);


ALTER TABLE public.investigation OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 33303)
-- Name: investigation_investigation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.investigation_investigation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.investigation_investigation_id_seq OWNER TO postgres;

--
-- TOC entry 3951 (class 0 OID 0)
-- Dependencies: 209
-- Name: investigation_investigation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.investigation_investigation_id_seq OWNED BY public.investigation.investigation_id;


--
-- TOC entry 218 (class 1259 OID 33357)
-- Name: investigation_ontology_source; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.investigation_ontology_source (
    investigation_id integer NOT NULL,
    ontology_source character varying NOT NULL
);


ALTER TABLE public.investigation_ontology_source OWNER TO postgres;

--
-- TOC entry 3952 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE investigation_ontology_source; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.investigation_ontology_source IS 'Many to many relationship between Investigations and Ontology Sources';


--
-- TOC entry 239 (class 1259 OID 33632)
-- Name: investigation_publications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.investigation_publications (
    investigation_id integer NOT NULL,
    publication_id character varying NOT NULL
);


ALTER TABLE public.investigation_publications OWNER TO postgres;

--
-- TOC entry 3953 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE investigation_publications; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.investigation_publications IS 'Many to many relationship between Investigations and Publications';


--
-- TOC entry 216 (class 1259 OID 33342)
-- Name: material; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.material (
    material_id character varying NOT NULL,
    name character varying,
    material_type character varying,
    CONSTRAINT material_type_must_be_extract_name_or_labeled_extract_name CHECK ((NOT ((material_type IS NOT NULL) AND ((material_type)::text <> 'Extract Name'::text) AND ((material_type)::text <> 'Labeled Extract Name'::text))))
);


ALTER TABLE public.material OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 33851)
-- Name: materials_characteristics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.materials_characteristics (
    material_id character varying NOT NULL,
    characteristic_id integer NOT NULL
);


ALTER TABLE public.materials_characteristics OWNER TO postgres;

--
-- TOC entry 3954 (class 0 OID 0)
-- Dependencies: 252
-- Name: TABLE materials_characteristics; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.materials_characteristics IS 'Many to many relationship between Materials and Characteristics';


--
-- TOC entry 222 (class 1259 OID 33405)
-- Name: ontology_annotation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ontology_annotation (
    ontology_annotation_id character varying NOT NULL,
    annotation_value character varying,
    term_accession character varying,
    term_source_id character varying
);


ALTER TABLE public.ontology_annotation OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 33312)
-- Name: ontology_source; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ontology_source (
    ontology_source_id character varying NOT NULL,
    name character varying,
    file character varying,
    version character varying,
    description character varying
);


ALTER TABLE public.ontology_source OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 33531)
-- Name: parameter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parameter (
    parameter_id character varying NOT NULL,
    ontology_annotation_id character varying
);


ALTER TABLE public.parameter OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 33943)
-- Name: parameter_value; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parameter_value (
    parameter_value_id integer NOT NULL,
    value_int integer,
    value_id character varying,
    unit_id character varying,
    category_id character varying
);


ALTER TABLE public.parameter_value OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 33942)
-- Name: parameter_value_parameter_value_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.parameter_value_parameter_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.parameter_value_parameter_value_id_seq OWNER TO postgres;

--
-- TOC entry 3955 (class 0 OID 0)
-- Dependencies: 257
-- Name: parameter_value_parameter_value_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.parameter_value_parameter_value_id_seq OWNED BY public.parameter_value.parameter_value_id;


--
-- TOC entry 232 (class 1259 OID 33544)
-- Name: person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person (
    person_id integer NOT NULL,
    last_name character varying,
    first_name character varying,
    mid_initials character varying,
    email character varying,
    phone character varying,
    fax character varying,
    address character varying,
    affiliation character varying,
    investigation_id integer,
    study_id integer
);


ALTER TABLE public.person OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 33543)
-- Name: person_person_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.person_person_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_person_id_seq OWNER TO postgres;

--
-- TOC entry 3956 (class 0 OID 0)
-- Dependencies: 231
-- Name: person_person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.person_person_id_seq OWNED BY public.person.person_id;


--
-- TOC entry 253 (class 1259 OID 33868)
-- Name: person_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_roles (
    person_id integer NOT NULL,
    role_id character varying NOT NULL
);


ALTER TABLE public.person_roles OWNER TO postgres;

--
-- TOC entry 3957 (class 0 OID 0)
-- Dependencies: 253
-- Name: TABLE person_roles; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.person_roles IS 'Many to many relationship between Persons and Roles (Ontology Annotations)';


--
-- TOC entry 254 (class 1259 OID 33885)
-- Name: process; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.process (
    process_id character varying NOT NULL,
    name character varying,
    performer character varying,
    date date,
    previous_process_id character varying,
    next_process_id character varying,
    study_id integer,
    assay_id integer,
    protocol_id character varying
);


ALTER TABLE public.process OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 34073)
-- Name: process_inputs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.process_inputs (
    input_id_ integer NOT NULL,
    process_id character varying
);


ALTER TABLE public.process_inputs OWNER TO postgres;

--
-- TOC entry 3958 (class 0 OID 0)
-- Dependencies: 262
-- Name: TABLE process_inputs; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.process_inputs IS 'Many to many relationship between Processes and Inputs';


--
-- TOC entry 263 (class 1259 OID 34090)
-- Name: process_outputs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.process_outputs (
    output_id_ integer NOT NULL,
    process_id character varying NOT NULL
);


ALTER TABLE public.process_outputs OWNER TO postgres;

--
-- TOC entry 3959 (class 0 OID 0)
-- Dependencies: 263
-- Name: TABLE process_outputs; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.process_outputs IS 'Many to many relationship between Processes and Outputs';


--
-- TOC entry 264 (class 1259 OID 34109)
-- Name: process_parameter_values; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.process_parameter_values (
    process_id character varying NOT NULL,
    parameter_value_id integer NOT NULL
);


ALTER TABLE public.process_parameter_values OWNER TO postgres;

--
-- TOC entry 3960 (class 0 OID 0)
-- Dependencies: 264
-- Name: TABLE process_parameter_values; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.process_parameter_values IS 'Many to many relationship between Processes and ParameterValues';


--
-- TOC entry 233 (class 1259 OID 33562)
-- Name: protocol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.protocol (
    protocol_id character varying NOT NULL,
    name character varying,
    description character varying,
    uri character varying,
    version character varying,
    protocol_type_id character varying
);


ALTER TABLE public.protocol OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 33800)
-- Name: protocol_parameters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.protocol_parameters (
    protocol_id character varying NOT NULL,
    parameter_id character varying NOT NULL
);


ALTER TABLE public.protocol_parameters OWNER TO postgres;

--
-- TOC entry 3961 (class 0 OID 0)
-- Dependencies: 249
-- Name: TABLE protocol_parameters; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.protocol_parameters IS 'Many to many relationship between Protocols and Parameters';


--
-- TOC entry 229 (class 1259 OID 33519)
-- Name: publication; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publication (
    publication_id character varying NOT NULL,
    author_list character varying,
    doi character varying,
    pubmed_id character varying,
    title character varying,
    status_id character varying
);


ALTER TABLE public.publication OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 33335)
-- Name: sample; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sample (
    sample_id character varying NOT NULL,
    name character varying,
    id bigint NOT NULL
);


ALTER TABLE public.sample OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 33834)
-- Name: sample_characteristics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sample_characteristics (
    sample_id character varying NOT NULL,
    characteristic_id integer NOT NULL
);


ALTER TABLE public.sample_characteristics OWNER TO postgres;

--
-- TOC entry 3962 (class 0 OID 0)
-- Dependencies: 251
-- Name: TABLE sample_characteristics; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sample_characteristics IS 'Many to many relationship between Samples and Characteristics';


--
-- TOC entry 219 (class 1259 OID 33374)
-- Name: sample_derives_from; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sample_derives_from (
    sample_id character varying NOT NULL,
    source_id character varying NOT NULL
);


ALTER TABLE public.sample_derives_from OWNER TO postgres;

--
-- TOC entry 3963 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE sample_derives_from; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sample_derives_from IS 'Many to many relationship between Samples and Sources';


--
-- TOC entry 261 (class 1259 OID 34056)
-- Name: sample_factor_values; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sample_factor_values (
    sample_id character varying NOT NULL,
    factor_value_id integer NOT NULL
);


ALTER TABLE public.sample_factor_values OWNER TO postgres;

--
-- TOC entry 3964 (class 0 OID 0)
-- Dependencies: 261
-- Name: TABLE sample_factor_values; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sample_factor_values IS 'Many to many relationship between Samples and FactorValues';


--
-- TOC entry 306 (class 1259 OID 35984)
-- Name: sample_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sample_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sample_id_seq OWNER TO postgres;

--
-- TOC entry 3965 (class 0 OID 0)
-- Dependencies: 306
-- Name: sample_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sample_id_seq OWNED BY public.sample.id;


--
-- TOC entry 214 (class 1259 OID 33328)
-- Name: source; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.source (
    source_id character varying NOT NULL,
    name character varying
);


ALTER TABLE public.source OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 33817)
-- Name: source_characteristics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.source_characteristics (
    source_id character varying NOT NULL,
    characteristic_id integer NOT NULL
);


ALTER TABLE public.source_characteristics OWNER TO postgres;

--
-- TOC entry 3966 (class 0 OID 0)
-- Dependencies: 250
-- Name: TABLE source_characteristics; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.source_characteristics IS 'Many to many relationship between Sources and Characteristics';


--
-- TOC entry 221 (class 1259 OID 33392)
-- Name: study; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study (
    study_id integer NOT NULL,
    title character varying,
    identifier character varying,
    description character varying,
    filename character varying,
    submission_date character varying,
    public_release_date character varying,
    investigation_id integer
);


ALTER TABLE public.study OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 33700)
-- Name: study_assays; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_assays (
    study_id integer NOT NULL,
    assay_id integer NOT NULL
);


ALTER TABLE public.study_assays OWNER TO postgres;

--
-- TOC entry 3967 (class 0 OID 0)
-- Dependencies: 243
-- Name: TABLE study_assays; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.study_assays IS 'Many to many relationship between Studies and Assays';


--
-- TOC entry 227 (class 1259 OID 33485)
-- Name: study_characteristic_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_characteristic_categories (
    study_id integer NOT NULL,
    ontology_annotation_id character varying NOT NULL
);


ALTER TABLE public.study_characteristic_categories OWNER TO postgres;

--
-- TOC entry 3968 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE study_characteristic_categories; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.study_characteristic_categories IS 'Many to many relationship between Studies and characteristic categories (Ontology Annotations)';


--
-- TOC entry 223 (class 1259 OID 33417)
-- Name: study_design_descriptors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_design_descriptors (
    study_id integer NOT NULL,
    ontology_annotation_id character varying NOT NULL
);


ALTER TABLE public.study_design_descriptors OWNER TO postgres;

--
-- TOC entry 3969 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE study_design_descriptors; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.study_design_descriptors IS 'Many to many relationship between Studies design descriptors (Ontology Annotations)';


--
-- TOC entry 242 (class 1259 OID 33683)
-- Name: study_factors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_factors (
    study_id integer NOT NULL,
    factor_id character varying NOT NULL
);


ALTER TABLE public.study_factors OWNER TO postgres;

--
-- TOC entry 3970 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE study_factors; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.study_factors IS 'Many to many relationship between Studies and FactorsValues';


--
-- TOC entry 226 (class 1259 OID 33468)
-- Name: study_materials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_materials (
    study_id integer NOT NULL,
    material_id character varying NOT NULL
);


ALTER TABLE public.study_materials OWNER TO postgres;

--
-- TOC entry 3971 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE study_materials; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.study_materials IS 'Many to many relationship between Studies and Materials';


--
-- TOC entry 241 (class 1259 OID 33666)
-- Name: study_protocols; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_protocols (
    study_id integer NOT NULL,
    protocol_id character varying NOT NULL
);


ALTER TABLE public.study_protocols OWNER TO postgres;

--
-- TOC entry 3972 (class 0 OID 0)
-- Dependencies: 241
-- Name: TABLE study_protocols; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.study_protocols IS 'Many to many relationship between Studies and Protocols';


--
-- TOC entry 240 (class 1259 OID 33649)
-- Name: study_publications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_publications (
    study_id integer NOT NULL,
    publication_id character varying NOT NULL
);


ALTER TABLE public.study_publications OWNER TO postgres;

--
-- TOC entry 3973 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE study_publications; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.study_publications IS 'Many to many relationship between Studies and Publications';


--
-- TOC entry 225 (class 1259 OID 33451)
-- Name: study_samples; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_samples (
    study_id integer NOT NULL,
    sample_id character varying NOT NULL
);


ALTER TABLE public.study_samples OWNER TO postgres;

--
-- TOC entry 3974 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE study_samples; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.study_samples IS 'Many to many relationship between Studies and Samples';


--
-- TOC entry 224 (class 1259 OID 33434)
-- Name: study_sources; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_sources (
    study_id integer NOT NULL,
    source_id character varying NOT NULL
);


ALTER TABLE public.study_sources OWNER TO postgres;

--
-- TOC entry 3975 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE study_sources; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.study_sources IS 'Many to many relationship between Studies and Sources';


--
-- TOC entry 220 (class 1259 OID 33391)
-- Name: study_study_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.study_study_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.study_study_id_seq OWNER TO postgres;

--
-- TOC entry 3976 (class 0 OID 0)
-- Dependencies: 220
-- Name: study_study_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.study_study_id_seq OWNED BY public.study.study_id;


--
-- TOC entry 228 (class 1259 OID 33502)
-- Name: study_unit_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_unit_categories (
    study_id integer NOT NULL,
    ontology_annotation_id character varying NOT NULL
);


ALTER TABLE public.study_unit_categories OWNER TO postgres;

--
-- TOC entry 3977 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE study_unit_categories; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.study_unit_categories IS 'Many to many relationship between Studies and unit categories (Ontology Annotations)';


--
-- TOC entry 3483 (class 2604 OID 34934)
-- Name: Compound id; Type: DEFAULT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."Compound" ALTER COLUMN id SET DEFAULT nextval('public."Compound_id_seq"'::regclass);


--
-- TOC entry 3480 (class 2604 OID 34921)
-- Name: Configs id; Type: DEFAULT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."Configs" ALTER COLUMN id SET DEFAULT nextval('public."Configs_id_seq"'::regclass);


--
-- TOC entry 3485 (class 2604 OID 34946)
-- Name: Contact id; Type: DEFAULT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."Contact" ALTER COLUMN id SET DEFAULT nextval('public."Contact_id_seq"'::regclass);


--
-- TOC entry 3486 (class 2604 OID 34955)
-- Name: DataSource id; Type: DEFAULT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."DataSource" ALTER COLUMN id SET DEFAULT nextval('public."DataSource_id_seq"'::regclass);


--
-- TOC entry 3489 (class 2604 OID 34982)
-- Name: MS1Dets id; Type: DEFAULT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS1Dets" ALTER COLUMN id SET DEFAULT nextval('public."MS1Dets_id_seq"'::regclass);


--
-- TOC entry 3490 (class 2604 OID 34996)
-- Name: MS1DetsImportLog id; Type: DEFAULT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS1DetsImportLog" ALTER COLUMN id SET DEFAULT nextval('public."MS1DetsImportLog_id_seq"'::regclass);


--
-- TOC entry 3488 (class 2604 OID 34973)
-- Name: MS1Mst id; Type: DEFAULT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS1Mst" ALTER COLUMN id SET DEFAULT nextval('public."MS1Mst_id_seq"'::regclass);


--
-- TOC entry 3492 (class 2604 OID 35029)
-- Name: MS2Dets id; Type: DEFAULT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS2Dets" ALTER COLUMN id SET DEFAULT nextval('public."MS2Dets_id_seq"'::regclass);


--
-- TOC entry 3493 (class 2604 OID 35049)
-- Name: MS2DetsImportLog id; Type: DEFAULT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS2DetsImportLog" ALTER COLUMN id SET DEFAULT nextval('public."MS2DetsImportLog_id_seq"'::regclass);


--
-- TOC entry 3491 (class 2604 OID 35010)
-- Name: MS2Mst id; Type: DEFAULT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS2Mst" ALTER COLUMN id SET DEFAULT nextval('public."MS2Mst_id_seq"'::regclass);


--
-- TOC entry 3494 (class 2604 OID 35064)
-- Name: MS2Peak id; Type: DEFAULT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS2Peak" ALTER COLUMN id SET DEFAULT nextval('public."MS2Peak_id_seq"'::regclass);


--
-- TOC entry 3495 (class 2604 OID 35077)
-- Name: MS2PeakImportLog id; Type: DEFAULT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS2PeakImportLog" ALTER COLUMN id SET DEFAULT nextval('public."MS2PeakImportLog_id_seq"'::regclass);


--
-- TOC entry 3487 (class 2604 OID 34964)
-- Name: MassSpecType id; Type: DEFAULT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MassSpecType" ALTER COLUMN id SET DEFAULT nextval('public."MassSpecType_id_seq"'::regclass);


--
-- TOC entry 3502 (class 2604 OID 35322)
-- Name: PeakTableMerge id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PeakTableMerge" ALTER COLUMN id SET DEFAULT nextval('public."PeakTableMerge_id_seq"'::regclass);


--
-- TOC entry 3503 (class 2604 OID 35977)
-- Name: PeakTableMerge a_sample_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PeakTableMerge" ALTER COLUMN a_sample_id SET DEFAULT nextval('public."PeakTableMerge_a_sample_id_seq"'::regclass);


--
-- TOC entry 3500 (class 2604 OID 35149)
-- Name: UnknownComparisonMisc id; Type: DEFAULT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."UnknownComparisonMisc" ALTER COLUMN id SET DEFAULT nextval('public."UnknownComparisonMisc_id_seq"'::regclass);


--
-- TOC entry 3499 (class 2604 OID 35135)
-- Name: UnknownDetectionResults id; Type: DEFAULT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."UnknownDetectionResults" ALTER COLUMN id SET DEFAULT nextval('public."UnknownDetectionResults_id_seq"'::regclass);


--
-- TOC entry 3497 (class 2604 OID 35109)
-- Name: UnknownMS2Dets id; Type: DEFAULT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."UnknownMS2Dets" ALTER COLUMN id SET DEFAULT nextval('public."UnknownMS2Dets_id_seq"'::regclass);


--
-- TOC entry 3496 (class 2604 OID 35090)
-- Name: UnknownMS2Mst id; Type: DEFAULT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."UnknownMS2Mst" ALTER COLUMN id SET DEFAULT nextval('public."UnknownMS2Mst_id_seq"'::regclass);


--
-- TOC entry 3498 (class 2604 OID 35123)
-- Name: UnknownMS2Peak id; Type: DEFAULT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."UnknownMS2Peak" ALTER COLUMN id SET DEFAULT nextval('public."UnknownMS2Peak_id_seq"'::regclass);


--
-- TOC entry 3501 (class 2604 OID 35161)
-- Name: User id; Type: DEFAULT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."User" ALTER COLUMN id SET DEFAULT nextval('public."User_id_seq"'::regclass);


--
-- TOC entry 3474 (class 2604 OID 33617)
-- Name: assay assay_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assay ALTER COLUMN assay_id SET DEFAULT nextval('public.assay_assay_id_seq'::regclass);


--
-- TOC entry 3470 (class 2604 OID 33578)
-- Name: characteristic characteristic_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.characteristic ALTER COLUMN characteristic_id SET DEFAULT nextval('public.characteristic_characteristic_id_seq'::regclass);


--
-- TOC entry 3478 (class 2604 OID 33970)
-- Name: comment comment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment ALTER COLUMN comment_id SET DEFAULT nextval('public.comment_comment_id_seq'::regclass);


--
-- TOC entry 3475 (class 2604 OID 33921)
-- Name: factor_value factor_value_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factor_value ALTER COLUMN factor_value_id SET DEFAULT nextval('public.factor_value_factor_value_id_seq'::regclass);


--
-- TOC entry 3465 (class 2604 OID 33323)
-- Name: input_output id_; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.input_output ALTER COLUMN id_ SET DEFAULT nextval('public.input_output_id__seq'::regclass);


--
-- TOC entry 3464 (class 2604 OID 33307)
-- Name: investigation investigation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.investigation ALTER COLUMN investigation_id SET DEFAULT nextval('public.investigation_investigation_id_seq'::regclass);


--
-- TOC entry 3477 (class 2604 OID 33946)
-- Name: parameter_value parameter_value_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parameter_value ALTER COLUMN parameter_value_id SET DEFAULT nextval('public.parameter_value_parameter_value_id_seq'::regclass);


--
-- TOC entry 3469 (class 2604 OID 33547)
-- Name: person person_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person ALTER COLUMN person_id SET DEFAULT nextval('public.person_person_id_seq'::regclass);


--
-- TOC entry 3466 (class 2604 OID 35985)
-- Name: sample id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sample ALTER COLUMN id SET DEFAULT nextval('public.sample_id_seq'::regclass);


--
-- TOC entry 3468 (class 2604 OID 33395)
-- Name: study study_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study ALTER COLUMN study_id SET DEFAULT nextval('public.study_study_id_seq'::regclass);


--
-- TOC entry 3605 (class 2606 OID 34939)
-- Name: Compound Compound_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."Compound"
  --  ADD CONSTRAINT "Compound_pkey" PRIMARY KEY (id);


--
-- TOC entry 3601 (class 2606 OID 34927)
-- Name: Configs Configs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."Configs"
  --  ADD CONSTRAINT "Configs_pkey" PRIMARY KEY (id);


--
-- TOC entry 3609 (class 2606 OID 34950)
-- Name: Contact Contact_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

-- ALTER TABLE ONLY public."Contact"
--     ADD CONSTRAINT "Contact_pkey" PRIMARY KEY (id);


--
-- TOC entry 3611 (class 2606 OID 34959)
-- Name: DataSource DataSource_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."DataSource"
  --  ADD CONSTRAINT "DataSource_pkey" PRIMARY KEY (id);


--
-- TOC entry 3619 (class 2606 OID 35000)
-- Name: MS1DetsImportLog MS1DetsImportLog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS1DetsImportLog"
  --  ADD CONSTRAINT "MS1DetsImportLog_pkey" PRIMARY KEY (id);


--
-- TOC entry 3617 (class 2606 OID 34986)
-- Name: MS1Dets MS1Dets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS1Dets"
  --  ADD CONSTRAINT "MS1Dets_pkey" PRIMARY KEY (id);


--
-- TOC entry 3615 (class 2606 OID 34977)
-- Name: MS1Mst MS1Mast_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS1Mst"
  --  ADD CONSTRAINT "MS1Mast_pkey" PRIMARY KEY (id);


--
-- TOC entry 3626 (class 2606 OID 35053)
-- Name: MS2DetsImportLog MS2DetsImportLog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS2DetsImportLog"
  --  ADD CONSTRAINT "MS2DetsImportLog_pkey" PRIMARY KEY (id);


--
-- TOC entry 3623 (class 2606 OID 35033)
-- Name: MS2Dets MS2Dets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS2Dets"
  --  ADD CONSTRAINT "MS2Dets_pkey" PRIMARY KEY (id);


--
-- TOC entry 3621 (class 2606 OID 35014)
-- Name: MS2Mst MS2Mst_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS2Mst"
  --  ADD CONSTRAINT "MS2Mst_pkey" PRIMARY KEY (id);


--
-- TOC entry 3613 (class 2606 OID 34968)
-- Name: MassSpecType MassSpecType_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MassSpecType"
  --  ADD CONSTRAINT "MassSpecType_pkey" PRIMARY KEY (id);


--
-- TOC entry 3649 (class 2606 OID 35326)
-- Name: PeakTableMerge PeakTableMerge_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PeakTableMerge"
    ADD CONSTRAINT "PeakTableMerge_pkey" PRIMARY KEY (id);


--
-- TOC entry 3629 (class 2606 OID 35066)
-- Name: MS2Peak Peak_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS2Peak"
  --  ADD CONSTRAINT "Peak_pkey1" PRIMARY KEY (id);


--
-- TOC entry 3632 (class 2606 OID 35079)
-- Name: MS2PeakImportLog Peak_pkey2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS2PeakImportLog"
  --  ADD CONSTRAINT "Peak_pkey2" PRIMARY KEY (id);


--
-- TOC entry 3639 (class 2606 OID 35125)
-- Name: UnknownMS2Peak UPeak_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."UnknownMS2Peak"
  --  ADD CONSTRAINT "UPeak_pkey1" PRIMARY KEY (id);


--
-- TOC entry 3643 (class 2606 OID 35151)
-- Name: UnknownComparisonMisc UnknownComparisonMisc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."UnknownComparisonMisc"
  --  ADD CONSTRAINT "UnknownComparisonMisc_pkey" PRIMARY KEY (id, ms2mst_id);


--
-- TOC entry 3641 (class 2606 OID 35139)
-- Name: UnknownDetectionResults UnknownDetectionResults_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."UnknownDetectionResults"
  --  ADD CONSTRAINT "UnknownDetectionResults_pkey" PRIMARY KEY (id);


--
-- TOC entry 3637 (class 2606 OID 35113)
-- Name: UnknownMS2Dets UnknownMS2Dets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."UnknownMS2Dets"
  --  ADD CONSTRAINT "UnknownMS2Dets_pkey" PRIMARY KEY (id);


--
-- TOC entry 3635 (class 2606 OID 35094)
-- Name: UnknownMS2Mst UnknownMS2Mst_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."UnknownMS2Mst"
  --  ADD CONSTRAINT "UnknownMS2Mst_pkey" PRIMARY KEY (id);


--
-- TOC entry 3645 (class 2606 OID 35165)
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."User"
  --  ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- TOC entry 3565 (class 2606 OID 33738)
-- Name: assay_characteristic_categories assay_characteristic_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assay_characteristic_categories
    ADD CONSTRAINT assay_characteristic_categories_pkey PRIMARY KEY (assay_id, ontology_annotation_id);


--
-- TOC entry 3571 (class 2606 OID 33789)
-- Name: assay_data_files assay_data_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assay_data_files
    ADD CONSTRAINT assay_data_files_pkey PRIMARY KEY (assay_id, data_file_id);


--
-- TOC entry 3569 (class 2606 OID 33772)
-- Name: assay_materials assay_materials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assay_materials
    ADD CONSTRAINT assay_materials_pkey PRIMARY KEY (assay_id, material_id);


--
-- TOC entry 3551 (class 2606 OID 33621)
-- Name: assay assay_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assay
    ADD CONSTRAINT assay_pkey PRIMARY KEY (assay_id);


--
-- TOC entry 3567 (class 2606 OID 33755)
-- Name: assay_samples assay_samples_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assay_samples
    ADD CONSTRAINT assay_samples_pkey PRIMARY KEY (assay_id, sample_id);


--
-- TOC entry 3563 (class 2606 OID 33721)
-- Name: assay_unit_categories assay_unit_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assay_unit_categories
    ADD CONSTRAINT assay_unit_categories_pkey PRIMARY KEY (assay_id, ontology_annotation_id);


--
-- TOC entry 3547 (class 2606 OID 33585)
-- Name: characteristic characteristic_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.characteristic
    ADD CONSTRAINT characteristic_pkey PRIMARY KEY (characteristic_id);


--
-- TOC entry 3589 (class 2606 OID 33975)
-- Name: comment comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 3607 (class 2606 OID 34941)
-- Name: Compound compound_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."Compound"
 --   ADD CONSTRAINT compound_name UNIQUE (name) INCLUDE (name);


--
-- TOC entry 3517 (class 2606 OID 33356)
-- Name: datafile datafile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.datafile
    ADD CONSTRAINT datafile_pkey PRIMARY KEY (datafile_id);


--
-- TOC entry 3549 (class 2606 OID 33607)
-- Name: factor factor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factor
    ADD CONSTRAINT factor_pkey PRIMARY KEY (factor_id);


--
-- TOC entry 3585 (class 2606 OID 33926)
-- Name: factor_value factor_value_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factor_value
    ADD CONSTRAINT factor_value_pkey PRIMARY KEY (factor_value_id);


--
-- TOC entry 3509 (class 2606 OID 33327)
-- Name: input_output input_output_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.input_output
    ADD CONSTRAINT input_output_pkey PRIMARY KEY (id_);


--
-- TOC entry 3519 (class 2606 OID 33363)
-- Name: investigation_ontology_source investigation_ontology_source_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.investigation_ontology_source
    ADD CONSTRAINT investigation_ontology_source_pkey PRIMARY KEY (investigation_id, ontology_source);


--
-- TOC entry 3505 (class 2606 OID 33311)
-- Name: investigation investigation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.investigation
    ADD CONSTRAINT investigation_pkey PRIMARY KEY (investigation_id);


--
-- TOC entry 3553 (class 2606 OID 33638)
-- Name: investigation_publications investigation_publications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.investigation_publications
    ADD CONSTRAINT investigation_publications_pkey PRIMARY KEY (investigation_id, publication_id);


--
-- TOC entry 3515 (class 2606 OID 33349)
-- Name: material material_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material
    ADD CONSTRAINT material_pkey PRIMARY KEY (material_id);


--
-- TOC entry 3579 (class 2606 OID 33857)
-- Name: materials_characteristics materials_characteristics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials_characteristics
    ADD CONSTRAINT materials_characteristics_pkey PRIMARY KEY (material_id, characteristic_id);


--
-- TOC entry 3525 (class 2606 OID 33411)
-- Name: ontology_annotation ontology_annotation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ontology_annotation
    ADD CONSTRAINT ontology_annotation_pkey PRIMARY KEY (ontology_annotation_id);


--
-- TOC entry 3507 (class 2606 OID 33318)
-- Name: ontology_source ontology_source_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ontology_source
    ADD CONSTRAINT ontology_source_pkey PRIMARY KEY (ontology_source_id);


--
-- TOC entry 3541 (class 2606 OID 33537)
-- Name: parameter parameter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parameter
    ADD CONSTRAINT parameter_pkey PRIMARY KEY (parameter_id);


--
-- TOC entry 3587 (class 2606 OID 33950)
-- Name: parameter_value parameter_value_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parameter_value
    ADD CONSTRAINT parameter_value_pkey PRIMARY KEY (parameter_value_id);


--
-- TOC entry 3543 (class 2606 OID 33551)
-- Name: person person_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (person_id);


--
-- TOC entry 3581 (class 2606 OID 33874)
-- Name: person_roles person_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_roles
    ADD CONSTRAINT person_roles_pkey PRIMARY KEY (person_id, role_id);


--
-- TOC entry 3593 (class 2606 OID 34079)
-- Name: process_inputs process_inputs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_inputs
    ADD CONSTRAINT process_inputs_pkey PRIMARY KEY (input_id_);


--
-- TOC entry 3595 (class 2606 OID 34098)
-- Name: process_outputs process_outputs_output_id__key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_outputs
    ADD CONSTRAINT process_outputs_output_id__key UNIQUE (output_id_);


--
-- TOC entry 3597 (class 2606 OID 34096)
-- Name: process_outputs process_outputs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_outputs
    ADD CONSTRAINT process_outputs_pkey PRIMARY KEY (output_id_, process_id);


--
-- TOC entry 3599 (class 2606 OID 34115)
-- Name: process_parameter_values process_parameter_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_parameter_values
    ADD CONSTRAINT process_parameter_values_pkey PRIMARY KEY (process_id, parameter_value_id);


--
-- TOC entry 3583 (class 2606 OID 33891)
-- Name: process process_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process
    ADD CONSTRAINT process_pkey PRIMARY KEY (process_id);


--
-- TOC entry 3573 (class 2606 OID 33806)
-- Name: protocol_parameters protocol_parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protocol_parameters
    ADD CONSTRAINT protocol_parameters_pkey PRIMARY KEY (protocol_id, parameter_id);


--
-- TOC entry 3545 (class 2606 OID 33568)
-- Name: protocol protocol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protocol
    ADD CONSTRAINT protocol_pkey PRIMARY KEY (protocol_id);


--
-- TOC entry 3539 (class 2606 OID 33525)
-- Name: publication publication_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publication
    ADD CONSTRAINT publication_pkey PRIMARY KEY (publication_id);


--
-- TOC entry 3577 (class 2606 OID 33840)
-- Name: sample_characteristics sample_characteristics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sample_characteristics
    ADD CONSTRAINT sample_characteristics_pkey PRIMARY KEY (sample_id, characteristic_id);


--
-- TOC entry 3521 (class 2606 OID 33380)
-- Name: sample_derives_from sample_derives_from_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sample_derives_from
    ADD CONSTRAINT sample_derives_from_pkey PRIMARY KEY (sample_id, source_id);


--
-- TOC entry 3591 (class 2606 OID 34062)
-- Name: sample_factor_values sample_factor_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sample_factor_values
    ADD CONSTRAINT sample_factor_values_pkey PRIMARY KEY (sample_id, factor_value_id);


--
-- TOC entry 3513 (class 2606 OID 33341)
-- Name: sample sample_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sample
    ADD CONSTRAINT sample_pkey PRIMARY KEY (sample_id);


--
-- TOC entry 3575 (class 2606 OID 33823)
-- Name: source_characteristics source_characteristics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.source_characteristics
    ADD CONSTRAINT source_characteristics_pkey PRIMARY KEY (source_id, characteristic_id);


--
-- TOC entry 3511 (class 2606 OID 33334)
-- Name: source source_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.source
    ADD CONSTRAINT source_pkey PRIMARY KEY (source_id);


--
-- TOC entry 3561 (class 2606 OID 33704)
-- Name: study_assays study_assays_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_assays
    ADD CONSTRAINT study_assays_pkey PRIMARY KEY (study_id, assay_id);


--
-- TOC entry 3535 (class 2606 OID 33491)
-- Name: study_characteristic_categories study_characteristic_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_characteristic_categories
    ADD CONSTRAINT study_characteristic_categories_pkey PRIMARY KEY (study_id, ontology_annotation_id);


--
-- TOC entry 3527 (class 2606 OID 33423)
-- Name: study_design_descriptors study_design_descriptors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_design_descriptors
    ADD CONSTRAINT study_design_descriptors_pkey PRIMARY KEY (study_id, ontology_annotation_id);


--
-- TOC entry 3559 (class 2606 OID 33689)
-- Name: study_factors study_factors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_factors
    ADD CONSTRAINT study_factors_pkey PRIMARY KEY (study_id, factor_id);


--
-- TOC entry 3533 (class 2606 OID 33474)
-- Name: study_materials study_materials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_materials
    ADD CONSTRAINT study_materials_pkey PRIMARY KEY (study_id, material_id);


--
-- TOC entry 3523 (class 2606 OID 33399)
-- Name: study study_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study
    ADD CONSTRAINT study_pkey PRIMARY KEY (study_id);


--
-- TOC entry 3557 (class 2606 OID 33672)
-- Name: study_protocols study_protocols_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_protocols
    ADD CONSTRAINT study_protocols_pkey PRIMARY KEY (study_id, protocol_id);


--
-- TOC entry 3555 (class 2606 OID 33655)
-- Name: study_publications study_publications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_publications
    ADD CONSTRAINT study_publications_pkey PRIMARY KEY (study_id, publication_id);


--
-- TOC entry 3531 (class 2606 OID 33457)
-- Name: study_samples study_samples_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_samples
    ADD CONSTRAINT study_samples_pkey PRIMARY KEY (study_id, sample_id);


--
-- TOC entry 3529 (class 2606 OID 33440)
-- Name: study_sources study_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_sources
    ADD CONSTRAINT study_sources_pkey PRIMARY KEY (study_id, source_id);


--
-- TOC entry 3537 (class 2606 OID 33508)
-- Name: study_unit_categories study_unit_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_unit_categories
    ADD CONSTRAINT study_unit_categories_pkey PRIMARY KEY (study_id, ontology_annotation_id);


--
-- TOC entry 3603 (class 2606 OID 34929)
-- Name: Configs uniqname; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."Configs"
 --   ADD CONSTRAINT uniqname UNIQUE (name) INCLUDE (name);


--
-- TOC entry 3647 (class 2606 OID 35167)
-- Name: User unique_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."User"
  --  ADD CONSTRAINT unique_email UNIQUE (email_id);


--
-- TOC entry 3630 (class 1259 OID 35072)
-- Name: ms2dets_id; Type: INDEX; Schema: public; Owner: postgres
--

--CREATE INDEX ms2dets_id ON public."MS2Peak" USING btree (ms2_det_id);


--
-- TOC entry 3633 (class 1259 OID 35085)
-- Name: ms2dets_id1; Type: INDEX; Schema: public; Owner: postgres
--

--CREATE INDEX ms2dets_id1 ON public."MS2PeakImportLog" USING btree (ms2_det_id);


--
-- TOC entry 3624 (class 1259 OID 35044)
-- Name: ms2mst_id1; Type: INDEX; Schema: public; Owner: postgres
--

--CREATE INDEX ms2mst_id1 ON public."MS2Dets" USING btree (ms2mst_id);


--
-- TOC entry 3627 (class 1259 OID 35059)
-- Name: ms2mst_id2; Type: INDEX; Schema: public; Owner: postgres
--

--CREATE INDEX ms2mst_id2 ON public."MS2DetsImportLog" USING btree (ms2mst_id);


--
-- TOC entry 3750 (class 2606 OID 35054)
-- Name: MS2DetsImportLog MS2DetsImportLog_spec_scan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS2DetsImportLog"
  --  ADD CONSTRAINT "MS2DetsImportLog_spec_scan_id_fkey" FOREIGN KEY (ms2mst_id) REFERENCES public."MS2Mst"(id);


--
-- TOC entry 3748 (class 2606 OID 35034)
-- Name: MS2Dets MS2Dets_spec_scan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS2Dets"
  --  ADD CONSTRAINT "MS2Dets_spec_scan_id_fkey" FOREIGN KEY (ms2mst_id) REFERENCES public."MS2Mst"(id);


--
-- TOC entry 3746 (class 2606 OID 35015)
-- Name: MS2Mst MS2Mst_data_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS2Mst"
  --  ADD CONSTRAINT "MS2Mst_data_source_id_fkey" FOREIGN KEY (data_source_id) REFERENCES public."DataSource"(id);


--
-- TOC entry 3747 (class 2606 OID 35020)
-- Name: MS2Mst MS2Mst_mass_spec_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS2Mst"
  --  ADD CONSTRAINT "MS2Mst_mass_spec_type_id_fkey" FOREIGN KEY (mass_spec_type_id) REFERENCES public."MassSpecType"(id);


--
-- TOC entry 3751 (class 2606 OID 35067)
-- Name: MS2Peak Peak_ms2dets_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS2Peak"
  --  ADD CONSTRAINT "Peak_ms2dets_id_fkey" FOREIGN KEY (ms2_det_id) REFERENCES public."MS2Dets"(id);


--
-- TOC entry 3752 (class 2606 OID 35080)
-- Name: MS2PeakImportLog Peak_ms2detsimportlog_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS2PeakImportLog"
  --  ADD CONSTRAINT "Peak_ms2detsimportlog_id_fkey" FOREIGN KEY (ms2_det_id) REFERENCES public."MS2DetsImportLog"(id);


--
-- TOC entry 3755 (class 2606 OID 35114)
-- Name: UnknownMS2Dets UMS2Dets_spec_scan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."UnknownMS2Dets"
  --  ADD CONSTRAINT "UMS2Dets_spec_scan_id_fkey" FOREIGN KEY (ms2mst_id) REFERENCES public."UnknownMS2Mst"(id);


--
-- TOC entry 3756 (class 2606 OID 35126)
-- Name: UnknownMS2Peak UPeak_ms2dets_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."UnknownMS2Peak"
  --  ADD CONSTRAINT "UPeak_ms2dets_id_fkey" FOREIGN KEY (ms2_det_id) REFERENCES public."UnknownMS2Dets"(id);


--
-- TOC entry 3753 (class 2606 OID 35095)
-- Name: UnknownMS2Mst UnknownMS2Mst_data_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."UnknownMS2Mst"
  --  ADD CONSTRAINT "UnknownMS2Mst_data_source_id_fkey" FOREIGN KEY (data_source_id) REFERENCES public."DataSource"(id);


--
-- TOC entry 3754 (class 2606 OID 35100)
-- Name: UnknownMS2Mst UnknownMS2Mst_mass_spec_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."UnknownMS2Mst"
  --  ADD CONSTRAINT "UnknownMS2Mst_mass_spec_type_id_fkey" FOREIGN KEY (mass_spec_type_id) REFERENCES public."MassSpecType"(id);


--
-- TOC entry 3691 (class 2606 OID 33739)
-- Name: assay_characteristic_categories assay_characteristic_categories_assay_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assay_characteristic_categories
    ADD CONSTRAINT assay_characteristic_categories_assay_id_fkey FOREIGN KEY (assay_id) REFERENCES public.assay(assay_id);


--
-- TOC entry 3692 (class 2606 OID 33744)
-- Name: assay_characteristic_categories assay_characteristic_categories_ontology_annotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assay_characteristic_categories
    ADD CONSTRAINT assay_characteristic_categories_ontology_annotation_id_fkey FOREIGN KEY (ontology_annotation_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3697 (class 2606 OID 33790)
-- Name: assay_data_files assay_data_files_assay_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assay_data_files
    ADD CONSTRAINT assay_data_files_assay_id_fkey FOREIGN KEY (assay_id) REFERENCES public.assay(assay_id);


--
-- TOC entry 3698 (class 2606 OID 33795)
-- Name: assay_data_files assay_data_files_data_file_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assay_data_files
    ADD CONSTRAINT assay_data_files_data_file_id_fkey FOREIGN KEY (data_file_id) REFERENCES public.datafile(datafile_id);


--
-- TOC entry 3695 (class 2606 OID 33773)
-- Name: assay_materials assay_materials_assay_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assay_materials
    ADD CONSTRAINT assay_materials_assay_id_fkey FOREIGN KEY (assay_id) REFERENCES public.assay(assay_id);


--
-- TOC entry 3696 (class 2606 OID 33778)
-- Name: assay_materials assay_materials_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assay_materials
    ADD CONSTRAINT assay_materials_material_id_fkey FOREIGN KEY (material_id) REFERENCES public.material(material_id);


--
-- TOC entry 3677 (class 2606 OID 33622)
-- Name: assay assay_measurement_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assay
    ADD CONSTRAINT assay_measurement_type_id_fkey FOREIGN KEY (measurement_type_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3693 (class 2606 OID 33756)
-- Name: assay_samples assay_samples_assay_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assay_samples
    ADD CONSTRAINT assay_samples_assay_id_fkey FOREIGN KEY (assay_id) REFERENCES public.assay(assay_id);


--
-- TOC entry 3694 (class 2606 OID 33761)
-- Name: assay_samples assay_samples_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assay_samples
    ADD CONSTRAINT assay_samples_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.sample(sample_id);


--
-- TOC entry 3678 (class 2606 OID 33627)
-- Name: assay assay_technology_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assay
    ADD CONSTRAINT assay_technology_type_id_fkey FOREIGN KEY (technology_type_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3689 (class 2606 OID 33722)
-- Name: assay_unit_categories assay_unit_categories_assay_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assay_unit_categories
    ADD CONSTRAINT assay_unit_categories_assay_id_fkey FOREIGN KEY (assay_id) REFERENCES public.assay(assay_id);


--
-- TOC entry 3690 (class 2606 OID 33727)
-- Name: assay_unit_categories assay_unit_categories_ontology_annotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assay_unit_categories
    ADD CONSTRAINT assay_unit_categories_ontology_annotation_id_fkey FOREIGN KEY (ontology_annotation_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3675 (class 2606 OID 33596)
-- Name: characteristic characteristic_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.characteristic
    ADD CONSTRAINT characteristic_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3674 (class 2606 OID 33591)
-- Name: characteristic characteristic_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.characteristic
    ADD CONSTRAINT characteristic_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3673 (class 2606 OID 33586)
-- Name: characteristic characteristic_value_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.characteristic
    ADD CONSTRAINT characteristic_value_id_fkey FOREIGN KEY (value_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3720 (class 2606 OID 33976)
-- Name: comment comment_assay_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_assay_id_fkey FOREIGN KEY (assay_id) REFERENCES public.assay(assay_id);


--
-- TOC entry 3721 (class 2606 OID 33981)
-- Name: comment comment_characteristic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_characteristic_id_fkey FOREIGN KEY (characteristic_id) REFERENCES public.characteristic(characteristic_id);


--
-- TOC entry 3722 (class 2606 OID 33986)
-- Name: comment comment_datafile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_datafile_id_fkey FOREIGN KEY (datafile_id) REFERENCES public.datafile(datafile_id);


--
-- TOC entry 3723 (class 2606 OID 33991)
-- Name: comment comment_factor_value_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_factor_value_id_fkey FOREIGN KEY (factor_value_id) REFERENCES public.factor_value(factor_value_id);


--
-- TOC entry 3724 (class 2606 OID 33996)
-- Name: comment comment_investigation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_investigation_id_fkey FOREIGN KEY (investigation_id) REFERENCES public.investigation(investigation_id);


--
-- TOC entry 3725 (class 2606 OID 34001)
-- Name: comment comment_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_material_id_fkey FOREIGN KEY (material_id) REFERENCES public.material(material_id);


--
-- TOC entry 3727 (class 2606 OID 34011)
-- Name: comment comment_ontology_annotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_ontology_annotation_id_fkey FOREIGN KEY (ontology_annotation_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3726 (class 2606 OID 34006)
-- Name: comment comment_ontology_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_ontology_source_id_fkey FOREIGN KEY (ontology_source_id) REFERENCES public.ontology_source(ontology_source_id);


--
-- TOC entry 3728 (class 2606 OID 34016)
-- Name: comment comment_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(person_id);


--
-- TOC entry 3729 (class 2606 OID 34021)
-- Name: comment comment_process_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_process_id_fkey FOREIGN KEY (process_id) REFERENCES public.process(process_id);


--
-- TOC entry 3730 (class 2606 OID 34026)
-- Name: comment comment_protocol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_protocol_id_fkey FOREIGN KEY (protocol_id) REFERENCES public.protocol(protocol_id);


--
-- TOC entry 3731 (class 2606 OID 34031)
-- Name: comment comment_publication_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_publication_id_fkey FOREIGN KEY (publication_id) REFERENCES public.publication(publication_id);


--
-- TOC entry 3732 (class 2606 OID 34036)
-- Name: comment comment_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.sample(sample_id);


--
-- TOC entry 3733 (class 2606 OID 34041)
-- Name: comment comment_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_source_id_fkey FOREIGN KEY (source_id) REFERENCES public.source(source_id);


--
-- TOC entry 3734 (class 2606 OID 34046)
-- Name: comment comment_study_factor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_study_factor_id_fkey FOREIGN KEY (study_factor_id) REFERENCES public.factor(factor_id);


--
-- TOC entry 3735 (class 2606 OID 34051)
-- Name: comment comment_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_study_id_fkey FOREIGN KEY (study_id) REFERENCES public.study(study_id);


--
-- TOC entry 3744 (class 2606 OID 34987)
-- Name: MS1Dets compound_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS1Dets"
--    ADD CONSTRAINT compound_id FOREIGN KEY (compound_id) REFERENCES public."Compound"(id);


--
-- TOC entry 3745 (class 2606 OID 35001)
-- Name: MS1DetsImportLog compound_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS1DetsImportLog"
  --  ADD CONSTRAINT compound_id FOREIGN KEY (compound_id) REFERENCES public."Compound"(id);


--
-- TOC entry 3749 (class 2606 OID 35039)
-- Name: MS2Dets compoundid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."MS2Dets"
  --  ADD CONSTRAINT compoundid FOREIGN KEY (compound_id) REFERENCES public."Compound"(id);


--
-- TOC entry 3676 (class 2606 OID 33608)
-- Name: factor factor_factor_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factor
    ADD CONSTRAINT factor_factor_type_id_fkey FOREIGN KEY (factor_type_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3714 (class 2606 OID 33927)
-- Name: factor_value factor_value_factor_name_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factor_value
    ADD CONSTRAINT factor_value_factor_name_id_fkey FOREIGN KEY (factor_name_id) REFERENCES public.factor(factor_id);


--
-- TOC entry 3716 (class 2606 OID 33937)
-- Name: factor_value factor_value_factor_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factor_value
    ADD CONSTRAINT factor_value_factor_unit_id_fkey FOREIGN KEY (factor_unit_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3715 (class 2606 OID 33932)
-- Name: factor_value factor_value_value_oa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.factor_value
    ADD CONSTRAINT factor_value_value_oa_id_fkey FOREIGN KEY (value_oa_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3650 (class 2606 OID 33364)
-- Name: investigation_ontology_source investigation_ontology_source_investigation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.investigation_ontology_source
    ADD CONSTRAINT investigation_ontology_source_investigation_id_fkey FOREIGN KEY (investigation_id) REFERENCES public.investigation(investigation_id);


--
-- TOC entry 3651 (class 2606 OID 33369)
-- Name: investigation_ontology_source investigation_ontology_source_ontology_source_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.investigation_ontology_source
    ADD CONSTRAINT investigation_ontology_source_ontology_source_fkey FOREIGN KEY (ontology_source) REFERENCES public.ontology_source(ontology_source_id);


--
-- TOC entry 3679 (class 2606 OID 33639)
-- Name: investigation_publications investigation_publications_investigation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.investigation_publications
    ADD CONSTRAINT investigation_publications_investigation_id_fkey FOREIGN KEY (investigation_id) REFERENCES public.investigation(investigation_id);


--
-- TOC entry 3680 (class 2606 OID 33644)
-- Name: investigation_publications investigation_publications_publication_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.investigation_publications
    ADD CONSTRAINT investigation_publications_publication_id_fkey FOREIGN KEY (publication_id) REFERENCES public.publication(publication_id);


--
-- TOC entry 3706 (class 2606 OID 33863)
-- Name: materials_characteristics materials_characteristics_characteristic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials_characteristics
    ADD CONSTRAINT materials_characteristics_characteristic_id_fkey FOREIGN KEY (characteristic_id) REFERENCES public.characteristic(characteristic_id);


--
-- TOC entry 3705 (class 2606 OID 33858)
-- Name: materials_characteristics materials_characteristics_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials_characteristics
    ADD CONSTRAINT materials_characteristics_material_id_fkey FOREIGN KEY (material_id) REFERENCES public.material(material_id);


--
-- TOC entry 3757 (class 2606 OID 35140)
-- Name: UnknownDetectionResults ms2det_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."UnknownDetectionResults"
  --  ADD CONSTRAINT ms2det_id FOREIGN KEY (ms2det_id) REFERENCES public."UnknownMS2Dets"(id);


--
-- TOC entry 3758 (class 2606 OID 35152)
-- Name: UnknownComparisonMisc ms2mstid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

--ALTER TABLE ONLY public."UnknownComparisonMisc"
  --  ADD CONSTRAINT ms2mstid FOREIGN KEY (ms2mst_id) REFERENCES public."UnknownMS2Mst"(id);


--
-- TOC entry 3655 (class 2606 OID 33412)
-- Name: ontology_annotation ontology_annotation_term_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ontology_annotation
    ADD CONSTRAINT ontology_annotation_term_source_id_fkey FOREIGN KEY (term_source_id) REFERENCES public.ontology_source(ontology_source_id);


--
-- TOC entry 3669 (class 2606 OID 33538)
-- Name: parameter parameter_ontology_annotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parameter
    ADD CONSTRAINT parameter_ontology_annotation_id_fkey FOREIGN KEY (ontology_annotation_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3719 (class 2606 OID 33961)
-- Name: parameter_value parameter_value_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parameter_value
    ADD CONSTRAINT parameter_value_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.parameter(parameter_id);


--
-- TOC entry 3718 (class 2606 OID 33956)
-- Name: parameter_value parameter_value_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parameter_value
    ADD CONSTRAINT parameter_value_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3717 (class 2606 OID 33951)
-- Name: parameter_value parameter_value_value_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parameter_value
    ADD CONSTRAINT parameter_value_value_id_fkey FOREIGN KEY (value_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3670 (class 2606 OID 33552)
-- Name: person person_investigation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_investigation_id_fkey FOREIGN KEY (investigation_id) REFERENCES public.investigation(investigation_id);


--
-- TOC entry 3707 (class 2606 OID 33875)
-- Name: person_roles person_roles_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_roles
    ADD CONSTRAINT person_roles_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(person_id);


--
-- TOC entry 3708 (class 2606 OID 33880)
-- Name: person_roles person_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_roles
    ADD CONSTRAINT person_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3671 (class 2606 OID 33557)
-- Name: person person_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_study_id_fkey FOREIGN KEY (study_id) REFERENCES public.study(study_id);


--
-- TOC entry 3712 (class 2606 OID 33907)
-- Name: process process_assay_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process
    ADD CONSTRAINT process_assay_id_fkey FOREIGN KEY (assay_id) REFERENCES public.assay(assay_id);


--
-- TOC entry 3738 (class 2606 OID 34080)
-- Name: process_inputs process_inputs_input_id__fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_inputs
    ADD CONSTRAINT process_inputs_input_id__fkey FOREIGN KEY (input_id_) REFERENCES public.input_output(id_);


--
-- TOC entry 3739 (class 2606 OID 34085)
-- Name: process_inputs process_inputs_process_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_inputs
    ADD CONSTRAINT process_inputs_process_id_fkey FOREIGN KEY (process_id) REFERENCES public.process(process_id);


--
-- TOC entry 3710 (class 2606 OID 33897)
-- Name: process process_next_process_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process
    ADD CONSTRAINT process_next_process_id_fkey FOREIGN KEY (next_process_id) REFERENCES public.process(process_id);


--
-- TOC entry 3740 (class 2606 OID 34099)
-- Name: process_outputs process_outputs_output_id__fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_outputs
    ADD CONSTRAINT process_outputs_output_id__fkey FOREIGN KEY (output_id_) REFERENCES public.input_output(id_);


--
-- TOC entry 3741 (class 2606 OID 34104)
-- Name: process_outputs process_outputs_process_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_outputs
    ADD CONSTRAINT process_outputs_process_id_fkey FOREIGN KEY (process_id) REFERENCES public.process(process_id);


--
-- TOC entry 3743 (class 2606 OID 34121)
-- Name: process_parameter_values process_parameter_values_parameter_value_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_parameter_values
    ADD CONSTRAINT process_parameter_values_parameter_value_id_fkey FOREIGN KEY (parameter_value_id) REFERENCES public.parameter_value(parameter_value_id);


--
-- TOC entry 3742 (class 2606 OID 34116)
-- Name: process_parameter_values process_parameter_values_process_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process_parameter_values
    ADD CONSTRAINT process_parameter_values_process_id_fkey FOREIGN KEY (process_id) REFERENCES public.process(process_id);


--
-- TOC entry 3709 (class 2606 OID 33892)
-- Name: process process_previous_process_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process
    ADD CONSTRAINT process_previous_process_id_fkey FOREIGN KEY (previous_process_id) REFERENCES public.process(process_id);


--
-- TOC entry 3713 (class 2606 OID 33912)
-- Name: process process_protocol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process
    ADD CONSTRAINT process_protocol_id_fkey FOREIGN KEY (protocol_id) REFERENCES public.protocol(protocol_id);


--
-- TOC entry 3711 (class 2606 OID 33902)
-- Name: process process_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.process
    ADD CONSTRAINT process_study_id_fkey FOREIGN KEY (study_id) REFERENCES public.study(study_id);


--
-- TOC entry 3700 (class 2606 OID 33812)
-- Name: protocol_parameters protocol_parameters_parameter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protocol_parameters
    ADD CONSTRAINT protocol_parameters_parameter_id_fkey FOREIGN KEY (parameter_id) REFERENCES public.parameter(parameter_id);


--
-- TOC entry 3699 (class 2606 OID 33807)
-- Name: protocol_parameters protocol_parameters_protocol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protocol_parameters
    ADD CONSTRAINT protocol_parameters_protocol_id_fkey FOREIGN KEY (protocol_id) REFERENCES public.protocol(protocol_id);


--
-- TOC entry 3672 (class 2606 OID 33569)
-- Name: protocol protocol_protocol_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protocol
    ADD CONSTRAINT protocol_protocol_type_id_fkey FOREIGN KEY (protocol_type_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3668 (class 2606 OID 33526)
-- Name: publication publication_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publication
    ADD CONSTRAINT publication_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3704 (class 2606 OID 33846)
-- Name: sample_characteristics sample_characteristics_characteristic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sample_characteristics
    ADD CONSTRAINT sample_characteristics_characteristic_id_fkey FOREIGN KEY (characteristic_id) REFERENCES public.characteristic(characteristic_id);


--
-- TOC entry 3703 (class 2606 OID 33841)
-- Name: sample_characteristics sample_characteristics_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sample_characteristics
    ADD CONSTRAINT sample_characteristics_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.sample(sample_id);


--
-- TOC entry 3652 (class 2606 OID 33381)
-- Name: sample_derives_from sample_derives_from_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sample_derives_from
    ADD CONSTRAINT sample_derives_from_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.sample(sample_id);


--
-- TOC entry 3653 (class 2606 OID 33386)
-- Name: sample_derives_from sample_derives_from_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sample_derives_from
    ADD CONSTRAINT sample_derives_from_source_id_fkey FOREIGN KEY (source_id) REFERENCES public.source(source_id);


--
-- TOC entry 3737 (class 2606 OID 34068)
-- Name: sample_factor_values sample_factor_values_factor_value_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sample_factor_values
    ADD CONSTRAINT sample_factor_values_factor_value_id_fkey FOREIGN KEY (factor_value_id) REFERENCES public.factor_value(factor_value_id);


--
-- TOC entry 3736 (class 2606 OID 34063)
-- Name: sample_factor_values sample_factor_values_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sample_factor_values
    ADD CONSTRAINT sample_factor_values_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.sample(sample_id);


--
-- TOC entry 3702 (class 2606 OID 33829)
-- Name: source_characteristics source_characteristics_characteristic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.source_characteristics
    ADD CONSTRAINT source_characteristics_characteristic_id_fkey FOREIGN KEY (characteristic_id) REFERENCES public.characteristic(characteristic_id);


--
-- TOC entry 3701 (class 2606 OID 33824)
-- Name: source_characteristics source_characteristics_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.source_characteristics
    ADD CONSTRAINT source_characteristics_source_id_fkey FOREIGN KEY (source_id) REFERENCES public.source(source_id);


--
-- TOC entry 3688 (class 2606 OID 33710)
-- Name: study_assays study_assays_assay_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_assays
    ADD CONSTRAINT study_assays_assay_id_fkey FOREIGN KEY (assay_id) REFERENCES public.assay(assay_id);


--
-- TOC entry 3687 (class 2606 OID 33705)
-- Name: study_assays study_assays_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_assays
    ADD CONSTRAINT study_assays_study_id_fkey FOREIGN KEY (study_id) REFERENCES public.study(study_id);


--
-- TOC entry 3665 (class 2606 OID 33497)
-- Name: study_characteristic_categories study_characteristic_categories_ontology_annotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_characteristic_categories
    ADD CONSTRAINT study_characteristic_categories_ontology_annotation_id_fkey FOREIGN KEY (ontology_annotation_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3664 (class 2606 OID 33492)
-- Name: study_characteristic_categories study_characteristic_categories_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_characteristic_categories
    ADD CONSTRAINT study_characteristic_categories_study_id_fkey FOREIGN KEY (study_id) REFERENCES public.study(study_id);


--
-- TOC entry 3657 (class 2606 OID 33429)
-- Name: study_design_descriptors study_design_descriptors_ontology_annotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_design_descriptors
    ADD CONSTRAINT study_design_descriptors_ontology_annotation_id_fkey FOREIGN KEY (ontology_annotation_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3656 (class 2606 OID 33424)
-- Name: study_design_descriptors study_design_descriptors_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_design_descriptors
    ADD CONSTRAINT study_design_descriptors_study_id_fkey FOREIGN KEY (study_id) REFERENCES public.study(study_id);


--
-- TOC entry 3686 (class 2606 OID 33695)
-- Name: study_factors study_factors_factor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_factors
    ADD CONSTRAINT study_factors_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES public.factor(factor_id);


--
-- TOC entry 3685 (class 2606 OID 33690)
-- Name: study_factors study_factors_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_factors
    ADD CONSTRAINT study_factors_study_id_fkey FOREIGN KEY (study_id) REFERENCES public.study(study_id);


--
-- TOC entry 3654 (class 2606 OID 33400)
-- Name: study study_investigation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study
    ADD CONSTRAINT study_investigation_id_fkey FOREIGN KEY (investigation_id) REFERENCES public.investigation(investigation_id);


--
-- TOC entry 3663 (class 2606 OID 33480)
-- Name: study_materials study_materials_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_materials
    ADD CONSTRAINT study_materials_material_id_fkey FOREIGN KEY (material_id) REFERENCES public.material(material_id);


--
-- TOC entry 3662 (class 2606 OID 33475)
-- Name: study_materials study_materials_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_materials
    ADD CONSTRAINT study_materials_study_id_fkey FOREIGN KEY (study_id) REFERENCES public.study(study_id);


--
-- TOC entry 3684 (class 2606 OID 33678)
-- Name: study_protocols study_protocols_protocol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_protocols
    ADD CONSTRAINT study_protocols_protocol_id_fkey FOREIGN KEY (protocol_id) REFERENCES public.protocol(protocol_id);


--
-- TOC entry 3683 (class 2606 OID 33673)
-- Name: study_protocols study_protocols_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_protocols
    ADD CONSTRAINT study_protocols_study_id_fkey FOREIGN KEY (study_id) REFERENCES public.study(study_id);


--
-- TOC entry 3682 (class 2606 OID 33661)
-- Name: study_publications study_publications_publication_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_publications
    ADD CONSTRAINT study_publications_publication_id_fkey FOREIGN KEY (publication_id) REFERENCES public.publication(publication_id);


--
-- TOC entry 3681 (class 2606 OID 33656)
-- Name: study_publications study_publications_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_publications
    ADD CONSTRAINT study_publications_study_id_fkey FOREIGN KEY (study_id) REFERENCES public.study(study_id);


--
-- TOC entry 3661 (class 2606 OID 33463)
-- Name: study_samples study_samples_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_samples
    ADD CONSTRAINT study_samples_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.sample(sample_id);


--
-- TOC entry 3660 (class 2606 OID 33458)
-- Name: study_samples study_samples_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_samples
    ADD CONSTRAINT study_samples_study_id_fkey FOREIGN KEY (study_id) REFERENCES public.study(study_id);


--
-- TOC entry 3659 (class 2606 OID 33446)
-- Name: study_sources study_sources_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_sources
    ADD CONSTRAINT study_sources_source_id_fkey FOREIGN KEY (source_id) REFERENCES public.source(source_id);


--
-- TOC entry 3658 (class 2606 OID 33441)
-- Name: study_sources study_sources_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_sources
    ADD CONSTRAINT study_sources_study_id_fkey FOREIGN KEY (study_id) REFERENCES public.study(study_id);


--
-- TOC entry 3667 (class 2606 OID 33514)
-- Name: study_unit_categories study_unit_categories_ontology_annotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_unit_categories
    ADD CONSTRAINT study_unit_categories_ontology_annotation_id_fkey FOREIGN KEY (ontology_annotation_id) REFERENCES public.ontology_annotation(ontology_annotation_id);


--
-- TOC entry 3666 (class 2606 OID 33509)
-- Name: study_unit_categories study_unit_categories_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_unit_categories
    ADD CONSTRAINT study_unit_categories_study_id_fkey FOREIGN KEY (study_id) REFERENCES public.study(study_id);


ALTER TABLE ONLY public.sample
    ADD CONSTRAINT id UNIQUE (id) INCLUDE (id);


ALTER TABLE ONLY public."PeakTableMerge"
    ADD CONSTRAINT assay_id FOREIGN KEY (assay_id) REFERENCES public.assay(assay_id) NOT VALID;


ALTER TABLE ONLY public."PeakTableMerge"
    ADD CONSTRAINT compound_id FOREIGN KEY (compound_id) REFERENCES public."Compound"(id) NOT VALID;

ALTER TABLE ONLY public."PeakTableMerge"
    ADD CONSTRAINT sample_id FOREIGN KEY (sample_id) REFERENCES public.sample(id) NOT VALID;




insert into "Configs" (name, type, config, active, created_by) values('default', 'DEFAULT', '{"matching_peaks":"1", "matching_score":"0.75", "pep_mass_tolerance":[-1,1]}', true,1) ;

insert into "DataSource" (name) values('NA');
insert into "MassSpecType" (name) values('MS/MS') ;
insert into "User" (name, email_id, pwd) values ('Lawrence Egyir', 'lawegyir@yahoo.com', 'biodevs');

INSERT INTO public."Method"(
	 name, method, active)
values('RP',	'RP',	true);

INSERT INTO public."Method"(
	 name, method, active)
values('GC',	'GC',	true);

INSERT INTO public."Method"(
	 name, method, active)
values('LIP',	'LIP',	true);

INSERT INTO public."Method"(
	 name, method, active)
values('HILIC',	'HILIC',	true);
	





COMMIT
