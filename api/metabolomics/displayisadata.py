#from symbol import pass_stmt
import psycopg2
from metabolomics.components.db import close_db_conn, get_db_conn
from flask import render_template , current_app, jsonify
from metabolomics.appbp import app_bp
from metabolomics.components.utilityfns import *

@app_bp.route("/isadata")
@app_bp.route("/isadata/<page>,<count>")
def displayisadata(page=0, count=0, client="external"):
    try:
        conn = None
        conn = get_db_conn()

        curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

        sql = " select  investigation_id, identifier, title, description, submission_date, public_release_date  \
                from \"investigation\" inv   \
                order by investigation_id desc "


        if int(count) > 0:
            sql = sql + " LIMIT %s OFFSET %s   "


        if int(count) == 0:
            curr.execute(sql)    
        else:
            offset = (int(page) - 1) * int(count)
            curr.execute(sql, (int(count), offset))    

        ms2mst = curr.fetchall() 

        sql = "select count(*) as totalRecords from \"investigation\" "
        curr.execute(sql)
        invcount = curr.fetchone() 

        # dets = []
        # curr.execute(sql, (invid,))
        # ms2dets = curr.fetchall()
        # dets.append(ms2dets)
        # #else return JSON for external client
        output = {}
        output["mst"] = ms2mst
        output["invcount"] = invcount 

        # output["dets"] = dets

        return jsonify(output)


    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        if client == "flask":
            raise err
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500


@app_bp.route("/isadata/<invid>, <client>")
def displayinvestigation(invid, client):
    try:
        conn = None
        conn = get_db_conn()

        curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

        sql = " select  investigation_id, identifier, title, description, submission_date, public_release_date  \
                from \"investigation\" inv   where investigation_id = %s"


        curr.execute(sql, (invid,))
        ms2mst = curr.fetchall() 

        sql = " select  study_id   \
                from \"study\" inv   where investigation_id = %s"


        curr.execute(sql, (invid,))
        invstudy = curr.fetchall() 


        # stmt = " select distinct adtf.assay_id, dtf.filename  from assay_data_files adtf "
        # stmt += " join datafile dtf  on  adtf.data_file_id = dtf.datafile_id  "
        # stmt += " join study on study.study_id = adtf.assay_id  "
        # stmt += " join investigation i on i.investigation_id  = study.investigation_id "
        # stmt += " where i.investigation_id = %s and dtf.label  = 'Derived Data File' "

        # stmt = " select distinct adtf.assay_id, dtf.filename  from assay_data_files adtf "
        # stmt += " join datafile dtf  on  adtf.data_file_id = dtf.datafile_id  "
        # stmt += " join study_assays on study_assays.assay_id = adtf.assay_id  "
        # stmt += " join study on study_assays.study_id = study.study_id  "
        # stmt += " join investigation i on i.investigation_id  = study.investigation_id "
        # stmt += " where i.investigation_id = %s and dtf.label  = 'Derived Data File' "


        stmt = " select distinct sample_id from \"PeakTableMerge\"  ptm  "
        stmt += " inner join assay_data_files  adtf "
        stmt += "    on ptm.assay_id =  adtf.assay_id and ptm.data_file_id = adtf.data_file_id " 
        stmt += " join study_assays on study_assays.assay_id = adtf.assay_id  "
        stmt += " join study on study_assays.study_id = study.study_id "
        stmt += " join investigation i on i.investigation_id  = study.investigation_id "
        stmt += " where i.investigation_id = %s "

        curr.execute(stmt, (invid,))
        invresults = curr.fetchall() 


        #fetch publications
        stmt = " select  publication_id "
        stmt += "     from investigation_publications "
        stmt += "      where investigation_id = %s " 
        stmt += " limit 1 "

        curr.execute(stmt, (invid,))
        invpubl = curr.fetchall() 


        #fetch contacts
        stmt = " select  person_id "
        stmt += "     from person  "
        stmt += "      where investigation_id = %s " 
        stmt += " limit 1 "

        curr.execute(stmt, (invid,))
        invcontacts = curr.fetchall() 


        #fetch contacts 



        # dets = []
        # curr.execute(sql, (invid,))
        # ms2dets = curr.fetchall()
        # dets.append(ms2dets)
        # #else return JSON for external client
        output = {}
        output["mst"] = ms2mst
        output["dets"] = invstudy
        output["results"] = invresults 
        output["publications"] = invpubl 
        output["contacts"] = invcontacts
        return jsonify(output)


    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        if client == "flask":
            raise err
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500




