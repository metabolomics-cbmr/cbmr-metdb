import os
import psycopg2
from metabolomics.components.db import close_db_conn, get_db_conn
from flask import render_template , current_app, url_for, jsonify 
from metabolomics.appbp import app_bp
from metabolomics.my_exceptions import InputError, CustomException
from metabolomics.components.utilityfns import * 


@app_bp.route("/resultslog/<client>")
@app_bp.route("/resultslog/<client>,<id>")
@app_bp.route("/resultslog/<client>,<id>,<page>,<count>")
def get_results( client, id=0, page=0, count=0):
    try:
        conn = None 
        # if not page.isnumeric() or not count.isnumeric() or not id.isnumeric() :
        #     raise Exception("Incorrect parameter values")

        offset = (int(page) - 1) * int(count )
        qry = "select import_date, file_name, ums2.id, file_format, tmethod.method  from \"UnknownMS2Mst\"  ums2 "
        qry += "  inner join \"Method\"  tmethod on  ums2.method_id = tmethod.id "

        if int(id) > 0:
            qry  = qry + " where ums2.id = %s "
        
        qry = qry + " order by import_date desc "

        if int(count) > 0:
            qry = qry  + " limit %s offset %s "

        current_app.logger.info(' Query %s ', qry)

        conn = get_db_conn()
        cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

        if int(id) > 0:
            if int(count) > 0:
                cur.execute(qry, (id, count, offset))   
            else:
                cur.execute(qry, (id,))   
        else:
            if int(count) > 0:
                cur.execute(qry, (count, offset))   
            else:
                cur.execute(qry)   

        data = cur.fetchall()
        cur.close()
        close_db_conn(conn)

        if client == "flask":
            return render_template('comparison_log.html', resultlog=data)


        return jsonify(data),200        

    except InputError as err:
        if client == "flask":
            raise err

        e_dict = err.get_error_dict()
        return jsonify(e_dict), 400 

        #return jsonify("{code:400, description:" + str(err) + "}"), 400

    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        if client == "flask":
            raise err
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500

        #return jsonify("{code:500, description:" + str(err) + "}"), 500


@app_bp.route("/displayresults/<id>, <client>, <show_only_above_threshold>")
def display_results(id, client, show_only_above_threshold="N", raw=False):
    try:
        conn = None 
        output = [] 
        conn = get_db_conn()

        #access cursor columns by colunms names and not indexes
        cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
        qry = " select * from \"UnknownComparisonMisc\" ucm   \
                    where ms2mst_id = %s "
        cur.execute(qry, (id,))
        settings_data = cur.fetchall()

        if len(settings_data) == 0:
            raise CustomException("Misc data for Unknown comparison not found")


        settings = {}
        settings["matching_score"] = {"threshold":settings_data[0]["matching_score_threshold"], "description":"Matching score threshold"}
        settings["matching_peaks"] = {"threshold":settings_data[0]["matching_peak_threshold"], "description":"Minimum number of matching peaks"}
        settings["pepmass_tolerance"] = {"threshold":str(settings_data[0]["pep_mass_tolerance_from"])  + " to " + \
                            str(settings_data[0]["pep_mass_tolerance_to"]) , \
                            "description":"Precursor mass tolerance for selecting reference compounds"}

        summary = {}
        summary = {"unique_compounds_compared":settings_data[0]["num_unique_compounds"], \
             "matches_over_threhold":settings_data[0]["num_rows_over_threshold"], \
             "total_ms2_rows_compared":settings_data[0]["num_rows_processed"]}

        upload_data_added = False 
        uploaddatadets = {}

        qry = " select udr.id, udr.ms2det_id, udr.ref_compound_id, udr.ref_retention_time, udr.ref_collision_energy, \
                    udr.matching_peaks, udr.score, udr.ref_precursor_mass, udr.qry_compound_id, \
                    udr.qry_retention_time, udr.qry_collision_energy, udr.qry_precursor_mass, \
                    udr.match_method, udr.ref_scan_number, udr.qry_scan_number, udr.instrument_used, \
                    udr.ref_qry_mz_plot_url, udr.ref_structure_url, \
                    cm.smiles, cm.name as compound_name, cm.smiles, m2m.file_name, m2m.num_spectra_in_file, \
                    udr.over_threshold      \
                from \"UnknownDetectionResults\" udr \
                    join \"UnknownMS2Dets\" um2dt \
                            on um2dt.id = udr.ms2det_id  \
                    join \"UnknownMS2Mst\" m2m \
                         on um2dt.ms2mst_id = m2m.id  \
                    join \"Compound\" cm \
                        on udr.ref_compound_id = cm.id \
                where m2m.id  = %s  order by udr.score desc "

        cur.execute(qry, (id,))

        
        ms2detrows = cur.fetchall()
        for ms2detrow in ms2detrows:
            
            if upload_data_added == False:
                uploaddatadets["file_name"] = ms2detrow["file_name"]
                uploaddatadets["num_spectra_in_file"] = ms2detrow["num_spectra_in_file"]
                upload_data_added = True

            # if user wants to see spectra that matches thresholds
            if show_only_above_threshold == "Y":
                if not (int(ms2detrow["matching_peaks"]) >= int(settings_data[0]["matching_peak_threshold"]) and \
                        float(ms2detrow["score"]) >=   settings_data[0]["matching_score_threshold"]):                      
                    continue 

            output_ele = {}

            output_ele["reference"] =  {"name":ms2detrow["compound_name"],  \
                                            "scan_number":ms2detrow["ref_scan_number"],  \
                                            "collision_energy":ms2detrow["ref_collision_energy"], \
                                            "retention_time":ms2detrow["ref_retention_time"], \
                                            "precursor_mass":ms2detrow["ref_precursor_mass"], 
                                            "smiles":ms2detrow["smiles"]}

            output_ele["query"] =  {"name":"",  "scan_number":ms2detrow["qry_scan_number"],  \
                                            "collision_energy":ms2detrow["qry_collision_energy"], \
                                            "retention_time":ms2detrow["qry_retention_time"], \
                                            "precursor_mass":ms2detrow["qry_precursor_mass"], 
                                            "smiles":""}


            output_ele["result"] = {"match_method":ms2detrow["match_method"], "num_matching_peaks":ms2detrow["matching_peaks"], "score":ms2detrow["score"], "over_threshold":ms2detrow["over_threshold"]}
            output_ele["image"] = {"mz_intensity":ms2detrow["ref_qry_mz_plot_url"], "molecular_structure":ms2detrow["ref_structure_url"]}

            outputdict = {}
            outputdict["data"] = output_ele 

            output.append(outputdict)
            close_db_conn(conn)

        

        if client == "flask":
            return render_template('detectionresults.html', results=output, settings=settings, summary=summary)

        results = {}
        results["uploaddata"] = uploaddatadets
        results["settings"] = settings
        results["summary"] = summary 
        results["output"] = output 

        # raw ==True added to call the method from another program. So the output becomes a dict instead of a response object 
        if raw == True:
            return results


        return jsonify(results)

    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        if client == "flask":
            raise err
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500


