#from symbol import pass_stmt
import psycopg2
import psycopg2.extras
from metabolomics.components.db import close_db_conn, get_db_conn
from flask import render_template , current_app, jsonify
from metabolomics.appbp import app_bp
from metabolomics.components.utilityfns import *

@app_bp.route("/displayms1/<id>, <client>")
def displayms1(id, client):
    try:
        conn = get_db_conn()

        #curr = conn.cursor()
        curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

        sql = " select id, file_name, import_date \
                 from \"MS1Mst\"  \
                  where id = %s "

        curr.execute(sql, (id,))
        mst = curr.fetchone() 

        sql = " select cm.name compound_name,  cm.mass_spec_polarity, ms1.library_rt_rf1, ms1.library_rt_hillic1, \
                    ms1.library_mz, ms1.measured_mz, cm.molecular_formula, \
                    ms1.mass_diff_ppm, ms1.mass_diff, ms1.ion, ms1.peak_note, ms1.ms2_available, \
                    library_name, project_name, data_file_name, library_rt_rf_updated, \
                    cm.mono_molecule_mass, ms1.mass_diff_ppm, ms1.spectra_confirmation, ms1.remarks,  \
                    cm.kegg_id_csid, cm.cas_id, cm.hmdb_ymdb_id, cm.metlin_id, cm.pubchem_id, cm.pubchem_sid, \
                    cm.pubchem_url, cm.chebi, \
                    cm.supplier_cat_no, cm.smiles, cm.supplier_product_name, \
                    cm.class_chemical_taxonomy, cm.subclass_chemical_taxonomy, \
                    cm.biospecimen_locations, cm.tissue_locations, \
                    cm.has_adduct_h, cm.has_adduct_na, cm.has_adduct_k, cm.has_adduct_fa, \
                    cm.has_fragment_loss_h2o, cm.has_fragment_loss_hcooh, cm.has_fragment_loss_fa, \
                    extra_pc_cid, canonical_smiles \
                 from \"MS1Dets\" ms1   \
                    inner join \"Compound\"  cm  on ms1.compound_id = cm.id  \
                  where ms1.ms1_mst_id = %s  \
                    order by mass_spec_polarity, compound_name, ion  "


        curr.execute(sql, (id,))
        det = curr.fetchall() 

        #current_app.logger.info(' Type of det %s ', det)
        if client =="flask":
            return render_template('ms1data.html', mst=mst, det=det)

        output = {}
        output["mst"] = mst
        output["det"] = det

        return jsonify(output),200

    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        if client == "flask":
            raise err
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500
        
        #return jsonify("{code:500, description:" + str(err) + "}"), 500 