@app_bp.route("/isastudy/<studyId>, <client>")
def displaystudy(studyId, client):
    try:
        conn = None
        conn = get_db_conn()

        curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

        sql = " select  study_id, filename, investigation_id, identifier, title, description, submission_date, public_release_date  \
                from \"study\" inv   where study_id = %s"


        curr.execute(sql, (studyId,))
        ms2mst = curr.fetchall() 

        sql = " select assay_id from  \"study_assays\"  where study_id  = %s "
        curr.execute(sql, (studyId,))
        studyassay = curr.fetchall() 


        stmt = " select protocol.name, protocol.description, study_protocols.protocol_id  "
        stmt += "       from study_protocols  "
        stmt += "           inner join protocol on study_protocols.protocol_id = protocol.protocol_id  "
        stmt += "  where study_id = %s "


        curr.execute(stmt, (studyId,))
        protocols = curr.fetchall() 

        #fetch publications
        stmt = " select  publication_id "
        stmt += "     from study_publications "
        stmt += "      where study_id = %s " 
        stmt += " limit 1 "

        curr.execute(stmt, (studyId,))
        publications = curr.fetchall() 


        #fetch contacts
        stmt = " select  person_id "
        stmt += "     from person  "
        stmt += "      where study_id = %s " 
        stmt += " limit 1 "

        curr.execute(stmt, (studyId,))
        contacts = curr.fetchall() 


        # dets = []
        # curr.execute(sql, (invid,))
        # ms2dets = curr.fetchall()
        # dets.append(ms2dets)
        # #else return JSON for external client
        output = {}
        output["mst"] = ms2mst
        output["dets"] = studyassay
        output["protocols"] = protocols 
        output["publications"] = publications
        output["contacts"] = contacts

        return jsonify(output)


    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        if client == "flask":
            raise err
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500


@app_bp.route("/isaassay/<assayId>, <client>")
def displayassay(assayId, client):
    try:
        conn = None
        conn = get_db_conn()

        curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)


        sql = " select assay_id, techtype.annotation_value as technology_type,  \
                measuretype.annotation_value as measurement_type,  \
                assay.filename, technology_platform \
                from  assay  \
                    inner join ontology_annotation as techtype \
                                on assay.technology_type_id = techtype.ontology_annotation_id \
                    inner join ontology_annotation as measuretype \
                                on assay.measurement_type_id = measuretype.ontology_annotation_id \
        where assay_id = %s "


        curr.execute(sql, (assayId,))
        assaydets = curr.fetchall() 

        output = {}
        output["mst"] = assaydets
        # output["dets"] = studyassay

        return jsonify(output)


    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        if client == "flask":
            raise err
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500



@app_bp.route("/isastudyassay/<studyId>, <client>")
def displaystudyassay(studyId, client):
    try:
        conn = None
        conn = get_db_conn()

        curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)


        sql = " select distinct study_assays.assay_id, techtype.annotation_value as technology_type,  \
                measuretype.annotation_value as measurement_type,  \
                assay.filename, technology_platform, datafile.filename  \
                from  study_assays  \
                    inner join assay  \
                            on study_assays.assay_id = assay.assay_id \
                    inner join ontology_annotation as techtype \
                                on assay.technology_type_id = techtype.ontology_annotation_id \
                    inner join ontology_annotation as measuretype \
                                on assay.measurement_type_id = measuretype.ontology_annotation_id \
                    inner join \"PeakTableMerge\"  ptm   on study_assays.assay_id = ptm.assay_id  \
                    inner join datafile on ptm.data_file_id = datafile.datafile_id \
        where study_assays.study_id = %s "


        curr.execute(sql, (studyId,))
        assaydets = curr.fetchall() 



        # stmt = " select distinct sample.name as sample_name,  ptm.sample_id,  filename as datafile "
        # stmt += "   from   study_assays    saa    "
        # stmt += "    inner join \"PeakTableMerge\"  ptm   on saa.assay_id = ptm.assay_id  "
        # stmt += "    inner join sample on ptm.sample_id = sample.id "
        # stmt += "    inner join datafile on ptm.data_file_id = datafile.datafile_id"
        # stmt += " where saa.study_id = %s "


        # curr.execute(stmt, (studyId,))
        # sampleresults  = curr.fetchall() 



        output = {}
        output["mst"] = assaydets
        # output["dets"] = studyassay

        return jsonify(output)


    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        if client == "flask":
            raise err
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500


