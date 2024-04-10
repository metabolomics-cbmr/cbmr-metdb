#from symbol import pass_stmt
import psycopg2
from metabolomics.components.db import close_db_conn, get_db_conn
from flask import render_template , current_app, jsonify
from metabolomics.appbp import app_bp
from metabolomics.components.utilityfns import *

@app_bp.route("/ms2list/<mstid>, <client>")
def displayms2list(mstid, client):
    try:
        conn = None
        conn = get_db_conn()

        curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

        sql = " select  sc.id, ds.name data_source_name, sc.predicted_experimental, \
                mst.name mass_spectype_name, \
				sc.file_name, sc.import_date  \
                from \"MS2Mst\" sc   \
                    inner join \"DataSource\" ds on sc.data_source_id = ds.id  \
                    inner join \"MassSpecType\" mst on sc.mass_spec_type_id = mst.id \
                  where sc.id = %s "

        curr.execute(sql, (mstid,))
        ms2mst = curr.fetchone() 

        #current_app.logger.info('%s scanmst is  ', scanmst)
        sql = "select ms2dets.id, spec_scan_num, retention_time_secs, cm.name compound_name, collision_energy  \
            from   \"MS2Dets\" ms2dets \
                    inner join \"Compound\"  cm  on ms2dets.compound_id = cm.id  \
                where ms2mst_id = %s "

        # sql = "select id, spec_scan_num, ms_level, retention_time_secs, centroided, polarity, \
        #         prec_scan_num, precursor_mass, precursor_intensity, precursor_charge, collision_energy, from_file, \
        #         original_peaks_count, total_ion_current, base_peak_mz, base_peak_intensity, ionisation_energy, \
        #         low_mz, high_mz, injection_time_secs, peak_index, peak_id, scan_index, spectrum_id  \
        #     from   \"MS2DetsImportLog\" where ms2mst_id = %s "

        dets = []
        curr.execute(sql, (mstid,))
        ms2dets = curr.fetchall()
        dets.append(ms2dets)
        #else return JSON for external client
        output = {}
        output["mst"] = ms2mst
        output["dets"] = dets

        return jsonify(output)


    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        if client == "flask":
            raise err
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500



@app_bp.route("/ms2dets/<detid>, <client>")
def displayms2dets(detid, client):
    try:
        conn = None
        conn = get_db_conn()

        curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

        #current_app.logger.info('%s scanmst is  ', scanmst)
        sql = "select ms2dets.id, spec_scan_num, ms_level, retention_time_secs, centroided, polarity, \
                prec_scan_num, precursor_mass, precursor_intensity, precursor_charge, collision_energy, from_file, \
                original_peaks_count, total_ion_current, base_peak_mz, base_peak_intensity, ionisation_energy, \
                low_mz, high_mz, injection_time_secs, peak_index, peak_id, scan_index, spectrum_id, cm.name compound_name  \
            from   \"MS2Dets\" ms2dets \
                    inner join \"Compound\"  cm  on ms2dets.compound_id = cm.id  \
                where ms2dets.id = %s "

        # sql = "select id, spec_scan_num, ms_level, retention_time_secs, centroided, polarity, \
        #         prec_scan_num, precursor_mass, precursor_intensity, precursor_charge, collision_energy, from_file, \
        #         original_peaks_count, total_ion_current, base_peak_mz, base_peak_intensity, ionisation_energy, \
        #         low_mz, high_mz, injection_time_secs, peak_index, peak_id, scan_index, spectrum_id  \
        #     from   \"MS2DetsImportLog\" where ms2mst_id = %s "

        dets = []
        curr.execute(sql, (detid,))
        ms2dets = curr.fetchall()
        #for detrow in ms2dets:
        det = {}
        det["det"]  = ms2dets            
        spec_det_id = ms2dets[0]["id"]

        sql = " select id,  mz, intensity from   \"MS2Peak\" where ms2_det_id = %s "
        curr.execute(sql,(spec_det_id,))
        peakdet = curr.fetchall()
        det["peaks"] = peakdet 

        #current_app.logger.info('%s scanmst is  ', peakdet)        
        dets.append(det)

        # if client =="flask":
        #     return render_template('ms2data.html', mst=scanmst, det=scandet, peak=peakdet)

        #else return JSON for external client
        output = {}
        output["dets"] = dets


        return jsonify(output)


    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        if client == "flask":
            raise err
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500

        #return jsonify("{code:500, description:" + str(err) + "}"), 500 



