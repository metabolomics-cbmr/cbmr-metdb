import os 
from flask import Flask, request, flash, request, redirect, url_for, current_app, render_template  , jsonify
from flask_restful import Api
from metabolomics.components.saveconfig import *
from metabolomics.appbp import app_bp
from metabolomics.components.utilityfns import *
from metabolomics.my_exceptions import InputError, CustomException 
from metabolomics.components.db import close_db_conn, get_db_conn


@app_bp.route("/compareconfig",  methods=['POST'])
def saveconfig():
    settings_data = request.form 

    try:
        # if isinstance(settings_data["matching_peaks"], int) and isinstance(float(settings_data["matching_score"]), float) and \
        #             isinstance(float(settings_data["pepmass_tolerance_from"]), float) and   \
        #             isinstance(float(settings_data["pepmass_tolerance_to"]), float):

        errmsg = ""

        if settings_data["name"].strip() == "":
            if errmsg != "":
                errmsg = errmsg + "\\n"
            errmsg = "Name cannot be blank"


        if float(settings_data["pepmass_tolerance_from"]) >  float(settings_data["pepmass_tolerance_to"]):
            if errmsg != "":
                errmsg = errmsg + "\\n"
            errmsg = "Precursor Mass tolerance value in incorrect: From value must be less than or equal to To value"

        if float(settings_data["matching_score"]) > 1:
            if errmsg != "":
                errmsg = errmsg + "\\n"
            errmsg = "Matching score must be less than or equal to 1 "

        if int(settings_data["matching_peaks"]) <= 0:
            if errmsg != "":
                errmsg = errmsg + "\\n"
            errmsg = "Matching Peaks setting must be greater than 0"

        if errmsg != "":
            raise InputError("Errors found in settings \n" + errmsg )
        # else:
        #     raise InputError("Configuration for comparison must be numbers")
    
        configid = save_config(settings_data)

        output = {}
        output["configid"] =  configid
        output["description"] = "Save successful"
        return jsonify(output), 200

   
    except InputError as err:
        # if from_client == "flask":
        #     raise err

        e_dict = err.get_error_dict()
        return jsonify(e_dict), 400


    except (Exception, InputError, psycopg2.DatabaseError) as err:
        httpcode = 500
        e_dict = {}
        if err is InputError or  err is CustomException:
            e_dict = err.get_error_dict()
            if err is InputError:
                httpcode = 400 
            else:
                httpcode = 500 
        else:
            httpcode = 500 
            e_dict = get_unhandled_exception_details()
    
        return jsonify(e_dict), httpcode

@app_bp.route("/compareconfig",  methods=['GET'])
@app_bp.route("/compareconfig/<id>",  methods=['GET'])
def getconfig(id=0):

    conn = None
    current_app.logger.info('in GET  %s', type(id))
    i_id = int(id)

    if   i_id < 0:
        raise CustomException("Id parameter must be a greater than 0")

    try:
        conn = get_db_conn()
        cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

        qry = " select * from \"Configs\" where active = true  "
        if i_id > 0:
            qry = qry + " where id = %s"
            cur.execute(qry, (i_id,))
        else:
            cur.execute(qry)

        data = cur.fetchall()
        cur.close()
        close_db_conn(conn)


        return jsonify(data), 200

    except (Exception, CustomException, psycopg2.DatabaseError) as err:
        e_dict = {}
        httpcode = 500
        if err is CustomException:
            e_dict = err.get_error_dict()
        else:
            e_dict = get_unhandled_exception_details()
        
        return jsonify(e_dict), httpcode 

@app_bp.route("/compareconfig/<id>",  methods=['DELETE'])
def deleteconfig(id):
    conn = None
    i_id = int(id)

    if   i_id < 0:
        raise CustomException("Id parameter must be a greater than 0")

    try:
        conn = get_db_conn()
        cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

        qry = " select id from  \"Configs\"  where id = %s "
        cur.execute(qry, (i_id,))

        if cur.rowcount == 0:
            raise InputError("Configuration not found")

        qry = " update \"Configs\" set active = false where id = %s "
        cur.execute(qry, (i_id,))

        conn.commit()

        cur.close()
        close_db_conn(conn)
        
        dict = {}
        dict["message"] = "Configuration disabled"

        return jsonify(dict), 200

    except (Exception, CustomException, psycopg2.DatabaseError) as err:
        e_dict = {}
        httpcode = 500
        if err is CustomException:
            e_dict = err.get_error_dict()
        else:
            e_dict = get_unhandled_exception_details()
        
        return jsonify(e_dict), httpcode 