@app_bp.route("/isasample/<assayid>, <sampleid>, <client>")
def displaysample(assayid, sampleid, client):
    try:

        print(" Sample id" + sampleid)
        conn = None
        conn = get_db_conn()

        curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)


        stmt = " select  id as sample_id, sample.name as sample_name "
        stmt += "   from sample   "
        stmt += " where id = %s "


        curr.execute(stmt, (sampleid,))
        sample  = curr.fetchall() 


        stmt = " select  id, a_sample_id  from \"PeakTableMerge\"  "
        stmt += " where assay_id = %s and sample_id = %s "


        curr.execute(stmt, (assayid, sampleid,))
        sampleresults  = curr.fetchall() 

        output = {}
        output["mst"] = sample
        output["dets"] = sampleresults

        return jsonify(output)


    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        if client == "flask":
            raise err
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500


@app_bp.route("/isasampleresults/<sampleid>, <client>")
def displaysampleresults(sampleid, client):
    try:
        conn = None
        conn = get_db_conn()

        curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)


        stmt = " select distinct sample.name as sample_name,  ptm.sample_id, ptm.assay_id, compound_name, intensity, filename as datafile "
        stmt += "   from \"PeakTableMerge\"  ptm  "
        stmt += "  inner join sample on ptm.sample_id = sample.id "
        stmt += "  inner join datafile on ptm.data_file_id = datafile.datafile_id"
        stmt += " where ptm.sample_id = %s "


        curr.execute(stmt, (sampleid,))
        sampleresults  = curr.fetchall() 

        output = {}
        output["mst"] = sampleresults
        # output["dets"] = studyassay

        return jsonify(output)


    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        if client == "flask":
            raise err
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500


@app_bp.route("/isaontology/<investigationid>, <client>")
def display_ontology_refs(investigationid, client):
    try:
        conn = None
        conn = get_db_conn()

        curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

        stmt = "select inv_onto.ontology_source,  onto.name, onto.file, onto.version, onto.description "
        stmt += "   from   investigation_ontology_source  inv_onto  "
        stmt += "              inner join  "
        stmt += "          ontology_source  onto    "
        stmt += "             on inv_onto.ontology_source = onto.ontology_source_id "
        stmt += "   where  inv_onto.investigation_id = %s"
        stmt += "    order by onto.name "

        curr.execute(stmt, (investigationid, ))
        inv_onto = curr.fetchall()

        output = {}
        output["inv_onto"] = inv_onto


        return jsonify(output)


    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        if client == "flask":
            raise err
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500


@app_bp.route("/assaysamples/<assayid>, <client>")
def get_assay_samples(assayid, client):
    try:
        conn = None
        conn = get_db_conn()

        curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

        stmt = " select distinct ptm.sample_id, sample.name  from \"PeakTableMerge\"  ptm  "
        stmt += " inner join assay_data_files  adtf "
        stmt += "    on ptm.assay_id =  adtf.assay_id and ptm.data_file_id = adtf.data_file_id " 
        stmt += " join sample on sample.id = ptm.sample_id  "
        stmt += " where ptm.assay_id = %s "

        curr.execute(stmt, (assayid,))
        samples = curr.fetchall() 


        output = {}
        output["samples"] = samples


        return jsonify(output)


    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        if client == "flask":
            raise err
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500


@app_bp.route("/studyprotocol/<studyid>, <client>")
def get_study_ptotocols(studyid, client):
    try:
        conn = None
        conn = get_db_conn()

        curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

        stmt = " select protocol.name, protocol.description, study_protocols.protocol_id  "
        stmt += "       from study_protocols  "
        stmt += "           inner join protocol on study_protocols.protocol_id = protocol.protocol_id  "
        stmt += "  where study_id = %s "


        curr.execute(stmt, (studyid,))
        protocols = curr.fetchall() 


        output = {}
        output["protocols"] = protocols


        return jsonify(output)


    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        if client == "flask":
            raise err
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500



@app_bp.route("/invpublications/<invid>, <client>")
def get_inv_publications(invid, client):
    try:
        conn = None
        conn = get_db_conn()

        curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

        #fetch publications
        stmt = " select publ.author_list, doi, pubmed_id, title,   onto.annotation_value "
        stmt += "     from investigation_publications  inv_publ  "
        stmt += "           inner join publication publ   on inv_publ.publication_id = publ.publication_id "
        stmt += "           inner join ontology_annotation onto   on publ.status_id = onto.ontology_annotation_id "
        stmt += "      where inv_publ.investigation_id = %s "

        curr.execute(stmt, (invid,))
        invpubl = curr.fetchall() 


        output = {}
        output["publications"] = invpubl


        return jsonify(output)


    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        if client == "flask":
            raise err
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500


@app_bp.route("/invcontacts/<invid>, <client>")
def get_inv_contacts(invid, client):
    try:
        conn = None
        conn = get_db_conn()

        curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

        #fetch publications
        stmt = " select person.person_id, coalesce(last_name, '') as last_name , coalesce(first_name, '') as  first_name , "
        stmt += " coalesce(mid_initials, '') as mid_initials,  email, phone, fax, address, affiliation, onto.annotation_value  as person_role"
        stmt += "     from person  "
        stmt += "           inner join person_roles role   on person.person_id = role.person_id "
        stmt += "           inner join ontology_annotation onto   on role.role_id = onto.ontology_annotation_id "
        stmt += "      where person.investigation_id = %s "

        curr.execute(stmt, (invid,))
        invpubl = curr.fetchall() 


        output = {}
        output["contacts"] = invpubl


        return jsonify(output)


    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        if client == "flask":
            raise err
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500



@app_bp.route("/studypublications/<invid>, <client>")
def get_study_publications(studyid, client):
    try:
        conn = None
        conn = get_db_conn()

        curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

        #fetch publications
        stmt = " select publ.author_list, doi, pubmed_id, title,   onto.annotation_value "
        stmt += "     from study_publications  study_publ  "
        stmt += "           inner join publication publ   on study_publ.publication_id = publ.publication_id "
        stmt += "           inner join ontology_annotation onto   on publ.status_id = onto.ontology_annotation_id "
        stmt += "      where study_publ.study_id = %s "

        curr.execute(stmt, (studyid,))
        studypubl = curr.fetchall() 


        output = {}
        output["publications"] = studypubl


        return jsonify(output)


    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        if client == "flask":
            raise err
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500




@app_bp.route("/studycontacts/<studyid>, <client>")
def get_study_contacts(studyid, client):
    try:
        conn = None
        conn = get_db_conn()

        curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

        #fetch publications
        stmt = " select person.person_id, coalesce(last_name, '') as last_name , coalesce(first_name, '') as  first_name , "
        stmt += " coalesce(mid_initials, '') as mid_initials,  email, phone, fax, address, affiliation, onto.annotation_value  as person_role"
        stmt += "     from person  "
        stmt += "           inner join person_roles role   on person.person_id = role.person_id "
        stmt += "           inner join ontology_annotation onto   on role.role_id = onto.ontology_annotation_id "
        stmt += "      where person.study_id = %s "

        curr.execute(stmt, (studyid,))
        invpubl = curr.fetchall() 


        output = {}
        output["contacts"] = invpubl


        return jsonify(output)


    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        if client == "flask":
            raise err
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500

